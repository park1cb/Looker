view: story_revenue_and_costs_by_cohort_raw_data {
  derived_table: {
    sql: select a.created_at
            ,e.joined_at
            ,a.user_id
            ,d.string_id
            ,a.story_id
            ,c.title
            ,a.episode_id
            ,a.amount
            ,f.type
            ,case when f.type in ('one-time','subscription') then 0.12 else 0 end*0.7*a.amount as revenue
            ,case
              when c.writer_id = 705918 then 0
              when b.story_id is null then 0.042
              when b.story_id is not null and date_parse(cast(b.apply_month as varchar),'%Y%m') > a.created_at then 0.042
              else b.value end as "value"
            ,a.amount*  case
              when c.writer_id = 705918 then 0
              when b.story_id is null then 0.042
              when b.story_id is not null and date_parse(cast(b.apply_month as varchar),'%Y%m') > a.created_at then 0.042
              else b.value end as cost
            ,case when date_diff('hour',e.joined_at,a.created_at)/24<=7 then 7
            --When date_diff('hour',e.joined_at,a.created_at)/24>0 and date_diff('hour',e.joined_at,a.created_at)/24<=3 Then 3
            --When date_diff('hour',e.joined_at,a.created_at)/24>7 and date_diff('hour',e.joined_at,a.created_at)/24<=15 then 15
            When date_diff('hour',e.joined_at,a.created_at)/24>7 and date_diff('hour',e.joined_at,a.created_at)/24<=30 Then 30
            when date_diff('hour',e.joined_at,a.created_at)/24>30 and date_diff('hour',e.joined_at,a.created_at)/24<=120 Then 120
            when date_diff('hour',e.joined_at,a.created_at)/24>120 and date_diff('hour',e.joined_at,a.created_at)/24<=360 then 360
            --when date_diff('hour',e.joined_at,a.created_at)/24>60 and date_diff('hour',e.joined_at,a.created_at)/24<=120 then 120
            --when date_diff('hour',e.joined_at,a.created_at)/24>121 and date_diff('hour',e.joined_at,a.created_at)/24<=240 then 240
            --when date_diff('hour',e.joined_at,a.created_at)/24>241 and date_diff('hour',e.joined_at,a.created_at)/24<=360 then 360
            ELSE 361 END as cohort

            from mysql.gatsby.coin_usages a
            left join mysql.gatsby.transfer_story_coin_values b on a.story_id = b.story_id
            left join mysql.gatsby.stories c on a.story_id = c.id
            left join mysql.gatsby.users d on c.writer_id = d.id
            join mysql.gatsby.users e on e.id=a.user_id
            join mysql.gatsby.coin_balances f on f.id=a.coin_balance_id

 ;;
  }

  suggestions: no



  dimension_group: created_at {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: joined_at {
    type: time
    sql: ${TABLE}.joined_at ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: string_id {
    type: string
    sql: ${TABLE}.string_id ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: episode_id {
    type: number
    sql: ${TABLE}.episode_id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: revenue {
    type: number
    sql: ${TABLE}.revenue ;;
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: cohort {
    type: number
    sql: ${TABLE}.cohort ;;
  }

  measure: total_cost {
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
  }

  measure: total_revenue {
    type: sum
    sql: ${revenue} ;;
    value_format_name: usd
  }

  measure: episode_count {
    type: number
    sql: count(${episode_id}) ;;
  }




}
