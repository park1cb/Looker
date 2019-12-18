view: another_episode_purchase_count {
  derived_table: {
    sql: select b.title,user_id,coins,story_id
      from ${episode_count_distribution_raw_data.SQL_TABLE_NAME} a

      join mysql.gatsby.stories b
      on b.id=a.story_id

      where user_id in
      (

      select user_id
      from ${episode_count_distribution_raw_data.SQL_TABLE_NAME}
      where story_id={% parameter story_id %}
      and days<=7
      and coins/3>=30
      )
      and story_id<>{% parameter story_id %}
      and coins/3>=30
      and days<=10
       ;;
  }

  suggestions: no

  parameter: story_id {
    type: number
    default_value: "8602"
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
    link: {
      url: "https://radish.looker.com/dashboards/53?User%20ID={{ value }}"
      label: "User Profile"
      icon_url: "https://res-3.cloudinary.com/crunchbase-production/image/upload/c_lpad,h_120,w_120,f_auto,b_white,q_auto:eco/v1485884030/mi3tj8fkktvfiio8rzyu.png"
    }
  }

  dimension: paid_episode_read {
    type: number
    sql: ${TABLE}.coins/3 ;;
  }

  measure: payer_count {
    type: count_distinct
    sql: ${user_id} ;;
    drill_fields: [title,user_id,paid_episode_read]
  }


}
