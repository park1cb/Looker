view: active_users {
  derived_table: {
    sql: select users.id,users.joined_at,amp.event_type,amp.event_time,amp.base_date

            from hive.dw.dw_amplitude amp

            join mysql.gatsby.users users
            on users.id=amp.user_id
            where base_date>=date '2019-07-01'
             ;;
  }

  suggestions: no

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: joined_at {
    type: time
    timeframes: [
      raw,
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
    sql: ${TABLE}.joined_at ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension_group: event_time {
    type: time
    timeframes: [
      raw,
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
    sql: ${TABLE}.event_time ;;
  }

  dimension_group: base {
    type: time
    timeframes: [
      raw,
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
    sql: ${TABLE}.base_date ;;
  }

  dimension_group: cohort {
    type: duration
    intervals: [day]
    sql_start: ${joined_at_raw} ;;
    sql_end: ${event_time_raw} ;;
  }
  measure: count {
    type: count_distinct
    sql: ${id} ;;
  }

}
