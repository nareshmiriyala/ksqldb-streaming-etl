CREATE TABLE workspace_summary_id WITH(kafka_topic='workspace_summary_topic') AS
    SELECT w.id AS workspace_id,
           latest_by_offset(w.susbscriber_id) AS subscriber_id,
           latest_by_offset(w.mortgage_ref) AS mortgage_ref,
           latest_by_offset(w.status) AS workspace_status,
           latest_by_offset(ld.status) AS lodgement_status,
           latest_by_offset(st.status) AS settlement_status,
           latest_by_offset(sb.name) AS subscriber_name,
           latest_by_offset(sb.age) AS subscriber_age
    FROM workspace_stream  w
    LEFT JOIN lodgement_stream  ld WITHIN 7 DAYS  ON w.id=ld.workspace_id
     LEFT JOIN settlement_stream  st  WITHIN 7 DAYS ON w.id=st.workspace_id
     LEFT JOIN subscriber_stream  sb WITHIN 7 DAYS ON w.susbscriber_id=sb.id
     GROUP BY w.id
     EMIT CHANGES;