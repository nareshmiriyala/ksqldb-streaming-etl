# ksqldb-streaming-etl

### Create the workspace table in Postgres

1) Login into postgres-workspace container

    ```shell
    docker exec -it postgres-workspace /bin/bash
    
    ```

2) Log into Postgres as the user created by default:

   ```shell
   psql -U postgres-workspace-user workspace_db
   
   ```

3) Create a table that represents the workspace

   ```roomsql
   CREATE TABLE workspace (id UUID PRIMARY KEY,mortgage_ref TEXT, status TEXT, susbscriber_id UUID,created_date_time timestamp);
   ```

4) Seed the table with some initial data:

   ```roomsql
   INSERT INTO workspace (id,mortgage_ref, status, susbscriber_id,created_date_time) VALUES ('dff8a5b6-c5d9-11ed-afa1-0242ac120002','ref-1', 'CREATING', 'f5f8ec5e-c5d9-11ed-afa1-0242ac120002',CURRENT_TIMESTAMP);
   INSERT INTO workspace (id,mortgage_ref, status, susbscriber_id,created_date_time) VALUES ('5d4b0101-4b41-4505-a378-3e4f8fa40ed6','ref-2', 'CREATING', 'f5f8ec5e-c5d9-11ed-afa1-0242ac120002',CURRENT_TIMESTAMP);
   ```

### Create the lodgement table in Postgres

1) Login into postgres-lodgement container

    ```shell
    docker exec -it postgres-lodgement /bin/bash
    
    ```

2) Log into Postgres as the user created by default:

   ```shell
   psql -U postgres-lodgement-user lodgement_db
   
   ```

3) Create a table that represents the lodgement

 ```roomsql
CREATE TABLE lodgement (id UUID PRIMARY KEY, status TEXT, workspace_id UUID,created_date_time timestamp);
```

4) Seed the table with some initial data:

```roomsql
INSERT INTO lodgement (id, status, workspace_id,created_date_time) VALUES ('3ea63308-c5da-11ed-afa1-0242ac120002','PENDING', 'dff8a5b6-c5d9-11ed-afa1-0242ac120002',CURRENT_TIMESTAMP);
INSERT INTO lodgement (id, status, workspace_id,created_date_time) VALUES ('4f1aa0ca-c6b1-11ed-afa1-0242ac120002','COMPLETED', 'dff8a5b6-c5d9-11ed-afa1-0242ac120002',CURRENT_TIMESTAMP);

```

### Create the settlement table in Postgres

1) Login into postgres-settlement container

    ```shell
    docker exec -it postgres-settlement /bin/bash
    
    ```

2) Log into Postgres as the user created by default:

   ```shell
   psql -U postgres-settlement-user settlement_db
   
   ```

3) Create a table that represents the settlements

```roomsql
CREATE TABLE settlement (id UUID PRIMARY KEY, status TEXT, workspace_id UUID,created_date_time timestamp);
```

4) Seed the table with some initial data:

```roomsql
INSERT INTO settlement (id, status, workspace_id,created_date_time) VALUES ('5f8c7a5a-c6b1-11ed-afa1-0242ac120002','PENDING', 'dff8a5b6-c5d9-11ed-afa1-0242ac120002',CURRENT_TIMESTAMP);
INSERT INTO settlement (id, status, workspace_id,created_date_time) VALUES ('6dcd8816-c5da-11ed-afa1-0242ac120002','PENDING', 'dff8a5b6-c5d9-11ed-afa1-0242ac120002',CURRENT_TIMESTAMP);
```

### Create the subscriber table in Postgres

1) Login into postgres-subscriber container

    ```shell
    docker exec -it postgres-subscriber /bin/bash
    
    ```

2) Log into Postgres as the user created by default:

   ```shell
   psql -U postgres-subscriber-user subscriber_db
   
   ```

3) Create a table that represents the subscribers

```roomsql
CREATE TABLE subscriber (id UUID PRIMARY KEY, name TEXT,age INT,created_date_time timestamp);
```

4) Seed the table with some initial data:

```roomsql
INSERT INTO subscriber (id, name, age,created_date_time) VALUES ('9762ba02-c5da-11ed-afa1-0242ac120002','Susbscriber_1', 30,CURRENT_TIMESTAMP);
INSERT INTO subscriber (id, name, age,created_date_time) VALUES ('6a7b4df6-c6b1-11ed-afa1-0242ac120002','Susbscriber_2', 25,CURRENT_TIMESTAMP);
```




## Start the Postgres source connectors
With all of the seed data in place, you can process it with ksqlDB. Connect to ksqlDB's server by using its interactive CLI. Run the following command from your host:

```shell
docker exec -it ksqldb-cli ksql http://ksqldb-server:8088
```
Before you issue more commands, tell ksqlDB to start all queries from earliest point in each topic:
```shell
SET 'auto.offset.reset' = 'earliest';
```
Now you can ask Debezium to stream the Postgres changelog into Kafka. Invoke the following command in ksqlDB, which creates a Debezium source connector and writes all of its changes to Kafka topics:

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

## Create the ksqlDB source streams

For ksqlDB to be able to use the topics that Debezium created, you must declare streams over it. Because you configured Kafka Connect with Schema Registry, you don't need to declare the schema of the data for the streams, because it's inferred from the schema that Debezium writes with.

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

```shell
CREATE TABLE workspace_summary_id_new_3 AS
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

```shell
CREATE STREAM my_stream_3 (
id VARCHAR,
created_date_time TIMESTAMP 
) WITH (
kafka_topic='workspace_db.public.workspace',
value_format='AVRO',
timestamp = 'created_date_time',                        
    timestamp_format = 'yyyy-MM-dd HH:mm:ss' 
);
```
CREATE STREAM my_stream (
id string,
created_date_time TIMESTAMP 'yyyy-MM-dd HH:mm:ss.SSSSSS'
) WITH (
kafka_topic='workspace_db.public.workspace',
value_format='avro'
);

select FORMAT_TIMESTAMP(CREATED_DATE_TIME, 'yyyy-MM-dd HH:mm:ss.SSS')   as created_date_time_string from workspace;

SELECT TIMESTAMPTOSTRING(CREATED_DATE_TIME,'yyyy-MM-dd HH:mm:ss') AS formatted_order_time from workspace_stream;