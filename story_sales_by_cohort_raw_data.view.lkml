#include: "story_sales_by_cohort_raw_data.view"

view: story_sales_by_cohort_raw_data {
  derived_table: {
    sql: select cast(cu.created_at +interval '5' hour as date) as created_at
      ,case when date_diff('day',u.joined_at,cu.created_at)=0 then 'Day 0'
      When date_diff('day',u.joined_at,cu.created_at)>0 and date_diff('day',u.joined_at,cu.created_at)<=3 Then 'Day 1-3'
      When date_diff('day',u.joined_at,cu.created_at)>3 and date_diff('day',u.joined_at,cu.created_at)<=7 then 'Day 4-7'
      When date_diff('day',u.joined_at,cu.created_at)>8 and date_diff('day',u.joined_at,cu.created_at)<=15 Then 'Day 8-15'
      when date_diff('day',u.joined_at,cu.created_at)>16 and date_diff('day',u.joined_at,cu.created_at)<=30 Then 'Day 16-30'
      when date_diff('day',u.joined_at,cu.created_at)>30 and date_diff('day',u.joined_at,cu.created_at)<=120 then 'Day 31-120'
       ELSE 'Day 121+' END as cohort
      ,cu.story_id as story_id
      ,cb.type as sales_type
      ,count(distinct cu.user_id) Payers
      ,sum(cu.amount) as coins
      from mysql.gatsby.users u

      left join mysql.gatsby.coin_usages cu
      on u.id=cu.user_id


      left join
      (select id,type,cb.created_at
      from mysql.gatsby.coin_balances cb
      )cb
      on cb.id = cu.coin_balance_id
      and cb.created_at<=cu.created_at


      where cu.created_at>=now() - interval '60' day
      group by 1,2,3,4--,5
 ;;
    sql_trigger_value: select date_trunc('hour',now());;
  }

  suggestions: no


  dimension_group: created_at {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day,
      day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.created_at ;;
  }

  dimension: cohort {
    type: string
    sql: ${TABLE}.cohort ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: sales_type {
    type: string
    sql: ${TABLE}.sales_type ;;
  }

  dimension: payers {
    type: number
    sql: ${TABLE}.Payers ;;
  }

  dimension: coins {
    type: number
    sql: ${TABLE}.coins ;;
  }

}
