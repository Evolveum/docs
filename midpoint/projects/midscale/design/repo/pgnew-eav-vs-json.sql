-- Copyright (C) 2010-2021 Evolveum and contributors
--
-- This work is dual-licensed under the Apache License 2.0
-- and European Union Public License. See LICENSE file for details.
--
-- @formatter:off because of terribly unreliable IDEA reformat for SQL
-- drop schema public CASCADE;
CREATE SCHEMA IF NOT EXISTS public;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

DO $$
    BEGIN
        perform pg_get_functiondef('gen_random_uuid()'::regprocedure);
        raise notice 'gen_random_uuid already exists, skipping create EXTENSION pgcrypto';
    EXCEPTION WHEN undefined_function THEN
        create EXTENSION pgcrypto;
    END
$$;

-- JSONB
-- drop table tjson;

create table tjson (
    oid UUID NOT NULL DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    ext JSONB,

    CONSTRAINT tjson_oid_pk PRIMARY KEY (oid)
);

ALTER TABLE tjson ADD CONSTRAINT tjson_name_key UNIQUE (name);
CREATE INDEX tjson_ext_idx ON tjson USING gin (ext);

--- EAV
-- drop table teav_ext_string; drop table teav;

create table teav (
    oid UUID NOT NULL DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,

    CONSTRAINT teav_oid_pk PRIMARY KEY (oid)
);

ALTER TABLE teav ADD CONSTRAINT teav_name_key UNIQUE (name);

create table teav_ext_string (
    ownerOid UUID NOT NULL references teav(oid),
    key VARCHAR(32) NOT NULL,
    value VARCHAR(255) NOT NULL,

    -- this also covers the index on ownerOid FK
    CONSTRAINT teav_ext_string_pk PRIMARY KEY (ownerOid, key, value)
);

CREATE INDEX teav_ext_string_key_value_idx ON teav_ext_string (key, value);

-- support functions
-- returns random elements from array
-- output is of random length based on ratio (0-1), 0 returns nothing, 1 everything
CREATE OR REPLACE FUNCTION random_pick(vals ANYARRAY, ratio numeric, ignore ANYELEMENT = NULL)
    RETURNS ANYARRAY
    LANGUAGE plpgsql
AS $$
DECLARE
    rval vals%TYPE := '{}';
    val ignore%TYPE;
BEGIN
    IF vals IS NULL THEN
        RETURN NULL;
    END IF;

    -- Alternative FOR i IN array_lower(vals, 1) .. array_upper(vals, 1) LOOP does not need "ignore" parameter.
    -- Functions array_lower/upper are better if array subscript doesn't start with 1 (which is default).
    FOREACH val IN ARRAY vals LOOP
            IF random() < ratio THEN
                rval := array_append(rval, val); -- alt. vals[i]
            END IF;
        END LOOP;
    -- It's also possible to iterate without index with , but requires
    -- more
    RETURN rval;
END $$;

-- INSERTS
DELETE FROM tjson;
DELETE FROM teav_ext_string;
DELETE FROM teav;

-- start with smaller batches 1..1000, 1001..100000, etc.
DO
$$
DECLARE
    hobbies VARCHAR[];
    v VARCHAR;
    id UUID;
BEGIN
    FOR r IN 100001..1000000 LOOP

        id := gen_random_uuid();

        IF r % 100 = 0 THEN
            -- rarely used values of hobbies key
            hobbies := random_pick(ARRAY['recording', 'guitar', 'beer', 'rum', 'writing', 'coding', 'debugging', 'gaming', 'shopping', 'watching videos', 'sleeping', 'dreaming'], 0.1);
            -- JSONB
            INSERT INTO tjson (oid, name, ext) VALUES (
                id, 'user-' || LPAD(r::text, 10, '0'),
                ('{"eid": ' || r || ', "hobbies": '|| array_to_json(hobbies)::text || '}')::jsonb
            );

            -- EAV
            INSERT INTO teav (oid, name) VALUES (id, 'user-' || LPAD(r::text, 10, '0'));
            INSERT INTO teav_ext_string (ownerOid, key, value) VALUES (id, 'eid', r);
            FOREACH v IN ARRAY hobbies LOOP
                INSERT INTO teav_ext_string (ownerOid, key, value)
                VALUES (id, 'hobbies', v);
            END LOOP;
        ELSEIF r % 10 <= 1 THEN
            -- some entries have no extension
            INSERT INTO tjson (oid, name) VALUES (id, 'user-' || LPAD(r::text, 10, '0'));
            INSERT INTO teav (oid, name) VALUES (id, 'user-' || LPAD(r::text, 10, '0'));
        ELSEIF r % 10 <= 3 THEN
            -- email+eid (constant keys) + other-key-{r} (variable key)
            INSERT INTO tjson (oid, name, ext) VALUES (
                id, 'user-' || LPAD(r::text, 10, '0'),
                ('{"eid": ' || r || ', "email": "user' || r || '@mycompany.com", "other-key-' || r || '": "other-value-' || r || '"}')::jsonb
            );
            INSERT INTO teav (oid, name) VALUES (id, 'user-' || LPAD(r::text, 10, '0'));
            INSERT INTO teav_ext_string (ownerOid, key, value) VALUES (id, 'email', 'user' || r || '@mycompany.com');
            INSERT INTO teav_ext_string (ownerOid, key, value) VALUES (id, 'eid', r);
            INSERT INTO teav_ext_string (ownerOid, key, value) VALUES (id, 'other-key-' || r, 'other-value-' || r);
        ELSE
            -- these values are used by many entries
            hobbies := random_pick(ARRAY['eating', 'books', 'music', 'dancing', 'walking', 'jokes', 'video', 'photo'], 0.4);
            -- JSONB
            INSERT INTO tjson (oid, name, ext) VALUES (
                id, 'user-' || LPAD(r::text, 10, '0'),
                ('{"eid": ' || r || ', "hobbies": '|| array_to_json(hobbies)::text || '}')::jsonb
            );

            -- EAV
            INSERT INTO teav (oid, name) VALUES (id, 'user-' || LPAD(r::text, 10, '0'));
            INSERT INTO teav_ext_string (ownerOid, key, value) VALUES (id, 'eid', r);
            FOREACH v IN ARRAY hobbies LOOP
                INSERT INTO teav_ext_string (ownerOid, key, value)
                VALUES (id, 'hobbies', v);
            END LOOP;
        END IF;

        IF r % 1000 = 0 THEN
            COMMIT;
        END IF;
    END LOOP;
END $$;

-- SELECTS

select count(*) from tjson;
select count(*) from teav;
select count(*) from teav_ext_string;
select count(*) from teav_ext_string where key = 'hobbies';
-- 61% of objects contain hobbies, some arrays are empty, these have no rows in teav_ext_string
select count(distinct ownerOid) from teav_ext_string where key = 'hobbies';
select count(*) from tjson where ext ? 'hobbies';
select count(*) from tjson where ext->'hobbies' = '[]';
-- in midPoint we would not store empty arrays to avoid match with ?

select 1830000-38947; -- 1791053

select * from tjson;
select * from teav;
select * from teav_ext_string;

vacuum full analyze;
analyze; -- 15m rows, 45s
analyze teav;
analyze teav_ext_string;
analyze tjson;
-- cluster teav_ext_string using teav_ext_string_pk; -- 10-13min, not sure how useful this is

-- SHOW enable_seqscan;
-- SET enable_seqscan = on;


EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
select count(*)
-- select *
from tjson
where ext->>'email' LIKE 'user2%'
and ext ? 'email';

-- index experiments
analyze;
CREATE INDEX tjson_exttmp_idx ON tjson (cast(ext->'eid' as int));
CREATE INDEX tjson_ext_eid_int_idx ON tjson (((ext->'eid')::int)); -- the same as above

select * from pg_indexes where tablename = 'tjson';
select * from pg_index where indrelid = 951043;
select * from pg_class where relname='tjson'; -- 951043

-- BENCHMARK JSONB
-- counts, -t 10 is default for pgbench, counts take long
-- pgbench -r -P 5 -f - -t 5 << "--EOF"
select count(*) from tjson;
-- first is low selectivity, second is higher (rarer values)
select count(*) from tjson where ext @> '{"hobbies":["video"]}';
select count(*) from tjson where ext @> '{"hobbies":["sleeping"]}';
select count(*) from tjson where ext->>'email' ILIKE 'USER2%';
select count(*) from tjson where UPPER(ext->>'email') LIKE 'USER2%';
--EOF

CREATE INDEX tjson_ext_email_idx ON tjson USING btree ((ext->>'email'));
CREATE INDEX tjson_ext_email2_idx ON tjson USING btree ((ext->>'email')) WHERE ext?'email';
CREATE INDEX tjson_ext_email_trgm_idx ON tjson USING gin((ext->>'email') gin_trgm_ops);
CREATE INDEX tjson_ext_email2_trgm_idx ON tjson USING gin((ext->>'email') gin_trgm_ops) WHERE ext?'email';
drop table if exists xemails;
create table xemails as select oid,ext->>'email' as email from tjson where ext?'email';
CREATE INDEX xemails_email_idx ON xemails USING btree (email);
CREATE INDEX xemails_email_trgm_idx ON xemails USING gin(email gin_trgm_ops);

-- LIKE/ILIKE support:
-- gin_trgm_ops should be used, pg_trgm extension must be installed
-- works great for ilike, no upper/lower needed for case-insensitive operation
select count(*) from tjson where ext?'email';
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
select * from xemails where email = 'UsEr2%';
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
select * from xemails where email ilike '%2@%';
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
select * from tjson where ext->>'email' = 'USER2%'; -- and ext?'email';
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
select * from tjson where ext->>'email' ILIKE 'USER2%';
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
select * from tjson where UPPER(ext->>'email') LIKE 'USER2%' LIMIT 500;

-- compare gin_trgm_ops on value and specific values (with WHERE)
CREATE INDEX teav_ext_string_value_trgm_idx ON teav_ext_string USING gin(value gin_trgm_ops);
CREATE INDEX teav_ext_string_value_email_trgm_idx ON teav_ext_string USING gin(value gin_trgm_ops) WHERE key='email';
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
select * from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'email' and es.value ILIKE 'USER2%') LIMIT 50;
select from teav_ext_string ex where es.key = 'email' and es.value ILIKE 'USER2%' limit 500;

-- selecting item with any of two hobbies:
-- see https://dba.stackexchange.com/a/130863/157622
select * from tjson where ext @> ANY (ARRAY['{"hobbies": ["video"]}', '{"hobbies": ["photo"]}']::jsonb[]);

-- This is marginally slower and the plan contains BitmapOr:
select * from tjson where ext @> '{"hobbies": ["video"]}' OR ext @> '{"hobbies": ["photo"]}';

-- Selecting first values of arrays, this is safe for scalar value too (and can used in index):
insert into tjson values ('00000000-0000-0000-0000-000000000000', 'scalar-test', '{"hobbies": "scalar"}');
select oid, ext, ext->'hobbies'->0 from tjson where oid='00000000-0000-0000-0000-000000000000'; -- works for scalar too
select oid, ext, ext->'hobbies'->0 from tjson; -- and works fine for all the rest

-- selects
-- pgbench -r -P 5 -f - -t 30 << "--EOF"
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
select * from tjson limit 500;
select * from tjson where ext @> '{"hobbies":["video"]}' limit 500;
select * from tjson where ext @> '{"hobbies":["video"]}' order by oid limit 500;
select * from tjson where ext @> '{"hobbies":["video"]}' and oid>'fffe0000-0000-0000-0000-000000000000' order by oid limit 500;
select * from tjson where ext @> '{"hobbies":["sleeping"]}' limit 500;
select * from tjson where ext @> '{"hobbies":["sleeping"]}' order by oid limit 500;
--EOF

-- pgbench -r -P 5 -f - -t 30 << "--EOF"
select * from tjson where ext->>'email' LIKE 'user2%' limit 500;
select * from tjson where ext->>'email' LIKE 'user2%' order by oid limit 500;
select * from tjson where ext->>'email' LIKE 'user2%' and oid>'fffe0000-0000-0000-0000-000000000000' order by oid limit 500;

select * from tjson where UPPER(ext->>'email') LIKE 'USER2%' limit 500;
select * from tjson where UPPER(ext->>'email') LIKE 'USER2%' order by oid limit 500;
select * from tjson where UPPER(ext->>'email') LIKE 'USER2%' and oid>'fffe0000-0000-0000-0000-000000000000' order by oid limit 500;

-- very inefficient, can work with index ON tjson (cast(ext->'eid' as int)), equivalent with (((ext->'eid')::int))
-- helps comparison operations too; the same -> or ->> must be used in both index and query
--select * from tjson where cast(ext->'eid' as int) = 5000 and ext?'eid';
-- uses GIN index just fine
select * from tjson where ext @> '{"eid":5000}';
--EOF

-- BENCHMARK EAV
-- counts, -t 10 is default for pgbench, counts take long
-- pgbench -r -P 5 -f - -t 5 << "--EOF"
select count(*) from teav_ext_string; -- out for curiosity, not practical otherwise
select count(*) from teav;
select count(*) from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'hobbies' and es.value = 'video');
select count(*) from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'hobbies' and es.value = 'sleeping');
select count(*) from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'email' and es.value LIKE 'user2%');
select count(*) from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'email' and UPPER(es.value) LIKE 'USER2%');
--EOF

-- selects
-- pgbench -r -P 5 -f - -t 30 << "--EOF"
select * from teav limit 500;
select * from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'hobbies' and es.value = 'video') limit 500;
select * from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'hobbies' and es.value = 'video') order by t.oid limit 500;
select * from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'hobbies' and es.value = 'video') and t.oid>'fffe0000-0000-0000-0000-000000000000' order by t.oid limit 500;
select * from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'hobbies' and es.value = 'sleeping') limit 500;
select * from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'hobbies' and es.value = 'sleeping') order by t.oid limit 500;
--EOF

-- pgbench -r -P 5 -f - -t 30 << "--EOF"
select * from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'email' and es.value LIKE 'user2%') limit 500;
select * from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'email' and es.value LIKE 'user2%') order by oid limit 500;
select * from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'email' and es.value LIKE 'user2%') and oid>'fffe0000-0000-0000-0000-000000000000' order by oid limit 500;

select * from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'email' and UPPER(es.value) LIKE 'USER2%') limit 500;
select * from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'email' and UPPER(es.value) LIKE 'USER2%') order by oid limit 500;
select * from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'email' and UPPER(es.value) LIKE 'USER2%') and oid>'fffe0000-0000-0000-0000-000000000000' order by oid limit 500;

select * from teav t where exists (select from teav_ext_string es where es.ownerOid = t.oid and es.key = 'eid' and es.value = '5000');
--EOF
