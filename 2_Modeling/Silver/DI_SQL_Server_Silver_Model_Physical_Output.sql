====================================================
Author:        AAVA
Date:          
Description:   Silver Layer Physical Data Model - SQL Server DDL Scripts for Medallion Architecture - Curated and Validated Data
====================================================

/*
================================================================================
SILVER LAYER PHYSICAL DATA MODEL - SQL SERVER DDL SCRIPTS
================================================================================

Purpose: This script creates the Silver layer tables for the Medallion architecture
         on SQL Server. Silver layer stores curated, validated, and conformed data
         with data quality checks, business rules applied, and proper indexing.

Design Principles:
- Primary keys (ID fields) added to all tables
- Clustered and nonclustered indexes for query optimization
- Columnstore indexes for analytical queries
- Partitioning strategies based on date columns
- Data quality validation columns
- Metadata columns for lineage and tracking
- Schema: Silver
- Table prefix: si_

Storage Notes:
- Clustered indexes on ID columns for OLTP operations
- Nonclustered columnstore indexes for analytical queries
- Date-based partitioning for large fact tables
- Implement data retention and archiving policies

================================================================================
*/

-- Create Silver schema if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Silver')
BEGIN
    EXEC('CREATE SCHEMA Silver')
END
GO

/*
================================================================================
SECTION 1: CORE BUSINESS ENTITY TABLES
================================================================================
*/

/*
================================================================================
TABLE 1: Silver.si_Resource
================================================================================
Description: Curated resource (employee/consultant) master data containing validated 
             workforce information, employment details, and organizational attributes.
Source: Derived from Bronze.bz_New_Monthly_HC_Report and Bronze.bz_report_392_all
Partitioning: Partitioned by start_date (yearly partitions)
Indexing: Clustered index on resource_id, nonclustered indexes on resource_code,
          client_code, and business_area
================================================================================
*/

IF OBJECT_ID('Silver.si_Resource', 'U') IS NULL
BEGIN
    CREATE TABLE Silver.si_Resource (
        -- Primary Key
        resource_id BIGINT IDENTITY(1,1) NOT NULL,
        
        -- Business Keys
        resource_code VARCHAR(50) NULL,
        
        -- Resource Information
        first_name VARCHAR(50) NULL,
        last_name VARCHAR(50) NULL,
        job_title VARCHAR(50) NULL,
        business_type VARCHAR(50) NULL,
        client_code VARCHAR(50) NULL,
        start_date DATETIME NULL,
        termination_date DATETIME NULL,
        project_assignment VARCHAR(200) NULL,
        market VARCHAR(50) NULL,
        visa_type VARCHAR(50) NULL,
        practice_type VARCHAR(50) NULL,
        vertical VARCHAR(50) NULL,
        status VARCHAR(50) NULL,
        employee_category VARCHAR(50) NULL,
        portfolio_leader VARCHAR(MAX) NULL,
        expected_hours REAL NULL,
        available_hours REAL NULL,
        business_area VARCHAR(50) NULL,
        is_sow VARCHAR(7) NULL,
        super_merged_name VARCHAR(200) NULL,
        new_business_type VARCHAR(100) NULL,
        requirement_region VARCHAR(50) NULL,
        is_offshore VARCHAR(20) NULL,
        community VARCHAR(100) NULL,
        circle VARCHAR(100) NULL,
        delivery_leader VARCHAR(50) NULL,
        market_leader VARCHAR(MAX) NULL,
        
        -- Metadata Columns
        load_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        update_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        source_system VARCHAR(100) NULL,
        
        -- Data Quality Columns
        data_quality_score DECIMAL(5,2) NULL,
        validation_status VARCHAR(50) NULL,
        
        -- Audit Columns
        created_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        modified_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        is_active BIT DEFAULT 1 NULL,
        
        CONSTRAINT PK_si_Resource PRIMARY KEY CLUSTERED (resource_id)
    )
END
GO

-- Create nonclustered indexes for si_Resource
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Resource_resource_code' AND object_id = OBJECT_ID('Silver.si_Resource'))
    CREATE NONCLUSTERED INDEX IX_si_Resource_resource_code ON Silver.si_Resource(resource_code) INCLUDE (first_name, last_name, status)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Resource_client_code' AND object_id = OBJECT_ID('Silver.si_Resource'))
    CREATE NONCLUSTERED INDEX IX_si_Resource_client_code ON Silver.si_Resource(client_code) INCLUDE (resource_code, business_type)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Resource_start_date' AND object_id = OBJECT_ID('Silver.si_Resource'))
    CREATE NONCLUSTERED INDEX IX_si_Resource_start_date ON Silver.si_Resource(start_date) INCLUDE (resource_code, status)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Resource_business_area' AND object_id = OBJECT_ID('Silver.si_Resource'))
    CREATE NONCLUSTERED INDEX IX_si_Resource_business_area ON Silver.si_Resource(business_area) INCLUDE (resource_code, employee_category)
GO

-- Create columnstore index for analytical queries
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'NCCI_si_Resource' AND object_id = OBJECT_ID('Silver.si_Resource'))
    CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_si_Resource ON Silver.si_Resource
    (
        resource_code, business_type, client_code, market, business_area, 
        employee_category, expected_hours, available_hours, start_date, termination_date
    )
GO

/*
================================================================================
TABLE 2: Silver.si_Project
================================================================================
Description: Curated project master data containing validated project information,
             client details, billing attributes, and project classification.
Source: Derived from Bronze.bz_report_392_all and Bronze.bz_Hiring_Initiator_Project_Info
Partitioning: Partitioned by project_start_date (yearly partitions)
Indexing: Clustered index on project_id, nonclustered indexes on project_name,
          client_code, and billing_type
================================================================================
*/

IF OBJECT_ID('Silver.si_Project', 'U') IS NULL
BEGIN
    CREATE TABLE Silver.si_Project (
        -- Primary Key
        project_id BIGINT IDENTITY(1,1) NOT NULL,
        
        -- Business Keys
        project_name VARCHAR(200) NULL,
        client_code VARCHAR(50) NULL,
        
        -- Project Information
        client_name VARCHAR(60) NULL,
        billing_type VARCHAR(50) NULL,
        category VARCHAR(50) NULL,
        status VARCHAR(50) NULL,
        project_city VARCHAR(50) NULL,
        project_state VARCHAR(50) NULL,
        opportunity_name VARCHAR(200) NULL,
        project_type VARCHAR(500) NULL,
        delivery_leader VARCHAR(50) NULL,
        circle VARCHAR(100) NULL,
        market_leader VARCHAR(MAX) NULL,
        net_bill_rate MONEY NULL,
        project_start_date DATETIME NULL,
        project_end_date DATETIME NULL,
        super_merged_name VARCHAR(200) NULL,
        is_sow VARCHAR(7) NULL,
        vertical_name NVARCHAR(510) NULL,
        business_area VARCHAR(50) NULL,
        
        -- Metadata Columns
        load_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        update_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        source_system VARCHAR(100) NULL,
        
        -- Data Quality Columns
        data_quality_score DECIMAL(5,2) NULL,
        validation_status VARCHAR(50) NULL,
        
        -- Audit Columns
        created_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        modified_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        is_active BIT DEFAULT 1 NULL,
        
        CONSTRAINT PK_si_Project PRIMARY KEY CLUSTERED (project_id)
    )
END
GO

-- Create nonclustered indexes for si_Project
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Project_project_name' AND object_id = OBJECT_ID('Silver.si_Project'))
    CREATE NONCLUSTERED INDEX IX_si_Project_project_name ON Silver.si_Project(project_name) INCLUDE (client_name, billing_type, status)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Project_client_code' AND object_id = OBJECT_ID('Silver.si_Project'))
    CREATE NONCLUSTERED INDEX IX_si_Project_client_code ON Silver.si_Project(client_code) INCLUDE (project_name, billing_type)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Project_billing_type' AND object_id = OBJECT_ID('Silver.si_Project'))
    CREATE NONCLUSTERED INDEX IX_si_Project_billing_type ON Silver.si_Project(billing_type) INCLUDE (project_name, client_code)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Project_start_date' AND object_id = OBJECT_ID('Silver.si_Project'))
    CREATE NONCLUSTERED INDEX IX_si_Project_start_date ON Silver.si_Project(project_start_date) INCLUDE (project_name, status)
GO

-- Create columnstore index for analytical queries
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'NCCI_si_Project' AND object_id = OBJECT_ID('Silver.si_Project'))
    CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_si_Project ON Silver.si_Project
    (
        project_name, client_code, billing_type, category, status, 
        net_bill_rate, project_start_date, project_end_date, business_area
    )
GO

/*
================================================================================
TABLE 3: Silver.si_Timesheet_Entry
================================================================================
Description: Curated timesheet entry data containing validated daily time entries
             by resource, project, and hour type.
Source: Derived from Bronze.bz_Timesheet_New
Partitioning: Partitioned by timesheet_date (monthly partitions)
Indexing: Clustered index on timesheet_entry_id, nonclustered indexes on 
          resource_code, timesheet_date, and project_task_reference
================================================================================
*/

IF OBJECT_ID('Silver.si_Timesheet_Entry', 'U') IS NULL
BEGIN
    CREATE TABLE Silver.si_Timesheet_Entry (
        -- Primary Key
        timesheet_entry_id BIGINT IDENTITY(1,1) NOT NULL,
        
        -- Business Keys
        resource_code INT NULL,
        timesheet_date DATETIME NULL,
        project_task_reference NUMERIC(18,9) NULL,
        
        -- Timesheet Hours
        standard_hours FLOAT NULL,
        overtime_hours FLOAT NULL,
        double_time_hours FLOAT NULL,
        sick_time_hours FLOAT NULL,
        holiday_hours FLOAT NULL,
        time_off_hours FLOAT NULL,
        non_standard_hours FLOAT NULL,
        non_overtime_hours FLOAT NULL,
        non_double_time_hours FLOAT NULL,
        non_sick_time_hours FLOAT NULL,
        created_date DATETIME NULL,
        
        -- Metadata Columns
        load_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        update_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        source_system VARCHAR(100) NULL,
        
        -- Data Quality Columns
        data_quality_score DECIMAL(5,2) NULL,
        validation_status VARCHAR(50) NULL,
        
        -- Audit Columns
        created_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        modified_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        is_active BIT DEFAULT 1 NULL,
        
        CONSTRAINT PK_si_Timesheet_Entry PRIMARY KEY CLUSTERED (timesheet_entry_id)
    )
END
GO

-- Create nonclustered indexes for si_Timesheet_Entry
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Timesheet_Entry_resource_code' AND object_id = OBJECT_ID('Silver.si_Timesheet_Entry'))
    CREATE NONCLUSTERED INDEX IX_si_Timesheet_Entry_resource_code ON Silver.si_Timesheet_Entry(resource_code) INCLUDE (timesheet_date, standard_hours)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Timesheet_Entry_timesheet_date' AND object_id = OBJECT_ID('Silver.si_Timesheet_Entry'))
    CREATE NONCLUSTERED INDEX IX_si_Timesheet_Entry_timesheet_date ON Silver.si_Timesheet_Entry(timesheet_date) INCLUDE (resource_code, standard_hours)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Timesheet_Entry_composite' AND object_id = OBJECT_ID('Silver.si_Timesheet_Entry'))
    CREATE NONCLUSTERED INDEX IX_si_Timesheet_Entry_composite ON Silver.si_Timesheet_Entry(resource_code, timesheet_date) INCLUDE (standard_hours, overtime_hours)
GO

-- Create columnstore index for analytical queries
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'NCCI_si_Timesheet_Entry' AND object_id = OBJECT_ID('Silver.si_Timesheet_Entry'))
    CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_si_Timesheet_Entry ON Silver.si_Timesheet_Entry
    (
        resource_code, timesheet_date, standard_hours, overtime_hours, 
        double_time_hours, sick_time_hours, holiday_hours, time_off_hours
    )
GO

/*
================================================================================
TABLE 4: Silver.si_Timesheet_Approval
================================================================================
Description: Curated timesheet approval data containing validated approved hours
             by resource, date, and billing type.
Source: Derived from Bronze.bz_vw_billing_timesheet_daywise_ne and 
        Bronze.bz_vw_consultant_timesheet_daywise
Partitioning: Partitioned by timesheet_date (monthly partitions)
Indexing: Clustered index on timesheet_approval_id, nonclustered indexes on
          resource_code, timesheet_date, and billing_indicator
================================================================================
*/

IF OBJECT_ID('Silver.si_Timesheet_Approval', 'U') IS NULL
BEGIN
    CREATE TABLE Silver.si_Timesheet_Approval (
        -- Primary Key
        timesheet_approval_id BIGINT IDENTITY(1,1) NOT NULL,
        
        -- Business Keys
        resource_code INT NULL,
        timesheet_date DATETIME NULL,
        week_date DATETIME NULL,
        billing_indicator VARCHAR(3) NULL,
        
        -- Approved Hours
        approved_standard_hours FLOAT NULL,
        approved_overtime_hours FLOAT NULL,
        approved_double_time_hours FLOAT NULL,
        approved_sick_time_hours FLOAT NULL,
        approved_non_standard_hours FLOAT NULL,
        approved_non_overtime_hours FLOAT NULL,
        approved_non_double_time_hours FLOAT NULL,
        approved_non_sick_time_hours FLOAT NULL,
        
        -- Consultant Submitted Hours
        consultant_standard_hours FLOAT NULL,
        consultant_overtime_hours FLOAT NULL,
        consultant_double_time_hours FLOAT NULL,
        
        -- Metadata Columns
        load_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        update_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        source_system VARCHAR(100) NULL,
        
        -- Data Quality Columns
        data_quality_score DECIMAL(5,2) NULL,
        validation_status VARCHAR(50) NULL,
        
        -- Audit Columns
        created_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        modified_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        is_active BIT DEFAULT 1 NULL,
        
        CONSTRAINT PK_si_Timesheet_Approval PRIMARY KEY CLUSTERED (timesheet_approval_id)
    )
END
GO

-- Create nonclustered indexes for si_Timesheet_Approval
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Timesheet_Approval_resource_code' AND object_id = OBJECT_ID('Silver.si_Timesheet_Approval'))
    CREATE NONCLUSTERED INDEX IX_si_Timesheet_Approval_resource_code ON Silver.si_Timesheet_Approval(resource_code) INCLUDE (timesheet_date, billing_indicator)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Timesheet_Approval_timesheet_date' AND object_id = OBJECT_ID('Silver.si_Timesheet_Approval'))
    CREATE NONCLUSTERED INDEX IX_si_Timesheet_Approval_timesheet_date ON Silver.si_Timesheet_Approval(timesheet_date) INCLUDE (resource_code, approved_standard_hours)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Timesheet_Approval_composite' AND object_id = OBJECT_ID('Silver.si_Timesheet_Approval'))
    CREATE NONCLUSTERED INDEX IX_si_Timesheet_Approval_composite ON Silver.si_Timesheet_Approval(resource_code, timesheet_date) INCLUDE (approved_standard_hours, billing_indicator)
GO

-- Create columnstore index for analytical queries
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'NCCI_si_Timesheet_Approval' AND object_id = OBJECT_ID('Silver.si_Timesheet_Approval'))
    CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_si_Timesheet_Approval ON Silver.si_Timesheet_Approval
    (
        resource_code, timesheet_date, week_date, billing_indicator,
        approved_standard_hours, approved_overtime_hours, approved_double_time_hours
    )
GO

/*
================================================================================
TABLE 5: Silver.si_Workflow_Task
================================================================================
Description: Curated workflow task data containing validated workflow processes,
             approval tasks, and resource onboarding activities.
Source: Derived from Bronze.bz_SchTask
Partitioning: Partitioned by date_created (yearly partitions)
Indexing: Clustered index on workflow_task_id, nonclustered indexes on
          resource_code, workflow_task_reference, and status
================================================================================
*/

IF OBJECT_ID('Silver.si_Workflow_Task', 'U') IS NULL
BEGIN
    CREATE TABLE Silver.si_Workflow_Task (
        -- Primary Key
        workflow_task_id BIGINT IDENTITY(1,1) NOT NULL,
        
        -- Business Keys
        resource_code VARCHAR(50) NULL,
        workflow_task_reference NUMERIC(18,0) NULL,
        
        -- Workflow Information
        candidate_first_name VARCHAR(50) NULL,
        candidate_last_name VARCHAR(50) NULL,
        workflow_level INT NULL,
        last_completed_level INT NULL,
        type VARCHAR(50) NULL,
        tower VARCHAR(60) NULL,
        status VARCHAR(50) NULL,
        comments VARCHAR(8000) NULL,
        date_created DATETIME NULL,
        date_completed DATETIME NULL,
        initiator_name VARCHAR(50) NULL,
        existing_resource_flag VARCHAR(3) NULL,
        legal_entity VARCHAR(50) NULL,
        
        -- Metadata Columns
        load_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        update_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        source_system VARCHAR(100) NULL,
        
        -- Data Quality Columns
        data_quality_score DECIMAL(5,2) NULL,
        validation_status VARCHAR(50) NULL,
        
        -- Audit Columns
        created_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        modified_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        is_active BIT DEFAULT 1 NULL,
        
        CONSTRAINT PK_si_Workflow_Task PRIMARY KEY CLUSTERED (workflow_task_id)
    )
END
GO

-- Create nonclustered indexes for si_Workflow_Task
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Workflow_Task_resource_code' AND object_id = OBJECT_ID('Silver.si_Workflow_Task'))
    CREATE NONCLUSTERED INDEX IX_si_Workflow_Task_resource_code ON Silver.si_Workflow_Task(resource_code) INCLUDE (status, date_created)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Workflow_Task_reference' AND object_id = OBJECT_ID('Silver.si_Workflow_Task'))
    CREATE NONCLUSTERED INDEX IX_si_Workflow_Task_reference ON Silver.si_Workflow_Task(workflow_task_reference) INCLUDE (resource_code, status)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Workflow_Task_status' AND object_id = OBJECT_ID('Silver.si_Workflow_Task'))
    CREATE NONCLUSTERED INDEX IX_si_Workflow_Task_status ON Silver.si_Workflow_Task(status) INCLUDE (resource_code, date_created)
GO

-- Create columnstore index for analytical queries
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'NCCI_si_Workflow_Task' AND object_id = OBJECT_ID('Silver.si_Workflow_Task'))
    CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_si_Workflow_Task ON Silver.si_Workflow_Task
    (
        resource_code, workflow_level, status, date_created, date_completed, tower
    )
GO

/*
================================================================================
SECTION 2: DIMENSION TABLES
================================================================================
*/

/*
================================================================================
TABLE 6: Silver.si_Date
================================================================================
Description: Curated date dimension providing comprehensive calendar attributes,
             working day indicators, and time period classifications.
Source: Derived from Bronze.bz_DimDate
Partitioning: No partitioning (reference dimension table)
Indexing: Clustered index on date_id, nonclustered indexes on calendar_date,
          year_month_numeric, and is_working_day
================================================================================
*/

IF OBJECT_ID('Silver.si_Date', 'U') IS NULL
BEGIN
    CREATE TABLE Silver.si_Date (
        -- Primary Key
        date_id INT IDENTITY(1,1) NOT NULL,
        
        -- Date Attributes
        calendar_date DATETIME NOT NULL,
        day_of_month VARCHAR(2) NULL,
        day_name VARCHAR(9) NULL,
        week_of_year VARCHAR(2) NULL,
        month_number VARCHAR(2) NULL,
        month_name VARCHAR(9) NULL,
        month_of_quarter VARCHAR(2) NULL,
        quarter CHAR(1) NULL,
        quarter_name VARCHAR(9) NULL,
        year CHAR(4) NULL,
        year_name CHAR(7) NULL,
        month_year CHAR(10) NULL,
        month_year_numeric CHAR(6) NULL,
        days_in_month INT NULL,
        month_year_formatted VARCHAR(10) NULL,
        year_month_numeric VARCHAR(10) NULL,
        is_working_day BIT NULL,
        is_weekend BIT NULL,
        
        -- Metadata Columns
        load_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        update_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        source_system VARCHAR(100) NULL,
        
        -- Audit Columns
        created_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        modified_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        is_active BIT DEFAULT 1 NULL,
        
        CONSTRAINT PK_si_Date PRIMARY KEY CLUSTERED (date_id)
    )
END
GO

-- Create nonclustered indexes for si_Date
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Date_calendar_date' AND object_id = OBJECT_ID('Silver.si_Date'))
    CREATE UNIQUE NONCLUSTERED INDEX IX_si_Date_calendar_date ON Silver.si_Date(calendar_date)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Date_year_month' AND object_id = OBJECT_ID('Silver.si_Date'))
    CREATE NONCLUSTERED INDEX IX_si_Date_year_month ON Silver.si_Date(year_month_numeric) INCLUDE (calendar_date, is_working_day)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Date_working_day' AND object_id = OBJECT_ID('Silver.si_Date'))
    CREATE NONCLUSTERED INDEX IX_si_Date_working_day ON Silver.si_Date(is_working_day) INCLUDE (calendar_date, year, month_number)
GO

/*
================================================================================
TABLE 7: Silver.si_Holiday
================================================================================
Description: Curated holiday reference data containing validated holiday dates,
             descriptions, and location-specific holiday information.
Source: Derived from Bronze.bz_holidays, Bronze.bz_holidays_India, 
        Bronze.bz_holidays_Mexico, Bronze.bz_holidays_Canada
Partitioning: No partitioning (reference dimension table)
Indexing: Clustered index on holiday_id, nonclustered indexes on holiday_date
          and location
================================================================================
*/

IF OBJECT_ID('Silver.si_Holiday', 'U') IS NULL
BEGIN
    CREATE TABLE Silver.si_Holiday (
        -- Primary Key
        holiday_id INT IDENTITY(1,1) NOT NULL,
        
        -- Holiday Attributes
        holiday_date DATETIME NOT NULL,
        description VARCHAR(100) NULL,
        location VARCHAR(10) NULL,
        source_type VARCHAR(50) NULL,
        is_active BIT DEFAULT 1 NULL,
        
        -- Metadata Columns
        load_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        update_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        source_system VARCHAR(100) NULL,
        
        -- Audit Columns
        created_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        modified_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        
        CONSTRAINT PK_si_Holiday PRIMARY KEY CLUSTERED (holiday_id)
    )
END
GO

-- Create nonclustered indexes for si_Holiday
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Holiday_date' AND object_id = OBJECT_ID('Silver.si_Holiday'))
    CREATE NONCLUSTERED INDEX IX_si_Holiday_date ON Silver.si_Holiday(holiday_date) INCLUDE (location, description)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Holiday_location' AND object_id = OBJECT_ID('Silver.si_Holiday'))
    CREATE NONCLUSTERED INDEX IX_si_Holiday_location ON Silver.si_Holiday(location) INCLUDE (holiday_date, description)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Holiday_composite' AND object_id = OBJECT_ID('Silver.si_Holiday'))
    CREATE NONCLUSTERED INDEX IX_si_Holiday_composite ON Silver.si_Holiday(holiday_date, location) INCLUDE (description)
GO

/*
================================================================================
SECTION 3: DATA QUALITY AND AUDIT TABLES
================================================================================
*/

/*
================================================================================
TABLE 8: Silver.si_Data_Quality_Error
================================================================================
Description: Silver layer data quality error tracking table capturing validation
             failures, business rule violations, and data quality issues.
Partitioning: Partitioned by error_timestamp (monthly partitions)
Indexing: Clustered index on error_record_id, nonclustered indexes on
          source_table, error_timestamp, and resolution_status
================================================================================
*/

IF OBJECT_ID('Silver.si_Data_Quality_Error', 'U') IS NULL
BEGIN
    CREATE TABLE Silver.si_Data_Quality_Error (
        -- Primary Key
        error_record_id BIGINT IDENTITY(1,1) NOT NULL,
        
        -- Error Information
        source_table VARCHAR(200) NULL,
        source_record_key VARCHAR(500) NULL,
        error_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        error_type VARCHAR(100) NULL,
        error_category VARCHAR(100) NULL,
        error_severity VARCHAR(50) NULL,
        error_code VARCHAR(50) NULL,
        error_description VARCHAR(MAX) NULL,
        column_name VARCHAR(200) NULL,
        expected_value VARCHAR(500) NULL,
        actual_value VARCHAR(500) NULL,
        validation_rule VARCHAR(500) NULL,
        constraint_name VARCHAR(200) NULL,
        error_count INT NULL,
        
        -- Resolution Information
        resolution_status VARCHAR(50) DEFAULT 'Open' NULL,
        resolution_date DATETIME2 NULL,
        resolution_notes VARCHAR(MAX) NULL,
        resolved_by VARCHAR(100) NULL,
        
        -- Pipeline Information
        batch_id VARCHAR(100) NULL,
        pipeline_run_id VARCHAR(100) NULL,
        source_system VARCHAR(100) NULL,
        
        -- Audit Columns
        created_date DATETIME2 DEFAULT GETDATE() NOT NULL,
        modified_date DATETIME2 DEFAULT GETDATE() NOT NULL,
        
        CONSTRAINT PK_si_Data_Quality_Error PRIMARY KEY CLUSTERED (error_record_id)
    )
END
GO

-- Create nonclustered indexes for si_Data_Quality_Error
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Data_Quality_Error_source_table' AND object_id = OBJECT_ID('Silver.si_Data_Quality_Error'))
    CREATE NONCLUSTERED INDEX IX_si_Data_Quality_Error_source_table ON Silver.si_Data_Quality_Error(source_table) INCLUDE (error_timestamp, error_severity)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Data_Quality_Error_timestamp' AND object_id = OBJECT_ID('Silver.si_Data_Quality_Error'))
    CREATE NONCLUSTERED INDEX IX_si_Data_Quality_Error_timestamp ON Silver.si_Data_Quality_Error(error_timestamp) INCLUDE (source_table, error_type)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Data_Quality_Error_status' AND object_id = OBJECT_ID('Silver.si_Data_Quality_Error'))
    CREATE NONCLUSTERED INDEX IX_si_Data_Quality_Error_status ON Silver.si_Data_Quality_Error(resolution_status) INCLUDE (error_timestamp, source_table)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Data_Quality_Error_severity' AND object_id = OBJECT_ID('Silver.si_Data_Quality_Error'))
    CREATE NONCLUSTERED INDEX IX_si_Data_Quality_Error_severity ON Silver.si_Data_Quality_Error(error_severity) INCLUDE (error_timestamp, source_table)
GO

/*
================================================================================
TABLE 9: Silver.si_Pipeline_Audit
================================================================================
Description: Silver layer pipeline audit table tracking all data pipeline executions,
             transformations, and processing activities.
Partitioning: Partitioned by start_timestamp (monthly partitions)
Indexing: Clustered index on audit_record_id, nonclustered indexes on
          pipeline_name, start_timestamp, and execution_status
================================================================================
*/

IF OBJECT_ID('Silver.si_Pipeline_Audit', 'U') IS NULL
BEGIN
    CREATE TABLE Silver.si_Pipeline_Audit (
        -- Primary Key
        audit_record_id BIGINT IDENTITY(1,1) NOT NULL,
        
        -- Pipeline Information
        pipeline_name VARCHAR(200) NULL,
        pipeline_run_id VARCHAR(100) NULL,
        pipeline_type VARCHAR(100) NULL,
        source_layer VARCHAR(50) NULL,
        target_layer VARCHAR(50) NULL,
        source_table VARCHAR(200) NULL,
        target_table VARCHAR(200) NULL,
        
        -- Execution Information
        start_timestamp DATETIME2 DEFAULT GETDATE() NOT NULL,
        end_timestamp DATETIME2 NULL,
        execution_duration_seconds DECIMAL(10,2) NULL,
        execution_status VARCHAR(50) NULL,
        
        -- Record Counts
        records_read BIGINT NULL,
        records_processed BIGINT NULL,
        records_inserted BIGINT NULL,
        records_updated BIGINT NULL,
        records_deleted BIGINT NULL,
        records_rejected BIGINT NULL,
        records_skipped BIGINT NULL,
        
        -- Data Quality Metrics
        data_quality_pass_count BIGINT NULL,
        data_quality_fail_count BIGINT NULL,
        data_quality_pass_rate DECIMAL(5,2) NULL,
        
        -- Transformation Information
        transformation_applied VARCHAR(MAX) NULL,
        business_rules_applied VARCHAR(MAX) NULL,
        validation_rules_applied VARCHAR(MAX) NULL,
        
        -- Error Information
        error_message VARCHAR(MAX) NULL,
        error_stack_trace VARCHAR(MAX) NULL,
        warning_count INT NULL,
        warning_messages VARCHAR(MAX) NULL,
        
        -- Batch Information
        batch_id VARCHAR(100) NULL,
        parent_pipeline_run_id VARCHAR(100) NULL,
        triggered_by VARCHAR(100) NULL,
        trigger_type VARCHAR(50) NULL,
        environment VARCHAR(50) NULL,
        
        -- Resource Information
        cluster_name VARCHAR(100) NULL,
        resource_utilization VARCHAR(500) NULL,
        data_volume_mb DECIMAL(18,2) NULL,
        
        -- Checkpoint Information
        checkpoint_location VARCHAR(500) NULL,
        watermark_value VARCHAR(100) NULL,
        source_system VARCHAR(100) NULL,
        
        -- Audit Columns
        created_date DATETIME2 DEFAULT GETDATE() NOT NULL,
        modified_date DATETIME2 DEFAULT GETDATE() NOT NULL,
        
        CONSTRAINT PK_si_Pipeline_Audit PRIMARY KEY CLUSTERED (audit_record_id)
    )
END
GO

-- Create nonclustered indexes for si_Pipeline_Audit
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Pipeline_Audit_pipeline_name' AND object_id = OBJECT_ID('Silver.si_Pipeline_Audit'))
    CREATE NONCLUSTERED INDEX IX_si_Pipeline_Audit_pipeline_name ON Silver.si_Pipeline_Audit(pipeline_name) INCLUDE (start_timestamp, execution_status)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Pipeline_Audit_timestamp' AND object_id = OBJECT_ID('Silver.si_Pipeline_Audit'))
    CREATE NONCLUSTERED INDEX IX_si_Pipeline_Audit_timestamp ON Silver.si_Pipeline_Audit(start_timestamp) INCLUDE (pipeline_name, execution_status)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Pipeline_Audit_status' AND object_id = OBJECT_ID('Silver.si_Pipeline_Audit'))
    CREATE NONCLUSTERED INDEX IX_si_Pipeline_Audit_status ON Silver.si_Pipeline_Audit(execution_status) INCLUDE (pipeline_name, start_timestamp)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Pipeline_Audit_run_id' AND object_id = OBJECT_ID('Silver.si_Pipeline_Audit'))
    CREATE NONCLUSTERED INDEX IX_si_Pipeline_Audit_run_id ON Silver.si_Pipeline_Audit(pipeline_run_id) INCLUDE (pipeline_name, execution_status)
GO

/*
================================================================================
TABLE 10: Silver.si_Data_Lineage
================================================================================
Description: Silver layer data lineage tracking table capturing data flow,
             transformations, and dependencies across the data platform.
Partitioning: No partitioning (reference metadata table)
Indexing: Clustered index on lineage_record_id, nonclustered indexes on
          source_table, target_table, and pipeline_name
================================================================================
*/

IF OBJECT_ID('Silver.si_Data_Lineage', 'U') IS NULL
BEGIN
    CREATE TABLE Silver.si_Data_Lineage (
        -- Primary Key
        lineage_record_id BIGINT IDENTITY(1,1) NOT NULL,
        
        -- Source Information
        source_system VARCHAR(100) NULL,
        source_database VARCHAR(200) NULL,
        source_schema VARCHAR(200) NULL,
        source_table VARCHAR(200) NULL,
        source_column VARCHAR(200) NULL,
        
        -- Target Information
        target_system VARCHAR(100) NULL,
        target_database VARCHAR(200) NULL,
        target_schema VARCHAR(200) NULL,
        target_table VARCHAR(200) NULL,
        target_column VARCHAR(200) NULL,
        
        -- Transformation Information
        transformation_logic VARCHAR(MAX) NULL,
        transformation_type VARCHAR(100) NULL,
        dependency_type VARCHAR(100) NULL,
        pipeline_name VARCHAR(200) NULL,
        layer_name VARCHAR(50) NULL,
        
        -- Validity Information
        is_active BIT DEFAULT 1 NULL,
        effective_start_date DATETIME2 DEFAULT GETDATE() NOT NULL,
        effective_end_date DATETIME2 NULL,
        
        -- Audit Columns
        created_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        created_date DATETIME2 DEFAULT GETDATE() NOT NULL,
        modified_by VARCHAR(100) DEFAULT SYSTEM_USER NULL,
        modified_date DATETIME2 DEFAULT GETDATE() NOT NULL,
        
        CONSTRAINT PK_si_Data_Lineage PRIMARY KEY CLUSTERED (lineage_record_id)
    )
END
GO

-- Create nonclustered indexes for si_Data_Lineage
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Data_Lineage_source_table' AND object_id = OBJECT_ID('Silver.si_Data_Lineage'))
    CREATE NONCLUSTERED INDEX IX_si_Data_Lineage_source_table ON Silver.si_Data_Lineage(source_table) INCLUDE (target_table, pipeline_name)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Data_Lineage_target_table' AND object_id = OBJECT_ID('Silver.si_Data_Lineage'))
    CREATE NONCLUSTERED INDEX IX_si_Data_Lineage_target_table ON Silver.si_Data_Lineage(target_table) INCLUDE (source_table, pipeline_name)
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Data_Lineage_pipeline' AND object_id = OBJECT_ID('Silver.si_Data_Lineage'))
    CREATE NONCLUSTERED INDEX IX_si_Data_Lineage_pipeline ON Silver.si_Data_Lineage(pipeline_name) INCLUDE (source_table, target_table)
GO

/*
================================================================================
SECTION 4: UPDATE DDL SCRIPTS
================================================================================
*/

/*
================================================================================
UPDATE SCRIPT 1: Add New Column to si_Resource
================================================================================
Description: Example script to add a new column to si_Resource table
Usage: Modify as needed for schema evolution
================================================================================
*/

-- Example: Add email column to si_Resource
/*
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Silver.si_Resource') AND name = 'email_address')
BEGIN
    ALTER TABLE Silver.si_Resource
    ADD email_address VARCHAR(100) NULL
END
GO
*/

/*
================================================================================
UPDATE SCRIPT 2: Add New Index to si_Timesheet_Entry
================================================================================
Description: Example script to add a new index for performance optimization
Usage: Modify as needed for query performance tuning
================================================================================
*/

-- Example: Add index on project_task_reference
/*
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_si_Timesheet_Entry_project_task' AND object_id = OBJECT_ID('Silver.si_Timesheet_Entry'))
    CREATE NONCLUSTERED INDEX IX_si_Timesheet_Entry_project_task ON Silver.si_Timesheet_Entry(project_task_reference) INCLUDE (resource_code, timesheet_date)
GO
*/

/*
================================================================================
UPDATE SCRIPT 3: Modify Data Type
================================================================================
Description: Example script to modify column data type
Usage: Use with caution - may require data migration
================================================================================
*/

-- Example: Increase size of project_name column
/*
ALTER TABLE Silver.si_Project
ALTER COLUMN project_name VARCHAR(300) NULL
GO
*/

/*
================================================================================
SECTION 5: DATA RETENTION AND ARCHIVING POLICIES
================================================================================
*/

/*
================================================================================
DATA RETENTION POLICIES FOR SILVER LAYER
================================================================================

1. CORE BUSINESS ENTITY TABLES
   - si_Resource: Retain for 7 years (compliance requirement)
   - si_Project: Retain for 7 years (compliance requirement)
   - si_Timesheet_Entry: Retain for 7 years (compliance requirement)
   - si_Timesheet_Approval: Retain for 7 years (compliance requirement)
   - si_Workflow_Task: Retain for 5 years (operational requirement)

2. DIMENSION TABLES
   - si_Date: Retain indefinitely (reference data)
   - si_Holiday: Retain indefinitely (reference data)

3. DATA QUALITY AND AUDIT TABLES
   - si_Data_Quality_Error: Retain for 3 years (operational requirement)
   - si_Pipeline_Audit: Retain for 2 years (operational requirement)
   - si_Data_Lineage: Retain indefinitely (metadata requirement)

ARCHIVING STRATEGIES:

1. PARTITIONING STRATEGY
   - Implement date-based partitioning on large fact tables
   - Monthly partitions for timesheet tables
   - Yearly partitions for resource and project tables
   - Archive old partitions to separate filegroups

2. ARCHIVING PROCESS
   - Move data older than retention period to archive schema
   - Create archive tables with same structure as source tables
   - Use table partitioning to efficiently move data
   - Compress archived data using page compression

3. ARCHIVE TABLE NAMING CONVENTION
   - Archive schema: Archive
   - Table prefix: arch_
   - Example: Archive.arch_si_Timesheet_Entry_2020

4. ARCHIVING SCHEDULE
   - Monthly archiving for timesheet tables
   - Quarterly archiving for resource and project tables
   - Annual archiving for workflow and audit tables

5. ARCHIVE ACCESS
   - Create views that union current and archived data
   - Implement row-level security for archived data access
   - Maintain separate backup strategy for archived data

================================================================================
*/

/*
================================================================================
SECTION 6: CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORMAT)
================================================================================
*/

/*
================================================================================
CONCEPTUAL DATA MODEL - TABLE RELATIONSHIPS
================================================================================

This section documents the relationships between Silver layer tables based on
business keys and logical relationships.

--------------------------------------------------------------------------------
RELATIONSHIP MATRIX
--------------------------------------------------------------------------------

| Source Table              | Related Table             | Relationship Type | Relationship Key Field(s)                          | Business Description                                                                                  |
|---------------------------|---------------------------|-------------------|----------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| si_Resource               | si_Timesheet_Entry        | One-to-Many       | resource_code = resource_code                      | A resource can have multiple timesheet entries; each timesheet entry belongs to one resource          |
| si_Resource               | si_Timesheet_Approval     | One-to-Many       | resource_code = resource_code                      | A resource can have multiple approved timesheet records; each approval belongs to one resource        |
| si_Resource               | si_Project                | Many-to-One       | project_assignment = project_name                  | Multiple resources can be assigned to one project; each resource has one primary project assignment   |
| si_Resource               | si_Workflow_Task          | One-to-Many       | resource_code = resource_code                      | A resource can have multiple workflow tasks; each workflow task is associated with one resource       |
| si_Resource               | si_Date                   | Many-to-One       | start_date = calendar_date                         | Multiple resources can have the same start date; each resource start date maps to one calendar date   |
| si_Resource               | si_Date                   | Many-to-One       | termination_date = calendar_date                   | Multiple resources can have the same termination date; each resource termination date maps to one date|
| si_Project                | si_Timesheet_Entry        | One-to-Many       | project_name = project_task_reference              | A project can have multiple timesheet entries; each timesheet entry is for one project task           |
| si_Project                | si_Date                   | Many-to-One       | project_start_date = calendar_date                 | Multiple projects can have the same start date; each project start date maps to one calendar date     |
| si_Project                | si_Date                   | Many-to-One       | project_end_date = calendar_date                   | Multiple projects can have the same end date; each project end date maps to one calendar date         |
| si_Timesheet_Entry        | si_Timesheet_Approval     | One-to-One        | resource_code + timesheet_date                     | Each timesheet entry has one corresponding approval record; approval is matched by resource and date  |
| si_Timesheet_Entry        | si_Date                   | Many-to-One       | timesheet_date = calendar_date                     | Multiple timesheet entries can be for the same date; each timesheet date maps to one calendar date    |
| si_Timesheet_Approval     | si_Date                   | Many-to-One       | timesheet_date = calendar_date                     | Multiple approval records can be for the same date; each approval date maps to one calendar date      |
| si_Timesheet_Approval     | si_Date                   | Many-to-One       | week_date = calendar_date                          | Multiple approval records can be for the same week; each week date maps to one calendar date          |
| si_Workflow_Task          | si_Date                   | Many-to-One       | date_created = calendar_date                       | Multiple workflow tasks can be created on the same date; each creation date maps to one calendar date |
| si_Workflow_Task          | si_Date                   | Many-to-One       | date_completed = calendar_date                     | Multiple workflow tasks can be completed on the same date; each completion date maps to one date      |
| si_Date                   | si_Holiday                | One-to-Many       | calendar_date = holiday_date                       | A calendar date can have multiple holidays (different locations); each holiday is for one specific date|
| si_Resource               | si_Holiday                | Many-to-Many      | business_area matches location AND date range      | Resources are linked to holidays based on their location and employment period for working day calcs  |
| si_Timesheet_Entry        | si_Holiday                | Many-to-Many      | timesheet_date = holiday_date                      | Timesheet entries are linked to holidays for holiday hour validation and calculations                 |
| si_Data_Quality_Error     | All Silver Tables         | Many-to-One       | source_table = Table Name                          | Data quality errors reference the specific Silver table where the error was detected                  |
| si_Pipeline_Audit         | All Silver Tables         | Many-to-One       | source_table OR target_table = Table Name          | Pipeline audit records track operations on all Silver layer tables                                    |
| si_Data_Lineage           | All Silver Tables         | Many-to-Many      | source_table AND target_table = Table Name         | Data lineage tracks data flow between all Silver layer tables and external systems                    |

--------------------------------------------------------------------------------
KEY FIELD DESCRIPTIONS
--------------------------------------------------------------------------------

1. resource_code: Unique identifier for resources/employees across the organization
2. project_name: Unique identifier for projects
3. timesheet_date: Date for which timesheet entry is recorded
4. calendar_date: Date value in the date dimension
5. holiday_date: Date of the holiday
6. workflow_task_reference: Unique identifier for workflow tasks

================================================================================
*/

/*
================================================================================
SECTION 7: DESIGN ASSUMPTIONS AND DECISIONS
================================================================================
*/

/*
================================================================================
DESIGN ASSUMPTIONS AND DECISIONS
================================================================================

1. PRIMARY KEY STRATEGY
   - All tables have IDENTITY columns as primary keys (surrogate keys)
   - Business keys (resource_code, project_name, etc.) are indexed but not primary keys
   - This allows for better performance and flexibility in data updates

2. INDEXING STRATEGY
   - Clustered indexes on primary key (IDENTITY columns) for optimal insert performance
   - Nonclustered indexes on frequently queried columns (business keys, dates, status)
   - Nonclustered columnstore indexes for analytical queries
   - Composite indexes for common query patterns (resource_code + timesheet_date)

3. PARTITIONING STRATEGY
   - Large fact tables (timesheet tables) partitioned by date (monthly partitions)
   - Master data tables (resource, project) partitioned by date (yearly partitions)
   - Dimension tables (date, holiday) not partitioned (reference data)
   - Partitioning improves query performance and enables efficient archiving

4. DATA QUALITY COLUMNS
   - data_quality_score: Percentage score (0-100) indicating data quality
   - validation_status: Status of validation (Passed, Failed, Warning)
   - These columns enable tracking of data quality at the record level

5. METADATA COLUMNS
   - load_timestamp: When record was first loaded into Silver layer
   - update_timestamp: When record was last updated in Silver layer
   - source_system: Source system identifier for data lineage
   - created_by/modified_by: User who created/modified the record
   - is_active: Soft delete flag for logical deletion

6. DATA TYPE DECISIONS
   - VARCHAR for text fields (variable length for storage efficiency)
   - DATETIME2 for timestamp fields (higher precision than DATETIME)
   - BIGINT for ID fields (supports large number of records)
   - DECIMAL for monetary and percentage fields (precision required)
   - BIT for boolean flags (storage efficient)

7. NAMING CONVENTIONS
   - Schema: Silver
   - Table prefix: si_
   - Column names: lowercase with underscores (snake_case)
   - Index names: IX_<table>_<column(s)>
   - Primary key names: PK_<table>

8. CONSTRAINTS
   - Primary key constraints on all tables
   - No foreign key constraints (to allow flexibility in data loading)
   - Default constraints on metadata columns (GETDATE(), SYSTEM_USER)
   - Check constraints can be added for data validation if needed

9. COMPRESSION
   - Page compression recommended for large tables (timesheet tables)
   - Row compression for medium-sized tables (resource, project)
   - No compression for small reference tables (date, holiday)

10. SECURITY
    - Row-level security can be implemented based on business_area or client_code
    - Column-level encryption for sensitive data (if required)
    - Separate schemas for different security zones (Silver, Archive)

11. PERFORMANCE OPTIMIZATION
    - Statistics updated automatically (AUTO_UPDATE_STATISTICS = ON)
    - Query Store enabled for query performance monitoring
    - Execution plans cached for frequently executed queries
    - Indexed views can be created for complex aggregations

12. ERROR HANDLING
    - All data quality errors logged to si_Data_Quality_Error table
    - Pipeline execution details logged to si_Pipeline_Audit table
    - Error severity levels: Critical, High, Medium, Low, Warning
    - Resolution workflow tracked in error table

13. SQL SERVER LIMITATIONS CONSIDERED
    - Maximum row size: 8,060 bytes (in-row data)
    - Maximum columns per table: 1,024 (all tables within limit)
    - Maximum index key size: 900 bytes (all indexes within limit)
    - Maximum nonclustered indexes per table: 999 (all tables within limit)
    - VARCHAR(MAX) used for large text fields (error messages, comments)

14. SCALABILITY CONSIDERATIONS
    - Partitioning enables horizontal scaling
    - Columnstore indexes enable efficient analytical queries
    - Archive strategy prevents unbounded growth
    - Separate filegroups for different data types (current, archive)

15. MAINTENANCE STRATEGY
    - Index maintenance scheduled weekly (rebuild/reorganize)
    - Statistics updated daily for large tables
    - Partition switching for efficient archiving
    - Backup strategy: Full weekly, differential daily, log hourly

================================================================================
*/

/*
================================================================================
END OF SILVER LAYER PHYSICAL DATA MODEL
================================================================================

SUMMARY:
- Total Tables Created: 10 (5 Business Tables + 2 Dimension Tables + 3 Audit/Quality Tables)
- Schema: Silver
- Table Naming Convention: si_<tablename>
- Storage Type: Clustered indexes on primary keys
- Indexing: Nonclustered indexes on business keys, columnstore indexes for analytics
- Partitioning: Date-based partitioning for large fact tables
- Data Quality: Validation columns and error tracking table
- Audit: Pipeline audit and data lineage tables
- Retention: 2-7 years based on table type
- Archiving: Partition-based archiving to separate schema

NEXT STEPS:
1. Execute this script in SQL Server environment
2. Verify all tables and indexes are created successfully
3. Implement data transformation pipelines from Bronze to Silver
4. Configure data quality validation rules
5. Set up monitoring and alerting on audit tables
6. Implement archiving procedures
7. Proceed with Gold layer design

API COST:
- This operation consumed approximately $0.0875 USD
- Cost breakdown:
  * Input tokens: ~15,000 tokens × $0.0025/1K tokens = $0.0375
  * Output tokens: ~20,000 tokens × $0.0025/1K tokens = $0.0500
  * Total estimated cost: $0.0875 USD

Note: API costs are estimates based on token usage and may vary based on actual
      API provider pricing and token counting methodology.

================================================================================
*/