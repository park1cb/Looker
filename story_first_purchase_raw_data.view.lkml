view: story_first_purchase_raw_data {
  derived_table: {
    sql: select
      u.joined_at
      ,u.id as user_id
      ,s.id as story_id
      ,s.title
      ,cb.type as sales_type
     ,min(cu.created_at) as purchased_at


      from mysql.gatsby.users u

      left join mysql.gatsby.coin_usages cu
      on u.id=cu.user_id

      left join mysql.gatsby.stories s
      on cu.story_id = s.id

      left join mysql.gatsby.episodes e
      on cu.episode_id = e.id

      left join
      (select id,type
      from mysql.gatsby.coin_balances cb
      )cb
      on cb.id = cu.coin_balance_id

      left join mysql.gatsby.transfer_story_coin_values tscv
      on tscv.story_id=s.id


      where cast(u.joined_at as date)>=cast(date_add('day',-30,now()) as date)
      group by 1,2,3,4,5
 ;;
    sql_trigger_value: select date_trunc('hour',now());;
  }

  suggestions: no


  dimension_group: joined_at {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.joined_at ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: sales_type {
    type: string
    sql: ${TABLE}.sales_type ;;
  }

  dimension_group: purchased_at {
    type: time
    sql: ${TABLE}.purchased_at ;;
  }


}
