view: best_performing_converter {
  derived_table: {
    sql: with mast as
          (
          select *
          from ${best_performing_converter_raw_data.SQL_TABLE_NAME} a
          where story_id=8602
          )


            select
            base_date_est
            ,story_id
            ,element_at(cp,'Day 0') as "Day 0"
            ,element_at(cp,'Day 1-3') as "Day 1-3"
            ,element_at(cp,'Day 4-7') as "Day 4-7"
            ,element_at(cp,'Day 8-15') as "Day 8-15"
            ,element_at(cp,'Day 16-30') as "Day 16-30"
            ,element_at(cp,'Day 31-120') as "Day 31-120"
            ,element_at(cp,'Day 121+') as "Day 121 Plus"
            ,element_at(cc,'Day 0') as "Day 0 pacakge"
            ,element_at(cc,'Day 1-3') as "Day 1-3 pacakge"
            ,element_at(cc,'Day 4-7') as "Day 4-7 pacakge"
            ,element_at(cc,'Day 8-15') as "Day 8-15 pacakge"
            ,element_at(cc,'Day 16-30') as "Day 16-30 pacakge"
            ,element_at(cc,'Day 31-120') as "Day 31-120 pacakge"
            ,element_at(cc,'Day 121+') as "Day 121 Plus pacakge"




            from
            (
            select base_date_est,story_id,map_agg(cohort,paying_users) cp,map_agg(cohort,amount) cc--,map_agg(day7payer,payers) d7
            from mast
            group by 1,2)
       ;;
  }

  suggestions: no



  dimension_group: base_date_est {
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
    sql: ${TABLE}.base_date_est ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
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

  dimension: day_121_plus {
    type: number
    label: "Day 121 Plus"
    sql: ${TABLE}."Day 121 Plus" ;;
  }

  dimension: day_0_pacakge {
    type: number
    label: "Day 0 pacakge"
    sql: ${TABLE}."Day 0 pacakge" ;;
  }

  dimension: day_13_pacakge {
    type: number
    label: "Day 1-3 pacakge"
    sql: ${TABLE}."Day 1-3 pacakge" ;;
  }

  dimension: day_47_pacakge {
    type: number
    label: "Day 4-7 pacakge"
    sql: ${TABLE}."Day 4-7 pacakge" ;;
  }

  dimension: day_815_pacakge {
    type: number
    label: "Day 8-15 pacakge"
    sql: ${TABLE}."Day 8-15 pacakge" ;;
  }

  dimension: day_1630_pacakge {
    type: number
    label: "Day 16-30 pacakge"
    sql: ${TABLE}."Day 16-30 pacakge" ;;
  }

  dimension: day_31120_pacakge {
    type: number
    label: "Day 31-120 pacakge"
    sql: ${TABLE}."Day 31-120 pacakge" ;;
  }

  dimension: day_121_plus_pacakge {
    type: number
    label: "Day 121 Plus pacakge"
    sql: ${TABLE}."Day 121 Plus pacakge" ;;
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
  measure: Day_31_120 {
    label: "Day 31~120"
    type: sum
    sql: ${day_31120} ;;
  }

  measure: Day_121 {
    label: "Day 121+"
    type: sum
    sql: ${day_121_plus} ;;
  }

  measure: Day0_pacakge {
    label: "Day 0 pacakge"
    type: sum
    sql: ${day_0_pacakge} ;;
    value_format_name: usd
  }
  measure: Day_1_3_pacakge {
    label: "Day 1~3 pacakge"
    type: sum
    sql: ${day_13_pacakge} ;;
    value_format_name: usd
  }
  measure: Day_4_7_pacakge {
    label: "Day 4~7 pacakge"
    type: sum
    sql: ${day_47_pacakge} ;;
    value_format_name: usd
  }
  measure: Day_8_15_pacakge {
    label: "Day 8~15 pacakge"
    type: sum
    sql: ${day_815_pacakge} ;;
    value_format_name: usd
  }
  measure: Day_16_30_pacakge {
    label: "Day 16~30 pacakge"
    type: sum
    sql: ${day_1630_pacakge} ;;
    value_format_name: usd
  }
  measure: Day_31_120_pacakge {
    label: "Day 31~120 pacakge"
    type: sum
    sql: ${day_31120_pacakge} ;;
    value_format_name: usd
  }

  measure: Day_121_pacakge {
    label: "Day 121+ pacakge"
    type: sum
    sql: ${day_121_plus_pacakge} ;;
    value_format_name: usd
  }


}
