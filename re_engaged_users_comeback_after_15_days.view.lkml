view: re_engaged_users_comeback_after_15_days {
  derived_table: {
    sql: with mast as
      (
      select *
      ,date_diff('day',lag(base_date) over (partition by user_id order by base_date asc),base_date ) as date_diff
      --,lag(base_date) over (partition by user_id order by base_date desc) as next_base_date
      from ${active_users_base_date.SQL_TABLE_NAME}
      )

      select *
      from mast
      where date_diff>=15
       ;;
  }

  suggestions: no



  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: base_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.base_date ;;
  }

  dimension: date_diff {
    type: number
    sql: ${TABLE}.date_diff ;;
  }

  measure: user_count {
    type: count_distinct
    sql: ${user_id} ;;
  }

}
