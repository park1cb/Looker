view: user_episode_read_dt_raw_data {
  derived_table: {
    sql: with mast as
      (
      select story_id,user_id,episode_id,min(base_dt) as episode_read_dt
      from hive.dw.dw_bookmark
      group by 1,2,3
      )
      select a.*,b."no",lag(a.episode_read_dt) over (partition by a.user_id, a.story_id order by "no") as previous_episode_read_dt,b.published_at as episode_published_at
      from mast a
      join mysql.gatsby.episodes b
      on b.id=a.episode_id
       ;;
      sql_trigger_value: select date_trunc('hour',now());;
  }

  suggestions: no

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: episode_number {
    type: number
    sql: ${TABLE}."no" ;;
  }

  dimension: episode_id {
    type: number
    sql: ${TABLE}.episode_id ;;
  }

  dimension_group: episode_read_dt {
    type: time
    sql: ${TABLE}.episode_read_dt ;;
  }



  dimension_group: previous_episode_read_dt {
    type: time
    sql: ${TABLE}.previous_episode_read_dt ;;
  }

  dimension_group: episode_published_at {
    type: time
    sql: ${TABLE}.episode_published_at ;;
  }


}
