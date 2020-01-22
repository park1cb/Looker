view: user_unique_episode_read_date_time_raw_data {
  derived_table: {
    sql: select story_id,user_id,episode_id,min(base_dt) as first_read_date
      from hive.dw.dw_bookmark
      --where story_id=8602
      group by 1,2,3
       ;;
    sql_trigger_value: select date_trunc('hour',now());;
  }

  suggestions: no

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: episode_id {
    type: number
    sql: ${TABLE}.episode_id ;;
  }

  dimension_group: first_read_date {
    type: time
    sql: ${TABLE}.first_read_date ;;
  }

  set: detail {
    fields: [story_id, user_id, episode_id, first_read_date_time]
  }
}
