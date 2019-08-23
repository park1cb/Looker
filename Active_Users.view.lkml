view: active_users {
  derived_table: {
    sql: select users.id,users.joined_at,amp.event_type,amp.event_time,amp.base_date,base_dt

            from hive.dw.dw_amplitude amp

            join mysql.gatsby.users users
            on users.id=amp.user_id

            where base_date>= date '2019-07-01'

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

  dimension_group: base_dt {
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
    sql: ${TABLE}.base_dt ;;
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

  dimension: base_date {
    type: date
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
