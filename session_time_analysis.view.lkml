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
      amplitude_id,
      session_count,
      session_duration,
      case when session_duration < 1 then True else False end as under_one_min
    from tt
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
    sql: ${TABLE}.session_count ;;
  }
  dimension: session_duration {
    type: number
    value_format: "0.00"
    sql: ${TABLE}.session_duration ;;
  }
  dimension: session_time_tier {
    type: tier
    value_format: "0"
#     tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180]
    tiers: [0, 1,2,3,4,5,6,7,8,9,10]
    style: interval
    sql: ${session_duration} ;;
  }
  dimension: under_one_min {
    type: yesno
    sql: ${TABLE}.under_one_min ;;
  }

  measure: total_session_duration {
    type: number
    value_format: "0.00"
    sql: sum(${session_duration}) ;;
  }
  measure: total_session_duration_over_one_min {
    type: number
    value_format: "0.00"
    sql: sum(case when ${under_one_min} = False then ${session_duration} else null end) ;;
  }
  measure: total_session_count {
    type: number
    sql: sum(${session_count}) ;;
  }
  measure: total_session_count_over_one_min {
    type: number
    sql: sum(case when ${under_one_min} = False then ${session_count} else null end) ;;
  }
  measure: user_count {
    type: number
    sql:count(distinct ${amplitude_id}) ;;
  }
  measure: user_count_over_one_min {
    type: number
    sql:count(distinct case when ${under_one_min} = False then ${amplitude_id} else null end) ;;
  }
}
