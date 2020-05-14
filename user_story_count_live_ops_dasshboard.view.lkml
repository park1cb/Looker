explore: user_story_count_live_ops_dasshboard {}
view: user_story_count_live_ops_dasshboard {
  derived_table: {
    sql: select b.id as user_id,b.joined_at ,a.base_dt ,a.story_id,a.episode_id,date_diff('hour',joined_at,base_dt)/24 as cohort_days,rank() over (partition by b.id,a.story_id order by base_dt) as episode_count
      from hive.dw.dw_bookmark a

      join mysql.gatsby.users b
      on b.id=a.user_id

      where a.base_dt>=date_add('day',-45,now())
      and b.joined_at>=date_add('day',-45,now())

       ;;
    sql_trigger_value: select date_trunc('day',now());;
  }

  suggestions: no

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: joined_at {
    type: time
    sql: ${TABLE}.joined_at ;;
  }

  dimension_group: base_dt {
    type: time
    sql: ${TABLE}.base_dt ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: episode_id {
    type: number
    sql: ${TABLE}.episode_id ;;
  }

  dimension: cohort_days {
    type: number
    sql: ${TABLE}.cohort_days ;;
  }

  dimension: episode_count {
    type: number
    sql: ${TABLE}.episode_count ;;
  }


}
