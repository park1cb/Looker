explore: paid_episode_per_installs_okr_temporary {}

view: paid_episode_per_installs_okr_temporary {
  derived_table: {
    sql: with mast as
      (
      select
            case when a.os_name='android' then a.gps_adid when a.os_name='ios' then coalesce(a.idfa,a.idfv) end as device_id
            ,a.attributed_at at time zone '-05:00' as attributed_at_est
            ,b.story_id
            ,count(distinct b.episode_id) as episode_read
            from mart.mart.user_mapper_adjust a
            join mart.mart.coin_used_devices b
            on a.adid=b.adjust_id


            where a.attributed_at>=timestamp '2020-01-01 00:00:00'
            and a.attributed_at<timestamp '2020-04-06 00:00:00'
            and date_diff('hour',a.attributed_at at time zone '-05:00',used_at at time zone '-05:00') <= {% parameter attributed_cohort %}
            and b.coin_type in ('one-time','subscription')
            group by 1,2,3
            having count(distinct b.episode_id)>=3

      )
      select attributed_at_est,device_id,count(distinct story_id) as story_count
      from mast
      group by 1,2
       ;;
  }

  suggestions: no

  parameter: attributed_cohort {
    type: number
    default_value: "10"
  }

  dimension_group: attributed_at_est {
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
    convert_tz: no
    datatype: date
    sql: ${TABLE}.attributed_at_est ;;
  }

  dimension: device_id {
    type: string
    sql: ${TABLE}.device_id ;;
  }

  dimension: story_count {
    type: number
    sql: ${TABLE}.story_count ;;
  }

  measure: device_count {
    type: count_distinct
    sql: ${device_id} ;;
  }

  measure: story_total {
    type: sum
    sql: ${story_count} ;;
  }


}
