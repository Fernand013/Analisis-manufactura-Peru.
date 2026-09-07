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

<img width="527" height="45" alt="image" src="https://github.com/user-attachments/assets/cfddfdb3-6f92-4600-980d-ef780d75f065" />

[PENDIENTE: comentario]

### Duplicados
Se verificó que no existan registros duplicados por `id_emp` y `año`.

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


El número de empresas cayó de 1,767 en 2022 a 1,633 en 2023, y solo se recuperó parcialmente a 1,657 en 2024. Las ventas totales muestran una tendencia descendente sostenida, pasando de S/ 2,037 millones en 2022 a S/ 1,574 millones en 2024 (una caída de casi 23%). Los trabajadores totales siguieron el mismo patrón, cayendo fuerte en 2023 y recuperándose solo en parte en 2024.

Sería importante investigar qué factores externos (económicos o sectoriales) explican la fuerte caída de 2023, y dar seguimiento cercano para confirmar si la tendencia negativa continúa o si 2024 marca el inicio de una recuperación.

### 2. Análisis geográfico

**2.1 Empresas por departamento** 

<img width="201" height="186" alt="image" src="https://github.com/user-attachments/assets/ab818bb4-dc6b-47a9-ba5a-faca53781609" />

Existe una concentración geográfica muy marcada: Lima reúne 1,751 de las empresas manufactureras grandes del país, muy por encima de Callao (130) y Arequipa (76), que ocupan un distante segundo y tercer lugar. El resto de departamentos apenas superan las 30 empresas cada uno.

**2.2 Ventas por departamento** 

<img width="420" height="185" alt="image" src="https://github.com/user-attachments/assets/d5bdfed3-fdfb-489b-adbe-708abedfcfe5" />

Aunque Lima lidera en ventas totales (S/ 3,956 millones) por su enorme cantidad de empresas, no es el departamento más "eficiente" en términos de ventas promedio por empresa. Ica (S/ 2.14 millones promedio), Callao (S/ 1.71 millones) y La Libertad (S/ 1.84 millones) muestran ventas promedio más altas que Lima (S/ 966 mil), lo que sugiere empresas de mayor tamaño individual en esas regiones pese a tener muchas menos compañías.

**2.3 Ranking de departamentos por año** 

<img width="337" height="181" alt="image" src="https://github.com/user-attachments/assets/4a71de4c-a4d7-4f7b-9940-ad0781a64e5f" />

Lima domina el ranking de ventas en 2022 con más de S/ 1,486 millones, siendo más de 6 veces superior a Callao, que ocupa el segundo lugar (S/ 227 millones). Esta brecha tan amplia confirma que la actividad manufacturera de gran empresa en el Perú está fuertemente centralizada en la capital, y no solo en cantidad de empresas, sino también en volumen de ventas.

### 3. Análisis por actividad económica (CIIU)

**3.1 Actividades con mayor número de empresas** 

<img width="527" height="187" alt="image" src="https://github.com/user-attachments/assets/8507cf13-24b7-4103-a945-f0739d0cd87a" />

La fabricación de productos de plástico (CIIU 2520) lidera con 180 empresas, seguida de cerca por la elaboración y conservación de frutas y legumbres (170) y la fabricación de prendas de vestir (134). Esto muestra que el sector manufacturero grande del Perú está bastante diversificado entre plásticos, alimentos y textiles, sin una sola actividad que concentre la mayoría de empresas.

**3.2 Actividades con mayores ventas**

<img width="737" height="183" alt="image" src="https://github.com/user-attachments/assets/f6124602-9f31-414b-9cba-2e6329c341cc" />

La fabricación de productos de plástico también lidera en ventas totales (S/ 372 millones), coincidiendo con ser la actividad con más empresas. Sin embargo, en ventas promedio por empresa destaca la fabricación de bebidas malteadas y de malta, con S/ 13.36 millones por empresa pese a tener solo 6 compañías — evidenciando que es una actividad de nicho pero de alto valor por unidad de negocio.

### 4. Análisis de empleo

**4.1 Trabajadores por año** 

<img width="738" height="91" alt="image" src="https://github.com/user-attachments/assets/c86b30b9-fe8e-4a12-8b26-fd2cad7f59ae" />

El total de trabajadores cayó de 421,261 en 2022 a 350,565 en 2023 (-16.8%), en línea con la caída de ventas ya observada, y se recuperó parcialmente a 385,117 en 2024. El promedio de trabajadores por empresa se mantuvo relativamente estable (entre 214 y 238), lo que sugiere que la caída se debió más a cierre o reducción de empresas que a despidos masivos dentro de las que se mantuvieron activas.

**4.2 Actividades que generan más empleo** 

<img width="732" height="184" alt="image" src="https://github.com/user-attachments/assets/90110e16-cd10-4fd5-9f63-4fbd8ff50d8f" />

La elaboración y conservación de frutas y legumbres es, por lejos, la actividad que más empleo genera (194,016 trabajadores), casi el triple que la fabricación de prendas de vestir, que ocupa el segundo lugar (86,322). Esto contrasta con el ranking de ventas, donde plástico lideraba — mostrando que la actividad más intensiva en mano de obra no es necesariamente la más rentable.

**4.3 Departamentos con mayor empleo manufacturero** 

<img width="346" height="185" alt="image" src="https://github.com/user-attachments/assets/03cf7fbc-9544-4a28-873c-3aaa789b70c1" />

Lima concentra 826,625 trabajadores, muy por encima de La Libertad (96,176) y Callao (80,684), reforzando el mismo patrón de centralización visto en número de empresas y ventas. Esto confirma que el empleo manufacturero de gran empresa en el Perú depende en gran medida de la actividad económica de la capital.

### 5. Productividad: ventas por trabajador

**5.1 Productividad por empresa** 

<img width="625" height="188" alt="image" src="https://github.com/user-attachments/assets/928949a7-223e-4d72-a4a4-2a865c134160" />

La productividad por trabajador varía enormemente entre empresas del mismo año: algunas generan más de S/ 100 mil por trabajador (como la empresa con solo 1 trabajador y S/ 188,600 en ventas), mientras que otras con más personal generan apenas S/ 645 por trabajador. Esto indica que el tamaño de la planilla no garantiza mayor productividad, y que hay empresas pequeñas altamente eficientes junto a otras grandes con rendimiento por trabajador mucho menor.

**5.2 Actividades más productivas** 

<img width="812" height="188" alt="image" src="https://github.com/user-attachments/assets/215c1f67-0291-4cce-a6a8-9dd4c5e18a76" />

La fabricación de maletas, bolsos y artículos de viaje resulta la actividad más productiva por trabajador (S/ 4.18 millones), pero con apenas 3 trabajadores en total — un caso atípico que probablemente corresponde a 1-2 empresas muy específicas, no a un patrón sectorial amplio. Actividades con una base de empleados más numerosa, como refinación de petróleo (3,190 trabajadores) y productos primarios de metales (5,175 trabajadores), muestran una productividad más "realista" y sostenible, entre S/ 25 mil y S/ 56 mil por trabajador.

### 6. Evolución y crecimiento de las empresas

**6.1 Empresas presentes los tres años** 

<img width="404" height="185" alt="image" src="https://github.com/user-attachments/assets/03c0678e-645d-4f6f-afb3-3117ecf7bfb2" />

**6.2 Crecimiento de ventas entre 2022 y 2024** 

<img width="617" height="185" alt="image" src="https://github.com/user-attachments/assets/fbba6207-5d9e-41d9-ace2-238a09b17fde" />

Se observan casos de crecimiento extraordinario, como una empresa que pasó de S/ 763,830 a S/ 5,716,504 (+648%) entre 2022 y 2024. Sin embargo, estos crecimientos tan altos suelen partir de una base de ventas pequeña, por lo que representan casos puntuales de expansión más que una tendencia generalizada del sector — es un buen ejemplo de empresas "estrella" que valdría la pena estudiar por separado para identificar qué hicieron diferente.

### 7. Clasificación del desempeño de las empresas

<img width="717" height="183" alt="image" src="https://github.com/user-attachments/assets/306a34f9-4644-4918-867e-80741ea1d20a" />

Se efidencia qiue predominan las empresas "en deterioro" (3 casos, con caídas de hasta -44.99%) y "estable" (3 casos, con variaciones leves de -4.42%), frente a solo 2 casos de "alto crecimiento" (10.93% y 17.92%). Esto sugiere que, incluso entre las empresas que sobrevivieron los tres años, la tendencia general no fue de expansión sino de estancamiento o retroceso en ventas — coherente con la caída general del sector manufacturero observada en 2023.

### 8. Antigüedad y desempeño

<img width="718" height="106" alt="image" src="https://github.com/user-attachments/assets/c163c371-f796-4504-b897-efec548e278f" />

Sorprendentemente, las empresas con más de 20 años de experiencia tienen tanto las ventas promedio más altas (S/ 1,571,322) como el mayor número de trabajadores promedio (345), mientras que las empresas más jóvenes (hasta 5 años) tienen las ventas más bajas y menos trabajadores (84 en promedio). Esto sugiere una relación positiva clara entre antigüedad y tamaño/desempeño de la empresa, consistente con la idea de que las empresas manufactureras grandes tardan años en consolidarse.

Los programas de apoyo a empresas jóvenes (créditos, capacitación, acceso a mercados) podrían ayudar a acelerar su curva de crecimiento y reducir la brecha con las empresas más consolidadas.

### 9. Concentración de ventas (Top 10 empresas)

<img width="181" height="85" alt="image" src="https://github.com/user-attachments/assets/1d432d12-64db-40fd-84a6-be32f91b7603" />

Usando el total de ventas por año que ya calculaste en la sección 1 (S/ 2,037.4M en 2022, S/ 1,632.4M en 2023, S/ 1,574.0M en 2024), las 10 empresas más grandes representan:

2022: ≈38.7% del total de ventas

2023: ≈47.3% del total de ventas

2024: ≈41.9% del total de ventas

Existe una concentración muy alta de las ventas en muy pocas empresas — casi la mitad de todas las ventas del sector en 2023 provino de solo 10 compañías. Esto indica que el desempeño del sector manufacturero peruano depende fuertemente de un grupo reducido de grandes jugadores, y que la caída de ventas de 2023 pudo haberse visto amplificada si alguna de estas empresas líderes tuvo un mal año.

---

## Conclusión

[PENDIENTE: 4-6 líneas resumiendo los 2-3 hallazgos más importantes del análisis completo — por ejemplo, sobre concentración geográfica, actividades más productivas, o crecimiento desigual entre empresas — y qué debería hacer la empresa/entidad con esta información.]

---

## About
[PENDIENTE: breve descripción, ej. "Mi proyecto de SQL sobre la gran empresa manufacturera peruana"]
