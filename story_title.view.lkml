view: story_title {
  derived_table: {
    sql: select id,title
      from mysql.gatsby.stories
        ;;
  }

  suggestions: no


  dimension:: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

}
