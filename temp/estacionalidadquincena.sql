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