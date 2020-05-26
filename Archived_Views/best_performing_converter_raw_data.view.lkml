view: best_performing_converter_raw_data {
  derived_table: {
    sql: select
      conv.base_date_est
      ,story_id
      ,case when date_diff('hour',user.joined_at,conv.purchased_at)/24=0 then 'Day 0'
            When date_diff('hour',user.joined_at,conv.purchased_at)/24>0 and date_diff('hour',user.joined_at,conv.purchased_at)/24<=3 Then 'Day 1-3'
            When date_diff('hour',user.joined_at,conv.purchased_at)/24>3 and date_diff('hour',user.joined_at,conv.purchased_at)/24<=7 then 'Day 4-7'
            When date_diff('hour',user.joined_at,conv.purchased_at)/24>8 and date_diff('hour',user.joined_at,conv.purchased_at)/24<=15 Then 'Day 8-15'
            when date_diff('hour',user.joined_at,conv.purchased_at)/24>16 and date_diff('hour',user.joined_at,conv.purchased_at)/24<=30 Then 'Day 16-30'
            when date_diff('hour',user.joined_at,conv.purchased_at)/24>30 and date_diff('hour',user.joined_at,conv.purchased_at)/24<=120 then 'Day 31-120'
             ELSE 'Day 121+' END as cohort
      ,count(distinct conv.user_id) as paying_users
      ,sum(price) as amount
      from hive.dm.converter_stories conv

      join mysql.gatsby.users user
      on user.id=conv.user_id
      where conv.base_date_est>=date_add('month',-6,now())
      group by 1,2,3
       ;;
    sql_trigger_value: select date_trunc('hour',now());;
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

  dimension: cohort {
    type: string
    sql: ${TABLE}.cohort ;;
  }

  dimension: paying_users {
    type: number
    sql: ${TABLE}.paying_users ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }


}
