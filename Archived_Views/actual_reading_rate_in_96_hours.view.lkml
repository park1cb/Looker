view: actual_reading_rate_in_96_hours {
  derived_table: {
    sql: select user_id,users.joined_at
      from mysql.gatsby.users users

      join mysql.gatsby.episode_bookmarks epi
      on epi.user_id=users.id

      where date_diff('hour',users.joined_at,epi.created_at)<=96

      group by 1,2
      having count(distinct epi.id)>3

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


  measure: dist_users{
    type: count_distinct
    sql: ${user_id} ;;
  }


}
