view: cohort_analysis {
  derived_table: {
    sql:select user_id, installed_at, used_at, amount, story_id, episode_id, concat('D',cast(cohort_ as varchar)) as cohort, network
        from (
            select cud.user_id,
                iaa.installed_at,
                cud.used_at,
                cud.amount,
                cud.story_id,
                cud.episode_id,
                date_diff('hour',iaa.installed_at,cud.used_at)/24 as cohort_,
                case when iaa.network in ('Organic','Branch(iOS)','Branch(Android)') then 'Organic' else 'Paid' end as network
            from mart.mart.install_attribution_adjust iaa
            left join mart.mart.coin_used_devices cud on iaa.adjust_id=cud.adjust_id
            where {% condition date_filter %} cast(cud.used_at at time zone '-05:00' as date) {% endcondition %}
            and {% condition date_filter %} cast(iaa.installed_at at time zone '-05:00' as date) {% endcondition %}
        )
        where cohort_ >= 0
        and cohort_ < 31
      ;;
  }

  filter: date_filter {
    label: "Date Filter"
    type: date
    default_value: "7 days"
  }

  # Define your dimensions and measures here, like this:
  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: installed_at {
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.installed_at ;;
  }

  dimension_group: used_at {
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.used_at ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: episode_id {
    type: number
    sql: ${TABLE}.episode_id ;;
  }

  dimension: cohort {
    type: string
    sql: ${TABLE}.cohort ;;
  }

  dimension: network {
    type: string
    sql: ${TABLE}.string ;;
  }

  measure: coin_sum {
    type: number
    sql: sum(${amount}) ;;
  }

  measure: coin_mean {
    type: number
    sql: avg(${amount}) ;;
  }

  measure: user_count {
    type: number
    sql: count(distinct ${user_id}) ;;
  }

  measure: episode_count {
    type: number
    sql: count(${episode_id}) ;;
  }
}
