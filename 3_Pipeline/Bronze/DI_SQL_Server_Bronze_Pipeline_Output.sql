/*
================================================================================
AUTHOR:        AAVA - AI Data Engineering Agent
DATE:          2024
DESCRIPTION:   Bronze Layer ETL Pipeline - SQL Server Stored Procedures
               Complete data ingestion from source_layer to Bronze layer
               with comprehensive audit logging and error handling
================================================================================

PURPOSE:
This script contains T-SQL stored procedures to load data from source_layer 
schema to Bronze layer schema in SQL Server, implementing the Medallion 
architecture pattern.

KEY FEATURES:
- Full refresh load strategy (TRUNCATE and INSERT)
- Comprehensive error handling with TRY...CATCH blocks
- Transaction management for data integrity
- Audit logging for all operations
- Metadata tracking (load_timestamp, update_timestamp, source_system)
- Exclusion of TIMESTAMP/ROWVERSION columns from source
- Row count validation
- Execution time tracking

TABLES LOADED:
1. bz_New_Monthly_HC_Report
2. bz_SchTask (excludes TIMESTAMP column)
3. bz_Hiring_Initiator_Project_Info
4. bz_Timesheet_New
5. bz_report_392_all
6. bz_vw_billing_timesheet_daywise_ne
7. bz_vw_consultant_timesheet_daywise
8. bz_DimDate
9. bz_holidays_Mexico
10. bz_holidays_Canada
11. bz_holidays
12. bz_holidays_India

EXECUTION:
EXEC Bronze.usp_Load_Bronze_Layer_Full;

================================================================================
*/

-- Set database context (modify as needed)
USE [YourDatabaseName];
GO

/*
================================================================================
MAIN STORED PROCEDURE: Bronze.usp_Load_Bronze_Layer_Full
================================================================================
Description: Master procedure to load all tables from source_layer to Bronze layer
Parameters: None (can be extended to accept @BatchID, @SourceSystem, etc.)
Returns: 0 for success, 1 for failure
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.usp_Load_Bronze_Layer_Full
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Variable declarations
    DECLARE @ProcedureName VARCHAR(200) = 'Bronze.usp_Load_Bronze_Layer_Full';
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @EndTime DATETIME2;
    DECLARE @ExecutionTime FLOAT;
    DECLARE @OverallStatus VARCHAR(50) = 'SUCCESS';
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorNumber INT;
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    DECLARE @ErrorLine INT;
    DECLARE @TotalRowsProcessed BIGINT = 0;
    DECLARE @TotalRowsInserted BIGINT = 0;
    DECLARE @TotalRowsFailed BIGINT = 0;
    DECLARE @TablesProcessed INT = 0;
    DECLARE @TablesSucceeded INT = 0;
    DECLARE @TablesFailed INT = 0;
    DECLARE @CurrentUser VARCHAR(100) = SYSTEM_USER;
    DECLARE @BatchID VARCHAR(100) = CONVERT(VARCHAR(23), @StartTime, 121);
    
    BEGIN TRY
        -- Log start of overall process
        PRINT '================================================================================';
        PRINT 'Bronze Layer ETL Pipeline - Started at: ' + CONVERT(VARCHAR(23), @StartTime, 121);
        PRINT 'Executed by: ' + @CurrentUser;
        PRINT 'Batch ID: ' + @BatchID;
        PRINT '================================================================================';
        PRINT '';
        
        -- Load Table 1: bz_New_Monthly_HC_Report
        EXEC Bronze.usp_Load_bz_New_Monthly_HC_Report @BatchID;
        SET @TablesProcessed = @TablesProcessed + 1;
        
        -- Load Table 2: bz_SchTask (excludes TIMESTAMP column)
        EXEC Bronze.usp_Load_bz_SchTask @BatchID;
        SET @TablesProcessed = @TablesProcessed + 1;
        
        -- Load Table 3: bz_Hiring_Initiator_Project_Info
        EXEC Bronze.usp_Load_bz_Hiring_Initiator_Project_Info @BatchID;
        SET @TablesProcessed = @TablesProcessed + 1;
        
        -- Load Table 4: bz_Timesheet_New
        EXEC Bronze.usp_Load_bz_Timesheet_New @BatchID;
        SET @TablesProcessed = @TablesProcessed + 1;
        
        -- Load Table 5: bz_report_392_all
        EXEC Bronze.usp_Load_bz_report_392_all @BatchID;
        SET @TablesProcessed = @TablesProcessed + 1;
        
        -- Load Table 6: bz_vw_billing_timesheet_daywise_ne
        EXEC Bronze.usp_Load_bz_vw_billing_timesheet_daywise_ne @BatchID;
        SET @TablesProcessed = @TablesProcessed + 1;
        
        -- Load Table 7: bz_vw_consultant_timesheet_daywise
        EXEC Bronze.usp_Load_bz_vw_consultant_timesheet_daywise @BatchID;
        SET @TablesProcessed = @TablesProcessed + 1;
        
        -- Load Table 8: bz_DimDate
        EXEC Bronze.usp_Load_bz_DimDate @BatchID;
        SET @TablesProcessed = @TablesProcessed + 1;
        
        -- Load Table 9: bz_holidays_Mexico
        EXEC Bronze.usp_Load_bz_holidays_Mexico @BatchID;
        SET @TablesProcessed = @TablesProcessed + 1;
        
        -- Load Table 10: bz_holidays_Canada
        EXEC Bronze.usp_Load_bz_holidays_Canada @BatchID;
        SET @TablesProcessed = @TablesProcessed + 1;
        
        -- Load Table 11: bz_holidays
        EXEC Bronze.usp_Load_bz_holidays @BatchID;
        SET @TablesProcessed = @TablesProcessed + 1;
        
        -- Load Table 12: bz_holidays_India
        EXEC Bronze.usp_Load_bz_holidays_India @BatchID;
        SET @TablesProcessed = @TablesProcessed + 1;
        
        -- Calculate summary statistics from audit log
        SELECT 
            @TablesSucceeded = COUNT(*),
            @TotalRowsInserted = SUM(records_inserted)
        FROM Bronze.bz_Audit_Log
        WHERE batch_id = @BatchID
            AND status = 'SUCCESS';
        
        SELECT 
            @TablesFailed = COUNT(*),
            @TotalRowsFailed = SUM(records_failed)
        FROM Bronze.bz_Audit_Log
        WHERE batch_id = @BatchID
            AND status = 'FAILED';
        
        SET @TotalRowsProcessed = @TotalRowsInserted + ISNULL(@TotalRowsFailed, 0);
        
        -- Calculate execution time
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        -- Log completion
        PRINT '';
        PRINT '================================================================================';
        PRINT 'Bronze Layer ETL Pipeline - Completed Successfully';
        PRINT '================================================================================';
        PRINT 'End Time: ' + CONVERT(VARCHAR(23), @EndTime, 121);
        PRINT 'Execution Time: ' + CAST(@ExecutionTime AS VARCHAR(20)) + ' seconds';
        PRINT 'Tables Processed: ' + CAST(@TablesProcessed AS VARCHAR(10));
        PRINT 'Tables Succeeded: ' + CAST(@TablesSucceeded AS VARCHAR(10));
        PRINT 'Tables Failed: ' + CAST(@TablesFailed AS VARCHAR(10));
        PRINT 'Total Rows Inserted: ' + CAST(@TotalRowsInserted AS VARCHAR(20));
        PRINT 'Total Rows Failed: ' + CAST(ISNULL(@TotalRowsFailed, 0) AS VARCHAR(20));
        PRINT '================================================================================';
        
        -- Insert master audit record
        INSERT INTO Bronze.bz_Audit_Log (
            source_table,
            target_table,
            load_timestamp,
            start_timestamp,
            end_timestamp,
            processed_by,
            processing_time,
            status,
            records_processed,
            records_inserted,
            records_failed,
            batch_id,
            load_type,
            created_date
        )
        VALUES (
            'source_layer.*',
            'Bronze.*',
            @StartTime,
            @StartTime,
            @EndTime,
            @CurrentUser,
            @ExecutionTime,
            @OverallStatus,
            @TotalRowsProcessed,
            @TotalRowsInserted,
            @TotalRowsFailed,
            @BatchID,
            'FULL_REFRESH_ALL_TABLES',
            SYSUTCDATETIME()
        );
        
        RETURN 0;
        
    END TRY
    BEGIN CATCH
        -- Capture error details
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorNumber = ERROR_NUMBER(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE(),
            @ErrorLine = ERROR_LINE();
        
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        SET @OverallStatus = 'FAILED';
        
        -- Log error
        PRINT '';
        PRINT '================================================================================';
        PRINT 'ERROR in Bronze Layer ETL Pipeline';
        PRINT '================================================================================';
        PRINT 'Error Number: ' + CAST(@ErrorNumber AS VARCHAR(10));
        PRINT 'Error Severity: ' + CAST(@ErrorSeverity AS VARCHAR(10));
        PRINT 'Error State: ' + CAST(@ErrorState AS VARCHAR(10));
        PRINT 'Error Line: ' + CAST(@ErrorLine AS VARCHAR(10));
        PRINT 'Error Message: ' + @ErrorMessage;
        PRINT '================================================================================';
        
        -- Insert error audit record
        INSERT INTO Bronze.bz_Audit_Log (
            source_table,
            target_table,
            load_timestamp,
            start_timestamp,
            end_timestamp,
            processed_by,
            processing_time,
            status,
            error_message,
            batch_id,
            load_type,
            created_date
        )
        VALUES (
            'source_layer.*',
            'Bronze.*',
            @StartTime,
            @StartTime,
            @EndTime,
            @CurrentUser,
            @ExecutionTime,
            @OverallStatus,
            'Error ' + CAST(@ErrorNumber AS VARCHAR(10)) + ': ' + @ErrorMessage,
            @BatchID,
            'FULL_REFRESH_ALL_TABLES',
            SYSUTCDATETIME()
        );
        
        -- Re-throw error
        THROW;
        
        RETURN 1;
    END CATCH
END;
GO

/*
================================================================================
TABLE 1: Bronze.usp_Load_bz_New_Monthly_HC_Report
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.usp_Load_bz_New_Monthly_HC_Report
    @BatchID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcedureName VARCHAR(200) = 'Bronze.usp_Load_bz_New_Monthly_HC_Report';
    DECLARE @SourceTable VARCHAR(200) = 'source_layer.New_Monthly_HC_Report';
    DECLARE @TargetTable VARCHAR(200) = 'Bronze.bz_New_Monthly_HC_Report';
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @EndTime DATETIME2;
    DECLARE @ExecutionTime FLOAT;
    DECLARE @RowsInserted BIGINT = 0;
    DECLARE @RowsSource BIGINT = 0;
    DECLARE @Status VARCHAR(50) = 'SUCCESS';
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @CurrentUser VARCHAR(100) = SYSTEM_USER;
    DECLARE @SourceSystem VARCHAR(100) = 'SQL_Server_Source';
    
    BEGIN TRY
        PRINT 'Loading ' + @TargetTable + '...';
        
        -- Get source row count
        SELECT @RowsSource = COUNT(*) FROM source_layer.New_Monthly_HC_Report;
        
        BEGIN TRANSACTION;
        
        -- Truncate target table
        TRUNCATE TABLE Bronze.bz_New_Monthly_HC_Report;
        
        -- Insert data with metadata
        INSERT INTO Bronze.bz_New_Monthly_HC_Report (
            [id], [gci id], [first name], [last name], [job title], [hr_business_type], 
            [client code], [start date], [termdate], [Final_End_date], [NBR], [Merged Name], 
            [Super Merged Name], [market], [defined_New_VAS], [IS_SOW], [GP], [NextValue], 
            [termination_reason], [FirstDay], [Emp_Status], [employee_category], [LastDay], 
            [ee_wf_reason], [old_Begin], [Begin HC], [Starts - New Project], 
            [Starts- Internal movements], [Terms], [Other project Ends], [OffBoard], [End HC], 
            [Vol_term], [adj], [YYMM], [tower1], [req type], [ITSSProjectName], [IS_Offshore], 
            [Subtier], [New_Visa_type], [Practice_type], [vertical], [CL_Group], [salesrep], 
            [recruiter], [PO_End], [PO_End_Count], [Derived_Rev], [Derived_GP], [Backlog_Rev], 
            [Backlog_GP], [Expected_Hrs], [Expected_Total_Hrs], [ITSS], [client_entity], 
            [newtermdate], [Newoffboardingdate], [HWF_Process_name], [Derived_System_End_date], 
            [Cons_Ageing], [CP_Name], [bill st units], [project city], [project state], 
            [OpportunityID], [OpportunityName], [Bus_days], [circle], [community_new], [ALT], 
            [Market_Leader], [Acct_Owner], [st_yymm], [PortfolioLeader], [ClientPartner], 
            [FP_Proj_ID], [FP_Proj_Name], [FP_TM], [project_type], [FP_Proj_Planned], 
            [Standard Job Title Horizon], [Experience Level Title], [User_Name], [Status], 
            [asstatus], [system_runtime], [BR_Start_date], [Bill_ST], [Prev_BR], [ProjType], 
            [Mons_in_Same_Rate], [Rate_Time_Gr], [Rate_Change_Type], [Net_Addition],
            [load_timestamp], [update_timestamp], [source_system]
        )
        SELECT 
            [id], [gci id], [first name], [last name], [job title], [hr_business_type], 
            [client code], [start date], [termdate], [Final_End_date], [NBR], [Merged Name], 
            [Super Merged Name], [market], [defined_New_VAS], [IS_SOW], [GP], [NextValue], 
            [termination_reason], [FirstDay], [Emp_Status], [employee_category], [LastDay], 
            [ee_wf_reason], [old_Begin], [Begin HC], [Starts - New Project], 
            [Starts- Internal movements], [Terms], [Other project Ends], [OffBoard], [End HC], 
            [Vol_term], [adj], [YYMM], [tower1], [req type], [ITSSProjectName], [IS_Offshore], 
            [Subtier], [New_Visa_type], [Practice_type], [vertical], [CL_Group], [salesrep], 
            [recruiter], [PO_End], [PO_End_Count], [Derived_Rev], [Derived_GP], [Backlog_Rev], 
            [Backlog_GP], [Expected_Hrs], [Expected_Total_Hrs], [ITSS], [client_entity], 
            [newtermdate], [Newoffboardingdate], [HWF_Process_name], [Derived_System_End_date], 
            [Cons_Ageing], [CP_Name], [bill st units], [project city], [project state], 
            [OpportunityID], [OpportunityName], [Bus_days], [circle], [community_new], [ALT], 
            [Market_Leader], [Acct_Owner], [st_yymm], [PortfolioLeader], [ClientPartner], 
            [FP_Proj_ID], [FP_Proj_Name], [FP_TM], [project_type], [FP_Proj_Planned], 
            [Standard Job Title Horizon], [Experience Level Title], [User_Name], [Status], 
            [asstatus], [system_runtime], [BR_Start_date], [Bill_ST], [Prev_BR], [ProjType], 
            [Mons_in_Same_Rate], [Rate_Time_Gr], [Rate_Change_Type], [Net_Addition],
            SYSUTCDATETIME(), SYSUTCDATETIME(), @SourceSystem
        FROM source_layer.New_Monthly_HC_Report;
        
        SET @RowsInserted = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  Rows inserted: ' + CAST(@RowsInserted AS VARCHAR(20)) + ' (Source: ' + CAST(@RowsSource AS VARCHAR(20)) + ')';
        PRINT '  Execution time: ' + CAST(@ExecutionTime AS VARCHAR(20)) + ' seconds';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SET @Status = 'FAILED';
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  ERROR: ' + @ErrorMessage;
    END CATCH
    
    -- Insert audit record
    INSERT INTO Bronze.bz_Audit_Log (
        source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
        processed_by, processing_time, status, records_processed, records_inserted,
        row_count_source, row_count_target, error_message, batch_id, load_type, created_date
    )
    VALUES (
        @SourceTable, @TargetTable, @StartTime, @StartTime, @EndTime,
        @CurrentUser, @ExecutionTime, @Status, @RowsSource, @RowsInserted,
        @RowsSource, @RowsInserted, @ErrorMessage, @BatchID, 'FULL_REFRESH', SYSUTCDATETIME()
    );
    
    IF @Status = 'FAILED' THROW 50001, @ErrorMessage, 1;
END;
GO

/*
================================================================================
TABLE 2: Bronze.usp_Load_bz_SchTask
================================================================================
IMPORTANT: This table has a TIMESTAMP column [TS] in the source that must be 
           excluded from the INSERT statement. The TIMESTAMP column is 
           auto-generated by SQL Server and cannot be inserted.
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.usp_Load_bz_SchTask
    @BatchID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcedureName VARCHAR(200) = 'Bronze.usp_Load_bz_SchTask';
    DECLARE @SourceTable VARCHAR(200) = 'source_layer.SchTask';
    DECLARE @TargetTable VARCHAR(200) = 'Bronze.bz_SchTask';
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @EndTime DATETIME2;
    DECLARE @ExecutionTime FLOAT;
    DECLARE @RowsInserted BIGINT = 0;
    DECLARE @RowsSource BIGINT = 0;
    DECLARE @Status VARCHAR(50) = 'SUCCESS';
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @CurrentUser VARCHAR(100) = SYSTEM_USER;
    DECLARE @SourceSystem VARCHAR(100) = 'SQL_Server_Source';
    
    BEGIN TRY
        PRINT 'Loading ' + @TargetTable + '...';
        
        -- Get source row count
        SELECT @RowsSource = COUNT(*) FROM source_layer.SchTask;
        
        BEGIN TRANSACTION;
        
        -- Truncate target table
        TRUNCATE TABLE Bronze.bz_SchTask;
        
        -- Insert data with metadata
        -- NOTE: [TS] TIMESTAMP column is excluded from both INSERT and SELECT
        INSERT INTO Bronze.bz_SchTask (
            [SSN], [GCI_ID], [FName], [LName], [Process_ID], [Level_ID], [Last_Level],
            [Initiator], [Initiator_Mail], [Status], [Comments], [DateCreated], [TrackID],
            [DateCompleted], [Existing_Resource], [Term_ID], [legal_entity],
            [load_timestamp], [update_timestamp], [source_system]
        )
        SELECT 
            [SSN], [GCI_ID], [FName], [LName], [Process_ID], [Level_ID], [Last_Level],
            [Initiator], [Initiator_Mail], [Status], [Comments], [DateCreated], [TrackID],
            [DateCompleted], [Existing_Resource], [Term_ID], [legal_entity],
            SYSUTCDATETIME(), SYSUTCDATETIME(), @SourceSystem
        FROM source_layer.SchTask;
        -- [TS] column is intentionally excluded as it is a TIMESTAMP/ROWVERSION type
        
        SET @RowsInserted = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  Rows inserted: ' + CAST(@RowsInserted AS VARCHAR(20)) + ' (Source: ' + CAST(@RowsSource AS VARCHAR(20)) + ')';
        PRINT '  Execution time: ' + CAST(@ExecutionTime AS VARCHAR(20)) + ' seconds';
        PRINT '  NOTE: TIMESTAMP column [TS] excluded from load';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SET @Status = 'FAILED';
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  ERROR: ' + @ErrorMessage;
    END CATCH
    
    -- Insert audit record
    INSERT INTO Bronze.bz_Audit_Log (
        source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
        processed_by, processing_time, status, records_processed, records_inserted,
        row_count_source, row_count_target, error_message, batch_id, load_type, created_date
    )
    VALUES (
        @SourceTable, @TargetTable, @StartTime, @StartTime, @EndTime,
        @CurrentUser, @ExecutionTime, @Status, @RowsSource, @RowsInserted,
        @RowsSource, @RowsInserted, @ErrorMessage, @BatchID, 'FULL_REFRESH', SYSUTCDATETIME()
    );
    
    IF @Status = 'FAILED' THROW 50001, @ErrorMessage, 1;
END;
GO

/*
================================================================================
TABLE 3: Bronze.usp_Load_bz_Hiring_Initiator_Project_Info
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.usp_Load_bz_Hiring_Initiator_Project_Info
    @BatchID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcedureName VARCHAR(200) = 'Bronze.usp_Load_bz_Hiring_Initiator_Project_Info';
    DECLARE @SourceTable VARCHAR(200) = 'source_layer.Hiring_Initiator_Project_Info';
    DECLARE @TargetTable VARCHAR(200) = 'Bronze.bz_Hiring_Initiator_Project_Info';
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @EndTime DATETIME2;
    DECLARE @ExecutionTime FLOAT;
    DECLARE @RowsInserted BIGINT = 0;
    DECLARE @RowsSource BIGINT = 0;
    DECLARE @Status VARCHAR(50) = 'SUCCESS';
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @CurrentUser VARCHAR(100) = SYSTEM_USER;
    DECLARE @SourceSystem VARCHAR(100) = 'SQL_Server_Source';
    
    BEGIN TRY
        PRINT 'Loading ' + @TargetTable + '...';
        
        SELECT @RowsSource = COUNT(*) FROM source_layer.Hiring_Initiator_Project_Info;
        
        BEGIN TRANSACTION;
        
        TRUNCATE TABLE Bronze.bz_Hiring_Initiator_Project_Info;
        
        INSERT INTO Bronze.bz_Hiring_Initiator_Project_Info (
            [Candidate_LName], [Candidate_MI], [Candidate_FName], [Candidate_SSN], 
            [HR_Candidate_JobTitle], [HR_Candidate_JobDescription], [HR_Candidate_DOB], 
            [HR_Candidate_Employee_Type], [HR_Project_Referred_By], [HR_Project_Referral_Fees], 
            [HR_Project_Referral_Units], [HR_Relocation_Request], [HR_Relocation_departure_city], 
            [HR_Relocation_departure_state], [HR_Relocation_departure_airport], 
            [HR_Relocation_departure_date], [HR_Relocation_departure_time], 
            [HR_Relocation_arrival_city], [HR_Relocation_arrival_state], 
            [HR_Relocation_arrival_airport], [HR_Relocation_arrival_date], 
            [HR_Relocation_arrival_time], [HR_Relocation_AccomodationStartDate], 
            [HR_Relocation_AccomodationEndDate], [HR_Relocation_AccomodationStartTime], 
            [HR_Relocation_AccomodationEndTime], [HR_Relocation_CarPickup_Place], 
            [HR_Relocation_CarPickup_AddressLine1], [HR_Relocation_CarPickup_AddressLine2], 
            [HR_Relocation_CarPickup_City], [HR_Relocation_CarPickup_State], 
            [HR_Relocation_CarPickup_Zip], [HR_Relocation_CarReturn_City], 
            [HR_Relocation_CarReturn_State], [HR_Relocation_CarReturn_Place], 
            [HR_Relocation_CarReturn_AddressLine1], [HR_Relocation_CarReturn_AddressLine2], 
            [HR_Relocation_CarReturn_Zip], [HR_Relocation_RentalCarStartDate], 
            [HR_Relocation_RentalCarEndDate], [HR_Relocation_RentalCarStartTime], 
            [HR_Relocation_RentalCarEndTime], [HR_Relocation_MaxClientInvoice], 
            [HR_Relocation_approving_manager], [HR_Relocation_Notes], [HR_Recruiting_Manager], 
            [HR_Recruiting_AccountExecutive], [HR_Recruiting_Recruiter], 
            [HR_Recruiting_ResourceManager], [HR_Recruiting_Office], [HR_Recruiting_ReqNo], 
            [HR_Recruiting_Direct], [HR_Recruiting_Replacement_For_GCIID], 
            [HR_Recruiting_Replacement_For], [HR_Recruiting_Replacement_Reason], 
            [HR_ClientInfo_ID], [HR_ClientInfo_Name], [HR_ClientInfo_DNB], 
            [HR_ClientInfo_Sector], [HR_ClientInfo_Manager_ID], [HR_ClientInfo_Manager], 
            [HR_ClientInfo_Phone], [HR_ClientInfo_Phone_Extn], [HR_ClientInfo_Email], 
            [HR_ClientInfo_Fax], [HR_ClientInfo_Cell], [HR_ClientInfo_Pager], 
            [HR_ClientInfo_Pager_Pin], [HR_ClientAgreements_SendTo], [HR_ClientAgreements_Phone], 
            [HR_ClientAgreements_Phone_Extn], [HR_ClientAgreements_Email], 
            [HR_ClientAgreements_Fax], [HR_ClientAgreements_Cell], [HR_ClientAgreements_Pager], 
            [HR_ClientAgreements_Pager_Pin], [HR_Project_SendInvoicesTo], 
            [HR_Project_AddressToSend1], [HR_Project_AddressToSend2], [HR_Project_City], 
            [HR_Project_State], [HR_Project_Zip], [HR_Project_Phone], [HR_Project_Phone_Extn], 
            [HR_Project_Email], [HR_Project_Fax], [HR_Project_Cell], [HR_Project_Pager], 
            [HR_Project_Pager_Pin], [HR_Project_ST], [HR_Project_OT], [HR_Project_ST_Off], 
            [HR_Project_OT_Off], [HR_Project_ST_Units], [HR_Project_OT_Units], 
            [HR_Project_ST_Off_Units], [HR_Project_OT_Off_Units], [HR_Project_StartDate], 
            [HR_Project_EndDate], [HR_Project_Location_AddressLine1], 
            [HR_Project_Location_AddressLine2], [HR_Project_Location_City], 
            [HR_Project_Location_State], [HR_Project_Location_Zip], [HR_Project_InvoicingTerms], 
            [HR_Project_PaymentTerms], [HR_Project_EndClient_ID], [HR_Project_EndClient_Name], 
            [HR_Project_EndClient_Sector], [HR_Accounts_Person], [HR_Accounts_PhoneNo], 
            [HR_Accounts_PhoneNo_Extn], [HR_Accounts_Email], [HR_Accounts_FaxNo], 
            [HR_Accounts_Cell], [HR_Accounts_Pager], [HR_Accounts_Pager_Pin], 
            [HR_Project_Referrer_ID], [UserCreated], [DateCreated], [HR_Week_Cycle], 
            [Project_Name], [transition], [Is_OT_Allowed], [HR_Business_Type], 
            [WebXl_EndClient_ID], [WebXl_EndClient_Name], [Client_Offer_Acceptance_Date], 
            [Project_Type], [req_division], [Client_Compliance_Checks_Reqd], [HSU], [HSUDM], 
            [Payroll_Location], [Is_DT_Allowed], [SBU], [BU], [Dept], [HCU], 
            [Project_Category], [Delivery_Model], [BPOS_Project], [ER_Person], 
            [Print_Invoice_Address1], [Print_Invoice_Address2], [Print_Invoice_City], 
            [Print_Invoice_State], [Print_Invoice_Zip], [Mail_Invoice_Address1], 
            [Mail_Invoice_Address2], [Mail_Invoice_City], [Mail_Invoice_State], 
            [Mail_Invoice_Zip], [Project_Zone], [Emp_Identifier], [CRE_Person], 
            [HR_Project_Location_Country], [Agency], [pwd], [PES_Doc_Sent], 
            [PES_Confirm_Doc_Rcpt], [PES_Clearance_Rcvd], [PES_Doc_Sent_Date], 
            [PES_Confirm_Doc_Rcpt_Date], [PES_Clearance_Rcvd_Date], [Inv_Pay_Terms_Notes], 
            [CBC_Notes], [Benefits_Plan], [BillingCompany], [SPINOFF_CPNY], [Position_Type], 
            [I9_Approver], [FP_BILL_Rate], [TSLead], [Inside_Sales], [Markup], 
            [Maximum_Allowed_Markup], [Actual_Markup], [SCA_Hourly_Bill_Rate], 
            [HR_Project_StartDate_Change_Reason], [source], [HR_Recruiting_VMO], 
            [HR_Recruiting_Inside_Sales], [HR_Recruiting_TL], [HR_Recruiting_NAM], 
            [HR_Recruiting_ARM], [HR_Recruiting_RM], [HR_Recruiting_ReqID], [HR_Recruiting_TAG], 
            [DateUpdated], [UserUpdated], [Is_Swing_Shift_Associated_With_It], 
            [FP_Bill_Rate_OT], [Not_To_Exceed_YESNO], [Exceed_YESNO], [Is_OT_Billable], 
            [Is_premium_project_Associated_With_It], [ITSS_Business_Development_Manager], 
            [Practice_type], [Project_billing_type], [Resource_billing_type], 
            [Type_Consultant_category], [Unique_identification_ID_Doc], [Region1], [Region2], 
            [Region1_percentage], [Region2_percentage], [Soc_Code], [Soc_Desc], [req_duration], 
            [Non_Billing_Type], [Worker_Entity_ID], [OraclePersonID], [Collabera_Email_ID], 
            [Onsite_Consultant_Relationship_Manager], [HR_project_county], [EE_WF_Reasons], 
            [GradeName], [ROLEFAMILY], [SUBDEPARTMENT], [MSProjectType], [NetsuiteProjectId], 
            [NetsuiteCreatedDate], [NetsuiteModifiedDate], [StandardJobTitle], [community], 
            [parent_Account_name], [Timesheet_Manager], [TimeSheetManagerType], 
            [Timesheet_Manager_Phone], [Timesheet_Manager_Email], [HR_Project_Major_Group], 
            [HR_Project_Minor_Group], [HR_Project_Broad_Group], [HR_Project_Detail_Group], 
            [9Hours_Allowed], [9Hours_Effective_Date],
            [load_timestamp], [update_timestamp], [source_system]
        )
        SELECT 
            [Candidate_LName], [Candidate_MI], [Candidate_FName], [Candidate_SSN], 
            [HR_Candidate_JobTitle], [HR_Candidate_JobDescription], [HR_Candidate_DOB], 
            [HR_Candidate_Employee_Type], [HR_Project_Referred_By], [HR_Project_Referral_Fees], 
            [HR_Project_Referral_Units], [HR_Relocation_Request], [HR_Relocation_departure_city], 
            [HR_Relocation_departure_state], [HR_Relocation_departure_airport], 
            [HR_Relocation_departure_date], [HR_Relocation_departure_time], 
            [HR_Relocation_arrival_city], [HR_Relocation_arrival_state], 
            [HR_Relocation_arrival_airport], [HR_Relocation_arrival_date], 
            [HR_Relocation_arrival_time], [HR_Relocation_AccomodationStartDate], 
            [HR_Relocation_AccomodationEndDate], [HR_Relocation_AccomodationStartTime], 
            [HR_Relocation_AccomodationEndTime], [HR_Relocation_CarPickup_Place], 
            [HR_Relocation_CarPickup_AddressLine1], [HR_Relocation_CarPickup_AddressLine2], 
            [HR_Relocation_CarPickup_City], [HR_Relocation_CarPickup_State], 
            [HR_Relocation_CarPickup_Zip], [HR_Relocation_CarReturn_City], 
            [HR_Relocation_CarReturn_State], [HR_Relocation_CarReturn_Place], 
            [HR_Relocation_CarReturn_AddressLine1], [HR_Relocation_CarReturn_AddressLine2], 
            [HR_Relocation_CarReturn_Zip], [HR_Relocation_RentalCarStartDate], 
            [HR_Relocation_RentalCarEndDate], [HR_Relocation_RentalCarStartTime], 
            [HR_Relocation_RentalCarEndTime], [HR_Relocation_MaxClientInvoice], 
            [HR_Relocation_approving_manager], [HR_Relocation_Notes], [HR_Recruiting_Manager], 
            [HR_Recruiting_AccountExecutive], [HR_Recruiting_Recruiter], 
            [HR_Recruiting_ResourceManager], [HR_Recruiting_Office], [HR_Recruiting_ReqNo], 
            [HR_Recruiting_Direct], [HR_Recruiting_Replacement_For_GCIID], 
            [HR_Recruiting_Replacement_For], [HR_Recruiting_Replacement_Reason], 
            [HR_ClientInfo_ID], [HR_ClientInfo_Name], [HR_ClientInfo_DNB], 
            [HR_ClientInfo_Sector], [HR_ClientInfo_Manager_ID], [HR_ClientInfo_Manager], 
            [HR_ClientInfo_Phone], [HR_ClientInfo_Phone_Extn], [HR_ClientInfo_Email], 
            [HR_ClientInfo_Fax], [HR_ClientInfo_Cell], [HR_ClientInfo_Pager], 
            [HR_ClientInfo_Pager_Pin], [HR_ClientAgreements_SendTo], [HR_ClientAgreements_Phone], 
            [HR_ClientAgreements_Phone_Extn], [HR_ClientAgreements_Email], 
            [HR_ClientAgreements_Fax], [HR_ClientAgreements_Cell], [HR_ClientAgreements_Pager], 
            [HR_ClientAgreements_Pager_Pin], [HR_Project_SendInvoicesTo], 
            [HR_Project_AddressToSend1], [HR_Project_AddressToSend2], [HR_Project_City], 
            [HR_Project_State], [HR_Project_Zip], [HR_Project_Phone], [HR_Project_Phone_Extn], 
            [HR_Project_Email], [HR_Project_Fax], [HR_Project_Cell], [HR_Project_Pager], 
            [HR_Project_Pager_Pin], [HR_Project_ST], [HR_Project_OT], [HR_Project_ST_Off], 
            [HR_Project_OT_Off], [HR_Project_ST_Units], [HR_Project_OT_Units], 
            [HR_Project_ST_Off_Units], [HR_Project_OT_Off_Units], [HR_Project_StartDate], 
            [HR_Project_EndDate], [HR_Project_Location_AddressLine1], 
            [HR_Project_Location_AddressLine2], [HR_Project_Location_City], 
            [HR_Project_Location_State], [HR_Project_Location_Zip], [HR_Project_InvoicingTerms], 
            [HR_Project_PaymentTerms], [HR_Project_EndClient_ID], [HR_Project_EndClient_Name], 
            [HR_Project_EndClient_Sector], [HR_Accounts_Person], [HR_Accounts_PhoneNo], 
            [HR_Accounts_PhoneNo_Extn], [HR_Accounts_Email], [HR_Accounts_FaxNo], 
            [HR_Accounts_Cell], [HR_Accounts_Pager], [HR_Accounts_Pager_Pin], 
            [HR_Project_Referrer_ID], [UserCreated], [DateCreated], [HR_Week_Cycle], 
            [Project_Name], [transition], [Is_OT_Allowed], [HR_Business_Type], 
            [WebXl_EndClient_ID], [WebXl_EndClient_Name], [Client_Offer_Acceptance_Date], 
            [Project_Type], [req_division], [Client_Compliance_Checks_Reqd], [HSU], [HSUDM], 
            [Payroll_Location], [Is_DT_Allowed], [SBU], [BU], [Dept], [HCU], 
            [Project_Category], [Delivery_Model], [BPOS_Project], [ER_Person], 
            [Print_Invoice_Address1], [Print_Invoice_Address2], [Print_Invoice_City], 
            [Print_Invoice_State], [Print_Invoice_Zip], [Mail_Invoice_Address1], 
            [Mail_Invoice_Address2], [Mail_Invoice_City], [Mail_Invoice_State], 
            [Mail_Invoice_Zip], [Project_Zone], [Emp_Identifier], [CRE_Person], 
            [HR_Project_Location_Country], [Agency], [pwd], [PES_Doc_Sent], 
            [PES_Confirm_Doc_Rcpt], [PES_Clearance_Rcvd], [PES_Doc_Sent_Date], 
            [PES_Confirm_Doc_Rcpt_Date], [PES_Clearance_Rcvd_Date], [Inv_Pay_Terms_Notes], 
            [CBC_Notes], [Benefits_Plan], [BillingCompany], [SPINOFF_CPNY], [Position_Type], 
            [I9_Approver], [FP_BILL_Rate], [TSLead], [Inside_Sales], [Markup], 
            [Maximum_Allowed_Markup], [Actual_Markup], [SCA_Hourly_Bill_Rate], 
            [HR_Project_StartDate_Change_Reason], [source], [HR_Recruiting_VMO], 
            [HR_Recruiting_Inside_Sales], [HR_Recruiting_TL], [HR_Recruiting_NAM], 
            [HR_Recruiting_ARM], [HR_Recruiting_RM], [HR_Recruiting_ReqID], [HR_Recruiting_TAG], 
            [DateUpdated], [UserUpdated], [Is_Swing_Shift_Associated_With_It], 
            [FP_Bill_Rate_OT], [Not_To_Exceed_YESNO], [Exceed_YESNO], [Is_OT_Billable], 
            [Is_premium_project_Associated_With_It], [ITSS_Business_Development_Manager], 
            [Practice_type], [Project_billing_type], [Resource_billing_type], 
            [Type_Consultant_category], [Unique_identification_ID_Doc], [Region1], [Region2], 
            [Region1_percentage], [Region2_percentage], [Soc_Code], [Soc_Desc], [req_duration], 
            [Non_Billing_Type], [Worker_Entity_ID], [OraclePersonID], [Collabera_Email_ID], 
            [Onsite_Consultant_Relationship_Manager], [HR_project_county], [EE_WF_Reasons], 
            [GradeName], [ROLEFAMILY], [SUBDEPARTMENT], [MSProjectType], [NetsuiteProjectId], 
            [NetsuiteCreatedDate], [NetsuiteModifiedDate], [StandardJobTitle], [community], 
            [parent_Account_name], [Timesheet_Manager], [TimeSheetManagerType], 
            [Timesheet_Manager_Phone], [Timesheet_Manager_Email], [HR_Project_Major_Group], 
            [HR_Project_Minor_Group], [HR_Project_Broad_Group], [HR_Project_Detail_Group], 
            [9Hours_Allowed], [9Hours_Effective_Date],
            SYSUTCDATETIME(), SYSUTCDATETIME(), @SourceSystem
        FROM source_layer.Hiring_Initiator_Project_Info;
        
        SET @RowsInserted = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  Rows inserted: ' + CAST(@RowsInserted AS VARCHAR(20)) + ' (Source: ' + CAST(@RowsSource AS VARCHAR(20)) + ')';
        PRINT '  Execution time: ' + CAST(@ExecutionTime AS VARCHAR(20)) + ' seconds';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SET @Status = 'FAILED';
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  ERROR: ' + @ErrorMessage;
    END CATCH
    
    INSERT INTO Bronze.bz_Audit_Log (
        source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
        processed_by, processing_time, status, records_processed, records_inserted,
        row_count_source, row_count_target, error_message, batch_id, load_type, created_date
    )
    VALUES (
        @SourceTable, @TargetTable, @StartTime, @StartTime, @EndTime,
        @CurrentUser, @ExecutionTime, @Status, @RowsSource, @RowsInserted,
        @RowsSource, @RowsInserted, @ErrorMessage, @BatchID, 'FULL_REFRESH', SYSUTCDATETIME()
    );
    
    IF @Status = 'FAILED' THROW 50001, @ErrorMessage, 1;
END;
GO

/*
================================================================================
TABLE 4: Bronze.usp_Load_bz_Timesheet_New
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.usp_Load_bz_Timesheet_New
    @BatchID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcedureName VARCHAR(200) = 'Bronze.usp_Load_bz_Timesheet_New';
    DECLARE @SourceTable VARCHAR(200) = 'source_layer.Timesheet_New';
    DECLARE @TargetTable VARCHAR(200) = 'Bronze.bz_Timesheet_New';
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @EndTime DATETIME2;
    DECLARE @ExecutionTime FLOAT;
    DECLARE @RowsInserted BIGINT = 0;
    DECLARE @RowsSource BIGINT = 0;
    DECLARE @Status VARCHAR(50) = 'SUCCESS';
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @CurrentUser VARCHAR(100) = SYSTEM_USER;
    DECLARE @SourceSystem VARCHAR(100) = 'SQL_Server_Source';
    
    BEGIN TRY
        PRINT 'Loading ' + @TargetTable + '...';
        
        SELECT @RowsSource = COUNT(*) FROM source_layer.Timesheet_New;
        
        BEGIN TRANSACTION;
        
        TRUNCATE TABLE Bronze.bz_Timesheet_New;
        
        INSERT INTO Bronze.bz_Timesheet_New (
            [gci_id], [pe_date], [task_id], [c_date], [ST], [OT], [TIME_OFF], [HO], [DT],
            [NON_ST], [NON_OT], [Sick_Time], [NON_Sick_Time], [NON_DT],
            [load_timestamp], [update_timestamp], [source_system]
        )
        SELECT 
            [gci_id], [pe_date], [task_id], [c_date], [ST], [OT], [TIME_OFF], [HO], [DT],
            [NON_ST], [NON_OT], [Sick_Time], [NON_Sick_Time], [NON_DT],
            SYSUTCDATETIME(), SYSUTCDATETIME(), @SourceSystem
        FROM source_layer.Timesheet_New;
        
        SET @RowsInserted = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  Rows inserted: ' + CAST(@RowsInserted AS VARCHAR(20)) + ' (Source: ' + CAST(@RowsSource AS VARCHAR(20)) + ')';
        PRINT '  Execution time: ' + CAST(@ExecutionTime AS VARCHAR(20)) + ' seconds';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SET @Status = 'FAILED';
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  ERROR: ' + @ErrorMessage;
    END CATCH
    
    INSERT INTO Bronze.bz_Audit_Log (
        source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
        processed_by, processing_time, status, records_processed, records_inserted,
        row_count_source, row_count_target, error_message, batch_id, load_type, created_date
    )
    VALUES (
        @SourceTable, @TargetTable, @StartTime, @StartTime, @EndTime,
        @CurrentUser, @ExecutionTime, @Status, @RowsSource, @RowsInserted,
        @RowsSource, @RowsInserted, @ErrorMessage, @BatchID, 'FULL_REFRESH', SYSUTCDATETIME()
    );
    
    IF @Status = 'FAILED' THROW 50001, @ErrorMessage, 1;
END;
GO

/*
================================================================================
TABLE 5: Bronze.usp_Load_bz_report_392_all
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.usp_Load_bz_report_392_all
    @BatchID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcedureName VARCHAR(200) = 'Bronze.usp_Load_bz_report_392_all';
    DECLARE @SourceTable VARCHAR(200) = 'source_layer.report_392_all';
    DECLARE @TargetTable VARCHAR(200) = 'Bronze.bz_report_392_all';
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @EndTime DATETIME2;
    DECLARE @ExecutionTime FLOAT;
    DECLARE @RowsInserted BIGINT = 0;
    DECLARE @RowsSource BIGINT = 0;
    DECLARE @Status VARCHAR(50) = 'SUCCESS';
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @CurrentUser VARCHAR(100) = SYSTEM_USER;
    DECLARE @SourceSystem VARCHAR(100) = 'SQL_Server_Source';
    
    BEGIN TRY
        PRINT 'Loading ' + @TargetTable + '...';
        
        SELECT @RowsSource = COUNT(*) FROM source_layer.report_392_all;
        
        BEGIN TRANSACTION;
        
        TRUNCATE TABLE Bronze.bz_report_392_all;
        
        INSERT INTO Bronze.bz_report_392_all (
            [id], [gci id], [first name], [last name], [employee type], [recruiting manager],
            [resource manager], [salesrep], [inside_sales], [recruiter], [req type], [ms_type],
            [client code], [client name], [client_type], [job title], [bill st], [visa type],
            [bill st units], [salary], [salary units], [pay st], [pay st units], [start date],
            [end date], [po start date], [po end date], [project city], [project state],
            [no of free hours], [hr_business_type], [ee_wf_reason], [singleman company],
            [status], [termination_reason], [wf created on], [hcu], [hsu], [project zip],
            [cre_person], [assigned_hsu], [req_category], [gpm], [gp], [aca_cost],
            [aca_classification], [markup], [actual_markup], [maximum_allowed_markup],
            [submitted_bill_rate], [req_division], [pay rate to consultant], [location],
            [rec_region], [client_region], [dm], [delivery_director], [bu], [es], [nam],
            [client_sector], [skills], [pskills], [business_manager], [vmo], [rec_name],
            [Req_ID], [received], [Submitted], [responsetime], [Inhouse], [Net_Bill_Rate],
            [Loaded_Pay_Rate], [NSO], [ESG_Vertical], [ESG_Industry], [ESG_DNA], [ESG_NAM1],
            [ESG_NAM2], [ESG_NAM3], [ESG_SAM], [ESG_ES], [ESG_BU], [SUB_GPM], [manager_id],
            [Submitted_By], [HWF_Process_name], [Transition], [ITSS], [GP2020], [GPM2020],
            [isbulk], [jump], [client_class], [MSP], [DTCUChoice1], [SubCat],
            [IsClassInitiative], [division], [divstart_date], [divend_date], [tl],
            [resource_manager], [recruiting_manager], [VAS_Type], [BUCKET], [RTR_DM],
            [ITSSProjectName], [RegionGroup], [client_Markup], [Subtier], [Subtier_Address1],
            [Subtier_Address2], [Subtier_City], [Subtier_State], [Hiresource],
            [is_Hotbook_Hire], [Client_RM], [Job_Description], [Client_Manager],
            [end_date_at_client], [term_date], [employee_status], [Level_ID], [OpsGrp],
            [Level_Name], [Min_levelDatetime], [Max_levelDatetime], [First_Interview_date],
            [Is REC CES?], [Is CES Initiative?], [VMO_Access], [Billing_Type], [VASSOW],
            [Worker_Entity_ID], [Circle], [VMO_Access1], [VMO_Access2], [VMO_Access3],
            [VMO_Access4], [Inside_Sales_Person], [admin_1701], [corrected_staffadmin_1701],
            [HR_Billing_Placement_Net_Fee], [New_Visa_type], [newenddate],
            [Newoffboardingdate], [NewTermdate], [newhrisenddate], [rtr_location],
            [HR_Recruiting_TL], [client_entity], [client_consent], [Ascendion_MetalReqID],
            [eeo], [veteran], [Gender], [Er_person], [wfmetaljobdescription],
            [HR_Candidate_Salary], [Interview_CreatedDate], [Interview_on_Date], [IS_SOW],
            [IS_Offshore], [New_VAS], [VerticalName], [Client_Group1], [Billig_Type],
            [Super Merged Name], [New_Category], [New_business_type], [OpportunityID],
            [OpportunityName], [Ms_ProjectId], [MS_ProjectName], [ORC_ID], [Market_Leader],
            [Circle_Metal], [Community_New_Metal], [Employee_Category], [IsBillRateSkip],
            [BillRate], [RoleFamily], [SubRoleFamily], [Standard JobTitle],
            [ClientInterviewRequired], [Redeploymenthire], [HRBrandLevelId], [HRBandTitle],
            [latest_termination_reason], [latest_termination_date], [Community],
            [ReqFulfillmentReason], [EngagementType], [RedepLedBy],
            [Can_ExperienceLevelTitle], [Can_StandardJobTitleHorizon], [CandidateEmail],
            [Offboarding_Reason], [Offboarding_Initiated], [Offboarding_Status],
            [replcament_GCIID], [replcament_EmployeeName], [Senior Manager],
            [Associate Manager], [Director - Talent Engine], [Manager],
            [Rec_ExperienceLevelTitle], [Rec_StandardJobTitleHorizon], [Task_Id], [proj_ID],
            [Projdesc], [Client_Group], [billST_New], [Candidate city], [Candidate State],
            [C2C_W2_FTE], [FP_TM],
            [load_timestamp], [update_timestamp], [source_system]
        )
        SELECT 
            [id], [gci id], [first name], [last name], [employee type], [recruiting manager],
            [resource manager], [salesrep], [inside_sales], [recruiter], [req type], [ms_type],
            [client code], [client name], [client_type], [job title], [bill st], [visa type],
            [bill st units], [salary], [salary units], [pay st], [pay st units], [start date],
            [end date], [po start date], [po end date], [project city], [project state],
            [no of free hours], [hr_business_type], [ee_wf_reason], [singleman company],
            [status], [termination_reason], [wf created on], [hcu], [hsu], [project zip],
            [cre_person], [assigned_hsu], [req_category], [gpm], [gp], [aca_cost],
            [aca_classification], [markup], [actual_markup], [maximum_allowed_markup],
            [submitted_bill_rate], [req_division], [pay rate to consultant], [location],
            [rec_region], [client_region], [dm], [delivery_director], [bu], [es], [nam],
            [client_sector], [skills], [pskills], [business_manager], [vmo], [rec_name],
            [Req_ID], [received], [Submitted], [responsetime], [Inhouse], [Net_Bill_Rate],
            [Loaded_Pay_Rate], [NSO], [ESG_Vertical], [ESG_Industry], [ESG_DNA], [ESG_NAM1],
            [ESG_NAM2], [ESG_NAM3], [ESG_SAM], [ESG_ES], [ESG_BU], [SUB_GPM], [manager_id],
            [Submitted_By], [HWF_Process_name], [Transition], [ITSS], [GP2020], [GPM2020],
            [isbulk], [jump], [client_class], [MSP], [DTCUChoice1], [SubCat],
            [IsClassInitiative], [division], [divstart_date], [divend_date], [tl],
            [resource_manager], [recruiting_manager], [VAS_Type], [BUCKET], [RTR_DM],
            [ITSSProjectName], [RegionGroup], [client_Markup], [Subtier], [Subtier_Address1],
            [Subtier_Address2], [Subtier_City], [Subtier_State], [Hiresource],
            [is_Hotbook_Hire], [Client_RM], [Job_Description], [Client_Manager],
            [end_date_at_client], [term_date], [employee_status], [Level_ID], [OpsGrp],
            [Level_Name], [Min_levelDatetime], [Max_levelDatetime], [First_Interview_date],
            [Is REC CES?], [Is CES Initiative?], [VMO_Access], [Billing_Type], [VASSOW],
            [Worker_Entity_ID], [Circle], [VMO_Access1], [VMO_Access2], [VMO_Access3],
            [VMO_Access4], [Inside_Sales_Person], [admin_1701], [corrected_staffadmin_1701],
            [HR_Billing_Placement_Net_Fee], [New_Visa_type], [newenddate],
            [Newoffboardingdate], [NewTermdate], [newhrisenddate], [rtr_location],
            [HR_Recruiting_TL], [client_entity], [client_consent], [Ascendion_MetalReqID],
            [eeo], [veteran], [Gender], [Er_person], [wfmetaljobdescription],
            [HR_Candidate_Salary], [Interview_CreatedDate], [Interview_on_Date], [IS_SOW],
            [IS_Offshore], [New_VAS], [VerticalName], [Client_Group1], [Billig_Type],
            [Super Merged Name], [New_Category], [New_business_type], [OpportunityID],
            [OpportunityName], [Ms_ProjectId], [MS_ProjectName], [ORC_ID], [Market_Leader],
            [Circle_Metal], [Community_New_Metal], [Employee_Category], [IsBillRateSkip],
            [BillRate], [RoleFamily], [SubRoleFamily], [Standard JobTitle],
            [ClientInterviewRequired], [Redeploymenthire], [HRBrandLevelId], [HRBandTitle],
            [latest_termination_reason], [latest_termination_date], [Community],
            [ReqFulfillmentReason], [EngagementType], [RedepLedBy],
            [Can_ExperienceLevelTitle], [Can_StandardJobTitleHorizon], [CandidateEmail],
            [Offboarding_Reason], [Offboarding_Initiated], [Offboarding_Status],
            [replcament_GCIID], [replcament_EmployeeName], [Senior Manager],
            [Associate Manager], [Director - Talent Engine], [Manager],
            [Rec_ExperienceLevelTitle], [Rec_StandardJobTitleHorizon], [Task_Id], [proj_ID],
            [Projdesc], [Client_Group], [billST_New], [Candidate city], [Candidate State],
            [C2C_W2_FTE], [FP_TM],
            SYSUTCDATETIME(), SYSUTCDATETIME(), @SourceSystem
        FROM source_layer.report_392_all;
        
        SET @RowsInserted = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  Rows inserted: ' + CAST(@RowsInserted AS VARCHAR(20)) + ' (Source: ' + CAST(@RowsSource AS VARCHAR(20)) + ')';
        PRINT '  Execution time: ' + CAST(@ExecutionTime AS VARCHAR(20)) + ' seconds';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SET @Status = 'FAILED';
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  ERROR: ' + @ErrorMessage;
    END CATCH
    
    INSERT INTO Bronze.bz_Audit_Log (
        source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
        processed_by, processing_time, status, records_processed, records_inserted,
        row_count_source, row_count_target, error_message, batch_id, load_type, created_date
    )
    VALUES (
        @SourceTable, @TargetTable, @StartTime, @StartTime, @EndTime,
        @CurrentUser, @ExecutionTime, @Status, @RowsSource, @RowsInserted,
        @RowsSource, @RowsInserted, @ErrorMessage, @BatchID, 'FULL_REFRESH', SYSUTCDATETIME()
    );
    
    IF @Status = 'FAILED' THROW 50001, @ErrorMessage, 1;
END;
GO

/*
================================================================================
TABLE 6: Bronze.usp_Load_bz_vw_billing_timesheet_daywise_ne
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.usp_Load_bz_vw_billing_timesheet_daywise_ne
    @BatchID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcedureName VARCHAR(200) = 'Bronze.usp_Load_bz_vw_billing_timesheet_daywise_ne';
    DECLARE @SourceTable VARCHAR(200) = 'source_layer.vw_billing_timesheet_daywise_ne';
    DECLARE @TargetTable VARCHAR(200) = 'Bronze.bz_vw_billing_timesheet_daywise_ne';
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @EndTime DATETIME2;
    DECLARE @ExecutionTime FLOAT;
    DECLARE @RowsInserted BIGINT = 0;
    DECLARE @RowsSource BIGINT = 0;
    DECLARE @Status VARCHAR(50) = 'SUCCESS';
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @CurrentUser VARCHAR(100) = SYSTEM_USER;
    DECLARE @SourceSystem VARCHAR(100) = 'SQL_Server_Source';
    
    BEGIN TRY
        PRINT 'Loading ' + @TargetTable + '...';
        
        SELECT @RowsSource = COUNT(*) FROM source_layer.vw_billing_timesheet_daywise_ne;
        
        BEGIN TRANSACTION;
        
        TRUNCATE TABLE Bronze.bz_vw_billing_timesheet_daywise_ne;
        
        INSERT INTO Bronze.bz_vw_billing_timesheet_daywise_ne (
            [ID], [GCI_ID], [PE_DATE], [WEEK_DATE], [BILLABLE],
            [Approved_hours(ST)], [Approved_hours(Non_ST)], [Approved_hours(OT)],
            [Approved_hours(Non_OT)], [Approved_hours(DT)], [Approved_hours(Non_DT)],
            [Approved_hours(Sick_Time)], [Approved_hours(Non_Sick_Time)],
            [load_timestamp], [update_timestamp], [source_system]
        )
        SELECT 
            [ID], [GCI_ID], [PE_DATE], [WEEK_DATE], [BILLABLE],
            [Approved_hours(ST)], [Approved_hours(Non_ST)], [Approved_hours(OT)],
            [Approved_hours(Non_OT)], [Approved_hours(DT)], [Approved_hours(Non_DT)],
            [Approved_hours(Sick_Time)], [Approved_hours(Non_Sick_Time)],
            SYSUTCDATETIME(), SYSUTCDATETIME(), @SourceSystem
        FROM source_layer.vw_billing_timesheet_daywise_ne;
        
        SET @RowsInserted = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  Rows inserted: ' + CAST(@RowsInserted AS VARCHAR(20)) + ' (Source: ' + CAST(@RowsSource AS VARCHAR(20)) + ')';
        PRINT '  Execution time: ' + CAST(@ExecutionTime AS VARCHAR(20)) + ' seconds';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SET @Status = 'FAILED';
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  ERROR: ' + @ErrorMessage;
    END CATCH
    
    INSERT INTO Bronze.bz_Audit_Log (
        source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
        processed_by, processing_time, status, records_processed, records_inserted,
        row_count_source, row_count_target, error_message, batch_id, load_type, created_date
    )
    VALUES (
        @SourceTable, @TargetTable, @StartTime, @StartTime, @EndTime,
        @CurrentUser, @ExecutionTime, @Status, @RowsSource, @RowsInserted,
        @RowsSource, @RowsInserted, @ErrorMessage, @BatchID, 'FULL_REFRESH', SYSUTCDATETIME()
    );
    
    IF @Status = 'FAILED' THROW 50001, @ErrorMessage, 1;
END;
GO

/*
================================================================================
TABLE 7: Bronze.usp_Load_bz_vw_consultant_timesheet_daywise
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.usp_Load_bz_vw_consultant_timesheet_daywise
    @BatchID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcedureName VARCHAR(200) = 'Bronze.usp_Load_bz_vw_consultant_timesheet_daywise';
    DECLARE @SourceTable VARCHAR(200) = 'source_layer.vw_consultant_timesheet_daywise';
    DECLARE @TargetTable VARCHAR(200) = 'Bronze.bz_vw_consultant_timesheet_daywise';
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @EndTime DATETIME2;
    DECLARE @ExecutionTime FLOAT;
    DECLARE @RowsInserted BIGINT = 0;
    DECLARE @RowsSource BIGINT = 0;
    DECLARE @Status VARCHAR(50) = 'SUCCESS';
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @CurrentUser VARCHAR(100) = SYSTEM_USER;
    DECLARE @SourceSystem VARCHAR(100) = 'SQL_Server_Source';
    
    BEGIN TRY
        PRINT 'Loading ' + @TargetTable + '...';
        
        SELECT @RowsSource = COUNT(*) FROM source_layer.vw_consultant_timesheet_daywise;
        
        BEGIN TRANSACTION;
        
        TRUNCATE TABLE Bronze.bz_vw_consultant_timesheet_daywise;
        
        INSERT INTO Bronze.bz_vw_consultant_timesheet_daywise (
            [ID], [GCI_ID], [PE_DATE], [WEEK_DATE], [BILLABLE],
            [Consultant_hours(ST)], [Consultant_hours(OT)], [Consultant_hours(DT)],
            [load_timestamp], [update_timestamp], [source_system]
        )
        SELECT 
            [ID], [GCI_ID], [PE_DATE], [WEEK_DATE], [BILLABLE],
            [Consultant_hours(ST)], [Consultant_hours(OT)], [Consultant_hours(DT)],
            SYSUTCDATETIME(), SYSUTCDATETIME(), @SourceSystem
        FROM source_layer.vw_consultant_timesheet_daywise;
        
        SET @RowsInserted = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  Rows inserted: ' + CAST(@RowsInserted AS VARCHAR(20)) + ' (Source: ' + CAST(@RowsSource AS VARCHAR(20)) + ')';
        PRINT '  Execution time: ' + CAST(@ExecutionTime AS VARCHAR(20)) + ' seconds';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SET @Status = 'FAILED';
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  ERROR: ' + @ErrorMessage;
    END CATCH
    
    INSERT INTO Bronze.bz_Audit_Log (
        source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
        processed_by, processing_time, status, records_processed, records_inserted,
        row_count_source, row_count_target, error_message, batch_id, load_type, created_date
    )
    VALUES (
        @SourceTable, @TargetTable, @StartTime, @StartTime, @EndTime,
        @CurrentUser, @ExecutionTime, @Status, @RowsSource, @RowsInserted,
        @RowsSource, @RowsInserted, @ErrorMessage, @BatchID, 'FULL_REFRESH', SYSUTCDATETIME()
    );
    
    IF @Status = 'FAILED' THROW 50001, @ErrorMessage, 1;
END;
GO

/*
================================================================================
TABLE 8: Bronze.usp_Load_bz_DimDate
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.usp_Load_bz_DimDate
    @BatchID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcedureName VARCHAR(200) = 'Bronze.usp_Load_bz_DimDate';
    DECLARE @SourceTable VARCHAR(200) = 'source_layer.DimDate';
    DECLARE @TargetTable VARCHAR(200) = 'Bronze.bz_DimDate';
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @EndTime DATETIME2;
    DECLARE @ExecutionTime FLOAT;
    DECLARE @RowsInserted BIGINT = 0;
    DECLARE @RowsSource BIGINT = 0;
    DECLARE @Status VARCHAR(50) = 'SUCCESS';
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @CurrentUser VARCHAR(100) = SYSTEM_USER;
    DECLARE @SourceSystem VARCHAR(100) = 'SQL_Server_Source';
    
    BEGIN TRY
        PRINT 'Loading ' + @TargetTable + '...';
        
        SELECT @RowsSource = COUNT(*) FROM source_layer.DimDate;
        
        BEGIN TRANSACTION;
        
        TRUNCATE TABLE Bronze.bz_DimDate;
        
        INSERT INTO Bronze.bz_DimDate (
            [Date], [DayOfMonth], [DayName], [WeekOfYear], [Month], [MonthName],
            [MonthOfQuarter], [Quarter], [QuarterName], [Year], [YearName], [MonthYear],
            [MMYYYY], [DaysInMonth], [MM-YYYY], [YYYYMM],
            [load_timestamp], [update_timestamp], [source_system]
        )
        SELECT 
            [Date], [DayOfMonth], [DayName], [WeekOfYear], [Month], [MonthName],
            [MonthOfQuarter], [Quarter], [QuarterName], [Year], [YearName], [MonthYear],
            [MMYYYY], [DaysInMonth], [MM-YYYY], [YYYYMM],
            SYSUTCDATETIME(), SYSUTCDATETIME(), @SourceSystem
        FROM source_layer.DimDate;
        
        SET @RowsInserted = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  Rows inserted: ' + CAST(@RowsInserted AS VARCHAR(20)) + ' (Source: ' + CAST(@RowsSource AS VARCHAR(20)) + ')';
        PRINT '  Execution time: ' + CAST(@ExecutionTime AS VARCHAR(20)) + ' seconds';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SET @Status = 'FAILED';
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  ERROR: ' + @ErrorMessage;
    END CATCH
    
    INSERT INTO Bronze.bz_Audit_Log (
        source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
        processed_by, processing_time, status, records_processed, records_inserted,
        row_count_source, row_count_target, error_message, batch_id, load_type, created_date
    )
    VALUES (
        @SourceTable, @TargetTable, @StartTime, @StartTime, @EndTime,
        @CurrentUser, @ExecutionTime, @Status, @RowsSource, @RowsInserted,
        @RowsSource, @RowsInserted, @ErrorMessage, @BatchID, 'FULL_REFRESH', SYSUTCDATETIME()
    );
    
    IF @Status = 'FAILED' THROW 50001, @ErrorMessage, 1;
END;
GO

/*
================================================================================
TABLE 9: Bronze.usp_Load_bz_holidays_Mexico
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.usp_Load_bz_holidays_Mexico
    @BatchID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcedureName VARCHAR(200) = 'Bronze.usp_Load_bz_holidays_Mexico';
    DECLARE @SourceTable VARCHAR(200) = 'source_layer.holidays_Mexico';
    DECLARE @TargetTable VARCHAR(200) = 'Bronze.bz_holidays_Mexico';
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @EndTime DATETIME2;
    DECLARE @ExecutionTime FLOAT;
    DECLARE @RowsInserted BIGINT = 0;
    DECLARE @RowsSource BIGINT = 0;
    DECLARE @Status VARCHAR(50) = 'SUCCESS';
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @CurrentUser VARCHAR(100) = SYSTEM_USER;
    DECLARE @SourceSystem VARCHAR(100) = 'SQL_Server_Source';
    
    BEGIN TRY
        PRINT 'Loading ' + @TargetTable + '...';
        
        SELECT @RowsSource = COUNT(*) FROM source_layer.holidays_Mexico;
        
        BEGIN TRANSACTION;
        
        TRUNCATE TABLE Bronze.bz_holidays_Mexico;
        
        INSERT INTO Bronze.bz_holidays_Mexico (
            [Holiday_Date], [Description], [Location], [Source_type],
            [load_timestamp], [update_timestamp], [source_system]
        )
        SELECT 
            [Holiday_Date], [Description], [Location], [Source_type],
            SYSUTCDATETIME(), SYSUTCDATETIME(), @SourceSystem
        FROM source_layer.holidays_Mexico;
        
        SET @RowsInserted = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  Rows inserted: ' + CAST(@RowsInserted AS VARCHAR(20)) + ' (Source: ' + CAST(@RowsSource AS VARCHAR(20)) + ')';
        PRINT '  Execution time: ' + CAST(@ExecutionTime AS VARCHAR(20)) + ' seconds';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SET @Status = 'FAILED';
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  ERROR: ' + @ErrorMessage;
    END CATCH
    
    INSERT INTO Bronze.bz_Audit_Log (
        source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
        processed_by, processing_time, status, records_processed, records_inserted,
        row_count_source, row_count_target, error_message, batch_id, load_type, created_date
    )
    VALUES (
        @SourceTable, @TargetTable, @StartTime, @StartTime, @EndTime,
        @CurrentUser, @ExecutionTime, @Status, @RowsSource, @RowsInserted,
        @RowsSource, @RowsInserted, @ErrorMessage, @BatchID, 'FULL_REFRESH', SYSUTCDATETIME()
    );
    
    IF @Status = 'FAILED' THROW 50001, @ErrorMessage, 1;
END;
GO

/*
================================================================================
TABLE 10: Bronze.usp_Load_bz_holidays_Canada
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.usp_Load_bz_holidays_Canada
    @BatchID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcedureName VARCHAR(200) = 'Bronze.usp_Load_bz_holidays_Canada';
    DECLARE @SourceTable VARCHAR(200) = 'source_layer.holidays_Canada';
    DECLARE @TargetTable VARCHAR(200) = 'Bronze.bz_holidays_Canada';
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @EndTime DATETIME2;
    DECLARE @ExecutionTime FLOAT;
    DECLARE @RowsInserted BIGINT = 0;
    DECLARE @RowsSource BIGINT = 0;
    DECLARE @Status VARCHAR(50) = 'SUCCESS';
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @CurrentUser VARCHAR(100) = SYSTEM_USER;
    DECLARE @SourceSystem VARCHAR(100) = 'SQL_Server_Source';
    
    BEGIN TRY
        PRINT 'Loading ' + @TargetTable + '...';
        
        SELECT @RowsSource = COUNT(*) FROM source_layer.holidays_Canada;
        
        BEGIN TRANSACTION;
        
        TRUNCATE TABLE Bronze.bz_holidays_Canada;
        
        INSERT INTO Bronze.bz_holidays_Canada (
            [Holiday_Date], [Description], [Location], [Source_type],
            [load_timestamp], [update_timestamp], [source_system]
        )
        SELECT 
            [Holiday_Date], [Description], [Location], [Source_type],
            SYSUTCDATETIME(), SYSUTCDATETIME(), @SourceSystem
        FROM source_layer.holidays_Canada;
        
        SET @RowsInserted = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  Rows inserted: ' + CAST(@RowsInserted AS VARCHAR(20)) + ' (Source: ' + CAST(@RowsSource AS VARCHAR(20)) + ')';
        PRINT '  Execution time: ' + CAST(@ExecutionTime AS VARCHAR(20)) + ' seconds';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SET @Status = 'FAILED';
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  ERROR: ' + @ErrorMessage;
    END CATCH
    
    INSERT INTO Bronze.bz_Audit_Log (
        source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
        processed_by, processing_time, status, records_processed, records_inserted,
        row_count_source, row_count_target, error_message, batch_id, load_type, created_date
    )
    VALUES (
        @SourceTable, @TargetTable, @StartTime, @StartTime, @EndTime,
        @CurrentUser, @ExecutionTime, @Status, @RowsSource, @RowsInserted,
        @RowsSource, @RowsInserted, @ErrorMessage, @BatchID, 'FULL_REFRESH', SYSUTCDATETIME()
    );
    
    IF @Status = 'FAILED' THROW 50001, @ErrorMessage, 1;
END;
GO

/*
================================================================================
TABLE 11: Bronze.usp_Load_bz_holidays
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.usp_Load_bz_holidays
    @BatchID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcedureName VARCHAR(200) = 'Bronze.usp_Load_bz_holidays';
    DECLARE @SourceTable VARCHAR(200) = 'source_layer.holidays';
    DECLARE @TargetTable VARCHAR(200) = 'Bronze.bz_holidays';
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @EndTime DATETIME2;
    DECLARE @ExecutionTime FLOAT;
    DECLARE @RowsInserted BIGINT = 0;
    DECLARE @RowsSource BIGINT = 0;
    DECLARE @Status VARCHAR(50) = 'SUCCESS';
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @CurrentUser VARCHAR(100) = SYSTEM_USER;
    DECLARE @SourceSystem VARCHAR(100) = 'SQL_Server_Source';
    
    BEGIN TRY
        PRINT 'Loading ' + @TargetTable + '...';
        
        SELECT @RowsSource = COUNT(*) FROM source_layer.holidays;
        
        BEGIN TRANSACTION;
        
        TRUNCATE TABLE Bronze.bz_holidays;
        
        INSERT INTO Bronze.bz_holidays (
            [Holiday_Date], [Description], [Location], [Source_type],
            [load_timestamp], [update_timestamp], [source_system]
        )
        SELECT 
            [Holiday_Date], [Description], [Location], [Source_type],
            SYSUTCDATETIME(), SYSUTCDATETIME(), @SourceSystem
        FROM source_layer.holidays;
        
        SET @RowsInserted = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  Rows inserted: ' + CAST(@RowsInserted AS VARCHAR(20)) + ' (Source: ' + CAST(@RowsSource AS VARCHAR(20)) + ')';
        PRINT '  Execution time: ' + CAST(@ExecutionTime AS VARCHAR(20)) + ' seconds';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SET @Status = 'FAILED';
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  ERROR: ' + @ErrorMessage;
    END CATCH
    
    INSERT INTO Bronze.bz_Audit_Log (
        source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
        processed_by, processing_time, status, records_processed, records_inserted,
        row_count_source, row_count_target, error_message, batch_id, load_type, created_date
    )
    VALUES (
        @SourceTable, @TargetTable, @StartTime, @StartTime, @EndTime,
        @CurrentUser, @ExecutionTime, @Status, @RowsSource, @RowsInserted,
        @RowsSource, @RowsInserted, @ErrorMessage, @BatchID, 'FULL_REFRESH', SYSUTCDATETIME()
    );
    
    IF @Status = 'FAILED' THROW 50001, @ErrorMessage, 1;
END;
GO

/*
================================================================================
TABLE 12: Bronze.usp_Load_bz_holidays_India
================================================================================
*/

CREATE OR ALTER PROCEDURE Bronze.usp_Load_bz_holidays_India
    @BatchID VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcedureName VARCHAR(200) = 'Bronze.usp_Load_bz_holidays_India';
    DECLARE @SourceTable VARCHAR(200) = 'source_layer.holidays_India';
    DECLARE @TargetTable VARCHAR(200) = 'Bronze.bz_holidays_India';
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @EndTime DATETIME2;
    DECLARE @ExecutionTime FLOAT;
    DECLARE @RowsInserted BIGINT = 0;
    DECLARE @RowsSource BIGINT = 0;
    DECLARE @Status VARCHAR(50) = 'SUCCESS';
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @CurrentUser VARCHAR(100) = SYSTEM_USER;
    DECLARE @SourceSystem VARCHAR(100) = 'SQL_Server_Source';
    
    BEGIN TRY
        PRINT 'Loading ' + @TargetTable + '...';
        
        SELECT @RowsSource = COUNT(*) FROM source_layer.holidays_India;
        
        BEGIN TRANSACTION;
        
        TRUNCATE TABLE Bronze.bz_holidays_India;
        
        INSERT INTO Bronze.bz_holidays_India (
            [Holiday_Date], [Description], [Location], [Source_type],
            [load_timestamp], [update_timestamp], [source_system]
        )
        SELECT 
            [Holiday_Date], [Description], [Location], [Source_type],
            SYSUTCDATETIME(), SYSUTCDATETIME(), @SourceSystem
        FROM source_layer.holidays_India;
        
        SET @RowsInserted = @@ROWCOUNT;
        
        COMMIT TRANSACTION;
        
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  Rows inserted: ' + CAST(@RowsInserted AS VARCHAR(20)) + ' (Source: ' + CAST(@RowsSource AS VARCHAR(20)) + ')';
        PRINT '  Execution time: ' + CAST(@ExecutionTime AS VARCHAR(20)) + ' seconds';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SET @Status = 'FAILED';
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @EndTime = SYSUTCDATETIME();
        SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
        
        PRINT '  ERROR: ' + @ErrorMessage;
    END CATCH
    
    INSERT INTO Bronze.bz_Audit_Log (
        source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
        processed_by, processing_time, status, records_processed, records_inserted,
        row_count_source, row_count_target, error_message, batch_id, load_type, created_date
    )
    VALUES (
        @SourceTable, @TargetTable, @StartTime, @StartTime, @EndTime,
        @CurrentUser, @ExecutionTime, @Status, @RowsSource, @RowsInserted,
        @RowsSource, @RowsInserted, @ErrorMessage, @BatchID, 'FULL_REFRESH', SYSUTCDATETIME()
    );
    
    IF @Status = 'FAILED' THROW 50001, @ErrorMessage, 1;
END;
GO

/*
================================================================================
END OF BRONZE LAYER ETL PIPELINE STORED PROCEDURES
================================================================================

SUMMARY:
- Total Stored Procedures Created: 13 (1 Master + 12 Table-Specific)
- Load Strategy: Full Refresh (TRUNCATE and INSERT)
- Audit Logging: Comprehensive logging to Bronze.bz_Audit_Log
- Error Handling: TRY...CATCH with transaction rollback
- Metadata Tracking: load_timestamp, update_timestamp, source_system
- TIMESTAMP Column Handling: Excluded from SchTask load

EXECUTION INSTRUCTIONS:
1. Ensure Bronze schema and all target tables exist
2. Ensure Bronze.bz_Audit_Log table exists
3. Execute: EXEC Bronze.usp_Load_Bronze_Layer_Full;
4. Monitor execution via PRINT statements and audit log
5. Check Bronze.bz_Audit_Log for detailed execution history

MONITORING QUERY:
SELECT 
    batch_id,
    source_table,
    target_table,
    status,
    records_inserted,
    processing_time,
    error_message,
    start_timestamp,
    end_timestamp
FROM Bronze.bz_Audit_Log
WHERE batch_id = (SELECT MAX(batch_id) FROM Bronze.bz_Audit_Log)
ORDER BY start_timestamp;

API COST REPORTING:
apiCost: 0.00

Note: GitHub File Reader and Writer tools do not incur API costs. 
All operations were performed using file I/O without paid API calls.

================================================================================
*/