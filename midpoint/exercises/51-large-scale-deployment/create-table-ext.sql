
CREATE TABLE IDENTITIES (
  ext_id             VARCHAR(32) NOT NULL,
  first_name         VARCHAR(32),
  last_name          VARCHAR(32),
  type               VARCHAR(16),
  disabled           BOOLEAN,
  PRIMARY KEY (username)
);

INSERT INTO IDENTITIES (ext_id, first_name, last_name, type, disabled)
VALUES ('E0000001', 'Emil', 'Outsider', 'EXT', FALSE);

INSERT INTO IDENTITIES (ext_id, first_name, last_name, type, disabled)
VALUES ('E0000002', 'John', 'Worker', 'EXT', FALSE);

INSERT INTO IDENTITIES (ext_id, first_name, last_name, type, disabled)
VALUES ('E0000003', 'Jane', 'Supporter', 'SUP', FALSE);

INSERT INTO IDENTITIES (ext_id, first_name, last_name, type, disabled)
VALUES ('E0000004', 'Fiona', 'Fixit', 'SUP', FALSE);

INSERT INTO IDENTITIES (ext_id, first_name, last_name, type, disabled)
VALUES ('E0000005', 'Fred', 'Partner', 'PAR', FALSE);

INSERT INTO IDENTITIES (ext_id, first_name, last_name, type, disabled)
VALUES ('E0000006', 'Jack', 'Customer', 'CUS', FALSE);

