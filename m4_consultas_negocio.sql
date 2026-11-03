USE Ventas_Tech_DB; 

-- Consulta 1: Resumen ejecutivo mensual --

SELECT 
MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado,
COUNT(*) AS cantidad_pedidos,
AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

-- Consulta 2: Ranking de productos --

SELECT TOP 5 id_producto,
SUM(cantidad) AS unidades_vendidas,
SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;

-- Consulta 3: Clientes recurrentes --

SELECT id_cliente,
COUNT(*) AS cantidad_de_pedidos, 
SUM (cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

-- Consulta: Productos por encima/por debajo del promedio --

WITH ventas_por_producto AS (
-- 1ra parte: total facturado por id_producto -- 
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_producto
    FROM ventas
    GROUP BY id_producto
)
-- 2da parte: comparar id_producto con el promedio por producto --
SELECT
    id_producto,
    total_producto,
    CASE
        WHEN total_producto > (
            SELECT AVG(total_producto)
            FROM ventas_por_producto
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion
FROM ventas_por_producto
ORDER BY id_producto;

-- COMENTARIOS: HALLAZGOS -- 
-- 1) El ticket promedio del mes de Marzo 2024 es de $ 644,44
-- 2) El producto más vendido en unidades en Marzo 2024 es el Mouse Inalámbrico
-- 3) Hay 5 clientes que hicieron pedidos recurrentes (2 pedidos cada uno)


