view: payer_analysis {
  derived_table: {
    sql: select
        u.id as user_id
        , select case when device.platform='android' then device.adid when device.platform='ios' then coalesce(device.idfv,device.adid) end as device_id
        , cu.user_id as paid_user_id
        , cu.story_id
        , cu.used_at as created_at
        , cu.coin_type as sales_type
        , u.joined_at
        , s.writer_id as writer_id
        , s.title
        , s.chapter_count
        , s.is_completed
        , s_info.first_published_at
        , s_info.completed_at
        , s_info.total_episodes
        , s.views
        , e.no as episode_no
        , cu.amount as coins
        , tscv.value as writer_payout
        , date_diff('hour',u.joined_at,cu.used_at)/24 as days
      from mysql.gatsby.users u

      left join mart.mart.coin_used_devices cu
      on u.id=cu.user_id

      left join mysql.gatsby.stories s
      on cu.story_id = s.id

      join mysql.gatsby.user_devices device
      on cu.adjust_id=device.adjust_id

      left join
      (
        select story.id,min(epi.published_at) as first_published_at,max(epi."no") as total_episodes,max(epi.published_at) as completed_at
        from mysql.gatsby.stories story
        join mysql.gatsby.episodes epi
        on epi.story_id=story.id
        group by 1
      )s_info
      on s_info.id=s.id


      left join mysql.gatsby.episodes e
      on cu.episode_id = e.id



      left join mysql.gatsby.transfer_story_coin_values tscv
      on tscv.story_id=s.id



 ;;
  }

  suggestions: no

  dimension: paid_user_adjust_id {
    type: string
    sql: ${TABLE}.paid_user_adjust_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: paid_user_id {
    type: number
    sql: ${TABLE}.paid_user_id ;;
  }

  dimension:story_id {
    type: number
    sql: ${TABLE}.story_id ;;
  }


  dimension_group: created_at {
    label: "purchased_at"
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
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.created_at ;;
  }

  dimension: sales_type {
    type: string
    sql: ${TABLE}.sales_type ;;
  }

  dimension: is_purchased {
    type: yesno
    sql: ${sales_type} in ('one-time','subscription') ;;
  }

  dimension_group: joined_at {
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
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.joined_at ;;
  }

  dimension: writer_id {
    type: number
    sql: ${TABLE}.writer_id ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: chapter_count {
    type: number
    sql: ${TABLE}.chapter_count ;;
  }

  dimension: is_completed {
    type: yesno
    sql: ${TABLE}.is_completed=1;;
  }

  dimension: first_published_at {
    description: "first episode published date"
    type: date
    sql: ${TABLE}.first_published_at ;;
  }

  dimension: completed_at {
    description: "episode completed date"
    type: date
    sql: case when ${TABLE}.is_completed=1 then ${TABLE}.completed_at else null end ;;
  }

  dimension: total_available_episodes_in_DB {
    description: "current available episodes in the database"
    type: number
    sql: ${TABLE}.total_episodes ;;
  }


  dimension: episode_no {
    type: number
    sql: ${TABLE}.episode_no ;;
  }

  dimension: views {
    type: number
    sql: ${TABLE}.views ;;
  }

  dimension: coins {
    type: number
    sql: ${TABLE}.coins ;;
  }

  dimension: days {
    type: number
    sql: ${TABLE}."days" ;;
  }

  dimension: payer_cohort {
    case: {
      when: {
        sql: ${days} is null ;;
        label: "Non PU"
      }
      when: {
        sql: ${days}=0;;
        label: "D0"
      }
      when: {
        sql: ${days}=1;;
        label: "D1"
      }
      when: {
        sql: ${days}=2;;
        label: "D2"
      }
      when: {
        sql: ${days}=3;;
        label: "D3"
      }
      else:"D4+"
    }
  }

  dimension: payer_cohort_Ashley {
    case: {
      when: {
        sql: ${days} is null ;;
        label: "Non PU"
      }
      when: {
        sql: ${days}=0;;
        label: "D0"
      }
      when: {
        sql: ${days}=1;;
        label: "D1"
      }
      when: {
        sql: ${days}=2;;
        label: "D2"
      }
      when: {
        sql: ${days}=3;;
        label: "D3"
      }

      when: {
        sql: ${days}=4;;
        label: "D4"
      }

      when: {
        sql: ${days}=5;;
        label: "D5"
      }

      when: {
        sql: ${days}=6;;
        label: "D6"
      }

      when: {
        sql: ${days}=7;;
        label: "D7"
      }
      else:"D8+"
    }
  }

  dimension: writer_payout {
    type: number
    sql: ${TABLE}.writer_payout ;;
    value_format: "$0.00000"
  }

  dimension: high_margin_story_flag {
    type: yesno
    sql: ${writer_payout}<0.042 or ${writer_id}=705918 ;;
  }

  measure: total_available_episode {
    type: number
    sql: max(${episode_no}) ;;
  }


  measure: new_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: new_dist_paid_users {
    type: count_distinct
    sql: ${paid_user_id} ;;
  }

  measure: writer_payout_cost {
    type: sum
    sql: ${writer_payout} ;;
    value_format_name: usd
  }

  #measure: paying_transactions {
  #  type: sum
  #  sql: case when ${paid_user_id} is not null then 1 else 0 end ;;
  #}

  measure: total_coins {
    type: sum
    sql: ${coins} ;;
  }






}
