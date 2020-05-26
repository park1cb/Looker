explore: acquired_contents_performance {}
view: acquired_contents_performance {
  derived_table: {
    sql: select
      user_id
      ,{% parameter acquisition_cost %} as cost
      ,story_id
      ,b.title
      ,b.sales_type
      ,episode_id
      ,value
      ,amount
      ,case when coin_type in ('one-time','subscription') then 'paid' else 'free' end as coin_type
      ,used_at at time zone '-05:00' as used_at
      ,date_diff('day',{% parameter acquired_date %},used_at at time zone '-05:00') as days

      from mart.mart.coin_used_devices a

      join mysql.gatsby.stories b
      on a.story_id=b.id

      where a.story_id={% parameter story_id %}
      and date(used_at at time zone '-05:00')>= {% parameter acquired_date %}


       ;;
  }

  suggestions: no

  parameter: acquisition_cost {
    type: number
    #suggest_explore: dw_amplitude
    #suggest_dimension: dw_amplitude.event_type
  }

  parameter: acquired_date {
    type: date
  }

  parameter: story_id {
    type: number
  }


  dimension: user_id {
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: cost {
    #hidden: yes
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: story_title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: sales_type {
    type: string
    sql: ${TABLE}.sales_type ;;
  }

  dimension: episode_id {
    type: number
    sql: ${TABLE}.episode_id ;;
  }

  dimension: value {
    hidden: yes
    type: number
    sql: ${TABLE}.value ;;
  }

  dimension: amount {
    hidden: yes
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: coin_type {
    type: string
    sql: ${TABLE}.coin_type ;;
  }

  dimension_group: coin_date {
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
    sql: ${TABLE}.used_at ;;
  }

  dimension: days {
    type: number
    sql: ${TABLE}.days ;;
  }

  measure: total_coins {
    type: sum
    sql: ${amount} ;;
  }

  measure: money {
    label: "Profit"
    type: sum
    sql: ${amount}*0.042 ;;
    value_format_name: usd
  }

  measure: acquired_cost{
    label: "Acquisition Cost"
    type: number
    sql: max(${cost});;
    value_format_name: usd
  }

  measure: coin_used_user_count {
    type: count_distinct
    sql: ${user_id} ;;
  }



}
