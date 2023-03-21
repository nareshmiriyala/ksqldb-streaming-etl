CREATE STREAM subscriber_stream WITH (
    kafka_topic = 'subscriber_db.public.subscriber',
    value_format = 'avro'
);