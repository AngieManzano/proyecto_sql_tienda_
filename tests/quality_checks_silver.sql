
SELECT 
    cli_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cli_id
HAVING COUNT(*) > 1 OR cli_id IS NULL;

SELECT 
    cli_clave 
FROM silver.crm_cust_info
WHERE cli_clave != TRIM(cli_clave);

SELECT DISTINCT 
    cli_estado_civil 
FROM silver.crm_cust_info;



SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


SELECT 
    prd_nombre 
FROM silver.crm_prd_info
WHERE prd_nombre != TRIM(prd_nombre);


SELECT 
    prd_costo 
FROM silver.crm_prd_info
WHERE prd_costo < 0 OR prd_costo IS NULL;

SELECT DISTINCT 
    prd_linea 
FROM silver.crm_prd_info;


SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_fecha_fin < prd_fecha_inicio;


SELECT 
    NULLIF(vta_fecha_vencimiento, 0) AS vta_fecha_vencimiento_limpia 
FROM bronze.crm_sales_details
WHERE vta_fecha_vencimiento <= 0 
    OR LEN(vta_fecha_vencimiento) != 8 
    OR vta_fecha_vencimiento > 20500101 
    OR vta_fecha_vencimiento < 19000101;


SELECT 
    * 
FROM silver.crm_sales_details
WHERE vta_fecha_pedido > vta_fecha_envio 
   OR vta_fecha_pedido > vta_fecha_vencimiento;


SELECT DISTINCT 
    vta_ventas,
    vta_cantidad,
    vta_precio 
FROM silver.crm_sales_details
WHERE vta_ventas != vta_cantidad * vta_precio
   OR vta_ventas IS NULL 
   OR vta_cantidad IS NULL 
   OR vta_precio IS NULL
   OR vta_ventas <= 0 
   OR vta_cantidad <= 0 
   OR vta_precio <= 0
ORDER BY vta_ventas, vta_cantidad, vta_precio;


SELECT DISTINCT 
    fecha_nacimiento 
FROM silver.erp_cust_az12
WHERE fecha_nacimiento < '1924-01-01' 
   OR fecha_nacimiento > GETDATE();










SELECT DISTINCT 
    genero 
FROM silver.erp_cust_az12;



SELECT DISTINCT 
    pais 
FROM silver.erp_loc_a101
ORDER BY pais;


SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE categoria != TRIM(categoria) 
   OR subcategoria != TRIM(subcategoria) 
   OR mantenimiento != TRIM(mantenimiento);










SELECT DISTINCT 
    mantenimiento 
FROM silver.erp_px_cat_g1v2;
