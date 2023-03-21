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