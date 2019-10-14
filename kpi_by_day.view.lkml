view: kpi_by_day {
  sql_table_name: mart.mart.kpi_by_day ;;
  suggestions: no

  dimension: active_users {
    type: number
    sql: ${TABLE}.active_users ;;
  }

  dimension_group: base_date_est {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.base_date_est ;;
  }

  dimension: coin_used_users {
    type: number
    sql: ${TABLE}.coin_used_users ;;
  }

  dimension: episode_unique_views {
    type: number
    sql: ${TABLE}.episode_unique_views ;;
  }

  dimension: new_installed_users {
    type: number
    sql: ${TABLE}.new_installed_users ;;
  }

  dimension: new_users {
    type: number
    sql: ${TABLE}.new_users ;;
  }

  dimension: paying_users {
    type: number
    sql: ${TABLE}.paying_users ;;
  }

  dimension: read_users {
    type: number
    sql: ${TABLE}.read_users ;;
  }

  dimension: sales {
    type: number
    sql: ${TABLE}.sales ;;
    value_format_name: usd
  }

  dimension: sales_onetime_product {
    type: number
    sql: ${TABLE}.sales_onetime_product ;;
    value_format_name: usd
  }

  dimension: sales_subscription_product {
    type: number
    sql: ${TABLE}.sales_subscription_product ;;
    value_format_name: usd
  }

  dimension: used_coins {
    type: number
    sql: ${TABLE}.used_coins ;;
  }

  dimension: viewed_episodes {
    type: number
    sql: ${TABLE}.viewed_episodes ;;
  }

  dimension: viewed_stories {
    type: number
    sql: ${TABLE}.viewed_stories ;;
  }

  measure: total_episode_unique_vies {
    type: average
    sql: ${episode_unique_views} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
