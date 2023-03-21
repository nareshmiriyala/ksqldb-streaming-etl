CREATE STREAM settlement_stream WITH (
    kafka_topic = 'settlement_db.public.settlement',
    value_format = 'avro'
);