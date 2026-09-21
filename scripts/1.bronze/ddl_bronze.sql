

CREATE DATABASE  DB_DATA_ACADEMY ;
USE DB_DATA_ACADEMY;

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO








IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO












--> DATA ENGINERR EXTRACT 
CREATE TABLE bronze.crm_cust_info (
    cli_id              INT,
    cli_clave           NVARCHAR(50),
    cli_nombre          NVARCHAR(50),
    cli_apellido        NVARCHAR(50),
    cli_estado_civil    NVARCHAR(50),
    cli_genero          NVARCHAR(50),
    cli_fecha_creacion  DATE
);
GO











IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id            INT,
    prd_clave         NVARCHAR(50),
    prd_nombre        NVARCHAR(50),
    prd_costo         INT,
    prd_linea         NVARCHAR(50),
    prd_fecha_inicio  DATETIME,
    prd_fecha_fin     DATETIME
);
GO










IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    vta_num_pedido        NVARCHAR(50),
    vta_clave_producto    NVARCHAR(50),
    vta_id_cliente        INT,
    vta_fecha_pedido      INT,
    vta_fecha_envio       INT,
    vta_fecha_vencimiento INT,
    vta_ventas            INT,
    vta_cantidad          INT,
    vta_precio            INT
);
GO










IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO










CREATE TABLE bronze.erp_loc_a101 (
    id_cliente    NVARCHAR(50),
    pais          NVARCHAR(50)
);
GO








IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO










CREATE TABLE bronze.erp_cust_az12 (
    id_cliente        NVARCHAR(50),
    fecha_nacimiento  DATE,
    genero            NVARCHAR(50)
);
GO




IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO








CREATE TABLE bronze.erp_px_cat_g1v2 (
    id_categoria    NVARCHAR(50),
    categoria       NVARCHAR(50),
    subcategoria    NVARCHAR(50),
    mantenimiento   NVARCHAR(50)
);
GO
