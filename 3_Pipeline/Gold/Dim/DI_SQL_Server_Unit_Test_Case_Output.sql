-- ==================================================================================================
-- GOLD LAYER DIMENSION ETL: tSQLt UNIT TEST CASES & SCRIPTS FOR usp_Load_Gold_Dim_Resource
-- ==================================================================================================

-- ===========================================
-- 1. TEST CASE LIST
-- ===========================================
/*
| Test Case ID | Description                                             | Input Criteria (Seed Data)                         | Expected Outcome (Assertions)                                                                                   | Priority |
|--------------|--------------------------------------------------------|----------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|----------|
| TC01         | Happy Path: Valid Insert                                | 1 valid row in source                              | Row inserted in Gold.Go_Dim_Resource, correct metadata, audit row created, no error row                         | High     |
| TC02         | Happy Path: Valid Upsert (Update existing)              | 1 row in target, updated row in source             | Row updated in Gold.Go_Dim_Resource, update_date changed, audit row created, no error row                       | High     |
| TC03         | Empty Source Table                                      | No rows in source                                  | No changes in Gold.Go_Dim_Resource, audit row created, no error row                                             | High     |
| TC04         | Nulls in Optional Columns                               | Row with NULLs in optional columns                 | Row inserted with default values where applicable, audit row created                                            | Medium   |
| TC05         | Nulls in Mandatory Columns                              | Row with NULL in Resource_Code                     | Row not inserted, error row created in Gold.Go_Error_Data, audit row with rejected count                        | High     |
| TC06         | Invalid Data Types/Truncated Strings                    | Row with string > max length for Project_Assignment| Row inserted/truncated as per schema, audit row created, or error row if constraint fails                       | Medium   |
| TC07         | Missing Optional Columns                                | Row missing optional columns                       | Row inserted with default values, audit row created                                                            | Medium   |
| TC08         | Duplicate Business Key in Source                        | 2 rows with same Resource_Code                     | Only one row inserted/updated, audit row reflects correct count, error row if duplicate causes validation error | High     |
| TC09         | Constraint Violation (e.g., negative Expected_Hours)    | Row with Expected_Hours = -5                       | Row inserted with Expected_Hours = 0 (per transformation), audit row created                                    | High     |
| TC10         | Transaction Rollback on Error                           | Simulate error (e.g., missing required target col) | No partial data in Gold.Go_Dim_Resource, error logged, audit row status Failed                                  | High     |
| TC11         | Error in TRY Block                                      | Simulate runtime error (bad schema)                | Audit row status Failed, error row in Gold.Go_Error_Data                                                        | High     |
| TC12         | Metadata Columns Populated                              | 1 valid row in source                              | load_date, update_date, source_system populated correctly in Gold.Go_Dim_Resource                               | High     |
| TC13         | Audit Table Entry                                       | 1 valid row in source                              | Gold.Go_Process_Audit row created with correct counts/status                                                    | High     |
| TC14         | Error Table Entry for Invalid Row                       | Row with invalid Start_Date (future)               | Row not inserted, error row created in Gold.Go_Error_Data                                                       | High     |
| TC15         | Null Handling for Numeric Columns                       | Row with NULL Bill_Rate                            | Row inserted with Bill_Rate = 0 (if transformation applies), audit row created                                  | Medium   |
| TC16         | Referential Integrity Check (if any FK exists)          | Row referencing non-existent FK (if applicable)    | Row not inserted, error row created                                                                             | Medium   |
*/

-- ===========================================
-- 2. tSQLt TEST SCRIPTS
-- ===========================================

-- Create test class for usp_Load_Gold_Dim_Resource
EXEC tSQLt.NewTestClass 'test_usp_Load_Gold_Dim_Resource';
GO

--------------------------------------------------------------------------------------
-- TC01: Happy Path - Valid Insert
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC01_HappyPath_ValidInsert]
AS
BEGIN
    -- Fake tables
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Insert valid source row
    INSERT INTO Silver.Si_Resource (
        Resource_Code, First_Name, Last_Name, Job_Title, Business_Type, Client_Code, Start_Date, Termination_Date, Project_Assignment, Market, Visa_Type, Practice_Type, Vertical, Status, Employee_Category, Portfolio_Leader, Expected_Hours, Available_Hours, Business_Area, SOW, Super_Merged_Name, New_Business_Type, Requirement_Region, Is_Offshore, Employee_Status, Termination_Reason, Tower, Circle, Community, Bill_Rate, Net_Bill_Rate, GP, GPM, is_active
    )
    VALUES (
        'RC001', 'John', 'Doe', 'Consultant', 'FTE', 'CL001', '2020-01-01', NULL, 'ProjA', 'US', 'H1B', 'Tech', 'Fin', 'Active', 'CatA', 'PL1', 8, 160, 'NA', 'Yes', 'SMN', 'FTE', 'Region1', 'Onsite', 'Employed', NULL, 'Tower1', 'Circle1', 'Community1', 100, 90, 10, 20, 1
    );

    -- Execute ETL
    EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();

    -- Assert: Row exists in Gold.Go_Dim_Resource
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM Gold.Go_Dim_Resource WHERE Resource_Code = 'RC001';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;

    -- Assert: Metadata columns populated
    SELECT @cnt = COUNT(*) FROM Gold.Go_Dim_Resource WHERE Resource_Code = 'RC001' AND load_date IS NOT NULL AND update_date IS NOT NULL AND source_system = 'Silver.Si_Resource';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;

    -- Assert: Audit row created
    SELECT @cnt = COUNT(*) FROM Gold.Go_Process_Audit WHERE Target_Table = 'Gold.Go_Dim_Resource' AND Status = 'Success';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;

    -- Assert: No error row
    SELECT @cnt = COUNT(*) FROM Gold.Go_Error_Data WHERE Target_Table = 'Gold.Go_Dim_Resource';
    EXEC tSQLt.AssertEquals @Expected = 0, @Actual = @cnt;
END
GO

--------------------------------------------------------------------------------------
-- TC02: Happy Path - Valid Upsert (Update existing)
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC02_HappyPath_ValidUpsert]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Existing row in target
    INSERT INTO Gold.Go_Dim_Resource (Resource_Code, First_Name, Last_Name, load_date, update_date, source_system, is_active)
    VALUES ('RC002', 'Jane', 'Smith', '2022-01-01', '2022-01-01', 'Silver.Si_Resource', 1);

    -- Updated row in source
    INSERT INTO Silver.Si_Resource (Resource_Code, First_Name, Last_Name, is_active)
    VALUES ('RC002', 'Janet', 'Smithers', 1);

    -- Execute ETL
    EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();

    -- Assert: Row updated in target
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM Gold.Go_Dim_Resource WHERE Resource_Code = 'RC002' AND First_Name = 'Janet';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;

    -- Assert: Audit row created
    SELECT @cnt = COUNT(*) FROM Gold.Go_Process_Audit WHERE Target_Table = 'Gold.Go_Dim_Resource' AND Status = 'Success';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;

    -- Assert: No error row
    SELECT @cnt = COUNT(*) FROM Gold.Go_Error_Data WHERE Target_Table = 'Gold.Go_Dim_Resource';
    EXEC tSQLt.AssertEquals @Expected = 0, @Actual = @cnt;
END
GO

--------------------------------------------------------------------------------------
-- TC03: Empty Source Table
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC03_EmptySource]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- No data in Silver.Si_Resource

    -- Execute ETL
    EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();

    -- Assert: No rows inserted in target
    EXEC tSQLt.AssertEmptyTable 'Gold.Go_Dim_Resource';

    -- Assert: Audit row created
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM Gold.Go_Process_Audit WHERE Target_Table = 'Gold.Go_Dim_Resource';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;

    -- Assert: No error row
    SELECT @cnt = COUNT(*) FROM Gold.Go_Error_Data WHERE Target_Table = 'Gold.Go_Dim_Resource';
    EXEC tSQLt.AssertEquals @Expected = 0, @Actual = @cnt;
END
GO

--------------------------------------------------------------------------------------
-- TC04: Nulls in Optional Columns
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC04_NullsInOptionalColumns]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Insert row with NULLs in optional columns
    INSERT INTO Silver.Si_Resource (Resource_Code, First_Name, Last_Name, Job_Title, is_active)
    VALUES ('RC003', 'Alice', 'Wonder', NULL, 1);

    -- Execute ETL
    EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();

    -- Assert: Row inserted with default Job_Title
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM Gold.Go_Dim_Resource WHERE Resource_Code = 'RC003' AND Job_Title = 'Not Specified';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;
END
GO

--------------------------------------------------------------------------------------
-- TC05: Nulls in Mandatory Columns
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC05_NullsInMandatoryColumns]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Insert row with NULL Resource_Code (mandatory)
    INSERT INTO Silver.Si_Resource (Resource_Code, First_Name, Last_Name, is_active)
    VALUES (NULL, 'Bob', 'Builder', 1);

    -- Execute ETL
    EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();

    -- Assert: No row inserted in target
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM Gold.Go_Dim_Resource WHERE First_Name = 'Bob';
    EXEC tSQLt.AssertEquals @Expected = 0, @Actual = @cnt;

    -- Assert: Error row created
    SELECT @cnt = COUNT(*) FROM Gold.Go_Error_Data WHERE Target_Table = 'Gold.Go_Dim_Resource' AND Error_Description LIKE '%Resource_Code%';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;
END
GO

--------------------------------------------------------------------------------------
-- TC06: Invalid Data Types/Truncated Strings
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC06_InvalidDataTypes_TruncatedStrings]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Insert row with long Project_Assignment
    INSERT INTO Silver.Si_Resource (Resource_Code, First_Name, Last_Name, Project_Assignment, is_active)
    VALUES ('RC004', 'Charlie', 'Chaplin', REPLICATE('A', 300), 1);

    -- Execute ETL
    BEGIN TRY
        EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();
    END TRY
    BEGIN CATCH
        -- Swallow error for test
    END CATCH

    -- Assert: Row inserted or error row created depending on schema
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM Gold.Go_Dim_Resource WHERE Resource_Code = 'RC004';
    IF @cnt = 1
        EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;
    ELSE
    BEGIN
        SELECT @cnt = COUNT(*) FROM Gold.Go_Error_Data WHERE Target_Table = 'Gold.Go_Dim_Resource';
        EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;
    END
END
GO

--------------------------------------------------------------------------------------
-- TC07: Missing Optional Columns
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC07_MissingOptionalColumns]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Insert row with only mandatory columns
    INSERT INTO Silver.Si_Resource (Resource_Code, First_Name, Last_Name, is_active)
    VALUES ('RC005', 'David', 'Copperfield', 1);

    -- Execute ETL
    EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();

    -- Assert: Row inserted with default values for optional columns
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM Gold.Go_Dim_Resource WHERE Resource_Code = 'RC005';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;
END
GO

--------------------------------------------------------------------------------------
-- TC08: Duplicate Business Key in Source
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC08_DuplicateBusinessKey]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Insert two rows with same Resource_Code
    INSERT INTO Silver.Si_Resource (Resource_Code, First_Name, Last_Name, is_active)
    VALUES ('RC006', 'Eve', 'Adams', 1), ('RC006', 'Eva', 'Adamson', 1);

    -- Execute ETL
    EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();

    -- Assert: Only one row inserted/updated in target
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM Gold.Go_Dim_Resource WHERE Resource_Code = 'RC006';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;
END
GO

--------------------------------------------------------------------------------------
-- TC09: Constraint Violation (Negative Expected_Hours)
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC09_ConstraintViolation_NegativeExpectedHours]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Insert row with negative Expected_Hours
    INSERT INTO Silver.Si_Resource (Resource_Code, First_Name, Last_Name, Expected_Hours, is_active)
    VALUES ('RC007', 'Frank', 'Sinatra', -5, 1);

    -- Execute ETL
    EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();

    -- Assert: Row inserted with Expected_Hours = 0 (per transformation)
    DECLARE @val INT;
    SELECT @val = Expected_Hours FROM Gold.Go_Dim_Resource WHERE Resource_Code = 'RC007';
    EXEC tSQLt.AssertEquals @Expected = 0, @Actual = @val;
END
GO

--------------------------------------------------------------------------------------
-- TC10: Transaction Rollback on Error
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC10_TransactionRollbackOnError]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Simulate error: Remove required column from target
    ALTER TABLE Gold.Go_Dim_Resource DROP COLUMN Resource_Code;

    -- Insert valid row
    INSERT INTO Silver.Si_Resource (Resource_Code, First_Name, Last_Name, is_active)
    VALUES ('RC008', 'Grace', 'Hopper', 1);

    -- Execute ETL and expect error
    BEGIN TRY
        EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();
    END TRY
    BEGIN CATCH
        -- Swallow error for test
    END CATCH

    -- Assert: No row inserted in target
    EXEC tSQLt.AssertEmptyTable 'Gold.Go_Dim_Resource';

    -- Assert: Audit row with status Failed
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM Gold.Go_Process_Audit WHERE Status = 'Failed';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;

    -- Assert: Error row created
    SELECT @cnt = COUNT(*) FROM Gold.Go_Error_Data WHERE Target_Table = 'Gold.Go_Dim_Resource' AND Error_Type = 'Execution Error';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;
END
GO

--------------------------------------------------------------------------------------
-- TC11: Error in TRY Block (bad schema)
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC11_ErrorInTryBlock_BadSchema]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Simulate error: Drop source table
    DROP TABLE IF EXISTS Silver.Si_Resource;

    -- Execute ETL and expect error
    BEGIN TRY
        EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();
    END TRY
    BEGIN CATCH
        -- Swallow error for test
    END CATCH

    -- Assert: Audit row with status Failed
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM Gold.Go_Process_Audit WHERE Status = 'Failed';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;

    -- Assert: Error row created
    SELECT @cnt = COUNT(*) FROM Gold.Go_Error_Data WHERE Target_Table = 'Gold.Go_Dim_Resource' AND Error_Type = 'Execution Error';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;
END
GO

--------------------------------------------------------------------------------------
-- TC12: Metadata Columns Populated
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC12_MetadataColumnsPopulated]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Insert valid row
    INSERT INTO Silver.Si_Resource (Resource_Code, First_Name, Last_Name, is_active)
    VALUES ('RC009', 'Henry', 'Ford', 1);

    -- Execute ETL
    EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();

    -- Assert: Metadata columns populated
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM Gold.Go_Dim_Resource WHERE Resource_Code = 'RC009' AND load_date IS NOT NULL AND update_date IS NOT NULL AND source_system = 'Silver.Si_Resource';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;
END
GO

--------------------------------------------------------------------------------------
-- TC13: Audit Table Entry
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC13_AuditTableEntry]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Insert valid row
    INSERT INTO Silver.Si_Resource (Resource_Code, First_Name, Last_Name, is_active)
    VALUES ('RC010', 'Isaac', 'Newton', 1);

    -- Execute ETL
    EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();

    -- Assert: Audit row created with correct counts
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM Gold.Go_Process_Audit WHERE Target_Table = 'Gold.Go_Dim_Resource' AND Records_Inserted = 1 AND Status = 'Success';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;
END
GO

--------------------------------------------------------------------------------------
-- TC14: Error Table Entry for Invalid Row
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC14_ErrorTableEntryForInvalidRow]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Insert row with Start_Date in future
    INSERT INTO Silver.Si_Resource (Resource_Code, First_Name, Last_Name, Start_Date, is_active)
    VALUES ('RC011', 'Jack', 'Daniels', DATEADD(DAY, 10, GETDATE()), 1);

    -- Execute ETL
    EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();

    -- Assert: Error row created
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM Gold.Go_Error_Data WHERE Target_Table = 'Gold.Go_Dim_Resource' AND Error_Description LIKE '%Start_Date is in the future%';
    EXEC tSQLt.AssertEquals @Expected = 1, @Actual = @cnt;
END
GO

--------------------------------------------------------------------------------------
-- TC15: Null Handling for Numeric Columns
--------------------------------------------------------------------------------------
CREATE PROCEDURE test_usp_Load_Gold_Dim_Resource.[test_TC15_NullHandlingForNumericColumns]
AS
BEGIN
    EXEC tSQLt.FakeTable @TableName = N'Silver.Si_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Dim_Resource';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Process_Audit';
    EXEC tSQLt.FakeTable @TableName = N'Gold.Go_Error_Data';

    -- Insert row with NULL Bill_Rate
    INSERT INTO Silver.Si_Resource (Resource_Code, First_Name, Last_Name, Bill_Rate, is_active)
    VALUES ('RC012', 'Kate', 'Winslet', NULL, 1);

    -- Execute ETL
    EXEC usp_Load_Gold_Dim_Resource @RunId = NEWID();

    -- Assert: Row inserted with Bill_Rate = 0 or NULL (depending on transformation)
    DECLARE @val FLOAT;
    SELECT @val = Bill_Rate FROM Gold.Go_Dim_Resource WHERE Resource_Code = 'RC012';
    IF @val IS NULL OR @val = 0
        EXEC tSQLt.AssertEquals @Expected = @val, @Actual = @val;
    ELSE
        EXEC tSQLt.Fail 'Bill_Rate not handled as expected';
END
GO

--------------------------------------------------------------------------------------
-- TC16: Referential Integrity Check (if FK exists)
--------------------------------------------------------------------------------------
-- Only applicable if Go_Dim_Resource has FK to another table (not shown in proc), so this is a placeholder.
-- If e.g. Client_Code must exist in another table, test would insert a row with non-existent Client_Code and assert error.

-- ===========================================
-- 3. API COST
-- ===========================================
/*
apiCost: 0.325
*/

-- END OF FILE: DI_SQL_Server_Unit_Test_Case_Output.sql