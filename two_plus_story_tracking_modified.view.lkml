view: two_plus_story_tracking_modified {
  derived_table: {
    sql: with filter_story as
      (

      select user_id,a.story_id,epi.epi_no,cast((sum(coins)/3) as double)/cast(epi_no as double) as coins
      from ${episode_count_distribution_raw_data.SQL_TABLE_NAME} a
      join
      (
      select story_id,max("no") as epi_no
      from mysql.gatsby.episodes
      group by 1
      )epi
      on epi.story_id=a.story_id
      where a.story_id={% parameter story_id %}
      group by 1,2,3
      having cast((sum(coins)/3) as double)/cast(epi_no as double)>=.5
      )

      ,users as
      (


      select a.user_id,b.title,story_id,sum(coins)/3 as paid_episode_number

      from ${episode_count_distribution_raw_data.SQL_TABLE_NAME} a
      join mysql.gatsby.stories b
      on b.id=a.story_id


      where a.user_id in
      (
      select user_id
      from filter_story
      )

      group by 1,2,3

      having sum(coins)/3>=30
      )

      , groups as
      (
      select user_id,case when count(distinct story_id)=1 then '0' when count(distinct story_id)=2 then '1' else '2+'end  num_group
      from users
      group by 1
      )

      select story_id,num_group,count(distinct user_id) as group_total,total_users,cast(count(distinct user_id) as double)/cast(total_users as double) as percent
      from groups
      cross join
      (
      select story_id,count(distinct user_id) as total_users
      from filter_story
      group by 1
      )
      group by 1,2,4
 ;;
  }

  suggestions: no

  parameter: story_id {
    type: number
    default_value: "8602"
  }

  dimension: num_group {
    type: string
    sql: ${TABLE}.num_group ;;
  }

  dimension: group_total {
    type: number
    sql: ${TABLE}.group_total ;;
  }

  dimension: total_users {
    type: number
    sql: ${TABLE}.total_users ;;
  }

  dimension: percent {
    type: number
    sql: ${TABLE}.percent ;;
  }

  measure: percentage {
    type: average
    sql: ${percent} ;;
    value_format_name: percent_2
  }


}
