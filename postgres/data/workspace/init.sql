CREATE TABLE workspace (id UUID PRIMARY KEY,mortgage_ref TEXT, status TEXT, susbscriber_id UUID,created_date_time timestamp);

INSERT INTO workspace (id,mortgage_ref, status, susbscriber_id,created_date_time) VALUES ('dff8a5b6-c5d9-11ed-afa1-0242ac120002','ref-1', 'CREATING', 'f5f8ec5e-c5d9-11ed-afa1-0242ac120002',CURRENT_TIMESTAMP);
   INSERT INTO workspace (id,mortgage_ref, status, susbscriber_id,created_date_time) VALUES ('5d4b0101-4b41-4505-a378-3e4f8fa40ed6','ref-2', 'CREATING', 'f5f8ec5e-c5d9-11ed-afa1-0242ac120002',CURRENT_TIMESTAMP);