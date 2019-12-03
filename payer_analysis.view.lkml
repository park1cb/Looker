view: payer_analysis {
  derived_table: {
    sql: select
        u.id as user_id
        , cu.user_id as paid_user_id
        , cu.story_id
        , cu.created_at
        , cb.type as sales_type
        , u.joined_at
        , s.writer_id as writer_id
        , s.title
        , e.no as episode_no
        , cu.amount as coins
        , cu.coin_balance_id
        , tscv.value as writer_payout
        , date_diff('day',u.joined_at,cu.created_at) as days
      from mysql.gatsby.users u

      left join mysql.gatsby.coin_usages cu
      on u.id=cu.user_id

      left join mysql.gatsby.stories s
      on cu.story_id = s.id

      left join mysql.gatsby.episodes e
      on cu.episode_id = e.id

      left join mysql.gatsby.coin_balances cb
      on cb.id = cu.coin_balance_id

      left join mysql.gatsby.transfer_story_coin_values tscv
      on tscv.story_id=s.id



 ;;
  }

  suggestions: no


  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: paid_user_id {
    type: number
    sql: ${TABLE}.paid_user_id ;;
  }

  dimension:story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }


  dimension_group: created_at {
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

  dimension_group: joined_at {
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
    sql: ${TABLE}.joined_at ;;
  }

  dimension: writer_id {
    type: number
    sql: ${TABLE}.writer_id ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: episode_no {
    type: number
    sql: ${TABLE}.episode_no ;;
  }

  dimension: coins {
    type: number
    sql: ${TABLE}.coins ;;
  }

  dimension: coin_balance_id {
    type: number
    sql: ${TABLE}.coin_balance_id ;;
  }

  dimension: days {
    type: number
    sql: ${TABLE}."days" ;;
  }

  dimension: payer_cohort {
    case: {
      when: {
        sql: ${days} is null ;;
        label: "Non PU"
      }
      when: {
        sql: ${days}=0;;
        label: "D0"
      }
      when: {
        sql: ${days}=1;;
        label: "D1"
      }
      when: {
        sql: ${days}=2;;
        label: "D2"
      }
      when: {
        sql: ${days}=3;;
        label: "D3"
      }
      else:"D4+"
    }
  }

  dimension: writer_payout {
    type: number
    sql: ${TABLE}.writer_payout ;;
    value_format_name: usd
  }

  dimension: high_margin_story_flag {
    type: yesno
    sql: ${writer_payout}<0.042 or ${writer_id}=705918 ;;
  }

  measure: new_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: new_dist_paid_users {
    type: count_distinct
    sql: ${paid_user_id} ;;
  }

  measure: writer_payout_cost {
    type: sum
    sql: ${writer_payout} ;;
    value_format_name: usd
  }

  #measure: paying_transactions {
  #  type: sum
  #  sql: case when ${paid_user_id} is not null then 1 else 0 end ;;
  #}

  measure: total_coins {
    type: sum
    sql: ${coins} ;;
  }





}
