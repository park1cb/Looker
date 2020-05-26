view: paying_conversion_by_days {
  derived_table: {
    sql: select a.id as user_id
      , a.joined_at + interval '5' hour as joined_at
      , 1/cast(kpi.new_users as double) as percent
      ,min(b.created_at) created_at
      , date_diff('day',a.joined_at + interval '5' hour ,min(b.created_at + interval '5' hour)) as date_diff
            from mysql.gatsby.users a
            left join mysql.gatsby.paid_coin_issues b on a.id = b.user_id
            join mart.mart.kpi_by_day kpi
            on kpi.base_date_est=cast(joined_at+ interval '5' hour as date)
            group by 1,2,3
            having date_diff('day',a.joined_at + interval '5' hour ,min(b.created_at + interval '5' hour)) >= 0
            --and date_diff('day',a.joined_at,min(b.created_at)) <= 500

            order by 1,2
       ;;
  }

  suggestions: no


  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: joined_at {
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
    sql: ${TABLE}.joined_at ;;
  }

  dimension: percent {
    type: number
    sql: ${TABLE}.percent ;;
  }

  dimension_group: created_at {
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
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.created_at ;;
  }

  dimension: date_diff {
    type: number
    sql: ${TABLE}.date_diff ;;
  }

  measure: paying_conversion {
    type: sum
    sql: ${percent} ;;
    value_format_name: percent_2
  }


}
