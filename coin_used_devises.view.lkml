view: coin_used_devises {
  derived_table: {
    sql: select
      a.installed_at
      ,a.attributed_at
      ,a.os_name
      ,a.network_name
      ,a.adid
      ,b.adjust_id
      ,b.story_id
      ,b.episode_id
      ,b.value
      ,b.amount
      ,b.coin_type
      ,b.used_at
      ,date_diff('hour',a.installed_at,b.used_at)/24 as installed_to_used
      ,date_diff('hour',a.attributed_at,b.used_at)/24 as attributed_to_used
      from mart.mart.user_mapper_adjust a
      left join mart.mart.coin_used_devices b
      on a.adid=b.adjust_id

      where installed_at>=date_add('month',-6,now())
      --and used_at>=date_add('month',-6,now())
 ;;
  }

  suggestions: no


  dimension_group: installed_at {
    type: time
    timeframes: [
      raw,
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
    sql: ${TABLE}.installed_at ;;
  }

  dimension_group: attributed_at {
    type: time
    timeframes: [
      raw,
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
    sql: ${TABLE}.attributed_at ;;
  }

  dimension: os_name {
    type: string
    sql: ${TABLE}.os_name ;;
  }

  dimension: network_name {
    type: string
    sql: ${TABLE}.network_name ;;
  }

  dimension: adid {
    type: string
    sql: ${TABLE}.adid ;;
  }

  dimension: adjust_id {
    type: string
    sql: ${TABLE}.adjust_id ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: episode_id {
    type: number
    sql: ${TABLE}.episode_id ;;
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: coin_type {
    type: string
    sql: ${TABLE}.coin_type ;;
  }

  dimension: paid_status {
    case: {
      when: {
        sql: ${coin_type}='one-time' or ${coin_type}='subscription'  ;;
        label: "Paid"
      }
      # possibly more when statements
      else: "Non-Paid"
    }
  }

  dimension_group: used_at {
    type: time
    timeframes: [
      raw,
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
    sql: ${TABLE}.used_at ;;
  }

  dimension: installed_to_used {
    type: number
    sql: ${TABLE}.installed_to_used ;;
  }

  dimension: attributed_to_used {
    type: number
    sql: ${TABLE}.attributed_to_used ;;
  }

  measure: device_count {
    type: count_distinct
    sql: ${adid} ;;
  }

  measure: coin_used_device_count {
    type: count_distinct
    sql: ${adjust_id} ;;
  }

  measure: episode_count{
    type: sum
    sql: ${amount}/3 ;;
  }

  measure: paid_episode_count{
    type: sum
    sql: case when ${paid_status}='Paid' then ${amount}/3 else 0 end ;;
  }

  measure: story_count {
    type: count_distinct
    sql: ${story_id};;
  }


}
