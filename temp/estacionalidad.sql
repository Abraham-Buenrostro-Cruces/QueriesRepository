-- =====================================================
-- PASO 1: EXPLORACIÓN DE ESTACIONALIDAD
-- Objetivo: identificar los meses/semanas de mayor
-- concentración de ventas para definir temporadas altas
-- =====================================================

-- 1A. Volumen y monto por mes (visión anual agregada)
SELECT
    EXTRACT(YEAR FROM fechorvta)     AS anio,
    EXTRACT(MONTH FROM fechorvta)    AS mes,
    TO_CHAR(fechorvta, 'Mon')        AS mes_nombre,
    COUNT(DISTINCT numefolio)        AS num_compras,
    COUNT(DISTINCT id_cliente_unificado) AS clientes_unicos,
    ROUND(SUM(monto_pago + iva_pago), 2) AS monto_total,
    ROUND(AVG(monto_pago + iva_pago), 2) AS ticket_promedio
FROM "cliente"."models"."vw_bolven"
WHERE statusboleto IN ('V', 'T')
  AND fechorvta IS NOT NULL
GROUP BY 1, 2, 3
ORDER BY 1, 2;


-- 1B. Índice estacional por mes (promedio histórico normalizado)
-- Muestra qué meses están por encima del promedio general
WITH ventas_por_anio_mes AS (
    SELECT
        EXTRACT(YEAR  FROM fechorvta)::INT  AS anio,
        EXTRACT(MONTH FROM fechorvta)::INT  AS mes,
        TO_CHAR(fechorvta, 'Mon')           AS mes_nombre,
        SUM(monto_pago + iva_pago)          AS monto_total_mes
    FROM "cliente"."models"."vw_bolven"
    WHERE statusboleto IN ('V', 'T')
      AND fechorvta IS NOT NULL
    GROUP BY 1, 2, 3
),
ventas_mes AS (
    SELECT
        mes,
        mes_nombre,
        AVG(monto_total_mes) AS promedio_historico
    FROM ventas_por_anio_mes
    GROUP BY mes, mes_nombre
),
promedio_global AS (
    SELECT AVG(promedio_historico) AS media_global
    FROM ventas_mes
)
SELECT
    v.mes,
    v.mes_nombre,
    ROUND(v.promedio_historico, 2)                          AS venta_promedio_historica,
    ROUND(v.promedio_historico / p.media_global, 2)         AS indice_estacional,
    CASE
        WHEN v.promedio_historico / p.media_global >= 1.20  THEN 'Temporada Alta'
        WHEN v.promedio_historico / p.media_global >= 0.90  THEN 'Temporada Media'
        ELSE                                                      'Temporada Baja'
    END AS clasificacion
FROM ventas_mes v
CROSS JOIN promedio_global p
ORDER BY v.mes;


--por mes y año


-- 1C. Concentración de clientes únicos por quincena
-- Útil para ver si las temporadas duran semanas o meses completos
SELECT
    EXTRACT(YEAR FROM fechorvta)                        AS anio,
    EXTRACT(MONTH FROM fechorvta)                       AS mes,
    CASE WHEN EXTRACT(DAY FROM fechorvta) <= 15
         THEN '1ra quincena'
         ELSE '2da quincena'
    END                                                 AS quincena,
    COUNT(DISTINCT id_cliente_unificado)                AS clientes_unicos,
    COUNT(DISTINCT numefolio)                           AS num_compras,
    ROUND(SUM(monto_pago + iva_pago), 2)               AS monto_total
FROM "cliente"."models"."vw_bolven"
WHERE statusboleto IN ('V', 'T')
  AND fechorvta IS NOT NULL
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3;