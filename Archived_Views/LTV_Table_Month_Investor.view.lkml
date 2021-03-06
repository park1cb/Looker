explore: ltv_table_month_investor {}
view: ltv_table_month_investor {
    derived_table: {
      sql: with LTV as
            (
select
date_format(date_trunc('Month',users.date),'%Y-%m') as date

,day
,element_at(kv,'Organic')+element_at(kv,'Paid') as new_users
,
COALESCE((COALESCE(element_at(kr,'Organic'),0) +  COALESCE(element_at(kr,'Paid'),0))/( COALESCE(element_at(kv,'Organic'),0)+ COALESCE(element_at(kv,'Paid'),0)),0)
as Value
from
(
  select
  date
  ,map_agg(network,new_users)  as kv
  from
  (
    select
    cast(a.joined_at as date) as date
    ,case when network.network_name='Organic' or network.network_name is null then 'Organic' else 'Paid' End as network
    ,count(distinct a.id) as new_users
    from mysql.gatsby.users a
    left join mysql.gatsby.pre_signin_users b
    on a.id = b.pre_user_id
    left join
    (
      select
      adid.user_id
      ,adj.network_name--,network_name
      from mart.mart.user_mapper_adjust adj
      join mart.mart.user_mapper_adjust_id adid
      on adid.adjust_id=adj.adid
      join
      (
        select distinct user_id,min(installed_at) as installed_at
        from mart.mart.user_mapper_adjust adj
        join mart.mart.user_mapper_adjust_id adid
        on adid.adjust_id=adj.adid
        where activity_kind='install'
        and user_id<>0
        group by 1
      )firstdate
      on firstdate.user_id=adid.user_id
      and adj.installed_at=firstdate.installed_at
      where activity_kind='install'
      and adid.user_id<>0
    )network
    on network.user_id=a.id
    where b.pre_user_id is null
    group by 1,2
  )
  group by 1
)users







left join
(
  select
  date
  ,day
  ,map_agg(network,revenue) as kr
  from
  (
    select
    cast(a.joined_at as date) as date
    ,case when network.network_name='Organic' or network.network_name is null then 'Organic' else 'Paid' End as network
    ,date_diff('day',a.joined_at,paid.created_at) as day
    ,sum(pd.original_price)*0.7 as revenue
    from mysql.gatsby.users a
    left join mysql.gatsby.pre_signin_users b
    on a.id = b.pre_user_id
    left join mysql.gatsby.paid_coin_issues paid
    on paid.user_id=a.id
    left join mysql.gatsby.products pd
    on pd.id=paid.product_id
    left join
    (
      select
      adid.user_id
      ,adj.network_name--,network_name
      from mart.mart.user_mapper_adjust adj
      join mart.mart.user_mapper_adjust_id adid
      on adid.adjust_id=adj.adid
      join
      (
        select distinct user_id,min(installed_at) as installed_at
        from mart.mart.user_mapper_adjust adj
        join mart.mart.user_mapper_adjust_id adid
        on adid.adjust_id=adj.adid
        where activity_kind='install'
        and user_id<>0
        group by 1
      )firstdate
      on firstdate.user_id=adid.user_id
      and adj.installed_at=firstdate.installed_at
      where activity_kind='install'
      and adid.user_id<>0
    )network
    on network.user_id=a.id
    where b.pre_user_id is null
    group by 1,2,3
  )
  group by 1,2

)revenue
on users.date=revenue.date

where day>=0
            )

      ,test as
      (
      select date,day,avg(Value) as Value
            from LTV
            group by 1,2
            )
      , months as
      (
      select
      Day
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-17,now())),'%Y-%m')) as Month17
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-16,now())),'%Y-%m')) as Month16

      ,element_at(kv,date_format(date_trunc('month',date_add('month',-15,now())),'%Y-%m')) as Month15
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-14,now())),'%Y-%m')) as Month14

      ,element_at(kv,date_format(date_trunc('month',date_add('month',-13,now())),'%Y-%m')) as Month13
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-12,now())),'%Y-%m')) as Month12
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-11,now())),'%Y-%m')) as Month11
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-10,now())),'%Y-%m')) as Month10
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-9,now())),'%Y-%m')) as Month9
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-8,now())),'%Y-%m')) as Month8
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-7,now())),'%Y-%m')) as Month7
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-6,now())),'%Y-%m')) as Month6
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-5,now())),'%Y-%m')) as Month5
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-4,now())),'%Y-%m')) as Month4
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-3,now())),'%Y-%m')) as Month3
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-2,now())),'%Y-%m')) as Month2
      ,element_at(kv,date_format(date_trunc('month',date_add('month',-1,now())),'%Y-%m')) as Month1
      ,element_at(kv,date_format(date_trunc('month',date_add('month',0,now())),'%Y-%m')) as Month0
      from
      (
      select Day,map_agg(date,value) kv
      from test
      group by 1
        )
      )
      , running_totals as
      (
      select
      Day
      , sum(Month17) over (order by Day asc) as RunningMonth17

      , sum(Month16) over (order by Day asc) as RunningMonth16
      , sum(Month15) over (order by Day asc) as RunningMonth15
      , sum(Month14) over (order by Day asc) as RunningMonth14
      , sum(Month13) over (order by Day asc) as RunningMonth13
      , sum(Month12) over (order by Day asc) as RunningMonth12
      , sum(Month11) over (order by Day asc) as RunningMonth11
      , sum(Month10) over (order by Day asc) as RunningMonth10
      , sum(Month9) over (order by Day asc) as RunningMonth9
      , sum(Month8) over (order by Day asc) as RunningMonth8
      , sum(Month7) over (order by Day asc) as RunningMonth7
      , sum(Month6) over (order by Day asc) as RunningMonth6
      , sum(Month5) over (order by Day asc) as RunningMonth5
      , sum(Month4) over (order by Day asc) as RunningMonth4
      , sum(Month3) over (order by Day asc) as RunningMonth3
      , sum(Month2) over (order by Day asc) as RunningMonth2
      , sum(Month1) over (order by Day asc) as RunningMonth1
      , sum(Month0) over (order by Day asc) as RunningMonth0
      from months
      )
      select
      Day
      , RunningMonth17
      , lag(RunningMonth17) over (order by Day asc) as RunningMonth17_prev_day
      , RunningMonth16
      , lag(RunningMonth16) over (order by Day asc) as RunningMonth16_prev_day
      , RunningMonth15
      , lag(RunningMonth15) over (order by Day asc) as RunningMonth15_prev_day
      , RunningMonth14
      , lag(RunningMonth14) over (order by Day asc) as RunningMonth14_prev_day
      , RunningMonth13
      , lag(RunningMonth13) over (order by Day asc) as RunningMonth13_prev_day
      , RunningMonth12
      , lag(RunningMonth12) over (order by Day asc) as RunningMonth12_prev_day
      , RunningMonth11
      , lag(RunningMonth11) over (order by Day asc) as RunningMonth11_prev_day
      , RunningMonth10
      , lag(RunningMonth10) over (order by Day asc) as RunningMonth10_prev_day
      , RunningMonth9
      , lag(RunningMonth9) over (order by Day asc) as RunningMonth9_prev_day

      , RunningMonth8
      , lag(RunningMonth8) over (order by Day asc) as RunningMonth8_prev_day
      , RunningMonth7
      , lag(RunningMonth7) over (order by Day asc) as RunningMonth7_prev_day
      , RunningMonth6
      , lag(RunningMonth6) over (order by Day asc) as RunningMonth6_prev_day
      , RunningMonth5
      , lag(RunningMonth5) over (order by Day asc) as RunningMonth5_prev_day
      , RunningMonth4
      , lag(RunningMonth4) over (order by Day asc) as RunningMonth4_prev_day
      , RunningMonth3
      , lag(RunningMonth3) over (order by Day asc) as RunningMonth3_prev_day
      , RunningMonth2
      , lag(RunningMonth2) over (order by Day asc) as RunningMonth2_prev_day
      , RunningMonth1
      , lag(RunningMonth1) over (order by Day asc) as RunningMonth1_prev_day
      , RunningMonth0
      , lag(RunningMonth0) over (order by Day asc) as RunningMonth0_prev_day
      from running_totals
 ;;
    }

    suggestions: no

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    parameter: network_filter{
      type: string
      allowed_value: { value: "Organic"}
      allowed_value: { value: "Paid" }
      allowed_value: { value: "Everything" }
    }

    dimension: day {
      type: number
      sql: ${TABLE}."Day" ;;
    }

  dimension: running_month17 {
    type: number
    sql: ${TABLE}.RunningMonth17 ;;
    hidden: yes
  }

  dimension: running_month17_prev_day {
    type: number
    sql: ${TABLE}.RunningMonth17_prev_day ;;
    hidden: yes
  }

  dimension: running_month16 {
    type: number
    sql: ${TABLE}.RunningMonth16 ;;
    hidden: yes
  }

  dimension: running_month16_prev_day {
    type: number
    sql: ${TABLE}.RunningMonth16_prev_day ;;
    hidden: yes
  }

  dimension: running_month15 {
    type: number
    sql: ${TABLE}.RunningMonth15 ;;
    hidden: yes
  }

  dimension: running_month15_prev_day {
    type: number
    sql: ${TABLE}.RunningMonth15_prev_day ;;
    hidden: yes
  }

  dimension: running_month14 {
    type: number
    sql: ${TABLE}.RunningMonth14 ;;
    hidden: yes
  }

  dimension: running_month14_prev_day {
    type: number
    sql: ${TABLE}.RunningMonth14_prev_day ;;
    hidden: yes
  }

  dimension: running_month13 {
    type: number
    sql: ${TABLE}.RunningMonth13 ;;
    hidden: yes
  }

  dimension: running_month13_prev_day {
    type: number
    sql: ${TABLE}.RunningMonth13_prev_day ;;
    hidden: yes
  }

  dimension: running_month12 {
    type: number
    sql: ${TABLE}.RunningMonth12 ;;
    hidden: yes
  }

  dimension: running_month12_prev_day {
    type: number
    sql: ${TABLE}.RunningMonth12_prev_day ;;
    hidden: yes
  }

  dimension: running_month11 {
    type: number
    sql: ${TABLE}.RunningMonth11 ;;
    hidden: yes
  }

  dimension: running_month11_prev_day {
    type: number
    sql: ${TABLE}.RunningMonth11_prev_day ;;
    hidden: yes
  }

  dimension: running_month10 {
    type: number
    sql: ${TABLE}.RunningMonth10 ;;
    hidden: yes
  }

  dimension: running_month10_prev_day {
    type: number
    sql: ${TABLE}.RunningMonth10_prev_day ;;
    hidden: yes
  }

  dimension: running_month9 {
    type: number
    sql: ${TABLE}.RunningMonth9 ;;
    hidden: yes
  }

  dimension: running_month9_prev_day {
    type: number
    sql: ${TABLE}.RunningMonth9_prev_day ;;
    hidden: yes
  }


    dimension: running_month8 {
      type: number
      sql: ${TABLE}.RunningMonth8 ;;
      hidden: yes
    }

    dimension: running_month8_prev_day {
      type: number
      sql: ${TABLE}.RunningMonth8_prev_day ;;
      hidden: yes
    }

    dimension: running_month7 {
      type: number
      sql: ${TABLE}.RunningMonth7 ;;
      hidden: yes
    }

    dimension: running_month7_prev_day {
      type: number
      sql: ${TABLE}.RunningMonth7_prev_day ;;
      hidden: yes
    }

    dimension: running_month6 {
      type: number
      sql: ${TABLE}.RunningMonth6 ;;
      hidden: yes
    }

    dimension: running_month6_prev_day {
      type: number
      sql: ${TABLE}.RunningMonth6_prev_day ;;
      hidden: yes
    }

    dimension: running_month5 {
      type: number
      sql: ${TABLE}.RunningMonth5 ;;
      hidden: yes
    }

    dimension: running_month5_prev_day {
      type: number
      sql: ${TABLE}.RunningMonth5_prev_day ;;
      hidden: yes
    }

    dimension: running_month4 {
      type: number
      sql: ${TABLE}.RunningMonth4 ;;
      hidden: yes
    }

    dimension: running_month4_prev_day {
      type: number
      sql: ${TABLE}.RunningMonth4_prev_day ;;
      hidden: yes
    }

    dimension: running_month3 {
      type: number
      sql: ${TABLE}.RunningMonth3 ;;
      hidden: yes
    }

    dimension: running_month3_prev_day {
      type: number
      sql: ${TABLE}.RunningMonth3_prev_day ;;
      hidden: yes
    }

    dimension: running_month2 {
      type: number
      sql: ${TABLE}.RunningMonth2 ;;
      hidden: yes
    }

    dimension: running_month2_prev_day {
      type: number
      sql: ${TABLE}.RunningMonth2_prev_day ;;
      hidden: yes
    }

    dimension: running_month1 {
      type: number
      sql: ${TABLE}.RunningMonth1 ;;
      hidden: yes
    }

    dimension: running_month1_prev_day {
      type: number
      sql: ${TABLE}.RunningMonth1_prev_day ;;
      hidden: yes
    }

    dimension: running_month0 {
      type: number
      sql: ${TABLE}.RunningMonth0 ;;
      hidden: yes
    }

    dimension: running_month0_prev_day {
      type: number
      sql: ${TABLE}.RunningMonth0_prev_day ;;
      hidden: yes
    }

  dimension: running_month17_formatted {
    type: number
    sql: case when ${running_month17} = ${running_month17_prev_day} then null
      else ${running_month17} end ;;
    value_format_name: usd
    hidden: yes
  }

  dimension: running_month16_formatted {
    type: number
    sql: case when ${running_month16} = ${running_month16_prev_day} then null
      else ${running_month16} end ;;
    value_format_name: usd
    hidden: yes
  }

  dimension: running_month15_formatted {
    type: number
    sql: case when ${running_month15} = ${running_month15_prev_day} then null
      else ${running_month15} end ;;
    value_format_name: usd
    hidden: yes
  }

  dimension: running_month14_formatted {
    type: number
    sql: case when ${running_month14} = ${running_month14_prev_day} then null
      else ${running_month14} end ;;
    value_format_name: usd
    hidden: yes
  }

  dimension: running_month13_formatted {
    type: number
    sql: case when ${running_month13} = ${running_month13_prev_day} then null
      else ${running_month13} end ;;
    value_format_name: usd
    hidden: yes
  }

  dimension: running_month12_formatted {
    type: number
    sql: case when ${running_month12} = ${running_month12_prev_day} then null
      else ${running_month12} end ;;
    value_format_name: usd
    hidden: yes
  }

  dimension: running_month11_formatted {
    type: number
    sql: case when ${running_month11} = ${running_month11_prev_day} then null
      else ${running_month11} end ;;
    value_format_name: usd
    hidden: yes
  }

  dimension: running_month10_formatted {
    type: number
    sql: case when ${running_month10} = ${running_month10_prev_day} then null
      else ${running_month10} end ;;
    value_format_name: usd
    hidden: yes
  }

  dimension: running_month9_formatted {
    type: number
    sql: case when ${running_month9} = ${running_month9_prev_day} then null
      else ${running_month9} end ;;
    value_format_name: usd
    hidden: yes
  }

    dimension: running_month8_formatted {
      type: number
      sql: case when ${running_month8} = ${running_month8_prev_day} then null
        else ${running_month8} end ;;
      value_format_name: usd
      hidden: yes
    }

    dimension: running_month7_formatted {
      type: number
      sql: case when ${running_month7} = ${running_month7_prev_day} then null
        else ${running_month7} end ;;
      value_format_name: usd
      hidden: yes
    }

    dimension: running_month6_formatted {
      type: number
      sql: case when ${running_month6} = ${running_month6_prev_day} then null
        else ${running_month6} end ;;
      value_format_name: usd
      hidden: yes
    }

    dimension: running_month5_formatted {
      type: number
      sql: case when ${running_month5} = ${running_month5_prev_day} then null
        else ${running_month5} end ;;
      value_format_name: usd
      hidden: yes
    }

    dimension: running_month4_formatted {
      type: number
      sql: case when ${running_month4} = ${running_month4_prev_day} then null
        else ${running_month4} end ;;
      value_format_name: usd
      hidden: yes
    }

    dimension: running_month3_formatted {
      type: number
      sql: case when ${running_month3} = ${running_month3_prev_day} then null
        else ${running_month3} end ;;
      value_format_name: usd
      hidden: yes
    }

    dimension: running_month2_formatted {
      type: number
      sql: case when ${running_month2} = ${running_month2_prev_day} then null
        else ${running_month2} end ;;
      value_format_name: usd
      hidden: yes
    }

    dimension: running_month1_formatted {
      type: number
      sql: case when ${running_month1} = ${running_month1_prev_day} then null
        else ${running_month1} end ;;
      value_format_name: usd
      hidden: yes
    }

    dimension: running_month0_formatted {
      type: number
      sql: case when ${running_month0} = ${running_month0_prev_day} then null
        else ${running_month0} end ;;
      value_format_name: usd
      hidden: yes
    }

    measure: Month0 {
      type: average
      label: "Month 0"
      sql: ${running_month0_formatted} ;;
      value_format: "$#0.####"
    }

    measure: Month1 {
      type: average
      label: "Month 1"
      sql: ${running_month1_formatted} ;;
      value_format: "$#0.####"
    }


    measure: Month2 {
      type: average
      label: "Month 2"
      sql: ${running_month2_formatted} ;;
      value_format: "$#0.####"
    }

    measure: Month3 {
      type: average
      label: "Month 3"
      sql: ${running_month3_formatted} ;;
      value_format: "$#0.####"
    }

    measure: Month4 {
      type: average
      label: "Month 4"
      sql: ${running_month4_formatted} ;;
      value_format: "$#0.####"
    }

    measure: Month5 {
      type: average
      label: "Month 5"
      sql: ${running_month5_formatted} ;;
      value_format: "$#0.####"
    }

    measure: Month6 {
      type: average
      label: "Month 6"
      sql: ${running_month6_formatted} ;;
      value_format: "$#0.####"
    }

    measure: Month7 {
      type: average
      label: "Month 7"
      sql: ${running_month7_formatted} ;;
      value_format: "$#0.####"
    }

    measure: Month8 {
      type: average
      label: "Month 8"
      sql: ${running_month8_formatted} ;;
      value_format: "$#0.####"
    }
    measure: Month9 {
      type: average
      label: "Month 9"
      sql: ${running_month9_formatted} ;;
      value_format: "$#0.####"
    }
    measure: Month10 {
      type: average
      label: "Month 10"
      sql: ${running_month10_formatted} ;;
      value_format: "$#0.####"
    }
    measure: Month11 {
      type: average
      label: "Month 11"
      sql: ${running_month11_formatted} ;;
      value_format: "$#0.####"
    }
    measure: Month12 {
      type: average
      label: "Month 12"
      sql: ${running_month12_formatted} ;;
      value_format: "$#0.####"
    }
    measure: Month13 {
      type: average
      label: "Month 13"
      sql: ${running_month13_formatted} ;;
      value_format: "$#0.####"
    }
    measure: Month14 {
      type: average
      label: "Month 14"
      sql: ${running_month14_formatted} ;;
      value_format: "$#0.####"
    }
    measure: Month15 {
      type: average
      label: "Month 15"
      sql: ${running_month15_formatted} ;;
      value_format: "$#0.####"
    }

  measure: Month16 {
    type: average
    label: "Month 16"
    sql: ${running_month16_formatted} ;;
    value_format: "$#0.####"
  }

  measure: Month17 {
    type: average
    label: "Month 17"
    sql: ${running_month17_formatted} ;;
    value_format: "$#0.####"
  }


    set: detail {
      fields: [
        day,
        running_month8,
        running_month8_prev_day,
        running_month7,
        running_month7_prev_day,
        running_month6,
        running_month6_prev_day,
        running_month5,
        running_month5_prev_day,
        running_month4,
        running_month4_prev_day,
        running_month3,
        running_month3_prev_day,
        running_month2,
        running_month2_prev_day,
        running_month1,
        running_month1_prev_day,
        running_month0,
        running_month0_prev_day
      ]
    }
  }
