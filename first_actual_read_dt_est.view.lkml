# 이거 테이블 따로 저장하고 이거 맵핑해서 쓸 예정
view: first_actual_read_dt_est {
  derived_table: {
    sql: with test as
      (
      select user_id,story_id,base_dt_est,rank() over (partition by user_id,story_id order by base_dt_est) as episode_number
      from hive.dw.dw_bookmark_est
      where base_date>=date '2019-01-01'
      )
      select test.user_id,cast(date_format(joined_at, '%Y-%m-%d 00:00:00 -05:00') as timestamp) as joined_at,min(test.base_dt_est) as first_actual_read_dt_est
      from test test
      join mysql.gatsby.users user
      on user.id=test.user_id
      where episode_number=4
      and user.joined_at>=date '2019-01-01'
      group by 1,2
       ;;
    sql_trigger_value: select date_trunc('day',now());;
  }

  suggestions: no


  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: first_actual_read_dt_est {
    type: date_time
    sql: ${TABLE}.first_actual_read_dt_est ;;
  }

  dimension: joined_at {
    type: date_time
    sql: ${TABLE}.joined_at ;;
  }


}
