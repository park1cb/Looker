view: dw_braze_users_canvas_entry {
  sql_table_name: hive.dw.dw_braze_users_canvas_entry ;;
  drill_fields: [id]
  suggestions: no

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension_group: base {
    type: time
    timeframes: [
      raw,
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

  dimension_group: base_dt {
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
    sql: ${TABLE}.base_dt ;;
  }

  dimension: canvas_id {
    type: string
    sql: ${TABLE}.canvas_id ;;
  }

  dimension: canvas_name {
    type: string
    sql: ${TABLE}.canvas_name ;;
  }

  dimension: canvas_step_id {
    type: string
    sql: ${TABLE}.canvas_step_id ;;
  }

  dimension: canvas_variation_id {
    type: string
    sql: ${TABLE}.canvas_variation_id ;;
  }

  dimension: external_user_id {
    type: number
    sql: ${TABLE}.external_user_id ;;
  }

  dimension: in_control_group {
    type: string
    sql: ${TABLE}.in_control_group ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, canvas_name]
  }
}
