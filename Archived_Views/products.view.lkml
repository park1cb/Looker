view: products {
  sql_table_name: mysql.gatsby.products ;;
  suggestions: no

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: alias {
    type: string
    hidden: yes
    sql: ${TABLE}.alias ;;
  }

  dimension: alias_for_chat {
    type: string
    hidden: yes
    sql: ${TABLE}.alias_for_chat ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: current_price {
    type: number
    sql: ${TABLE}.current_price ;;
  }

  dimension_group: deleted {
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
    sql: ${TABLE}.deleted_at ;;
  }

  dimension: description {
    type: string
    hidden: yes
    sql: ${TABLE}.description ;;
  }

  dimension: is_default {
    type: number
    hidden: yes
    sql: ${TABLE}.is_default ;;
  }

  dimension: key {
    type: string
    hidden: yes
    sql: ${TABLE}.key ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: original_amount {
    type: number
    sql: ${TABLE}.original_amount ;;
  }

  dimension: original_price {
    type: number
    sql: ${TABLE}.original_price ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;;
  }

  dimension: tag_line {
    type: string
    sql: ${TABLE}.tag_line ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at ;;
  }


}
