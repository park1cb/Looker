view: two_plus_story_tracking {
  derived_table: {
    sql: with filter_story as
      (

      select user_id,epi.epi_no,cast((sum(coins)/3) as double)/cast(epi_no as double) as coins
      from ${episode_count_distribution_raw_data.SQL_TABLE_NAME} a
      join
      (
      select story_id,max("no") as epi_no
      from mysql.gatsby.episodes
      group by 1
      )epi
      on epi.story_id=a.story_id
      where a.story_id=8602
      group by 1,2
      having cast((sum(coins)/3) as double)/cast(epi_no as double)>=.5
      )


      select a.user_id,b.title,story_id,sum(coins)/3 as paid_episode_number,total_users

      from ${episode_count_distribution_raw_data.SQL_TABLE_NAME} a
      join mysql.gatsby.stories b
      on b.id=a.story_id

      cross join
      (
      select count(distinct user_id) as total_users
      from filter_story
      )
      where a.user_id in
      (
      select user_id
      from filter_story
      )

      group by 1,2,3,5
      having sum(coins)/3>=20
       ;;
  }

  suggestions: no


  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: paid_episode_number {
    type: number
    sql: ${TABLE}.paid_episode_number ;;
  }

  dimension: total_users {
    type: number
    sql: ${TABLE}.total_users ;;
  }

  measure: dist_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: dist_stories {
    type: count_distinct
    sql: ${story_id} ;;
  }


}
