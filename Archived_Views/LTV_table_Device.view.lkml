view: ltv_table_device {
   derived_table: {
      sql:with LTV as
            (
select
date_format(date_trunc('Month',users.date),'%Y-%m') as date

,day
,users.organic_users+users.paid_users as new_users
,Case
when {% parameter network_filter %}='Organic' Then
  COALESCE(COALESCE(element_at(kr,'Organic'),0) /COALESCE(users.organic_users,0),0)
when {% parameter network_filter %}='Paid' Then
  COALESCE(COALESCE(element_at(kr,'Paid'),0) /COALESCE(users.paid_users,0),0)
when {% parameter network_filter %}='Everything' then
COALESCE((COALESCE(element_at(kr,'Organic'),0) +  COALESCE(element_at(kr,'Paid'),0))/( COALESCE(users.organic_users,0)+ COALESCE(users.paid_users,0)),0)
End as Value
from
(
select
date
,element_at(kv,'Organic') as Organic_Users
,element_at(kv,'Paid') as Paid_Users
from
(
  select
  date
  ,map_agg(network,new_users)  as kv
  from
  (
select cast(a.installed_at+interval '5' hour as date) as date
--,a.network
,case when a.network in ('Organic','Branch(iOS)','Branch(Android)') then 'Organic' Else 'Paid' end as Network

--,a.platform
,count( distinct case when a.platform='android' then device.adid when a.platform='ios' then coalesce(device.adid,device.idfv) end) as new_users
--,c.product_type
--,c.purchased_at
--,sum(c.price)

from mart.mart.install_attribution_adjust a
left join mart.mart.coin_purchased_devices c
on a.adjust_id=c.adjust_id

join mysql.gatsby.user_devices device
on a.adjust_id=device.adjust_id

where case when a.platform='android' then device.adid when a.platform='ios' then coalesce(device.adid,device.idfv) end<>'00000000-0000-0000-0000-000000000000'
group by 1,2--,3,4,5
order by 1 desc
  )
  group by 1
)

) users


left join
(
  select
  date
  ,day
  ,map_agg(network,revenue) as kr
  from
  (
select cast(a.installed_at+interval '5' hour as date) as date
--,a.network
,case when a.network in ('Organic','Branch(iOS)','Branch(Android)') then 'Organic' Else 'Paid' end as Network

,date_diff('hour',a.installed_at+interval '5' hour,c.purchased_at+interval '5' hour)/24 as day
--,count( distinct case when a.platform='android' then device.adid when a.platform='ios' then coalesce(device.adid,device.idfv) end) as device_id
--,c.product_type
--,c.purchased_at
,sum(c.price)*0.7 as revenue

from mart.mart.install_attribution_adjust a
left join mart.mart.coin_purchased_devices c
on a.adjust_id=c.adjust_id

join mysql.gatsby.user_devices device
on a.adjust_id=device.adjust_id

where case when a.platform='android' then device.adid when a.platform='ios' then coalesce(device.adid,device.idfv) end<>'00000000-0000-0000-0000-000000000000'
group by 1,2,3--,4--,5
order by 1 desc
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
      --,element_at(kv,date_format(date_trunc('month',date_add('month',-13,now())),'%Y-%m')) as Month13
      --,element_at(kv,date_format(date_trunc('month',date_add('month',-12,now())),'%Y-%m')) as Month12
      --,element_at(kv,date_format(date_trunc('month',date_add('month',-11,now())),'%Y-%m')) as Month11
      --,element_at(kv,date_format(date_trunc('month',date_add('month',-10,now())),'%Y-%m')) as Month10
      --,element_at(kv,date_format(date_trunc('month',date_add('month',-9,now())),'%Y-%m')) as Month9
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
