view: actual_story_read_by_day {
  derived_table: {
    sql: with actual_story_read as
            (
select
date_trunc('week',users.installed_at) as date
,day
,users.organic_users+users.paid_users as new_users
,cast(actual_story_read as double)/cast(nullif(( COALESCE(users.organic_users,0)+ COALESCE(users.paid_users,0)),0) as double)
 as Value
from
(
select
installed_at
,element_at(kv,'Organic') as Organic_Users
,element_at(kv,'Paid') as Paid_Users
from
(
  select
  installed_at
  ,map_agg(network,new_installed_users)  as kv
  from
  (
   select cast(installed_at + interval '5' hour as date) as installed_at
  ,case when network_name in ('Organic','Branch(iOS)','Branch(Android)') then 'Organic' else 'Paid' end as network
  ,count(adid) as new_installed_users

  from mart.mart.user_mapper_adjust a
  ------------------------------------
   --and cohort=0
   --and story_id=8602
----------------------------------------
   group by 1,2

  )
  group by 1
)

) users


left join
(
  select
  installed_at
  ,day
  ,network
  ,sum(actual_story_read) as actual_story_read
  from
  (


    select distinct
    cast(a.installed_at+interval '5' hour as date) as installed_at
    ,a.adjust_id
    ,cohort as day
    ,a.story_id
    ,a.network
    --,case when cohort>=actual_read_day then 1 else 0 end as actual_story_read
    ,case when actual_read_day is not null then 1 else 0 end as actual_story_read
    from ${cohort_data_purchase_raw_data.SQL_TABLE_NAME} a

    left join
    (
    select installed_at,adjust_id,platform,purchased_user,network,story_id,min(day) as actual_read_day
    from
    (
    select *,sum(episode_reads) over(PARTITION BY adjust_id,story_id ORDER BY day ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_read
    from
    (
    select cast(a.installed_at+ interval '5' hour as date) installed_at,a.adjust_id,platform,purchased_user,network,cohort as day,story_id,sum(a.amount)/3 as episode_reads
    from ${cohort_data_purchase_raw_data.SQL_TABLE_NAME} a

    where purchased_user='Y'
    group by 1,2,3,4,5,6,7
    )
    )
    where cumulative_read>=10
    group by 1,2,3,4,5,6
    )actual_read
    on actual_read.adjust_id=a.adjust_id
    and actual_read.story_id=a.story_id


)
group by 1,2,3
)story_read
on users.installed_at=story_read.installed_at
where day>=0
            )


            select *
            from actual_story_read
 ;;
  }

  suggestions: no

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: date {
    type: date
    sql: ${TABLE}."date" ;;
  }

  dimension: day {
    type: number
    sql: ${TABLE}."day" ;;
  }

  dimension: new_users {
    type: number
    sql: ${TABLE}.new_users ;;
  }

  dimension: value {
    type: number
    sql: ${TABLE}.Value ;;
  }

  set: detail {
    fields: [date, day, new_users, value]
  }
}
