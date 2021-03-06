view: arppu_table {
 derived_table: {
    sql: with arppu as
            (
           select
              date_format(date_trunc('Month',joined_at),'%Y-%m') as date
              ,date_diff('day',users.joined_at,paid.created_at) as day
              ,count(distinct paid.user_id) as paid_users
              ,sum(pd.original_price)/count(distinct paid.user_id) as value
              from mysql.gatsby.users users

              left join mysql.gatsby.paid_coin_issues paid
              on paid.user_id=users.id

              left join mysql.gatsby.products pd
              on pd.id=paid.product_id

              where date_diff('day',users.joined_at,paid.created_at)>=0
              and users.id not in
              (
                select pre_user_id
                from mysql.gatsby.pre_signin_users
              )
              and cast(users.joined_at as date)>=date_trunc('month',date_add('month',-8,now()))
            group by 1,2
            )

      ,test as
      (
      select date,day,avg(Value) as Value
            from arppu
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
      select Day,map_agg(date,value) kv
      from test
      group by 1
        )

 ;;
  }

  suggestions: no

  dimension: day {
    type: number
    sql: ${TABLE}."Day" ;;
  }

  dimension: month8_raw {
    type: number
    sql: ${TABLE}.month8 ;;
    hidden: yes
  }

  dimension: month7_raw {
    type: number
    sql: ${TABLE}.month7 ;;
    hidden: yes
  }

  dimension: month6_raw {
    type: number
    sql: ${TABLE}.month6 ;;
    hidden: yes
  }

  dimension: month5_raw {
    type: number
    sql: ${TABLE}.month5 ;;
    hidden: yes
  }

  dimension: month4_raw {
    type: number
    sql: ${TABLE}.month4 ;;
    hidden: yes
  }

  dimension: month3_raw {
    type: number
    sql: ${TABLE}.month3 ;;
    hidden: yes
  }

  dimension: month2_raw {
    type: number
    sql: ${TABLE}.month2 ;;
    hidden: yes
  }

  dimension: month1_raw {
    type: number
    sql: ${TABLE}.month1 ;;
    hidden: yes
  }

  dimension: month0_raw {
    type: number
    sql: ${TABLE}.month0 ;;
    hidden: yes
  }

  measure: month8 {
    type: average
    sql: ${month8_raw} ;;
    value_format: "$#0.####"
  }

  measure: month7 {
    type: average
    sql: ${month7_raw} ;;
    value_format: "$#0.####"
  }

  measure: month6 {
    type: average
    sql: ${month6_raw} ;;
    value_format: "$#0.####"
  }

  measure: month5 {
    type: average
    sql: ${month5_raw} ;;
    value_format: "$#0.####"
  }

  measure: month4 {
    type: average
    sql: ${month4_raw} ;;
    value_format: "$#0.####"
  }

  measure: month3 {
    type: average
    sql: ${month3_raw} ;;
    value_format: "$#0.####"
  }

  measure: month2 {
    type: average
    sql: ${month2_raw} ;;
    value_format: "$#0.####"
  }

  measure: month1 {
    type: average
    sql: ${month1_raw} ;;
    value_format: "$#0.####"
  }

  measure: month0 {
    type: average
    sql: ${month0_raw} ;;
    value_format: "$#0.####"
  }




}

#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
