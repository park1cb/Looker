view: organic_vs_paid_installs {
  derived_table: {
    sql: select
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
 ;;
  }

  suggestions: no

  measure: count {
    type: count
    drill_fields: [detail*]
  }

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
    datatype: timestamp
    sql: ${TABLE}."date" ;;
  }

  dimension: organic_users {
    type: number
    sql: ${TABLE}.Organic_Users ;;
  }

  dimension: paid_users {
    type: number
    sql: ${TABLE}.Paid_Users ;;
  }

  set: detail {
    fields: [date, organic_users, paid_users]
  }
}
