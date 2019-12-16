view: user_story_retention {
  derived_table: {
    sql: with mast as
      (
      select *
      from ${user_story_retention_raw_data.SQL_TABLE_NAME}
      where story_id={% parameter story_id %}
      )

      select *
      from mast
      where min_episode=1
       ;;
  }

  suggestions: no


  dimension_group: base_date_est {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.base_date_est ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  parameter: story_id {
    type: number
    default_value: "8602"
  }


  dimension: no_ {
    type: number
    sql: ${TABLE}.no ;;
  }

  dimension: min_episode {
    type: number
    sql: ${TABLE}.min_episode ;;
  }

  measure: reader {
    type: count_distinct
    sql: ${user_id} ;;
  }


}
