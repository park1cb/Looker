include: "/*.view.lkml"
view: payers_by_cohort {
  derived_table: {
    sql: select
        u.id as user_id
        , cu.user_id as paid_user_id
        , cu.story_id
        , cu.created_at
        , u.joined_at
        , s.writer_id as writer_id
        , s.title
        , e.no as episode_no
        , cu.coin_balance_id
        , date_diff('day',u.joined_at,cu.created_at) as days
      from mysql.gatsby.users u

      left join (
        select cu.user_id,story_id,cu.episode_id,coin_balance_id,cu.created_at
        from mysql.gatsby.coin_usages cu

        left join ${first_paid_episode_purchase_date.SQL_TABLE_NAME} cb
        on cb.user_id = cu.user_id
        and cb.created_at=cu.created_at
        )cu
      on u.id=cu.user_id

      left join mysql.gatsby.stories s
      on cu.story_id = s.id

      left join mysql.gatsby.episodes e
      on cu.episode_id = e.id

      left join mysql.gatsby.pre_signin_users pre
      on u.id = pre.pre_user_id

      where pre.pre_user_id is null

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

  measure: new_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: new_dist_paid_users {
    type: count_distinct
    sql: ${paid_user_id} ;;
  }

  measure: new_paid_users {
    type: sum
    sql: case when ${paid_user_id} is not null then 1 else 0 end ;;
  }

  measure: total_coins {
    type: sum
    sql: ${coins} ;;
  }

  measure: episode_count {
    type: max
    sql: ${episode_no} ;;
  }





}
