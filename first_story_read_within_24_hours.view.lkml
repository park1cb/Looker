view: first_story_read_within_24_hours {
  derived_table: {
    sql: select user_id,users.joined_at
      from mysql.gatsby.users users

      join mysql.gatsby.episode_bookmarks epi
      on epi.user_id=users.id

      join mart.mart.kpi_by_day kpi
      on kpi.base_date_est=cast(users.joined_at at time zone '-05:00' as date)
      where joined_at at time zone '-05:00'<=date_add('hour',-24,now())
      group by 1,2
      having  date_diff('hour',users.joined_at,min(epi.created_at))<=24
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
