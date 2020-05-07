explore: publisher_upload_date {}
view: publisher_upload_date {
  derived_table: {
    sql: select a.username,b.writer_id,b.title,date(min(c.published_at at time zone '-05:00')) as story_published_at

      from mysql.gatsby.users a

      join mysql.gatsby.stories b
      on a.id=b.writer_id
      join mysql.gatsby.episodes c
      on b.id=c.story_id

      --where b.writer_id=480324

      group by 1,2,3
      order by 1,4 desc
       ;;
  }

  suggestions: no



  dimension: username {
    type: string
    sql: ${TABLE}.username ;;
  }

  dimension: writer_id {
    type: number
    sql: ${TABLE}.writer_id ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension_group: story_published_at {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.story_published_at ;;
  }


}
