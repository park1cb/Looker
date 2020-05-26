view: story_episode_read_type {
  derived_table: {
    sql: select a.*
      ,case when c.type in ('one-time','subscription') then 'paid' when c.type is not null and c.type not in ('one-time','subscription') then 'free coin' else 'wait to unlock' end as story_read_type
      ,c.type
      ,date_diff('hour',previous_episode_read_dt,episode_read_dt) as hour--,b.created_at as episode_paid_at
      ,d.joined_at
      from ${user_episode_read_dt_raw_data.SQL_TABLE_NAME} a

      left join mysql.gatsby.coin_usages b
      on b.user_id=a.user_id
      and b.episode_id=a.episode_id
      and a.story_id=b.story_id

      left join mysql.gatsby.coin_balances c
      on c.id = b.coin_balance_id

      join mysql.gatsby.users d
      on d.id=a.user_id

       ;;
  }

  suggestions: no



  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: episode_id {
    type: number
    sql: ${TABLE}.episode_id ;;
  }

  dimension_group: episode_read_dt {
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
    sql: ${TABLE}.episode_read_dt ;;
  }

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

  dimension: episode_number {
    type: number
    sql: ${TABLE}.no ;;
  }

  dimension_group: previous_episode_read_dt {
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
    sql: ${TABLE}.previous_episode_read_dt ;;
  }

  dimension_group: episode_published_at {
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
    sql: ${TABLE}.episode_published_at ;;
  }

  dimension: story_read_type {
    type: string
    sql: ${TABLE}.story_read_type ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: hour {
    type: number
    sql: ${TABLE}."hour" ;;
  }

  dimension: hour_group {
    type: tier
    tiers: [1,3,5,8,12,25]
    style: integer
    sql: ${hour} ;;

  }

  measure: user_count {
    type: count_distinct
    link: {
      url: "https://radish.looker.com/dashboards/92?Story%20id=${story_id}&Episode%20Id=${episode_number}"
      icon_url: "https://res-3.cloudinary.com/crunchbase-production/image/upload/c_lpad,h_120,w_120,f_auto,b_white,q_auto:eco/v1485884030/mi3tj8fkktvfiio8rzyu.png"
    }
    sql: ${user_id} ;;
  }

  measure: story_revenue {
    type: sum
    sql: case when ${user_id} is null then 0 else 1 end *0.126 ;;
    value_format_name: usd
  }


}
