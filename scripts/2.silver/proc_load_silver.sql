

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Cargando la Capa Silver';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Cargando Tablas CRM';
        PRINT '------------------------------------------------';

        -- Cargando silver.crm_cust_info
        SET @start_time = GETDATE();
        PRINT '>> Truncando Tabla: silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;
        PRINT '>> Insertando Datos En: silver.crm_cust_info';
        INSERT INTO silver.crm_cust_info (
            cli_id, 
            cli_clave, 
            cli_nombre, 
            cli_apellido, 
            cli_genero,
            cli_fecha_creacion
        )
        SELECT
            cli_id,
            cli_clave,
            TRIM(cli_nombre) AS cli_nombre,
            TRIM(cli_apellido) AS cli_apellido,
          
            CASE 
                WHEN UPPER(TRIM(cli_genero)) = 'F' THEN 'Femenino'
                WHEN UPPER(TRIM(cli_genero)) = 'M' THEN 'Masculino'
                ELSE 'n/a'
            END AS cli_genero, -- Normalizar genero a un formato legible
            cli_fecha_creacion
        FROM (
            SELECT
                *,
                ROW_NUMBER() OVER (PARTITION BY cli_id ORDER BY cli_fecha_creacion DESC) AS flag_ultimo
            FROM bronze.crm_cust_info
            WHERE cli_id IS NOT NULL
        ) t
        WHERE flag_ultimo = 1; -- Seleccionar el registro mas reciente por cliente
        SET @end_time = GETDATE();
        PRINT '>> Duracion de la Carga: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        -- Cargando silver.crm_prd_info
        SET @start_time = GETDATE();
        PRINT '>> Truncando Tabla: silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;
        PRINT '>> Insertando Datos En: silver.crm_prd_info';
        INSERT INTO silver.crm_prd_info (
            prd_id,
            id_categoria,
            prd_clave,
            prd_nombre,
            prd_costo,
            prd_linea,
            prd_fecha_inicio,
            prd_fecha_fin
        )
        SELECT
            prd_id,
            REPLACE(SUBSTRING(prd_clave, 1, 5), '-', '_') AS id_categoria, -- Extraer ID de categoria
            SUBSTRING(prd_clave, 7, LEN(prd_clave)) AS prd_clave,        -- Extraer clave del producto
            prd_nombre,
            ISNULL(prd_costo, 0) AS prd_costo,
            CASE 
                WHEN UPPER(TRIM(prd_linea)) = 'M' THEN 'Montaña'
                WHEN UPPER(TRIM(prd_linea)) = 'R' THEN 'Carretera'
                WHEN UPPER(TRIM(prd_linea)) = 'S' THEN 'Otras Ventas'
                WHEN UPPER(TRIM(prd_linea)) = 'T' THEN 'Turismo'
                ELSE 'n/a'
            END AS prd_linea,
            TRY_CAST(prd_fecha_inicio AS DATE) AS prd_fecha_inicio,
            TRY_CAST(
                LEAD(prd_fecha_inicio) OVER (PARTITION BY prd_clave ORDER BY prd_fecha_inicio) - 1 
                AS DATE
            ) AS prd_fecha_fin -- Calcular la fecha de finalizacion como un dia antes de la siguiente fecha de inicio
        FROM bronze.crm_prd_info;
        SET @end_time = GETDATE();
        PRINT '>> Duracion de la Carga: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        -- Cargando silver.crm_sales_details
        SET @start_time = GETDATE();
        PRINT '>> Truncando Tabla: silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;
        PRINT '>> Insertando Datos En: silver.crm_sales_details';
        INSERT INTO silver.crm_sales_details (
            vta_num_pedido,
            vta_clave_producto,
            vta_id_cliente,
            vta_fecha_pedido,
            vta_fecha_envio,
            vta_fecha_vencimiento,
            vta_ventas,
            vta_cantidad,
            vta_precio
        )
        SELECT 
            vta_num_pedido,
            vta_clave_producto,
            vta_id_cliente,
            CASE 
                WHEN vta_fecha_pedido = 0 OR LEN(vta_fecha_pedido) != 8 THEN NULL
                ELSE CAST(CAST(vta_fecha_pedido AS VARCHAR) AS DATE)
            END AS vta_fecha_pedido,
            CASE 
                WHEN vta_fecha_envio = 0 OR LEN(vta_fecha_envio) != 8 THEN NULL
                ELSE CAST(CAST(vta_fecha_envio AS VARCHAR) AS DATE)
            END AS vta_fecha_envio,
            CASE 
                WHEN vta_fecha_vencimiento = 0 OR LEN(vta_fecha_vencimiento) != 8 THEN NULL
                ELSE CAST(CAST(vta_fecha_vencimiento AS VARCHAR) AS DATE)
            END AS vta_fecha_vencimiento,
            CASE 
                WHEN vta_ventas IS NULL OR vta_ventas <= 0 OR vta_ventas != vta_cantidad * ABS(vta_precio) 
                    THEN vta_cantidad * ABS(vta_precio)
                ELSE vta_ventas
            END AS vta_ventas, -- Recalcular ventas si el valor original falta o es incorrecto
            vta_cantidad,
            CASE 
                WHEN vta_precio IS NULL OR vta_precio <= 0 
                    THEN vta_ventas / NULLIF(vta_cantidad, 0)
                ELSE vta_precio  -- Derivar el precio si el valor original no es valido
            END AS vta_precio
        FROM bronze.crm_sales_details;
        SET @end_time = GETDATE();
        PRINT '>> Duracion de la Carga: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        PRINT '------------------------------------------------';
        PRINT 'Cargando Tablas ERP';
        PRINT '------------------------------------------------';

        -- Cargando silver.erp_cust_az12
        SET @start_time = GETDATE();
        PRINT '>> Truncando Tabla: silver.erp_cust_az12';
        TRUNCATE TABLE silver.erp_cust_az12;
        PRINT '>> Insertando Datos En: silver.erp_cust_az12';
        INSERT INTO silver.erp_cust_az12 (
            id_cliente,
            fecha_nacimiento,
            genero
        )
        SELECT
            CASE
                WHEN id_cliente LIKE 'NAS%' THEN SUBSTRING(id_cliente, 4, LEN(id_cliente)) -- Eliminar prefijo 'NAS' si esta presente
                ELSE id_cliente
            END AS id_cliente, 
            CASE
                WHEN fecha_nacimiento > GETDATE() THEN NULL
                ELSE fecha_nacimiento
            END AS fecha_nacimiento, -- Establecer fechas de nacimiento futuras a NULL
            CASE
                WHEN UPPER(TRIM(genero)) IN ('F', 'FEMALE') THEN 'Femenino'
                WHEN UPPER(TRIM(genero)) IN ('M', 'MALE') THEN 'Masculino'
                ELSE 'n/a'
            END AS genero -- Normalizar valores de genero y manejar casos desconocidos
        FROM bronze.erp_cust_az12;
        SET @end_time = GETDATE();
        PRINT '>> Duracion de la Carga: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';


        -- Cargando silver.erp_loc_a101
        SET @start_time = GETDATE();
        PRINT '>> Truncando Tabla: silver.erp_loc_a101';
        TRUNCATE TABLE silver.erp_loc_a101;
        PRINT '>> Insertando Datos En: silver.erp_loc_a101';
        INSERT INTO silver.erp_loc_a101 (
            id_cliente,
            departamento
        )
        SELECT
            REPLACE(id_cliente, '-', '') AS id_cliente, 
            CASE
            
                WHEN TRIM(departamento) = '' OR departamento IS NULL THEN 'n/a'
                ELSE TRIM(departamento)
            END AS departamento
        FROM bronze.erp_loc_a101;
        SET @end_time = GETDATE();
        PRINT '>> Duracion de la Carga: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';
        
        -- Cargando silver.erp_px_cat_g1v2
        SET @start_time = GETDATE();
        PRINT '>> Truncando Tabla: silver.erp_px_cat_g1v2';
        TRUNCATE TABLE silver.erp_px_cat_g1v2;
        PRINT '>> Insertando Datos En: silver.erp_px_cat_g1v2';
        INSERT INTO silver.erp_px_cat_g1v2 (
            id_categoria,
            categoria,
            subcategoria,
            mantenimiento
        )
        SELECT
            id_categoria,
            categoria,
            subcategoria,
            CASE 
                WHEN UPPER(TRIM(mantenimiento)) = 'YES' THEN 'Si'
                WHEN UPPER(TRIM(mantenimiento)) = 'NO' THEN 'No'
                ELSE mantenimiento
            END AS mantenimiento -- Estandarizar valores de mantenimiento
        FROM bronze.erp_px_cat_g1v2;
        SET @end_time = GETDATE();
        PRINT '>> Duracion de la Carga: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        SET @batch_end_time = GETDATE();
        PRINT '=========================================='
        PRINT 'Carga de la Capa Silver Completada';
        PRINT '   - Duracion Total de la Carga: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' segundos';
        PRINT '=========================================='
        
    END TRY
    BEGIN CATCH
        PRINT '=========================================='
        PRINT 'OCURRIO UN ERROR DURANTE LA CARGA DE LA CAPA SILVER'
        PRINT 'Mensaje de Error: ' + ERROR_MESSAGE();
        PRINT 'Numero de Error: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Estado de Error: ' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================='
    END CATCH
END
