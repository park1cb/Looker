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
        and base_date <= {% date_end date_filter %}
        and session_id <> -1
      group by 1,2,3
      order by 1,2,3
    )
    select
      amplitude_id,
      count(session_id) as session_count,
      sum(session_duration) as session_duration
    from t
    group by 1
    order by 1
      ;;
  }

  filter: date_filter {
    type: date
  }

  dimension: amplitude_id {
    type: string
    sql: ${TABLE}.amplitude_id ;;
  }
  dimension: session_duration {
    type: number
    sql: ${TABLE}.session_duration ;;
  }
  dimension: session_count {
    type: number
    sql: ${TABLE}.session_count ;;
  }
  dimension: session_time_tier {
    type: tier
    value_format: "0"
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180]
    style: interval
    sql: ${session_duration} ;;
  }

  measure: total_session_duration {
    type: number
    sql: ${session_duration} ;;
  }
  measure: total_session_count {
    type: number
    sql: ${session_count} ;;
  }
  measure: user_count {
    type: number
    sql:count(distinct ${amplitude_id}) ;;
  }
}
