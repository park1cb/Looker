view: episode_count_distribution_raw_data {
  derived_table: {
    sql: select
        cast(cu.created_at + interval '5' hour as date) as created_at
        , cu.user_id as user_id
        , cu.story_id
        , date_diff('day',u.joined_at,cu.created_at) as days
        , sum(cu.amount) as coins

      from mysql.gatsby.users u

      left join mysql.gatsby.coin_usages cu
      on u.id=cu.user_id


      left join mysql.gatsby.coin_balances cb
      on cb.id = cu.coin_balance_id

      where cb.type in ('one-time','subscription')
      --and cu.story_id=8602
      --and date_diff('day',u.joined_at,cu.created_at)=0
      and cu.created_at>=date_add('day',-30,now())
      group by 1,2,3,4
 ;;
    sql_trigger_value: select date_trunc('hour',now());;
  }

  suggestions: no



  dimension_group: created_at {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day,
      day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.created_at ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: days {
    type: number
    sql: ${TABLE}."days" ;;
  }

  dimension: coins {
    type: number
    sql: ${TABLE}.coins ;;
  }


}
