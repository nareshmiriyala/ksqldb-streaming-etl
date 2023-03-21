# ksqldb-streaming-etl

Add your aws aws_access_key_id and aws_secret_access_key into docker-compose.yml file and create S3 bucket workspace-summary-s3-bucket.

Postgres Debezium(debezium-debezium-connector-postgresql) and Confluent-S3-sink connector are downloaded into
confluent-hub-components folder.

#### Start the stack

```shell
docker-compose up -d
```

Seed data should be inserted into workspace, lodgement,settlement and subscriber postgres databases.

```shell
docker ps
```

The above command should provide the status of all docker containers.
After few minutes docker containers should be up a running.

## Start the Postgres source connectors

With all the seed data in place, you can process it with ksqlDB.

## Please follow either Automated or Manual approach to create connectors and streams

- ### Automated approach to create connectors and streams

Run the below command to create the initial streams and datasets:

```sh
docker-compose run --entrypoint "/ksql/migrate" ksqldb-cli-migration
```

This should end with output similar to:

```shell

 Stream Name         | Kafka Topic                     | Key Format | Value Format | Windowed 
----------------------------------------------------------------------------------------------
 KSQL_PROCESSING_LOG | default_ksql_processing_log     | KAFKA      | JSON         | false    
 LODGEMENT_STREAM    | lodgement_db.public.lodgement   | KAFKA      | AVRO         | false    
 MIGRATION_EVENTS    | default_ksql_MIGRATION_EVENTS   | KAFKA      | JSON         | false    
 SETTLEMENT_STREAM   | settlement_db.public.settlement | KAFKA      | AVRO         | false    
 SUBSCRIBER_STREAM   | subscriber_db.public.subscriber | KAFKA      | AVRO         | false    
 WORKSPACE_STREAM    | workspace_db.public.workspace   | KAFKA      | AVRO         | false    
----------------------------------------------------------------------------------------------

```

_Note: To recreate the database from scratch, use this `docker-compose` command instead_

```sh
docker-compose up -d --renew-anon-volumes --force-recreate
```

Once successful AWS S3 should have objects created under workspace-summary-s3-bucket.

#### Tear down stack

```shell
docker-compose down
```

- ### Manual CLI approach to create connectors and streams

Connect to ksqlDB's server by using its interactive
CLI. Run the following command from your host:

```shell
docker exec -it ksqldb-cli ksql http://ksqldb-server:8088
```

Now you can ask Debezium to stream the Postgres changelog into Kafka. Invoke the following command in ksqlDB, which
creates a Debezium source connector and writes all of its changes to Kafka topics:

#### Create workspace connector

```shell
CREATE SOURCE CONNECTOR workspace_reader WITH (
    'connector.class' = 'io.debezium.connector.postgresql.PostgresConnector',
    'database.hostname' = 'postgres-workspace',
    'database.port' = '5432',
    'database.user' = 'postgres-workspace-user',
    'database.password' = 'postgres-workspace-pwd',
    'database.dbname' = 'workspace_db',
    'database.server.name' = 'workspace_db',
    'table.whitelist' = 'public.workspace',
    'transforms.unwrap.type' = 'io.debezium.transforms.ExtractNewRecordState',
    'transforms.unwrap.drop.tombstones' = 'false',
    'transforms.unwrap.delete.handling.mode' = 'rewrite',
     'transforms' = 'unwrap',
     'time.precision.mode' = 'connect',
      'plugin.name' = 'pgoutput'
);

```

#### Create lodgement connector

```shell
CREATE SOURCE CONNECTOR lodgement_reader WITH (
    'connector.class' = 'io.debezium.connector.postgresql.PostgresConnector',
    'database.hostname' = 'postgres-lodgement',
    'database.port' = '5432',
    'database.user' = 'postgres-lodgement-user',
    'database.password' = 'postgres-lodgement-pwd',
    'database.dbname' = 'lodgement_db',
    'database.server.name' = 'lodgement_db',
    'table.whitelist' = 'public.lodgement',
    'transforms.unwrap.type' = 'io.debezium.transforms.ExtractNewRecordState',
    'transforms.unwrap.drop.tombstones' = 'false',
    'transforms.unwrap.delete.handling.mode' = 'rewrite',
         'transforms' = 'unwrap',
     'time.precision.mode' = 'connect',
      'plugin.name' = 'pgoutput'
);

```

#### Create settlement connector

```shell
CREATE SOURCE CONNECTOR settlement_reader WITH (
    'connector.class' = 'io.debezium.connector.postgresql.PostgresConnector',
    'database.hostname' = 'postgres-settlement',
    'database.port' = '5432',
    'database.user' = 'postgres-settlement-user',
    'database.password' = 'postgres-settlement-pwd',
    'database.dbname' = 'settlement_db',
    'database.server.name' = 'settlement_db',
    'table.whitelist' = 'public.settlement',
    'transforms.unwrap.type' = 'io.debezium.transforms.ExtractNewRecordState',
    'transforms.unwrap.drop.tombstones' = 'false',
    'transforms.unwrap.delete.handling.mode' = 'rewrite',
         'transforms' = 'unwrap',
     'time.precision.mode' = 'connect',
      'plugin.name' = 'pgoutput'
);

```

#### Create subscriber connector

```shell
CREATE SOURCE CONNECTOR subscriber_reader WITH (
    'connector.class' = 'io.debezium.connector.postgresql.PostgresConnector',
    'database.hostname' = 'postgres-subscriber',
    'database.port' = '5432',
    'database.user' = 'postgres-subscriber-user',
    'database.password' = 'postgres-subscriber-pwd',
    'database.dbname' = 'subscriber_db',
    'database.server.name' = 'subscriber_db',
    'table.whitelist' = 'public.subscriber',
    'transforms.unwrap.type' = 'io.debezium.transforms.ExtractNewRecordState',
    'transforms.unwrap.drop.tombstones' = 'false',
    'transforms.unwrap.delete.handling.mode' = 'rewrite',
         'transforms' = 'unwrap',
     'time.precision.mode' = 'connect',
      'plugin.name' = 'pgoutput'
    
);

```

#### Create the ksqlDB source streams

For ksqlDB to be able to use the topics that Debezium created, you must declare streams over it. Because you configured
Kafka Connect with Schema Registry, you don't need to declare the schema of the data for the streams, because it's
inferred from the schema that Debezium writes with.

Run the following statement to create a stream over the workspace table.

```shell
CREATE STREAM workspace_stream WITH (
    kafka_topic = 'workspace_db.public.workspace',
    value_format = 'avro'
);

```

```shell
CREATE STREAM lodgement_stream WITH (
    kafka_topic = 'lodgement_db.public.lodgement',
    value_format = 'avro'
);

```

```shell
CREATE STREAM settlement_stream WITH (
    kafka_topic = 'settlement_db.public.settlement',
    value_format = 'avro'
);

```

```shell
CREATE STREAM subscriber_stream WITH (
    kafka_topic = 'subscriber_db.public.subscriber',
    value_format = 'avro'
);

```

#### Join the streams together

This query will provide summary of workspace created with in last 7 days.

```shell
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
```

#### Sink the data into S3 connector

```shell
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
```

Try inserting more rows into Postgres database. Notice how the results update quickly in the S3 bucket.

#### Tear down stack

```shell
docker-compose down
```