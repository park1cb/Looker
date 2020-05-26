explore: user_story_count_live_ops_dasshboard {}
view: user_story_count_live_ops_dasshboard {
  derived_table: {
    sql: select b.id as user_id,b.joined_at ,a.base_dt ,a.story_id,a.episode_id,coalesce(date_diff('hour',joined_at,base_dt)/24,date_diff('hour',joined_at,now())/24) as cohort_days,case when base_dt is null then 0 else rank() over (partition by b.id,a.story_id order by base_dt) end as episode_count
      from mysql.gatsby.users b

      left join hive.dw.dw_bookmark a
      on b.id=a.user_id

      where (
      a.base_dt>=date_add('week',-6,now())
      or
      a.base_dt is null
      )
      and b.joined_at>=date_add('week',-6,now())

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
