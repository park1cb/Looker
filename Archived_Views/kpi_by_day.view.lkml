view: kpi_by_day {
  sql_table_name: mart.mart.kpi_by_day ;;
  suggestions: no

  dimension: active_users_raw {
    type: number
    sql: ${TABLE}.active_users ;;
    hidden: yes
  }

  dimension_group: base_date_est {
    type: time
    timeframes: [
      date

    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.base_date_est ;;
  }

  dimension: coin_used_users_raw {
    type: number
    sql: ${TABLE}.coin_used_users ;;
    hidden: yes
  }

  dimension: episode_unique_views_raw {
    type: number
    sql: ${TABLE}.episode_unique_views ;;
    hidden: yes
  }

  dimension: new_installed_users_raw {
    type: number
    sql: ${TABLE}.new_installed_users ;;
    hidden: yes
  }

  dimension: new_users_raw {
    type: number
    sql: ${TABLE}.new_users ;;
    hidden: yes
  }

  dimension: paying_users_raw {
    type: number
    sql: ${TABLE}.paying_users ;;
    hidden: yes
  }

  dimension: read_users_raw {
    type: number
    sql: ${TABLE}.read_users ;;
    hidden: yes
  }

  dimension: sales_raw {
    type: number
    sql: ${TABLE}.sales ;;
    hidden: yes
  }

  dimension: sales_onetime_product_raw {
    type: number
    sql: ${TABLE}.sales_onetime_product ;;
    hidden: yes
  }

  dimension: sales_subscription_product_raw {
    type: number
    sql: ${TABLE}.sales_subscription_product ;;
    hidden: yes
  }

  dimension: used_coins_raw {
    type: number
    sql: ${TABLE}.used_coins ;;
    hidden: yes
  }

  dimension: viewed_episodes_raw {
    type: number
    sql: ${TABLE}.viewed_episodes ;;
    hidden: yes
  }

  dimension: viewed_stories_raw {
    type: number
    sql: ${TABLE}.viewed_stories ;;
    hidden: yes
  }

  measure: active_users {
    type: average
    sql: ${active_users_raw};;
  }

  measure: episode_unique_views {
    type: average
    sql: ${episode_unique_views_raw} ;;
  }



  measure: coin_used_users  {
    type: average
    sql: ${coin_used_users_raw} ;;
  }

  measure: new_installed_users {
    type: average
    sql: ${new_installed_users_raw} ;;
  }

  measure: new_users {
    type: average
    sql: ${new_users_raw} ;;
  }

  measure: paying_users {
    type: average
    sql: ${paying_users_raw} ;;
  }

  measure: read_users {
    type: average
    sql: ${read_users_raw} ;;
  }

  measure: sales {
    type: average
    sql: ${sales_raw} ;;
    value_format_name: usd
  }

  measure: sales_onetime_product {
    type: average
    sql: ${sales_onetime_product_raw} ;;
    value_format_name: usd
  }

  measure: sales_subscription_product {
    type: average
    sql: ${sales_subscription_product_raw} ;;
    value_format_name: usd
  }

  measure: used_coins {
    type: average
    sql: ${used_coins_raw} ;;
  }

  measure: viewed_episode {
    type: average
    sql: ${viewed_episodes_raw} ;;
  }

  measure: viewed_stories {
    type: average
    sql: ${viewed_stories_raw} ;;
  }

}
