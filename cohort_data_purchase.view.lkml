view: cohort_data_purchase {
  derived_table: {
    sql: select
      adjust_id,
      platform,
      user_id,
      cast(installed_at + interval '5' hour as date) as installed_at,
      cohort,
      network,
      sum(amount)/3 as episode_purchase

      from ${cohort_data_purchase_raw_data.SQL_TABLE_NAME} a
      where   {% if story_id._in_query %}
              story_id = {% parameter story_id %}
              {% else %} {% endif %}
      group by 1,2,3,4,5,6
 ;;
  }

  parameter: story_id {
    type: number
  }

  dimension: adjust_id {
    type: string
    sql: ${TABLE}.adjust_id ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: installed_at {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day,
      day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.installed_at ;;
  }



  dimension: cohort {
    type: number
    sql: ${TABLE}.cohort ;;
  }

  dimension: network {
    type: string
    sql: ${TABLE}.network ;;
  }

  dimension: episode_purchase {
    type: number
    sql: ${TABLE}.episode_purchase ;;
  }



  measure: avg_episode_purchase {
    type: average
    sql: ${episode_purchase} ;;
    value_format_name: decimal_2
  }

  measure: median_episode_purchase {
    type: median
    sql: ${episode_purchase} ;;
    value_format_name: decimal_2
  }


}
