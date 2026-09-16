TRUNCATE TABLE
    demo_accessibility.network_edges,
    demo_accessibility.origins,
    demo_accessibility.facilities;

INSERT INTO demo_accessibility.network_edges
    (id, source, target, cost, reverse_cost, geom)
VALUES
    (1, 1, 2, 3.0, 3.0, ST_GeomFromText('LINESTRING(0 0, 100 0)', 3857)),
    (2, 2, 3, 4.0, 4.0, ST_GeomFromText('LINESTRING(100 0, 200 0)', 3857)),
    (3, 2, 4, 5.0, 5.0, ST_GeomFromText('LINESTRING(100 0, 100 100)', 3857)),
    (4, 3, 5, 4.0, 4.0, ST_GeomFromText('LINESTRING(200 0, 200 100)', 3857)),
    (5, 4, 5, 3.0, 3.0, ST_GeomFromText('LINESTRING(100 100, 200 100)', 3857)),
    (6, 4, 6, 6.0, 6.0, ST_GeomFromText('LINESTRING(100 100, 100 200)', 3857)),
    (7, 5, 6, 4.0, 4.0, ST_GeomFromText('LINESTRING(200 100, 100 200)', 3857));

INSERT INTO demo_accessibility.origins
    (id, name, area_name, start_vertex, population, geom)
VALUES
    (1, 'Жилой квартал A', 'Северный район', 1, 1200, ST_SetSRID(ST_Point(0, 0), 3857)),
    (2, 'Жилой квартал B', 'Северный район', 3, 800, ST_SetSRID(ST_Point(200, 0), 3857)),
    (3, 'Жилой квартал C', 'Южный район', 6, 950, ST_SetSRID(ST_Point(100, 200), 3857));

INSERT INTO demo_accessibility.facilities
    (id, name, vertex_id, capacity, geom)
VALUES
    (1, 'Школа № 1', 4, 700, ST_SetSRID(ST_Point(100, 100), 3857)),
    (2, 'Школа № 2', 5, 900, ST_SetSRID(ST_Point(200, 100), 3857));
