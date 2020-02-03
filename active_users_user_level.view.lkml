view: active_users_user_level {
  derived_table: {
    sql: select distinct b.joined_at,a.user_id,date_diff('hour',b.joined_at,a.event_time)/24 as cohort
      from ${dw_amplitude_early_funnel_raw.SQL_TABLE_NAME} a
      join mysql.gatsby.users b
      on b.id=a.user_id
      where a.base_date>=date_add('day',-30,now())
      and date_diff('hour',b.joined_at,a.event_time)/24<=30
      and date_diff('hour',b.joined_at,a.event_time)/24>=0
       ;;
      sql_trigger_value: select date_trunc('day',now());;
  }

  suggestions: no



  dimension_group: joined_at {
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
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.joined_at ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: cohort {
    type: number
    sql: ${TABLE}.cohort ;;
  }

  measure: user_count {
    type: count_distinct
    sql: ${user_id} ;;
  }


}
