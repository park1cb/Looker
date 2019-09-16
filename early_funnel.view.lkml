view: early_funnel {
  derived_table: {
    sql: select amplitude_id,'Open Episode' as event,min(event_time) as event_time
      from hive.dw.dw_amplitude amp

      where event_type='Open Episode'
      and base_date>=date '2019-09-01'
      group by 1

      union

      select amplitude_id,'Actual Reading' as event,min(event_time)

      from
      (
      select amplitude_id,event_time,json_extract_scalar(event_properties, '$["Story Id"]'),rank() over (partition by amplitude_id,json_extract_scalar(event_properties, '$["Story Id"]') order by event_time) as rank
      from hive.dw.dw_amplitude amp
      where event_type='Open Episode'
      and base_date>=date '2019-09-01'
      group by 1,2,3
      )

      where rank=3
      group by 1,2

      union

      select amplitude_id,'Search',min(event_time)
      from hive.dw.dw_amplitude
      where base_date>=date '2019-09-01'
      and event_type='Search'
      group by 1,2

      union

      select amplitude_id, 'Purchase Coins',min(event_time) as event_time
      from hive.dw.dw_amplitude
      where base_date>=date'2019-09-01'
      and event_type='Purchase Coins'
      group by 1,2

      union

      select  amplitude_id, 'Viewed Story Screen',min(event_time) as event_time
      from hive.dw.dw_amplitude
      where event_type ='Viewed Story Screen'
      and base_date>=date'2019-09-01'
      group by 1,2

      union

      select amplitude_id,'Open Second Story',min(event_time)
      from
      (
      select amplitude_id,event_time,json_extract_scalar(event_properties, '$["Story Id"]') story_id,lag(json_extract_scalar(event_properties, '$["Story Id"]')) over (partition by amplitude_id order by event_time) as second_story--,rank() over (order by amplitude_id,json_extract_scalar(event_properties, '$["Story Id"]'))
      from hive.dw.dw_amplitude amp
      where event_type='Open Story'
      and base_date>=date '2019-09-01'
      )
      where second_story is not null
      and story_id<>second_story
      group by 1,2
       ;;
  }

  suggestions: no



  dimension: amplitude_id {
    type: string
    sql: ${TABLE}.amplitude_id ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension_group: event_time {
    type: time
    sql: ${TABLE}.event_time ;;
  }

  measure: Open_Episode {
    label: "Open Episode"
    type: count_distinct
    filters: {
      field: event
      value: "Open Episode"
    }
    sql: ${amplitude_id} ;;
  }

  measure: Actual_Reading {
    label: "Actual Reading"
    type: count_distinct
    filters: {
      field: event
      value: "Actual Reading"
    }
    sql: ${amplitude_id} ;;
  }

}
