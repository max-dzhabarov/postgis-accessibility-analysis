DROP MATERIALIZED VIEW IF EXISTS demo_accessibility.mv_nearest_facility CASCADE;

CREATE MATERIALIZED VIEW demo_accessibility.mv_nearest_facility AS
WITH route_costs AS (
    SELECT *
    FROM pgr_dijkstraCost(
        'SELECT id, source, target, cost, reverse_cost
         FROM demo_accessibility.network_edges',
        ARRAY(
            SELECT DISTINCT start_vertex
            FROM demo_accessibility.origins
            ORDER BY start_vertex
        ),
        ARRAY(
            SELECT DISTINCT vertex_id
            FROM demo_accessibility.facilities
            ORDER BY vertex_id
        ),
        false
    )
),
ranked AS (
    SELECT
        o.id AS origin_id,
        o.name AS origin_name,
        o.area_name,
        o.population,
        f.id AS facility_id,
        f.name AS facility_name,
        f.capacity,
        rc.agg_cost AS travel_cost,
        row_number() OVER (
            PARTITION BY o.id
            ORDER BY rc.agg_cost, f.id
        ) AS route_rank,
        o.geom
    FROM route_costs AS rc
    JOIN demo_accessibility.origins AS o
      ON o.start_vertex = rc.start_vid
    JOIN demo_accessibility.facilities AS f
      ON f.vertex_id = rc.end_vid
    WHERE rc.agg_cost < 'Infinity'::double precision
)
SELECT
    origin_id,
    origin_name,
    area_name,
    population,
    facility_id,
    facility_name,
    capacity,
    travel_cost,
    travel_cost <= 10 AS accessible_within_10,
    geom
FROM ranked
WHERE route_rank = 1
WITH DATA;

CREATE UNIQUE INDEX mv_nearest_facility_origin_uidx
    ON demo_accessibility.mv_nearest_facility (origin_id);

CREATE INDEX mv_nearest_facility_geom_gix
    ON demo_accessibility.mv_nearest_facility USING gist (geom);

CREATE OR REPLACE VIEW demo_accessibility.v_area_statistics AS
SELECT
    area_name,
    count(*) AS origin_count,
    sum(population) AS population_total,
    sum(population) FILTER (WHERE accessible_within_10) AS population_accessible,
    round(
        100.0 * sum(population) FILTER (WHERE accessible_within_10)
        / NULLIF(sum(population), 0),
        1
    ) AS accessible_population_percent,
    round(avg(travel_cost)::numeric, 1) AS average_travel_cost
FROM demo_accessibility.mv_nearest_facility
GROUP BY area_name;
