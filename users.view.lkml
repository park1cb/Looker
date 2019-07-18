view: users {
  sql_table_name: mysql.gatsby.users ;;
  suggestions: no

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: access_token {
    type: string
    sql: ${TABLE}.access_token ;;
  }

  dimension: bio {
    type: string
    sql: ${TABLE}.bio ;;
  }

  dimension: coins {
    type: number
    sql: ${TABLE}.coins ;;
  }

  dimension: deposit_coins {
    type: number
    sql: ${TABLE}.deposit_coins ;;
  }

  dimension: earned_coins {
    type: number
    sql: ${TABLE}.earned_coins ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: facebook {
    type: string
    sql: ${TABLE}.facebook ;;
  }

  dimension: fb_id {
    type: string
    sql: ${TABLE}.fb_id ;;
  }

  dimension: has_agreed {
    type: number
    sql: ${TABLE}.has_agreed ;;
  }

  dimension: homepage {
    type: string
    sql: ${TABLE}.homepage ;;
  }

  dimension: instagram {
    type: string
    sql: ${TABLE}.instagram ;;
  }

  dimension: is_publisher {
    type: number
    sql: ${TABLE}.is_publisher ;;
  }

  dimension: is_verified {
    type: number
    sql: ${TABLE}.is_verified ;;
  }

  dimension: is_writer {
    type: number
    sql: ${TABLE}.is_writer ;;
  }

  dimension_group: joined {
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
    sql: ${TABLE}.joined_at ;;
  }

  dimension: level {
    type: number
    sql: ${TABLE}.level ;;
  }

  dimension: nickname {
    type: string
    sql: ${TABLE}.nickname ;;
  }

  dimension: password {
    type: string
    sql: ${TABLE}.password ;;
  }

  dimension: string_id {
    type: string
    sql: ${TABLE}.string_id ;;
  }

  dimension: string_id_lower {
    type: string
    sql: ${TABLE}.string_id_lower ;;
  }

  dimension: subscriber_count {
    type: number
    sql: ${TABLE}.subscriber_count ;;
  }

  dimension: thumb_url {
    type: string
    sql: ${TABLE}.thumb_url ;;
  }

  dimension: twitter {
    type: string
    sql: ${TABLE}.twitter ;;
  }

  dimension: username {
    type: string
    sql: ${TABLE}.username ;;
  }

  dimension: username_lower {
    type: string
    sql: ${TABLE}.username_lower ;;
  }

  measure: count {
    type: count
    drill_fields: [id, username, nickname]
  }
}
