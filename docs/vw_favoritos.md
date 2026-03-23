# View: `cliente.models.vw_favoritos`

## Tipo

- **Objeto:** View
- **Nombre:** `"cliente"."models"."vw_favoritos"`

## Descripción funcional

Construye, para cada `id_cliente_unificado`, el valor **más frecuente (top 1)** de distintos atributos observados en la fuente `cliente.models.vw_bolven`:

- Marca favorita
- Mercado favorito
- Origen favorito
- Destino favorito
- Clase de servicio favorita
- Día de semana favorito de venta
- Día de semana favorito de viaje
- Canal favorito
- Punto de venta favorito

La selección del “favorito” se realiza con `ROW_NUMBER() ... ORDER BY COUNT(*) DESC` por cliente y atributo.

## Fuente(s) y dependencias

- **Fuente principal:** `"cliente"."models"."vw_bolven"`

### Diagrama de dependencias

```mermaid
flowchart LR
  vw_bolven[(cliente.models.vw_bolven)] --> vw_favoritos[cliente.models.vw_favoritos]
```

## Lógica / reglas relevantes

- **Base (`base` CTE):** proyecta columnas de `vw_bolven` y deriva:
  - `dia_semana_venta`: `EXTRACT(DOW FROM dia_venta)` mapeado a `Dom/Lun/Mar/Mier/Jue/Vie/Sab`
  - `dia_semana_viaje`: `EXTRACT(DOW FROM fechorviaje)` con el mismo mapeo
- **Favoritos (CTEs `fav_*`):**
  - Agrupa por `id_cliente_unificado` y atributo
  - Asigna `rn = 1` al atributo con mayor frecuencia
- **Salida final:** join por `id_cliente_unificado` contra cada `fav_*` filtrado a `rn = 1`.

## Diccionario de datos (salida de la view)

| Columna | Descripción |
|---|---|
| `id_cliente_unificado` | Identificador del cliente unificado (llave de grano: 1 fila por cliente). |
| `fav_marca` | Marca con mayor frecuencia de compra/viaje para el cliente. |
| `fav_mercado` | Mercado con mayor frecuencia para el cliente. |
| `fav_origen_id` | Identificador de origen más frecuente para el cliente. |
| `fav_destino_id` | Identificador de destino más frecuente para el cliente. |
| `fav_clase_servicio` | Clase de servicio más frecuente para el cliente. |
| `fav_dia_venta` | Día de la semana (texto `Dom`..`Sab`) más frecuente de `dia_venta` para el cliente. |
| `fav_dia_viaje` | Día de la semana (texto `Dom`..`Sab`) más frecuente de `fechorviaje` para el cliente. |
| `fav_canal` | Canal más frecuente para el cliente. |
| `fav_puntoventa_id` | Punto de venta más frecuente para el cliente. |

## Notas

- El archivo `vw_favoritos.sql` también contiene consultas de exploración (frecuencia y porcentaje). La **view final** no expone los porcentajes (`pct_*`), solo los favoritos.
