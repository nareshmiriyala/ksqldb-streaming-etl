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