view: first_story_read_within_24_hours {
  derived_table: {
    sql: select user_id,users.joined_at,epi.created_at
      from mysql.gatsby.users users

      join mysql.gatsby.episode_bookmarks epi
      on epi.user_id=users.id


      where date_diff('hour',users.joined_at,epi.created_at)<=24
       ;;
  }

  suggestions: no


  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
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

  dimension_group: created_at {
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
    sql: ${TABLE}.created_at ;;
  }


  measure: dist_users{
    type: count_distinct
    sql: ${user_id} ;;
  }

  dimension_group: cohort {
    type: duration
    intervals: [hour]
    sql_start: ${joined_at_raw} ;;
    sql_end: ${created_at_raw} ;;
  }


}
