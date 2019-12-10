view: stories {
  sql_table_name: mysql.gatsby.stories ;;
  drill_fields: [id]
  suggestions: no

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }


}
