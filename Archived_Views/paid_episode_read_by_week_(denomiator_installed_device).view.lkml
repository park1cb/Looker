view: paid_episode_read_by_week__denomiator_installed_device_ {
    derived_table: {
      sql: with paid_episode_read as
            (
select
date_trunc('week',users.installed_at) as date
,day
,users.organic_users+users.paid_users as new_users
,Case
when {% parameter network_filter %}='Organic' Then
  cast(COALESCE(element_at(kr,'Organic'),0) as double) /cast(nullif(COALESCE(users.organic_users,0),0) as double)
when {% parameter network_filter %}='Paid' Then
  cast(COALESCE(element_at(kr,'Paid'),0) as double) /cast(nullif(COALESCE(users.paid_users,0),0) as double)
when {% parameter network_filter %}='Everything' then
cast(( COALESCE(element_at(kr,'Organic'),0) +  COALESCE(element_at(kr,'Paid'),0)) as double)/cast(nullif(( COALESCE(users.organic_users,0)+ COALESCE(users.paid_users,0)),0) as double)
End as Value
from
(
select
installed_at
,element_at(kv,'Organic') as Organic_Users
,element_at(kv,'Paid') as Paid_Users
from
(
  select
  installed_at
  ,map_agg(network,new_installed_users)  as kv
  from
  (
    select cast(attributed_at + interval '5' hour as date) as installed_at
    ,case when network_name in ('Organic','Branch(iOS)','Branch(Android)') then 'Organic' else 'Paid' end as network
    ,count(adid) as new_installed_users

    from mart.mart.user_mapper_adjust
  ------------------------------------
   --and cohort=0
   --and story_id=8602
----------------------------------------
   group by 1,2

  )
  group by 1
)

) users


left join
(
  select
  installed_at
  ,day
  ,map_agg(network,episode_read) as kr
  from
  (
    select cast(a.installed_at+ interval '5' hour as date) installed_at,platform,purchased_user,network,cohort as day,sum(a.amount)/3 as episode_read
    from ${cohort_data_purchase_raw_data.SQL_TABLE_NAME} a
    join
    (
      select adjust_id
      ,cast(installed_at+interval '5' hour as date) as installed_at
      ,sum(amount) as amount
      , CASE WHEN
          PERCENT_RANK() OVER (PARTITION by cast(installed_at+interval '5' hour as date)  ORDER BY sum(amount) DESC)<.1 Then 'Top 10%'
          WHEN
          PERCENT_RANK() OVER (PARTITION by cast(installed_at+interval '5' hour as date)  ORDER BY sum(amount) DESC)<.2 Then 'Top 10%-20%'
          WHEN
          PERCENT_RANK() OVER (PARTITION by cast(installed_at+interval '5' hour as date)  ORDER BY sum(amount) DESC)<.4 Then 'Top 20%-40%'
          WHEN
          PERCENT_RANK() OVER (PARTITION by cast(installed_at+interval '5' hour as date)  ORDER BY sum(amount) DESC)<.6 Then 'Top 40%-60%'
          WHEN
          PERCENT_RANK() OVER (PARTITION by cast(installed_at+interval '5' hour as date)  ORDER BY sum(amount) DESC)<.8 Then 'Top 60%-80%'
          ELSE 'Top 80%-100%' end as percentile
      from ${cohort_data_purchase_raw_data.SQL_TABLE_NAME}
      where purchased_user='Y'
      group by 1,2
    )b
    on a.adjust_id=b.adjust_id
    where purchased_user='Y'
      {% if percentile._in_query %}
      and
      percentile = {% parameter percentile %}
      {% else %} {% endif %}

---------------------------
    --and story_id=8602
---------------------------
    group by 1,2,3,4,5
  )
  group by 1,2

)episode_read
on users.installed_at=episode_read.installed_at

where day>=0
            )

      ,test as
      (
      select date,day,avg(Value) as Value
            from paid_episode_read
            group by 1,2
            )
      , weeks as
      (
      select
      Day
      --,element_at(kv,date_format(date_trunc('week',date_add('week',-13,now())),'%Y-%m')) as week13
      --,element_at(kv,date_format(date_trunc('week',date_add('week',-12,now())),'%Y-%m')) as week12
      --,element_at(kv,date_format(date_trunc('week',date_add('week',-11,now())),'%Y-%m')) as week11
      --,element_at(kv,date_format(date_trunc('week',date_add('week',-10,now())),'%Y-%m')) as week10
      --,element_at(kv,date_format(date_trunc('week',date_add('week',-9,now())),'%Y-%m')) as week9
      ,element_at(kv,date_trunc('Week',date_add('week',-8,now()))) as week8
      ,element_at(kv,date_trunc('Week',date_add('week',-7,now()))) as week7
      ,element_at(kv,date_trunc('Week',date_add('week',-6,now()))) as week6
      ,element_at(kv,date_trunc('Week',date_add('week',-5,now()))) as week5
      ,element_at(kv,date_trunc('Week',date_add('week',-4,now()))) as week4
      ,element_at(kv,date_trunc('Week',date_add('week',-3,now())))  as week3
      ,element_at(kv,date_trunc('Week',date_add('week',-2,now())))  as week2
      ,element_at(kv,date_trunc('Week',date_add('week',-1,now())))  as week1
      ,element_at(kv,date_trunc('Week',now()))  as week0
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
      , sum(week8) over (order by Day asc) as Runningweek8
      , sum(week7) over (order by Day asc) as Runningweek7
      , sum(week6) over (order by Day asc) as Runningweek6
      , sum(week5) over (order by Day asc) as Runningweek5
      , sum(week4) over (order by Day asc) as Runningweek4
      , sum(week3) over (order by Day asc) as Runningweek3
      , sum(week2) over (order by Day asc) as Runningweek2
      , sum(week1) over (order by Day asc) as Runningweek1
      , sum(week0) over (order by Day asc) as Runningweek0
      from weeks
      )
      select Day, Runningweek8
                , lag(Runningweek8) over (order by Day asc) as Runningweek8_prev_day
                , Runningweek7
                , lag(Runningweek7) over (order by Day asc) as Runningweek7_prev_day
                , Runningweek6
                , lag(Runningweek6) over (order by Day asc) as Runningweek6_prev_day
                , Runningweek5
                , lag(Runningweek5) over (order by Day asc) as Runningweek5_prev_day
                , Runningweek4
                , lag(Runningweek4) over (order by Day asc) as Runningweek4_prev_day
                , Runningweek3
                , lag(Runningweek3) over (order by Day asc) as Runningweek3_prev_day
                , Runningweek2
                , lag(Runningweek2) over (order by Day asc) as Runningweek2_prev_day
                , Runningweek1
                , lag(Runningweek1) over (order by Day asc) as Runningweek1_prev_day
                , Runningweek0
                , lag(Runningweek0) over (order by Day asc) as Runningweek0_prev_day
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
      allowed_value: { value: "Everything" }
      allowed_value: { value: "Paid" }
      allowed_value: { value: "Organic"}
    }

    parameter: percentile {
      type: string
      allowed_value: { label: "Everything" value: "" }
      allowed_value: { label: "Top 10%" value: "Top 10%" }
      allowed_value: { label: "Top 10%-20%" value: "Top 10%-20%" }
      allowed_value: { label: "Top 20%-40%" value: "Top 20%-40%" }
      allowed_value: { label: "Top 40%-60%" value: "Top 40%-60%" }
      allowed_value: { label: "Top 60%-80%" value: "Top 60%-80%" }
      allowed_value: { label: "Top 80%-100%" value: "Top 80%-100%" }
    }
    #########################


    dimension: day {
      type: number
      sql: ${TABLE}."Day" ;;
    }

    dimension: running_week8 {
      type: number
      sql: ${TABLE}.Runningweek8 ;;
      hidden: yes
    }

    dimension: running_week8_prev_day {
      type: number
      sql: ${TABLE}.Runningweek8_prev_day ;;
      hidden: yes
    }

    dimension: running_week7 {
      type: number
      sql: ${TABLE}.Runningweek7 ;;
      hidden: yes
    }

    dimension: running_week7_prev_day {
      type: number
      sql: ${TABLE}.Runningweek7_prev_day ;;
      hidden: yes
    }

    dimension: running_week6 {
      type: number
      sql: ${TABLE}.Runningweek6 ;;
      hidden: yes
    }

    dimension: running_week6_prev_day {
      type: number
      sql: ${TABLE}.Runningweek6_prev_day ;;
      hidden: yes
    }

    dimension: running_week5 {
      type: number
      sql: ${TABLE}.Runningweek5 ;;
      hidden: yes
    }

    dimension: running_week5_prev_day {
      type: number
      sql: ${TABLE}.Runningweek5_prev_day ;;
      hidden: yes
    }

    dimension: running_week4 {
      type: number
      sql: ${TABLE}.Runningweek4 ;;
      hidden: yes
    }

    dimension: running_week4_prev_day {
      type: number
      sql: ${TABLE}.Runningweek4_prev_day ;;
      hidden: yes
    }

    dimension: running_week3 {
      type: number
      sql: ${TABLE}.Runningweek3 ;;
      hidden: yes
    }

    dimension: running_week3_prev_day {
      type: number
      sql: ${TABLE}.Runningweek3_prev_day ;;
      hidden: yes
    }

    dimension: running_week2 {
      type: number
      sql: ${TABLE}.Runningweek2 ;;
      hidden: yes
    }

    dimension: running_week2_prev_day {
      type: number
      sql: ${TABLE}.Runningweek2_prev_day ;;
      hidden: yes
    }

    dimension: running_week1 {
      type: number
      sql: ${TABLE}.Runningweek1 ;;
      hidden: yes
    }

    dimension: running_week1_prev_day {
      type: number
      sql: ${TABLE}.Runningweek1_prev_day ;;
      hidden: yes
    }

    dimension: running_week0 {
      type: number
      sql: ${TABLE}.Runningweek0 ;;
      hidden: yes
    }

    dimension: running_week0_prev_day {
      type: number
      sql: ${TABLE}.Runningweek0_prev_day ;;
      hidden: yes
    }

    dimension: running_week8_formatted {
      type: number
      sql: case when ${running_week8} = ${running_week8_prev_day} then null
        else ${running_week8} end ;;
      value_format_name: decimal_2
      hidden: yes
    }

    dimension: running_week7_formatted {
      type: number
      sql: case when ${running_week7} = ${running_week7_prev_day} then null
        else ${running_week7} end ;;
      value_format_name: decimal_2
      hidden: yes
    }

    dimension: running_week6_formatted {
      type: number
      sql: case when ${running_week6} = ${running_week6_prev_day} then null
        else ${running_week6} end ;;
      value_format_name: decimal_2
      hidden: yes
    }

    dimension: running_week5_formatted {
      type: number
      sql: case when ${running_week5} = ${running_week5_prev_day} then null
        else ${running_week5} end ;;
      value_format_name: decimal_2
      hidden: yes
    }

    dimension: running_week4_formatted {
      type: number
      sql: case when ${running_week4} = ${running_week4_prev_day} then null
        else ${running_week4} end ;;
      value_format_name: decimal_2
      hidden: yes
    }

    dimension: running_week3_formatted {
      type: number
      sql: case when ${running_week3} = ${running_week3_prev_day} then null
        else ${running_week3} end ;;
      value_format_name: decimal_2
      hidden: yes
    }

    dimension: running_week2_formatted {
      type: number
      sql: case when ${running_week2} = ${running_week2_prev_day} then null
        else ${running_week2} end ;;
      value_format_name: decimal_2
      hidden: yes
    }

    dimension: running_week1_formatted {
      type: number
      sql: case when ${running_week1} = ${running_week1_prev_day} then null
        else ${running_week1} end ;;
      value_format_name: decimal_2
      hidden: yes
    }

    dimension: running_week0_formatted {
      type: number
      sql: case when ${running_week0} = ${running_week0_prev_day} then null
        else ${running_week0} end ;;
      value_format_name: decimal_2
      hidden: yes
    }

    measure: week0 {
      type: average
      label: "Week 0"
      sql: ${running_week0_formatted} ;;
      value_format: "#0.##"
    }

    measure: week1 {
      type: average
      label: "Week 1"
      sql: ${running_week1_formatted} ;;
      value_format: "#0.##"
    }


    measure: week2 {
      type: average
      label: "Week 2"
      sql: ${running_week2_formatted} ;;
      value_format: "#0.##"
    }

    measure: week3 {
      type: average
      label: "Week 3"
      sql: ${running_week3_formatted} ;;
      value_format: "#0.##"
    }

    measure: week4 {
      type: average
      label: "Week 4"
      sql: ${running_week4_formatted} ;;
      value_format: "#0.##"
    }

    measure: week5 {
      type: average
      label: "Week 5"
      sql: ${running_week5_formatted} ;;
      value_format: "#0.##"
    }

    measure: week6 {
      type: average
      label: "Week 6"
      sql: ${running_week6_formatted} ;;
      value_format: "#0.##"
    }

    measure: week7 {
      type: average
      label: "Week 7"
      sql: ${running_week7_formatted} ;;
      value_format: "#0.##"
    }

    measure: week8 {
      type: average
      label: "Week 8"
      sql: ${running_week8_formatted} ;;
      value_format: "#0.##"
    }

    set: detail {
      fields: [
        day,
        running_week8,
        running_week8_prev_day,
        running_week7,
        running_week7_prev_day,
        running_week6,
        running_week6_prev_day,
        running_week5,
        running_week5_prev_day,
        running_week4,
        running_week4_prev_day,
        running_week3,
        running_week3_prev_day,
        running_week2,
        running_week2_prev_day,
        running_week1,
        running_week1_prev_day,
        running_week0,
        running_week0_prev_day
      ]
    }
  }
