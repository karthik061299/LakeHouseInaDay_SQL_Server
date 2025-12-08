------------------------------------------------------------------------
Author:        AAVA       
Date:          
Description:   Data Expectations, Constraints, and Business Rules for UTL Reporting Data Model
------------------------------------------------------------------------

# DATA EXPECTATIONS, CONSTRAINTS, AND BUSINESS RULES

## 1. DATA EXPECTATIONS

Data Expectations define the quality standards, completeness requirements, accuracy measures, format specifications, and consistency rules that the data must meet to ensure reliable reporting and analytics.

### 1.1 Data Completeness Expectations

1. **Employee Master Data Completeness**
   - Every resource must have a valid GCI_ID (Employee Code) in source_layer.New_Monthly_HC_Report
   - First name and last name are mandatory for all employees
   - Job title must be populated for all active employees
   - HR_business_type must be specified for FTE classification
   - Start date is mandatory for all employee records

2. **Timesheet Data Completeness**
   - Every timesheet entry in source_layer.Timesheet_New must have gci_id, pe_date, and task_id
   - At least one hour category (ST, OT, DT, Sick_Time) must have a non-zero value
   - Timesheet date (pe_date) must fall within the employee's active period
   - Task_id must reference a valid workflow/project assignment

3. **Project Assignment Completeness**
   - Every assignment in source_layer.report_392_all must have gci id, client name, and ITSSProjectName
   - Start date is mandatory for all project assignments
   - Billing_Type must be specified (Billable or NBL)
   - Category and Status must be derived based on business rules

4. **Calendar and Holiday Data Completeness**
   - source_layer.DimDate must contain all dates within the reporting period
   - DayName must be populated for weekend identification
   - Holiday tables (holidays, holidays_India, holidays_Canada, holidays_Mexico) must contain all applicable holidays for respective locations
   - Location field must be populated in all holiday tables

### 1.2 Data Accuracy Expectations

1. **Hours Calculation Accuracy**
   - Total Hours calculation must accurately reflect working days excluding weekends and location-specific holidays
   - Offshore (India) resources: 9 hours per working day
   - Onshore (US, Canada, LATAM, Mexico): 8 hours per working day
   - Submitted Hours must equal the sum of all timesheet hour categories submitted by resource
   - Approved Hours must equal the sum of all approved hour categories

2. **FTE Calculation Accuracy**
   - Total FTE = Submitted Hours / Total Hours (must be calculated consistently)
   - Billed FTE = Approved Hours / Total Hours (or Submitted Hours if Approved is unavailable)
   - FTE values must be between 0 and 1 for single project assignments
   - For multiple project allocations, sum of FTE across all projects should equal 1.0

3. **Weighted Average Allocation Accuracy**
   - When a resource is allocated to multiple projects, Total Hours must be distributed based on the ratio of Submitted Hours for each project
   - Any difference between distributed hours and actual working hours must be adjusted proportionally
   - Project Utilization = Billed Hours / Available Hours must be calculated accurately

4. **Date Range Accuracy**
   - Employee start date must be less than or equal to end date
   - Project start date must be less than or equal to project end date
   - Timesheet dates must fall within valid project assignment periods
   - Term date, offboarding date, and end date must be logically consistent

### 1.3 Data Format Expectations

1. **Date Format Standards**
   - All date fields must be in datetime format
   - YYMM format: (DATEPART(yyyy, date) * 100 + DATEPART(MONTH, date))
   - Date fields: start date, end date, pe_date, c_date, Holiday_Date must be valid datetime values

2. **Numeric Format Standards**
   - GCI_ID must be numeric or varchar containing numeric values
   - Hour fields (ST, OT, DT, Sick_Time, etc.) must be float or numeric with appropriate precision
   - Bill rates and pay rates must be money or decimal data types
   - FTE calculations must be decimal values with precision up to 5 decimal places

3. **Text Format Standards**
   - Employee names (first name, last name) must be varchar(50)
   - Project names (ITSSProjectName) must be varchar(200)
   - Client names must be varchar(60)
   - Status values must follow controlled vocabulary: Billed, Unbilled, SGA, Bench, AVA
   - Category values must follow controlled vocabulary based on business rules

4. **Code Format Standards**
   - Client code must follow standard format (e.g., IT010, IT008, CE035, CO120)
   - Location codes must be standardized (India, US, Canada, Mexico, LATAM)
   - Billing_Type must be either 'Billable' or 'NBL'

### 1.4 Data Consistency Expectations

1. **Cross-Table Consistency**
   - GCI_ID in source_layer.Timesheet_New must exist in source_layer.New_Monthly_HC_Report
   - GCI_ID in source_layer.report_392_all must exist in source_layer.New_Monthly_HC_Report
   - Task_id in source_layer.Timesheet_New must exist in source_layer.SchTask
   - Holiday_Date in holiday tables must exist in source_layer.DimDate

2. **Temporal Consistency**
   - Timesheet entries must not exist before employee start date
   - Timesheet entries must not exist after employee termination date (unless valid extension)
   - Project assignments must align with employee active periods
   - Working day calculations must consistently exclude weekends and holidays

3. **Business Logic Consistency**
   - Billing_Type derivation must be consistent across all records
   - Category assignment must follow India Billing Matrix and Client Project Matrix rules consistently
   - Status assignment must align with Category values
   - FTE/Consultant classification must be consistent based on Process_name and HR_Subtier_Company

4. **Aggregation Consistency**
   - Sum of hours across all categories must equal total submitted/approved hours
   - Sum of FTE across multiple projects for same resource must equal 1.0
   - Available Hours must equal Monthly Hours × Total FTE
   - Onsite Hours + Offsite Hours must equal Total Actual Hours

### 1.5 Data Timeliness Expectations

1. **Timesheet Submission Timeliness**
   - Timesheet data must be submitted within the defined week cycle
   - Approved hours must be updated within defined approval timeframes
   - Late submissions must be flagged for reporting purposes

2. **Master Data Update Timeliness**
   - Employee master data changes must be reflected within 24 hours
   - Project assignment changes must be updated in real-time or near real-time
   - Holiday calendar updates must be completed before the start of each fiscal year

3. **Reporting Data Refresh**
   - UTL dashboard data must be refreshed on a defined schedule (daily/weekly)
   - Historical data must be preserved for trend analysis
   - System runtime timestamp must be captured for all data loads

---

## 2. CONSTRAINTS

Constraints define the mandatory rules, limitations, and restrictions that must be enforced at the data model level to maintain data integrity and quality.

### 2.1 Mandatory Field Constraints

1. **source_layer.Timesheet_New - Mandatory Fields**
   - gci_id: NOT NULL (Employee identifier is mandatory)
   - pe_date: NOT NULL (Timesheet date is mandatory)
   - task_id: NOT NULL (Task/workflow reference is mandatory)
   - At least one hour category (ST, OT, DT, Sick_Time, etc.) must have a value > 0

2. **source_layer.New_Monthly_HC_Report - Mandatory Fields**
   - gci id: NOT NULL (Employee code is mandatory)
   - first name: NOT NULL (First name is mandatory)
   - last name: NOT NULL (Last name is mandatory)
   - hr_business_type: NOT NULL (Business type classification is mandatory)
   - start date: NOT NULL (Employment start date is mandatory)
   - Emp_Status: NOT NULL (Employment status is mandatory)

3. **source_layer.report_392_all - Mandatory Fields**
   - gci id: NOT NULL (Employee identifier is mandatory)
   - client name: NOT NULL (Client name is mandatory)
   - ITSSProjectName: NOT NULL (Project name is mandatory)
   - start date: NOT NULL (Assignment start date is mandatory)
   - Billing_Type: NOT NULL (Billing classification is mandatory)
   - Category: NOT NULL (Derived category is mandatory)
   - Status: NOT NULL (Derived status is mandatory)

4. **source_layer.SchTask - Mandatory Fields**
   - ID: NOT NULL, IDENTITY(1,1) (Primary key)
   - GCI_ID: NOT NULL (Employee identifier is mandatory)
   - Process_ID: NOT NULL (Workflow process identifier is mandatory)
   - Level_ID: NOT NULL DEFAULT 0 (Workflow level is mandatory)

5. **source_layer.DimDate - Mandatory Fields**
   - DateKey: NOT NULL, PRIMARY KEY (Unique date identifier)
   - Date: NOT NULL (Calendar date is mandatory)
   - DayName: NOT NULL (Day name for weekend identification)
   - Month: NOT NULL (Month number is mandatory)
   - Year: NOT NULL (Year is mandatory)

6. **Holiday Tables - Mandatory Fields**
   - Holiday_Date: NOT NULL (Holiday date is mandatory)
   - Description: NOT NULL (Holiday description is mandatory)
   - Location: NOT NULL (Geographic location is mandatory)
   - Source_type: NOT NULL (Source identification is mandatory)

### 2.2 Uniqueness Constraints

1. **Primary Key Constraints**
   - source_layer.SchTask: ID is PRIMARY KEY (unique identifier for each workflow task)
   - source_layer.DimDate: DateKey is PRIMARY KEY (unique identifier for each date)
   - source_layer.Hiring_Initiator_Project_Info: ID has UNIQUE constraint

2. **Composite Uniqueness Constraints**
   - source_layer.Timesheet_New: Combination of (gci_id, pe_date, task_id) should be unique
   - source_layer.report_392_all: Combination of (gci id, ITSSProjectName, start date) should identify unique assignments
   - Holiday tables: Combination of (Holiday_Date, Location) should be unique

3. **Business Key Uniqueness**
   - GCI_ID should be unique per employee in source_layer.New_Monthly_HC_Report for active records
   - Task_id should be unique per workflow instance in source_layer.SchTask
   - Employee Code (GCI_ID) should not have duplicate active assignments to same project

### 2.3 Data Type Constraints

1. **Numeric Data Type Constraints**
   - gci_id: INT or VARCHAR(50) containing numeric values
   - task_id: NUMERIC(18,9)
   - Hour fields (ST, OT, DT, etc.): FLOAT (must be >= 0)
   - FTE calculations: DECIMAL with precision (38,36)
   - Bill rates: MONEY or DECIMAL(18,9)
   - ID fields: NUMERIC(18,0) or INT

2. **Date/Time Data Type Constraints**
   - All date fields: DATETIME (must be valid datetime values)
   - pe_date, c_date, start date, end date, termdate: DATETIME
   - Holiday_Date: DATETIME
   - Date range: Must be within valid business date range (e.g., 1900-01-01 to 2099-12-31)

3. **String Data Type Constraints**
   - Employee names: VARCHAR(50)
   - Project names: VARCHAR(200)
   - Client names: VARCHAR(60)
   - Status fields: VARCHAR(50)
   - Location: VARCHAR(10) or VARCHAR(50)
   - Description fields: VARCHAR(50) to VARCHAR(8000) based on requirement

4. **Boolean/Flag Data Type Constraints**
   - IsBillRateSkip: BIT (0 or 1)
   - isbulk: BIT NOT NULL
   - jump: BIT NOT NULL
   - client_consent: BIT

### 2.4 Domain Constraints (Valid Value Ranges)

1. **Hour Value Constraints**
   - ST, OT, DT, Sick_Time, TIME_OFF, HO: Must be >= 0 and <= 24 per day
   - Total daily hours (sum of all categories): Should not exceed 24 hours
   - Weekly hours: Should be reasonable (typically <= 168 hours)
   - Monthly hours: Should align with working days calculation

2. **FTE Value Constraints**
   - Total FTE: Must be >= 0 and <= 1 for single project allocation
   - Billed FTE: Must be >= 0 and <= 1 for single project allocation
   - Sum of FTE across multiple projects: Should equal 1.0 (with tolerance for rounding)
   - Project Utilization: Must be >= 0 and <= 1

3. **Status Domain Constraints**
   - Status field must be one of: 'Billed', 'Unbilled', 'SGA', 'Bench', 'AVA'
   - Emp_Status must be one of: 'Active', 'Terminated', 'On Bench', etc.
   - employee_status must align with workflow status values

4. **Category Domain Constraints**
   - Category must be one of:
     - 'India Billing - Client-NBL'
     - 'India Billing - Billable'
     - 'India Billing - Project NBL'
     - 'Client-NBL'
     - 'Project-NBL'
     - 'Billable'
     - 'SGA'
     - 'AVA'
     - 'ELT Project'
     - 'Bench'

5. **Billing_Type Domain Constraints**
   - Billing_Type must be either 'Billable' or 'NBL'
   - Derived based on client code, project name, Net_Bill_Rate, and HWF_Process_name

6. **Location Domain Constraints**
   - Location must be one of: 'India', 'US', 'Canada', 'Mexico', 'LATAM', or other defined regions
   - IS_Offshore must be 'Offshore' or 'OnSite'
   - Business area must be one of: 'NA', 'LATAM', 'India', 'Others'

7. **Date Range Constraints**
   - start date must be <= end date
   - pe_date must be >= employee start date
   - pe_date must be <= current date (no future timesheets)
   - Holiday_Date must be within valid calendar range

### 2.5 Referential Integrity Constraints

1. **Employee Reference Integrity**
   - gci_id in source_layer.Timesheet_New must reference valid gci id in source_layer.New_Monthly_HC_Report
   - gci id in source_layer.report_392_all must reference valid gci id in source_layer.New_Monthly_HC_Report
   - GCI_ID in source_layer.SchTask must reference valid employee records

2. **Task/Workflow Reference Integrity**
   - task_id in source_layer.Timesheet_New should reference ID in source_layer.SchTask
   - Process_ID in source_layer.SchTask should reference valid workflow process definitions

3. **Date Reference Integrity**
   - pe_date in source_layer.Timesheet_New should exist in source_layer.DimDate
   - start date, end date in assignment tables should exist in source_layer.DimDate
   - Holiday_Date in holiday tables must exist in source_layer.DimDate

4. **Project Reference Integrity**
   - ITSSProjectName in source_layer.report_392_all should reference valid project definitions
   - client code should reference valid client master data
   - OpportunityID should reference valid opportunity records

### 2.6 Dependency Constraints

1. **Timesheet Approval Dependencies**
   - Approved_hours fields can only be populated after corresponding submitted hours exist
   - Approved_hours(ST) depends on ST or Consultant_hours(ST) being submitted
   - Approved_hours(OT) depends on OT or Consultant_hours(OT) being submitted
   - Approved_hours(DT) depends on DT or Consultant_hours(DT) being submitted

2. **Employment Status Dependencies**
   - termdate can only be populated if Emp_Status is 'Terminated'
   - Offboarding_Status depends on Offboarding_Initiated date being set
   - End date must be set when employee status changes to inactive

3. **Project Assignment Dependencies**
   - end date can only be set if start date exists
   - Billing_Type derivation depends on client code, project name, and Net_Bill_Rate
   - Category derivation depends on Billing_Type, client name, and ITSSProjectName
   - Status derivation depends on Category value

4. **FTE Calculation Dependencies**
   - Total FTE calculation depends on Submitted Hours and Total Hours
   - Billed FTE calculation depends on Approved Hours (or Submitted Hours if Approved is null)
   - Available Hours calculation depends on Monthly Hours and Total FTE
   - Project Utilization depends on Billed Hours and Available Hours

### 2.7 Cardinality Constraints

1. **One-to-Many Relationships**
   - One Employee (GCI_ID) can have many Timesheet entries (one-to-many)
   - One Employee can have many Project Assignments (one-to-many)
   - One Project can have many Employee Assignments (one-to-many)
   - One Date can have many Timesheet entries (one-to-many)

2. **Many-to-Many Relationships**
   - Employees and Projects have many-to-many relationship (via Project Assignment)
   - Employees can work on multiple projects simultaneously
   - Projects can have multiple employees assigned

3. **Cardinality Rules**
   - Each timesheet entry must belong to exactly one employee
   - Each timesheet entry must be associated with exactly one date
   - Each timesheet entry must reference exactly one task/workflow
   - Each project assignment must belong to exactly one employee and one project

---

## 3. BUSINESS RULES

Business Rules define the operational logic, transformation guidelines, calculation methods, and decision criteria that govern how data is processed, categorized, and reported.

### 3.1 Total Hours Calculation Rules

1. **Working Hours by Location**
   - Rule: Offshore (India) resources are allocated 9 hours per working day
   - Rule: Onshore resources (US, Canada, LATAM, Mexico) are allocated 8 hours per working day
   - Formula: Total Hours = Number of Working Days × Hours per Day (location-specific)
   - Example: For US resources in August with 19 working days: Total Hours = 19 × 8 = 152

2. **Working Day Calculation Rules**
   - Rule: Exclude all Saturdays and Sundays (weekends) from working day count
   - Rule: Exclude location-specific holidays from working day count
   - Rule: Use source_layer.DimDate for weekend identification (DayName = 'Saturday' or 'Sunday')
   - Rule: Use location-specific holiday tables:
     - source_layer.holidays for US holidays
     - source_layer.holidays_India for India holidays
     - source_layer.holidays_Canada for Canada holidays
     - source_layer.holidays_Mexico for Mexico holidays

3. **Multiple Project Allocation Rules**
   - Rule: When an employee is allocated to multiple projects, Total Hours are distributed based on the ratio of Submitted Hours for each project
   - Rule: Any difference between the total of distributed hours and (Working Days × Hours) must be adjusted proportionally across projects
   - Rule: Sum of Total Hours across all projects for a resource should equal (Working Days × Location Hours)
   - Example: If Mukesh Agrawal works on 4 projects with submitted hours 40, 43, 44, 44 and location available hours = 176, then:
     - Total FTE = 171/176 = 0.97159
     - Project 1 FTE = 40/171 × 0.97159 = 0.23392
     - Available Hours for Project 1 = 0.23392 × 176 = 41.16959

### 3.2 Submitted Hours and Approved Hours Rules

1. **Submitted Hours Calculation**
   - Rule: Submitted Hours = Sum of all timesheet hours submitted by the resource
   - Rule: Include the following hour categories in submitted hours:
     - Consultant_hours(ST) or Approved_hours(ST)
     - Consultant_hours(OT) or Approved_hours(OT)
     - Consultant_hours(DT) or Approved_hours(DT)
     - Approved_hours(Sick_Time)
   - Rule: Submitted hours are captured from source_layer.Timesheet_New, vw_consultant_timesheet_daywise, and vw_billing_timesheet_daywise_ne

2. **Approved Hours Calculation**
   - Rule: Approved Hours = Sum of timesheet hours approved by Manager (Project Manager, Client, or Approver)
   - Rule: Approved hour column names:
     - Approved_hours(Non_ST)
     - Approved_hours(Non_OT)
     - Approved_hours(Non_DT)
     - Approved_hours(Non_Sick_Time)
   - Rule: If Approved Hours are unavailable, use Submitted Hours for calculations

### 3.3 FTE Calculation Rules

1. **Total FTE Calculation**
   - Formula: Total FTE = Submitted Hours / Total Hours
   - Rule: Total FTE represents the proportion of time a resource has submitted timesheets relative to available working hours
   - Rule: For single project allocation, Total FTE should be between 0 and 1
   - Rule: For multiple project allocations, sum of Total FTE across all projects should equal 1.0

2. **Billed FTE Calculation**
   - Formula: Billed FTE = Approved Hours / Total Hours
   - Rule: If Approved Hours are unavailable, use Submitted Hours: Billed FTE = Submitted Hours / Total Hours
   - Rule: Billed FTE represents the proportion of time that has been approved for billing
   - Rule: Billed FTE should be <= Total FTE

3. **Available Hours Calculation**
   - Formula: Available Hours = Monthly Hours × Total FTE
   - Rule: Available Hours represent the total hours available for a resource on a specific project
   - Rule: Monthly Hours = Working Days in Month × Location Hours per Day

4. **Project Utilization Calculation**
   - Formula: Project Utilization = Billed Hours / Available Hours
   - Rule: Project Utilization indicates the percentage of available hours that are billed
   - Rule: Project Utilization should be between 0 and 1 (0% to 100%)

### 3.4 FTE vs Consultant Classification Rules

1. **Classification Source**
   - Rule: Source for FTE/Consultant categorization is Workflow (source_layer.SchTask)
   - Rule: Classification is based on Process_name and HR_Subtier_Company fields

2. **FTE Classification Logic**
   - Rule: IF Process_name LIKE '%office%' AND HR_Subtier_Company = 'Ascendion Engineering Private Limited' THEN 'FTE'
   - Rule: IF Process_name LIKE '%office%' AND HR_Subtier_Company = 'Ascendion Engineering Solutions Mexico' THEN 'FTE'
   - Rule: IF Process_name LIKE '%office%' AND HR_Subtier_Company IS NULL OR '' THEN 'FTE'

3. **Consultant Classification Logic**
   - Rule: IF Process_name LIKE '%Contractor%' AND HR_Subtier_Company NOT IN ('Collabera Technologies Pvt. Ltd.', 'Collaborate Solutions, Inc', 'Ascendion Engineering Private Limited', 'Ascendion Engineering Solutions Mexico', 'Ascendion Canada Inc.', 'Ascendion Engineering Solutions Europe Limited', 'Ascendion Digital Solution Pvt. Ltd') THEN 'Consultant'
   - Rule: ELSE 'Consultant' (default classification)

4. **Circle_new Derivation**
   - Rule: Circle_new column is sourced from connection file 392 (source_layer.report_392_all)

### 3.5 Billing Type Derivation Rules

1. **Non-Billable (NBL) Classification**
   - Rule: IF client code IN ('IT010', 'IT008', 'CE035', 'CO120') THEN Billing_Type = 'NBL'
   - Rule: IF ITSSProjectName LIKE '% - pipeline%' THEN Billing_Type = 'NBL'
   - Rule: IF Net_Bill_Rate <= 0.1 THEN Billing_Type = 'NBL'
   - Rule: IF HWF_Process_name = 'JUMP Hourly Trainee Onboarding' THEN Billing_Type = 'NBL'

2. **Billable Classification**
   - Rule: ELSE Billing_Type = 'Billable' (default when none of the NBL conditions are met)

### 3.6 India Billing Matrix Rules

1. **India Billing - Client-NBL**
   - Rule: IF ITSSProjectName LIKE 'India Billing%Pipeline%' AND Billing_Type = 'NBL' THEN:
     - Category = 'India Billing - Client-NBL'
     - Status = 'Unbilled'
   - Exclusion: Exclude specific project names (AVA projects, ELT programs, Bench projects, SGA projects)

2. **India Billing - Billable**
   - Rule: IF client name LIKE '%India-Billing%' AND Billing_Type = 'Billable' THEN:
     - Category = 'India Billing - Billable'
     - Status = 'Billed'

3. **India Billing - Project NBL**
   - Rule: IF client name LIKE '%India-Billing%' AND Billing_Type = 'NBL' THEN:
     - Category = 'India Billing - Project NBL'
     - Status = 'Unbilled'

### 3.7 Client Project Matrix Rules (Excluding India Billing)

1. **Client-NBL Classification**
   - Rule: IF client name NOT LIKE '%India-Billing%' AND ITSSProjectName LIKE '%Pipeline%' AND Billing_Type = 'NBL' THEN:
     - Category = 'Client-NBL'
     - Status = 'Unbilled'

2. **Project-NBL Classification**
   - Rule: IF client name NOT LIKE '%India-Billing%' AND ITSSProjectName NOT LIKE '%Pipeline%' AND Billing_Type = 'NBL' THEN:
     - Category = 'Project-NBL'
     - Status = 'Unbilled'

3. **Billable Classification**
   - Rule: IF client name NOT LIKE '%India-Billing%' AND ITSSProjectName NOT LIKE '%Pipeline%' AND Billing_Type = 'Billable' THEN:
     - Category = 'Billable'
     - Status = 'Billed'

4. **Default Billable Rule**
   - Rule: IF Billing_Type IS NULL AND Actual Hours > 0 THEN:
     - Category = 'Billable'
     - Status = 'Billed'

5. **Default Project-NBL Rule**
   - Rule: ELSE (when no other conditions match):
     - Category = 'Project-NBL'
     - Status = 'Unbilled'

### 3.8 SGA (Selling, General & Administrative) Rules

1. **SGA Classification**
   - Rule: Resources identified as part of approved SGA must have Category = 'SGA' and Status = 'SGA'
   - Rule: SGA resources are identified through ELT marker and GCI IDs provided in a separate mapping sheet
   - Rule: SGA resources must be included in the base data model for filtering in Power BI dashboard

2. **Portfolio Lead Assignment**
   - Rule: Portfolio lead column must be included in base data for dashboard filtering
   - Rule: Portfolio lead is sourced from source_layer.report_392_all (PortfolioLeader field)

### 3.9 Bench and AVA Matrix Rules

1. **AVA Project Classification**
   - Rule: IF ITSSProjectName IN ('AVA_Architecture, Development & Testing Project', 'CapEx - GenAI Project', 'CapEx - Web3.0+Gaming 2 (Gaming/Metaverse)', 'Capex - Data Assets', 'AVA_Support, Management & Planning Project', 'Dummy Project - TIQE Bench Project') THEN:
     - Category = 'AVA'
     - Status = 'AVA'

2. **ELT Project Classification**
   - Rule: IF ITSSProjectName IN ('ASC-ELT Program-2024', 'CES - ELT\'s Program') THEN:
     - Category = 'ELT Project'
     - Status = 'Bench'

3. **Bench Project Classification**
   - Rule: IF ITSSProjectName IN ('Dummy Project - Managed Services Hiring', 'GenAI Capability Project - ITSS Collabera', 'Gaming/Metaverse CapEx Project Bench') THEN:
     - Category = 'Bench'
     - Status = 'Bench'

### 3.10 Hours Type Classification Rules

1. **Actual Hours Calculation**
   - Rule: Actual Hours = Sum of all hour categories (ST + OT + DT + Sick_Time + TIME_OFF + HO)
   - Rule: Actual Hours represent total hours worked by the resource

2. **Onsite Hours Calculation**
   - Rule: IF Type = 'OnSite' THEN Onsite Hours = Actual Hours ELSE Onsite Hours = 0
   - Rule: Type field is sourced from source_layer.SchTask

3. **Offsite Hours Calculation**
   - Rule: IF Type = 'Offshore' THEN Offsite Hours = Actual Hours ELSE Offsite Hours = 0
   - Rule: Offsite Hours represent hours worked from offshore locations

4. **Total Billed Hours**
   - Rule: Total Billed Hours = Actual Hours (for billed projects)
   - Rule: Total Available Hours = Monthly Expected Hours

### 3.11 YYMM Calculation Rule

1. **Year-Month Format**
   - Formula: YYMM = (DATEPART(yyyy, c_date) * 100 + DATEPART(MONTH, c_date))
   - Rule: YYMM is calculated from c_date in source_layer.Timesheet_New
   - Example: For date 2024-03-15, YYMM = 202403

### 3.12 Expected Hours and Available Hours Rules

1. **Expected Hours**
   - Rule: Expected_hours is hard-coded as 8 hours per day (default standard)
   - Rule: This is used as a baseline for comparison purposes

2. **Available Hours**
   - Formula: Available Hours = Monthly Hours × Total FTE
   - Rule: Monthly Hours = Working Days in Month × Location Hours per Day
   - Rule: Available Hours represent the total hours a resource is available for work on a project

### 3.13 Delivery Leader and Mapping Rules

1. **Delivery Leader Assignment**
   - Rule: Delivery Leader is sourced from a mapping sheet shared by JayaLaxmi
   - Rule: Delivery Leader must be assigned to each project for reporting purposes

2. **Offshore Location Determination**
   - Rule: IS_Offshore field indicates whether the resource is working offshore or onsite
   - Rule: Offshore typically refers to India location
   - Rule: Onsite refers to US, Canada, LATAM, Mexico locations

### 3.14 Business Area and Geographic Rules

1. **Business Area Classification**
   - Rule: Business area must be one of: 'NA' (North America), 'LATAM' (Latin America), 'India', 'Others'
   - Rule: Business area is sourced from source_layer.New_Monthly_HC_Report

2. **SOW (Statement of Work) Classification**
   - Rule: IS_SOW field indicates whether the client engagement is SOW-based
   - Rule: SOW classification affects billing and reporting categorization

3. **Vertical Name Assignment**
   - Rule: VerticalName represents the industry vertical (e.g., Healthcare, Financial Services, Retail)
   - Rule: Vertical is used for industry-based reporting and analysis

4. **Geo Group and Region**
   - Rule: Geo Group is not in use after 2024
   - Rule: Rec Region (Recruitment Region) indicates the region where the requirement originated

### 3.15 Task and Workflow Rules

1. **Task Reference Mapping**
   - Rule: task_id in source_layer.Timesheet_New references ID in source_layer.SchTask
   - Rule: Each timesheet entry must be associated with a valid workflow task

2. **Workflow Identification**
   - Rule: GCI_ID in source_layer.SchTask identifies the employee
   - Rule: ID in source_layer.SchTask is the WorkflowID/Task ID
   - Rule: Process_ID identifies the workflow process type

3. **Tower Assignment**
   - Rule: Tower is derived from DTCUChoice1 field in source_layer.SchTask
   - Rule: Tower represents the service delivery tower or practice area

### 3.16 Data Quality and Validation Rules

1. **Timesheet Validation Rules**
   - Rule: Timesheet entries must not exceed 24 hours per day
   - Rule: Weekly timesheet hours should not exceed 168 hours (7 days × 24 hours)
   - Rule: Timesheet dates must fall within the employee's active employment period
   - Rule: Timesheet dates must not be in the future

2. **FTE Validation Rules**
   - Rule: Total FTE for a single project should be between 0 and 1
   - Rule: Sum of FTE across all projects for a resource should equal 1.0 (with tolerance of ±0.01 for rounding)
   - Rule: Billed FTE should not exceed Total FTE

3. **Date Validation Rules**
   - Rule: Start date must be less than or equal to end date
   - Rule: Termination date must be greater than or equal to start date
   - Rule: Project end date must be greater than or equal to project start date

4. **Status Consistency Rules**
   - Rule: If Category = 'Billable' then Status must be 'Billed'
   - Rule: If Category contains 'NBL' then Status must be 'Unbilled'
   - Rule: If Category = 'SGA' then Status must be 'SGA'
   - Rule: If Category = 'AVA' then Status must be 'AVA'
   - Rule: If Category = 'Bench' or 'ELT Project' then Status must be 'Bench'

### 3.17 Reporting and Analytics Rules

1. **Dashboard Filtering Rules**
   - Rule: Portfolio Lead must be available for dashboard filtering
   - Rule: Vertical Name must be available for industry-based filtering
   - Rule: Business Area must be available for geographic filtering
   - Rule: Category and Status must be available for billing classification filtering

2. **KPI Calculation Rules**
   - Rule: All KPIs must be calculated consistently across all reports
   - Rule: Total Hours, Submitted Hours, Approved Hours, Total FTE, Billed FTE must use standardized formulas
   - Rule: Project Utilization must be calculated as Billed Hours / Available Hours

3. **Historical Data Preservation**
   - Rule: Historical timesheet data must be preserved for trend analysis
   - Rule: Changes to employee assignments must be tracked with effective dates
   - Rule: System runtime timestamp must be captured for audit purposes

---

## 4. IMPLEMENTATION NOTES

### 4.1 Data Model Alignment

1. All data expectations, constraints, and business rules are derived from the reporting requirements specified in UTL_Logic.md
2. Entity and attribute names reference the actual source data model DDL script (Source_Layer_DDL.sql)
3. No new elements have been introduced that are not present in the given requirements
4. All rules strictly align with the business requirements for UTL reporting and workforce utilization analytics

### 4.2 Compliance and Governance

1. These rules ensure data integrity and compliance with reporting standards
2. Data quality checks should be implemented based on these constraints
3. Business rules should be enforced through ETL processes and data validation procedures
4. Regular audits should be conducted to ensure adherence to these rules

### 4.3 Change Management

1. Any changes to business rules must be documented and approved
2. Impact analysis must be performed before modifying constraints
3. Data expectations should be reviewed quarterly to ensure relevance
4. New reporting requirements must be evaluated against existing rules

---

## 5. API COST CALCULATION

**Cost for this particular API Call to LLM model: $0.04**

---

**END OF DOCUMENT**