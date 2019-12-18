view: episode_read_paid_nonpaid {
  derived_table: {
    sql: select bookmark.user_id
      ,user.joined_at
      ,bookmark.story_id
      ,min(bookmark.base_dt) as base_dt
      ,epi."no"
      ,cu.coin_transaction_id
      ,cu.created_at as purchased_at
      ,case when cb.type in ('one-time','subscription') then 'paid' else 'free' end type
      from
      (
      select distinct user_id,story_id,episode_id,base_dt
      from hive.dw.dw_bookmark
      where base_date>=date_add('day',-7,now())
      )bookmark

      left join mysql.gatsby.coin_usages cu
      on bookmark.user_id=cu.user_id
      and bookmark.episode_id=cu.episode_id
      and cu.created_at>=now()-interval '7' day

      left join
      (select id,type
      from mysql.gatsby.coin_balances cb
      )cb
      on cb.id = cu.coin_balance_id

      join mysql.gatsby.episodes epi
      on epi.id=bookmark.episode_id

      join mysql.gatsby.users user
      on user.id=bookmark.user_id
      group by 1,2,3,5,6,7,8
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

  dimension_group: base_dt {
    label: "bookmarked_at"
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
    sql: ${TABLE}.base_dt ;;
  }

  dimension: cohort {
    type: duration_day
    sql_start: ${joined_at_raw} ;;
    sql_end: ${base_dt_raw} ;;
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

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  measure: reader {
    type: count_distinct
    sql: ${user_id} ;;

  }


}
