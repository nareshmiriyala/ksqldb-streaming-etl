CREATE TABLE settlement (id UUID PRIMARY KEY, status TEXT, workspace_id UUID,created_date_time timestamp);

INSERT INTO settlement (id, status, workspace_id,created_date_time) VALUES ('5f8c7a5a-c6b1-11ed-afa1-0242ac120002','PENDING', 'dff8a5b6-c5d9-11ed-afa1-0242ac120002',CURRENT_TIMESTAMP);
INSERT INTO settlement (id, status, workspace_id,created_date_time) VALUES ('6dcd8816-c5da-11ed-afa1-0242ac120002','PENDING', 'dff8a5b6-c5d9-11ed-afa1-0242ac120002',CURRENT_TIMESTAMP);
INSERT INTO settlement (id, status, workspace_id,created_date_time) VALUES ('ae445958-c6eb-11ed-afa1-0242ac120002','FAILED', '5d4b0101-4b41-4505-a378-3e4f8fa40ed6',CURRENT_TIMESTAMP);