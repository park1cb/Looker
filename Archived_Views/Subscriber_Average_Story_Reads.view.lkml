view: subscriber_average_story_reads {
  derived_table: {
      sql: select cu.user_id
              ,date_trunc('week',cu.created_at) as coin_used_at
              --,story_id
              --,story.title
              ,case when cb.type='subscription' then
                  case when init_amount in (40,20,35) then 'Weekly' when init_amount in (200,230,255) then 'Monthly' when init_amount in (265,300) then 'Yearly' ELSE 'etc' END
                  else cb.type end as type
              ,sum(cu.amount) as total_coins
              ,count(distinct story_id) as story_count
              from mysql.gatsby.coin_usages cu
              left join mysql.gatsby.coin_balances cb on cu.coin_balance_id = cb.id


        group by 1,2,3
        ;;
    }

    suggestions: no



    dimension: user_id {
      type: number
      sql: ${TABLE}.user_id ;;
    }

    dimension_group: coin_used_at {
      type: time
      sql: ${TABLE}.coin_used_at ;;
    }


    dimension: type {
      type: string
      sql: ${TABLE}.type ;;
    }

    dimension: total_couns {
      type: number
      sql: ${TABLE}.amount ;;
    }

    dimension: story_count {
      type: number
      sql: ${TABLE}.story_count ;;
    }

    measure: story_avg {
      type: average
      sql: ${story_count} ;;
      value_format_name: decimal_2
    }

  }
