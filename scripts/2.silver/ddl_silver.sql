/*
===============================================================================
Script DDL: Crear Tablas Silver
===============================================================================
Propósito del Script:
    Este script crea tablas en el esquema 'silver', eliminando las tablas existentes 
    si ya existen.
    Ejecute este script para redefinir la estructura DDL de las tablas de la capa 'silver'.
===============================================================================
*/

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cli_id              INT,
    cli_clave           NVARCHAR(50),
    cli_nombre          NVARCHAR(50),
    cli_apellido        NVARCHAR(50),
    cli_estado_civil    NVARCHAR(50),
    cli_genero          NVARCHAR(50),
    cli_fecha_creacion  DATE,
    dwh_fecha_creacion  DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id              INT,
    id_categoria        NVARCHAR(50),
    prd_clave           NVARCHAR(50),
    prd_nombre          NVARCHAR(50),
    prd_costo           INT,
    prd_linea           NVARCHAR(50),
    prd_fecha_inicio    DATE,
    prd_fecha_fin       DATE,
    dwh_fecha_creacion  DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    vta_num_pedido        NVARCHAR(50),
    vta_clave_producto    NVARCHAR(50),
    vta_id_cliente        INT,
    vta_fecha_pedido      DATE,
    vta_fecha_envio       DATE,
    vta_fecha_vencimiento DATE,
    vta_ventas            INT,
    vta_cantidad          INT,
    vta_precio            INT,
    dwh_fecha_creacion    DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
    id_cliente          NVARCHAR(50),
    pais                NVARCHAR(50),
    dwh_fecha_creacion  DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12 (
    id_cliente          NVARCHAR(50),
    fecha_nacimiento    DATE,
    genero              NVARCHAR(50),
    dwh_fecha_creacion  DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
    id_categoria        NVARCHAR(50),
    categoria           NVARCHAR(50),
    subcategoria        NVARCHAR(50),
    mantenimiento       NVARCHAR(50),
    dwh_fecha_creacion  DATETIME2 DEFAULT GETDATE()
);
GO
