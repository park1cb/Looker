view: payers_by_cohort {
  derived_table: {
    sql: select users.id,date_diff('day',users.joined_at,paid.created_at) as cohort,users.joined_at
      from mysql.gatsby.users users

      left join
      (
      select paid.user_id,min(paid.created_at) as created_at
      from mysql.gatsby.paid_coin_issues paid
      join mysql.gatsby.products prod
      on prod.id=paid.product_id

      where prod.type in ('one-time','subscription')
      group by 1
      )paid
      on paid.user_id=users.id

      left join mysql.gatsby.pre_signin_users pre
      on users.id=pre.pre_user_id


      where users.joined_at>=date '2018-10-01'
      and pre.pre_user_id is null
       ;;
  }

  suggestions: no



  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cohort {
    type: number
    sql: ${TABLE}.cohort ;;
  }


  dimension_group: joined_at {
    type: time
    sql: ${TABLE}.joined_at ;;
  }



  measure: users {
    type: count
  }

  measure: D0_count {
    type: count_distinct
    sql: case when cohort=0 then id else null end ;;
  }

  measure: D3_count {
    type: count_distinct
    sql: case when cohort<=3 then id else null end ;;
  }

  measure: D7_count {
    type: count_distinct
    sql: case when cohort<=7 then id else null end ;;
  }

  measure: D30_count {
    type: count_distinct
    sql: case when cohort<=30 then id else null end ;;
  }

  measure: D60_count {
    type: count_distinct
    sql: case when cohort<=60 then id else null end ;;
  }


  measure: D61_plus_count {
    type: count_distinct
    sql: case when cohort>60 then id else null end ;;
  }


}
