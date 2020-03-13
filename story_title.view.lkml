view: story_title {
  derived_table: {
    sql: select id,title
      from mysql.gatsby.stories
      where id={%parameter id%}
       ;;
  }

  suggestions: no


  parameter: id {
    type: number
    default_value:"8602"
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

}
