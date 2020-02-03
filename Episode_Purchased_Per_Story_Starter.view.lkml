view: episode_purchased_per_story_starter {
  derived_table: {
      sql: select
              date_trunc('day',users.installed_at) as date
              ,day
              ,users.organic_users+users.paid_users as new_users
              ,Case
              when {% parameter network_filter %}='Organic' Then
                cast(COALESCE(element_at(kr,'Organic'),0) as double) /cast(nullif(COALESCE(users.organic_users,0),0) as double)
              when {% parameter network_filter %}='Paid' Then
                cast(COALESCE(element_at(kr,'Paid'),0) as double) /cast(nullif(COALESCE(users.paid_users,0),0) as double)
              when {% parameter network_filter %}='Everything' then
              cast(( COALESCE(element_at(kr,'Organic'),0) +  COALESCE(element_at(kr,'Paid'),0)) as double)/cast(nullif(( COALESCE(users.organic_users,0)+ COALESCE(users.paid_users,0)),0) as double)
              End as Value
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
                ,case when network in ('Organic','Branch(iOS)','Branch(Android)') then 'Organic' else 'Paid' end as network
                ,count(adjust_id) as new_installed_users

                from mart.mart.install_attribution_adjust a
                ------------------------------------
                where a.adjust_id in
                (
                  select distinct adjust_id
                  from ${cohort_data_purchase_raw_data.SQL_TABLE_NAME} a
                  where story_id={% parameter story_id %}
                  and date_diff('hour',installed_at,used_at)/24=0
                )
                ------------------------------------

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
                ,map_agg(network,episode_read) as kr
                from
                (
                  select cast(a.installed_at+ interval '5' hour as date) installed_at,platform,purchased_user,network,cohort as day,sum(a.amount)/3 as episode_read
                  from ${cohort_data_purchase_raw_data.SQL_TABLE_NAME} a
                  join
                  (
                    select adjust_id
                    ,cast(installed_at+interval '5' hour as date) as installed_at
                    ,sum(amount) as amount
                    , CASE WHEN
                        PERCENT_RANK() OVER (PARTITION by cast(installed_at+interval '5' hour as date)  ORDER BY sum(amount) DESC)<.1 Then 'Top 10%'
                        WHEN
                        PERCENT_RANK() OVER (PARTITION by cast(installed_at+interval '5' hour as date)  ORDER BY sum(amount) DESC)<.2 Then 'Top 10%-20%'
                        WHEN
                        PERCENT_RANK() OVER (PARTITION by cast(installed_at+interval '5' hour as date)  ORDER BY sum(amount) DESC)<.4 Then 'Top 20%-40%'
                        WHEN
                        PERCENT_RANK() OVER (PARTITION by cast(installed_at+interval '5' hour as date)  ORDER BY sum(amount) DESC)<.6 Then 'Top 40%-60%'
                        WHEN
                        PERCENT_RANK() OVER (PARTITION by cast(installed_at+interval '5' hour as date)  ORDER BY sum(amount) DESC)<.8 Then 'Top 60%-80%'
                        ELSE 'Top 80%-100%' end as percentile
                    from ${cohort_data_purchase_raw_data.SQL_TABLE_NAME}
                    where purchased_user='Y'
                    group by 1,2
                  )b
                  on a.adjust_id=b.adjust_id
                  where purchased_user='Y'
                  and a.adjust_id in
                  (
                    select distinct adjust_id
                    from ${cohort_data_purchase_raw_data.SQL_TABLE_NAME} a
                    where story_id={% parameter story_id %}
                    and date_diff('hour',installed_at,used_at)/24=0
                  )
                  {% if percentile._in_query %}
                  and
                  percentile = {% parameter percentile %}
                  {% else %} {% endif %}

              ---------------------------

              ---------------------------
                  group by 1,2,3,4,5
                )
                group by 1,2

              )episode_read
              on users.installed_at=episode_read.installed_at


              where day>=0
               ;;
    }

    suggestions: no

    parameter: story_id {
      type: number
      default_value: "8602"
    }


    parameter: network_filter{
      type: string
      allowed_value: { value: "Everything" }
      allowed_value: { value: "Paid" }
      allowed_value: { value: "Organic"}
    }

    parameter: percentile {
      type: string
      allowed_value: { label: "Everything" value: "" }
      allowed_value: { label: "Top 10%" value: "Top 10%" }
      allowed_value: { label: "Top 10%-20%" value: "Top 10%-20%" }
      allowed_value: { label: "Top 20%-40%" value: "Top 20%-40%" }
      allowed_value: { label: "Top 40%-60%" value: "Top 40%-60%" }
      allowed_value: { label: "Top 60%-80%" value: "Top 60%-80%" }
      allowed_value: { label: "Top 80%-100%" value: "Top 80%-100%" }
    }
    #########################

    dimension_group: date {
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

    measure: episode_read {
      type: sum
      sql: ${value} ;;
      value_format_name: decimal_2
    }

  }
