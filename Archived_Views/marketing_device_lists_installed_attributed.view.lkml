view: marketing_device_lists_installed_attributed {
  derived_table: {
    sql: select
      a.os_name
      ,case when a.os_name='android' then device.adid when a.os_name='ios' then coalesce(device.idfv,device.adid) end as device_id
      ,case when network_name in ('Organic','Branch(iOS)','Branch(Android)') then 'Organic' else 'Paid' end as network
      ,campaign_name
      ,campaign_name_id as campaign_id
      ,adgroup_name
      ,adgroup_name_id as adgroup_id
      ,creative_name
      ,creative_name_id as creative_id
      ,installed_at at time zone '-05:00' as installed_at_est
      ,attributed_at at time zone '-05:00' as attributed_at_est
      from mart.mart.user_mapper_adjust a

      join mysql.gatsby.user_devices device
      on a.adid=device.adjust_id

      where case when a.os_name='android' then device.adid when a.os_name='ios' then coalesce(device.adid,device.idfv) end<>'00000000-0000-0000-0000-000000000000'
      and case when a.os_name='android' then device.adid when a.os_name='ios' then coalesce(device.adid,device.idfv) end<>'null'
       ;;
  }

  suggestions: no



  dimension: os_name {
    type: string
    sql: ${TABLE}.os_name ;;
  }

  dimension: device_id {
    type: string
    sql: ${TABLE}.device_id ;;
  }

  dimension: network {
    type: string
    sql: ${TABLE}.network ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: campaign_id {
    type: string
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: adgroup_name {
    type: string
    sql: ${TABLE}.adgroup_name ;;
  }

  dimension: adgroup_id {
    type: string
    sql: ${TABLE}.adgroup_id ;;
  }

  dimension: creative_name {
    type: string
    sql: ${TABLE}.creative_name ;;
  }

  dimension: creative_id {
    type: string
    sql: ${TABLE}.creative_id ;;
  }

  dimension_group: installed_at_est {
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
    convert_tz: no
    datatype: date
    sql: ${TABLE}.installed_at_est ;;
  }

  dimension_group: attributed_at_est {
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
    convert_tz: no
    datatype: date
    sql: ${TABLE}.attributed_at_est ;;
  }


}
