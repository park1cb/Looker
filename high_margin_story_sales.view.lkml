view: high_margin_story_sales {
  derived_table: {
    sql: select cu.user_id as paid_user_id
      , cu.story_id
      , cu.created_at
      , cb.type as sales_type
      , s.writer_id as writer_id
      , s.title
      , s.chapter_count
      , cu.amount as coins
      , tscv.value as writer_payout
      from mysql.gatsby.coin_usages cu

      left join mysql.gatsby.stories s
      on cu.story_id = s.id

      left join mysql.gatsby.episodes e
      on cu.episode_id = e.id

      join mysql.gatsby.coin_balances cb
      on cb.id = cu.coin_balance_id

      left join mysql.gatsby.transfer_story_coin_values tscv
      on tscv.story_id=s.id
       ;;

    sql_trigger_value: select date_trunc('hour',now());;
  }

  suggestions: no


  dimension: paid_user_id {
    type: number
    sql: ${TABLE}.paid_user_id ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension_group: purchased_at {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.created_at ;;
  }

  dimension: sales_type {
    type: string
    sql: ${TABLE}.sales_type ;;
  }

  dimension: writer_id {
    type: number
    sql: ${TABLE}.writer_id ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: chapter_count {
    type: number
    sql: ${TABLE}.chapter_count ;;
  }

  dimension: coins {
    type: number
    sql: ${TABLE}.coins ;;
  }

  dimension: writer_payout {
    type: number
    sql: ${TABLE}.writer_payout ;;
  }

  dimension: high_margin_story_flag {
    type: yesno
    sql: ${writer_payout}<0.042 or ${writer_id}=705918 ;;
  }

  dimension: paid_coins {
    type: yesno
    sql: ${sales_type}='one-time' or ${sales_type}='subscription' ;;
  }

  measure: total_coins {
    type: sum
    sql: ${coins} ;;
  }


}
