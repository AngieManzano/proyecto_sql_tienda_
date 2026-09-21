

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'proyecto_sql_tienda_')
BEGIN
    ALTER DATABASE proyecto_sql_tienda_ SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE proyecto_sql_tienda_;
END;
GO


CREATE DATABASE proyecto_sql_tienda_;
GO

USE proyecto_sql_tienda_;
GO

-- Crear Esquemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

EXEC bronze.load_bronze;
GO

SELECT *
FROM bronze.crm_cust_info;
GO

PRINT 'HOLA'

TRUNCATE TABLE bronze.crm_cust_info;


SELECT DISTINCT [departamento]
FROM bronze.erp_loc_a101;

SELECT DISTINCT [departamento]
FROM silver.erp_loc_a101




SELECT *
FROM gold.dim_productos


        