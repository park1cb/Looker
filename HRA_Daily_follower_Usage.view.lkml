view: HRA_Daily_Follower_Usage {
  derived_table: {
    sql: select cu.user_id
      ,cu.created_at as coin_used_at
      ,case when cb.type='subscription' then
          case when init_amount in (40,20,35) then 'Weekly' when init_amount in (200,230,255) then 'Monthly' when init_amount in (265,300) then 'Yearly' ELSE 'etc' END
          else cb.type end as type
      ,cu.amount
      from mysql.gatsby.coin_usages cu
      left join mysql.gatsby.coin_balances cb on cu.coin_balance_id = cb.id
      where story_id = 7808
      and cu.user_id in
      (select user_id
from
(
select cu.user_id, sum(cu.amount) as amount
      from mysql.gatsby.coin_usages cu
      left join mysql.gatsby.coin_balances cb on cu.coin_balance_id = cb.id
      where story_id = 7808
      group by 1
      having sum(cu.amount)>=60
))

       ;;
  }

  suggestions: no


  dimension_group: coin_used_at {
    type: time
    sql: ${TABLE}.coin_used_at ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  measure: total_amount {
    type: sum
    sql: ${amount} ;;
  }

  measure: dist_user {
    type: count_distinct
    sql: ${user_id} ;;
  }

}
