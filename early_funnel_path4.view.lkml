view: early_funnel_path4 {
  derived_table: {
    sql: select table1.user_id
              ,table1.event_type as event1
              , table1.event_time as event1_time
              , table5.event_type as event5
              , table5.event_time as event5_time
              , table2.event_type as event2
              , table2.event_time as event2_time
              , table3.event_type as event3
              , table3.event_time as event3_time
              , table4.event_type as event4
              , table4.event_time as event4_time

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
              select  user_id,event_type,min(event_time) as event_time
              from hive.dw.dw_amplitude table5
              where event_type='Logout'
              and {% condition event1_date_filter %} table5.base_date {% endcondition %}
              group by 1,2
            )table5
            on table1.user_id=table5.user_id
            and table1.event_time < table5.event_time

          left join
            (
                select user_id,event_type,event_time as event_time--,rank() over (partition by user_id,json_extract_scalar(table2.event_properties, '$["Story Id"]') order by event_time) as rank
                from hive.dw.dw_amplitude table2
                where table2.event_type = 'Viewed Home Screen'
                and {% condition event1_date_filter %} table2.base_date {% endcondition %}

            )table2
            on table1.user_id= table2.user_id
            and table5.event_time < table2.event_time

          left join
            (
                select table3.user_id,event_type,event_time,json_extract_scalar(table3.event_properties, '$["Story Id"]') as story_id,rank() over (partition by user_id order by event_time) as rank
                from hive.dw.dw_amplitude table3

                where event_type='Open Episode'
                and {% condition event1_date_filter %} table3.base_date {% endcondition %}
                and table3.user_id>0
            )table3
            on table1.user_id=table3.user_id
            and table2.event_time < table3.event_time
            and table3.rank=2

          left join
            (
            select user_id,event_type,event_time as event_time,json_extract_scalar(table4.event_properties, '$["Story Id"]') as story_id,rank() over (partition by user_id,json_extract_scalar(table4.event_properties, '$["Story Id"]') order by event_time) as rank
            from hive.dw.dw_amplitude table4
                where table4.event_type = 'Open Episode'
                and {% condition event1_date_filter %} table4.base_date {% endcondition %}
                group by 1,2,3,4
            )table4
            on table1.user_id= table4.user_id
            and table3.event_time < table4.event_time
            and table3.story_id = table4.story_id
            and table4.rank=3

          where table1.rank=1  ;;
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

  dimension: event4 {
    type: string
    sql: ${TABLE}.event4 ;;
  }
  dimension_group: event4_time {
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
    sql: ${TABLE}.event4_time ;;
  }

  dimension: event5 {
    type: string
    sql: ${TABLE}.event5 ;;
  }
  dimension_group: event5_time {
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
    sql: ${TABLE}.event5_time ;;
  }



  measure: count_users_from_event_1 {
    label: "Open First Story"
    type: number
    sql: count(distinct case when event1 = 'Open Episode' then ${user_id} else null end) ;;
  }
  measure: count_users_from_event_2 {
    label: "Viewed Story Screen"
    type: number
    sql: count(distinct case when event2 = 'Viewed Home Screen' then ${user_id} else null end) ;;
  }
  measure: count_users_from_event_3 {
    label: "Open Second Story"
    type: number
    sql: count(distinct case when event3 = 'Open Episode' then ${user_id} else null end) ;;
  }

  measure: count_users_from_event_4 {
    label: "Actual Read Second Story"
    type: number
    sql: count(distinct case when event4 = 'Open Episode' then ${user_id} else null end) ;;
  }

  measure: count_users_from_event_5 {
    label: "Log Out"
    type: number
    sql: count(distinct case when event5 = 'Logout' then ${user_id} else null end) ;;
  }

  measure: count_clicks_from_event_1 {
    type: number
    sql: count(case when event1 = 'Open Episode' then ${user_id} else null end) ;;
  }
  measure: count_clicks_from_event_2 {
    type: number
    sql: count(case when event2 = 'Viewed Home Screen' then ${user_id} else null end) ;;
  }
  measure: count_clicks_from_event_3 {
    type: number
    sql: count(case when event3 = 'Open Episode' then ${user_id} else null end) ;;
  }
  measure: count_clicks_from_event_4 {
    type: number
    sql: count(case when event4 = 'Open Episode' then ${user_id} else null end) ;;
  }

  measure: count_clicks_from_event_5 {
    type: number
    sql: count(case when event4 = 'Logout' then ${user_id} else null end) ;;
  }


}
