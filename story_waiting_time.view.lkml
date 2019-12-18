view: story_waiting_time {
  derived_table: {
    sql: select *
      ,date_diff('minute',lag(base_dt,1) over (partition by user_id,story_id order by "no"),base_dt) as waiting_time
      ,case
      when type<>lag(type,1) over (partition by user_id,story_id order by "no") and type='paid' then 'CP'
      when type<>lag(type,1) over (partition by user_id,story_id order by "no") and type='free' then 'CF'
      else 'Same' end payer_type_conversion
      from ${episode_read_paid_nonpaid.SQL_TABLE_NAME} a
      where story_id={% parameter story_id %}
      and date_diff('minute',lag(base_dt,1) over (partition by user_id,story_id order by "no"),base_dt)>=0
       ;;
  }

  suggestions: no



  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: joined_at {
    type: time
    sql: ${TABLE}.joined_at ;;
  }

  parameter: story_id {
    type: number
    default_value: "8602"
  }

  dimension_group: base_dt {
    type: time
    sql: ${TABLE}.base_dt ;;
  }

  dimension: no_ {
    type: number
    sql: ${TABLE}.no ;;
  }

  dimension: coin_transaction_id {
    type: number
    sql: ${TABLE}.coin_transaction_id ;;
  }

  dimension_group: purchased_at {
    type: time
    sql: ${TABLE}.purchased_at ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: waiting_time {
    type: number
    sql: ${TABLE}.waiting_time ;;
  }

  dimension: payer_type_conversion {
    type: string
    sql: ${TABLE}.payer_type_conversion ;;
  }

  dimension: story_waiting_time {
    type: tier
    style: integer
    tiers: [10,30,60,120,600,1200]
    sql: ${waiting_time} ;;
  }

  measure: reader {
    type: count_distinct
    sql: ${user_id} ;;
  }


}
