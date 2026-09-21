
    DROP VIEW gold.dim_clientes;
GO

CREATE VIEW gold.dim_clientes AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cli_id) AS clave_cliente, -- Clave subrogada
    ci.cli_id                             AS id_cliente,
    ci.cli_clave                          AS numero_cliente,
    ci.cli_nombre                         AS primer_nombre,
    ci.cli_apellido                       AS apellido,
    la.departamento                       AS departamento,
    CASE 
        WHEN ci.cli_genero != 'n/a' THEN ci.cli_genero -- CRM es la fuente principal para género
        ELSE COALESCE(ca.genero, 'n/a')  			   -- Alternativa de datos ERP
    END                                   AS genero,
    ca.fecha_nacimiento                   AS fecha_nacimiento,
    ci.cli_fecha_creacion                 AS fecha_creacion
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cli_clave = ca.id_cliente
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cli_clave = la.id_cliente;
GO

-- =============================================================================
-- Crear Dimensión: gold.dim_productos
-- =============================================================================
IF OBJECT_ID('gold.dim_productos', 'V') IS NOT NULL
    DROP VIEW gold.dim_productos;
GO

CREATE VIEW gold.dim_productos AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_fecha_inicio, pn.prd_clave) AS clave_producto, -- Clave subrogada
    pn.prd_id          AS id_producto,
    pn.prd_clave       AS numero_producto,
    pn.prd_nombre      AS nombre_producto,
    pn.id_categoria    AS id_categoria,
    pc.categoria       AS categoria,
    pc.subcategoria    AS subcategoria,
    pc.mantenimiento   AS mantenimiento,
    pn.prd_costo       AS costo,
    pn.prd_linea       AS linea_producto,
    pn.prd_fecha_inicio AS fecha_inicio
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.id_categoria = pc.id_categoria
WHERE pn.prd_fecha_fin IS NULL; -- Filtrar datos históricos
GO

-- =============================================================================
-- Crear Tabla de Hechos: gold.fact_ventas
-- =============================================================================
IF OBJECT_ID('gold.fact_ventas', 'V') IS NOT NULL
    DROP VIEW gold.fact_ventas;
GO

CREATE VIEW gold.fact_ventas AS
SELECT
    sd.vta_num_pedido  AS numero_orden,
    pr.clave_producto  AS clave_producto,
    cu.clave_cliente   AS clave_cliente,
    sd.vta_fecha_pedido AS fecha_orden,
    sd.vta_fecha_envio  AS fecha_envio,
    sd.vta_fecha_vencimiento AS fecha_vencimiento,
    sd.vta_ventas      AS monto_ventas,
    sd.vta_cantidad    AS cantidad,
    sd.vta_precio      AS precio
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_productos pr
    ON sd.vta_clave_producto = pr.numero_producto
LEFT JOIN gold.dim_clientes cu
    ON sd.vta_id_cliente = cu.id_cliente;
GO
