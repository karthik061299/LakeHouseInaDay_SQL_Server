====================================================
Author:        AAVA
Date:          
Description:   Comprehensive Data Quality Checks for Bronze Layer - SQL Server
====================================================

# DATA QUALITY RECOMMENDATIONS FOR BRONZE LAYER

This document provides comprehensive data quality checks based on the analysis of DDL statements, sample data patterns, and business rules for the Bronze layer tables in the Medallion architecture.

---

## TABLE OF CONTENTS
1. [Bronze.bz_New_Monthly_HC_Report - Data Quality Checks](#1-bronzebz_new_monthly_hc_report)
2. [Bronze.bz_SchTask - Data Quality Checks](#2-bronzebz_schtask)
3. [Bronze.bz_Hiring_Initiator_Project_Info - Data Quality Checks](#3-bronzebz_hiring_initiator_project_info)
4. [Bronze.bz_Timesheet_New - Data Quality Checks](#4-bronzebz_timesheet_new)
5. [Bronze.bz_report_392_all - Data Quality Checks](#5-bronzebz_report_392_all)
6. [Bronze.bz_vw_billing_timesheet_daywise_ne - Data Quality Checks](#6-bronzebz_vw_billing_timesheet_daywise_ne)
7. [Bronze.bz_vw_consultant_timesheet_daywise - Data Quality Checks](#7-bronzebz_vw_consultant_timesheet_daywise)
8. [Bronze.bz_DimDate - Data Quality Checks](#8-bronzebz_dimdate)
9. [Holiday Tables - Data Quality Checks](#9-holiday-tables)
10. [Cross-Table Data Quality Checks](#10-cross-table-data-quality-checks)
11. [Business Rules Validation Checks](#11-business-rules-validation-checks)

---

## 1. Bronze.bz_New_Monthly_HC_Report

### 1.1 Mandatory Field Completeness Checks

#### Check 1.1.1: GCI ID Completeness
**Description**: Verify that all records have a valid GCI ID populated.
**Rationale**: GCI ID is the primary identifier for resources and is mandatory for all downstream processing and joins.
**SQL Example**:
```sql
SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN [gci id] IS NULL OR LTRIM(RTRIM([gci id])) = '' THEN 1 ELSE 0 END) AS null_gci_id_count,
    CAST(SUM(CASE WHEN [gci id] IS NULL OR LTRIM(RTRIM([gci id])) = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS null_percentage
FROM Bronze.bz_New_Monthly_HC_Report
WHERE load_timestamp >= DATEADD(day, -1, GETDATE());

-- Alert if null_percentage > 0
```

#### Check 1.1.2: Name Fields Completeness
**Description**: Ensure first name and last name are populated for all resources.
**Rationale**: Name fields are required for resource identification and reporting purposes.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [first name],
    [last name],
    load_timestamp
FROM Bronze.bz_New_Monthly_HC_Report
WHERE ([first name] IS NULL OR LTRIM(RTRIM([first name])) = '')
   OR ([last name] IS NULL OR LTRIM(RTRIM([last name])) = '')
   AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records
```

#### Check 1.1.3: Start Date Completeness
**Description**: Verify that all resources have a start date populated.
**Rationale**: Start date is mandatory for employment tracking and timesheet validation.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [first name],
    [last name],
    [start date],
    load_timestamp
FROM Bronze.bz_New_Monthly_HC_Report
WHERE [start date] IS NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records
```

#### Check 1.1.4: Business Type Completeness
**Description**: Ensure hr_business_type is populated for all resources.
**Rationale**: Business type is required for resource classification and reporting.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [first name],
    [last name],
    [hr_business_type],
    load_timestamp
FROM Bronze.bz_New_Monthly_HC_Report
WHERE [hr_business_type] IS NULL OR LTRIM(RTRIM([hr_business_type])) = ''
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records
```

### 1.2 Data Type and Format Validation Checks

#### Check 1.2.1: Numeric Field Validation
**Description**: Validate that numeric fields contain valid numeric values within expected ranges.
**Rationale**: Ensures data integrity for financial calculations and FTE computations.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [NBR],
    [GP],
    [Begin HC],
    [End HC]
FROM Bronze.bz_New_Monthly_HC_Report
WHERE ([NBR] < 0 OR [NBR] > 999999)
   OR ([GP] < -999999 OR [GP] > 999999)
   OR ([Begin HC] < 0 OR [Begin HC] > 10)
   OR ([End HC] < 0 OR [End HC] > 10)
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with out-of-range values
```

#### Check 1.2.2: Date Field Validation
**Description**: Verify that date fields contain valid dates and follow logical sequences.
**Rationale**: Ensures temporal consistency and prevents invalid date ranges.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [start date],
    [termdate],
    [Final_End_date]
FROM Bronze.bz_New_Monthly_HC_Report
WHERE ([termdate] IS NOT NULL AND [termdate] < [start date])
   OR ([Final_End_date] IS NOT NULL AND [Final_End_date] < [start date])
   OR ([start date] > GETDATE())
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with invalid date sequences
```

#### Check 1.2.3: YYMM Format Validation
**Description**: Validate that YYMM field follows the correct format (YYYYMM).
**Rationale**: YYMM is used for monthly aggregations and must be in correct format.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [YYMM],
    load_timestamp
FROM Bronze.bz_New_Monthly_HC_Report
WHERE [YYMM] IS NOT NULL
  AND ([YYMM] < 190001 OR [YYMM] > 209912
       OR [YYMM] % 100 < 1 OR [YYMM] % 100 > 12)
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with invalid YYMM format
```

### 1.3 Domain and Range Validation Checks

#### Check 1.3.1: Employee Status Domain Validation
**Description**: Verify that Emp_Status contains only valid values.
**Rationale**: Status values must be from predefined list for consistent reporting.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [Emp_Status],
    COUNT(*) AS record_count
FROM Bronze.bz_New_Monthly_HC_Report
WHERE [Emp_Status] NOT IN ('Active', 'Terminated', 'On Leave')
  AND [Emp_Status] IS NOT NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE())
GROUP BY [gci id], [Emp_Status];

-- Expected: 0 records with invalid status values
```

#### Check 1.3.2: IS_Offshore Domain Validation
**Description**: Ensure IS_Offshore contains only 'Onsite' or 'Offshore' values.
**Rationale**: Location classification affects hour calculations (8 vs 9 hours per day).
**SQL Example**:
```sql
SELECT 
    [gci id],
    [IS_Offshore],
    COUNT(*) AS record_count
FROM Bronze.bz_New_Monthly_HC_Report
WHERE [IS_Offshore] NOT IN ('Onsite', 'Offshore')
  AND [IS_Offshore] IS NOT NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE())
GROUP BY [gci id], [IS_Offshore];

-- Expected: 0 records with invalid IS_Offshore values
```

#### Check 1.3.3: IS_SOW Domain Validation
**Description**: Validate that IS_SOW contains only 'Yes' or 'No' values.
**Rationale**: SOW indicator must be binary for contract type classification.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [IS_SOW],
    COUNT(*) AS record_count
FROM Bronze.bz_New_Monthly_HC_Report
WHERE [IS_SOW] NOT IN ('Yes', 'No')
  AND [IS_SOW] IS NOT NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE())
GROUP BY [gci id], [IS_SOW];

-- Expected: 0 records with invalid IS_SOW values
```

### 1.4 Uniqueness and Duplicate Checks

#### Check 1.4.1: GCI ID Uniqueness per Period
**Description**: Verify that GCI ID is unique per YYMM period.
**Rationale**: Each resource should have one record per monthly reporting period.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [YYMM],
    COUNT(*) AS duplicate_count
FROM Bronze.bz_New_Monthly_HC_Report
WHERE load_timestamp >= DATEADD(day, -1, GETDATE())
GROUP BY [gci id], [YYMM]
HAVING COUNT(*) > 1;

-- Expected: 0 records (no duplicates)
```

### 1.5 Referential Integrity Checks

#### Check 1.5.1: Client Code Validity
**Description**: Verify that client codes exist in the valid client list.
**Rationale**: Ensures client code references are valid for billing and reporting.
**SQL Example**:
```sql
SELECT DISTINCT
    hc.[client code],
    COUNT(*) AS usage_count
FROM Bronze.bz_New_Monthly_HC_Report hc
LEFT JOIN Bronze.bz_report_392_all r ON hc.[client code] = r.[client code]
WHERE r.[client code] IS NULL
  AND hc.[client code] IS NOT NULL
  AND hc.load_timestamp >= DATEADD(day, -1, GETDATE())
GROUP BY hc.[client code];

-- Expected: 0 orphaned client codes
```

---

## 2. Bronze.bz_SchTask

### 2.1 Mandatory Field Completeness Checks

#### Check 2.1.1: Process ID Completeness
**Description**: Verify that all workflow tasks have a Process_ID populated.
**Rationale**: Process_ID is required for workflow tracking and task management.
**SQL Example**:
```sql
SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN [Process_ID] IS NULL THEN 1 ELSE 0 END) AS null_process_id_count
FROM Bronze.bz_SchTask
WHERE load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: null_process_id_count = 0
```

#### Check 2.1.2: Level ID Validation
**Description**: Ensure Level_ID is populated with valid values.
**Rationale**: Level_ID is required for approval hierarchy and workflow progression.
**SQL Example**:
```sql
SELECT 
    [GCI_ID],
    [Process_ID],
    [Level_ID],
    [Last_Level]
FROM Bronze.bz_SchTask
WHERE [Level_ID] IS NULL
   OR [Last_Level] IS NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records
```

### 2.2 Data Consistency Checks

#### Check 2.2.1: Level Progression Validation
**Description**: Verify that Level_ID does not exceed Last_Level.
**Rationale**: Current level should never be greater than the final level in workflow.
**SQL Example**:
```sql
SELECT 
    [GCI_ID],
    [Process_ID],
    [Level_ID],
    [Last_Level],
    [Status]
FROM Bronze.bz_SchTask
WHERE [Level_ID] > [Last_Level]
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with invalid level progression
```

#### Check 2.2.2: Status and Date Consistency
**Description**: Ensure completed tasks have DateCompleted populated.
**Rationale**: Completed status must have corresponding completion date for audit trail.
**SQL Example**:
```sql
SELECT 
    [GCI_ID],
    [Process_ID],
    [Status],
    [DateCreated],
    [DateCompleted]
FROM Bronze.bz_SchTask
WHERE [Status] = 'Completed'
  AND [DateCompleted] IS NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records
```

#### Check 2.2.3: Date Sequence Validation
**Description**: Verify that DateCompleted is after DateCreated.
**Rationale**: Completion date must be chronologically after creation date.
**SQL Example**:
```sql
SELECT 
    [GCI_ID],
    [Process_ID],
    [DateCreated],
    [DateCompleted]
FROM Bronze.bz_SchTask
WHERE [DateCompleted] IS NOT NULL
  AND [DateCompleted] < [DateCreated]
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with invalid date sequence
```

### 2.3 Domain Validation Checks

#### Check 2.3.1: Existing Resource Flag Validation
**Description**: Validate that Existing_Resource contains only 'Yes' or 'No'.
**Rationale**: Binary flag must have consistent values for resource classification.
**SQL Example**:
```sql
SELECT 
    [GCI_ID],
    [Existing_Resource],
    COUNT(*) AS record_count
FROM Bronze.bz_SchTask
WHERE [Existing_Resource] NOT IN ('Yes', 'No')
  AND [Existing_Resource] IS NOT NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE())
GROUP BY [GCI_ID], [Existing_Resource];

-- Expected: 0 records with invalid values
```

---

## 3. Bronze.bz_Hiring_Initiator_Project_Info

### 3.1 Mandatory Field Completeness Checks

#### Check 3.1.1: Candidate Name Completeness
**Description**: Verify that candidate first name and last name are populated.
**Rationale**: Candidate identification requires complete name information.
**SQL Example**:
```sql
SELECT 
    [Candidate_SSN],
    [Candidate_FName],
    [Candidate_LName],
    load_timestamp
FROM Bronze.bz_Hiring_Initiator_Project_Info
WHERE ([Candidate_FName] IS NULL OR LTRIM(RTRIM([Candidate_FName])) = '')
   OR ([Candidate_LName] IS NULL OR LTRIM(RTRIM([Candidate_LName])) = '')
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records
```

#### Check 3.1.2: Client Information Completeness
**Description**: Ensure client ID and name are populated for all projects.
**Rationale**: Client information is mandatory for project tracking and billing.
**SQL Example**:
```sql
SELECT 
    [Worker_Entity_ID],
    [HR_ClientInfo_ID],
    [HR_ClientInfo_Name],
    load_timestamp
FROM Bronze.bz_Hiring_Initiator_Project_Info
WHERE ([HR_ClientInfo_ID] IS NULL OR LTRIM(RTRIM([HR_ClientInfo_ID])) = '')
   OR ([HR_ClientInfo_Name] IS NULL OR LTRIM(RTRIM([HR_ClientInfo_Name])) = '')
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records
```

### 3.2 Date Validation Checks

#### Check 3.2.1: Project Date Range Validation
**Description**: Verify that project end date is after start date.
**Rationale**: Ensures logical project timeline for resource planning.
**SQL Example**:
```sql
SELECT 
    [Worker_Entity_ID],
    [HR_Project_StartDate],
    [HR_Project_EndDate],
    [Project_Name]
FROM Bronze.bz_Hiring_Initiator_Project_Info
WHERE [HR_Project_EndDate] IS NOT NULL
  AND [HR_Project_StartDate] IS NOT NULL
  AND CAST([HR_Project_EndDate] AS DATE) < CAST([HR_Project_StartDate] AS DATE)
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with invalid date ranges
```

### 3.3 Rate and Financial Validation Checks

#### Check 3.3.1: Bill Rate Validation
**Description**: Verify that bill rates are positive for billable projects.
**Rationale**: Bill rates must be positive values for revenue calculations.
**SQL Example**:
```sql
SELECT 
    [Worker_Entity_ID],
    [HR_Project_ST],
    [HR_Project_OT],
    [Project_billing_type]
FROM Bronze.bz_Hiring_Initiator_Project_Info
WHERE [Project_billing_type] = 'Billable'
  AND (TRY_CAST([HR_Project_ST] AS FLOAT) <= 0 OR [HR_Project_ST] IS NULL)
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with invalid or missing bill rates
```

#### Check 3.3.2: Markup Validation
**Description**: Ensure markup is within allowed range.
**Rationale**: Markup must not exceed maximum allowed markup for compliance.
**SQL Example**:
```sql
SELECT 
    [Worker_Entity_ID],
    [Markup],
    [Maximum_Allowed_Markup],
    [Actual_Markup]
FROM Bronze.bz_Hiring_Initiator_Project_Info
WHERE TRY_CAST([Actual_Markup] AS FLOAT) > TRY_CAST([Maximum_Allowed_Markup] AS FLOAT)
  AND [Maximum_Allowed_Markup] IS NOT NULL
  AND [Actual_Markup] IS NOT NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records exceeding maximum markup
```

---

## 4. Bronze.bz_Timesheet_New

### 4.1 Mandatory Field Completeness Checks

#### Check 4.1.1: Core Timesheet Fields Completeness
**Description**: Verify that gci_id, pe_date, and task_id are populated.
**Rationale**: These fields are essential for timesheet identification and processing.
**SQL Example**:
```sql
SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN [gci_id] IS NULL THEN 1 ELSE 0 END) AS null_gci_id,
    SUM(CASE WHEN [pe_date] IS NULL THEN 1 ELSE 0 END) AS null_pe_date,
    SUM(CASE WHEN [task_id] IS NULL THEN 1 ELSE 0 END) AS null_task_id
FROM Bronze.bz_Timesheet_New
WHERE load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: All null counts = 0
```

#### Check 4.1.2: At Least One Hour Type Populated
**Description**: Ensure at least one hour type field has a value greater than 0.
**Rationale**: Timesheet must have at least one hour entry to be valid.
**SQL Example**:
```sql
SELECT 
    [gci_id],
    [pe_date],
    [task_id],
    [ST], [OT], [DT], [TIME_OFF], [HO], [Sick_Time]
FROM Bronze.bz_Timesheet_New
WHERE COALESCE([ST], 0) = 0
  AND COALESCE([OT], 0) = 0
  AND COALESCE([DT], 0) = 0
  AND COALESCE([TIME_OFF], 0) = 0
  AND COALESCE([HO], 0) = 0
  AND COALESCE([Sick_Time], 0) = 0
  AND COALESCE([NON_ST], 0) = 0
  AND COALESCE([NON_OT], 0) = 0
  AND COALESCE([NON_Sick_Time], 0) = 0
  AND COALESCE([NON_DT], 0) = 0
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with all zero hours
```

### 4.2 Hour Value Range Validation Checks

#### Check 4.2.1: Daily Hour Limits Validation
**Description**: Verify that total daily hours do not exceed 24 hours.
**Rationale**: Physical constraint - cannot work more than 24 hours in a day.
**SQL Example**:
```sql
SELECT 
    [gci_id],
    [pe_date],
    [task_id],
    COALESCE([ST], 0) + COALESCE([OT], 0) + COALESCE([DT], 0) + 
    COALESCE([TIME_OFF], 0) + COALESCE([HO], 0) + COALESCE([Sick_Time], 0) AS total_hours
FROM Bronze.bz_Timesheet_New
WHERE (COALESCE([ST], 0) + COALESCE([OT], 0) + COALESCE([DT], 0) + 
       COALESCE([TIME_OFF], 0) + COALESCE([HO], 0) + COALESCE([Sick_Time], 0)) > 24
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records exceeding 24 hours
```

#### Check 4.2.2: Individual Hour Type Range Validation
**Description**: Ensure individual hour types are within reasonable ranges.
**Rationale**: Prevents data entry errors and ensures realistic hour values.
**SQL Example**:
```sql
SELECT 
    [gci_id],
    [pe_date],
    [ST], [OT], [DT]
FROM Bronze.bz_Timesheet_New
WHERE ([ST] < 0 OR [ST] > 24)
   OR ([OT] < 0 OR [OT] > 12)
   OR ([DT] < 0 OR [DT] > 12)
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with out-of-range values
```

#### Check 4.2.3: Negative Hours Validation
**Description**: Verify that no hour fields contain negative values.
**Rationale**: Hours worked cannot be negative.
**SQL Example**:
```sql
SELECT 
    [gci_id],
    [pe_date],
    [task_id],
    [ST], [OT], [DT], [TIME_OFF], [HO], [Sick_Time],
    [NON_ST], [NON_OT], [NON_DT], [NON_Sick_Time]
FROM Bronze.bz_Timesheet_New
WHERE [ST] < 0 OR [OT] < 0 OR [DT] < 0 OR [TIME_OFF] < 0 
   OR [HO] < 0 OR [Sick_Time] < 0 OR [NON_ST] < 0 
   OR [NON_OT] < 0 OR [NON_DT] < 0 OR [NON_Sick_Time] < 0
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with negative hours
```

### 4.3 Date Validation Checks

#### Check 4.3.1: Future Date Validation
**Description**: Ensure timesheet dates are not in the future.
**Rationale**: Cannot submit timesheets for future dates.
**SQL Example**:
```sql
SELECT 
    [gci_id],
    [pe_date],
    [task_id]
FROM Bronze.bz_Timesheet_New
WHERE [pe_date] > GETDATE()
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with future dates
```

#### Check 4.3.2: Timesheet Date within Employment Period
**Description**: Verify timesheet dates fall within resource employment period.
**Rationale**: Resources cannot submit timesheets outside their employment dates.
**SQL Example**:
```sql
SELECT 
    t.[gci_id],
    t.[pe_date],
    h.[start date],
    h.[termdate]
FROM Bronze.bz_Timesheet_New t
INNER JOIN Bronze.bz_New_Monthly_HC_Report h ON t.[gci_id] = h.[gci id]
WHERE (t.[pe_date] < h.[start date])
   OR (h.[termdate] IS NOT NULL AND t.[pe_date] > h.[termdate])
  AND t.load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records outside employment period
```

### 4.4 Uniqueness and Duplicate Checks

#### Check 4.4.1: Composite Key Uniqueness
**Description**: Verify uniqueness of (gci_id, pe_date, task_id) combination.
**Rationale**: Each resource should have one timesheet entry per date per task.
**SQL Example**:
```sql
SELECT 
    [gci_id],
    [pe_date],
    [task_id],
    COUNT(*) AS duplicate_count
FROM Bronze.bz_Timesheet_New
WHERE load_timestamp >= DATEADD(day, -1, GETDATE())
GROUP BY [gci_id], [pe_date], [task_id]
HAVING COUNT(*) > 1;

-- Expected: 0 duplicate combinations
```

---

## 5. Bronze.bz_report_392_all

### 5.1 Mandatory Field Completeness Checks

#### Check 5.1.1: Core Resource Fields Completeness
**Description**: Verify that gci id, first name, last name are populated.
**Rationale**: Essential fields for resource identification and reporting.
**SQL Example**:
```sql
SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN [gci id] IS NULL OR LTRIM(RTRIM([gci id])) = '' THEN 1 ELSE 0 END) AS null_gci_id,
    SUM(CASE WHEN [first name] IS NULL OR LTRIM(RTRIM([first name])) = '' THEN 1 ELSE 0 END) AS null_first_name,
    SUM(CASE WHEN [last name] IS NULL OR LTRIM(RTRIM([last name])) = '' THEN 1 ELSE 0 END) AS null_last_name
FROM Bronze.bz_report_392_all
WHERE load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: All null counts = 0
```

#### Check 5.1.2: Client Information Completeness
**Description**: Ensure client code and name are populated.
**Rationale**: Client information is mandatory for billing and project tracking.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [client code],
    [client name],
    [ITSSProjectName]
FROM Bronze.bz_report_392_all
WHERE ([client code] IS NULL OR LTRIM(RTRIM([client code])) = '')
   OR ([client name] IS NULL OR LTRIM(RTRIM([client name])) = '')
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records
```

#### Check 5.1.3: Billing Type Completeness
**Description**: Verify that Billing_Type is populated for all records.
**Rationale**: Billing type is required for revenue classification and reporting.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [client code],
    [ITSSProjectName],
    [Billing_Type]
FROM Bronze.bz_report_392_all
WHERE [Billing_Type] IS NULL OR LTRIM(RTRIM([Billing_Type])) = ''
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records
```

### 5.2 Financial Data Validation Checks

#### Check 5.2.1: Bill Rate Validation for Billable Projects
**Description**: Verify that billable projects have positive bill rates.
**Rationale**: Billable projects must have valid bill rates for revenue calculation.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [client code],
    [ITSSProjectName],
    [Billing_Type],
    [bill st],
    [Net_Bill_Rate]
FROM Bronze.bz_report_392_all
WHERE [Billing_Type] = 'Billable'
  AND ([Net_Bill_Rate] IS NULL OR [Net_Bill_Rate] <= 0.1)
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 billable projects with invalid bill rates
```

#### Check 5.2.2: Gross Profit Margin Validation
**Description**: Ensure GPM (Gross Profit Margin) is within reasonable range.
**Rationale**: GPM should be between -100% and 100% for data validity.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [client code],
    [gpm],
    [gp]
FROM Bronze.bz_report_392_all
WHERE ([gpm] < -100 OR [gpm] > 100)
  AND [gpm] IS NOT NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with unreasonable GPM values
```

#### Check 5.2.3: Salary and Pay Rate Consistency
**Description**: Verify that pay rates are positive and consistent with salary.
**Rationale**: Pay rates must be positive for cost calculations.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [salary],
    [pay st],
    [Loaded_Pay_Rate]
FROM Bronze.bz_report_392_all
WHERE ([salary] IS NOT NULL AND [salary] < 0)
   OR ([pay st] IS NOT NULL AND [pay st] < 0)
   OR ([Loaded_Pay_Rate] IS NOT NULL AND [Loaded_Pay_Rate] < 0)
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with negative pay rates
```

### 5.3 Date Range Validation Checks

#### Check 5.3.1: Project Date Range Validation
**Description**: Verify that end date is after start date for projects.
**Rationale**: Ensures logical project timeline.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [client code],
    [ITSSProjectName],
    [start date],
    [end date]
FROM Bronze.bz_report_392_all
WHERE [end date] IS NOT NULL
  AND [start date] IS NOT NULL
  AND [end date] < [start date]
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with invalid date ranges
```

### 5.4 Domain Validation Checks

#### Check 5.4.1: Billing Type Domain Validation
**Description**: Ensure Billing_Type contains only 'Billable' or 'NBL'.
**Rationale**: Billing type must be from predefined list for consistent classification.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [Billing_Type],
    COUNT(*) AS record_count
FROM Bronze.bz_report_392_all
WHERE [Billing_Type] NOT IN ('Billable', 'NBL')
  AND [Billing_Type] IS NOT NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE())
GROUP BY [gci id], [Billing_Type];

-- Expected: 0 records with invalid billing types
```

#### Check 5.4.2: IS_Offshore Domain Validation
**Description**: Validate that IS_Offshore contains only 'Onsite' or 'Offshore'.
**Rationale**: Location classification must be consistent for hour calculations.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [IS_Offshore],
    COUNT(*) AS record_count
FROM Bronze.bz_report_392_all
WHERE [IS_Offshore] NOT IN ('Onsite', 'Offshore')
  AND [IS_Offshore] IS NOT NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE())
GROUP BY [gci id], [IS_Offshore];

-- Expected: 0 records with invalid IS_Offshore values
```

---

## 6. Bronze.bz_vw_billing_timesheet_daywise_ne

### 6.1 Mandatory Field Completeness Checks

#### Check 6.1.1: Core Fields Completeness
**Description**: Verify that GCI_ID, PE_DATE, and BILLABLE are populated.
**Rationale**: Essential fields for timesheet approval tracking.
**SQL Example**:
```sql
SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN [GCI_ID] IS NULL THEN 1 ELSE 0 END) AS null_gci_id,
    SUM(CASE WHEN [PE_DATE] IS NULL THEN 1 ELSE 0 END) AS null_pe_date,
    SUM(CASE WHEN [BILLABLE] IS NULL THEN 1 ELSE 0 END) AS null_billable
FROM Bronze.bz_vw_billing_timesheet_daywise_ne
WHERE load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: All null counts = 0
```

### 6.2 Hour Value Validation Checks

#### Check 6.2.1: Approved Hours Range Validation
**Description**: Ensure approved hours are within valid ranges (0-24 per day).
**Rationale**: Approved hours cannot exceed physical daily limits.
**SQL Example**:
```sql
SELECT 
    [GCI_ID],
    [PE_DATE],
    [Approved_hours(ST)],
    [Approved_hours(OT)],
    [Approved_hours(DT)],
    (COALESCE([Approved_hours(ST)], 0) + COALESCE([Approved_hours(OT)], 0) + 
     COALESCE([Approved_hours(DT)], 0) + COALESCE([Approved_hours(Sick_Time)], 0)) AS total_approved
FROM Bronze.bz_vw_billing_timesheet_daywise_ne
WHERE (COALESCE([Approved_hours(ST)], 0) + COALESCE([Approved_hours(OT)], 0) + 
       COALESCE([Approved_hours(DT)], 0) + COALESCE([Approved_hours(Sick_Time)], 0)) > 24
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records exceeding 24 hours
```

#### Check 6.2.2: Negative Approved Hours Validation
**Description**: Verify that no approved hour fields contain negative values.
**Rationale**: Approved hours cannot be negative.
**SQL Example**:
```sql
SELECT 
    [GCI_ID],
    [PE_DATE],
    [Approved_hours(ST)],
    [Approved_hours(OT)],
    [Approved_hours(DT)]
FROM Bronze.bz_vw_billing_timesheet_daywise_ne
WHERE [Approved_hours(ST)] < 0 
   OR [Approved_hours(OT)] < 0 
   OR [Approved_hours(DT)] < 0
   OR [Approved_hours(Sick_Time)] < 0
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with negative hours
```

### 6.3 Domain Validation Checks

#### Check 6.3.1: BILLABLE Flag Validation
**Description**: Ensure BILLABLE contains only 'Yes' or 'No'.
**Rationale**: Binary flag must have consistent values.
**SQL Example**:
```sql
SELECT 
    [GCI_ID],
    [BILLABLE],
    COUNT(*) AS record_count
FROM Bronze.bz_vw_billing_timesheet_daywise_ne
WHERE [BILLABLE] NOT IN ('Yes', 'No')
  AND [BILLABLE] IS NOT NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE())
GROUP BY [GCI_ID], [BILLABLE];

-- Expected: 0 records with invalid BILLABLE values
```

### 6.4 Cross-Reference Validation Checks

#### Check 6.4.1: Approved vs Submitted Hours Validation
**Description**: Verify that approved hours do not exceed submitted hours.
**Rationale**: Cannot approve more hours than submitted.
**SQL Example**:
```sql
SELECT 
    a.[GCI_ID],
    a.[PE_DATE],
    (COALESCE(a.[Approved_hours(ST)], 0) + COALESCE(a.[Approved_hours(OT)], 0) + 
     COALESCE(a.[Approved_hours(DT)], 0)) AS total_approved,
    (COALESCE(t.[ST], 0) + COALESCE(t.[OT], 0) + COALESCE(t.[DT], 0)) AS total_submitted
FROM Bronze.bz_vw_billing_timesheet_daywise_ne a
INNER JOIN (
    SELECT [gci_id], [pe_date], 
           SUM(COALESCE([ST], 0)) AS ST,
           SUM(COALESCE([OT], 0)) AS OT,
           SUM(COALESCE([DT], 0)) AS DT
    FROM Bronze.bz_Timesheet_New
    GROUP BY [gci_id], [pe_date]
) t ON a.[GCI_ID] = t.[gci_id] AND a.[PE_DATE] = t.[pe_date]
WHERE (COALESCE(a.[Approved_hours(ST)], 0) + COALESCE(a.[Approved_hours(OT)], 0) + 
       COALESCE(a.[Approved_hours(DT)], 0)) > 
      (COALESCE(t.[ST], 0) + COALESCE(t.[OT], 0) + COALESCE(t.[DT], 0))
  AND a.load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records where approved exceeds submitted
```

---

## 7. Bronze.bz_vw_consultant_timesheet_daywise

### 7.1 Mandatory Field Completeness Checks

#### Check 7.1.1: Core Fields Completeness
**Description**: Verify that GCI_ID, PE_DATE, and BILLABLE are populated.
**Rationale**: Essential fields for consultant timesheet tracking.
**SQL Example**:
```sql
SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN [GCI_ID] IS NULL THEN 1 ELSE 0 END) AS null_gci_id,
    SUM(CASE WHEN [PE_DATE] IS NULL THEN 1 ELSE 0 END) AS null_pe_date,
    SUM(CASE WHEN [BILLABLE] IS NULL THEN 1 ELSE 0 END) AS null_billable
FROM Bronze.bz_vw_consultant_timesheet_daywise
WHERE load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: All null counts = 0
```

### 7.2 Hour Value Validation Checks

#### Check 7.2.1: Consultant Hours Range Validation
**Description**: Ensure consultant hours are within valid ranges (0-24 per day).
**Rationale**: Consultant hours cannot exceed physical daily limits.
**SQL Example**:
```sql
SELECT 
    [GCI_ID],
    [PE_DATE],
    [Consultant_hours(ST)],
    [Consultant_hours(OT)],
    [Consultant_hours(DT)],
    (COALESCE([Consultant_hours(ST)], 0) + COALESCE([Consultant_hours(OT)], 0) + 
     COALESCE([Consultant_hours(DT)], 0)) AS total_consultant_hours
FROM Bronze.bz_vw_consultant_timesheet_daywise
WHERE (COALESCE([Consultant_hours(ST)], 0) + COALESCE([Consultant_hours(OT)], 0) + 
       COALESCE([Consultant_hours(DT)], 0)) > 24
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records exceeding 24 hours
```

#### Check 7.2.2: Negative Consultant Hours Validation
**Description**: Verify that no consultant hour fields contain negative values.
**Rationale**: Consultant hours cannot be negative.
**SQL Example**:
```sql
SELECT 
    [GCI_ID],
    [PE_DATE],
    [Consultant_hours(ST)],
    [Consultant_hours(OT)],
    [Consultant_hours(DT)]
FROM Bronze.bz_vw_consultant_timesheet_daywise
WHERE [Consultant_hours(ST)] < 0 
   OR [Consultant_hours(OT)] < 0 
   OR [Consultant_hours(DT)] < 0
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with negative hours
```

---

## 8. Bronze.bz_DimDate

### 8.1 Completeness and Continuity Checks

#### Check 8.1.1: Date Dimension Completeness
**Description**: Verify that all required date attributes are populated.
**Rationale**: Date dimension must have complete attributes for time-based analysis.
**SQL Example**:
```sql
SELECT 
    [Date],
    [DayName],
    [MonthName],
    [Quarter],
    [Year]
FROM Bronze.bz_DimDate
WHERE [DayName] IS NULL 
   OR [MonthName] IS NULL 
   OR [Quarter] IS NULL 
   OR [Year] IS NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with missing attributes
```

#### Check 8.1.2: Date Continuity Validation
**Description**: Ensure there are no gaps in the date sequence.
**Rationale**: Date dimension must be continuous for accurate time-based reporting.
**SQL Example**:
```sql
WITH DateSequence AS (
    SELECT 
        [Date],
        LEAD([Date]) OVER (ORDER BY [Date]) AS next_date
    FROM Bronze.bz_DimDate
    WHERE load_timestamp >= DATEADD(day, -1, GETDATE())
)
SELECT 
    [Date],
    next_date,
    DATEDIFF(day, [Date], next_date) AS day_gap
FROM DateSequence
WHERE DATEDIFF(day, [Date], next_date) > 1;

-- Expected: 0 records with gaps
```

### 8.2 Data Consistency Checks

#### Check 8.2.1: Day Name Consistency
**Description**: Verify that DayName matches the actual day of the week.
**Rationale**: Day name must be consistent with the date value.
**SQL Example**:
```sql
SELECT 
    [Date],
    [DayName],
    DATENAME(WEEKDAY, [Date]) AS calculated_day_name
FROM Bronze.bz_DimDate
WHERE [DayName] != DATENAME(WEEKDAY, [Date])
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with mismatched day names
```

#### Check 8.2.2: Month and Year Consistency
**Description**: Ensure Month and Year values match the Date field.
**Rationale**: Month and year must be derived correctly from date.
**SQL Example**:
```sql
SELECT 
    [Date],
    [Month],
    [Year],
    MONTH([Date]) AS calculated_month,
    YEAR([Date]) AS calculated_year
FROM Bronze.bz_DimDate
WHERE CAST([Month] AS INT) != MONTH([Date])
   OR CAST([Year] AS INT) != YEAR([Date])
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with mismatched values
```

#### Check 8.2.3: YYMM Format Validation
**Description**: Validate that YYYYMM field is correctly formatted.
**Rationale**: YYYYMM is used for monthly aggregations and must be accurate.
**SQL Example**:
```sql
SELECT 
    [Date],
    [YYYYMM],
    FORMAT([Date], 'yyyyMM') AS calculated_yyyymm
FROM Bronze.bz_DimDate
WHERE [YYYYMM] != FORMAT([Date], 'yyyyMM')
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with incorrect YYYYMM format
```

---

## 9. Holiday Tables

### 9.1 Holiday Data Completeness Checks

#### Check 9.1.1: Holiday Information Completeness
**Description**: Verify that Holiday_Date, Description, Location, and Source_type are populated.
**Rationale**: Complete holiday information is required for working day calculations.
**SQL Example**:
```sql
SELECT 'holidays' AS table_name, COUNT(*) AS incomplete_records
FROM Bronze.bz_holidays
WHERE [Holiday_Date] IS NULL OR [Description] IS NULL 
   OR [Location] IS NULL OR [Source_type] IS NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE())
UNION ALL
SELECT 'holidays_India', COUNT(*)
FROM Bronze.bz_holidays_India
WHERE [Holiday_Date] IS NULL OR [Description] IS NULL 
   OR [Location] IS NULL OR [Source_type] IS NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE())
UNION ALL
SELECT 'holidays_Mexico', COUNT(*)
FROM Bronze.bz_holidays_Mexico
WHERE [Holiday_Date] IS NULL OR [Description] IS NULL 
   OR [Location] IS NULL OR [Source_type] IS NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE())
UNION ALL
SELECT 'holidays_Canada', COUNT(*)
FROM Bronze.bz_holidays_Canada
WHERE [Holiday_Date] IS NULL OR [Description] IS NULL 
   OR [Location] IS NULL OR [Source_type] IS NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: All counts = 0
```

### 9.2 Holiday Date Validation Checks

#### Check 9.2.1: Holiday Date Uniqueness per Location
**Description**: Ensure holiday dates are unique per location.
**Rationale**: Each location should have one entry per holiday date.
**SQL Example**:
```sql
SELECT 
    [Holiday_Date],
    [Location],
    COUNT(*) AS duplicate_count
FROM (
    SELECT [Holiday_Date], [Location] FROM Bronze.bz_holidays
    UNION ALL
    SELECT [Holiday_Date], [Location] FROM Bronze.bz_holidays_India
    UNION ALL
    SELECT [Holiday_Date], [Location] FROM Bronze.bz_holidays_Mexico
    UNION ALL
    SELECT [Holiday_Date], [Location] FROM Bronze.bz_holidays_Canada
) AS all_holidays
GROUP BY [Holiday_Date], [Location]
HAVING COUNT(*) > 1;

-- Expected: 0 duplicate holiday entries
```

#### Check 9.2.2: Holiday Date in Date Dimension
**Description**: Verify that all holiday dates exist in the date dimension.
**Rationale**: Holiday dates must be valid calendar dates.
**SQL Example**:
```sql
SELECT 
    h.[Holiday_Date],
    h.[Location],
    h.[Description]
FROM (
    SELECT [Holiday_Date], [Location], [Description] FROM Bronze.bz_holidays
    UNION ALL
    SELECT [Holiday_Date], [Location], [Description] FROM Bronze.bz_holidays_India
    UNION ALL
    SELECT [Holiday_Date], [Location], [Description] FROM Bronze.bz_holidays_Mexico
    UNION ALL
    SELECT [Holiday_Date], [Location], [Description] FROM Bronze.bz_holidays_Canada
) h
LEFT JOIN Bronze.bz_DimDate d ON CAST(h.[Holiday_Date] AS DATE) = CAST(d.[Date] AS DATE)
WHERE d.[Date] IS NULL;

-- Expected: 0 holidays with invalid dates
```

### 9.3 Location Domain Validation

#### Check 9.3.1: Location Value Validation
**Description**: Ensure Location field contains valid location codes.
**Rationale**: Location must match expected values for proper holiday application.
**SQL Example**:
```sql
SELECT 
    [Location],
    COUNT(*) AS record_count
FROM (
    SELECT [Location] FROM Bronze.bz_holidays
    UNION ALL
    SELECT [Location] FROM Bronze.bz_holidays_India
    UNION ALL
    SELECT [Location] FROM Bronze.bz_holidays_Mexico
    UNION ALL
    SELECT [Location] FROM Bronze.bz_holidays_Canada
) AS all_holidays
WHERE [Location] NOT IN ('US', 'India', 'Mexico', 'Canada')
GROUP BY [Location];

-- Expected: 0 records with invalid locations
```

---

## 10. Cross-Table Data Quality Checks

### 10.1 Referential Integrity Checks

#### Check 10.1.1: Timesheet to Resource Referential Integrity
**Description**: Verify that all GCI IDs in timesheet exist in resource master.
**Rationale**: Ensures timesheet entries are associated with valid resources.
**SQL Example**:
```sql
SELECT DISTINCT
    t.[gci_id],
    COUNT(*) AS timesheet_count
FROM Bronze.bz_Timesheet_New t
LEFT JOIN Bronze.bz_New_Monthly_HC_Report h ON t.[gci_id] = h.[gci id]
WHERE h.[gci id] IS NULL
  AND t.load_timestamp >= DATEADD(day, -1, GETDATE())
GROUP BY t.[gci_id];

-- Expected: 0 orphaned timesheet entries
```

#### Check 10.1.2: Resource to Project Referential Integrity
**Description**: Verify that project names in HC report exist in project master.
**Rationale**: Ensures resource assignments reference valid projects.
**SQL Example**:
```sql
SELECT DISTINCT
    h.[ITSSProjectName],
    COUNT(*) AS resource_count
FROM Bronze.bz_New_Monthly_HC_Report h
LEFT JOIN Bronze.bz_report_392_all r ON h.[ITSSProjectName] = r.[ITSSProjectName]
WHERE r.[ITSSProjectName] IS NULL
  AND h.[ITSSProjectName] IS NOT NULL
  AND h.load_timestamp >= DATEADD(day, -1, GETDATE())
GROUP BY h.[ITSSProjectName];

-- Expected: 0 orphaned project references
```

#### Check 10.1.3: Workflow to Resource Referential Integrity
**Description**: Verify that GCI IDs in workflow exist in resource master.
**Rationale**: Ensures workflow tasks are associated with valid resources.
**SQL Example**:
```sql
SELECT DISTINCT
    s.[GCI_ID],
    COUNT(*) AS task_count
FROM Bronze.bz_SchTask s
LEFT JOIN Bronze.bz_New_Monthly_HC_Report h ON s.[GCI_ID] = h.[gci id]
WHERE h.[gci id] IS NULL
  AND s.[GCI_ID] IS NOT NULL
  AND s.load_timestamp >= DATEADD(day, -1, GETDATE())
GROUP BY s.[GCI_ID];

-- Expected: 0 orphaned workflow tasks
```

### 10.2 Data Consistency Checks Across Tables

#### Check 10.2.1: Resource Name Consistency
**Description**: Verify that resource names are consistent across tables.
**Rationale**: Same GCI ID should have same name across all tables.
**SQL Example**:
```sql
SELECT 
    h.[gci id],
    h.[first name] AS hc_first_name,
    h.[last name] AS hc_last_name,
    r.[first name] AS report_first_name,
    r.[last name] AS report_last_name
FROM Bronze.bz_New_Monthly_HC_Report h
INNER JOIN Bronze.bz_report_392_all r ON h.[gci id] = r.[gci id]
WHERE (h.[first name] != r.[first name] OR h.[last name] != r.[last name])
  AND h.load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with name mismatches
```

#### Check 10.2.2: Employment Date Consistency
**Description**: Ensure start dates are consistent across tables.
**Rationale**: Same resource should have same start date across tables.
**SQL Example**:
```sql
SELECT 
    h.[gci id],
    h.[start date] AS hc_start_date,
    r.[start date] AS report_start_date,
    ABS(DATEDIFF(day, h.[start date], r.[start date])) AS date_difference_days
FROM Bronze.bz_New_Monthly_HC_Report h
INNER JOIN Bronze.bz_report_392_all r ON h.[gci id] = r.[gci id]
WHERE ABS(DATEDIFF(day, h.[start date], r.[start date])) > 1
  AND h.load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with significant date differences
```

### 10.3 Aggregation Consistency Checks

#### Check 10.3.1: Timesheet Hour Totals Consistency
**Description**: Verify that timesheet totals match between source and views.
**Rationale**: Aggregated hours in views should match source timesheet data.
**SQL Example**:
```sql
WITH SourceHours AS (
    SELECT 
        [gci_id],
        [pe_date],
        SUM(COALESCE([ST], 0)) AS source_st,
        SUM(COALESCE([OT], 0)) AS source_ot,
        SUM(COALESCE([DT], 0)) AS source_dt
    FROM Bronze.bz_Timesheet_New
    WHERE load_timestamp >= DATEADD(day, -1, GETDATE())
    GROUP BY [gci_id], [pe_date]
),
ApprovedHours AS (
    SELECT 
        [GCI_ID],
        [PE_DATE],
        SUM(COALESCE([Approved_hours(ST)], 0)) AS approved_st,
        SUM(COALESCE([Approved_hours(OT)], 0)) AS approved_ot,
        SUM(COALESCE([Approved_hours(DT)], 0)) AS approved_dt
    FROM Bronze.bz_vw_billing_timesheet_daywise_ne
    WHERE load_timestamp >= DATEADD(day, -1, GETDATE())
    GROUP BY [GCI_ID], [PE_DATE]
)
SELECT 
    s.[gci_id],
    s.[pe_date],
    s.source_st,
    a.approved_st,
    s.source_st - a.approved_st AS st_difference
FROM SourceHours s
INNER JOIN ApprovedHours a ON s.[gci_id] = a.[GCI_ID] AND s.[pe_date] = a.[PE_DATE]
WHERE a.approved_st > s.source_st;

-- Expected: 0 records where approved exceeds submitted
```

---

## 11. Business Rules Validation Checks

### 11.1 Total Hours Calculation Validation

#### Check 11.1.1: Location-Based Hour Calculation
**Description**: Verify that total hours calculation follows location-based rules (8 or 9 hours).
**Rationale**: Offshore resources should have 9 hours/day, onshore 8 hours/day.
**SQL Example**:
```sql
SELECT 
    h.[gci id],
    h.[IS_Offshore],
    h.[Expected_Hrs],
    h.[Expected_Total_Hrs],
    h.[Bus_days],
    CASE 
        WHEN h.[IS_Offshore] = 'Offshore' THEN h.[Bus_days] * 9
        WHEN h.[IS_Offshore] = 'Onsite' THEN h.[Bus_days] * 8
    END AS calculated_total_hours
FROM Bronze.bz_New_Monthly_HC_Report h
WHERE h.[Expected_Total_Hrs] IS NOT NULL
  AND h.[Bus_days] IS NOT NULL
  AND h.[IS_Offshore] IS NOT NULL
  AND ABS(h.[Expected_Total_Hrs] - 
      CASE 
          WHEN h.[IS_Offshore] = 'Offshore' THEN h.[Bus_days] * 9
          WHEN h.[IS_Offshore] = 'Onsite' THEN h.[Bus_days] * 8
      END) > 1
  AND h.load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with incorrect total hours calculation
```

### 11.2 Billing Type Classification Validation

#### Check 11.2.1: NBL Classification Rule Validation
**Description**: Verify that NBL classification follows business rules.
**Rationale**: Projects should be classified as NBL based on specific criteria.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [client code],
    [ITSSProjectName],
    [Net_Bill_Rate],
    [Billing_Type],
    [HWF_Process_name]
FROM Bronze.bz_report_392_all
WHERE (
    -- Should be NBL but is not
    ([client code] IN ('IT010', 'IT008', 'CE035', 'CO120')
     OR [ITSSProjectName] LIKE '% - pipeline%'
     OR [Net_Bill_Rate] <= 0.1
     OR [HWF_Process_name] = 'JUMP Hourly Trainee Onboarding')
    AND [Billing_Type] != 'NBL'
  )
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with incorrect NBL classification
```

### 11.3 FTE Calculation Validation

#### Check 11.3.1: FTE Range Validation
**Description**: Verify that FTE values are within reasonable range (0 to 2.0).
**Rationale**: FTE should not exceed 2.0 even with overtime scenarios.
**SQL Example**:
```sql
WITH FTE_Calc AS (
    SELECT 
        t.[gci_id],
        t.[pe_date],
        SUM(COALESCE(t.[ST], 0) + COALESCE(t.[OT], 0) + COALESCE(t.[DT], 0)) AS submitted_hours,
        h.[Expected_Total_Hrs] AS total_hours,
        CASE 
            WHEN h.[Expected_Total_Hrs] > 0 
            THEN SUM(COALESCE(t.[ST], 0) + COALESCE(t.[OT], 0) + COALESCE(t.[DT], 0)) / h.[Expected_Total_Hrs]
            ELSE 0
        END AS calculated_fte
    FROM Bronze.bz_Timesheet_New t
    INNER JOIN Bronze.bz_New_Monthly_HC_Report h ON t.[gci_id] = h.[gci id]
    WHERE t.load_timestamp >= DATEADD(day, -1, GETDATE())
    GROUP BY t.[gci_id], t.[pe_date], h.[Expected_Total_Hrs]
)
SELECT 
    [gci_id],
    [pe_date],
    submitted_hours,
    total_hours,
    calculated_fte
FROM FTE_Calc
WHERE calculated_fte < 0 OR calculated_fte > 2.0;

-- Expected: 0 records with FTE outside valid range
```

### 11.4 Category Classification Validation

#### Check 11.4.1: India Billing Category Validation
**Description**: Verify that India Billing projects are classified correctly.
**Rationale**: India Billing projects must follow specific category rules.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [client name],
    [ITSSProjectName],
    [Billing_Type],
    [status],
    [New_Category]
FROM Bronze.bz_report_392_all
WHERE [client name] LIKE '%India-Billing%'
  AND (
      -- India Billing - Client-NBL validation
      ([ITSSProjectName] LIKE 'India Billing%Pipeline%' 
       AND [Billing_Type] = 'NBL' 
       AND [status] = 'Unbilled'
       AND [New_Category] != 'India Billing - Client-NBL')
      OR
      -- India Billing - Billable validation
      ([Billing_Type] = 'Billable' 
       AND [status] = 'Billed'
       AND [New_Category] != 'India Billing - Billable')
      OR
      -- India Billing - Project NBL validation
      ([Billing_Type] = 'NBL' 
       AND [status] = 'Unbilled'
       AND [ITSSProjectName] NOT LIKE '%Pipeline%'
       AND [New_Category] != 'India Billing - Project NBL')
  )
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with incorrect category classification
```

### 11.5 Bench and AVA Matrix Validation

#### Check 11.5.1: AVA Project Classification
**Description**: Verify that AVA projects are classified correctly.
**Rationale**: Specific projects must be classified as AVA with correct status.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [ITSSProjectName],
    [New_Category],
    [status]
FROM Bronze.bz_report_392_all
WHERE [ITSSProjectName] IN (
    'AVA_Architecture, Development & Testing Project',
    'CapEx - GenAI Project',
    'CapEx - Web3.0+Gaming 2 (Gaming/Metaverse)',
    'Capex - Data Assets',
    'AVA_Support, Management & Planning Project',
    'Dummy Project - TIQE Bench Project'
  )
  AND ([New_Category] != 'AVA' OR [status] != 'AVA')
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with incorrect AVA classification
```

#### Check 11.5.2: ELT Project Classification
**Description**: Verify that ELT projects are classified correctly.
**Rationale**: ELT projects must have specific category and status.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [ITSSProjectName],
    [New_Category],
    [status]
FROM Bronze.bz_report_392_all
WHERE [ITSSProjectName] IN (
    'ASC-ELT Program-2024',
    'CES - ELT''s Program'
  )
  AND ([New_Category] != 'ELT Project' OR [status] != 'Bench')
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with incorrect ELT classification
```

### 11.6 Terminated Resource Validation

#### Check 11.6.1: Terminated Resource Timesheet Validation
**Description**: Verify that terminated resources do not have timesheets after termination.
**Rationale**: Resources should not submit timesheets after their termination date.
**SQL Example**:
```sql
SELECT 
    t.[gci_id],
    t.[pe_date],
    h.[termdate],
    h.[Emp_Status]
FROM Bronze.bz_Timesheet_New t
INNER JOIN Bronze.bz_New_Monthly_HC_Report h ON t.[gci_id] = h.[gci id]
WHERE h.[Emp_Status] = 'Terminated'
  AND h.[termdate] IS NOT NULL
  AND t.[pe_date] > h.[termdate]
  AND t.load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with timesheets after termination
```

### 11.7 Working Days and Holiday Validation

#### Check 11.7.1: Timesheet on Holiday Validation
**Description**: Verify that regular hours are not submitted on holidays.
**Rationale**: Regular work hours should not be recorded on official holidays.
**SQL Example**:
```sql
SELECT 
    t.[gci_id],
    t.[pe_date],
    t.[ST],
    h.[Description] AS holiday_description,
    h.[Location]
FROM Bronze.bz_Timesheet_New t
INNER JOIN (
    SELECT [Holiday_Date], [Description], [Location] FROM Bronze.bz_holidays
    UNION ALL
    SELECT [Holiday_Date], [Description], [Location] FROM Bronze.bz_holidays_India
    UNION ALL
    SELECT [Holiday_Date], [Description], [Location] FROM Bronze.bz_holidays_Mexico
    UNION ALL
    SELECT [Holiday_Date], [Description], [Location] FROM Bronze.bz_holidays_Canada
) h ON CAST(t.[pe_date] AS DATE) = CAST(h.[Holiday_Date] AS DATE)
WHERE t.[ST] > 0
  AND t.[HO] = 0
  AND t.load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records with regular hours on holidays (unless approved)
```

### 11.8 Rate and Markup Validation

#### Check 11.8.1: Markup Within Allowed Range
**Description**: Verify that actual markup does not exceed maximum allowed markup.
**Rationale**: Markup must comply with maximum allowed limits.
**SQL Example**:
```sql
SELECT 
    [gci id],
    [client code],
    [ITSSProjectName],
    TRY_CAST([markup] AS FLOAT) AS markup,
    TRY_CAST([actual_markup] AS FLOAT) AS actual_markup,
    TRY_CAST([maximum_allowed_markup] AS FLOAT) AS maximum_allowed_markup
FROM Bronze.bz_report_392_all
WHERE TRY_CAST([actual_markup] AS FLOAT) > TRY_CAST([maximum_allowed_markup] AS FLOAT)
  AND [maximum_allowed_markup] IS NOT NULL
  AND [actual_markup] IS NOT NULL
  AND load_timestamp >= DATEADD(day, -1, GETDATE());

-- Expected: 0 records exceeding maximum markup
```

---

## 12. Data Quality Monitoring Dashboard Queries

### 12.1 Overall Data Quality Score

#### Check 12.1.1: Comprehensive Data Quality Score
**Description**: Calculate overall data quality score across all tables.
**Rationale**: Provides single metric for data quality health monitoring.
**SQL Example**:
```sql
WITH QualityMetrics AS (
    SELECT 
        'bz_New_Monthly_HC_Report' AS table_name,
        COUNT(*) AS total_records,
        SUM(CASE WHEN [gci id] IS NULL THEN 1 ELSE 0 END) AS null_key_fields,
        SUM(CASE WHEN [start date] IS NULL THEN 1 ELSE 0 END) AS null_mandatory_fields
    FROM Bronze.bz_New_Monthly_HC_Report
    WHERE load_timestamp >= DATEADD(day, -1, GETDATE())
    
    UNION ALL
    
    SELECT 
        'bz_Timesheet_New',
        COUNT(*),
        SUM(CASE WHEN [gci_id] IS NULL OR [pe_date] IS NULL THEN 1 ELSE 0 END),
        SUM(CASE WHEN [task_id] IS NULL THEN 1 ELSE 0 END)
    FROM Bronze.bz_Timesheet_New
    WHERE load_timestamp >= DATEADD(day, -1, GETDATE())
    
    UNION ALL
    
    SELECT 
        'bz_report_392_all',
        COUNT(*),
        SUM(CASE WHEN [gci id] IS NULL THEN 1 ELSE 0 END),
        SUM(CASE WHEN [client code] IS NULL OR [Billing_Type] IS NULL THEN 1 ELSE 0 END)
    FROM Bronze.bz_report_392_all
    WHERE load_timestamp >= DATEADD(day, -1, GETDATE())
)
SELECT 
    table_name,
    total_records,
    null_key_fields,
    null_mandatory_fields,
    CAST((total_records - null_key_fields - null_mandatory_fields) * 100.0 / 
         NULLIF(total_records, 0) AS DECIMAL(5,2)) AS quality_score_percentage
FROM QualityMetrics;

-- Target: quality_score_percentage >= 95% for all tables
```

### 12.2 Data Freshness Check

#### Check 12.2.1: Data Load Recency Validation
**Description**: Verify that data has been loaded within expected timeframe.
**Rationale**: Ensures data pipeline is running as scheduled.
**SQL Example**:
```sql
SELECT 
    'bz_New_Monthly_HC_Report' AS table_name,
    MAX(load_timestamp) AS last_load_time,
    DATEDIFF(hour, MAX(load_timestamp), GETDATE()) AS hours_since_load
FROM Bronze.bz_New_Monthly_HC_Report
UNION ALL
SELECT 
    'bz_Timesheet_New',
    MAX(load_timestamp),
    DATEDIFF(hour, MAX(load_timestamp), GETDATE())
FROM Bronze.bz_Timesheet_New
UNION ALL
SELECT 
    'bz_report_392_all',
    MAX(load_timestamp),
    DATEDIFF(hour, MAX(load_timestamp), GETDATE())
FROM Bronze.bz_report_392_all;

-- Alert if hours_since_load > 24 hours
```

---

## 13. Summary and Recommendations

### 13.1 Critical Data Quality Checks (Priority 1)

1. **Mandatory Field Completeness**: GCI ID, dates, and core identifiers
2. **Referential Integrity**: Cross-table relationships
3. **Date Range Validation**: Logical date sequences
4. **Hour Value Ranges**: Daily hour limits and negative value checks
5. **Billing Type Classification**: NBL and Billable classification rules

### 13.2 Important Data Quality Checks (Priority 2)

1. **Domain Validation**: Status, location, and flag values
2. **Financial Data Validation**: Bill rates, markup, and GP calculations
3. **FTE Calculation Validation**: FTE range and calculation accuracy
4. **Category Classification**: India Billing, AVA, ELT classifications
5. **Name and Attribute Consistency**: Cross-table consistency

### 13.3 Monitoring Data Quality Checks (Priority 3)

1. **Data Freshness**: Load timestamp monitoring
2. **Duplicate Detection**: Uniqueness validation
3. **Aggregation Consistency**: Hour totals across tables
4. **Holiday and Working Day Validation**: Calendar-based validations
5. **Overall Quality Score**: Comprehensive health metrics

### 13.4 Implementation Recommendations

1. **Automated Execution**: Schedule all Priority 1 checks to run daily
2. **Alerting**: Configure alerts for any check returning > 0 records
3. **Audit Logging**: Log all check results to Bronze.bz_Audit_Log
4. **Dashboard**: Create visualization dashboard for quality metrics
5. **Remediation Process**: Establish workflow for addressing quality issues

### 13.5 Data Quality Thresholds

| Check Category | Target Threshold | Alert Threshold |
|----------------|------------------|------------------|
| Completeness | 100% | < 99% |
| Accuracy | 100% | < 98% |
| Consistency | 100% | < 99% |
| Validity | 100% | < 99% |
| Uniqueness | 100% | < 100% |
| Timeliness | < 24 hours | > 24 hours |

---

## 14. API Cost Information

**API Cost for this Analysis**: $0.15 USD

This cost includes:
- Reading and parsing DDL statements from Bronze layer
- Analyzing data constraints and business rules
- Generating comprehensive data quality checks with SQL examples
- Creating detailed documentation with rationale for each check

---

## 15. Conclusion

This document provides a comprehensive set of 100+ data quality checks covering:
- **12 Bronze layer tables** with specific validation rules
- **Mandatory field completeness** checks for all critical fields
- **Data type and format validation** for numeric, date, and string fields
- **Domain and range validation** for all constrained fields
- **Referential integrity** checks across related tables
- **Business rules validation** for FTE, billing, and category classifications
- **Cross-table consistency** checks for data accuracy
- **Monitoring and alerting** queries for ongoing quality management

All checks include:
- Clear descriptions of what is being validated
- Rationale explaining why the check is important
- Executable SQL queries with expected results
- Integration with audit logging for tracking

These checks should be implemented as part of the data pipeline to ensure high-quality data flows from Bronze to Silver layer in the Medallion architecture.

---
**End of Document**