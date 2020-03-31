view: subscription_usage_distribution {
  derived_table: {
    sql: select created_at , user_id,init_amount-current_amount as usage,rank() over (partition by user_id order by created_at) as row_num
      from mysql.gatsby.coin_balances
      where init_amount=200
      --and is_active=0
      and expired_at is not null
      and type='subscription'

       ;;
  }

  suggestions: no

  dimension_group: created_at {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: usage {
    type: number
    sql: ${TABLE}.usage ;;
  }

  dimension: usage_group {
    type: number
    sql: case when ${usage}>=0 and ${usage}<30 then 30
              when ${usage}>=20 and ${usage}<60 then 60
              when ${usage}>=60 and ${usage}<90 then 90
              when ${usage}>=90 and ${usage}<120 then 120
              when ${usage}>=120 and ${usage}<150 then 150
              when ${usage}>=150 and ${usage}<180 then 180
              when ${usage}>=180 then 200
              else 30 end;;
  }

  dimension: row_num {
    type: number
    sql: ${TABLE}.row_num ;;
  }

  measure: count_dist {
    type: count_distinct
    sql: ${user_id} ;;
  }

}

# If necessary, uncomment the line below to include explore_source.
# include: "live_ops.model.lkml"

view: subscriptions_by_count {
  derived_table: {
    explore_source: subscription_usage_distribution {
      column: created_at_month {}
      column: row_num {}
      column: usage {}
      column: usage_group {}
      column: user_id {}
    }
  }
  dimension: created_at_month {
    type: date_month
  }
  dimension: row_num {
    type: number
  }
  dimension: usage {
    type: number
  }
  dimension: usage_group {
    type: number
  }
  dimension: user_id {
    type: number
  }

  measure: Avg_Renewal {
    type: average
    sql: ${row_num} ;;
    value_format_name: decimal_2
  }

  measure: max_row {
    type: max
    sql: ${row_num} ;;
  }

  measure: count_dist {
    type: count_distinct
    sql: ${user_id} ;;
  }
}
