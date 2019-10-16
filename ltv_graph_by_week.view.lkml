view: ltv_graph_by_week {
  derived_table: {
    sql: with LTV as
            (
            select
                  date_trunc('week',cast(joined_at as date)) as date
                  ,date_diff('Week',users.joined_at,paid.created_at) as week
                  ,kpi.new_users
                  ,(sum(pd.original_price))/kpi.new_users as Value

                  from mysql.gatsby.users users

                  left join mysql.gatsby.paid_coin_issues paid
                  on paid.user_id=users.id
                  left join mysql.gatsby.products pd
                  on pd.id=paid.product_id

                  join mart.mart.kpi_by_week as kpi
                  on kpi.base_date_est=date_add('day',-1,date_trunc('week',users.joined_at))


                  where cast(users.joined_at as date)>=date '2018-07-02'
                  and users.id not in
                  (
                  select pre_user_id
                  from mysql.gatsby.pre_signin_users
                  )

                  and date_diff('day',users.joined_at,paid.created_at)>=0

                  group by 1,2,3
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
