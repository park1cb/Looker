view: payer_by_devices {
  derived_table: {
    sql:
      select
      a.installed_at
      ,a.attributed_at
      ,a.adid
      ,b.adjust_id
      ,b.product_type
      ,b.price
      ,b.purchased_at
      ,date_diff('hour',a.installed_at,b.purchased_at)/24 as installed_to_purchased
      ,date_diff('hour',a.attributed_at,b.purchased_at)/24 as installed_to_attributed
      from mart.mart.user_mapper_adjust a
      left join mart.mart.coin_purchased_devices b
      on a.adid=b.adjust_id
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

  dimension: adid {
    type: string
    sql: ${TABLE}.adid ;;
  }

  dimension: adjust_id {
    type: string
    sql: ${TABLE}.adjust_id ;;
  }

  dimension: product_type {
    type: string
    sql: ${TABLE}.product_type ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;;
  }

  dimension_group: purchased_at {
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
    sql: ${TABLE}.purchased_at ;;
  }

  dimension: installed_to_purchased {
    type: number
    sql: ${TABLE}.installed_to_purchased ;;
  }

  dimension: attributed_to_purchased {
    type: number
    sql: ${TABLE}.attributed_to_purchased ;;
  }

  measure: install_count {
    type: count_distinct
    sql: ${adid} ;;
  }

  measure: purchased_devices{
    type: count_distinct
    sql: ${adjust_id} ;;
  }



}
