====================================================
Author:        AAVA
Date:          
Description:   Gold Layer Fact Table ETL Transformation Stored Procedures
====================================================

-- =============================================
-- GOLD LAYER FACT TABLE ETL PIPELINE
-- =============================================
-- This script contains T-SQL stored procedures for loading
-- Gold Layer Fact tables from validated Silver Layer data.
-- All procedures implement comprehensive business rules,
-- error handling, audit logging, and performance optimization.
-- =============================================

-- =============================================
-- STORED PROCEDURE: usp_Load_Gold_Fact_Timesheet_Entry
-- PURPOSE: Load daily timesheet entries from Silver to Gold layer
-- GRAIN: One record per Resource per Date per Project Task
-- =============================================

CREATE OR ALTER PROCEDURE GOLD.usp_Load_Gold_Fact_Timesheet_Entry
    @RunId UNIQUEIDENTIFIER = NULL,
    @SourceSystem NVARCHAR(100) = 'Silver.Si_Timesheet_Entry'
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcedureName NVARCHAR(200) = 'usp_Load_Gold_Fact_Timesheet_Entry';
    DECLARE @StartTime DATETIME = GETDATE();
    DECLARE @EndTime DATETIME;
    DECLARE @RecordsRead BIGINT = 0;
    DECLARE @RecordsInserted BIGINT = 0;
    DECLARE @RecordsRejected BIGINT = 0;
    DECLARE @ErrorMessage NVARCHAR(MAX);
    DECLARE @Status NVARCHAR(50) = 'Running';
    DECLARE @AuditID BIGINT;
    
    IF @RunId IS NULL
        SET @RunId = NEWID();
    
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Gold.Go_Process_Audit (
            Pipeline_Name, Pipeline_Run_ID, Source_System, Source_Table, Target_Table,
            Processing_Type, Start_Time, Status, Records_Read, Records_Processed,
            Records_Inserted, Records_Rejected, Executed_By, Environment
        )
        VALUES (
            @ProcedureName, CAST(@RunId AS VARCHAR(100)), @SourceSystem,
            'Silver.Si_Timesheet_Entry', 'Gold.Go_Fact_Timesheet_Entry',
            'Full Load', CAST(@StartTime AS DATE), @Status,
            0, 0, 0, 0, SYSTEM_USER, 'Production'
        );

        SET @AuditID = SCOPE_IDENTITY();

        SELECT 
            Resource_Code,
            Timesheet_Date,
            Project_Task_Reference,
            Standard_Hours,
            Overtime_Hours,
            Double_Time_Hours,
            Sick_Time_Hours,
            Holiday_Hours,
            Time_Off_Hours,
            Non_Standard_Hours,
            Non_Overtime_Hours,
            Non_Double_Time_Hours,
            Non_Sick_Time_Hours,
            Creation_Date,
            Total_Hours,
            Total_Billable_Hours,
            load_timestamp,
            source_system,
            data_quality_score,
            is_validated
        INTO #Silver_Staging
        FROM Silver.si_timesheet_entry
        WHERE is_validated = 1;

        SET @RecordsRead = @@ROWCOUNT;

        SELECT 
            *,
            CASE 
                WHEN Resource_Code IS NULL THEN 'Resource_Code is NULL'
                WHEN NOT EXISTS (SELECT 1 FROM Gold.Go_Dim_Resource r WHERE r.Resource_Code = s.Resource_Code) THEN NULL
                WHEN Timesheet_Date IS NULL THEN 'Timesheet_Date is NULL'
                WHEN NOT EXISTS (SELECT 1 FROM Gold.Go_Dim_Date d WHERE d.Calendar_Date = CAST(s.Timesheet_Date AS DATE)) THEN NULL
                WHEN EXISTS (
                    SELECT 1 FROM Gold.Go_Dim_Resource r 
                    WHERE r.Resource_Code = s.Resource_Code 
                    AND (CAST(s.Timesheet_Date AS DATE) < r.Start_Date 
                      OR (r.Termination_Date IS NOT NULL AND CAST(s.Timesheet_Date AS DATE) > r.Termination_Date))
                ) THEN 'Timesheet_Date outside employment period'
                WHEN ISNULL(Standard_Hours, 0) < 0 THEN 'Standard_Hours is negative'
                WHEN ISNULL(Standard_Hours, 0) > 24 THEN 'Standard_Hours exceeds 24'
                WHEN ISNULL(Overtime_Hours, 0) < 0 THEN 'Overtime_Hours is negative'
                WHEN ISNULL(Overtime_Hours, 0) > 12 THEN 'Overtime_Hours exceeds 12'
                WHEN ISNULL(Double_Time_Hours, 0) < 0 THEN 'Double_Time_Hours is negative'
                WHEN ISNULL(Double_Time_Hours, 0) > 12 THEN 'Double_Time_Hours exceeds 12'
                WHEN ISNULL(Sick_Time_Hours, 0) < 0 THEN 'Sick_Time_Hours is negative'
                WHEN ISNULL(Sick_Time_Hours, 0) > 24 THEN 'Sick_Time_Hours exceeds 24'
                WHEN ISNULL(Holiday_Hours, 0) < 0 THEN 'Holiday_Hours is negative'
                WHEN ISNULL(Holiday_Hours, 0) > 24 THEN 'Holiday_Hours exceeds 24'
                WHEN ISNULL(Time_Off_Hours, 0) < 0 THEN 'Time_Off_Hours is negative'
                WHEN ISNULL(Time_Off_Hours, 0) > 24 THEN 'Time_Off_Hours exceeds 24'
                WHEN Total_Hours < 0 THEN 'Total_Hours is negative'
                WHEN Total_Hours > 24 THEN 'Total_Hours exceeds 24'
                WHEN Total_Billable_Hours < 0 THEN 'Total_Billable_Hours exceeds Total_Hours'
                ELSE NULL
            END AS ValidationError,
            CASE 
                WHEN Resource_Code IS NOT NULL 
                     AND EXISTS (SELECT 1 FROM Gold.Go_Dim_Resource r WHERE r.Resource_Code = s.Resource_Code)
                     AND Timesheet_Date IS NOT NULL
                     AND EXISTS (SELECT 1 FROM Gold.Go_Dim_Date d WHERE d.Calendar_Date = CAST(s.Timesheet_Date AS DATE))
                     AND ISNULL(Standard_Hours, 0) BETWEEN 0 AND 24
                     AND ISNULL(Overtime_Hours, 0) BETWEEN 0 AND 12
                     AND ISNULL(Double_Time_Hours, 0) BETWEEN 0 AND 12
                     AND ISNULL(Sick_Time_Hours, 0) BETWEEN 0 AND 24
                     AND ISNULL(Holiday_Hours, 0) BETWEEN 0 AND 24
                     AND ISNULL(Time_Off_Hours, 0) BETWEEN 0 AND 24
                     AND Total_Hours BETWEEN 0 AND 24
                     AND Total_Billable_Hours BETWEEN 0 AND Total_Hours
                THEN 100.00
                ELSE 50.00
            END AS Calculated_Quality_Score
        INTO #Staging_Validated
        FROM #Silver_Staging s;

        SELECT * INTO #Valid_Records FROM #Staging_Validated WHERE ValidationError IS NULL;
        SELECT * INTO #Invalid_Records FROM #Staging_Validated WHERE ValidationError IS NOT NULL;

        SET @RecordsRejected = (SELECT COUNT(*) FROM #Invalid_Records);

        INSERT INTO Gold.Go_Error_Data (
            Source_Table, Target_Table, Record_Identifier, Error_Type, Error_Category,
            Error_Description, Field_Name, Field_Value, Business_Rule, Severity_Level,
            Error_Date, Batch_ID, Processing_Stage, Resolution_Status, Created_By, Created_Date
        )
        SELECT 
            'Silver.Si_Timesheet_Entry', 'Gold.Go_Fact_Timesheet_Entry',
            'Resource: ' + ISNULL(Resource_Code, 'NULL') + ', Date: ' + ISNULL(CAST(Timesheet_Date AS VARCHAR), 'NULL'),
            'Validation Error', 'Data Quality', ValidationError,
            'Multiple Fields', 'See Error Description',
            'Fact table validation rules',
            'High', CAST(GETDATE() AS DATE), CAST(@RunId AS VARCHAR(100)),
            'Silver to Gold Transformation', 'Open',
            SYSTEM_USER, CAST(GETDATE() AS DATE)
        FROM #Invalid_Records;

        -- FIXED: ORDER BY load_timestamp
        WITH CTE_Dedup AS (
            SELECT *,
                ROW_NUMBER() OVER (
                    PARTITION BY Resource_Code, CAST(Timesheet_Date AS DATE), Project_Task_Reference 
                    ORDER BY load_timestamp DESC
                ) AS RowNum
            FROM #Valid_Records
        )
        SELECT *
        INTO #Final_Valid_Records
        FROM CTE_Dedup
        WHERE RowNum = 1;

        INSERT INTO Gold.Go_Fact_Timesheet_Entry (
            Resource_Code,
            Timesheet_Date,
            Project_Task_Reference,
            Standard_Hours,
            Overtime_Hours,
            Double_Time_Hours,
            Sick_Time_Hours,
            Holiday_Hours,
            Time_Off_Hours,
            Non_Standard_Hours,
            Non_Overtime_Hours,
            Non_Double_Time_Hours,
            Non_Sick_Time_Hours,
            Creation_Date,
            Total_Hours,
            Total_Billable_Hours,
            load_date,
            update_date,
            source_system,
            data_quality_score,
            is_validated
        )
        SELECT 
            Resource_Code,
            CAST(Timesheet_Date AS DATE),
            Project_Task_Reference,
            CAST(Standard_Hours AS FLOAT),
            CAST(Overtime_Hours AS FLOAT),
            CAST(Double_Time_Hours AS FLOAT),
            CAST(Sick_Time_Hours AS FLOAT),
            CAST(Holiday_Hours AS FLOAT),
            CAST(Time_Off_Hours AS FLOAT),
            CAST(Non_Standard_Hours AS FLOAT),
            CAST(Non_Overtime_Hours AS FLOAT),
            CAST(Non_Double_Time_Hours AS FLOAT),
            CAST(Non_Sick_Time_Hours AS FLOAT),
            CAST(Creation_Date AS DATE),
            CAST(Total_Hours AS FLOAT),
            CAST(Total_Billable_Hours AS FLOAT),
            CAST(GETDATE() AS DATE),
            CAST(GETDATE() AS DATE),
            source_system,
            Calculated_Quality_Score,
            1
        FROM #Final_Valid_Records;

        SET @RecordsInserted = @@ROWCOUNT;
        SET @Status = 'Success';
        SET @EndTime = GETDATE();

        UPDATE Gold.Go_Process_Audit
        SET 
            End_Time = CAST(@EndTime AS DATE),
            Duration_Seconds = DATEDIFF(SECOND, @StartTime, @EndTime),
            Status = @Status,
            Records_Read = @RecordsRead,
            Records_Processed = @RecordsRead,
            Records_Inserted = @RecordsInserted,
            Records_Rejected = @RecordsRejected,
            Data_Quality_Score = (SELECT AVG(Calculated_Quality_Score) FROM #Final_Valid_Records),
            Modified_Date = CAST(GETDATE() AS DATE)
        WHERE Audit_ID = @AuditID;

        DROP TABLE IF EXISTS #Silver_Staging;
        DROP TABLE IF EXISTS #Staging_Validated;
        DROP TABLE IF EXISTS #Valid_Records;
        DROP TABLE IF EXISTS #Invalid_Records;
        DROP TABLE IF EXISTS #Final_Valid_Records;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;

        SET @ErrorMessage = ERROR_MESSAGE();
        SET @Status = 'Failed';
        SET @EndTime = GETDATE();

        UPDATE Gold.Go_Process_Audit
        SET 
            End_Time = @EndTime,
            Status = @Status,
            Error_Message = @ErrorMessage,
            Modified_Date = @EndTime
        WHERE Audit_ID = @AuditID;

        THROW;
    END CATCH
END;


EXEC GOLD.usp_Load_Gold_Fact_Timesheet_Entry 

select * from gold.Go_Fact_Timesheet_Entry gfte 


-- =============================================
-- STORED PROCEDURE: usp_Load_Gold_Fact_Timesheet_Approval
-- PURPOSE: Load approved timesheet data from Silver to Gold layer
-- GRAIN: One record per Resource per Date
-- =============================================
CREATE OR ALTER PROCEDURE GOLD.usp_Load_Gold_Fact_Timesheet_Approval
    @RunId UNIQUEIDENTIFIER = NULL,
    @SourceSystem NVARCHAR(100) = 'Silver.Si_Timesheet_Approval'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProcedureName NVARCHAR(200) = 'usp_Load_Gold_Fact_Timesheet_Approval';
    DECLARE @StartTime DATETIME = GETDATE();
    DECLARE @EndTime DATETIME;
    DECLARE @RecordsRead BIGINT = 0;
    DECLARE @RecordsInserted BIGINT = 0;
    DECLARE @RecordsRejected BIGINT = 0;
    DECLARE @ErrorMessage NVARCHAR(MAX);
    DECLARE @Status NVARCHAR(50) = 'Running';
    DECLARE @AuditID BIGINT;

    IF @RunId IS NULL
        SET @RunId = NEWID();

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Gold.Go_Process_Audit (
            Pipeline_Name, Pipeline_Run_ID, Source_System, Source_Table, Target_Table,
            Processing_Type, Start_Time, Status, Records_Read, Records_Processed,
            Records_Inserted, Records_Rejected, Executed_By, Environment
        )
        VALUES (
            @ProcedureName, CAST(@RunId AS VARCHAR(100)), @SourceSystem,
            'Silver.Si_Timesheet_Approval', 'Gold.Go_Fact_Timesheet_Approval',
            'Full Load', CAST(@StartTime AS DATE), @Status,
            0, 0, 0, 0, SYSTEM_USER, 'Production'
        );

        SET @AuditID = SCOPE_IDENTITY();

        -- Load from Silver
        SELECT 
            Resource_Code,
            Timesheet_Date,
            Week_Date,
            Approved_Standard_Hours,
            Approved_Overtime_Hours,
            Approved_Double_Time_Hours,
            Approved_Sick_Time_Hours,
            Billing_Indicator,
            Consultant_Standard_Hours,
            Consultant_Overtime_Hours,
            Consultant_Double_Time_Hours,
            Total_Approved_Hours,
            Hours_Variance,
            source_system,
            data_quality_score,
            approval_status
        INTO #Silver_Staging
        FROM Silver.si_timesheet_approval;

        SET @RecordsRead = @@ROWCOUNT;

        -- Validation
        SELECT *,
            CASE 
                WHEN Resource_Code IS NULL THEN 'Resource_Code is NULL'
                WHEN NOT EXISTS (SELECT 1 FROM Gold.Go_Dim_Resource r WHERE r.Resource_Code = s.Resource_Code) THEN NULL
                WHEN Timesheet_Date IS NULL THEN 'Timesheet_Date is NULL'
                WHEN NOT EXISTS (SELECT 1 FROM Gold.Go_Dim_Date d WHERE d.Calendar_Date = CAST(s.Timesheet_Date AS DATE)) THEN NULL
                WHEN Week_Date IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Gold.Go_Dim_Date d WHERE d.Calendar_Date = CAST(s.Week_Date AS DATE)) THEN 'Week_Date not found in Go_Dim_Date'
                WHEN ISNULL(Approved_Standard_Hours, 0) < 0 THEN 'Approved_Standard_Hours negative'
                WHEN ISNULL(Approved_Overtime_Hours, 0) < 0 THEN 'Approved_Overtime_Hours negative'
                WHEN ISNULL(Approved_Double_Time_Hours, 0) < 0 THEN 'Approved_Double_Time_Hours negative'
                WHEN ISNULL(Approved_Sick_Time_Hours, 0) < 0 THEN 'Approved_Sick_Time_Hours negative'
                ELSE NULL
            END AS ValidationError,
            
            CASE 
                WHEN Resource_Code IS NOT NULL 
                AND EXISTS (SELECT 1 FROM Gold.Go_Dim_Resource r WHERE r.Resource_Code = s.Resource_Code)
                AND Timesheet_Date IS NOT NULL
                AND EXISTS (SELECT 1 FROM Gold.Go_Dim_Date d WHERE d.Calendar_Date = CAST(s.Timesheet_Date AS DATE))
                THEN 100.00
                ELSE 50.00
            END AS Calculated_Quality_Score,

            DATEADD(DAY, (7 - DATEPART(WEEKDAY, Timesheet_Date)) % 7, Timesheet_Date) AS Calculated_Week_Date,

            CASE WHEN Approved_Standard_Hours > Consultant_Standard_Hours 
                THEN Consultant_Standard_Hours 
                ELSE ISNULL(Approved_Standard_Hours, 0) 
            END AS Capped_Approved_Standard_Hours,

            CASE WHEN Approved_Overtime_Hours > Consultant_Overtime_Hours 
                THEN Consultant_Overtime_Hours 
                ELSE ISNULL(Approved_Overtime_Hours, 0) 
            END AS Capped_Approved_Overtime_Hours,

            CASE WHEN Approved_Double_Time_Hours > Consultant_Double_Time_Hours 
                THEN Consultant_Double_Time_Hours 
                ELSE ISNULL(Approved_Double_Time_Hours, 0) 
            END AS Capped_Approved_Double_Time_Hours,

            CASE 
                WHEN UPPER(LTRIM(RTRIM(Billing_Indicator))) IN ('YES','Y','1') THEN 'Yes'
                WHEN UPPER(LTRIM(RTRIM(Billing_Indicator))) IN ('NO','N','0') THEN 'No'
                ELSE 'No'
            END AS Standardized_Billing_Indicator

        INTO #Staging_Validated
        FROM #Silver_Staging s;

        SELECT * INTO #Valid_Records FROM #Staging_Validated WHERE ValidationError IS NULL;
        SELECT * INTO #Invalid_Records FROM #Staging_Validated WHERE ValidationError IS NOT NULL;

        SET @RecordsRejected = (SELECT COUNT(*) FROM #Invalid_Records);

        INSERT INTO Gold.Go_Error_Data (
            Source_Table, Target_Table, Error_Type, Error_Category, Error_Description,
            Error_Date, Batch_ID, Processing_Stage, Resolution_Status, Created_By, Created_Date
        )
        SELECT 
            'Silver.Si_Timesheet_Approval','Gold.Go_Fact_Timesheet_Approval',
            'Validation Error','Data Quality',ValidationError,
            CAST(GETDATE() AS DATE), CAST(@RunId AS VARCHAR(100)),
            'Silver to Gold Transformation','Open',SYSTEM_USER,CAST(GETDATE() AS DATE)
        FROM #Invalid_Records;

        -- Dedup
        WITH CTE_Dedup AS (
            SELECT *, ROW_NUMBER() OVER (
                PARTITION BY Resource_Code, CAST(Timesheet_Date AS DATE)
                ORDER BY Timesheet_Date DESC
            ) AS RowNum
            FROM #Valid_Records
        )
        SELECT *
        INTO #Final_Valid_Records
        FROM CTE_Dedup
        WHERE RowNum = 1;

        -- Insert Final
        INSERT INTO Gold.Go_Fact_Timesheet_Approval (
            Resource_Code, Timesheet_Date, Week_Date,
            Approved_Standard_Hours, Approved_Overtime_Hours, Approved_Double_Time_Hours,
            Approved_Sick_Time_Hours, Billing_Indicator,
            Consultant_Standard_Hours, Consultant_Overtime_Hours, Consultant_Double_Time_Hours,
            Total_Approved_Hours, Hours_Variance,
            load_date, update_date, source_system,
            data_quality_score, approval_status
        )
        SELECT 
            Resource_Code,
            CAST(Timesheet_Date AS DATE),
            CAST(Calculated_Week_Date AS DATE),
            Capped_Approved_Standard_Hours,
            Capped_Approved_Overtime_Hours,
            Capped_Approved_Double_Time_Hours,
            Approved_Sick_Time_Hours,
            Standardized_Billing_Indicator,
            Consultant_Standard_Hours,
            Consultant_Overtime_Hours,
            Consultant_Double_Time_Hours,

            -- FIXED MISSING HOURS ISSUE BELOW 👇
            Capped_Approved_Standard_Hours +
            Capped_Approved_Overtime_Hours +
            Capped_Approved_Double_Time_Hours +
            ISNULL(Approved_Sick_Time_Hours,0),

            (
                Capped_Approved_Standard_Hours +
                Capped_Approved_Overtime_Hours +
                Capped_Approved_Double_Time_Hours +
                ISNULL(Approved_Sick_Time_Hours,0)
            ) -
            (
                Consultant_Standard_Hours +
                Consultant_Overtime_Hours +
                Consultant_Double_Time_Hours
            ),

            CAST(GETDATE() AS DATE),
            CAST(GETDATE() AS DATE),
            source_system,
            Calculated_Quality_Score,
            approval_status
        FROM #Final_Valid_Records;

        SET @RecordsInserted = @@ROWCOUNT;
        SET @Status = 'Success';
        SET @EndTime = GETDATE();

        UPDATE Gold.Go_Process_Audit
        SET End_Time=@EndTime, Status=@Status,
            Records_Read=@RecordsRead,
            Records_Processed=@RecordsRead,
            Records_Inserted=@RecordsInserted,
            Records_Rejected=@RecordsRejected
        WHERE Audit_ID = @AuditID;

        DROP TABLE IF EXISTS #Silver_Staging;
        DROP TABLE IF EXISTS #Staging_Validated;
        DROP TABLE IF EXISTS #Valid_Records;
        DROP TABLE IF EXISTS #Invalid_Records;
        DROP TABLE IF EXISTS #Final_Valid_Records;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        SET @ErrorMessage = ERROR_MESSAGE();
        UPDATE Gold.Go_Process_Audit
        SET Status='Failed', Error_Message=@ErrorMessage
        WHERE Audit_ID=@AuditID;
        THROW;
    END CATCH
END;

-- =============================================
-- END OF GOLD LAYER FACT TABLE ETL PIPELINE
-- =============================================
-- Total Stored Procedures Created: 2
EXEC GOLD.usp_Load_Gold_Fact_Timesheet_Entry 
EXEC GOLD.usp_Load_Gold_Fact_Timesheet_Approval
select * from gold.go_fact_timesheet_approval

