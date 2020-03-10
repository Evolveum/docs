
CREATE TABLE HR_EMPLOYEES (
  employee_id        VARCHAR(16) NOT NULL,
  first_name         VARCHAR(32),
  middle_name        VARCHAR(32),
  last_name          VARCHAR(32),
  job_code           VARCHAR(16),
  ou_code            VARCHAR(8),
  active             BOOLEAN,
  PRIMARY KEY (employee_id)
);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('001', 'Alice', 'Alexandra', 'Anderson', 'S006', '11100', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('002', 'Bob', 'Bernard', 'Brown', 'S007', '11210', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('003', 'Carol', 'Clementine', 'Cooper', 'S008', '11310', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('004', 'David', 'Dennis', 'Davies', NULL, '11321', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('005', 'Erin', 'Eve', 'Evans', 'B001', '11320', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('006', 'Frank', 'Fitzgerald', 'Fox', 'O123', '12110', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('007', 'George', 'Graham', 'Green', 'B005', '12310', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('008', 'Harry', 'Herman', 'Harris', 'X001', '12200', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('009', 'Isabella', 'Iris', 'Irvine', 'X002', '11100', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('010', 'Jack', 'James', 'Jones', 'X003', '11200', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('011', 'Kate', 'Kylie', 'Knowles', 'S007', '12320', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('012', 'Lily', 'Luna', 'Lewis', 'S008', '12000', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('013', 'Max', 'Malcolm', 'Morgan', 'S007', '12310', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('014', 'Nathan', 'Neil', 'Newman', 'B001', '12330', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('015', 'Oliver', 'Ozzy', 'Owen', 'B002', '19100', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('016', 'Peter', 'Paul', 'Phillips', 'X001', '12310', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('017', 'Quentin', 'Quint', 'Quinn', 'G001', '19210', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('018', 'Roger', 'Robin', 'Russell', 'G002', '12320', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('019', 'Sophia', 'Serena', 'Simpson', 'S007', '19211', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('020', 'Thomas', 'Theodore', 'Turner', 'X002', '11200', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('021', 'Uma', 'Ursula', 'Underhill', 'B005', '12300', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('022', 'Violet', 'Victoria', 'Vickers', 'B001', '12200', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('023', 'William', 'Winston', 'Walker', 'X001', '19200', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('024', 'Xenia', 'Xyla', 'Xanadu', NULL, '11320', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('025', 'Yasmine', 'Yanis', 'Young', 'S008', '19100', TRUE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('026', 'Zed', 'Zachariah', 'Zimmerman', 'S007', '19211', TRUE);


INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('901', 'Adam', 'Anthony ', 'Abrams', 'G002', '12320', FALSE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('902', 'Betty', 'Beatrix ', 'Rubble', 'S007', '11210', FALSE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('903', 'Charles ', 'Collins', 'Connors', 'B001', '12200', FALSE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('904', 'Danna', 'Denise', 'Down', 'S007', '19211', FALSE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('905', 'Elijah', 'Ezekiel', 'Emerson', 'X002', '11200', FALSE);

INSERT INTO HR_EMPLOYEES (employee_id, first_name, middle_name, last_name, job_code, ou_code, active)
VALUES ('906', 'Fiona ', 'Felicity ', 'Floyd', 'B005', '12300', FALSE);
