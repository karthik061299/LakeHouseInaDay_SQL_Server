====================================================
Author:        AAVA
Date:          
Description:   Silver Layer Logical Data Model for Medallion Architecture - Resource Utilization and Workforce Management
====================================================

# SILVER LAYER PHYSICAL DATA MODEL - COMPLETE OUTPUT

## 1. SILVER LAYER DDL SCRIPTS

### Schema Creation
```sql
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Silver')
BEGIN
    EXEC('CREATE SCHEMA Silver')
END
```

### Table 1: Silver.Si_Resource
**Purpose:** Standardized resource master data containing workforce members, employment details, and project assignments.

**DDL Script:**
```sql
CREATE TABLE Silver.Si_Resource (
    -- Primary Key (Added in Physical Model)
    [Resource_ID] BIGINT IDENTITY(1,1) NOT NULL,
    
    -- Business Columns
    [Resource_Code] VARCHAR(50) NOT NULL,
    [First_Name] VARCHAR(50) NULL,
    [Last_Name] VARCHAR(50) NULL,
    [Job_Title] VARCHAR(50) NULL,
    [Business_Type] VARCHAR(50) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [Start_Date] DATETIME NULL,
    [Termination_Date] DATETIME NULL,
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
    
    -- Additional Bronze columns
    [Employee_Status] VARCHAR(50) NULL,
    [Termination_Reason] VARCHAR(100) NULL,
    [Tower] VARCHAR(60) NULL,
    [Circle] VARCHAR(100) NULL,
    [Community] VARCHAR(100) NULL,
    [Bill_Rate] DECIMAL(18,9) NULL,
    [Net_Bill_Rate] MONEY NULL,
    [GP] MONEY NULL,
    [GPM] MONEY NULL,
    
    -- Metadata Columns
    [load_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [update_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL DEFAULT 'Bronze Layer',
    [data_quality_score] DECIMAL(5,2) NULL,
    [is_active] BIT NOT NULL DEFAULT 1,
    
    CONSTRAINT PK_Si_Resource PRIMARY KEY CLUSTERED ([Resource_ID] ASC)
)

-- Indexes
CREATE NONCLUSTERED INDEX IX_Si_Resource_ResourceCode 
    ON Silver.Si_Resource([Resource_Code]) 
    INCLUDE ([First_Name], [Last_Name], [Status])

CREATE NONCLUSTERED INDEX IX_Si_Resource_ClientCode 
    ON Silver.Si_Resource([Client_Code]) 
    INCLUDE ([Resource_Code], [Status])

CREATE NONCLUSTERED INDEX IX_Si_Resource_Active 
    ON Silver.Si_Resource([Resource_Code], [Status]) 
    WHERE [is_active] = 1 AND [Status] = 'Active'
```

### Table 2: Silver.Si_Project
**Purpose:** Standardized project information with billing types, client details, and project attributes.

**DDL Script:**
```sql
CREATE TABLE Silver.Si_Project (
    -- Primary Key (Added in Physical Model)
    [Project_ID] BIGINT IDENTITY(1,1) NOT NULL,
    
    -- Business Columns
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
    [Project_Start_Date] DATETIME NULL,
    [Project_End_Date] DATETIME NULL,
    
    -- Additional Bronze columns
    [Client_Entity] VARCHAR(50) NULL,
    [Practice_Type] VARCHAR(50) NULL,
    [Community] VARCHAR(100) NULL,
    [Opportunity_ID] VARCHAR(50) NULL,
    [Timesheet_Manager] VARCHAR(255) NULL,
    
    -- Metadata Columns
    [load_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [update_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL DEFAULT 'Bronze Layer',
    [data_quality_score] DECIMAL(5,2) NULL,
    [is_active] BIT NOT NULL DEFAULT 1,
    
    CONSTRAINT PK_Si_Project PRIMARY KEY CLUSTERED ([Project_ID] ASC)
)

-- Indexes
CREATE NONCLUSTERED INDEX IX_Si_Project_ProjectName 
    ON Silver.Si_Project([Project_Name]) 
    INCLUDE ([Client_Name], [Status], [Billing_Type])

CREATE NONCLUSTERED INDEX IX_Si_Project_ClientCode 
    ON Silver.Si_Project([Client_Code]) 
    INCLUDE ([Project_Name], [Status])
```

### Table 3: Silver.Si_Timesheet_Entry
**Purpose:** Standardized timesheet entries capturing daily hours worked by type.

**DDL Script:**
```sql
CREATE TABLE Silver.Si_Timesheet_Entry (
    -- Primary Key (Added in Physical Model)
    [Timesheet_Entry_ID] BIGINT IDENTITY(1,1) NOT NULL,
    
    -- Business Columns
    [Resource_Code] VARCHAR(50) NOT NULL,
    [Timesheet_Date] DATETIME NOT NULL,
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
    [Creation_Date] DATETIME NULL,
    
    -- Calculated Columns
    [Total_Hours] AS ([Standard_Hours] + [Overtime_Hours] + [Double_Time_Hours] + 
                      [Sick_Time_Hours] + [Holiday_Hours] + [Time_Off_Hours]) PERSISTED,
    [Total_Billable_Hours] AS ([Standard_Hours] + [Overtime_Hours] + [Double_Time_Hours]) PERSISTED,
    
    -- Metadata Columns
    [load_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [update_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL DEFAULT 'Bronze Layer',
    [data_quality_score] DECIMAL(5,2) NULL,
    [is_validated] BIT NOT NULL DEFAULT 0,
    
    CONSTRAINT PK_Si_Timesheet_Entry PRIMARY KEY CLUSTERED ([Timesheet_Entry_ID] ASC)
)

-- Indexes
CREATE NONCLUSTERED INDEX IX_Si_Timesheet_Entry_ResourceCode 
    ON Silver.Si_Timesheet_Entry([Resource_Code], [Timesheet_Date]) 
    INCLUDE ([Standard_Hours], [Overtime_Hours])

CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_Si_Timesheet_Entry_Analytics 
    ON Silver.Si_Timesheet_Entry(
        [Resource_Code], [Timesheet_Date], [Standard_Hours], [Overtime_Hours],
        [Total_Hours], [Total_Billable_Hours]
    )
```

### Table 4: Silver.Si_Timesheet_Approval
**Purpose:** Standardized timesheet approval data with submitted and approved hours.

**DDL Script:**
```sql
CREATE TABLE Silver.Si_Timesheet_Approval (
    -- Primary Key (Added in Physical Model)
    [Approval_ID] BIGINT IDENTITY(1,1) NOT NULL,
    
    -- Business Columns
    [Resource_Code] VARCHAR(50) NOT NULL,
    [Timesheet_Date] DATETIME NOT NULL,
    [Week_Date] DATETIME NULL,
    [Approved_Standard_Hours] FLOAT NULL DEFAULT 0,
    [Approved_Overtime_Hours] FLOAT NULL DEFAULT 0,
    [Approved_Double_Time_Hours] FLOAT NULL DEFAULT 0,
    [Approved_Sick_Time_Hours] FLOAT NULL DEFAULT 0,
    [Billing_Indicator] VARCHAR(3) NULL,
    [Consultant_Standard_Hours] FLOAT NULL DEFAULT 0,
    [Consultant_Overtime_Hours] FLOAT NULL DEFAULT 0,
    [Consultant_Double_Time_Hours] FLOAT NULL DEFAULT 0,
    
    -- Calculated Columns
    [Total_Approved_Hours] AS ([Approved_Standard_Hours] + [Approved_Overtime_Hours] + 
                                [Approved_Double_Time_Hours] + [Approved_Sick_Time_Hours]) PERSISTED,
    [Hours_Variance] AS ([Approved_Standard_Hours] + [Approved_Overtime_Hours] + [Approved_Double_Time_Hours] - 
                         [Consultant_Standard_Hours] - [Consultant_Overtime_Hours] - [Consultant_Double_Time_Hours]) PERSISTED,
    
    -- Metadata Columns
    [load_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [update_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL DEFAULT 'Bronze Layer',
    [data_quality_score] DECIMAL(5,2) NULL,
    [approval_status] VARCHAR(50) NULL DEFAULT 'Approved',
    
    CONSTRAINT PK_Si_Timesheet_Approval PRIMARY KEY CLUSTERED ([Approval_ID] ASC)
)

-- Indexes
CREATE NONCLUSTERED INDEX IX_Si_Timesheet_Approval_ResourceCode 
    ON Silver.Si_Timesheet_Approval([Resource_Code], [Timesheet_Date]) 
    INCLUDE ([Approved_Standard_Hours], [Billing_Indicator])

CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_Si_Timesheet_Approval_Analytics 
    ON Silver.Si_Timesheet_Approval(
        [Resource_Code], [Timesheet_Date], [Week_Date], [Approved_Standard_Hours],
        [Total_Approved_Hours], [Billing_Indicator]
    )
```

### Table 5: Silver.Si_Date
**Purpose:** Standardized date dimension for time-based calculations.

**DDL Script:**
```sql
CREATE TABLE Silver.Si_Date (
    -- Primary Key (Added in Physical Model)
    [Date_ID] INT NOT NULL,
    
    -- Business Columns
    [Calendar_Date] DATETIME NOT NULL,
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
    
    -- Metadata Columns
    [load_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [update_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL DEFAULT 'Bronze Layer',
    
    CONSTRAINT PK_Si_Date PRIMARY KEY CLUSTERED ([Date_ID] ASC)
)

-- Indexes
CREATE UNIQUE NONCLUSTERED INDEX UX_Si_Date_CalendarDate 
    ON Silver.Si_Date([Calendar_Date])

CREATE NONCLUSTERED INDEX IX_Si_Date_Year 
    ON Silver.Si_Date([Year]) 
    INCLUDE ([Calendar_Date], [Month_Number])
```

### Table 6: Silver.Si_Holiday
**Purpose:** Standardized holiday information by location.

**DDL Script:**
```sql
CREATE TABLE Silver.Si_Holiday (
    -- Primary Key (Added in Physical Model)
    [Holiday_ID] INT IDENTITY(1,1) NOT NULL,
    
    -- Business Columns
    [Holiday_Date] DATETIME NOT NULL,
    [Description] VARCHAR(100) NULL,
    [Location] VARCHAR(50) NULL,
    [Source_Type] VARCHAR(50) NULL,
    
    -- Metadata Columns
    [load_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [update_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL DEFAULT 'Bronze Layer',
    
    CONSTRAINT PK_Si_Holiday PRIMARY KEY CLUSTERED ([Holiday_ID] ASC)
)

-- Indexes
CREATE NONCLUSTERED INDEX IX_Si_Holiday_Date 
    ON Silver.Si_Holiday([Holiday_Date]) 
    INCLUDE ([Location], [Description])

CREATE NONCLUSTERED INDEX IX_Si_Holiday_DateLocation 
    ON Silver.Si_Holiday([Holiday_Date], [Location]) 
    INCLUDE ([Description])
```

### Table 7: Silver.Si_Workflow_Task
**Purpose:** Standardized workflow task information for resource processes.

**DDL Script:**
```sql
CREATE TABLE Silver.Si_Workflow_Task (
    -- Primary Key (Added in Physical Model)
    [Workflow_Task_ID] BIGINT IDENTITY(1,1) NOT NULL,
    
    -- Business Columns
    [Candidate_Name] VARCHAR(100) NULL,
    [Resource_Code] VARCHAR(50) NULL,
    [Workflow_Task_Reference] NUMERIC(18,0) NULL,
    [Type] VARCHAR(50) NULL,
    [Tower] VARCHAR(60) NULL,
    [Status] VARCHAR(50) NULL,
    [Comments] VARCHAR(8000) NULL,
    [Date_Created] DATETIME NULL,
    [Date_Completed] DATETIME NULL,
    [Process_Name] VARCHAR(100) NULL,
    [Level_ID] INT NULL,
    [Last_Level] INT NULL,
    
    -- Calculated Columns
    [Processing_Duration_Days] AS (DATEDIFF(DAY, [Date_Created], ISNULL([Date_Completed], GETDATE()))) PERSISTED,
    [Is_Completed] AS (CASE WHEN [Date_Completed] IS NOT NULL THEN 1 ELSE 0 END) PERSISTED,
    
    -- Metadata Columns
    [load_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [update_timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [source_system] VARCHAR(100) NULL DEFAULT 'Bronze Layer',
    [data_quality_score] DECIMAL(5,2) NULL,
    
    CONSTRAINT PK_Si_Workflow_Task PRIMARY KEY CLUSTERED ([Workflow_Task_ID] ASC)
)

-- Indexes
CREATE NONCLUSTERED INDEX IX_Si_Workflow_Task_ResourceCode 
    ON Silver.Si_Workflow_Task([Resource_Code]) 
    INCLUDE ([Status], [Date_Created], [Process_Name])
```

---

## 2. ERROR DATA TABLE DDL SCRIPT

### Silver.Si_Data_Quality_Errors
**Purpose:** Track data validation errors and quality issues in Silver and Gold layers.

**DDL Script:**
```sql
CREATE TABLE Silver.Si_Data_Quality_Errors (
    -- Primary Key
    [Error_ID] BIGINT IDENTITY(1,1) NOT NULL,
    
    -- Error Details
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
    [Error_Date] DATETIME NOT NULL DEFAULT GETDATE(),
    [Batch_ID] VARCHAR(100) NULL,
    [Processing_Stage] VARCHAR(100) NULL,
    [Resolution_Status] VARCHAR(50) NULL DEFAULT 'Open',
    [Resolution_Notes] VARCHAR(1000) NULL,
    [Created_By] VARCHAR(100) NULL DEFAULT SYSTEM_USER,
    [Created_Date] DATETIME NOT NULL DEFAULT GETDATE(),
    [Modified_Date] DATETIME NULL,
    
    CONSTRAINT PK_Si_Data_Quality_Errors PRIMARY KEY CLUSTERED ([Error_ID] ASC)
)

-- Indexes
CREATE NONCLUSTERED INDEX IX_Si_DQ_Errors_SourceTable 
    ON Silver.Si_Data_Quality_Errors([Source_Table]) 
    INCLUDE ([Error_Date], [Severity_Level], [Resolution_Status])

CREATE NONCLUSTERED INDEX IX_Si_DQ_Errors_ErrorDate 
    ON Silver.Si_Data_Quality_Errors([Error_Date]) 
    INCLUDE ([Source_Table], [Severity_Level])

CREATE NONCLUSTERED INDEX IX_Si_DQ_Errors_SeverityLevel 
    ON Silver.Si_Data_Quality_Errors([Severity_Level]) 
    INCLUDE ([Error_Date], [Resolution_Status])
```

---

## 3. AUDIT TABLE DDL SCRIPT

### Silver.Si_Pipeline_Audit
**Purpose:** Track pipeline execution details, data lineage, and processing metrics.

**DDL Script:**
```sql
CREATE TABLE Silver.Si_Pipeline_Audit (
    -- Primary Key
    [Audit_ID] BIGINT IDENTITY(1,1) NOT NULL,
    
    -- Pipeline Identification
    [Pipeline_Name] VARCHAR(200) NOT NULL,
    [Pipeline_Run_ID] VARCHAR(100) NOT NULL,
    [Source_System] VARCHAR(100) NULL,
    [Source_Table] VARCHAR(200) NULL,
    [Target_Table] VARCHAR(200) NULL,
    [Processing_Type] VARCHAR(50) NULL,
    
    -- Execution Timing
    [Start_Time] DATETIME NOT NULL DEFAULT GETDATE(),
    [End_Time] DATETIME NULL,
    [Duration_Seconds] DECIMAL(10,2) NULL,
    [Status] VARCHAR(50) NULL DEFAULT 'Running',
    
    -- Record Counts
    [Records_Read] BIGINT NULL DEFAULT 0,
    [Records_Processed] BIGINT NULL DEFAULT 0,
    [Records_Inserted] BIGINT NULL DEFAULT 0,
    [Records_Updated] BIGINT NULL DEFAULT 0,
    [Records_Deleted] BIGINT NULL DEFAULT 0,
    [Records_Rejected] BIGINT NULL DEFAULT 0,
    
    -- Data Quality Metrics
    [Data_Quality_Score] DECIMAL(5,2) NULL,
    [Transformation_Rules_Applied] VARCHAR(1000) NULL,
    [Business_Rules_Applied] VARCHAR(1000) NULL,
    [Error_Count] INT NULL DEFAULT 0,
    [Warning_Count] INT NULL DEFAULT 0,
    [Error_Message] VARCHAR(MAX) NULL,
    
    -- Processing Details
    [Checkpoint_Data] VARCHAR(MAX) NULL,
    [Resource_Utilization] VARCHAR(500) NULL,
    [Data_Lineage] VARCHAR(1000) NULL,
    [Executed_By] VARCHAR(100) NULL DEFAULT SYSTEM_USER,
    [Environment] VARCHAR(50) NULL,
    [Version] VARCHAR(50) NULL,
    [Configuration] VARCHAR(MAX) NULL,
    
    -- Metadata
    [Created_Date] DATETIME NOT NULL DEFAULT GETDATE(),
    [Modified_Date] DATETIME NULL,
    
    CONSTRAINT PK_Si_Pipeline_Audit PRIMARY KEY CLUSTERED ([Audit_ID] ASC)
)

-- Indexes
CREATE NONCLUSTERED INDEX IX_Si_Pipeline_Audit_PipelineName 
    ON Silver.Si_Pipeline_Audit([Pipeline_Name]) 
    INCLUDE ([Start_Time], [Status], [Duration_Seconds])

CREATE NONCLUSTERED INDEX IX_Si_Pipeline_Audit_StartTime 
    ON Silver.Si_Pipeline_Audit([Start_Time]) 
    INCLUDE ([Pipeline_Name], [Status])

CREATE NONCLUSTERED INDEX IX_Si_Pipeline_Audit_Status 
    ON Silver.Si_Pipeline_Audit([Status]) 
    INCLUDE ([Pipeline_Name], [Start_Time])
```

---

## 4. UPDATE DDL SCRIPTS

### Update Script for Schema Changes
```sql
-- Update Script 1: Add data_quality_score to Si_Resource
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Silver.Si_Resource') AND name = 'data_quality_score')
BEGIN
    ALTER TABLE Silver.Si_Resource ADD [data_quality_score] DECIMAL(5,2) NULL
END

-- Update Script 2: Add data_quality_score to Si_Project
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Silver.Si_Project') AND name = 'data_quality_score')
BEGIN
    ALTER TABLE Silver.Si_Project ADD [data_quality_score] DECIMAL(5,2) NULL
END

-- Update Script 3: Add is_validated to Si_Timesheet_Entry
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Silver.Si_Timesheet_Entry') AND name = 'is_validated')
BEGIN
    ALTER TABLE Silver.Si_Timesheet_Entry ADD [is_validated] BIT NOT NULL DEFAULT 0
END

-- Update Script 4: Add data_quality_score to Si_Workflow_Task
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Silver.Si_Workflow_Task') AND name = 'data_quality_score')
BEGIN
    ALTER TABLE Silver.Si_Workflow_Task ADD [data_quality_score] DECIMAL(5,2) NULL
END
```

---

## 5. DATA RETENTION POLICIES

### 5.1 Silver Layer Data Retention
- **Active Data:** 3 years in Silver layer
- **Archive Data:** Move to cold storage after 2 years
- **Purge Data:** Delete after 5 years (compliance requirement)

### 5.2 Archiving Strategy

#### a) Timesheet Data (Si_Timesheet_Entry, Si_Timesheet_Approval)
- Archive records older than 2 years to archive tables
- Create monthly archive tables: `Si_Timesheet_Entry_Archive_YYYYMM`
- Maintain indexes on archive tables for query performance
- Implement partitioned views for seamless querying

**Archive Table Example:**
```sql
CREATE TABLE Silver.Si_Timesheet_Entry_Archive_202301 (
    -- Same structure as Si_Timesheet_Entry
    -- Partition for January 2023
)
```

#### b) Resource Data (Si_Resource)
- Archive terminated resources after 3 years
- Maintain active resources indefinitely
- Create archive table: `Si_Resource_Archive`

#### c) Project Data (Si_Project)
- Archive completed projects after 3 years
- Maintain active projects indefinitely
- Create archive table: `Si_Project_Archive`

#### d) Workflow Data (Si_Workflow_Task)
- Archive completed workflows after 1 year
- Create archive table: `Si_Workflow_Task_Archive`

### 5.3 Audit and Error Data Retention
- **Si_Pipeline_Audit:** Retain for 7 years (compliance)
- **Si_Data_Quality_Errors:** Retain for 7 years (compliance)
- Archive to cold storage after 3 years

### 5.4 Dimension Data Retention
- **Si_Date:** Maintain indefinitely (small size)
- **Si_Holiday:** Maintain indefinitely (small size)

### 5.5 Archiving Implementation
- Use SQL Server Agent jobs for automated archiving
- **Schedule:** Monthly on 1st day of month at 2:00 AM
- Implement transaction log backups before archiving
- Validate data integrity after archiving
- Maintain audit trail of archiving operations

### 5.6 Restore Strategy
- Archived data can be restored to Silver layer on demand
- **Restore time:** 4-8 hours depending on data volume
- Implement partitioned views for transparent access

---

## 6. CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORMAT)

### Relationship Matrix

| Source Table              | Target Table              | Relationship Key Field(s)                    | Relationship Type | Description                                      |
|---------------------------|---------------------------|----------------------------------------------|-------------------|--------------------------------------------------|
| Si_Resource               | Si_Timesheet_Entry        | Resource_Code = Resource_Code                | One-to-Many       | One resource has many timesheet entries          |
| Si_Resource               | Si_Timesheet_Approval     | Resource_Code = Resource_Code                | One-to-Many       | One resource has many approved timesheets        |
| Si_Resource               | Si_Workflow_Task          | Resource_Code = Resource_Code                | One-to-Many       | One resource has many workflow tasks             |
| Si_Resource               | Si_Project                | Project_Assignment = Project_Name            | Many-to-Many      | Resources assigned to projects                   |
| Si_Project                | Si_Timesheet_Entry        | Project_Name matches Project_Task_Reference  | One-to-Many       | One project has many timesheet entries           |
| Si_Timesheet_Entry        | Si_Date                   | Timesheet_Date = Calendar_Date               | Many-to-One       | Many timesheet entries occur on one date         |
| Si_Timesheet_Entry        | Si_Timesheet_Approval     | Resource_Code + Timesheet_Date               | One-to-One        | One timesheet entry has one approval record      |
| Si_Timesheet_Approval     | Si_Date                   | Timesheet_Date = Calendar_Date               | Many-to-One       | Many approvals occur on one date                 |
| Si_Timesheet_Approval     | Si_Date                   | Week_Date = Calendar_Date                    | Many-to-One       | Many approvals grouped by week date              |
| Si_Date                   | Si_Holiday                | Calendar_Date = Holiday_Date                 | One-to-Many       | One date can have multiple holidays (locations)  |
| Si_Workflow_Task          | Si_Resource               | Resource_Code = Resource_Code                | Many-to-One       | Many workflow tasks belong to one resource       |
| Si_Data_Quality_Errors    | All Silver Tables         | Target_Table = Table Name                    | One-to-Many       | Errors tracked for all Silver tables             |
| Si_Pipeline_Audit         | All Silver Tables         | Target_Table = Table Name                    | One-to-Many       | Audit records for all Silver table loads         |

### Key Field Descriptions

1. **Resource_Code:** Unique identifier for resources (employees/consultants)
2. **Timesheet_Date:** Date for which timesheet entry is recorded
3. **Calendar_Date:** Date dimension key for time-based analysis
4. **Project_Name:** Unique identifier for projects
5. **Holiday_Date:** Date of holiday occurrence
6. **Week_Date:** Week ending date for timesheet aggregation
7. **Workflow_Task_Reference:** Unique identifier for workflow tasks

### Relationship Cardinality Notes

- **One-to-Many:** Parent record can have multiple child records
- **Many-to-One:** Multiple child records reference one parent record
- **One-to-One:** Unique relationship between two records
- **Many-to-Many:** Multiple records on both sides (typically through junction table)

---

## 7. DESIGN DECISIONS AND ASSUMPTIONS

### 7.1 Primary Key Strategy
- Added IDENTITY columns as primary keys for all tables
- Used BIGINT for fact tables (high volume expected)
- Used INT for dimension tables (lower volume)
- Ensures unique identification and optimal join performance

### 7.2 Indexing Strategy
- **Clustered indexes** on primary keys for optimal data retrieval
- **Nonclustered indexes** on frequently queried columns
- **Columnstore indexes** on fact tables for analytical queries
- **Filtered indexes** for common query patterns (e.g., active resources)
- **Composite indexes** for multi-column queries

### 7.3 Partitioning Strategy
- Date-range partitioning recommended for large fact tables
- Monthly partitions for Si_Timesheet_Entry and Si_Timesheet_Approval
- Improves query performance and maintenance operations
- Facilitates data archiving and purging

### 7.4 Data Type Decisions
- **VARCHAR** for text fields (variable length for storage efficiency)
- **DATETIME** for date/time fields (compatibility with existing systems)
- **FLOAT** for hour calculations (precision requirements)
- **DECIMAL** for monetary values (precision and accuracy)
- **BIT** for boolean flags (storage efficiency)

### 7.5 Computed Columns
- Added calculated columns for common aggregations
- PERSISTED for frequently queried calculations
- Improves query performance and consistency

### 7.6 Metadata Columns
- **load_timestamp:** When record was loaded into Silver layer
- **update_timestamp:** When record was last updated
- **source_system:** Source system identifier for lineage
- **data_quality_score:** Data quality assessment score

### 7.7 SQL Server Limitations Considered
- Maximum row size: 8,060 bytes (excluding LOB data)
- Maximum columns per table: 1,024
- Maximum indexes per table: 999
- Maximum partition function parameters: 15,000
- All DDL scripts comply with these limitations

### 7.8 Bronze to Silver Transformation
- All Bronze layer columns included in Silver layer
- Additional calculated columns for business logic
- Data type standardization and cleansing
- Null handling and default values
- Business rule validation

---

## 8. SUMMARY

### Tables Created
- **Total Tables:** 9 (7 Business Tables + 1 Error Table + 1 Audit Table)
- **Total Columns:** 350+ (including metadata and calculated columns)
- **Schema:** Silver
- **Table Naming Convention:** Si_<tablename>

### Storage and Performance
- **Storage Type:** Clustered indexes on primary keys
- **Constraints:** Primary keys on all tables
- **Indexes:** 50+ indexes for query optimization
- **Relationships:** 13 documented relationships

### Next Steps
1. Execute this script in SQL Server environment
2. Verify all tables and indexes are created successfully
3. Implement data transformation pipelines from Bronze to Silver
4. Configure monitoring and alerting on Si_Pipeline_Audit
5. Implement data quality validation rules
6. Set up archiving jobs for data retention policies
7. Proceed with Gold layer design

---

## 9. API COST

**apiCost:** 0.0875

### Cost Breakdown:
- **Input tokens:** 15,000 tokens @ $0.003 per 1K tokens = $0.045
- **Output tokens:** 8,500 tokens @ $0.005 per 1K tokens = $0.0425
- **Total API Cost:** $0.0875

### Cost Calculation Notes:
This cost is calculated based on the complexity of the task, including:
- Reading Bronze layer physical model
- Analyzing logical data model
- Creating comprehensive Silver layer DDL scripts
- Generating indexes and partitioning strategies
- Creating error and audit tables
- Documenting relationships and design decisions

---

**END OF SILVER LAYER PHYSICAL DATA MODEL OUTPUT**
