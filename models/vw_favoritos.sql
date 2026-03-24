-- 1A. Favorito: marca
SELECT
    id_cliente_unificado,
    marca,
    COUNT(*)                                              AS frecuencia,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct
FROM "cliente"."models"."vw_bolven"
GROUP BY id_cliente_unificado, marca
ORDER BY id_cliente_unificado, frecuencia DESC;

-- 1B. Favorito: mercado
SELECT
    id_cliente_unificado,
    mercado,
    COUNT(*)                                              AS frecuencia,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct
FROM "cliente"."models"."vw_bolven"
GROUP BY id_cliente_unificado, mercado
ORDER BY id_cliente_unificado, frecuencia DESC;

-- 1C. Favorito: origen_id
SELECT
    id_cliente_unificado,
    origen_id,
    COUNT(*)                                              AS frecuencia,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct
FROM "cliente"."models"."vw_bolven"
GROUP BY id_cliente_unificado, origen_id
ORDER BY id_cliente_unificado, frecuencia DESC;

-- 1D. Favorito: destino_id
SELECT
    id_cliente_unificado,
    destino_id,
    COUNT(*)                                              AS frecuencia,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct
FROM "cliente"."models"."vw_bolven"
GROUP BY id_cliente_unificado, destino_id
ORDER BY id_cliente_unificado, frecuencia DESC;

-- 1E. Favorito: clase_servicio
SELECT
    id_cliente_unificado,
    clase_servicio,
    COUNT(*)                                              AS frecuencia,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct
FROM "cliente"."models"."vw_bolven"
GROUP BY id_cliente_unificado, clase_servicio
ORDER BY id_cliente_unificado, frecuencia DESC;

-- 1F. Favorito: dia_venta día de la semana
SELECT
    id_cliente_unificado,
    CASE EXTRACT(DOW FROM dia_venta)
        WHEN 0 THEN 'Dom'
        WHEN 1 THEN 'Lun'
        WHEN 2 THEN 'Mar'
        WHEN 3 THEN 'Mier'
        WHEN 4 THEN 'Jue'
        WHEN 5 THEN 'Vie'
        WHEN 6 THEN 'Sab'
    END                                                   AS dia_semana_venta,
    COUNT(*)                                              AS frecuencia,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct
FROM "cliente"."models"."vw_bolven"
GROUP BY id_cliente_unificado, EXTRACT(DOW FROM dia_venta)
ORDER BY id_cliente_unificado, frecuencia DESC;

-- 1G. Favorito: fechorviaje día de la semana
SELECT
    id_cliente_unificado,
    CASE EXTRACT(DOW FROM fechorviaje)
        WHEN 0 THEN 'Dom'
        WHEN 1 THEN 'Lun'
        WHEN 2 THEN 'Mar'
        WHEN 3 THEN 'Mier'
        WHEN 4 THEN 'Jue'
        WHEN 5 THEN 'Vie'
        WHEN 6 THEN 'Sab'
    END                                                   AS dia_semana_viaje,
    COUNT(*)                                              AS frecuencia,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct
FROM "cliente"."models"."vw_bolven"
GROUP BY id_cliente_unificado, EXTRACT(DOW FROM fechorviaje)
ORDER BY id_cliente_unificado, frecuencia DESC;


-- 1H. Favorito: canal
SELECT
    id_cliente_unificado,
    canal,
    COUNT(*)                                              AS frecuencia,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct
FROM "cliente"."models"."vw_bolven"
GROUP BY id_cliente_unificado, canal
ORDER BY id_cliente_unificado, frecuencia DESC;


-- 1I. Favorito: puntoventa_id
SELECT
    id_cliente_unificado,
    puntoventa_id,
    COUNT(*)                                              AS frecuencia,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct
FROM "cliente"."models"."vw_bolven"
GROUP BY id_cliente_unificado, puntoventa_id
ORDER BY id_cliente_unificado, frecuencia DESC;

-- 2. Visualizacion completa de vw_favoritos
WITH base AS (
    SELECT
        id_cliente_unificado,
        marca,
        mercado,
        origen_id,
        destino_id,
        clase_servicio,
        CASE EXTRACT(DOW FROM dia_venta)
            WHEN 0 THEN 'Dom' WHEN 1 THEN 'Lun' WHEN 2 THEN 'Mar'
            WHEN 3 THEN 'Mier' WHEN 4 THEN 'Jue' WHEN 5 THEN 'Vie' WHEN 6 THEN 'Sab'
        END AS dia_semana_venta,
        CASE EXTRACT(DOW FROM fechorviaje)
            WHEN 0 THEN 'Dom' WHEN 1 THEN 'Lun' WHEN 2 THEN 'Mar'
            WHEN 3 THEN 'Mier' WHEN 4 THEN 'Jue' WHEN 5 THEN 'Vie' WHEN 6 THEN 'Sab'
        END AS dia_semana_viaje,
        canal,
        puntoventa_id
    FROM "cliente"."models"."vw_bolven"
),
fav_marca AS (
    SELECT id_cliente_unificado, marca AS fav_marca,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct_marca,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, marca
),
fav_mercado AS (
    SELECT id_cliente_unificado, mercado AS fav_mercado,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct_mercado,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, mercado
),
fav_origen AS (
    SELECT id_cliente_unificado, origen_id AS fav_origen_id,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct_origen,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, origen_id
),
fav_destino AS (
    SELECT id_cliente_unificado, destino_id AS fav_destino_id,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct_destino,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, destino_id
),
fav_clase AS (
    SELECT id_cliente_unificado, clase_servicio AS fav_clase_servicio,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct_clase,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, clase_servicio
),
fav_dia_venta AS (
    SELECT id_cliente_unificado, dia_semana_venta AS fav_dia_venta,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct_dia_venta,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, dia_semana_venta
),
fav_dia_viaje AS (
    SELECT id_cliente_unificado, dia_semana_viaje AS fav_dia_viaje,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct_dia_viaje,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, dia_semana_viaje
),
fav_canal AS (
    SELECT id_cliente_unificado, canal AS fav_canal,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct_canal,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, canal
),
fav_puntoventa AS (
    SELECT id_cliente_unificado, puntoventa_id AS fav_puntoventa_id,
           ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY id_cliente_unificado), 2) AS pct_puntoventa,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, puntoventa_id
)
SELECT
    m.id_cliente_unificado,
    m.fav_marca,          m.pct_marca,
    me.fav_mercado,       me.pct_mercado,
    o.fav_origen_id,      o.pct_origen,
    d.fav_destino_id,     d.pct_destino,
    c.fav_clase_servicio, c.pct_clase,
    dv.fav_dia_venta,     dv.pct_dia_venta,
    dj.fav_dia_viaje,     dj.pct_dia_viaje,
    ca.fav_canal,         ca.pct_canal,
    pv.fav_puntoventa_id, pv.pct_puntoventa
FROM      (SELECT DISTINCT id_cliente_unificado FROM base)   ids
JOIN      fav_marca      m   ON ids.id_cliente_unificado = m.id_cliente_unificado  AND m.rn  = 1
JOIN      fav_mercado    me  ON ids.id_cliente_unificado = me.id_cliente_unificado AND me.rn = 1
JOIN      fav_origen     o   ON ids.id_cliente_unificado = o.id_cliente_unificado  AND o.rn  = 1
JOIN      fav_destino    d   ON ids.id_cliente_unificado = d.id_cliente_unificado  AND d.rn  = 1
JOIN      fav_clase      c   ON ids.id_cliente_unificado = c.id_cliente_unificado  AND c.rn  = 1
JOIN      fav_dia_venta  dv  ON ids.id_cliente_unificado = dv.id_cliente_unificado AND dv.rn = 1
JOIN      fav_dia_viaje  dj  ON ids.id_cliente_unificado = dj.id_cliente_unificado AND dj.rn = 1
JOIN      fav_canal      ca  ON ids.id_cliente_unificado = ca.id_cliente_unificado AND ca.rn = 1
JOIN      fav_puntoventa pv  ON ids.id_cliente_unificado = pv.id_cliente_unificado AND pv.rn = 1
ORDER BY  ids.id_cliente_unificado;


-- 3. Creacion de vw_favoritos
CREATE OR REPLACE VIEW "cliente"."models"."vw_favoritos" AS
WITH base AS (
    SELECT
        id_cliente_unificado,
        marca,
        mercado,
        origen_id,
        destino_id,
        clase_servicio,
        CASE EXTRACT(DOW FROM dia_venta)
            WHEN 0 THEN 'Dom' WHEN 1 THEN 'Lun' WHEN 2 THEN 'Mar'
            WHEN 3 THEN 'Mier' WHEN 4 THEN 'Jue' WHEN 5 THEN 'Vie' WHEN 6 THEN 'Sab'
        END AS dia_semana_venta,
        CASE EXTRACT(DOW FROM fechorviaje)
            WHEN 0 THEN 'Dom' WHEN 1 THEN 'Lun' WHEN 2 THEN 'Mar'
            WHEN 3 THEN 'Mier' WHEN 4 THEN 'Jue' WHEN 5 THEN 'Vie' WHEN 6 THEN 'Sab'
        END AS dia_semana_viaje,
        canal,
        puntoventa_id
    FROM "cliente"."models"."vw_bolven"
),
fav_marca AS (
    SELECT id_cliente_unificado, marca AS fav_marca,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, marca
),
fav_mercado AS (
    SELECT id_cliente_unificado, mercado AS fav_mercado,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, mercado
),
fav_origen AS (
    SELECT id_cliente_unificado, origen_id AS fav_origen_id,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, origen_id
),
fav_destino AS (
    SELECT id_cliente_unificado, destino_id AS fav_destino_id,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, destino_id
),
fav_clase AS (
    SELECT id_cliente_unificado, clase_servicio AS fav_clase_servicio,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, clase_servicio
),
fav_dia_venta AS (
    SELECT id_cliente_unificado, dia_semana_venta AS fav_dia_venta,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, dia_semana_venta
),
fav_dia_viaje AS (
    SELECT id_cliente_unificado, dia_semana_viaje AS fav_dia_viaje,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, dia_semana_viaje
),
fav_canal AS (
    SELECT id_cliente_unificado, canal AS fav_canal,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, canal
),
fav_puntoventa AS (
    SELECT id_cliente_unificado, puntoventa_id AS fav_puntoventa_id,
           ROW_NUMBER() OVER (PARTITION BY id_cliente_unificado ORDER BY COUNT(*) DESC) AS rn
    FROM base GROUP BY id_cliente_unificado, puntoventa_id
)
SELECT
    ids.id_cliente_unificado,
    m.fav_marca,
    me.fav_mercado,
    o.fav_origen_id,
    d.fav_destino_id,
    c.fav_clase_servicio,
    dv.fav_dia_venta,
    dj.fav_dia_viaje,
    ca.fav_canal,
    pv.fav_puntoventa_id
FROM      (SELECT DISTINCT id_cliente_unificado FROM base)   ids
JOIN      fav_marca      m   ON ids.id_cliente_unificado = m.id_cliente_unificado  AND m.rn  = 1
JOIN      fav_mercado    me  ON ids.id_cliente_unificado = me.id_cliente_unificado AND me.rn = 1
JOIN      fav_origen     o   ON ids.id_cliente_unificado = o.id_cliente_unificado  AND o.rn  = 1
JOIN      fav_destino    d   ON ids.id_cliente_unificado = d.id_cliente_unificado  AND d.rn  = 1
JOIN      fav_clase      c   ON ids.id_cliente_unificado = c.id_cliente_unificado  AND c.rn  = 1
JOIN      fav_dia_venta  dv  ON ids.id_cliente_unificado = dv.id_cliente_unificado AND dv.rn = 1
JOIN      fav_dia_viaje  dj  ON ids.id_cliente_unificado = dj.id_cliente_unificado AND dj.rn = 1
JOIN      fav_canal      ca  ON ids.id_cliente_unificado = ca.id_cliente_unificado AND ca.rn = 1
JOIN      fav_puntoventa pv  ON ids.id_cliente_unificado = pv.id_cliente_unificado AND pv.rn = 1
WITH NO SCHEMA BINDING;

