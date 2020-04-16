view: user_story_retention_raw_data {
  derived_table: {
    sql: select distinct cast(u.joined_dt + interval '5' hour as date) as joined_at_est,cast(base_dt + interval '5' hour as date) as base_date_est,bookmark.user_id,bookmark.story_id,epi."no",min("no") over (partition by bookmark.user_id,bookmark.story_id order by epi."no") as min_episode
      from hive.dw.dw_bookmark bookmark
      join mysql.gatsby.episodes epi
      on bookmark.episode_id=epi.id

      join mysql.gatsby.users u
      on u.id=bookmark.user_id

      where bookmark.base_date>=date_add('month',-6,now())
       ;;
    sql_trigger_value: select date_trunc('hour',now());;
  }

  suggestions: no



  dimension: base_date_est {
    type: date
    sql: ${TABLE}.base_date_est ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: no_ {
    type: number
    sql: ${TABLE}.no ;;
  }

  dimension: min_episode {
    type: number
    sql: ${TABLE}.min_episode ;;
  }


}
