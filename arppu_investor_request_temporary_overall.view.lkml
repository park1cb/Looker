view: arppu_investor_request_temporary_overall {
  derived_table: {
      sql: select date_trunc('month',a.installed_at at time zone '-05:00') as installed_month
              ,a.os_name
              ,case when network_name in ('Branch(Android)','Branch(iOS)','Organic') then 'Organic' else 'Paid' End as Network
              ,b.adjust_id
              ,b.price
              from mart.mart.user_mapper_adjust a
              join mart.mart.coin_purchased_devices b
              on b.adjust_id=a.adid


              where b.adjust_id in
              (
              select adjust_id
              from mart.mart.user_mapper_adjust a
              join mart.mart.coin_purchased_devices b
              on b.adjust_id=a.adid
              where date_diff('hour',installed_at,purchased_at)/24<=30
              group by 1
              having sum(price)<4

              )
              and date_diff('hour',installed_at,purchased_at)/24<=30
              and date_diff('hour',installed_at,now())/24>=30
               ;;
    }

    suggestions: no


    dimension_group: installed_month {
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
      sql: ${TABLE}.installed_month ;;
    }

    dimension: os_name {
      type: string
      sql: ${TABLE}.os_name ;;
    }

    dimension: network {
      type: string
      sql: ${TABLE}.Network ;;
    }

    dimension: adjust_id {
      type: string
      sql: ${TABLE}.adjust_id ;;
    }

    dimension: price {
      type: number
      sql: ${TABLE}.price ;;
    }

    measure: payers {
      type: count_distinct
      sql: ${adjust_id} ;;
    }

    measure: revenue {
      type: sum
      sql: ${price} ;;
      value_format_name: usd
    }


  }
