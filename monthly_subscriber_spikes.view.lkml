view: monthly_subscriber_spikes {
 derived_table: {
      sql: with mast as
(
select created_at , user_id,init_amount-current_amount as usage,rank() over (partition by user_id order by created_at) as row_num
      from mysql.gatsby.coin_balances
      where init_amount=200
      --and is_active=0
      and expired_at is not null
      and type='subscription'
)


select cu.created_at as coin_used_at
              ,story_id
              ,story.title
              ,case when cb.type='subscription' then
                  case when init_amount in (40,20,35) then 'Weekly' when init_amount in (200,230,255) then 'Monthly' when init_amount in (265,300) then 'Yearly' ELSE 'etc' END
                  else cb.type end as type
              ,cu.amount
              from mysql.gatsby.coin_usages cu
              left join mysql.gatsby.coin_balances cb
              on cu.coin_balance_id = cb.id

              join mysql.gatsby.stories story
              on story.id=cu.story_id

where cu.user_id in
(
select user_id--,usage--,row_num,max(row_num) over (partition by user_id) as maximum,avg(usage) over (partition by user_id) as avg_usage
from mast
where created_at>=timestamp '2019-06-01 00:00:00'
and created_at<timestamp '2019-07-01 00:00:00'
and usage>=180)
and cu.created_at>=timestamp '2019-06-01 00:00:00'
and cu.created_at<timestamp '2019-07-01 00:00:00'

 ;;
    }

    suggestions: no



    dimension_group: coin_used_at {
      type: time
      sql: ${TABLE}.coin_used_at ;;
    }

    dimension: story_id {
      type: number
      sql: ${TABLE}.story_id ;;
    }

    dimension: title {
      type: string
      sql: ${TABLE}.title ;;
    }

    dimension: type {
      type: string
      sql: ${TABLE}.type ;;
    }

    dimension: coins {
      type: number
      sql: ${TABLE}.amount ;;
    }

    measure: total_coins {
      type: sum
      sql: ${coins} ;;
    }
}
