-- Crea Base de datos
create database manufactura_peru;
go

use manufactura_peru;
go
-- comprobamos que importamos las tablas 
select * 
from GRAN_EMPRESA_2022_MANUFACTURA;
go

select * 
from GRAN_EMPRESA_2023_MANUFACTURA;
go

select * 
from GRAN_EMPRESA_2024_MANUFACTURA;
go

-- Unimos las tres tablas para tener una completa

select *
into GRAN_EMPRESA_MANUFACTURA
from GRAN_EMPRESA_2022_MANUFACTURA
union all
select * 
from GRAN_EMPRESA_2023_MANUFACTURA
union all
select * 
from GRAN_EMPRESA_2024_MANUFACTURA

select * 
from GRAN_EMPRESA_MANUFACTURA

-- Limpieza de base

-- modificamos la talve de ventas_prom en dos decimales

alter table GRAN_EMPRESA_MANUFACTURA
alter column venta_prom decimal(30,2)

select * 
from GRAN_EMPRESA_MANUFACTURA

-- modificoa la colummano venta_prom para poder quier el cero adiconal incorrecto

update GRAN_EMPRESA_MANUFACTURA
set venta_prom = venta_prom / 10.0;

select * 
from GRAN_EMPRESA_MANUFACTURA

-- Total de registros 
select
    año,
    count(*) as total_registros,
    count(distinct id_emp) as empresas_unicas
from GRAN_EMPRESA_MANUFACTURA
group by año
order by año;

-- Busquemos valores nulos 

SELECT
    COUNT(*) AS total_registros,

    SUM(C   ASE WHEN id_emp IS NULL THEN 1 ELSE 0 END) AS nulos_id_emp,
    SUM(CASE WHEN ciiu IS NULL THEN 1 ELSE 0 END) AS nulos_ciiu,
    SUM(CASE WHEN descciiu IS NULL THEN 1 ELSE 0 END) AS nulos_descciiu,
    SUM(CASE WHEN ubigeo IS NULL THEN 1 ELSE 0 END) AS nulos_ubigeo,

    SUM(CASE WHEN departamento IS NULL THEN 1 ELSE 0 END) AS nulos_departamento,
    SUM(CASE WHEN provincia IS NULL THEN 1 ELSE 0 END) AS nulos_provincia,
    SUM(CASE WHEN distrito IS NULL THEN 1 ELSE 0 END) AS nulos_distrito,

    SUM(CASE WHEN sector IS NULL THEN 1 ELSE 0 END) AS nulos_sector,
    SUM(CASE WHEN venta_prom IS NULL THEN 1 ELSE 0 END) AS nulos_venta_prom,
    SUM(CASE WHEN trabajador IS NULL THEN 1 ELSE 0 END) AS nulos_trabajador,

    SUM(CASE WHEN experiencia IS NULL THEN 1 ELSE 0 END) AS nulos_experiencia,
    SUM(CASE WHEN categoria IS NULL THEN 1 ELSE 0 END) AS nulos_categoria,
    SUM(CASE WHEN año IS NULL THEN 1 ELSE 0 END) AS nulos_anio,
    SUM(CASE WHEN fec_creacion IS NULL THEN 1 ELSE 0 END) AS nulos_fecha

FROM GRAN_EMPRESA_MANUFACTURA;

-- Valores invalidos

select
    sum(case when venta_prom <= 0 then 1 else 0 end) as ventas_menor_igual_cero,
    sum(case when trabajador <= 0 then 1 else 0 end) as trabajadores_menor_igual_cero,
    sum(case when experiencia < 0 then 1 else 0 end) as experiencia_negativa
from GRAN_EMPRESA_MANUFACTURA;

-- Revisar duplicados
select 
    id_emp,
    año,
    count(*) as cantidad
from GRAN_EMPRESA_MANUFACTURA
group by 
    id_emp,
    año
having count(*) > 1
order by cantidad desc;

-- EDA

-- 1. panorama general
-- 1.1 evolución del número de empresas, ventas y trabajadores

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

-- 2. análisis geográfico
-- 2.1 empresa por departamento

select 
    departamento,
    count(distinct id_emp) as empresas
from dbo.GRAN_EMPRESA_MANUFACTURA
group by departamento
order by empresas desc;


-- 2.2 ventas por departamento

select
    departamento,
    count(distinct id_emp) as empresas,
    sum(venta_prom) as ventas_totales,
    round(avg(venta_prom), 2) as ventas_promedio
from dbo.GRAN_EMPRESA_MANUFACTURA
group by departamento
order by ventas_totales desc;

-- 2.3 ranking de departamentos por año
select
    año,
    departamento,
    sum(venta_prom) as ventas_totales,
    rank() over (
        partition by año
        order by sum(venta_prom) desc
    ) as ranking
from dbo.GRAN_EMPRESA_MANUFACTURA
group by
    año,
    departamento
order by
    año,
    ranking;

-- 3. análisis por actividad económica

-- 3.1 actividades con mayor número de empresas

select
    ciiu,
    descciiu,
    count(distinct id_emp) as empresas
from dbo.GRAN_EMPRESA_MANUFACTURA
group by
    ciiu,
    descciiu
order by empresas desc;

-- 3.2 actividades con mayores ventas

select
    ciiu,
    descciiu,
    count(distinct id_emp) as empresas,
    sum(venta_prom) as ventas_totales,
    round(avg(venta_prom), 2) as ventas_promedio
from dbo.gran_empresa_manufactura
group by
    ciiu,
    descciiu
order by ventas_totales desc;

--4. análisis de empleo
-- 4.1 trabajadores por año

select
    año,
    sum(trabajador) as trabajadores_totales,
    round(avg(cast(trabajador as decimal(18,2))), 2) as promedio_trabajadores,
    min(trabajador) as minimo_trabajadores,
    max(trabajador) as maximo_trabajadores
from dbo.gran_empresa_manufactura
group by año
order by año;

-- 4.2 actividades que generan más empleo

select
    ciiu,
    descciiu,
    sum(trabajador) as trabajadores_totales,
    round(avg(cast(trabajador as decimal(18,2))), 2) as promedio_trabajadores
from dbo.gran_empresa_manufactura
group by
    ciiu,
    descciiu
order by trabajadores_totales desc;

-- 4.3 departamentos con mayor empleo manufacturero


select
    departamento,
    sum(trabajador) as trabajadores_totales,
    count(distinct id_emp) as empresas
from dbo.gran_empresa_manufactura
group by departamento
order by trabajadores_totales desc;

-- 5. productividad: ventas por trabajador

-- 5.1 productividad por empresa

select
    año,
    id_emp,
    venta_prom,
    trabajador,
    round(
        venta_prom / nullif(trabajador, 0),
        2
    ) as ventas_por_trabajador
from dbo.gran_empresa_manufactura;

-- 5.2 actividades más productivas

select
    ciiu,
    descciiu,
    sum(venta_prom) as ventas_totales,
    sum(trabajador) as trabajadores_totales,
    round(
        sum(venta_prom) / nullif(sum(trabajador), 0),
        2
    ) as ventas_por_trabajador
from dbo.gran_empresa_manufactura
group by
    ciiu,
    descciiu
order by ventas_por_trabajador desc;


-- 6. evolución y crecimiento de las empresas

--6.1 empresas presentes durante los tres años

select
    id_emp,
    count(distinct año) as años_presentes
from dbo.gran_empresa_manufactura
group by id_emp
having count(distinct año) = 3;

--6.2 crecimiento de ventas entre 2022 y 2024
with empresas_comparables as (
    select
        id_emp,
        max(case when año = 2022 then venta_prom end) as ventas_2022,
        max(case when año = 2024 then venta_prom end) as ventas_2024
    from dbo.gran_empresa_manufactura
    group by id_emp
)

select
    id_emp,
    ventas_2022,
    ventas_2024,
    round(
        (
            ventas_2024 - ventas_2022
        ) / nullif(ventas_2022, 0) * 100,
        2
    ) as crecimiento_porcentual
from empresas_comparables
where ventas_2022 is not null
    and ventas_2024 is not null
order by crecimiento_porcentual desc;


-- 7. clasificación del desempeño de las empresas

with crecimiento_empresas as (
    select
        id_emp,
        max(case when año = 2022 then venta_prom end) as ventas_2022,
        max(case when año = 2024 then venta_prom end) as ventas_2024
    from dbo.gran_empresa_manufactura
    group by id_emp
)

select
    id_emp,
    ventas_2022,
    ventas_2024,
    round(
        (
            ventas_2024 - ventas_2022
        ) / nullif(ventas_2022, 0) * 100,
        2
    ) as crecimiento_porcentual,
    case
        when ventas_2024 > ventas_2022 * 1.10 then 'alto crecimiento'
        when ventas_2024 < ventas_2022 * 0.90 then 'en deterioro'
        else 'estable'
    end as clasificacion
from crecimiento_empresas
where ventas_2022 is not null
    and ventas_2024 is not null;


--  8.antigüedad y desempeño

select
    case
        when experiencia <= 5 then 'hasta 5 años'
        when experiencia between 6 and 10 then '6 a 10 años'
        when experiencia between 11 and 20 then '11 a 20 años'
        else 'más de 20 años'
    end as rango_experiencia,
    count(distinct id_emp) as empresas,
    round(avg(venta_prom), 2) as ventas_promedio,
    round(avg(cast(trabajador as decimal(18,2))), 2) as trabajadores_promedio
from dbo.gran_empresa_manufactura
group by
    case
        when experiencia <= 5 then 'hasta 5 años'
        when experiencia between 6 and 10 then '6 a 10 años'
        when experiencia between 11 and 20 then '11 a 20 años'
        else 'más de 20 años'
    end
order by rango_experiencia;



-- 9.concentración de ventas

with ranking_empresas as (
    select
        año,
        id_emp,
        venta_prom,
        rank() over (
            partition by año
            order by venta_prom desc
        ) as ranking
    from dbo.gran_empresa_manufactura
)

select
    año,
    sum(venta_prom) as ventas_top_10
from ranking_empresas
where ranking <= 10
group by año
order by año;