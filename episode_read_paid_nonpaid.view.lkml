view: episode_read_paid_nonpaid {
  derived_table: {
    sql: select cu.user_id
      ,user.joined_at
      ,cu.story_id
      ,epi."no"
      ,cu.coin_usage_id as coin_transaction_id
      ,cu.used_at as purchased_at
      ,case when cu.coin_type in ('one-time','subscription') then 'paid' else 'free' end type
      from mart.mart.coin_usage_by_ads cu


      join mysql.gatsby.episodes epi
      on epi.id=cu.episode_id

      join mysql.gatsby.users user
      on user.id=cu.user_id
       ;;
    sql_trigger_value: select date_trunc('hour',now());;
  }

  suggestions: no



  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
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
    sql: ${TABLE}.purchased_at ;;
  }

  dimension: cohort {
    type: duration_day
    sql_start: ${joined_at_raw} ;;
    sql_end: ${purchased_at_raw} ;;
  }

  dimension: no_ {
    type: number
    sql: ${TABLE}.no ;;
    link: {
      url: "https://radish.looker.com/dashboards/77?Story%20Id={{ _filters['story_id']}}&Episode%20Number={{value}}"
      label: "Episode Details"
      icon_url: "https://res-3.cloudinary.com/crunchbase-production/image/upload/c_lpad,h_120,w_120,f_auto,b_white,q_auto:eco/v1485884030/mi3tj8fkktvfiio8rzyu.png"
    }
  }

  dimension: coin_transaction_id {
    type: number
    sql: ${TABLE}.coin_transaction_id ;;
  }



  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  measure: reader {
    type: count_distinct
    sql: ${user_id} ;;

  }


}
