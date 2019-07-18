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
    sql_on: ${paid_users.joined_at_date}=${active_users.joined_at_date} ;;
    relationship: one_to_one
  }
}


# - explore: amplitude_mapped_from_adjust

# - explore: amplitude_mapped_from_adjust2

# - explore: amptest

# - explore: converter_stories

# - explore: converter_stories_old

# - explore: curation_ctr

# - explore: episode_sales

# - explore: episode_views

# - explore: onboarding_assigned

# - explore: onboarding_assigned_raw

# - explore: retained_users

# - explore: story_episode_retention

# - explore: story_retention

# - explore: story_retention_past_months

# - explore: story_retention_test

# - explore: story_retention_this_month

# - explore: story_sales

# - explore: story_views

# - explore: temp_onboarding_assigned

# - explore: temp_user_flow

# - explore: user_join

# - explore: user_mapped_from_adjust

# - explore: user_mapped_from_adjust_joined_test

# - explore: user_mapper_adjust

# - explore: user_read_count

# - explore: user_retention

# - explore: user_retention_test

# - explore: user_uninstall
