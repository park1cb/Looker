view: top_story_raking_by_sales_product {
  derived_table: {
    sql: select cu.created_at as coin_used_at
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
