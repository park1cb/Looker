view: cohort_analysis {
  derived_table: {
    sql:
    select
      user_id,
      cohort,
      network,
      used_date,
      sum(coin_amount) over (partition by row(user_id) order by cohort rows unbounded preceding) cumulative_coin_amount,
      sum(episode_count) over (partition by row(user_id) order by cohort rows unbounded preceding) cumulative_episode_count
    from (
      select
        user_id,
        cohort,
        network,
        cast(used_at at time zone '-05:00' as date) used_date,
        sum(amount) as coin_amount,
        count(episode_id) as episode_count
        from (
          select *
          from (
              select cud.user_id,
                  iaa.installed_at,
                  cud.used_at,
                  cud.amount,
                  cud.story_id,
                  cud.episode_id,
                  date_diff('hour',iaa.installed_at,cud.used_at)/24 as cohort,
                  case when iaa.network in ('Organic','Branch(iOS)','Branch(Android)') then 'Organic' else 'Paid' end as network
              from mart.mart.install_attribution_adjust iaa
              left join mart.mart.coin_used_devices cud on iaa.adjust_id=cud.adjust_id
              where {% condition date_filter %} cud.used_at at time zone '-05:00' {% endcondition %}
              and {% condition date_filter %} iaa.installed_at at time zone '-05:00' {% endcondition %}
              {% if story_id._in_query %}
              and cud.story_id = {% parameter story_id %}
              {% else %} {% endif %}
          )
          where cohort >= 0
          and cohort < 31
        )
        group by 1,2,3,4
      )
    order by 1,2,3,4
      ;;
  }

  filter: date_filter {
    label: "Date Filter"
    type: date
    default_value: "7 days"
  }

  parameter: story_id {
    type: number
  }

  # Define your dimensions and measures here, like this:
  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: cohort {
    type: number
    sql: ${TABLE}.cohort ;;
  }

  dimension: network {
    type: string
    sql: ${TABLE}.string ;;
  }

  dimension_group: used_date {
    type: time
    timeframes: [date, week, month, year]
    datatype: date
    sql: ${TABLE}.used_date ;;
    convert_tz: yes
  }

  dimension: coin_amount {
    type: number
    sql: ${TABLE}.cumulative_coin_amount ;;
  }

  dimension: episode_count {
    type: number
    sql: ${TABLE}.cumulative_episode_count ;;
  }

  # measure
  measure: coin_mean {
    type: number
    sql: avg(${coin_amount}) ;;
    value_format: "0.0"
  }

  measure: coin_median {
    type: median
    sql: ${coin_amount} ;;
    value_format: "0.0"
  }

  measure: episodes_count_mean {
    type: number
    sql: avg(${episode_count}) ;;
    value_format: "0.0"
  }

  measure: episodes_count_median {
    type: median
    sql: ${episode_count} ;;
    value_format: "0.0"
  }

  measure: user_count {
    type: number
    sql: count(distinct ${user_id}) ;;
  }


}
