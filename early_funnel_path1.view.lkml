view: early_funnel_path1 {
  derived_table: {
    sql: select table1.user_id
              ,table1.event_type as event1
              , table1.event_time as event1_time
              , table2.event_type as event2
              , table2.event_time as event2_time
              , table3.event_type as event3
              , table3.event_time as event3_time

          from
          (
          select table1.user_id,event_type,event_time,json_extract_scalar(table1.event_properties, '$["Story Id"]') as story_id,rank() over (partition by user_id order by event_time) as rank
          from hive.dw.dw_amplitude table1

          join mysql.gatsby.users users
          on users.id=table1.user_id

          where event_type='Open Episode'
          and {% condition event1_date_filter %} table1.base_date {% endcondition %}
          and table1.user_id>0
          and {% condition event1_date_filter %} cast(users.joined_at as date) {% endcondition %}
          )table1

            left join
            (
            select user_id,event_type,event_time as event_time,json_extract_scalar(table2.event_properties, '$["Story Id"]') as story_id,rank() over (partition by user_id,json_extract_scalar(table2.event_properties, '$["Story Id"]') order by event_time) as rank
            from hive.dw.dw_amplitude table2
                where table2.event_type = 'Open Episode'
                and {% condition event1_date_filter %} table2.base_date {% endcondition %}
                group by 1,2,3,4
            )table2
            on table1.user_id= table2.user_id
            and table1.event_time < table2.event_time
            and table1.story_id = table2.story_id
            and table2.rank=3

            left join hive.dw.dw_amplitude table3
                on table1.user_id=table3.user_id
                and table2.event_time < table3.event_time
                and table3.event_type = 'Purchase Coins'
                and {% condition event1_date_filter %} table3.base_date {% endcondition %}
            where table1.rank=1 ;;
            sql_trigger_value: select max(base_date) from hive.dw.dw_amplitude;;
  }

  filter: event1_date_filter {
    type: date
    default_value: "5 weeks"
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }
  dimension: episode_title {
    type: string
    sql: ${TABLE}.episode_title ;;
  }
  dimension: event1 {
    type: string
    sql: ${TABLE}.event1 ;;
  }
  dimension_group: event1_time {
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
    sql: ${TABLE}.event1_time ;;
  }
  dimension: event2 {
    type: string
    sql: ${TABLE}.event2 ;;
  }
  dimension_group: event2_time {
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
    sql: ${TABLE}.event2_time ;;
  }
  dimension: event3 {
    type: string
    sql: ${TABLE}.event3 ;;
  }
  dimension_group: event3_time {
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
    sql: ${TABLE}.event3_time ;;
  }


  measure: count_users_from_event_1 {
    label: "Open First Story"
    type: number
    sql: count(distinct case when event1 = 'Open Episode' then ${user_id} else null end) ;;
  }
  measure: count_users_from_event_2 {
    label: "Actual Read on First Story"
    type: number
    sql: count(distinct case when event2 = 'Open Episode' then ${user_id} else null end) ;;
  }
  measure: count_users_from_event_3 {
    label: "Purchase"
    type: number
    sql: count(distinct case when event3 = 'Purchase Coins' then ${user_id} else null end) ;;
  }

  measure: count_clicks_from_event_1 {
    type: number
    sql: count(case when event1 = 'Open Episode' then ${user_id} else null end) ;;
  }
  measure: count_clicks_from_event_2 {
    type: number
    sql: count(case when event2 = 'Open Episode' then ${user_id} else null end) ;;
  }
  measure: count_clicks_from_event_3 {
    type: number
    sql: count(case when event3 = 'Purchase Coins' then ${user_id} else null end) ;;
  }

}
