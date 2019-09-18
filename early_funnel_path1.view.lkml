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
    #default_value: "7 days"
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
view: dw_amplitude {
  sql_table_name: hive.dw.dw_amplitude ;;
  suggestions: no

  dimension: pk {
    type: string
    sql: concat(${user_id},  ${event_type}, ${event_raw}) ;;
    primary_key: yes
  }

  dimension: adid {
    type: string
    sql: ${TABLE}.adid ;;
  }

  dimension: amplitude_event_type {
    type: string
    sql: ${TABLE}.amplitude_event_type ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: app {
    type: string
    sql: ${TABLE}.app ;;
  }

  dimension_group: base {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.base_date ;;
  }

  dimension_group: base_dt {
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
    sql: ${TABLE}.base_dt ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension_group: client_event {
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
    sql: ${TABLE}.client_event_time ;;
  }

  dimension_group: client_upload {
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
    sql: ${TABLE}.client_upload_time ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: data {
    type: string
    sql: ${TABLE}.data ;;
  }

  dimension: device_brand {
    type: string
    sql: ${TABLE}.device_brand ;;
  }

  dimension: device_carrier {
    type: string
    sql: ${TABLE}.device_carrier ;;
  }

  dimension: device_family {
    type: string
    sql: ${TABLE}.device_family ;;
  }

  dimension: device_id {
    type: string
    sql: ${TABLE}.device_id ;;
  }

  dimension: device_manufacturer {
    type: string
    sql: ${TABLE}.device_manufacturer ;;
  }

  dimension: device_model {
    type: string
    sql: ${TABLE}.device_model ;;
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension: dma {
    type: string
    sql: ${TABLE}.dma ;;
  }

  dimension: event_id {
    type: string
    sql: ${TABLE}.event_id ;;
  }

  dimension: event_properties {
    type: string
    sql: ${TABLE}.event_properties ;;
  }

  dimension_group: event {
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
    sql: ${TABLE}.event_time ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: idfa {
    type: string
    sql: ${TABLE}.idfa ;;
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}.ip_address ;;
  }

  dimension: language {
    type: string
    sql: ${TABLE}.language ;;
  }

  dimension: library {
    type: string
    sql: ${TABLE}.library ;;
  }

  dimension: location_lat {
    type: string
    sql: ${TABLE}.location_lat ;;
  }

  dimension: location_lng {
    type: string
    sql: ${TABLE}.location_lng ;;
  }

  dimension: os_name {
    type: string
    sql: ${TABLE}.os_name ;;
  }

  dimension: os_version {
    type: string
    sql: ${TABLE}.os_version ;;
  }

  dimension: paying {
    type: yesno
    sql: ${TABLE}.paying ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension_group: processed {
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
    sql: ${TABLE}.processed_time ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension_group: server_upload {
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
    sql: ${TABLE}.server_upload_time ;;
  }

  dimension: session_id {
    type: number
    sql: ${TABLE}.session_id ;;
  }

  dimension: start_version {
    type: string
    sql: ${TABLE}.start_version ;;
  }

  dimension_group: user_creation {
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
    sql: ${TABLE}.user_creation_time ;;
  }

  dimension: amplitude_id {
    type: number
    sql: ${TABLE}.amplitude_id ;;
  }

  dimension: user_properties {
    type: string
    sql: ${TABLE}.user_properties ;;
  }

  dimension: uuid {
    type: string
    sql: ${TABLE}.uuid ;;
  }

  dimension: version_name {
    type: string
    sql: ${TABLE}.version_name ;;
  }

}
