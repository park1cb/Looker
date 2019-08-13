connection: "radish_datalake"

# include all the views
include: "*.view"

datagroup: live_ops_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: live_ops_default_datagroup

explore: paid_users {}

explore: active_users {
  label: "ARPU/ARPPU"
  join: paid_users {
    type: inner
    sql_on: ${paid_users.purchased_at_date}=${active_users.base_dt_date};;
    relationship: one_to_one
  }

}

explore: Paying_Conversion {}

explore: subscription_usage_distribution {}
