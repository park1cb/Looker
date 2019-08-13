view: paid_coin_issues {
  sql_table_name: mysql.gatsby.paid_coin_issues ;;
  suggestions: no

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: coin_transaction_id {
    type: number
    hidden: yes
    sql: ${TABLE}.coin_transaction_id ;;
  }

  dimension_group: created {
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
    datatype: timestamp
    sql: ${TABLE}.created_at ;;
  }

  dimension: platform {
    type: string
    hidden: yes
    sql: ${TABLE}.platform ;;
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
  }

  dimension: transaction_id {
    type: string
    hidden: yes
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_string_id {
    type: string
    hidden: yes
    sql: ${TABLE}.user_string_id ;;
  }

  measure: paid_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

}
