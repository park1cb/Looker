view: new_users {
  derived_table: {
    sql: select id,joined_at
      from mysql.gatsby.users users
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

  measure: dist_new_users {
    type: count_distinct
    sql: ${id} ;;
  }


}
