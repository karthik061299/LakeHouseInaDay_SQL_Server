------------------------------------------------------------------------
Author:        AAVA       
Date:          
Description:   Data Expectations, Constraints, and Business Rules for UTL and Resource Utilization Reporting System
------------------------------------------------------------------------

# DATA EXPECTATIONS, CONSTRAINTS, AND BUSINESS RULES

## 1. DATA EXPECTATIONS

Data expectations define the quality, completeness, accuracy, format, and consistency requirements for data within the conceptual model.

### 1.1 Data Completeness Expectations

1. **Timesheet Entry Completeness**
   - All resources must submit timesheet entries for each working day within the reporting period
   - Timesheet entries must include at least one hour type (ST, OT, DT, Sick_Time, or TIME_OFF)
   - Resource Code (gci_id) must be present for every timesheet entry
   - Timesheet Date (pe_date) must be populated for all entries

2. **Resource Master Data Completeness**
   - Every resource must have First Name, Last Name, and GCI ID populated
   - Start Date must be present for all active and terminated resources
   - Business Type (hr_business_type) must be defined for all resources
   - Client Code must be assigned for all billable resources

3. **Project Information Completeness**
   - All projects must have ITSSProjectName populated
   - Client Name and Client Code must be present for all client projects
   - Billing Type must be defined (Billable or NBL)
   - Project Start Date must be recorded for all active projects

4. **Date Dimension Completeness**
   - DimDate table must contain continuous date records without gaps
   - All dates must have DayName, MonthName, Quarter, and Year populated
   - Working day indicators must be defined for all dates

5. **Holiday Data Completeness**
   - Holiday dates must be defined for all applicable locations (US, India, Mexico, Canada)
   - Each holiday must have Description and Location populated
   - Source_type must be specified for audit purposes

### 1.2 Data Accuracy Expectations

1. **Hour Calculation Accuracy**
   - Total Hours calculation must accurately reflect working days × location-specific hours (8 or 9)
   - Submitted Hours must equal the sum of all hour types (ST + OT + DT + Sick_Time + TIME_OFF)
   - Approved Hours must not exceed Submitted Hours for the same resource and date

2. **FTE Calculation Accuracy**
   - Total FTE = Submitted Hours / Total Hours (must be between 0 and maximum allocation)
   - Billed FTE = Approved Hours / Total Hours (or Submitted Hours if Approved unavailable)
   - Sum of FTE across multiple projects for same resource should not exceed reasonable allocation limits

3. **Date Accuracy**
   - Timesheet dates must fall within the resource's employment period (between Start Date and Termination Date)
   - Project End Date must be greater than or equal to Project Start Date
   - Holiday dates must align with official calendar dates for respective locations

4. **Rate and Financial Accuracy**
   - Bill rates (bill st, bill st units) must be positive values for billable projects
   - Net Bill Rate must be calculated correctly based on billing type
   - GP (Gross Profit) and GPM (Gross Profit Margin) calculations must be accurate

### 1.3 Data Format Expectations

1. **Date Format Standards**
   - All date fields must follow datetime format (YYYY-MM-DD HH:MM:SS)
   - YYMM field must follow format: YYYYMM (e.g., 202401 for January 2024)
   - PE_DATE and c_date must be in consistent datetime format

2. **Numeric Format Standards**
   - Hour fields (ST, OT, DT, etc.) must be numeric with decimal precision (float)
   - GCI_ID must be integer or varchar format consistently across all tables
   - Rates and financial amounts must use money or decimal data types

3. **Text Format Standards**
   - Resource names (first name, last name) must be varchar(50)
   - Client Code must follow standardized format (e.g., IT010, CE035)
   - Status values must use predefined values (Active, Terminated, etc.)

4. **Code Format Standards**
   - Billing Type must be either 'Billable' or 'NBL'
   - Location codes must be standardized (US, India, Mexico, Canada)
   - Category values must follow predefined classification

### 1.4 Data Consistency Expectations

1. **Cross-Table Consistency**
   - GCI_ID in Timesheet_New must exist in New_Monthly_HC_Report
   - Task_ID in Timesheet_New must reference valid project in report_392_all
   - Resource employment dates must be consistent across all tables

2. **Temporal Consistency**
   - Timesheet dates must align with calendar dates in DimDate
   - Holiday dates must not overlap with working days
   - Resource termination dates must be after start dates

3. **Business Logic Consistency**
   - Resources marked as 'Offshore' must have 9-hour daily expectation
   - Resources in US, Canada, LATAM must have 8-hour daily expectation
   - Billing Type classification must be consistent with project and client attributes

4. **Status Consistency**
   - Terminated resources should not have active timesheet entries after termination date
   - Project status must align with billing status (Billed/Unbilled/SGA)
   - Employee status must reflect current employment state

---

## 2. CONSTRAINTS

Constraints define mandatory fields, uniqueness requirements, data type limitations, dependencies, and referential integrity rules.

### 2.1 Mandatory Field Constraints

1. **Timesheet_New Table**
   - gci_id (NOT NULL) - Required to identify resource
   - pe_date (NOT NULL) - Required to identify timesheet date
   - task_id (NOT NULL) - Required to link to project
   - At least one hour type field must have a value > 0

2. **New_Monthly_HC_Report Table**
   - [gci id] (NOT NULL) - Unique identifier for resource
   - [first name] (NOT NULL) - Required for resource identification
   - [last name] (NOT NULL) - Required for resource identification
   - [start date] (NOT NULL) - Required for employment tracking
   - [hr_business_type] (NOT NULL) - Required for classification

3. **report_392_all Table**
   - [gci id] (NOT NULL) - Required to identify resource
   - [client code] (NOT NULL) - Required for client association
   - ITSSProjectName (NOT NULL) - Required for project identification
   - Billing_Type (NOT NULL) - Required for billing classification

4. **SchTask Table**
   - ID (NOT NULL, IDENTITY) - Primary key
   - Process_ID (NOT NULL) - Required for workflow tracking
   - Level_ID (NOT NULL, DEFAULT 0) - Required for approval hierarchy
   - Last_Level (NOT NULL, DEFAULT 0) - Required for workflow completion

5. **DimDate Table**
   - DateKey (NOT NULL, PRIMARY KEY) - Unique date identifier
   - Date (NOT NULL) - Actual calendar date
   - DayName, MonthName, Quarter, Year (NOT NULL) - Required for reporting

6. **Holiday Tables (holidays, holidays_India, holidays_Mexico, holidays_Canada)**
   - Holiday_Date (NOT NULL) - Required to identify holiday
   - Description (NOT NULL) - Required for holiday identification
   - Source_type (NOT NULL) - Required for audit trail

### 2.2 Uniqueness Constraints

1. **Primary Key Constraints**
   - SchTask.ID must be unique (PRIMARY KEY)
   - DimDate.DateKey must be unique (PRIMARY KEY)
   - Hiring_Initiator_Project_Info.ID must be unique (UNIQUE CONSTRAINT)

2. **Composite Uniqueness**
   - Combination of (gci_id, pe_date, task_id) should be unique in Timesheet_New
   - Combination of (GCI_ID, PE_DATE) should be unique per billing type in timesheet approval views
   - Combination of (Holiday_Date, Location) should be unique in holiday tables

3. **Business Key Uniqueness**
   - GCI_ID should be unique per resource across the system
   - ITSSProjectName should be unique per project
   - Client Code should be unique per client

### 2.3 Data Type Constraints

1. **Numeric Constraints**
   - Hour fields (ST, OT, DT, etc.) must be FLOAT and >= 0
   - GCI_ID must be INT or VARCHAR(50)
   - ID fields must be NUMERIC(18,0) or INT
   - Financial fields (bill st, salary, GP) must be MONEY or DECIMAL

2. **Date/Time Constraints**
   - All date fields must be DATETIME type
   - Dates must be valid calendar dates
   - Future dates should be validated based on business context

3. **String Length Constraints**
   - first name, last name: VARCHAR(50)
   - client code: VARCHAR(50)
   - ITSSProjectName: VARCHAR(200)
   - Comments: VARCHAR(8000)
   - Status: VARCHAR(50)

4. **Boolean/Bit Constraints**
   - isbulk, jump, client_consent: BIT (0 or 1)
   - IS_SOW: VARCHAR(7) - 'Yes' or 'No'
   - BILLABLE: VARCHAR(3) - 'Yes' or 'No'

### 2.4 Range and Domain Constraints

1. **Hour Value Constraints**
   - Standard Hours (ST): 0 to 24 per day
   - Overtime Hours (OT): 0 to 12 per day
   - Double Time Hours (DT): 0 to 12 per day
   - Total daily hours should not exceed 24

2. **FTE Constraints**
   - Total FTE per resource: 0 to 2.0 (allowing for overtime scenarios)
   - Billed FTE: 0 to Total FTE
   - Project Utilization: 0 to 1.0 (100%)

3. **Date Range Constraints**
   - Timesheet dates must be within valid employment period
   - Project dates must be within reasonable business timeframe
   - Holiday dates must be within current or future calendar years

4. **Location Domain Constraints**
   - Location must be one of: 'US', 'India', 'Mexico', 'Canada', 'LATAM'
   - Business Area must be one of: 'NA', 'LATAM', 'India', 'Others'
   - IS_Offshore must be one of: 'Onsite', 'Offshore'

5. **Status Domain Constraints**
   - Employee Status: 'Active', 'Terminated', 'On Leave'
   - Project Status: 'Billed', 'Unbilled', 'SGA'
   - Billing Type: 'Billable', 'NBL'
   - Category: 'India Billing - Client-NBL', 'India Billing - Billable', 'India Billing - Project NBL', 'Client-NBL', 'Project-NBL', 'Billable', 'AVA', 'ELT Project', 'Bench'

### 2.5 Referential Integrity Constraints

1. **Timesheet to Resource Relationship**
   - Timesheet_New.gci_id must reference New_Monthly_HC_Report.[gci id]
   - Foreign key relationship ensures valid resource exists

2. **Timesheet to Project Relationship**
   - Timesheet_New.task_id should reference valid project in report_392_all
   - Ensures timesheet entries are associated with valid projects

3. **Timesheet to Date Relationship**
   - Timesheet_New.pe_date must exist in DimDate.Date
   - Ensures timesheet dates are valid calendar dates

4. **Resource to Project Relationship**
   - New_Monthly_HC_Report.ITSSProjectName should reference report_392_all.ITSSProjectName
   - Ensures resource assignments are to valid projects

5. **Workflow to Resource Relationship**
   - SchTask.GCI_ID should reference New_Monthly_HC_Report.[gci id]
   - Ensures workflow tasks are associated with valid resources

6. **Date to Holiday Relationship**
   - Holiday dates in holidays tables should exist in DimDate
   - Ensures holidays are defined for valid calendar dates

### 2.6 Dependency Constraints

1. **Temporal Dependencies**
   - Termination Date must be >= Start Date
   - Project End Date must be >= Project Start Date
   - Timesheet Date must be >= Resource Start Date
   - Timesheet Date must be <= Current Date (no future timesheets)

2. **Calculation Dependencies**
   - Approved Hours calculation depends on Submitted Hours
   - Total FTE calculation depends on Submitted Hours and Total Hours
   - Billed FTE calculation depends on Approved Hours (or Submitted Hours) and Total Hours
   - Available Hours calculation depends on Monthly Hours and Total FTE

3. **Status Dependencies**
   - Terminated resources must have Termination Date populated
   - Billed status requires Approved Hours > 0
   - SGA status requires specific project classification

4. **Location Dependencies**
   - Offshore resources must have 9-hour daily expectation
   - Onshore resources (US, Canada, LATAM) must have 8-hour daily expectation
   - Holiday exclusions depend on resource location

---

## 3. BUSINESS RULES

Business rules define operational rules affecting data processing, reporting logic, and transformation guidelines.

### 3.1 Total Hours Calculation Rules

1. **Location-Based Hour Calculation**
   - **Rule**: Total Hours = Number of Working Days × Location Hours
   - **Offshore (India)**: 9 hours per day
   - **Onshore (US, Canada, LATAM)**: 8 hours per day
   - **Example**: For US location in August with 19 working days: Total Hours = 19 × 8 = 152

2. **Working Day Determination**
   - **Rule**: Working days exclude weekends (Saturday and Sunday) and location-specific holidays
   - **Source Tables**:
     - DimDate: Provides weekend and working day indicators
     - holidays: US location holidays
     - holidays_India: India location holidays
     - holidays_Mexico: Mexico location holidays
     - holidays_Canada: Canada location holidays

3. **Multiple Project Allocation**
   - **Rule**: When a resource is allocated to multiple projects, Total Hours are distributed based on the ratio of Submitted Hours for each project
   - **Adjustment**: Any difference between the total of distributed hours and (Working Days × Hours) is adjusted proportionally
   - **Example**: Resource with 4 projects and 171 total submitted hours across 176 available hours

### 3.2 Submitted Hours Rules

1. **Hour Type Aggregation**
   - **Rule**: Submitted Hours = Sum of all hour types submitted by resource
   - **Hour Types**: ST (Standard Time), OT (Overtime), DT (Double Time), Sick_Time, TIME_OFF, HO (Holiday)
   - **Source Tables**:
     - Timesheet_New: Primary timesheet entry table
     - vw_consultant_timesheet_daywise: Consultant submitted hours

2. **Consultant vs Approved Hours**
   - **Rule**: Use Consultant_hours columns for resources submitting their own timesheets
   - **Columns**: Consultant_hours(ST), Consultant_hours(OT), Consultant_hours(DT)
   - **Source**: vw_consultant_timesheet_daywise table

### 3.3 Approved Hours Rules

1. **Manager Approval Logic**
   - **Rule**: Approved Hours are timesheet hours approved by Manager, Project Manager, Client, or Approver
   - **Columns**: Approved_hours(ST), Approved_hours(OT), Approved_hours(DT), Approved_hours(Sick_Time)
   - **Source**: vw_billing_timesheet_daywise_ne table

2. **Non-Billable Hour Tracking**
   - **Rule**: Track both billable and non-billable approved hours separately
   - **Columns**: Approved_hours(Non_ST), Approved_hours(Non_OT), Approved_hours(Non_DT), Approved_hours(Non_Sick_Time)

3. **Fallback Logic**
   - **Rule**: If Approved Hours is unavailable, use Submitted Hours for calculations
   - **Application**: Used in Billed FTE calculation

### 3.4 FTE Calculation Rules

1. **Total FTE Formula**
   - **Rule**: Total FTE = Submitted Hours / Total Hours
   - **Range**: 0 to maximum allocation (typically ≤ 1.0, but can exceed with overtime)
   - **Purpose**: Measures resource time commitment

2. **Billed FTE Formula**
   - **Rule**: Billed FTE = Approved Hours / Total Hours
   - **Fallback**: If Approved Hours unavailable, use Submitted Hours
   - **Purpose**: Measures billable resource utilization

3. **Weighted Average FTE for Multiple Projects**
   - **Rule**: For resources allocated to multiple projects, calculate weighted FTE per project
   - **Implementation**: Implemented in Q3 2024 to rectify gap where multiple allocations counted as full 1 FTE each
   - **Example**: Resource with 4 projects shows individual FTE per project summing to 1.0 total

### 3.5 Resource Classification Rules

1. **FTE vs Consultant Classification**
   - **Source**: Workflow table (SchTask) and Process_name field
   - **FTE Rules**:
     - Process_name LIKE '%office%' AND HR_Subtier_Company = 'Ascendion Engineering Private Limited' → FTE
     - Process_name LIKE '%office%' AND HR_Subtier_Company = 'Ascendion Engineering Solutions Mexico' → FTE
     - Process_name LIKE '%office%' AND HR_Subtier_Company IS NULL or empty → FTE
   - **Consultant Rules**:
     - Process_name LIKE '%Contractor%' AND HR_Subtier_Company NOT IN (specific Ascendion entities) → Consultant
     - All other cases → Consultant

2. **Onsite vs Offshore Classification**
   - **Rule**: Determined by Type field in SchTask table or IS_Offshore field in report_392_all
   - **Values**: 'Onsite' or 'Offshore'
   - **Impact**: Affects Total Hours calculation (8 vs 9 hours per day)

### 3.6 Billing Type Classification Rules

1. **Non-Billable (NBL) Classification**
   - **Rule**: Project is NBL if any of the following conditions are met:
     - Client code IN ('IT010', 'IT008', 'CE035', 'CO120')
     - ITSSProjectName LIKE '% - pipeline%'
     - Net_Bill_Rate <= 0.1
     - HWF_Process_name = 'JUMP Hourly Trainee Onboarding'
   - **Default**: Otherwise classified as 'Billable'

2. **Billable Classification**
   - **Rule**: Project is Billable if:
     - Not meeting any NBL criteria
     - Has positive Net_Bill_Rate > 0.1
     - Not a pipeline or internal project

### 3.7 Category Classification Rules

1. **India Billing Matrix**
   - **India Billing - Client-NBL**:
     - ITSSProjectName LIKE 'India Billing%Pipeline%'
     - Billing_Type = 'NBL'
     - Status = Unbilled
   - **India Billing - Billable**:
     - Client name contains 'India-Billing'
     - Billing_Type = 'Billable'
     - Status = Billed
   - **India Billing - Project NBL**:
     - Client name contains 'India-Billing'
     - Billing_Type = 'NBL'
     - Status = Unbilled

2. **Client Project Matrix (Excluding India Billing)**
   - **Client-NBL**:
     - Client name does NOT contain 'India-Billing'
     - ITSSProjectName contains 'Pipeline'
     - Billing_Type = 'NBL'
     - Status = Unbilled
   - **Project-NBL**:
     - Client name does NOT contain 'India-Billing'
     - ITSSProjectName does NOT contain 'Pipeline'
     - Billing_Type = 'NBL'
     - Status = Unbilled
   - **Billable**:
     - Client name does NOT contain 'India-Billing'
     - ITSSProjectName does NOT contain 'Pipeline'
     - Billing_Type = 'Billable'
     - Status = Billed
   - **Billable (Alternate)**:
     - Billing_Type is blank AND Actual Hours has value
     - Status = Billed
   - **Default**: Project-NBL, Status = Unbilled

3. **SGA Classification**
   - **Rule**: Resources approved as SGA (Selling, General & Administrative) have category and status updated accordingly
   - **Source**: ELT marker along with GCI IDs provided in separate mapping sheet
   - **Status**: SGA

### 3.8 Bench and AVA Matrix Rules

1. **AVA (Ascendion Value Add) Projects**
   - **Projects Classified as AVA**:
     - 'AVA_Architecture, Development & Testing Project'
     - 'CapEx - GenAI Project'
     - 'CapEx - Web3.0+Gaming 2 (Gaming/Metaverse)'
     - 'Capex - Data Assets'
     - 'AVA_Support, Management & Planning Project'
     - 'Dummy Project - TIQE Bench Project'
   - **Category**: AVA
   - **Status**: AVA

2. **ELT (Executive Leadership Training) Projects**
   - **Projects Classified as ELT**:
     - 'ASC-ELT Program-2024'
     - 'CES - ELT's Program'
   - **Category**: ELT Project
   - **Status**: Bench

3. **Bench Projects**
   - **Projects Classified as Bench**:
     - 'Dummy Project - Managed Services Hiring'
     - 'GenAI Capability Project - ITSS Collabera'
     - 'Gaming/Metaverse CapEx Project Bench'
   - **Category**: Bench
   - **Status**: Bench

### 3.9 Available Hours Calculation Rules

1. **Available Hours Formula**
   - **Rule**: Available Hours = Monthly Hours × Total FTE
   - **Purpose**: Calculates actual available hours based on resource allocation
   - **Example**: If Monthly Hours = 176 and Total FTE = 0.5, then Available Hours = 88

2. **Expected Hours**
   - **Rule**: Hard coded as 8 hours per day (standard expectation)
   - **Note**: This is different from location-based hours used in Total Hours calculation

3. **Total Available Hours**
   - **Rule**: Total Available Hours = Monthly Expected Hours
   - **Purpose**: Represents total capacity for the month

### 3.10 Project Utilization Rules

1. **Project Utilization Formula**
   - **Rule**: Project Utilization = Billed Hours / Available Hours
   - **Range**: 0 to 1.0 (0% to 100%)
   - **Purpose**: Measures how effectively resource time is utilized on billable work

2. **Actual Hours Tracking**
   - **Total Billed Hours / Actual Hours**: Sum of all approved billable hours
   - **Onsite Hours**: Actual hours where Type = 'OnSite'
   - **Offsite Hours**: Actual hours where Type = 'Offshore'

### 3.11 Date and Time Period Rules

1. **YYMM Calculation**
   - **Rule**: YYMM = (Year × 100) + Month
   - **Formula**: DATEPART(yyyy, c_date) × 100 + DATEPART(MONTH, c_date)
   - **Example**: January 2024 = 202401

2. **Month-Year Formatting**
   - **MMYYYY**: 6-character format (e.g., '012024')
   - **MM-YYYY**: 10-character format with hyphen (e.g., '01-2024')
   - **YYYYMM**: 10-character format (e.g., '202401')

### 3.12 Organizational Hierarchy Rules

1. **Business Area Classification**
   - **Values**: NA (North America), LATAM (Latin America), India, Others
   - **Purpose**: Geographic segmentation for reporting

2. **SOW (Statement of Work) Indicator**
   - **Rule**: Indicates whether client operates under SOW model
   - **Values**: 'Yes' or 'No'
   - **Purpose**: Differentiates contract types

3. **Portfolio and Leadership Mapping**
   - **Portfolio Leader**: Assigned from mapping sheet provided by business
   - **Delivery Leader**: Assigned from mapping sheet provided by business
   - **Market Leader**: Assigned based on client and market segment
   - **Purpose**: Enables leadership-level reporting and accountability

4. **Circle Classification**
   - **Source**: Connection file 392 (report_392_all table)
   - **Purpose**: Business circle or grouping for organizational reporting

### 3.13 Vertical and Practice Rules

1. **Vertical Name**
   - **Definition**: Industry vertical (e.g., Healthcare, Financial Services, Retail)
   - **Purpose**: Industry-based segmentation

2. **Practice Type**
   - **Definition**: Practice or business unit classification
   - **Purpose**: Service line reporting

3. **Community Classification**
   - **Definition**: Technical or functional community grouping
   - **Purpose**: Skills-based resource grouping

### 3.14 Client and Account Rules

1. **Super Merged Name**
   - **Definition**: Parent client name for consolidated reporting
   - **Purpose**: Rolls up subsidiary clients to parent organization

2. **New Business Type**
   - **Values**: Contract, Direct Hire, Project NBL
   - **Purpose**: Classifies engagement type

3. **Requirement Region**
   - **Definition**: Geographic region where requirement originated
   - **Purpose**: Demand-side geographic reporting

### 3.15 Workflow and Approval Rules

1. **Workflow Task Tracking**
   - **Candidate Name**: Resource or consultant name in workflow
   - **GCI_ID**: Employee code for tracking
   - **ID**: Workflow ID / Task ID for unique identification
   - **Type**: Onsite/Offshore indicator
   - **Tower**: Business tower or division (derived from DTCUChoice1)

2. **Status Tracking**
   - **Status**: Current status of workflow task
   - **DateCreated**: Date workflow task was initiated
   - **DateCompleted**: Date workflow task was completed
   - **Comments**: Notes or comments for audit trail

### 3.16 ELT (Executive Leadership Training) Classification

1. **ELT vs Non-ELT**
   - **Rule**: Selected GCI IDs are marked as ELT based on mapping shared by business
   - **Purpose**: Identifies resources in leadership development programs
   - **Impact**: Affects bench and utilization reporting

### 3.17 Rate and Financial Rules

1. **Bill Rate Management**
   - **Net Bill Rate**: Calculated based on billing type and client agreement
   - **Markup**: Percentage markup over pay rate
   - **Actual Markup**: Realized markup after adjustments
   - **Maximum Allowed Markup**: Cap on markup percentage

2. **Gross Profit Calculation**
   - **GP (Gross Profit)**: Revenue minus direct costs
   - **GPM (Gross Profit Margin)**: GP as percentage of revenue
   - **Purpose**: Financial performance measurement

### 3.18 Data Source and Integration Rules

1. **Mapping Sheet Dependencies**
   - **Expected Hours**: From mapping sheet shared by business
   - **Delivery Leader**: From mapping sheet shared by business
   - **Portfolio Leader**: From mapping sheet shared by business
   - **Circle**: From connection file 392

2. **Multi-Source Data Integration**
   - **Timesheet Data**: Integrated from Timesheet_New, vw_billing_timesheet_daywise_ne, vw_consultant_timesheet_daywise
   - **Resource Data**: Primary source is New_Monthly_HC_Report
   - **Project Data**: Primary source is report_392_all
   - **Workflow Data**: Source is SchTask and Hiring_Initiator_Project_Info

### 3.19 Historical Data and Versioning Rules

1. **Effective Dating**
   - **Start Date**: Beginning of resource assignment or project
   - **End Date / Termination Date**: End of resource assignment or employment
   - **Purpose**: Enables point-in-time and historical reporting

2. **Change Tracking**
   - **DateCreated**: Timestamp of record creation
   - **DateUpdated**: Timestamp of last update
   - **UserCreated / UserUpdated**: Audit trail of who made changes

### 3.20 Exception Handling Rules

1. **Missing Approved Hours**
   - **Rule**: If Approved Hours is NULL or unavailable, use Submitted Hours
   - **Application**: Billed FTE calculation

2. **Blank Billing Type**
   - **Rule**: If Billing_Type is blank AND Actual Hours has value, classify as Billable
   - **Status**: Billed

3. **Multiple Allocation Adjustment**
   - **Rule**: Any difference between total distributed hours and expected hours is adjusted proportionally across projects
   - **Purpose**: Ensures FTE totals are accurate

---

## 4. DATA QUALITY RULES

### 4.1 Validation Rules

1. **Timesheet Validation**
   - Timesheet date must be within resource employment period
   - Total daily hours should not exceed 24
   - Approved hours should not exceed submitted hours
   - Timesheet must be submitted for all working days

2. **Resource Validation**
   - GCI_ID must be unique
   - Start date must be before or equal to current date
   - Termination date must be after start date
   - Active resources must not have termination date

3. **Project Validation**
   - Project end date must be after start date
   - Billing type must be defined
   - Client code must be valid
   - Category must align with billing type

### 4.2 Data Reconciliation Rules

1. **Hour Reconciliation**
   - Sum of submitted hours across all projects should equal total submitted hours
   - Sum of approved hours should not exceed submitted hours
   - Available hours should equal monthly hours × total FTE

2. **FTE Reconciliation**
   - Sum of FTE across all projects for a resource should be reasonable (typically ≤ 1.5)
   - Billed FTE should not exceed Total FTE
   - Project utilization should be between 0 and 1

3. **Financial Reconciliation**
   - Net bill rate should be positive for billable projects
   - GP should be calculated correctly from revenue and costs
   - Markup should be within allowed range

---

## 5. REPORTING AND ANALYTICS RULES

### 5.1 KPI Calculation Rules

1. **Total Hours**: Working Days × Location Hours (8 or 9)
2. **Submitted Hours**: Sum of all timesheet hour types
3. **Approved Hours**: Manager-approved timesheet hours
4. **Total FTE**: Submitted Hours / Total Hours
5. **Billed FTE**: Approved Hours / Total Hours (or Submitted if Approved unavailable)
6. **Project Utilization**: Billed Hours / Available Hours
7. **Available Hours**: Monthly Hours × Total FTE
8. **Actual Hours**: Actual hours worked by resource
9. **Onsite Hours**: Actual hours where Type = 'OnSite'
10. **Offsite Hours**: Actual hours where Type = 'Offshore'

### 5.2 Aggregation Rules

1. **Time-Based Aggregation**
   - Daily: Sum hours by date
   - Weekly: Sum hours by week (using WEEK_DATE)
   - Monthly: Sum hours by YYMM
   - Quarterly: Sum hours by Quarter
   - Yearly: Sum hours by Year

2. **Organizational Aggregation**
   - By Resource: Sum by GCI_ID
   - By Project: Sum by ITSSProjectName
   - By Client: Sum by Client Code/Name
   - By Portfolio: Sum by Portfolio Leader
   - By Business Area: Sum by Business Area (NA, LATAM, India, Others)

3. **Classification Aggregation**
   - By Billing Type: Sum by Billable/NBL
   - By Category: Sum by Category classification
   - By Status: Sum by Billed/Unbilled/SGA
   - By Resource Type: Sum by FTE/Consultant

### 5.3 Filtering Rules

1. **Active Resources Filter**
   - Include resources where Status = 'Active' OR Termination Date >= Report Period

2. **Billable Hours Filter**
   - Include hours where Billing_Type = 'Billable' AND Status = 'Billed'

3. **Location-Based Filter**
   - Filter by Business Area, Location, or IS_Offshore indicator

4. **Time Period Filter**
   - Filter by YYMM, Quarter, or Year
   - Exclude future dates

---

## 6. API COST CALCULATION

**Cost for this particular API Call to LLM model: $0.03**

---

## 7. SUMMARY

This document defines comprehensive Data Expectations, Constraints, and Business Rules for the UTL and Resource Utilization Reporting System. These specifications ensure:

1. **Data Quality**: Through completeness, accuracy, format, and consistency expectations
2. **Data Integrity**: Through mandatory fields, uniqueness, data types, and referential integrity constraints
3. **Business Alignment**: Through operational rules, calculation logic, and classification rules
4. **Compliance**: Through validation rules, reconciliation rules, and audit trail requirements
5. **Reporting Accuracy**: Through KPI calculations, aggregation rules, and filtering logic

All rules and constraints are derived from the source requirements (UTL_Logic.md) and aligned with the source data model (Source_Layer_DDL.sql) to ensure accurate, consistent, and meaningful data representation for analytics and decision-making.

---
**End of Document**