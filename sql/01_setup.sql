CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pgrouting;

DROP SCHEMA IF EXISTS demo_accessibility CASCADE;
CREATE SCHEMA demo_accessibility;

CREATE TABLE demo_accessibility.network_edges (
    id bigint PRIMARY KEY,
    source bigint NOT NULL,
    target bigint NOT NULL,
    cost double precision NOT NULL CHECK (cost >= 0),
    reverse_cost double precision NOT NULL CHECK (reverse_cost >= 0),
    geom geometry(LineString, 3857) NOT NULL
);

CREATE INDEX network_edges_geom_gix
    ON demo_accessibility.network_edges USING gist (geom);

CREATE TABLE demo_accessibility.origins (
    id bigint PRIMARY KEY,
    name text NOT NULL,
    area_name text NOT NULL,
    start_vertex bigint NOT NULL,
    population integer NOT NULL CHECK (population >= 0),
    geom geometry(Point, 3857) NOT NULL
);

CREATE INDEX origins_geom_gix
    ON demo_accessibility.origins USING gist (geom);

CREATE TABLE demo_accessibility.facilities (
    id bigint PRIMARY KEY,
    name text NOT NULL,
    vertex_id bigint NOT NULL,
    capacity integer NOT NULL CHECK (capacity >= 0),
    geom geometry(Point, 3857) NOT NULL
);

CREATE INDEX facilities_geom_gix
    ON demo_accessibility.facilities USING gist (geom);
