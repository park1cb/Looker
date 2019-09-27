view: test {
  derived_table: {
    sql: select
          user_id
          ,event_type
          ,event_time
          ,json_extract_scalar(event_properties, '$["Story Id"]') as story_id
          ,base_date
          from hive.dw.dw_amplitude
          where base_date>= cast(date_add('month',-6,now()) as date)
       ;;
  }

  suggestions: no

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension_group: event_time {
    type: time
    sql: ${TABLE}.event_time ;;
  }

  dimension: story_id {
    type: string
    sql: ${TABLE}.story_id ;;
  }

  dimension: base_date {
    type: date
    sql: ${TABLE}.base_date ;;
  }

  set: detail {
    fields: [user_id, event_type, event_time_time, story_id, base_date]
  }
}
