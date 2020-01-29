view: session_time_analysis {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql:
    with t as (
      select
          base_date,
          amplitude_id,
          session_id,
          round(cast(date_diff('second',min(base_dt),max(base_dt)) as double)/60,2) as session_duration
      from hive.dw.dw_amplitude_est
      where base_date >= {% date_start date_filter %}
        and base_date < {% date_end date_filter %}
        and session_id <> -1
      group by 1,2,3
      order by 1,2,3
    ),
    tt as (
      select
        base_date,
        amplitude_id,
        count(session_id) as session_count,
        sum(session_duration) as session_duration
      from t
      group by 1,2
      order by 1,2
    )
    select
      base_date,
      count(distinct amplitude_id) as user_count,
      sum(session_count) as total_session_count,
      sum(session_duration) as total_session_duration,
      average(session_count) as mean_session_count,
      average(session_duration) as mean_session_duration,
      approx_percentile(session_count,0.50) as median_session_count,
      approx_percentile(session_duration,0.50) as median_session_duration
    from tt
    group by 1
    order by 1,2

      ;;
  }

  filter: date_filter {
    type: date
  }

  dimension_group: base_date_est {
    type: time
    timeframes: [date, week, month, year]
    datatype: date
    sql: ${TABLE}.base_date ;;
    convert_tz: no
  }
  dimension: user_count {
    type: number
    sql: ${TABLE}.user_count ;;
  }
  dimension: _total_session_count {
    type: number
    sql: ${TABLE}.total_session_count ;;
  }
  dimension: _total_session_duration {
    type: number
    value_format: "0.00"
    sql: ${TABLE}.total_session_duration ;;
  }
  dimension: _mean_session_count {
    type: number
    sql: ${TABLE}.mean_session_count ;;
  }
  dimension: _mean_session_duration {
    type: number
    value_format: "0.00"
    sql: ${TABLE}.mean_session_duration ;;
  }
  dimension: _median_session_count {
    type: number
    sql: ${TABLE}.median_session_count ;;
  }
  dimension: _median_session_duration {
    type: number
    value_format: "0.00"
    sql: ${TABLE}.median_session_duration ;;
  }
#   dimension: session_time_tier {
#     type: tier
#     value_format: "0"
# #     tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180]
#     tiers: [0, 1,2,3,4,5,6,7,8,9,10]
#     style: interval
#     sql: ${session_duration} ;;
#   }
#   dimension: under_one_min {
#     type: yesno
#     sql: ${TABLE}.under_one_min ;;
#   }

  measure: total_session_counts {
    type: number
    value_format: "0.00"
    sql: ${_total_session_count} ;;
  }
  measure: total_session_minute {
    type: number
    sql: ${_total_session_duration};;
  }
  measure: mean_session_counts {
    type: number
    value_format: "0.00"
    sql: ${_mean_session_count} ;;
  }
  measure: mean_session_minute {
    type: number
    sql: ${_mean_session_duration};;
  }
  measure: median_session_counts {
    type: number
    value_format: "0.00"
    sql: ${_median_session_count} ;;
  }
  measure: median_session_minute {
    type: number
    sql: ${_median_session_duration};;
  }
}
