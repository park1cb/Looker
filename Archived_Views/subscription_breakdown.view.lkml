view: subscription_breakdown {
  derived_table: {
    sql: select paid.user_id,paid.created_at,pd.alias,pd.amount,pd.original_price
      from mysql.gatsby.paid_coin_issues paid

      join mysql.gatsby.products pd
      on pd.id=paid.product_id

      where alias in ('Weekly','Monthly','Yearly')
       ;;
  }

  suggestions: no


  dimension_group: created_at {
    type: time
    sql: ${TABLE}.created_at ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: alias {
    type: string
    sql: ${TABLE}.alias ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: original_price {
    type: number
    sql: ${TABLE}.original_price ;;
  }

  measure: count_dist {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: Total_Coin_Issued {
    type: sum
    sql: ${amount} ;;
  }

  measure: total_revenue {
    type: sum
    sql: ${original_price} ;;
    value_format_name: usd
  }

}
