view: ltv_version_2_by_installed_date {
  derived_table: {
    sql: select
      date_trunc('day',users.date) as date
      ,day
      ,users.organic_users+users.paid_users as new_users
      ,
      ( COALESCE(element_at(kr,'Organic'),0) +  COALESCE(element_at(kr,'Paid'),0))/( COALESCE(users.organic_users,0)+ COALESCE(users.paid_users,0))
       as Value
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
       ;;
  }

  suggestions: no



  dimension_group: date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."date" ;;
  }

  dimension: day {
    type: number
    sql: ${TABLE}."day" ;;
  }

  dimension: new_users {
    type: number
    sql: ${TABLE}.new_users ;;
  }

  dimension: value {
    type: number
    sql: ${TABLE}.Value ;;
  }

  measure: LTV{
    type: sum
    sql: ${value} ;;
    value_format: "$0.0000"
    }


}
