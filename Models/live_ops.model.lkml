connection: "radish_datalake"
# include: "/*.view.lkml"

# # include all the views
# #include: "*.view"

# datagroup: live_ops_default_datagroup {
#   # sql_trigger: SELECT MAX(id) FROM etl_log;;
#   max_cache_age: "1 hour"
# }

# persist_with: live_ops_default_datagroup


# #explore: session_time_analysis {}

# explore: Paying_Conversion {}

# #explore: subscription_usage_distribution {}

# #explore: subscriptions_by_count {}

# #explore: monthly_subscription {}

# #explore: HRA_Usage {}

# #explore: HRA_Daily_Follower_Usage {}

# #explore: subscription_breakdown {}

# #explore: hra_heavy_user_monthly_subscription_raking {}

# #explore: subscriber_average_story_reads {}

# explore: top_story_raking_by_sales_product {}

# #explore: monthly_subscriber_spikes {}

# explore: ltv_final {}

# explore: ltv_table_week {}

# explore: first_story_read_within_24_hours {
#   join: new_users {
#     type: inner
#     sql_on: ${new_users.joined_at_date}=${first_story_read_within_24_hours.joined_at_date} ;;
#     relationship: one_to_one
#   }
# }
# explore: actual_reading_rate_in_96_hours {
#   join: new_users {
#     type: inner
#     sql_on: ${new_users.joined_at_date}=${actual_reading_rate_in_96_hours.joined_at_date} ;;
#     relationship: one_to_one
#   }
# }


# explore: paid_users {
#   label: "conversion to payer"

# }

# #explore: active_users {
# #  label: "Active Users"
# #  join: new_users {
# #    type: inner
# #    sql_on: ${new_users.joined_at_date}=${active_users.joined_at_date} ;;
# #    relationship: one_to_one
# #  }
# #}

# #explore: early_funnel {}

# explore: dw_amplitude_early_funnel_raw {}

# #explore: early_funnel_path1 {}

# #explore: early_funnel_path2 {}

# #explore: early_funnel_path3 {}

# #explore: early_funnel_path4 {}

# #explore: arpu_table {}

# explore: arppu_table {}

# explore: paying_conversion_rate {}

# explore: kpi_by_day {}

# explore: top_stories_by_coin_sales {}

# explore: ltv_graph_by_week {}



# explore: sales_by_story_type {}

# explore: payer_analysis {
#   join: braze_canvas_entry {
#     relationship: many_to_one
#     sql_on: ${payer_analysis.user_id}=${braze_canvas_entry.external_user_id} ;;
#     type: inner

#   }

# }

# explore: first_paid_episode_purchase_date {}

# explore: cohoted_by_first_actual_read {}

# explore: first_actual_read_dt_est {}

# explore: story_sales_by_cohort {

# }


# explore: episode_read_paid_nonpaid {
#     join: braze_canvas_entry {
#       #fields: [braze_canvas_entry.external_user_id,braze_canvas_entry.canvas_id,braze_canvas_entry.canvas_variation_id]
#       relationship: many_to_one
#       sql_on: ${episode_read_paid_nonpaid.user_id}=${braze_canvas_entry.external_user_id} ;;
#       type: inner
#     }
# }


# explore: story_sales_total_coins {}
# explore: episode_count_distribution {}

# explore: best_performing_converter {}

# explore: user_story_retention {
#   join: braze_canvas_entry {
#     #fields: [braze_canvas_entry.external_user_id,braze_canvas_entry.canvas_id,braze_canvas_entry.canvas_variation_id]
#     relationship: many_to_one
#     sql_on: ${user_story_retention.user_id}=${braze_canvas_entry.external_user_id} ;;
#     type: inner
#   }
# }

# explore: another_episode_purchase_count {}

# explore: story_waiting_time {}

# explore: two_plus_story_tracking {}

# explore: two_plus_story_tracking_modified {}

# explore: cohort_analysis {}

# explore: cohort_data_purchase {}

# explore: paid_episode_read_by_week {}

# explore: actual_story_read_by_week {}

# explore: paid_episode_read_by_week__denomiator_installed_device_ {}

# explore: actual_stroy_read_install_bases_by_week {}

# explore: cumulative_story_read {}

# explore: story_revenue_and_costs_by_cohort_raw_data {}

# explore: user_episode_read_dt_raw_data{}

# explore: story_episode_read_type {
#   join: braze_canvas_entry {
#     relationship: many_to_one
#     sql_on: ${story_episode_read_type.user_id}=${braze_canvas_entry.external_user_id} ;;
#     type: inner
#   }
# }

# explore: ltv_table_week_device {}

# explore: ltv_table_device {}

# explore: ltv_version_2_by_installed_date {}

# explore: organic_vs_paid_installs {}

# explore: paid_episode_read_by_installs_day {}

# explore: paid_episode_read_per_paying_users {}

# explore: paying_conversion_by_days {}

# explore: episode_purchased_per_story_starter {
#   join: episode_purchased_per_story_starter_his_surrogate {
#     from: episode_purchased_per_story_starter
#     type: inner
#     relationship: one_to_one
#     sql_on: ${episode_purchased_per_story_starter.date_date}=${episode_purchased_per_story_starter_his_surrogate.date_date}
#     and ${episode_purchased_per_story_starter.day}=${episode_purchased_per_story_starter_his_surrogate.day};;

#   }
# }

# explore: high_margin_story_sales {}

# explore: active_users_user_level {}

# #explore: active_users_base_date {}

# explore: kpi_by_week {}

# #explore: re_engaged_users_comeback_after_15_days {
# #  join: kpi_by_week {
# #    type: inner
# #    relationship: one_to_one
# #    sql_on: ${kpi_by_week.base_date_est_week}=${re_engaged_users_comeback_after_15_days.base_date_week} ;;

# #  }
# #}

# explore: marketing_device_lists_installed_attributed {}



# ######
# explore: cohort_data_purchase_raw_data {}

# explore: braze_canvas_entry {}

# explore: story_title {}

# explore: episode_read_by_cohort_story_level {
#   join: story_title {
#     type: inner
#     relationship: many_to_one
#     sql_on: ${episode_read_by_cohort_story_level.story_id}=${story_title.id} ;;
#   }
# }

# explore: ltv_table_month_gross_revenue {}

# explore: install_to_payer_by_device_level {}

# explore: arppu_investor_request_temporary_overall {}
# explore: arppu_investor_request_temporary {}

# explore: payer_by_devices {}

# explore: coin_used_devises {}

# explore: multi_story_reader_dashboard {
#   join: new_users{
#     type: full_outer
#     relationship: one_to_one
#     sql_on: ${multi_story_reader_dashboard.user_id}=${new_users.id} ;;
#   }
# }
