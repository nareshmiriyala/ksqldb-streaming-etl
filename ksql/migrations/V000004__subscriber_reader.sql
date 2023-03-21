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