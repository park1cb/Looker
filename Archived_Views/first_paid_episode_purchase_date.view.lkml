view: first_paid_episode_purchase_date {
  derived_table: {
    sql: select cu.user_id,min(cu.created_at) created_at
      from mysql.gatsby.coin_usages cu
      left join mysql.gatsby.coin_balances cb
      on cb.id = cu.coin_balance_id
      where cb.type in ('subscription','one-time')
      and  cast(cu.created_at as date)>=date_add('month',-8,now())
      group by 1
       ;;
      sql_trigger_value: select date_trunc('day',now());;
  }

  suggestions: no

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}.created_at ;;
  }

  set: detail {
    fields: [user_id, created_at_time]
  }
}
