view: story_first_purchase {
  derived_table: {
    sql: select *
        from ${story_first_purchase_raw_data.SQL_TABLE_NAME} a


      where story_id={% parameter story_id %}

 ;;
  }

  suggestions: no

  dimension_group: joined_at {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.joined_at ;;
  }

  parameter: story_id {
    type: number
    default_value: "8602"
  }


  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }



  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: sales_type {
    type: string
    sql: ${TABLE}.sales_type ;;
  }

  dimension: purchased {
    type: yesno
    sql: ${sales_type}='one-time' or ${sales_type}='subscription' ;;
  }


  dimension_group: purchased_at {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year  ]
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.purchased_at ;;
  }

  dimension_group: diff {
    type: duration
    intervals: [second,minute,hour,day]
    sql_start: ${joined_at_raw} ;;
    sql_end: ${purchased_at_raw} ;;
  }

  measure: avg_diff{
    type: average
    sql: ${minutes_diff} ;;
  }

  measure: median_diff {
    type: median
    sql: ${minutes_diff} ;;
  }

  measure: payers {
    type: count_distinct
    sql: ${user_id} ;;
  }



}
