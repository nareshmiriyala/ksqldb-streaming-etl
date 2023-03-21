CREATE STREAM lodgement_stream WITH (
    kafka_topic = 'lodgement_db.public.lodgement',
    value_format = 'avro'
);