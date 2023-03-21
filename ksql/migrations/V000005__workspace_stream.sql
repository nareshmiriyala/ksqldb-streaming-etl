CREATE STREAM workspace_stream WITH (
    kafka_topic = 'workspace_db.public.workspace',
    value_format = 'avro'
);