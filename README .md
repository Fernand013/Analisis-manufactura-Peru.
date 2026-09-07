# Proyecto SQL: Análisis de la Gran Empresa Manufacturera en el Perú (2022-2024)

## Resumen (Overview)

[PENDIENTE: 2-3 líneas explicando el objetivo del proyecto. Ej: "Este proyecto analiza el comportamiento de las grandes empresas manufactureras del Perú entre 2022 y 2024, evaluando ventas, empleo, productividad y crecimiento por región y actividad económica, con el fin de identificar patrones relevantes para la toma de decisiones."]

**Herramientas utilizadas:** SQL Server Management Studio (T-SQL)

> 📩 Si quieres aprender SQL, conéctate conmigo: [PENDIENTE: tus redes sociales, si quieres incluirlas como en el ejemplo]

---

## Estructura del Proyecto
- [Sobre los Datos](#sobre-los-datos)
- [Tareas](#tareas-task)
- [Limpieza de Datos](#limpieza-de-datos)
- [Análisis Exploratorio de Datos e Insights](#análisis-exploratorio-de-datos-eda-e-insights)
- [Conclusión](#conclusión)

---

## Sobre los Datos

Los datos provienen de tres archivos anuales (2022, 2023 y 2024) de la Gran Empresa Manufacturera del Perú, que fueron unificados en una sola tabla `GRAN_EMPRESA_MANUFACTURA`.

**Columnas principales:**
- `id_emp` — identificador de la empresa
- `ciiu` / `descciiu` — código y descripción de la actividad económica (CIIU)
- `ubigeo`, `departamento`, `provincia`, `distrito` — ubicación geográfica
- `sector` — sector económico
- `venta_prom` — ventas promedio
- `trabajador` — número de trabajadores
- `experiencia` — años de experiencia/antigüedad de la empresa
- `categoria` — categoría de la empresa
- `año` — año del registro (2022, 2023, 2024)
- `fec_creacion` — fecha de creación

[PENDIENTE: pega aquí una captura del `SELECT * FROM GRAN_EMPRESA_MANUFACTURA` con algunas filas, como hizo el ejemplo]

---

## Tareas (Task)

En este análisis, respondo a las siguientes preguntas:

1. **Panorama general:** ¿Cómo evolucionó el número de empresas, las ventas totales/promedio y los trabajadores entre 2022 y 2024?
2. **Análisis geográfico:** ¿Qué departamentos concentran más empresas y ventas? ¿Cómo cambia el ranking de departamentos por año?
3. **Análisis por actividad económica:** ¿Qué actividades (CIIU) tienen más empresas y cuáles generan más ventas?
4. **Análisis de empleo:** ¿Cómo varía el número de trabajadores por año, actividad y departamento?
5. **Productividad:** ¿Qué tan productivas son las empresas y actividades en términos de ventas por trabajador?
6. **Evolución y crecimiento:** ¿Cuántas empresas se mantuvieron activas los tres años y cuánto crecieron sus ventas entre 2022 y 2024?
7. **Clasificación de desempeño:** ¿Qué empresas tuvieron alto crecimiento, estabilidad o deterioro en ventas?
8. **Antigüedad y desempeño:** ¿La experiencia/antigüedad de una empresa se relaciona con mayores ventas o más trabajadores?
9. **Concentración de ventas:** ¿Qué porción de las ventas totales representan las 10 empresas más grandes cada año?

---

## Limpieza de Datos

Antes del análisis, se unificaron las tres tablas anuales en una sola (`GRAN_EMPRESA_MANUFACTURA`) y se realizaron las siguientes validaciones:

### Corrección de formato
Se ajustó la columna `venta_prom` a formato decimal con dos posiciones y se corrigió un error de escala (un cero adicional) dividiendo los valores entre 10.

```sql
alter table GRAN_EMPRESA_MANUFACTURA
alter column venta_prom decimal(30,2)

update GRAN_EMPRESA_MANUFACTURA
set venta_prom = venta_prom / 10.0;
```

### Total de registros por año
[PENDIENTE: pegar resultado + 1-2 líneas de comentario]

### Valores nulos
Se verificó la existencia de valores nulos en todas las columnas clave.

[PENDIENTE: pegar resultado. Ej: "No se encontraron valores nulos en ninguna columna."]

### Valores inválidos
Se revisaron ventas ≤ 0, trabajadores ≤ 0 y experiencia negativa.

[PENDIENTE: pegar resultado y comentario]

### Duplicados
Se verificó que no existan registros duplicados por `id_emp` y `año`.

[PENDIENTE: pegar resultado]

---

## Análisis Exploratorio de Datos (EDA) e Insights

### 1. Panorama general: evolución de empresas, ventas y trabajadores por año

```sql
select
    año,
    count(distinct id_emp) as empresas,
    sum(venta_prom) as ventas_totales,
    round(avg(venta_prom), 2) as ventas_promedio,
    sum(trabajador) as trabajadores_totales,
    round(avg(cast(trabajador as decimal(18,2))), 2) as trabajadores_promedio
from dbo.GRAN_EMPRESA_MANUFACTURA
group by año
order by año;
```

[PENDIENTE: captura de resultado]

*[PENDIENTE: 2-3 líneas de insight — ej. si las ventas crecieron/cayeron, si el número de empresas aumentó, etc.]*

*[PENDIENTE: 1 recomendación de negocio basada en este hallazgo]*

### 2. Análisis geográfico

**2.1 Empresas por departamento** — [PENDIENTE: captura + insight]

**2.2 Ventas por departamento** — [PENDIENTE: captura + insight]

**2.3 Ranking de departamentos por año** — [PENDIENTE: captura + insight]

### 3. Análisis por actividad económica (CIIU)

**3.1 Actividades con mayor número de empresas** — [PENDIENTE: captura + insight]

**3.2 Actividades con mayores ventas** — [PENDIENTE: captura + insight]

### 4. Análisis de empleo

**4.1 Trabajadores por año** — [PENDIENTE: captura + insight]

**4.2 Actividades que generan más empleo** — [PENDIENTE: captura + insight]

**4.3 Departamentos con mayor empleo manufacturero** — [PENDIENTE: captura + insight]

### 5. Productividad: ventas por trabajador

**5.1 Productividad por empresa** — [PENDIENTE: captura + insight]

**5.2 Actividades más productivas** — [PENDIENTE: captura + insight]

### 6. Evolución y crecimiento de las empresas

**6.1 Empresas presentes los tres años** — [PENDIENTE: captura + insight]

**6.2 Crecimiento de ventas entre 2022 y 2024** — [PENDIENTE: captura + insight]

### 7. Clasificación del desempeño de las empresas

[PENDIENTE: captura + insight — cuántas empresas cayeron en "alto crecimiento", "estable" o "en deterioro"]

### 8. Antigüedad y desempeño

[PENDIENTE: captura + insight — ¿las empresas más antiguas venden más o tienen más trabajadores?]

### 9. Concentración de ventas (Top 10 empresas)

[PENDIENTE: captura + insight — qué porcentaje del total representan las 10 empresas más grandes cada año]

---

## Conclusión

[PENDIENTE: 4-6 líneas resumiendo los 2-3 hallazgos más importantes del análisis completo — por ejemplo, sobre concentración geográfica, actividades más productivas, o crecimiento desigual entre empresas — y qué debería hacer la empresa/entidad con esta información.]

---

## About
[PENDIENTE: breve descripción, ej. "Mi proyecto de SQL sobre la gran empresa manufacturera peruana"]
