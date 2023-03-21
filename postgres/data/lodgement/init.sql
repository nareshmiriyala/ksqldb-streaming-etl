CREATE TABLE lodgement (id UUID PRIMARY KEY, status TEXT, workspace_id UUID,created_date_time timestamp);

INSERT INTO lodgement (id, status, workspace_id,created_date_time) VALUES ('3ea63308-c5da-11ed-afa1-0242ac120002','PENDING', 'dff8a5b6-c5d9-11ed-afa1-0242ac120002',CURRENT_TIMESTAMP);
INSERT INTO lodgement (id, status, workspace_id,created_date_time) VALUES ('4f1aa0ca-c6b1-11ed-afa1-0242ac120002','COMPLETED', 'dff8a5b6-c5d9-11ed-afa1-0242ac120002',CURRENT_TIMESTAMP);
INSERT INTO lodgement (id, status, workspace_id,created_date_time) VALUES ('342ab748-c6eb-11ed-afa1-0242ac120002','FAILED', '5d4b0101-4b41-4505-a378-3e4f8fa40ed6',CURRENT_TIMESTAMP);