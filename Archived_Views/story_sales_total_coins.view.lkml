view: story_sales_total_coins {
    derived_table: {
      sql:     select *
    from ${story_sales_by_cohort_raw_data.SQL_TABLE_NAME} a
    where story_id={% parameter story_id %}
         ;;
  }

    suggestions: no


    dimension_group: created_at {
      type: time
      timeframes: [
        date,
        week,
        month,
        quarter,
        year,
        hour_of_day,
        day_of_week
      ]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.created_at ;;
    }

    dimension: cohort {
      type: string
      sql: ${TABLE}.cohort ;;
    }

  parameter: story_id {
    type: number
    default_value: "8602"
  }

    dimension: sales_type {
      type: string
      sql: ${TABLE}.sales_type ;;
    }

    dimension: paid_coins {
      type: yesno
      sql: ${sales_type}='one-time' or ${sales_type}='subscription' ;;
  }


    dimension: payers {
      type: number
      sql: ${TABLE}.Payers ;;
    }

    dimension: coins {
      type: number
      sql: ${TABLE}.coins ;;
    }

    measure: total_coins {
      type: sum
      sql: ${coins} ;;
    }

  }
