view: paid_users {
  derived_table: {
    sql: select
      users.id as new_user_id
      ,paid.user_id as paid_user_id
      ,users.joined_at
      ,paid.purchased_at
      ,paid.product_id as product
      ,paid.product_type as type
      ,paid.platform as os_name
      ,paid.price

      from mysql.gatsby.users users

      left join mart.mart.coin_purchased_devices paid
      on paid.user_id=users.id

      left join mysql.gatsby.pre_signin_users pre
      on users.id = pre.pre_user_id
      where pre.pre_user_id is null
       ;;
  }

  suggestions: no



  dimension: new_user_id {
    type: number
    sql: ${TABLE}.new_user_id ;;
  }

  dimension: paid_user_id {
    type: number
    sql: ${TABLE}.paid_user_id ;;
  }

  dimension_group: joined_at {
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
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.joined_at ;;
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
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.Purchased_at ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}.product ;;
  }

  dimension: os_name {
    type: string
    sql: ${TABLE}.os_name ;;
  }



  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;;
  }

  measure: new_users {
    type: count_distinct
    sql: ${new_user_id} ;;
  }


  measure: paid_users {
    type: count_distinct
    sql: ${paid_user_id} ;;
  }

  measure: revenue {
    type: sum
    sql: ${price} ;;
    value_format_name: usd
  }


  measure: Average_Price{
    type: average
    sql: ${price} ;;
    value_format_name: usd
  }
  dimension_group: cohort {
    type: duration
    intervals: [day]
    sql_start: ${joined_at_raw} ;;
    sql_end: ${purchased_at_raw} ;;
  }


}
