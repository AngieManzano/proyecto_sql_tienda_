
SELECT 
    clave_cliente,
    COUNT(*) AS cantidad_duplicados
FROM gold.dim_clientes
GROUP BY clave_cliente
HAVING COUNT(*) > 1;










SELECT 
    clave_producto,
    COUNT(*) AS cantidad_duplicados
FROM gold.dim_productos
GROUP BY clave_producto
HAVING COUNT(*) > 1;














SELECT * 
FROM gold.fact_ventas f
LEFT JOIN gold.dim_clientes c
    ON c.clave_cliente = f.clave_cliente
LEFT JOIN gold.dim_productos p
    ON p.clave_producto = f.clave_producto
WHERE p.clave_producto IS NULL OR c.clave_cliente IS NULL;
