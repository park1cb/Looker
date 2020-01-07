view: cohort_data_purchase {
  derived_table: {
    sql: with mast as
      (select
      a.adjust_id,
      a.platform,
      a.user_id,
      cast(a.installed_at + interval '5' hour as date) as installed_at,
      a.cohort,
      a.network,
      sum(a.amount)/3 as episode_purchase

      from ${cohort_data_purchase_raw_data.SQL_TABLE_NAME} a
      where   cohort<=30
              {% if purchased_user._in_query %}
              and
              purchased_user = {% parameter purchased_user %}
              {% else %} {% endif %}
              {% if story_id._in_query %}
              and
              story_id = {% parameter story_id %}
              {% else %} {% endif %}
              {% if platform._in_query %}
              and
              platform = {% parameter platform %}
              {% else %} {% endif %}
              {% if network._in_query %}
              and
              network = {% parameter network %}
              {% else %} {% endif %}
      group by 1,2,3,4,5,6
      )
      ,mast2 as
      (
      select a.*,
        CASE WHEN
        PERCENT_RANK() OVER (PARTITION by a.installed_at ORDER BY b.total_amount DESC)<.1 Then 'Top 10%'
        WHEN
        PERCENT_RANK() OVER (PARTITION by a.installed_at ORDER BY b.total_amount DESC)<.2 Then 'Top 10%-20%'
        WHEN
        PERCENT_RANK() OVER (PARTITION by a.installed_at ORDER BY b.total_amount DESC)<.4 Then 'Top 20%-40%'
        WHEN
        PERCENT_RANK() OVER (PARTITION by a.installed_at ORDER BY b.total_amount DESC)<.6 Then 'Top 40-60%'
        WHEN
        PERCENT_RANK() OVER (PARTITION by a.installed_at ORDER BY b.total_amount DESC)<.8 Then 'Top 60%-80%'
        ELSE 'Top 80%-100%' end as percentile
        ,case when c.adjust_id is null then 'N' ELSE 'Y' end as multiple_stories
        ,case when d.stories is null then 1 else d.stories end stories
      from mast a
      join
      (
      select
      adjust_id,
      sum(amount) as total_amount
      from ${cohort_data_purchase_raw_data.SQL_TABLE_NAME} b
      where cohort<=30
      group by 1
      )b
      on b.adjust_id=a.adjust_id
      left join
      (
      select adjust_id,count(story_id) as stories
      from
      (
      select distinct
      adjust_id
      ,story_id
      from ${cohort_data_purchase_raw_data.SQL_TABLE_NAME} c
      where purchased_user='Y'
      group by 1,2


      having sum(amount)/3>=5
      )
      group by 1
      having count(story_id)>=2
      )c
      on c.adjust_id=a.adjust_id

      -----------
      left join
      (
      select adjust_id,cohort,count(story_id) as stories
      from
      (
      select distinct
      adjust_id
      ,cohort
      ,story_id
      from hive.looker.LR_83S5JXCB84W0BVLSECVTF_cohort_data_purchase_raw_data c
      where purchased_user='Y'
      group by 1,2,3


      having sum(amount)/3>=5
      )
      group by 1,2
      )d
      on d.adjust_id=a.adjust_id
      and d.cohort=a.cohort

      )


      select *
      from mast2
      where cohort<=30
      {% if percentile._in_query %}
      and
      percentile = {% parameter percentile %}
      {% else %} {% endif %}
      {% if multiple_stories._in_query %}
      and
      multiple_stories = {% parameter multiple_stories %}
      {% else %} {% endif %}


 ;;
  }

  parameter: story_id {
    type: number
  }

  parameter: purchased_user {
    type: string
    allowed_value: { label: "Free Coin User+Purchased Coin User" value: "" }
    allowed_value: { label: "Purchased Coin User Only" value: "Y" }
  }

  parameter: platform {
    type: string
    allowed_value: { label: "Everything" value: "" }
    allowed_value: { label: "ios" value: "ios" }
    allowed_value: { label: "android" value: "android" }
  }

  parameter: network {
    type: string
    allowed_value: { label: "Everything" value: "" }
    allowed_value: { label: "Organic User" value: "Organic" }
    allowed_value: { label: "Paid User" value: "Paid" }

  }

  parameter: percentile {
    type: string
    allowed_value: { label: "Everything" value: "" }
    allowed_value: { label: "Top 10%" value: "Top 10%" }
    allowed_value: { label: "Top 10%-20%" value: "Top 10%-20%" }
    allowed_value: { label: "Top 20%-40%" value: "Top 10%-20%" }
    allowed_value: { label: "Top 40%-60%" value: "Top 10%-20%" }
    allowed_value: { label: "Top 60%-80%" value: "Top 10%-20%" }
    allowed_value: { label: "Top 80%-100%" value: "Top 80%-100%" }
  }

  parameter: multiple_stories {
    type: string
    allowed_value: { label: "Everything" value: "" }
    allowed_value: { label: "One Story" value: "N" }
    allowed_value: { label: "Multiple Stories" value: "Y" }
  }






##########################################
  dimension: adjust_id {
    type: string
    sql: ${TABLE}.adjust_id ;;
  }


  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: installed_at {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day,
      day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.installed_at ;;
  }



  dimension: cohort {
    type: number
    sql: ${TABLE}.cohort ;;
  }



  dimension: episode_purchase {
    type: number
    sql: ${TABLE}.episode_purchase ;;
  }

  dimension: stories {
    type: number
    sql: ${TABLE}.stories ;;
  }

######################



  measure: avg_episode_purchase {
    type: average
    sql: ${episode_purchase} ;;
    value_format_name: decimal_2
  }

  measure: median_episode_purchase {
    type: median
    sql: ${episode_purchase} ;;
    value_format_name: decimal_2
  }


  measure: avg_story_read {
    type: average
    sql: ${stories} ;;
    value_format_name: decimal_2
  }

  measure: median_story_read {
    type: median
    sql: ${stories} ;;
    value_format_name: decimal_2
  }


}
