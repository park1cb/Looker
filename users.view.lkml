view: users {
  sql_table_name: mysql.gatsby.users ;;
  suggestions: no

  dimension: id {
    primary_key: yes
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

  measure: joined_users {
    type: count
    sql: ${id} ;;
  }

}
