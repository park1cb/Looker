view: monthly_subscription {
  derived_table: {
    sql: with mast as
(
select created_at , user_id,init_amount-current_amount as usage,rank() over (partition by user_id order by created_at) as row_num
      from mysql.gatsby.coin_balances
      where init_amount=200
      --and is_active=0
      and expired_at is not null
      and type='subscription'
)
select created_at,user_id,usage,row_num,max(row_num) over (partition by user_id) as maximum,avg(usage) over (partition by user_id) as avg_usage
from mast
group by 1,2,3,4
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

  dimension: maximum {
    type: number
    sql: ${TABLE}.maximum ;;
  }

  dimension: avge_usage {
    type: number
    sql: ${TABLE}.avg_usage ;;
  }

  measure: count_dist {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: avg_renewal {
    type: average
    sql: ${maximum} ;;
  }

}
