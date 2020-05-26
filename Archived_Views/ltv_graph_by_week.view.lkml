view: ltv_graph_by_week {
  derived_table: {
    sql: with LTV as
            (
select
date_trunc('week',users.date) as date
,week
,users.organic_users+users.paid_users as new_users
,Case
when {% parameter network_filter %}='Organic' Then
  COALESCE(element_at(kr,'Organic'),0) /COALESCE(users.organic_users,0)
when {% parameter network_filter %}='Paid' Then
  COALESCE(element_at(kr,'Paid'),0) /COALESCE(users.paid_users,0)
when {% parameter network_filter %}='Everything' then
( COALESCE(element_at(kr,'Organic'),0) +  COALESCE(element_at(kr,'Paid'),0))/( COALESCE(users.organic_users,0)+ COALESCE(users.paid_users,0))
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
)

) users


left join
(
  select
  date
  ,week
  ,map_agg(network,revenue) as kr
  from
  (
    select
    cast(a.joined_at as date) as date
    ,case when network.network_name='Organic' or network.network_name is null then 'Organic' else 'Paid' End as network
    ,date_diff('week',a.joined_at,paid.created_at) as week
    ,sum(pd.original_price) as revenue
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

where week>=0
            )

             select
             date_trunc('week',date) as date
            ,element_at(kv,0)+element_at(kv,1) as week1
            ,element_at(kv,0)+element_at(kv,1)+element_at(kv,2)+element_at(kv,3) as week3
            ,element_at(kv,0)+element_at(kv,1)+element_at(kv,2)+element_at(kv,3)+element_at(kv,4)+element_at(kv,5)+element_at(kv,6)+element_at(kv,7)+element_at(kv,8)+element_at(kv,9)+element_at(kv,10)+element_at(kv,11)+element_at(kv,12) as week12
            ,element_at(kv,0)+element_at(kv,1)+element_at(kv,2)+element_at(kv,3)+element_at(kv,4)+element_at(kv,5)+element_at(kv,6)+element_at(kv,7)+element_at(kv,8)+element_at(kv,9)+element_at(kv,10)+element_at(kv,11)+element_at(kv,12)+element_at(kv,13)+element_at(kv,14)+element_at(kv,15)+element_at(kv,16)+element_at(kv,17)+element_at(kv,18)+element_at(kv,19)+element_at(kv,20)+element_at(kv,21)+element_at(kv,22)+element_at(kv,23)+element_at(kv,24)+element_at(kv,25)+element_at(kv,26) as week26
            ,element_at(kv,0)+element_at(kv,1)+element_at(kv,2)+element_at(kv,3)+element_at(kv,4)+element_at(kv,5)+element_at(kv,6)+element_at(kv,7)+element_at(kv,8)+element_at(kv,9)+element_at(kv,10)+element_at(kv,11)+element_at(kv,12)+element_at(kv,13)+element_at(kv,14)+element_at(kv,15)+element_at(kv,16)+element_at(kv,17)+element_at(kv,18)+element_at(kv,19)+element_at(kv,20)+element_at(kv,21)+element_at(kv,22)+element_at(kv,23)+element_at(kv,24)+element_at(kv,25)+element_at(kv,26)+element_at(kv,27)+element_at(kv,28)+element_at(kv,29)+element_at(kv,30)+element_at(kv,31)+element_at(kv,32)+element_at(kv,33)+element_at(kv,34)+element_at(kv,35)+element_at(kv,36)+element_at(kv,37)+element_at(kv,38)+element_at(kv,39)+element_at(kv,40)+element_at(kv,41)+element_at(kv,42)+element_at(kv,43)+element_at(kv,44)+element_at(kv,45)+element_at(kv,46)+element_at(kv,47)+element_at(kv,48)+element_at(kv,49)+element_at(kv,50)+element_at(kv,51)+element_at(kv,52) as week52


          from
          (
             select Date,map_agg(week,value) kv
             from LTV
             group by 1
          )

          order by 1 desc
 ;;
  }

  suggestions: no

  parameter: network_filter{
    type: string
    allowed_value: { value: "Organic"}
    allowed_value: { value: "Paid" }
    allowed_value: { value: "Everything" }
  }


  dimension_group: date {
    type: time
    timeframes: [
      week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."date" ;;
  }

  dimension: week1_raw {
    type: number
    sql: ${TABLE}.week1 ;;
    hidden: yes
  }

  dimension: week3_raw {
    type: number
    sql: ${TABLE}.week3 ;;
    hidden: yes
  }

  dimension: week12_raw {
    type: number
    sql: ${TABLE}.week12 ;;
    hidden: yes
  }

  dimension: week26_raw {
    type: number
    sql: ${TABLE}.week26 ;;
    hidden: yes
  }

  dimension: week52_raw {
    type: number
    sql: ${TABLE}.week52 ;;
    hidden: yes
  }

  measure:week1  {
    type: average
    sql: ${week1_raw} ;;
    value_format: "$#0.####"
  }

  measure:week3  {
    type: average
    sql: ${week3_raw} ;;
    value_format: "$#0.####"
  }

  measure:week12  {
    type: average
    sql: ${week12_raw} ;;
    value_format: "$#0.####"
  }

  measure:week26  {
    type: average
    sql: ${week26_raw} ;;
    value_format: "$#0.####"
  }

  measure:week52  {
    type: average
    sql: ${week52_raw} ;;
    value_format: "$#0.####"
  }


}
