#include: "//live_ops/first_actual_read_dt_est.view"
#
#view: cohoted_by_first_actual_read {
#  derived_table: {
#    sql:
#      select bookmark.user_id,bookmark.base_dt_est,bookmark.story_id,actual.joined_at at time zone '-05:00' as joined_at
#      from  hive.dw.dw_bookmark_est bookmark
#
#      join ${first_actual_read_dt_est.SQL_TABLE_NAME} actual
#      on bookmark.user_id=actual.user_id
#      and bookmark.base_dt_est=actual.first_actual_read_dt_est
#    ;;
#  }
#
#
#  dimension: user_id {
#    type: number
#    sql: ${TABLE}.user_id ;;
#  }
#
#  dimension: story_id {
#    type: number
#    sql: ${TABLE}.story_id ;;
#  }
#
#
#
#  dimension: joined_at {
#    type: date_time
#    sql: ${TABLE}.joined_at ;;
#  }
#
#  dimension: joined_at2 {
#    type: date_time
#    convert_tz: yes
#    sql: ${TABLE}.joined_at2 ;;
#  }
#
#  dimension_group: base_dt_est {
#    type: time
#    timeframes: [
#      raw,
#      time,
#      date,
#      week,
#      month,
#      quarter,
#      year
#    ]
#    sql: ${TABLE}.base_dt_est ;;
#  }
#
#  #dimension: timediff{
#  #  type: number
#  #  sql:date_diff('hour',${joined_at},${base_dt_est_time}) ;;
#  #}
#
# }
#
