view: episode_read_by_cohort_story_level {
  derived_table: {
    sql: with d0_reader as
      (
          select date(attributed_at) as installed_date,story_id,adjust_id
          from mart.mart.coin_usage_by_ads
          where story_id in (8602,8739)
          and coin_type in ('one_time','subscription')
          and date_diff('hour',attributed_at,used_at)/24<=3
          and date_diff('hour',attributed_at,used_at)/24>=0
          group by 1,2,3
          having sum(amount)/3>=10
      )


          select
          date(attributed_at) as installed_date
          ,date_diff('hour',attributed_at,used_at)/24 as days
          ,b.serious_reader as serious_reader_at_d0
          ,a.story_id
          ,sum(amount)/3 as paid_episode_read
          from mart.mart.coin_usage_by_ads a

          join
          (
          select installed_date,story_id,count(distinct adjust_id) as serious_reader
          from d0_reader
          group by 1,2
          )b
          on b.installed_date=date(attributed_at)
          and a.story_id=b.story_id
          where a.story_id in (8602,8739)
          and coin_type in ('one_time','subscription')
          and adjust_id in
          (
          select adjust_id
          from d0_reader

          )
          group by 1,2,3,4
       ;;
  }

  suggestions: no


  dimension_group: installed_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.installed_date ;;
  }

  dimension: days {
    type: number
    sql: ${TABLE}."days" ;;
  }

  dimension: story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }

  dimension: serious_reader_at_d0_raw {
    type: number
    sql: ${TABLE}.serious_reader_at_d0 ;;
  }

  dimension: paid_episode_read_raw {
    type: number
    sql: ${TABLE}.paid_episode_read ;;
  }

  measure: paid_episode_read {
    type: average
    sql: ${paid_episode_read_raw} ;;
  }

  measure: average_episode_read {
    type: average
    sql: ${paid_episode_read_raw}/${serious_reader_at_d0_raw};;
    value_format_name: decimal_2
  }

}
