drop table if exists games cascade;
drop table if exists game_images cascade;
drop table if exists game_tags cascade;
drop table if exists offer_types cascade;
drop table if exists offers cascade;
drop type if exists order_status cascade;
drop table if exists orders cascade;
drop table if exists sellers cascade;
drop table if exists tags cascade;
drop table if exists users cascade;

CREATE OR REPLACE FUNCTION create_database(dbname TEXT) RETURNS VOID AS
$$
BEGIN
    IF NOT EXISTS (
        SELECT 
        FROM pg_database 
        WHERE datname = dbname
    ) THEN
        CREATE DATABASE dbname;
    END IF;
END;
$$
LANGUAGE plpgsql;