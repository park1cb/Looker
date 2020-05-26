view: multi_story_reader_dashboard {
  derived_table: {
    sql: with mast as
      (
      select distinct
      user_id
      ,story_id
      ,case when cohort_days=0 then 'D0' when cohort_days<=3 then 'D3' when cohort_days<=7 then 'D7' when cohort_days<=15 then 'D15' when cohort_days<=30 then 'D30' end cohort
      ,max(episode_count) over (partition by user_id,story_id,case when cohort_days=0 then 'D0' when cohort_days<=3 then 'D3' when cohort_days<=7 then 'D7' when cohort_days<=15 then 'D15' when cohort_days<=30 then 'D30' end) as episode_reads
      from ${user_story_count_live_ops_dasshboard.SQL_TABLE_NAME}
      --where case when cohort_days=0 then 'D0' when cohort_days<=3 then 'D3' when cohort_days<=7 then 'D7' when cohort_days<=15 then 'D15' when cohort_days<=30 then 'D30' end is not null


      group by 1,2,3,cohort_days,episode_count
      )
      ,mast2 as
      (
      select distinct
      user_id
      ,story_id
      ,case when cohort='D0' and episode_reads>=5 then 1 end as D0
      ,case when cohort='D3' and episode_reads>=5 then 1 end as D3
      ,case when cohort='D7' and episode_reads>=5 then 1 end as D7
      ,case when cohort='D15' and episode_reads>=5 then 1 end as D15
      ,case when cohort='D30' and episode_reads>=5 then 1 end as D30
      from mast
      )


      ,mast3 as
      (
      select user_id,story_id,coalesce(D0,0) as D0,coalesce(D0,D3,0) as D3,coalesce(D0,D3,D7,0) as D7,coalesce(D0,D3,D7,D15,0) as D15,coalesce(D0,D3,D7,D15,D30,0) as D30
      from mast2
      --where user_id=2850543
      --and story_id=8602
      )
      ,mast4 as
      (
      select *,max(D0+D3+D7+D15+D30) over (partition by user_id,story_id) row_max
      from mast3
      )

      select user_id,sum(D0) as D0,sum(D3) as D3,sum(D7) as D7,sum(D15) as D15,sum(D30) as D30
      from mast4
      where row_max=D0+D3+D7+D15+D30
      --and user_id=2591392
      group by 1
       ;;
  }

  suggestions: no

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }



  dimension: d0 {
    type: number
    sql: ${TABLE}.D0 ;;
  }

  dimension: d3 {
    type: number
    sql: ${TABLE}.D3 ;;
  }

  dimension: d7 {
    type: number
    sql: ${TABLE}.D7 ;;
  }

  dimension: d15 {
    type: number
    sql: ${TABLE}.D15 ;;
  }

  dimension: d30 {
    type: number
    sql: ${TABLE}.D30 ;;
  }

  measure: user_count {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: D0_story_read {
    type: sum
    sql: ${d0} ;;

  }

  measure: D3_story_read {
    type: sum
    sql: ${d3} ;;
  }

  measure: D7_story_read {
    type: sum
    sql: ${d7} ;;
  }

  measure: D15_story_read {
    type: sum
    sql: ${d15} ;;
  }

  measure: D30_story_read {
    type: sum
    sql: ${d30} ;;
  }



}

# If necessary, uncomment the line below to include explore_source.
# include: "live_ops.model.lkml"
explore: multi_story_reader_dashboard2 {}
view: multi_story_reader_dashboard2 {
  derived_table: {
    explore_source: multi_story_reader_dashboard {
      column: joined_at_week { field: new_users.joined_at_week }
      column: user_id {}
      column: D0_story_read {}
      column: D3_story_read {}
      column: D7_story_read {}
      column: D15_story_read {}
      column: D30_story_read {}
      filters: {
        field: new_users.joined_at_week
        value: "5 weeks"
      }
    }
  }
  dimension: joined_at_week {
    type: date_week
  }
  dimension: user_id {
    type: number
  }
  dimension: D0_story_read {
    type: number
  }
  dimension: D3_story_read {
    type: number
  }
  dimension: D7_story_read {
    type: number
  }
  dimension: D15_story_read {
    type: number
  }
  dimension: D30_story_read {
    type: number
  }







  dimension: D0_Bucket {
    case: {
      when: {
        sql: ${D0_story_read} >= 4;;
        label: "4+ Stories"
      }
      when: {
        sql: ${D0_story_read} = 3;;
        label: "3 Stories"
      }
      when: {
        sql: ${D0_story_read} = 2;;
        label: "2 Stories"
      }
      when: {
        sql: ${D0_story_read} = 1;;
        label: "1 Story"
      }
      else: "0 Story"
    }
  }

  dimension: D3_Bucket {
    case: {
      when: {
        sql: ${D3_story_read} >= 4;;
        label: "4+ Stories"
      }
      when: {
        sql: ${D3_story_read} = 3;;
        label: "3 Stories"
      }
      when: {
        sql: ${D3_story_read} = 2;;
        label: "2 Stories"
      }
      when: {
        sql: ${D3_story_read} = 1;;
        label: "1 Story"
      }
      else: "0 Story"
    }
  }

  dimension: D7_Bucket {
    case: {
      when: {
        sql: ${D7_story_read} >= 4;;
        label: "4+ Stories"
      }
      when: {
        sql: ${D7_story_read} = 3;;
        label: "3 Stories"
      }
      when: {
        sql: ${D7_story_read} = 2;;
        label: "2 Stories"
      }
      when: {
        sql: ${D7_story_read} = 1;;
        label: "1 Story"
      }
      else: "0 Story"
    }
  }

  dimension: D15_Bucket {
    case: {
      when: {
        sql: ${D15_story_read} >= 4;;
        label: "4+ Stories"
      }
      when: {
        sql: ${D15_story_read} = 3;;
        label: "3 Stories"
      }
      when: {
        sql: ${D15_story_read} = 2;;
        label: "2 Stories"
      }
      when: {
        sql: ${D15_story_read} = 1;;
        label: "1 Story"
      }
      else: "0 Story"
    }
  }

  dimension: D30_Bucket {
    case: {
      when: {
        sql: ${D30_story_read} >= 4;;
        label: "4+ Stories"
      }
      when: {
        sql: ${D30_story_read} = 3;;
        label: "3 Stories"
      }
      when: {
        sql: ${D30_story_read} = 2;;
        label: "2 Stories"
      }
      when: {
        sql: ${D30_story_read} = 1;;
        label: "1 Story"
      }
      else: "0 Story"
    }
  }

  measure: user_story_count {
    type: count_distinct
    sql: ${user_id} ;;
  }




}
