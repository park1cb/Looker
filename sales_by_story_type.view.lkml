view: sales_by_story_type {
  derived_table: {
    sql: select
        cu.story_id
        , cu.created_at
        , cu.user_id
        , u.string_id as writer_id
        , s.title
        , case when s.writer_id = 705918 Then 'RO'
        when cu.story_id in
          (
          select distinct coupon.story_id
          from mysql.gatsby.user_story_coupon_gifts coupon
          left join mysql.gatsby.Redeem_code_histories code
          on coupon.id = code.story_coupon_gift_id

          join mysql.gatsby.redeem_codes redeem
          on redeem.id=code.redeem_code_id

          where redeem.title not like '%test%'
          ) then 'WTS'
          else 'etc' end as story_type
        , e.no as episode_no
        , cu.amount as coins
        , cu.coin_balance_id
      from mysql.gatsby.coin_usages cu
      left join mysql.gatsby.stories s
      on cu.story_id = s.id
      left join mysql.gatsby.users u
      on s.writer_id = u.id
      left join mysql.gatsby.episodes e
      on cu.episode_id = e.id

      left join mysql.gatsby.coin_balances cb
      on cb.id = cu.coin_balance_id
      where cb.type in ('subscription','one-time')
      and cu.created_at>=timestamp '2019-01-01 00:00:00'
      --and s.writer_id = 705918
      order by 1,2,3,4 desc
 ;;
  }

  suggestions: no


  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
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

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: writer_id {
    type: string
    sql: ${TABLE}.writer_id ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: story_type {
    type: string
    sql: ${TABLE}.story_type ;;
  }

  dimension: episode_no {
    type: number
    sql: ${TABLE}.episode_no ;;
  }

  dimension: coins {
    type: number
    sql: ${TABLE}.coins ;;
  }

  dimension: coin_balance_id {
    type: number
    sql: ${TABLE}.coin_balance_id ;;
  }

  measure: total_coins {
    type: sum
    sql: ${coins} ;;
  }

  measure: RO_coins {
    type: sum
    sql: case when ${story_type}='RO' then ${coins} else 0 end;;
  }


  measure: WTS_coins {
    type: sum
    sql: case when ${story_type}='WTS' then ${coins} else 0 end;;
  }


}
