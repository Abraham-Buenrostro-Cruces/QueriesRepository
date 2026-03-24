-- revisando la tabla para ultima_compra

--id_cliente_unificado​
--Numeoperacion
--Marca
--Mercado
--Clasevicio
--Ultima_fecha viaje
--Ultima fecha compra

SELECT
    id_cliente_unificado,
    operacion,
    marca,
    mercado,
    clase_servicio,
    feccorrida   AS ultima_fecha_viaje,
    dia_venta    AS ultima_fecha_compra
FROM (
    SELECT
        id_cliente_unificado,
        operacion,
        marca,
        mercado,
        clase_servicio,
        feccorrida,
        dia_venta,
        ROW_NUMBER() OVER (
            PARTITION BY id_cliente_unificado
            ORDER BY dia_venta DESC
        ) AS rn
    FROM "cliente"."models"."vw_bolven"
    WHERE id_cliente_unificado IS NOT NULL
)
WHERE rn = 1
ORDER BY id_cliente_unificado



-- cracion de la vista dentro de la transaccion
BEGIN;

-- previsualizacion dentro de la transaccion 
SELECT
    id_cliente_unificado,
    operacion,
    marca,
    mercado,
    clase_servicio,
    feccorrida   AS ultima_fecha_viaje,
    dia_venta    AS ultima_fecha_compra
FROM (
    SELECT
        id_cliente_unificado,
        operacion,
        marca,
        mercado,
        clase_servicio,
        feccorrida,
        dia_venta,
        ROW_NUMBER() OVER (
            PARTITION BY id_cliente_unificado
            ORDER BY dia_venta DESC
        ) AS rn
    FROM "cliente"."models"."vw_bolven"
    WHERE id_cliente_unificado IS NOT NULL
)
WHERE rn = 1
ORDER BY id_cliente_unificado
LIMIT 100;




-- Creacion de la vista.

CREATE OR REPLACE VIEW "cliente"."models"."ultima_compra" AS
SELECT
    id_cliente_unificado,
    operacion,
    marca,
    mercado,
    clase_servicio,
    feccorrida   AS ultima_fecha_viaje,
    dia_venta    AS ultima_fecha_compra
FROM (
    SELECT
        id_cliente_unificado,
        operacion,
        marca,
        mercado,
        clase_servicio,
        feccorrida,
        dia_venta,
        ROW_NUMBER() OVER (
            PARTITION BY id_cliente_unificado
            ORDER BY dia_venta DESC
        ) AS rn
    FROM "cliente"."models"."vw_bolven"
    WHERE id_cliente_unificado IS NOT NULL
)
WHERE rn = 1;

COMMIT;
ROLLBACK;
