include: "/*.view.lkml"
view: payers_by_cohort {
  derived_table: {
    sql: with mast as
      (
      select *
      from ${payer_analysis.SQL_TABLE_NAME}
      )
      , active as
      (
      select mast.user_id,last_used_at,rank() over (partition by mast.user_id order by last_used_at desc) as rank
      from mast mast

      left join hive.dm.active_users_utc active
      on active.user_id=mast.user_id
      and active.last_used_at<=mast.created_at
      )

      select mast.*
      from mast mast
      left join active active
      on active.user_id=mast.user_id
      and active.rank=1

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
