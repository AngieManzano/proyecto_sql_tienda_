

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Cargando la Capa Bronze';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Cargando Tablas CRM';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncando Tabla: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT '>> Insertando Datos En: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Repos\BK\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Duracion de la Carga: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncando Tabla: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT '>> Insertando Datos En: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Repos\BK\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Duracion de la Carga: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncando Tabla: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT '>> Insertando Datos En: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Repos\BK\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Duracion de la Carga: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        PRINT '------------------------------------------------';
        PRINT 'Cargando Tablas ERP';
        PRINT '------------------------------------------------';
        
        SET @start_time = GETDATE();
        PRINT '>> Truncando Tabla: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT '>> Insertando Datos En: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Repos\BK\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Duracion de la Carga: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncando Tabla: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT '>> Insertando Datos En: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Repos\BK\datasets\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Duracion de la Carga: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncando Tabla: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT '>> Insertando Datos En: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Repos\BK\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Duracion de la Carga: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        SET @batch_end_time = GETDATE();
        PRINT '=========================================='
        PRINT 'Carga de la Capa Bronze Completada';
        PRINT '   - Duracion Total de la Carga: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' segundos';
        PRINT '=========================================='
    END TRY
    BEGIN CATCH
        PRINT '=========================================='
        PRINT 'OCURRIO UN ERROR DURANTE LA CARGA DE LA CAPA BRONZE'
        PRINT 'Mensaje de Error: ' + ERROR_MESSAGE();
        PRINT 'Numero de Error: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Estado de Error: ' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================='
    END CATCH
END
