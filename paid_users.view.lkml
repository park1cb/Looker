view: paid_users {
  derived_table: {
    sql: select paid.user_id
      ,users.joined_at
      ,paid.created_at as Purchased_at
      ,paid.product_id as product
      ,paid.amount
      ,pd.type
      ,pd.original_price

      from mysql.gatsby.users users

      join mysql.gatsby.paid_coin_issues paid
      on paid.user_id=users.id

      join mysql.gatsby.products pd
      on pd.id=paid.product_id
       ;;
  }

  suggestions: no

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
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
    convert_tz: no
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
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Purchased_at ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}.product ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: original_price {
    type: number
    sql: ${TABLE}.original_price ;;
  }

  measure: paid_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: revenue {
    type: sum
    sql: ${original_price} ;;
    value_format_name: usd
  }
  measure: Average_Price{
    type: average
    sql: ${original_price} ;;
    value_format_name: usd
  }
  dimension_group: cohort {
    type: duration
    intervals: [day]
    sql_start: ${joined_at_raw} ;;
    sql_end: ${purchased_at_raw} ;;
  }


  set: detail {
    fields: [
      user_id,
      joined_at_date,
      purchased_at_date,
      product,
      amount,
      type,
      original_price
    ]
  }
}
