view: episode_count_distribution {
  derived_table: {
    sql: select *
      from ${episode_count_distribution_raw_data.SQL_TABLE_NAME} a
      where story_id={% parameter story_id %}
 ;;
  }

  suggestions: no

  parameter: story_id {
    type: number
    default_value: "8602"
  }
  dimension_group: created_at {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }



  dimension: days {
    type: number
    sql: ${TABLE}."days" ;;
  }

  dimension: paid_episode_read {
    type: number
    sql: ${TABLE}.coins/3 ;;
  }

  dimension: episode_purchase_tier {
    type: tier
    style: integer
    tiers: [5,10,15,20,25,30,35,40]
    sql: ${paid_episode_read} ;;
  }

  measure: payers {
    type: count_distinct
    sql: ${user_id} ;;
  }


}
