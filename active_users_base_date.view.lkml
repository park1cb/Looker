view: active_users_base_date {
  derived_table: {
    sql: select distinct user_id,base_date
      from ${dw_amplitude_early_funnel_raw.SQL_TABLE_NAME}
       ;;
    sql_trigger_value: select date_trunc('day',now());;
  }

  suggestions: no



  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: base_date {
    type: date
    sql: ${TABLE}.base_date ;;
  }

}
