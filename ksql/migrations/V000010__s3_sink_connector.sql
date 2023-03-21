CREATE SOURCE CONNECTOR s3_connector WITH (
    'connector.class' = 'io.confluent.connect.s3.S3SinkConnector',
    'key.converter'='org.apache.kafka.connect.storage.StringConverter',
		'value.converter'='io.confluent.connect.avro.AvroConverter',
		'value.converter.schema.registry.url'= 'http://schema-registry:8081',
		'tasks.max'= '1',
		'topics'= 'workspace_summary_topic',
		's3.region'= 'us-east-1',
		's3.bucket.name'= 'workspace-summary-s3-bucket',
		'flush.size'= '1',
		'storage.class'= 'io.confluent.connect.s3.storage.S3Storage',
		'format.class'= 'io.confluent.connect.s3.format.json.JsonFormat',
        'partitioner.class'= 'io.confluent.connect.storage.partitioner.DefaultPartitioner'

);