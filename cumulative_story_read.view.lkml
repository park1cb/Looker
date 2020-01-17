view: cumulative_story_read {
  derived_table: {
    sql: select base_date,user_id,story_id,episode_id,sum(1) over(PARTITION BY user_id,story_id ORDER BY base_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cumulative_read
      from hive.dw.dw_bookmark_est
       ;;
    sql_trigger_value: select date_trunc('day',now());;
  }

  suggestions: no



  dimension_group: base_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.base_date ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: episode_id {
    type: number
    sql: ${TABLE}.episode_id ;;
  }

  dimension: cumulative_read {
    type: number
    sql: ${TABLE}.cumulative_read ;;
  }

}
