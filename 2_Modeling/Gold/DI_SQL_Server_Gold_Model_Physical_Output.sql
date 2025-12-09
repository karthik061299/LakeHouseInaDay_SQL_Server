====================================================
Author:        AAVA
Date:          
Description:   Gold Layer Physical Data Model for Medallion Architecture - Resource Utilization and Workforce Management
====================================================

-- GOLD LAYER PHYSICAL DATA MODEL OUTPUT

-- 1. GOLD LAYER DDL SCRIPTS

-- 1.1. Dimension Tables

-- Table: Go_Dim_Resource
CREATE TABLE Gold.Go_Dim_Resource (
    [Resource_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Resource_Code] VARCHAR(50) NOT NULL,
    [First_Name] VARCHAR(50) NULL,
    [Last_Name] VARCHAR(50) NULL,
    [Job_Title] VARCHAR(50) NULL,
    [Business_Type] VARCHAR(50) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [Start_Date] DATE NULL,
    [Termination_Date] DATE NULL,
    [Project_Assignment] VARCHAR(200) NULL,
    [Market] VARCHAR(50) NULL,
    [Visa_Type] VARCHAR(50) NULL,
    [Practice_Type] VARCHAR(50) NULL,
    [Vertical] VARCHAR(50) NULL,
    [Status] VARCHAR(50) NULL,
    [Employee_Category] VARCHAR(50) NULL,
    [Portfolio_Leader] VARCHAR(100) NULL,
    [Expected_Hours] FLOAT NULL,
    [Available_Hours] FLOAT NULL,
    [Business_Area] VARCHAR(50) NULL,
    [SOW] VARCHAR(7) NULL,
    [Super_Merged_Name] VARCHAR(100) NULL,
    [New_Business_Type] VARCHAR(100) NULL,
    [Requirement_Region] VARCHAR(50) NULL,
    [Is_Offshore] VARCHAR(20) NULL,
    [Employee_Status] VARCHAR(50) NULL,
    [Termination_Reason] VARCHAR(100) NULL,
    [Tower] VARCHAR(60) NULL,
    [Circle] VARCHAR(100) NULL,
    [Community] VARCHAR(100) NULL,
    [Bill_Rate] DECIMAL(18,9) NULL,
    [Net_Bill_Rate] MONEY NULL,
    [GP] MONEY NULL,
    [GPM] MONEY NULL,
    [load_date] DATE NOT NULL DEFAULT GETDATE(),
    [update_date] DATE NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL,
    [data_quality_score] DECIMAL(5,2) NULL,
    [is_active] BIT NOT NULL DEFAULT 1
)

CREATE NONCLUSTERED INDEX IX_Go_Dim_Resource_ResourceCode 
    ON Gold.Go_Dim_Resource([Resource_Code]) 
    INCLUDE ([First_Name], [Last_Name], [Status])

CREATE NONCLUSTERED INDEX IX_Go_Dim_Resource_ClientCode 
    ON Gold.Go_Dim_Resource([Client_Code]) 
    INCLUDE ([Resource_Code], [Status])

CREATE NONCLUSTERED INDEX IX_Go_Dim_Resource_Active 
    ON Gold.Go_Dim_Resource([Resource_Code], [Status]) 
    WHERE [is_active] = 1 AND [Status] = 'Active'

-- Table: Go_Dim_Project
CREATE TABLE Gold.Go_Dim_Project (
    [Project_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Project_Name] VARCHAR(200) NOT NULL,
    [Client_Name] VARCHAR(60) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [Billing_Type] VARCHAR(50) NULL,
    [Category] VARCHAR(50) NULL,
    [Status] VARCHAR(50) NULL,
    [Project_City] VARCHAR(50) NULL,
    [Project_State] VARCHAR(50) NULL,
    [Opportunity_Name] VARCHAR(200) NULL,
    [Project_Type] VARCHAR(500) NULL,
    [Delivery_Leader] VARCHAR(50) NULL,
    [Circle] VARCHAR(100) NULL,
    [Market_Leader] VARCHAR(100) NULL,
    [Net_Bill_Rate] MONEY NULL,
    [Bill_Rate] DECIMAL(18,9) NULL,
    [Project_Start_Date] DATE NULL,
    [Project_End_Date] DATE NULL,
    [Client_Entity] VARCHAR(50) NULL,
    [Practice_Type] VARCHAR(50) NULL,
    [Community] VARCHAR(100) NULL,
    [Opportunity_ID] VARCHAR(50) NULL,
    [Timesheet_Manager] VARCHAR(255) NULL,
    [load_date] DATE NOT NULL DEFAULT GETDATE(),
    [update_date] DATE NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL,
    [data_quality_score] DECIMAL(5,2) NULL,
    [is_active] BIT NOT NULL DEFAULT 1
)

CREATE NONCLUSTERED INDEX IX_Go_Dim_Project_ProjectName 
    ON Gold.Go_Dim_Project([Project_Name]) 
    INCLUDE ([Client_Name], [Status], [Billing_Type])

CREATE NONCLUSTERED INDEX IX_Go_Dim_Project_ClientCode 
    ON Gold.Go_Dim_Project([Client_Code]) 
    INCLUDE ([Project_Name], [Status])

-- Table: Go_Dim_Date
CREATE TABLE Gold.Go_Dim_Date (
    [Date_ID] INT NOT NULL,
    [Calendar_Date] DATE NOT NULL,
    [Day_Name] VARCHAR(9) NULL,
    [Day_Of_Month] VARCHAR(2) NULL,
    [Week_Of_Year] VARCHAR(2) NULL,
    [Month_Name] VARCHAR(9) NULL,
    [Month_Number] VARCHAR(2) NULL,
    [Quarter] CHAR(1) NULL,
    [Quarter_Name] VARCHAR(9) NULL,
    [Year] CHAR(4) NULL,
    [Is_Working_Day] BIT NULL DEFAULT 1,
    [Is_Weekend] BIT NULL DEFAULT 0,
    [Month_Year] CHAR(10) NULL,
    [YYMM] VARCHAR(10) NULL,
    [load_date] DATE NOT NULL DEFAULT GETDATE(),
    [update_date] DATE NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL
)

CREATE NONCLUSTERED INDEX UX_Go_Dim_Date_CalendarDate 
    ON Gold.Go_Dim_Date([Calendar_Date])

CREATE NONCLUSTERED INDEX IX_Go_Dim_Date_Year 
    ON Gold.Go_Dim_Date([Year]) 
    INCLUDE ([Calendar_Date], [Month_Number])

-- Table: Go_Dim_Holiday
CREATE TABLE Gold.Go_Dim_Holiday (
    [Holiday_ID] INT IDENTITY(1,1) NOT NULL,
    [Holiday_Date] DATE NOT NULL,
    [Description] VARCHAR(100) NULL,
    [Location] VARCHAR(50) NULL,
    [Source_Type] VARCHAR(50) NULL,
    [load_date] DATE NOT NULL DEFAULT GETDATE(),
    [update_date] DATE NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL
)

CREATE NONCLUSTERED INDEX IX_Go_Dim_Holiday_Date 
    ON Gold.Go_Dim_Holiday([Holiday_Date]) 
    INCLUDE ([Location], [Description])

CREATE NONCLUSTERED INDEX IX_Go_Dim_Holiday_DateLocation 
    ON Gold.Go_Dim_Holiday([Holiday_Date], [Location]) 
    INCLUDE ([Description])

-- Table: Go_Dim_Workflow_Task
CREATE TABLE Gold.Go_Dim_Workflow_Task (
    [Workflow_Task_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Candidate_Name] VARCHAR(100) NULL,
    [Resource_Code] VARCHAR(50) NULL,
    [Workflow_Task_Reference] NUMERIC(18,0) NULL,
    [Type] VARCHAR(50) NULL,
    [Tower] VARCHAR(60) NULL,
    [Status] VARCHAR(50) NULL,
    [Comments] VARCHAR(8000) NULL,
    [Date_Created] DATE NULL,
    [Date_Completed] DATE NULL,
    [Process_Name] VARCHAR(100) NULL,
    [Level_ID] INT NULL,
    [Last_Level] INT NULL,
    [load_date] DATE NOT NULL DEFAULT GETDATE(),
    [update_date] DATE NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL,
    [data_quality_score] DECIMAL(5,2) NULL
)

CREATE NONCLUSTERED INDEX IX_Go_Dim_Workflow_Task_ResourceCode 
    ON Gold.Go_Dim_Workflow_Task([Resource_Code]) 
    INCLUDE ([Status], [Date_Created], [Process_Name])

-- 1.2. Fact Tables

-- Table: Go_Fact_Timesheet_Entry
CREATE TABLE Gold.Go_Fact_Timesheet_Entry (
    [Timesheet_Entry_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Resource_Code] VARCHAR(50) NOT NULL,
    [Timesheet_Date] DATE NOT NULL,
    [Project_Task_Reference] NUMERIC(18,9) NULL,
    [Standard_Hours] FLOAT NULL DEFAULT 0,
    [Overtime_Hours] FLOAT NULL DEFAULT 0,
    [Double_Time_Hours] FLOAT NULL DEFAULT 0,
    [Sick_Time_Hours] FLOAT NULL DEFAULT 0,
    [Holiday_Hours] FLOAT NULL DEFAULT 0,
    [Time_Off_Hours] FLOAT NULL DEFAULT 0,
    [Non_Standard_Hours] FLOAT NULL DEFAULT 0,
    [Non_Overtime_Hours] FLOAT NULL DEFAULT 0,
    [Non_Double_Time_Hours] FLOAT NULL DEFAULT 0,
    [Non_Sick_Time_Hours] FLOAT NULL DEFAULT 0,
    [Creation_Date] DATE NULL,
    [Total_Hours] FLOAT NULL,
    [Total_Billable_Hours] FLOAT NULL,
    [load_date] DATE NOT NULL DEFAULT GETDATE(),
    [update_date] DATE NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL,
    [data_quality_score] DECIMAL(5,2) NULL,
    [is_validated] BIT NOT NULL DEFAULT 0
)

CREATE NONCLUSTERED INDEX IX_Go_Fact_Timesheet_Entry_ResourceCode 
    ON Gold.Go_Fact_Timesheet_Entry([Resource_Code], [Timesheet_Date]) 
    INCLUDE ([Standard_Hours], [Overtime_Hours])

CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_Go_Fact_Timesheet_Entry_Analytics 
    ON Gold.Go_Fact_Timesheet_Entry(
        [Resource_Code], [Timesheet_Date], [Standard_Hours], [Overtime_Hours],
        [Total_Hours], [Total_Billable_Hours]
    )

-- Table: Go_Fact_Timesheet_Approval
CREATE TABLE Gold.Go_Fact_Timesheet_Approval (
    [Approval_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Resource_Code] VARCHAR(50) NOT NULL,
    [Timesheet_Date] DATE NOT NULL,
    [Week_Date] DATE NULL,
    [Approved_Standard_Hours] FLOAT NULL DEFAULT 0,
    [Approved_Overtime_Hours] FLOAT NULL DEFAULT 0,
    [Approved_Double_Time_Hours] FLOAT NULL DEFAULT 0,
    [Approved_Sick_Time_Hours] FLOAT NULL DEFAULT 0,
    [Billing_Indicator] VARCHAR(3) NULL,
    [Consultant_Standard_Hours] FLOAT NULL DEFAULT 0,
    [Consultant_Overtime_Hours] FLOAT NULL DEFAULT 0,
    [Consultant_Double_Time_Hours] FLOAT NULL DEFAULT 0,
    [Total_Approved_Hours] FLOAT NULL,
    [Hours_Variance] FLOAT NULL,
    [load_date] DATE NOT NULL DEFAULT GETDATE(),
    [update_date] DATE NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL,
    [data_quality_score] DECIMAL(5,2) NULL,
    [approval_status] VARCHAR(50) NULL DEFAULT 'Approved'
)

CREATE NONCLUSTERED INDEX IX_Go_Fact_Timesheet_Approval_ResourceCode 
    ON Gold.Go_Fact_Timesheet_Approval([Resource_Code], [Timesheet_Date]) 
    INCLUDE ([Approved_Standard_Hours], [Billing_Indicator])

CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_Go_Fact_Timesheet_Approval_Analytics 
    ON Gold.Go_Fact_Timesheet_Approval(
        [Resource_Code], [Timesheet_Date], [Week_Date], [Approved_Standard_Hours],
        [Total_Approved_Hours], [Billing_Indicator]
    )

-- 1.3. Aggregated Tables

-- Table: Go_Agg_Resource_Utilization
CREATE TABLE Gold.Go_Agg_Resource_Utilization (
    [Agg_Utilization_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Resource_Code] VARCHAR(50) NOT NULL,
    [Project_Name] VARCHAR(200) NOT NULL,
    [Calendar_Date] DATE NOT NULL,
    [Total_Hours] FLOAT NULL,
    [Submitted_Hours] FLOAT NULL,
    [Approved_Hours] FLOAT NULL,
    [Total_FTE] FLOAT NULL,
    [Billed_FTE] FLOAT NULL,
    [Project_Utilization] FLOAT NULL,
    [Available_Hours] FLOAT NULL,
    [Actual_Hours] FLOAT NULL,
    [Onsite_Hours] FLOAT NULL,
    [Offsite_Hours] FLOAT NULL,
    [load_date] DATE NOT NULL DEFAULT GETDATE(),
    [update_date] DATE NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL
)

CREATE NONCLUSTERED INDEX IX_Go_Agg_Resource_Utilization_ResourceCode 
    ON Gold.Go_Agg_Resource_Utilization([Resource_Code], [Project_Name], [Calendar_Date])

-- 1.4. Error Data Table

CREATE TABLE Gold.Go_Error_Data (
    [Error_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Source_Table] VARCHAR(200) NULL,
    [Target_Table] VARCHAR(200) NULL,
    [Record_Identifier] VARCHAR(500) NULL,
    [Error_Type] VARCHAR(100) NULL,
    [Error_Category] VARCHAR(100) NULL,
    [Error_Description] VARCHAR(1000) NULL,
    [Field_Name] VARCHAR(200) NULL,
    [Field_Value] VARCHAR(500) NULL,
    [Expected_Value] VARCHAR(500) NULL,
    [Business_Rule] VARCHAR(500) NULL,
    [Severity_Level] VARCHAR(50) NULL,
    [Error_Date] DATE NOT NULL DEFAULT GETDATE(),
    [Batch_ID] VARCHAR(100) NULL,
    [Processing_Stage] VARCHAR(100) NULL,
    [Resolution_Status] VARCHAR(50) NULL DEFAULT 'Open',
    [Resolution_Notes] VARCHAR(1000) NULL,
    [Created_By] VARCHAR(100) NULL,
    [Created_Date] DATE NOT NULL DEFAULT GETDATE(),
    [Modified_Date] DATE NULL
)

CREATE NONCLUSTERED INDEX IX_Go_Error_Data_SourceTable 
    ON Gold.Go_Error_Data([Source_Table]) 
    INCLUDE ([Error_Date], [Severity_Level], [Resolution_Status])

CREATE NONCLUSTERED INDEX IX_Go_Error_Data_ErrorDate 
    ON Gold.Go_Error_Data([Error_Date]) 
    INCLUDE ([Source_Table], [Severity_Level])

CREATE NONCLUSTERED INDEX IX_Go_Error_Data_SeverityLevel 
    ON Gold.Go_Error_Data([Severity_Level]) 
    INCLUDE ([Error_Date], [Resolution_Status])

-- 1.5. Audit Table

CREATE TABLE Gold.Go_Process_Audit (
    [Audit_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Pipeline_Name] VARCHAR(200) NOT NULL,
    [Pipeline_Run_ID] VARCHAR(100) NOT NULL,
    [Source_System] VARCHAR(100) NULL,
    [Source_Table] VARCHAR(200) NULL,
    [Target_Table] VARCHAR(200) NULL,
    [Processing_Type] VARCHAR(50) NULL,
    [Start_Time] DATE NOT NULL DEFAULT GETDATE(),
    [End_Time] DATE NULL,
    [Duration_Seconds] DECIMAL(10,2) NULL,
    [Status] VARCHAR(50) NULL DEFAULT 'Running',
    [Records_Read] BIGINT NULL DEFAULT 0,
    [Records_Processed] BIGINT NULL DEFAULT 0,
    [Records_Inserted] BIGINT NULL DEFAULT 0,
    [Records_Updated] BIGINT NULL DEFAULT 0,
    [Records_Deleted] BIGINT NULL DEFAULT 0,
    [Records_Rejected] BIGINT NULL DEFAULT 0,
    [Data_Quality_Score] DECIMAL(5,2) NULL,
    [Transformation_Rules_Applied] VARCHAR(1000) NULL,
    [Business_Rules_Applied] VARCHAR(1000) NULL,
    [Error_Count] INT NULL DEFAULT 0,
    [Warning_Count] INT NULL DEFAULT 0,
    [Error_Message] VARCHAR(MAX) NULL,
    [Checkpoint_Data] VARCHAR(MAX) NULL,
    [Resource_Utilization] VARCHAR(500) NULL,
    [Data_Lineage] VARCHAR(1000) NULL,
    [Executed_By] VARCHAR(100) NULL,
    [Environment] VARCHAR(50) NULL,
    [Version] VARCHAR(50) NULL,
    [Configuration] VARCHAR(MAX) NULL,
    [Created_Date] DATE NOT NULL DEFAULT GETDATE(),
    [Modified_Date] DATE NULL
)

CREATE NONCLUSTERED INDEX IX_Go_Process_Audit_PipelineName 
    ON Gold.Go_Process_Audit([Pipeline_Name]) 
    INCLUDE ([Start_Time], [Status], [Duration_Seconds])

CREATE NONCLUSTERED INDEX IX_Go_Process_Audit_StartTime 
    ON Gold.Go_Process_Audit([Start_Time]) 
    INCLUDE ([Pipeline_Name], [Status])

CREATE NONCLUSTERED INDEX IX_Go_Process_Audit_Status 
    ON Gold.Go_Process_Audit([Status]) 
    INCLUDE ([Pipeline_Name], [Start_Time])

-- 1.6. Update DDL Scripts

-- Add data_quality_score to Go_Dim_Resource
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Gold.Go_Dim_Resource') AND name = 'data_quality_score')
BEGIN
    ALTER TABLE Gold.Go_Dim_Resource ADD [data_quality_score] DECIMAL(5,2) NULL
END

-- Add is_validated to Go_Fact_Timesheet_Entry
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Gold.Go_Fact_Timesheet_Entry') AND name = 'is_validated')
BEGIN
    ALTER TABLE Gold.Go_Fact_Timesheet_Entry ADD [is_validated] BIT NOT NULL DEFAULT 0
END

-- Add data_quality_score to Go_Dim_Workflow_Task
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Gold.Go_Dim_Workflow_Task') AND name = 'data_quality_score')
BEGIN
    ALTER TABLE Gold.Go_Dim_Workflow_Task ADD [data_quality_score] DECIMAL(5,2) NULL
END

-- 2. DATA RETENTION POLICIES

-- Gold Layer Data Retention
-- Active Data: 5 years in Gold layer
-- Archive Data: Move to cold storage after 3 years
-- Purge Data: Delete after 7 years (compliance requirement)

-- Archiving Strategy
-- a) Timesheet Data (Go_Fact_Timesheet_Entry, Go_Fact_Timesheet_Approval)
-- Archive records older than 3 years to archive tables
-- Create monthly archive tables: Go_Fact_Timesheet_Entry_Archive_YYYYMM
-- Maintain indexes on archive tables for query performance
-- Implement partitioned views for seamless querying

-- b) Resource Data (Go_Dim_Resource)
-- Archive terminated resources after 5 years
-- Maintain active resources indefinitely
-- Create archive table: Go_Dim_Resource_Archive

-- c) Project Data (Go_Dim_Project)
-- Archive completed projects after 5 years
-- Maintain active projects indefinitely
-- Create archive table: Go_Dim_Project_Archive

-- d) Workflow Data (Go_Dim_Workflow_Task)
-- Archive completed workflows after 2 years
-- Create archive table: Go_Dim_Workflow_Task_Archive

-- Audit and Error Data Retention
-- Go_Process_Audit: Retain for 7 years (compliance)
-- Go_Error_Data: Retain for 7 years (compliance)
-- Archive to cold storage after 4 years

-- Dimension Data Retention
-- Go_Dim_Date: Maintain indefinitely (small size)
-- Go_Dim_Holiday: Maintain indefinitely (small size)

-- Archiving Implementation
-- Use SQL Server Agent jobs for automated archiving
-- Schedule: Monthly on 1st day of month at 2:00 AM
-- Implement transaction log backups before archiving
-- Validate data integrity after archiving
-- Maintain audit trail of archiving operations

-- Restore Strategy
-- Archived data can be restored to Gold layer on demand
-- Restore time: 4-8 hours depending on data volume
-- Implement partitioned views for transparent access

-- 3. CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORM)

-- Relationship Matrix
-- | Table                  | Related Table           | Relationship Key Field(s)                | Relationship Description |
-- |------------------------|------------------------|------------------------------------------|-------------------------|
-- | Go_Dim_Resource        | Go_Fact_Timesheet_Entry| Resource_Code                            | One resource can have many timesheet entries |
-- | Go_Dim_Resource        | Go_Fact_Timesheet_Approval | Resource_Code                        | One resource can have many timesheet approvals |
-- | Go_Dim_Resource        | Go_Dim_Workflow_Task   | Resource_Code                            | One resource can have many workflow tasks |
-- | Go_Dim_Project         | Go_Fact_Timesheet_Entry| Project_Task_Reference                   | One project can have many timesheet entries |
-- | Go_Dim_Project         | Go_Agg_Resource_Utilization | Project_Name                         | One project can have many utilization records |
-- | Go_Fact_Timesheet_Entry| Go_Dim_Date            | Timesheet_Date = Calendar_Date           | Many timesheet entries can occur on one date |
-- | Go_Fact_Timesheet_Entry| Go_Fact_Timesheet_Approval | Resource_Code + Timesheet_Date       | One-to-one for timesheet approval |
-- | Go_Fact_Timesheet_Approval | Go_Dim_Date         | Timesheet_Date = Calendar_Date           | Many approvals can occur on one date |
-- | Go_Dim_Date            | Go_Dim_Holiday         | Calendar_Date = Holiday_Date             | One date can have multiple holidays |
-- | Go_Dim_Workflow_Task   | Go_Dim_Resource        | Resource_Code                            | Many workflow tasks belong to one resource |
-- | Go_Dim_Holiday         | Go_Dim_Date            | Holiday_Date = Calendar_Date             | Many holidays can reference one calendar date |
-- | Go_Agg_Resource_Utilization | Go_Dim_Resource   | Resource_Code                            | Aggregated utilization by resource |
-- | Go_Agg_Resource_Utilization | Go_Dim_Project    | Project_Name                             | Aggregated utilization by project |
-- | Go_Agg_Resource_Utilization | Go_Dim_Date       | Calendar_Date                            | Aggregated utilization by date |

-- 4. ER DIAGRAM VISUALIZATION GRAPH
-- (Textual Representation)
-- [Go_Dim_Resource]---(Resource_Code)--->[Go_Fact_Timesheet_Entry]
-- [Go_Dim_Resource]---(Resource_Code)--->[Go_Fact_Timesheet_Approval]
-- [Go_Dim_Resource]---(Resource_Code)--->[Go_Dim_Workflow_Task]
-- [Go_Dim_Project]---(Project_Task_Reference)--->[Go_Fact_Timesheet_Entry]
-- [Go_Dim_Project]---(Project_Name)--->[Go_Agg_Resource_Utilization]
-- [Go_Fact_Timesheet_Entry]---(Timesheet_Date)--->[Go_Dim_Date]
-- [Go_Fact_Timesheet_Entry]---(Resource_Code+Timesheet_Date)--->[Go_Fact_Timesheet_Approval]
-- [Go_Fact_Timesheet_Approval]---(Timesheet_Date)--->[Go_Dim_Date]
-- [Go_Dim_Date]---(Calendar_Date)--->[Go_Dim_Holiday]
-- [Go_Dim_Workflow_Task]---(Resource_Code)--->[Go_Dim_Resource]
-- [Go_Dim_Holiday]---(Holiday_Date)--->[Go_Dim_Date]
-- [Go_Agg_Resource_Utilization]---(Resource_Code)--->[Go_Dim_Resource]
-- [Go_Agg_Resource_Utilization]---(Project_Name)--->[Go_Dim_Project]
-- [Go_Agg_Resource_Utilization]---(Calendar_Date)--->[Go_Dim_Date]

-- 5. API COST
-- apiCost: 0.03 USD
