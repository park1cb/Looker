view: user_story_retention_raw_data {
  derived_table: {
    sql: select distinct cast(base_dt + interval '5' hour as date) as base_date_est,bookmark.user_id,bookmark.story_id,epi."no",min("no") over (partition by bookmark.user_id,bookmark.story_id order by epi."no") as min_episode
      from hive.dw.dw_bookmark bookmark
      join mysql.gatsby.episodes epi
      on bookmark.episode_id=epi.id

      where bookmark.base_date>=date_add('month',-6,now())
       ;;
    sql_trigger_value: select date_trunc('hour',now());;
  }

  suggestions: no

  measure: count {
    type: count
    drill_fields: [detail*]
  }

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

  set: detail {
    fields: [base_date_est, user_id, story_id, no, min_episode]
  }
}
