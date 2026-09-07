# Proyecto SQL: Análisis de la Gran Empresa Manufacturera en el Perú (2022-2024)

## Resumen (Overview)

Este proyecto analiza el comportamiento de las grandes empresas manufactureras del Perú entre 2022 y 2024, evaluando ventas, empleo, productividad y crecimiento por región y actividad económica, con el fin de identificar patrones relevantes para la toma de decisiones.

**Herramientas utilizadas:** SQL Server Management Studio (T-SQL)

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

<img width="1550" height="197" alt="image" src="https://github.com/user-attachments/assets/4315d62a-82b6-41bd-aec6-071efd163320" />


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
<img width="300" height="82" alt="image" src="https://github.com/user-attachments/assets/f93711dd-4258-4c08-a376-90bc257b083c" />

R

### Valores nulos
Se verificó la existencia de valores nulos en todas las columnas clave.

<img width="1557" height="47" alt="image" src="https://github.com/user-attachments/assets/5669ec97-7399-4ffb-bf81-5e77543bce5f" />

No se encontraron valores nulos en ninguna columna.

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

<img width="650" height="86" alt="image" src="https://github.com/user-attachments/assets/2f882b25-1972-4ea1-96be-65d02223c3c3" />


*[PENDIENTE: 2-3 líneas de insight — ej. si las ventas crecieron/cayeron, si el número de empresas aumentó, etc.]*

*[PENDIENTE: 1 recomendación de negocio basada en este hallazgo]*

### 2. Análisis geográfico

**2.1 Empresas por departamento** 

<img width="201" height="186" alt="image" src="https://github.com/user-attachments/assets/ab818bb4-dc6b-47a9-ba5a-faca53781609" />

**2.2 Ventas por departamento** — [PENDIENTE: captura + insight]

<img width="420" height="185" alt="image" src="https://github.com/user-attachments/assets/d5bdfed3-fdfb-489b-adbe-708abedfcfe5" />

**2.3 Ranking de departamentos por año** — [PENDIENTE: captura + insight]

<img width="337" height="181" alt="image" src="https://github.com/user-attachments/assets/4a71de4c-a4d7-4f7b-9940-ad0781a64e5f" />

### 3. Análisis por actividad económica (CIIU)

**3.1 Actividades con mayor número de empresas** — [PENDIENTE: captura + insight]

<img width="527" height="187" alt="image" src="https://github.com/user-attachments/assets/8507cf13-24b7-4103-a945-f0739d0cd87a" />

**3.2 Actividades con mayores ventas** — [PENDIENTE: captura + insight]

<img width="737" height="183" alt="image" src="https://github.com/user-attachments/assets/f6124602-9f31-414b-9cba-2e6329c341cc" />

### 4. Análisis de empleo

**4.1 Trabajadores por año** — [PENDIENTE: captura + insight]

<img width="738" height="91" alt="image" src="https://github.com/user-attachments/assets/c86b30b9-fe8e-4a12-8b26-fd2cad7f59ae" />

**4.2 Actividades que generan más empleo** — [PENDIENTE: captura + insight]

<img width="732" height="184" alt="image" src="https://github.com/user-attachments/assets/90110e16-cd10-4fd5-9f63-4fbd8ff50d8f" />

**4.3 Departamentos con mayor empleo manufacturero** — [PENDIENTE: captura + insight]

<img width="346" height="185" alt="image" src="https://github.com/user-attachments/assets/03cf7fbc-9544-4a28-873c-3aaa789b70c1" />

### 5. Productividad: ventas por trabajador

**5.1 Productividad por empresa** — [PENDIENTE: captura + insight]

<img width="625" height="188" alt="image" src="https://github.com/user-attachments/assets/928949a7-223e-4d72-a4a4-2a865c134160" />

**5.2 Actividades más productivas** — [PENDIENTE: captura + insight]

<img width="812" height="188" alt="image" src="https://github.com/user-attachments/assets/215c1f67-0291-4cce-a6a8-9dd4c5e18a76" />

### 6. Evolución y crecimiento de las empresas

**6.1 Empresas presentes los tres años** — [PENDIENTE: captura + insight]

<img width="404" height="185" alt="image" src="https://github.com/user-attachments/assets/03c0678e-645d-4f6f-afb3-3117ecf7bfb2" />

**6.2 Crecimiento de ventas entre 2022 y 2024** — [PENDIENTE: captura + insight]

<img width="617" height="185" alt="image" src="https://github.com/user-attachments/assets/fbba6207-5d9e-41d9-ace2-238a09b17fde" />

### 7. Clasificación del desempeño de las empresas

<img width="717" height="183" alt="image" src="https://github.com/user-attachments/assets/306a34f9-4644-4918-867e-80741ea1d20a" />

[PENDIENTE: captura + insight — cuántas empresas cayeron en "alto crecimiento", "estable" o "en deterioro"]

### 8. Antigüedad y desempeño

<img width="718" height="106" alt="image" src="https://github.com/user-attachments/assets/c163c371-f796-4504-b897-efec548e278f" />

[PENDIENTE: captura + insight — ¿las empresas más antiguas venden más o tienen más trabajadores?]

### 9. Concentración de ventas (Top 10 empresas)

<img width="181" height="85" alt="image" src="https://github.com/user-attachments/assets/1d432d12-64db-40fd-84a6-be32f91b7603" />

[PENDIENTE: captura + insight — qué porcentaje del total representan las 10 empresas más grandes cada año]

---

## Conclusión

[PENDIENTE: 4-6 líneas resumiendo los 2-3 hallazgos más importantes del análisis completo — por ejemplo, sobre concentración geográfica, actividades más productivas, o crecimiento desigual entre empresas — y qué debería hacer la empresa/entidad con esta información.]

---

## About
[PENDIENTE: breve descripción, ej. "Mi proyecto de SQL sobre la gran empresa manufacturera peruana"]
