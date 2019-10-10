connection: "radish_datalake"

# include all the views
include: "*.view"

datagroup: live_ops_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: live_ops_default_datagroup



explore: Paying_Conversion {}

explore: subscription_usage_distribution {}

explore: subscriptions_by_count {}

explore: monthly_subscription {}

explore: HRA_Usage {}

explore: HRA_Daily_Follower_Usage {}

explore: subscription_breakdown {}

explore: hra_heavy_user_monthly_subscription_raking {}

explore: subscriber_average_story_reads {}

explore: top_story_raking_by_sales_product {}

explore: monthly_subscriber_spikes {}

explore: ltv_final {}

explore: ltv_table_week {}

explore: first_story_read_within_24_hours {
  join: new_users {
    type: inner
    sql_on: ${new_users.joined_at_date}=${first_story_read_within_24_hours.joined_at_date} ;;
    relationship: one_to_one
  }
}
explore: actual_reading_rate_in_96_hours {
  join: new_users {
    type: inner
    sql_on: ${new_users.joined_at_date}=${actual_reading_rate_in_96_hours.joined_at_date} ;;
    relationship: one_to_one
  }
}


explore: paid_users {
  label: "conversion to payer"
  join: new_users {
    type: inner
    sql_on: ${new_users.joined_at_date}=${paid_users.joined_at_date} ;;
    relationship: one_to_one
  }
}

explore: active_users {
  label: "Active Users"
  join: new_users {
    type: inner
    sql_on: ${new_users.joined_at_date}=${active_users.joined_at_date} ;;
    relationship: one_to_one
  }
}

explore: early_funnel {}

explore: dw_amplitude_early_funnel_raw {}

explore: early_funnel_path1 {}

explore: early_funnel_path2 {}

explore: early_funnel_path3 {}

explore: early_funnel_path4 {}

explore: arpu_table {}
