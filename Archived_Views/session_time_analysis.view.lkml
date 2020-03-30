view: session_time_analysis {
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
    )
      select
        base_date,
        amplitude_id,
        count(session_id) as session_count,
        sum(session_duration) as session_duration
      from t
      group by 1,2
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
  dimension: amplitude_id {
    type: string
    sql: ${TABLE}.amplitude_id ;;
  }
  dimension: session_count {
    type: number
    sql: ${TABLE}.session_count;;
  }
  dimension: session_duration {
    type: number
    value_format: "0.00"
    sql: ${TABLE}.session_duration;;
  }

  measure: total_session_counts {
    type: number
    sql: sum(${session_count}) ;;
  }
  measure: total_session_duration {
    type: number
    value_format: "0.00"
    sql: sum(${session_duration});;
  }
  measure: mean_session_counts {
    type: number
    sql: avg(${session_count}) ;;
  }
  measure: mean_session_duration {
    type: number
    value_format: "0.00"
    sql: avg(${session_duration});;
  }
  measure: median_session_counts {
    type: number
    sql: approx_percentile(${session_count},0.50) ;;
  }
  measure: median_session_duration {
    type: number
    value_format: "0.00"
    sql: approx_percentile(${session_duration},0.50);;
  }

}
