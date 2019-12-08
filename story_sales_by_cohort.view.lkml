view: story_sales_by_cohort {
  derived_table: {
    sql: with mast as
      (

      select cast(cu.created_at + interval '5' hour as date) as created_at
      ,case when date_diff('day',u.joined_at,cu.created_at)=0 then 'Day 0'
      When date_diff('day',u.joined_at,cu.created_at)>0 and date_diff('day',u.joined_at,cu.created_at)<=3 Then 'Day 1-3'
      When date_diff('day',u.joined_at,cu.created_at)>3 and date_diff('day',u.joined_at,cu.created_at)<=7 then 'Day 4-7'
      When date_diff('day',u.joined_at,cu.created_at)>8 and date_diff('day',u.joined_at,cu.created_at)<=15 Then 'Day 8-15'
      when date_diff('day',u.joined_at,cu.created_at)>16 and date_diff('day',u.joined_at,cu.created_at)<=30 Then 'Day 16-30'
      when date_diff('day',u.joined_at,cu.created_at)>30 and date_diff('day',u.joined_at,cu.created_at)<=60 then 'Day 31-60'
      when date_diff('day',u.joined_at,cu.created_at)>60 and date_diff('day',u.joined_at,cu.created_at)<=120 then 'Day 61-120'
      when date_diff('day',u.joined_at,cu.created_at)>121 and date_diff('day',u.joined_at,cu.created_at)<=240 then 'Day 121-240'
      when date_diff('day',u.joined_at,cu.created_at)>241 and date_diff('day',u.joined_at,cu.created_at)<=360 then 'Day 241-360'
      ELSE 'Day 361+' END as cohort
      ,case when date_diff('day',u.joined_at,cu.created_at)>=0 and date_diff('day',u.joined_at,cu.created_at)<=7 then 'Day 7'
      else 'N' end as day7payer
      ,s.id as story_id
      ,s.title
      ,cb.type as sales_type
      ,count(distinct cu.user_id) Payers
      ,sum(cu.amount) as coins
      from mysql.gatsby.users u

      left join mysql.gatsby.coin_usages cu
      on u.id=cu.user_id

      left join mysql.gatsby.stories s
      on cu.story_id = s.id

      left join mysql.gatsby.episodes e
      on cu.episode_id = e.id

      left join
      (select id,type
      from mysql.gatsby.coin_balances cb
      )cb
      on cb.id = cu.coin_balance_id

      left join mysql.gatsby.transfer_story_coin_values tscv
      on tscv.story_id=s.id


      where cast(cu.created_at + interval '5' hour as date)>=cast(date_add('day',-30,now()) as date)
      and s.id={% parameter story_id %}
      group by 1,2,3,4,5,6
      )

      select
      created_at
      ,story_id
      ,title
      ,sales_type
      ,element_at(cp,'Day 0') as "Day 0"
      ,element_at(cp,'Day 1-3') as "Day 1-3"
      ,element_at(cp,'Day 4-7') as "Day 4-7"
      ,element_at(cp,'Day 8-15') as "Day 8-15"
      ,element_at(cp,'Day 16-30') as "Day 16-30"
      ,element_at(cp,'Day 31-60') as "Day 31-60"
      ,element_at(cp,'Day 61-120') as "Day 61-120"
      ,element_at(cp,'Day 121-240') as "Day 121-240"
      ,element_at(cp,'Day 241-360') as "Day 241-360"
      ,element_at(cp,'Day 361+') as "Day 361 Plus"
      ,element_at(cc,'Day 0') as "Day 0 Coins"
      ,element_at(cc,'Day 1-3') as "Day 1-3 Coins"
      ,element_at(cc,'Day 4-7') as "Day 4-7 Coins"
      ,element_at(cc,'Day 8-15') as "Day 8-15 Coins"
      ,element_at(cc,'Day 16-30') as "Day 16-30 Coins"
      ,element_at(cc,'Day 31-60') as "Day 31-60 Coins"
      ,element_at(cc,'Day 61-120') as "Day 61-120 Coins"
      ,element_at(cc,'Day 121-240') as "Day 121-240 Coins"
      ,element_at(cc,'Day 241-360') as "Day 241-360 Coins"
      ,element_at(cc,'Day 361+') as "Day 361 Plus Coins"
      ,element_at(d7,'Day 7') as "Day 7 Payers"





      from
      (
      select created_at,story_id,title,sales_type,map_agg(cohort,payers) cp,map_agg(cohort,coins) cc,map_agg(day7payer,payers) d7
      from mast
      group by 1,2,3,4
      )

       ;;
  }

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

  parameter: story_id {
    type: number
    default_value: "8602"
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: sales_type {
    type: string
    sql: ${TABLE}.sales_type ;;
  }

  dimension: paid_coins {
    type: yesno
    sql: ${sales_type}='one-time' or ${sales_type}='subscription' ;;
  }



  dimension: day_0 {
    type: number
    label: "Day 0"
    sql: ${TABLE}."Day 0" ;;
  }

  dimension: day_13 {
    type: number
    label: "Day 1-3"
    sql: ${TABLE}."Day 1-3" ;;
  }

  dimension: day_47 {
    type: number
    label: "Day 4-7"
    sql: ${TABLE}."Day 4-7" ;;
  }

  dimension: day_815 {
    type: number
    label: "Day 8-15"
    sql: ${TABLE}."Day 8-15" ;;
  }

  dimension: day_1630 {
    type: number
    label: "Day 16-30"
    sql: ${TABLE}."Day 16-30" ;;
  }

  dimension: day_3160 {
    type: number
    label: "Day 31-60"
    sql: ${TABLE}."Day 31-60" ;;
  }

  dimension: day_61120 {
    type: number
    label: "Day 61-120"
    sql: ${TABLE}."Day 61-120" ;;
  }

  dimension: day_121240 {
    type: number
    label: "Day 121-240"
    sql: ${TABLE}."Day 121-240" ;;
  }

  dimension: day_241360 {
    type: number
    label: "Day 241-360"
    sql: ${TABLE}."Day 241-360" ;;
  }

  dimension: day_361_plus {
    type: number
    label: "Day 361 Plus"
    sql: ${TABLE}."Day 361 Plus" ;;
  }

  dimension: day_0_coins {
    type: number
    label: "Day 0 Coins"
    sql: ${TABLE}."Day 0 Coins" ;;
  }

  dimension: day_13_coins {
    type: number
    label: "Day 1-3 Coins"
    sql: ${TABLE}."Day 1-3 Coins" ;;
  }

  dimension: day_47_coins {
    type: number
    label: "Day 4-7 Coins"
    sql: ${TABLE}."Day 4-7 Coins" ;;
  }

  dimension: day_815_coins {
    type: number
    label: "Day 8-15 Coins"
    sql: ${TABLE}."Day 8-15 Coins" ;;
  }

  dimension: day_1630_coins {
    type: number
    label: "Day 16-30 Coins"
    sql: ${TABLE}."Day 16-30 Coins" ;;
  }

  dimension: day_3160_coins {
    type: number
    label: "Day 31-60 Coins"
    sql: ${TABLE}."Day 31-60 Coins" ;;
  }

  dimension: day_61120_coins {
    type: number
    label: "Day 61-120 Coins"
    sql: ${TABLE}."Day 61-120 Coins" ;;
  }

  dimension: day_121240_coins {
    type: number
    label: "Day 121-240 Coins"
    sql: ${TABLE}."Day 121-240 Coins" ;;
  }

  dimension: day_241360_coins {
    type: number
    label: "Day 241-360 Coins"
    sql: ${TABLE}."Day 241-360 Coins" ;;
  }

  dimension: day_361_plus_coins {
    type: number
    label: "Day 361 Plus Coins"
    sql: ${TABLE}."Day 361 Plus Coins" ;;
  }

  dimension: day7payers {
    type: number
    sql: ${TABLE}."Day 7 Payers" ;;
  }

  measure: Day0 {
    label: "Day 0"
    type: sum
    sql: ${day_0} ;;
  }
  measure: Day_1_3 {
    label: "Day 1~3"
    type: sum
    sql: ${day_13} ;;
  }
  measure: Day_4_7 {
    label: "Day 4~7"
    type: sum
    sql: ${day_47} ;;
  }
  measure: Day_8_15 {
    label: "Day 8~15"
    type: sum
    sql: ${day_815} ;;
  }
  measure: Day_16_30 {
    label: "Day 16~30"
    type: sum
    sql: ${day_1630} ;;
  }
  measure: Day_31_60 {
    label: "Day 31~60"
    type: sum
    sql: ${day_3160} ;;
  }
  measure: Day_61_120 {
    label: "Day 61~120"
    type: sum
    sql: ${day_61120} ;;
  }
  measure: Day_121_240 {
    label: "Day 121~240"
    type: sum
    sql: ${day_121240} ;;
  }
  measure: Day_241_360 {
    label: "Day 241~360"
    type: sum
    sql: ${day_241360} ;;
  }
  measure: Day_361 {
    label: "Day 361+"
    type: sum
    sql: ${day_361_plus} ;;
  }

  measure: Day0_Coins {
    label: "Day 0 Coins"
    type: sum
    sql: ${day_0_coins} ;;
  }
  measure: Day_1_3_Coins {
    label: "Day 1~3 Coins"
    type: sum
    sql: ${day_13_coins} ;;
  }
  measure: Day_4_7_Coins {
    label: "Day 4~7 Coins"
    type: sum
    sql: ${day_47_coins} ;;
  }
  measure: Day_8_15_Coins {
    label: "Day 8~15 Coins"
    type: sum
    sql: ${day_815_coins} ;;
  }
  measure: Day_16_30_Coins {
    label: "Day 16~30 Coins"
    type: sum
    sql: ${day_1630_coins} ;;
  }
  measure: Day_31_60_Coins {
    label: "Day 31~60 Coins"
    type: sum
    sql: ${day_3160_coins} ;;
  }
  measure: Day_61_120_Coins {
    label: "Day 61~120 Coins"
    type: sum
    sql: ${day_61120_coins} ;;
  }
  measure: Day_121_240_Coins {
    label: "Day 121~240 Coins"
    type: sum
    sql: ${day_121240_coins} ;;
  }
  measure: Day_241_360_Coins {
    label: "Day 241~360 Coins"
    type: sum
    sql: ${day_241360_coins} ;;
  }
  measure: Day_361_Coins {
    label: "Day 361+ Coins"
    type: sum
    sql: ${day_361_plus_coins} ;;
  }

  measure: Day_7_Payers {
    label: "Day 7 Payers"
    type: sum
    sql: ${day7payers} ;;
  }

}
