view: cohort_data_purchase_raw_data {
  derived_table: {
    sql: select distinct
      case when a.os_name='android' then device.adid when a.os_name='ios' then coalesce(device.adid,device.idfv) end as device_id,
      a.adid as adjust_id,
      a.os_name as platform,
      c.user_id,
      a.attributed_at as installed_at,
      c.used_at,
      c.amount,
      c.story_id,
      s.title,
      c.episode_id,
      case when c.coin_type in ('one-time','subscription') then 'Y' else 'N' end as purchased_user,
      date_diff('hour',a.attributed_at,c.used_at)/24 as cohort,
      case when a.network_name in ('Organic','Branch(iOS)','Branch(Android)') then 'Organic' else 'Paid' end as network

      from mart.mart.user_mapper_adjust a

      left join mart.mart.coin_used_devices c
      on a.adid=c.adjust_id

      join mysql.gatsby.user_devices device
      on a.adid=device.adjust_id

      join mysql.gatsby.stories s
      on s.id=c.story_id

      where a.attributed_at at time zone '-05:00'>=date_add('month',-9,now())
      and date_diff('hour',a.attributed_at,c.used_at)/24>=0
       ;;
    sql_trigger_value: select date_trunc('hour',now());;
  }

  suggestions: no


  dimension: device_id {
    type: string
    sql: ${TABLE}.device_id ;;
  }

  dimension: adjust_id {
    type: string
    sql: ${TABLE}.adjust_id ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: installed_at {
    type: time
    sql: ${TABLE}.installed_at ;;
  }

  dimension_group: used_at {
    type: time
    sql: ${TABLE}.used_at ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: episode_id {
    type: number
    sql: ${TABLE}.episode_id ;;
  }

  dimension: cohort {
    type: number
    sql: ${TABLE}.cohort ;;
  }

  dimension: network {
    type: string
    sql: ${TABLE}.network ;;
  }
}
