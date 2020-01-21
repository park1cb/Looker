view: session_time_analysis {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql:
    select
        base_date,
        amplitude_id,
        session_id,
        date_diff('second',min(base_dt),max(base_dt)) as time_diff
    from hive.dw.dw_amplitude_est
    where base_date >= {% date_start date_filter %}
      and base_date <= {% date_end date_filter %}
      and session_id <> -1
    group by 1,2,3
    order by 1,2,3
      ;;
  }

  filter: date_filter {
    type: date
  }

  dimension_group: base_date_est {
    type: time
    timeframes: [date, week, month, year]
    convert_tz: no
    sql: ${TABLE}.base_date ;;
  }
  dimension: amplitude_id {
    type: string
    sql: ${TABLE}.amplitude_id ;;
  }
  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }
  dimension: time_diff{
    type: number
    sql: ${TABLE}.time_diff ;;
  }

  measure: total_session_seconds {
    type: sum
    sql: ${time_diff} ;;
  }
  measure: total_session_counts {
    type: number
    sql: count(${time_diff}) ;;
  }
  measure: avg_session_counts {
    type: average
    sql: ${time_diff} ;;
  }
}
