view: braze_canvas_entry {
  derived_table: {
    sql: select distinct canvas_id,canvas_name,canvas_id,canvas_variation_id,external_user_id
      from hive.dw.dw_braze_users_canvas_entry
      where canvas_id={%parameter canvas_id%}
       ;;
  }

  suggestions: no

  parameter: canvas_id {
    type: string
    default_value: "b432ae35-d5c2-41ae-a6ca-01917314c381"
  }


  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }


  dimension: external_user_id {
    type: number
    sql: ${TABLE}.external_user_id ;;
    primary_key: yes
  }




  dimension: canvas_name {
    type: string
    sql: ${TABLE}.canvas_name ;;
  }

  dimension: canvas_variation_id {
    type: string
    sql: ${TABLE}.canvas_variation_id ;;
  }

  measure: user_count {
    type: count_distinct
    sql: ${external_user_id} ;;
  }



}
