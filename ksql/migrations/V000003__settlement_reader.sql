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