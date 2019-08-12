view: Paying_Conversion {
  derived_table: {
    sql:

      with users as
      (
        select user_id,joined_at,paid.created_at,rank() over (partition by user_id order by paid.created_at) as rank
        from mysql.gatsby.users users
        join mysql.gatsby.paid_coin_issues paid
        on paid.user_id=users.id
        join mysql.gatsby.products pd
        on pd.id=paid.product_id
      )
      ,conversion as
            (
            select
                  date_format(date_trunc('Month',joined_at at time zone '-05:00'),'%Y-%m') as date
                  ,date_diff('day',users.joined_at at time zone '-05:00',users.created_at at time zone '-05:00') as day
                  ,kpi.new_users
                  ,cast(count(distinct users.user_id) as double)/cast(kpi.new_users as double) as percent

                  from users users


                  join mart.mart.kpi_by_day as kpi
                  on kpi.base_date_est=cast(users.joined_at at time zone '-05:00' as date)


                  where cast(users.joined_at at time zone '-05:00' as date)>=date_trunc('month',date_add('month',-8,now()))
                  and users.user_id not in
                  (
                  select pre_user_id
                  from mysql.gatsby.pre_signin_users
                  )

                  and date_diff('day',users.joined_at at time zone '-05:00' ,users.created_at at time zone '-05:00' )>=0
                  and users.rank=1

                  group by 1,2,3
            )


      ,test as
      (
      select date,day,avg(percent) as percent
            from conversion
            group by 1,2
            )

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
      select Day,map_agg(date,percent) kv
      from test
      group by 1
      )
       ;;
  }

  suggestions: no

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: day {
    type: number
    sql: ${TABLE}."Day" ;;
  }


  dimension: month8 {
    type: number
    sql: ${TABLE}.Month8 ;;

  }

  dimension: month7 {
    type: number
    sql: ${TABLE}.Month7 ;;
  }

  dimension: month6 {
    type: number
    sql: ${TABLE}.Month6 ;;
  }

  dimension: month5 {
    type: number
    sql: ${TABLE}.Month5 ;;
  }

  dimension: month4 {
    type: number
    sql: ${TABLE}.Month4 ;;
  }

  dimension: month3 {
    type: number
    sql: ${TABLE}.Month3 ;;
  }

  dimension: month2 {
    type: number
    sql: ${TABLE}.Month2 ;;
  }

  dimension: month1 {
    type: number
    sql: ${TABLE}.Month1 ;;
  }

  dimension: month0 {
    type: number
    sql: ${TABLE}.Month0 ;;
  }
  measure: RunningMonth8 {
    label: "Month 8"
    type: running_total
    sql: ${month8} ;;
    value_format_name: percent_2
  }
  measure: RunningMonth7 {
    label: "Month 7"
    type: running_total
    sql: ${month7} ;;
    value_format_name: percent_2
  }
  measure: RunningMonth6 {
    label: "Month 6"
    type: running_total
    sql: ${month6} ;;
    value_format_name: percent_2

  }
  measure: RunningMonth5 {
    label: "Month 5"
    type: running_total
    sql: ${month5} ;;
    value_format_name: percent_2
  }
  measure: RunningMonth4 {
    label: "Month 4"
    type: running_total
    sql: ${month4} ;;
    value_format_name: percent_2
  }
  measure: RunningMonth3 {
    label: "Month 3"
    type: running_total
    sql: ${month3} ;;
    value_format_name: percent_2
  }
  measure: RunningMonth2 {
    label: "Month 2"
    type: running_total
    sql: ${month2} ;;
    value_format_name: percent_2
  }
  measure: RunningMonth1 {
    label: "Month 1"
    type: running_total
    sql: ${month1} ;;
    value_format_name: percent_2
  }
  measure: RunningMonth0 {
    label: "Month 0"
    type: running_total
    sql: ${month0} ;;
    value_format_name: percent_2
  }
  set: detail {
    fields: [
      day,
      month8,
      month7,
      month6,
      month5,
      month4,
      month3,
      month2,
      month1,
      month0
    ]
  }
}
