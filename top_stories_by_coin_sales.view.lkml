view: top_stories_by_coin_sales {
  derived_table: {
    sql: select
      story.title
      ,max(epi."no") as Episodes
      ,story.writer_string_id
      ,story.deleted_at
      ,case when coins.amount is null then 0 else coins.amount end +case when coins2.amount is null then 0 else coins2.amount end as total_coins
      ,(case when coins.amount is null then 0 else coins.amount end +case when coins2.amount is null then 0 else coins2.amount end)/max(epi."no") as avg_coins_per_chapter
      ,date_diff('month',min(epi.created_at),now()) as published_since
      from mysql.gatsby.episodes epi

      join mysql.gatsby.stories story
      on story.id=epi.story_id

      left join (
      select story_id,sum(amount) as amount
      from mysql.gatsby.coin_usages
      where cast(created_at as date)>=date'2018-07-01'
      group by 1
      )coins
      on coins.story_id=story.id

      left join (
      select story_string_id,-sum(coins) as amount
      from mysql.gatsby.transactions
      where type='used'
      and cast(transacted_at as date)<date '2018-07-01'
      group by 1
      )coins2
      on coins2.story_string_id=story.string_id

      --where epi.writer_string_id='RadishOriginals'

      group by 1,3,4,5

      order by 6 desc
       ;;
      sql_trigger_value: select date_trunc('day',now());;
  }

  suggestions: no


  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: episodes {
    type: number
    sql: ${TABLE}.Episodes ;;
  }

  dimension: writer_string_id {
    type: string
    sql: ${TABLE}.writer_string_id ;;
  }

  dimension: archived {
    type: yesno
    sql: ${TABLE}.deleted_at is not null;;
  }

  dimension: total_coins {
    type: number
    sql: ${TABLE}.total_coins ;;
  }

  dimension: avg_coins_per_chapter {
    type: number
    sql: ${TABLE}.avg_coins_per_chapter ;;
  }

  dimension: published_since {
    type: number
    sql: ${TABLE}.published_since ;;
  }

}
