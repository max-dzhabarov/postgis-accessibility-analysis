# Анализ транспортной доступности на PostGIS и pgRouting

Демонстрационный проект расчёта доступности объектов социальной инфраструктуры по дорожному графу. Репозиторий воспроизводит архитектуру реального решения на небольшом наборе синтетических данных и не содержит рабочих данных, служебных имён или параметров подключения.

## Производственный контекст

Исходное решение разработано в мае 2026 года и выполняет пакетный расчёт примерно 56 000 маршрутных задач. Результаты используются для оценки доступности объектов и формирования статистики по районам и административным округам.

## Что показывает демоверсия

- хранение маршрутизируемого графа в PostGIS;
- расчёт стоимости кратчайших путей через `pgr_dijkstraCost`;
- выбор ближайшего объекта для каждой исходной точки;
- материализованное представление с уникальным индексом;
- конкурентное обновление результата;
- агрегирование показателей доступности по территориям.

## Структура

```text
sql/01_setup.sql                 — расширения, схема и таблицы
sql/02_sample_data.sql           — синтетический дорожный граф и объекты
sql/03_accessibility_analysis.sql — расчёт и итоговая статистика
sql/04_refresh.sql               — конкурентное обновление результата
```

## Запуск

Требуются PostgreSQL, PostGIS и pgRouting.

```bash
psql -d your_database -f sql/01_setup.sql
psql -d your_database -f sql/02_sample_data.sql
psql -d your_database -f sql/03_accessibility_analysis.sql
psql -d your_database -f sql/04_refresh.sql
```

После запуска:

```sql
SELECT * FROM demo_accessibility.mv_nearest_facility ORDER BY origin_id;
SELECT * FROM demo_accessibility.v_area_statistics ORDER BY area_name;
```

> В демонстрации стоимость ребра условно интерпретируется как минуты. Для промышленного расчёта стоимость должна быть подготовлена из длины, скорости, направления движения и ограничений конкретной сети.

---

# Accessibility analysis with PostGIS and pgRouting

A small, reproducible example of measuring access to social facilities over a road network. It mirrors the architecture of a production-inspired workflow while using only synthetic data and generic object names.

## Production context

The original solution was developed in May 2026 and processes approximately 56,000 routing tasks in batches. Its outputs support facility-accessibility assessment and statistics by districts and administrative areas.

## Demonstrated techniques

- storing a routable graph in PostGIS;
- shortest-path cost calculation with `pgr_dijkstraCost`;
- selecting the nearest facility for each origin;
- materializing and indexing the result;
- concurrent refreshes;
- aggregating accessibility indicators by area.

Run the four SQL files in numerical order. The demo treats edge cost as minutes; a production network should derive costs from length, speed, direction, and local routing restrictions.

## License

MIT
