view: dw_amplitude_early_funnel_raw {
  derived_table: {
    sql:
    select
    user_id
    ,event_type
    ,event_time
    ,json_extract_scalar(event_properties, '$["Story Id"]') as story_id
    ,base_date
    from hive.dw.dw_amplitude
    where base_date>= cast(date_add('month',-6,now()) as date);;
    sql_trigger_value: select date_trunc('day',now());;
    }


dimension: user_id {
  type: number
  sql: ${TABLE}.user_id ;;
}
dimension: event_type {
  type: string
  sql: ${TABLE}.event_type ;;
}
dimension_group: event_time{
  type: time
  timeframes: [
    raw,
    time,
    date,
    week,
    month,
    quarter,
    year
  ]
  convert_tz: no
  datatype: date
  sql: ${TABLE}.event_time ;;
}

dimension: story_id {
  type: number
  sql: ${TABLE}.story_id ;;
}

  dimension_group: base {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.base_date ;;
  }

}
