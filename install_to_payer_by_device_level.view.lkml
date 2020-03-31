view: install_to_payer_by_device_level {
  derived_table: {
    sql: select
    attributed_at installed_date
    ,a.os_name
    ,a.network_name
    ,a.campaign_name
    ,a.adgroup_name
    ,a.creative_name
    ,a.adid
    ,b.adjust_id
    ,min(purchased_at) as first_purchased_date
      from mart.mart.user_mapper_adjust a
      left join mart.mart.coin_purchased_devices b
      on a.adid=b.adjust_id
      and b.purchased_at>=a.attributed_at
      group by 1,2,3,4,5,6,7,8
       ;;
  }

  suggestions: no



  dimension_group: installed_date {
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
    datatype: timestamp
    sql: ${TABLE}.installed_date ;;
  }

  dimension: os_name {
    type: string
    sql: ${TABLE}.os_name ;;
  }

  dimension: network_name {
    type: string
    sql: ${TABLE}.network_name ;;
  }


  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: adgroup_name {
    type: string
    sql: ${TABLE}.adgroup_name ;;
  }

  dimension: creative_name {
    type: string
    sql: ${TABLE}.creative_name ;;
  }

  dimension: adid {
    type: string
    sql: ${TABLE}.adid ;;
  }

  dimension: adjust_id {
    type: string
    sql: ${TABLE}.adjust_id ;;
  }

  dimension_group: first_purchased_date {
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
    datatype: timestamp
    sql: ${TABLE}.first_purchased_date ;;
  }

  dimension_group: cohort {
    type: duration
    intervals: [day]
    sql_start: ${installed_date_raw} ;;
    sql_end: ${first_purchased_date_raw} ;;
  }

  measure: installed_devices{
    type: count_distinct
    sql: ${adid};;
  }

  measure: purchased_devices {
    type: count_distinct
    sql: ${adjust_id} ;;
  }


}
