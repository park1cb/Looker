view: new_users {
  derived_table: {
    sql: select users.id,joined_at
      from mysql.gatsby.users users
      left join mysql.gatsby.pre_signin_users pre
        on users.id = pre.pre_user_id
      where pre.pre_user_id is null
       ;;
  }

  suggestions: no


  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  measure: dist_new_users {
    type: count_distinct
    sql: ${id} ;;
  }


}
