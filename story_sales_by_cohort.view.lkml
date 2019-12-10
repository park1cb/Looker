view: story_sales_by_cohort {
  derived_table: {
    sql: with mast as
    (

    select *
    from ${story_sales_by_cohort_raw_data.SQL_TABLE_NAME} a
    where story_id={% parameter story_id %}
    )


      select
      created_at
      ,story_id
      ,sales_type
      ,element_at(cp,'Day 0') as "Day 0"
      ,element_at(cp,'Day 1-3') as "Day 1-3"
      ,element_at(cp,'Day 4-7') as "Day 4-7"
      ,element_at(cp,'Day 8-15') as "Day 8-15"
      ,element_at(cp,'Day 16-30') as "Day 16-30"
      ,element_at(cp,'Day 31-120') as "Day 31-120"
      ,element_at(cp,'Day 121+') as "Day 121 Plus"
      ,element_at(cc,'Day 0') as "Day 0 Coins"
      ,element_at(cc,'Day 1-3') as "Day 1-3 Coins"
      ,element_at(cc,'Day 4-7') as "Day 4-7 Coins"
      ,element_at(cc,'Day 8-15') as "Day 8-15 Coins"
      ,element_at(cc,'Day 16-30') as "Day 16-30 Coins"
      ,element_at(cc,'Day 31-120') as "Day 31-120 Coins"
      ,element_at(cc,'Day 121+') as "Day 121 Plus Coins"




      from
      (
      select created_at,story_id,sales_type,map_agg(cohort,payers) cp,map_agg(cohort,coins) cc--,map_agg(day7payer,payers) d7
      from mast
      group by 1,2,3
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

  dimension: day_31120 {
    type: number
    label: "Day 31-120"
    sql: ${TABLE}."Day 31-120" ;;
  }

  #dimension: day_61120 {
  #  type: number
  #  label: "Day 61-120"
  #  sql: ${TABLE}."Day 61-120" ;;
  #}

  #dimension: day_121240 {
  #  type: number
  #  label: "Day 121-240"
  #  sql: ${TABLE}."Day 121-240" ;;
  #}

  #dimension: day_241360 {
  #  type: number
  #  label: "Day 241-360"
  #  sql: ${TABLE}."Day 241-360" ;;
  #}

  dimension: day_121_plus {
    type: number
    label: "Day 121 Plus"
    sql: ${TABLE}."Day 121 Plus" ;;
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

  dimension: day_31120_coins {
    type: number
    label: "Day 31-120 Coins"
    sql: ${TABLE}."Day 31-120 Coins" ;;
  }

  #dimension: day_61120_coins {
  #  type: number
  #  label: "Day 61-120 Coins"
  #  sql: ${TABLE}."Day 61-120 Coins" ;;
  #}

  #dimension: day_121240_coins {
  #  type: number
  #  label: "Day 121-240 Coins"
  #  sql: ${TABLE}."Day 121-240 Coins" ;;
  #}

  #dimension: day_241360_coins {
  #  type: number
  #  label: "Day 241-360 Coins"
  #  sql: ${TABLE}."Day 241-360 Coins" ;;
  #}

  dimension: day_121_plus_coins {
    type: number
    label: "Day 121 Plus Coins"
    sql: ${TABLE}."Day 121 Plus Coins" ;;
  }

  #dimension: day7payers {
  #  type: number
  #  sql: ${TABLE}."Day 7 Payers" ;;
  #}

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
  measure: Day_31_120 {
    label: "Day 31~120"
    type: sum
    sql: ${day_31120} ;;
  }
  #measure: Day_61_120 {
  #  label: "Day 61~120"
  #  type: sum
  #  sql: ${day_61120} ;;
  #}
  #measure: Day_121_240 {
  #  label: "Day 121~240"
  #  type: sum
  #  sql: ${day_121240} ;;
  #}
  #measure: Day_241_360 {
  #  label: "Day 241~360"
  #  type: sum
  #  sql: ${day_241360} ;;
  #}
  measure: Day_121 {
    label: "Day 121+"
    type: sum
    sql: ${day_121_plus} ;;
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
  measure: Day_31_120_Coins {
    label: "Day 31~120 Coins"
    type: sum
    sql: ${day_31120_coins} ;;
  }
  #measure: Day_61_120_Coins {
  #  label: "Day 61~120 Coins"
  #  type: sum
  #  sql: ${day_61120_coins} ;;
  #}
  #measure: Day_121_240_Coins {
  #  label: "Day 121~240 Coins"
  #  type: sum
  #  sql: ${day_121240_coins} ;;
  #}
  #measure: Day_241_360_Coins {
  #  label: "Day 241~360 Coins"
  #  type: sum
  #  sql: ${day_241360_coins} ;;
  #}
  measure: Day_121_Coins {
    label: "Day 121+ Coins"
    type: sum
    sql: ${day_121_plus_coins} ;;
  }

  #measure: Day_7_Payers {
  #  label: "Day 7 Payers"
  #  type: sum
  #  sql: ${day7payers} ;;
  #}

}
