------------------------------------------------------------------------
Author:        AAVA       
Date:          
Description:   Data Expectations, Constraints, and Business Rules for UTL Reporting Requirements
------------------------------------------------------------------------

# DATA EXPECTATIONS, CONSTRAINTS, AND BUSINESS RULES

## 1. DATA EXPECTATIONS

Data Expectations define the quality standards, completeness requirements, accuracy measures, format specifications, and consistency rules that the data must meet to ensure reliable reporting and analytics.

### 1.1 Data Completeness Expectations

1. **Timesheet Data Completeness**
   - All resources must submit timesheet entries for each working day
   - Timesheet_New table must contain entries for all active resources during the reporting period
   - Fields gci_id, pe_date, task_id, and c_date are mandatory for all timesheet records
   - At least one hour type (ST, OT, DT, TIME_OFF, HO, Sick_Time) must have a non-zero value

2. **Resource Master Data Completeness**
   - report_392_all table must contain complete resource information including:
     - gci id (Resource identifier)
     - first name and last name
     - employee type (FTE/Consultant classification)
     - start date (mandatory for all active resources)
     - client code and client name
     - job title
     - Billing_Type (Billable/NBL)

3. **Workflow Data Completeness**
   - SchTask table must contain workflow records for all onboarding, offboarding, and project assignment activities
   - Mandatory fields: GCI_ID, Process_ID, Status, DateCreated
   - HWF_Process_name must be populated to determine FTE/Consultant categorization

4. **Calendar and Holiday Data Completeness**
   - DimDate table must contain all calendar dates for the reporting period
   - Holiday tables (holidays, holidays_India, holidays_Canada, holidays_Mexico) must be updated annually
   - Each holiday record must have Holiday_Date, Description, Location, and Source_type

5. **Monthly Headcount Data Completeness**
   - New_Monthly_HC_Report must contain monthly snapshots for all active resources
   - YYMM field must be populated for all records to enable time-series analysis
   - Expected_Hrs and Expected_Total_Hrs must be calculated for all resources

### 1.2 Data Accuracy Expectations

1. **Hour Calculation Accuracy**
   - Total Hours calculation must accurately reflect: (Number of working days × Location-specific hours)
   - Offshore (India) resources: 9 hours per day
   - Onshore (US, Canada, LATAM, Mexico) resources: 8 hours per day
   - Working days must exclude weekends (Saturday and Sunday) and location-specific holidays

2. **FTE Calculation Accuracy**
   - Total FTE = Submitted Hours / Total Hours (must be between 0 and 1 for single project allocation)
   - Billed FTE = Approved TS hours / Total Hours
   - For multiple project allocations, sum of Total FTE across all projects should equal 1.0
   - Project Utilization (Proj UTL) = Billed Hours / Available Hours

3. **Financial Metrics Accuracy**
   - Net_Bill_Rate must be greater than 0 for billable resources
   - Gross Profit (GP) and Gross Profit Margin (GPM) calculations must be accurate
   - Markup calculations: actual_markup, maximum_allowed_markup must be validated
   - Salary and pay rate fields must contain valid monetary values

4. **Date Field Accuracy**
   - start date must be less than or equal to end date
   - pe_date (period end date) must align with standard payroll cycles
   - termdate, Final_End_date, newtermdate must be consistent across related tables
   - po start date and po end date must define valid project duration

5. **Status and Category Accuracy**
   - Status field must accurately reflect: Billed, Unbilled, or SGA
   - Category must be correctly assigned based on India Billing Matrix and Client Project Matrix logic
   - Billing_Type must be correctly determined as Billable or NBL based on business rules

### 1.3 Data Format Expectations

1. **Identifier Formats**
   - gci_id / GCI_ID: Must be numeric integer format
   - client code: Alphanumeric format (e.g., IT010, CE035)
   - SSN: Must follow standard format with appropriate masking for security
   - Worker_Entity_ID: Alphanumeric format up to 30 characters

2. **Date and Time Formats**
   - All date fields must be in datetime format
   - YYMM: Integer format (YYYYMM) for year-month representation
   - pe_date, c_date, start date, end date: datetime format
   - DateCreated, DateCompleted: datetime format with timestamp

3. **Numeric Formats**
   - Hour fields (ST, OT, DT, Sick_Time, etc.): Float format with 2 decimal precision
   - Financial fields (salary, gp, gpm, Net_Bill_Rate): Money or decimal format
   - Percentage fields (markup, actual_markup): Numeric format
   - Headcount fields (Begin HC, End HC, Terms, etc.): Numeric with high precision (38,36)

4. **Text Formats**
   - Name fields (first name, last name): VARCHAR(50)
   - Description fields: VARCHAR with appropriate length
   - Email fields: VARCHAR format with email validation
   - Status and category fields: Controlled vocabulary (predefined values)

5. **Boolean Formats**
   - Flag fields (isbulk, jump, client_consent, IsBillRateSkip): BIT format (0/1)
   - Yes/No fields: Consistent representation across tables

### 1.4 Data Consistency Expectations

1. **Cross-Table Consistency**
   - gci_id in Timesheet_New must exist in report_392_all and SchTask
   - client code in report_392_all must be consistent with New_Monthly_HC_Report
   - ITSSProjectName must be consistent across report_392_all and New_Monthly_HC_Report
   - Task_Id in report_392_all must reference valid ID in SchTask

2. **Temporal Consistency**
   - Resource status changes must be reflected consistently across all tables
   - Start and end dates must be synchronized between report_392_all and New_Monthly_HC_Report
   - Timesheet entries must fall within the resource's active employment period
   - Monthly snapshots in New_Monthly_HC_Report must align with calendar months in DimDate

3. **Business Logic Consistency**
   - FTE/Consultant classification must be consistent across all tables
   - Billing_Type determination must follow the same logic throughout the model
   - Category assignment must be consistent with Status field values
   - Location-based hour calculations must be consistent (India=9hrs, Others=8hrs)

4. **Referential Consistency**
   - All foreign key relationships must maintain referential integrity
   - Holiday dates must exist in DimDate table
   - Project locations must have corresponding holiday tables
   - Workflow Process_ID must reference valid workflow definitions

5. **Aggregation Consistency**
   - Sum of project-level FTE must equal resource-level Total FTE
   - Monthly headcount movements (Starts, Terms, OffBoard) must reconcile with Begin HC and End HC
   - Total submitted hours must equal sum of all hour types (ST + OT + DT + TIME_OFF + HO + Sick_Time)
   - Approved hours must be less than or equal to submitted hours

### 1.5 Data Timeliness Expectations

1. **Timesheet Submission Timeliness**
   - Timesheet entries must be submitted within the defined payroll cycle
   - Approved hours must be recorded within specified approval timeframes
   - Late submissions must be flagged for reporting purposes

2. **Master Data Update Timeliness**
   - Resource onboarding data must be available before first timesheet submission
   - Termination and offboarding data must be updated within 24 hours of event
   - Project assignment changes must be reflected in real-time or near real-time

3. **Reference Data Update Timeliness**
   - Holiday calendars must be updated annually before the start of the calendar year
   - Client and project master data must be current and updated as changes occur
   - Organizational hierarchy changes must be reflected within the reporting period

---

## 2. DATA CONSTRAINTS

Data Constraints define the technical and business limitations, mandatory requirements, uniqueness rules, data type specifications, and referential integrity requirements that must be enforced at the database level.

### 2.1 Mandatory Field Constraints (NOT NULL)

#### 2.1.1 Timesheet_New Table
1. **gci_id** (INT NOT NULL) - Resource identifier is mandatory for all timesheet entries
2. **pe_date** (DATETIME NOT NULL) - Period end date is required for payroll processing
3. **task_id** (NUMERIC(18,9) NOT NULL) - Task identifier links timesheet to project assignment

#### 2.1.2 SchTask Table
1. **ID** (NUMERIC(18,0) NOT NULL) - Primary key for workflow task identification
2. **Process_ID** (NUMERIC(18,0) NOT NULL) - Workflow process identifier is mandatory
3. **Level_ID** (INT NOT NULL, DEFAULT 0) - Workflow level tracking
4. **Last_Level** (INT NOT NULL, DEFAULT 0) - Last completed workflow level
5. **TS** (TIMESTAMP NOT NULL) - Timestamp for audit trail

#### 2.1.3 report_392_all Table
1. **markup** (VARCHAR(3) NOT NULL) - Markup indicator is required
2. **Inhouse** (VARCHAR(3) NOT NULL) - In-house resource flag is mandatory
3. **ITSS** (VARCHAR(100) NOT NULL) - ITSS project classification required
4. **isbulk** (BIT NOT NULL) - Bulk hiring indicator
5. **jump** (BIT NOT NULL) - JUMP program indicator
6. **VASSOW** (VARCHAR(3) NOT NULL) - VAS SOW indicator
7. **Client_Group1** (VARCHAR(19) NOT NULL) - Client grouping required
8. **Billig_Type** (VARCHAR(8) NOT NULL) - Billing type classification mandatory
9. **Client_Group** (VARCHAR(19) NOT NULL) - Client group classification
10. **C2C_W2_FTE** (VARCHAR(13) NOT NULL) - Employment type classification
11. **FP_TM** (VARCHAR(2) NOT NULL) - Fixed price/Time & Material indicator

#### 2.1.4 New_Monthly_HC_Report Table
1. **IS_SOW** (VARCHAR(7) NOT NULL) - Statement of Work indicator
2. **CL_Group** (VARCHAR(32) NOT NULL) - Client group classification
3. **ITSS** (VARCHAR(100) NOT NULL) - ITSS project name required
4. **system_runtime** (DATETIME NOT NULL) - System processing timestamp
5. **FP_TM** (VARCHAR(2) NOT NULL) - Project type indicator
6. **ProjType** (VARCHAR(2) NOT NULL) - Project type classification

#### 2.1.5 Holiday Tables (holidays, holidays_India, holidays_Canada, holidays_Mexico)
1. **Holiday_Date** (DATETIME NOT NULL) - Holiday date is mandatory
2. **Description** (VARCHAR NOT NULL) - Holiday description required
3. **Source_type** (VARCHAR(50) NOT NULL) - Source type classification

### 2.2 Uniqueness Constraints

#### 2.2.1 Primary Key Constraints
1. **SchTask.ID** - Primary key ensures unique workflow task identification
   - Constraint: PK_SchTask PRIMARY KEY (ID)
   - Auto-increment: IDENTITY(1,1)

2. **DimDate.DateKey** - Primary key ensures unique date records
   - Constraint: PRIMARY KEY CLUSTERED (DateKey ASC)

3. **Hiring_Initiator_Project_Info.ID** - Unique constraint on hiring workflow ID
   - Constraint: IX_Hiring_Initiator_Project_Info UNIQUE (ID)

#### 2.2.2 Composite Uniqueness Requirements
1. **Timesheet_New**: Combination of (gci_id, pe_date, task_id, c_date) should be unique
   - Prevents duplicate timesheet entries for same resource, period, task, and date

2. **Holiday Tables**: Combination of (Holiday_Date, Location) should be unique
   - Prevents duplicate holiday entries for same date and location

3. **New_Monthly_HC_Report**: Combination of (gci id, YYMM, client code) should be unique
   - Ensures one record per resource per month per client

### 2.3 Data Type and Length Constraints

#### 2.3.1 Numeric Field Constraints
1. **Identifier Fields**
   - gci_id: INT (4 bytes, range: -2,147,483,648 to 2,147,483,647)
   - ID fields: NUMERIC(18,0) - 18 digits, no decimal places
   - task_id: NUMERIC(18,9) - 18 digits with 9 decimal places

2. **Hour Fields**
   - ST, OT, DT, TIME_OFF, HO, Sick_Time: FLOAT (approximate numeric)
   - Must be >= 0 (non-negative hours)
   - Practical maximum: 24 hours per day

3. **Financial Fields**
   - salary, gp, gpm, Net_Bill_Rate, submitted_bill_rate: MONEY (8 bytes, 4 decimal places)
   - Must be >= 0 for most fields
   - GP and GPM can be negative (loss scenarios)

4. **Headcount Fields**
   - Begin HC, End HC, Terms, OffBoard: NUMERIC(38,36) - High precision for fractional FTE
   - Range: 0 to 1 for individual resource FTE

5. **Percentage Fields**
   - Markup, actual_markup: VARCHAR or NUMERIC
   - Should be between 0 and 100 (or 0 and 1 if decimal representation)

#### 2.3.2 String Field Constraints
1. **Name Fields**
   - first name, last name: VARCHAR(50) - Maximum 50 characters
   - Cannot contain special characters or numbers (business rule)

2. **Code Fields**
   - client code: VARCHAR(50) - Alphanumeric codes
   - gci id: VARCHAR(50) - Can be alphanumeric in some tables
   - Worker_Entity_ID: VARCHAR(30)

3. **Description Fields**
   - job title: VARCHAR(50)
   - ITSSProjectName: VARCHAR(200)
   - OpportunityName: VARCHAR(200)
   - termination_reason: VARCHAR(100)

4. **Email Fields**
   - Initiator_Mail, CandidateEmail: VARCHAR(50-100)
   - Must follow email format validation

5. **Long Text Fields**
   - skills: VARCHAR(2500)
   - pskills: VARCHAR(4000)
   - Comments: VARCHAR(8000)
   - wfmetaljobdescription: NVARCHAR(MAX)

#### 2.3.3 Date and Time Constraints
1. **Date Fields**
   - All date fields: DATETIME format
   - Valid range: 1753-01-01 to 9999-12-31 (SQL Server DATETIME)
   - Must be valid calendar dates

2. **Timestamp Fields**
   - TS: TIMESTAMP (8 bytes, auto-generated)
   - system_runtime: DATETIME NOT NULL (system processing time)

3. **Date Range Constraints**
   - start date <= end date
   - po start date <= po end date
   - DateCreated <= DateCompleted
   - FirstDay <= LastDay

#### 2.3.4 Boolean Field Constraints
1. **BIT Fields**
   - isbulk, jump, client_consent, IsBillRateSkip: BIT (0 or 1)
   - IsClassInitiative: BIT (nullable)

2. **Yes/No String Fields**
   - Existing_Resource: VARCHAR(3) - 'Yes' or 'No'
   - IS_SOW: VARCHAR(7) - 'Yes' or 'No'
   - IS_Offshore: VARCHAR(20) - 'Onsite' or 'Offshore'

### 2.4 Domain and Value Constraints

#### 2.4.1 Status Field Constraints
1. **Status in report_392_all and New_Monthly_HC_Report**
   - Allowed values: 'Billed', 'Unbilled', 'SGA'
   - Must be derived from business rules (India Billing Matrix, Client Project Matrix)

2. **Workflow Status in SchTask**
   - Allowed values: 'Pending', 'Completed', 'In Progress', 'Rejected'
   - Must reflect actual workflow state

3. **Employee Status**
   - Allowed values: 'Active', 'Terminated', 'On Leave', 'Suspended'
   - Must be consistent with employment dates

#### 2.4.2 Category Field Constraints
1. **Category in report_392_all**
   - Allowed values (India Billing):
     - 'India Billing - Client-NBL'
     - 'India Billing - Billable'
     - 'India Billing - Project NBL'
   - Allowed values (Client Project):
     - 'Client-NBL'
     - 'Project-NBL'
     - 'Billable'
   - Allowed values (Bench & AVA):
     - 'AVA'
     - 'ELT Project'
     - 'Bench'
   - Allowed values (SGA):
     - 'SGA'

#### 2.4.3 Billing Type Constraints
1. **Billing_Type / Billig_Type**
   - Allowed values: 'Billable', 'NBL' (Non-Billable)
   - Must be determined by business logic:
     - Client code in ('IT010','IT008','CE035','CO120') → 'NBL'
     - ITSSProjectName like '% - pipeline%' → 'NBL'
     - Net_Bill_Rate <= 0.1 → 'NBL'
     - HWF_Process_name = 'JUMP Hourly Trainee Onboarding' → 'NBL'
     - Else → 'Billable'

#### 2.4.4 Employee Type Constraints
1. **employee type / C2C_W2_FTE**
   - Allowed values: 'FTE', 'Consultant', 'C2C', 'W2'
   - Must be derived from workflow process name and subtier company

2. **FTE/Consultant Classification Logic**
   - Process_name LIKE '%office%' AND HR_Subtier_Company = 'Ascendion Engineering Private Limited' → 'FTE'
   - Process_name LIKE '%office%' AND HR_Subtier_Company = 'Ascendion Engineering Solutions Mexico' → 'FTE'
   - Process_name LIKE '%office%' AND HR_Subtier_Company IS NULL → 'FTE'
   - Process_name LIKE '%Contractor%' AND HR_Subtier_Company NOT IN (specific list) → 'Consultant'
   - Else → 'Consultant'

#### 2.4.5 Location and Geography Constraints
1. **Location Fields**
   - project city, project state: Must be valid geographic locations
   - Location in holiday tables: Must match resource location classification

2. **IS_Offshore**
   - Allowed values: 'Onsite', 'Offshore'
   - Determines hours per day (9 for Offshore/India, 8 for Onsite)

3. **Business Area**
   - Allowed values: 'NA', 'LATAM', 'Others', 'India'
   - Must align with geographic location

#### 2.4.6 Project and Client Constraints
1. **Client Code**
   - Must be valid registered client code
   - Special codes: 'IT010', 'IT008', 'CE035', 'CO120' (NBL clients)

2. **ITSSProjectName**
   - Must not be NULL for active resources
   - Special project names for Bench & AVA classification:
     - 'AVA_Architecture, Development & Testing Project'
     - 'CapEx - GenAI Project'
     - 'ASC-ELT Program-2024'
     - 'Dummy Project - Managed Services Hiring'
     - And others as defined in business rules

3. **Project Type (FP_TM)**
   - Allowed values: 'FP' (Fixed Price), 'TM' (Time & Material)
   - Must be consistent with billing arrangements

### 2.5 Referential Integrity Constraints

#### 2.5.1 Foreign Key Relationships
1. **Timesheet_New → SchTask**
   - Timesheet_New.gci_id references SchTask.GCI_ID
   - Ensures timesheet entries link to valid workflow records

2. **Timesheet_New → report_392_all**
   - Timesheet_New.gci_id references report_392_all.[gci id]
   - Ensures timesheet entries link to valid resource records

3. **Timesheet_New → DimDate**
   - Timesheet_New.c_date references DimDate.Date
   - Ensures timesheet dates are valid calendar dates

4. **report_392_all → New_Monthly_HC_Report**
   - report_392_all.[gci id] references New_Monthly_HC_Report.[gci id]
   - Ensures resource consistency across operational and reporting tables

5. **SchTask → report_392_all**
   - SchTask.GCI_ID references report_392_all.[gci id]
   - Ensures workflow tasks link to valid resources

6. **DimDate → Holiday Tables**
   - Holiday tables' Holiday_Date should exist in DimDate.Date
   - Ensures holidays are valid calendar dates

#### 2.5.2 Lookup Table Relationships
1. **Location-based Holiday Lookup**
   - Resource location determines which holiday table to reference:
     - India → holidays_India
     - US → holidays
     - Canada → holidays_Canada
     - Mexico → holidays_Mexico

2. **Client and Project Lookup**
   - Client codes must exist in client master
   - Project codes must exist in project master
   - Organizational hierarchy must be maintained

### 2.6 Calculated Field Constraints

#### 2.6.1 Hour Calculation Constraints
1. **Total Hours**
   - Formula: Number of working days × Location-specific hours (8 or 9)
   - Must exclude weekends (Saturday, Sunday) from DimDate
   - Must exclude location-specific holidays
   - Must be > 0 for any active resource in a month

2. **Submitted Hours**
   - Formula: Sum of (ST + OT + DT + TIME_OFF + HO + Sick_Time)
   - Must be >= 0
   - Should not exceed Total Hours × 1.5 (reasonable overtime limit)

3. **Approved Hours**
   - Formula: Sum of (NON_ST + NON_OT + NON_DT + NON_Sick_Time)
   - Must be >= 0
   - Must be <= Submitted Hours
   - If Approved Hours is NULL or 0, use Submitted Hours for calculations

4. **Available Hours**
   - Formula: Monthly Hours × Total FTE
   - Must be >= 0
   - Must be <= Total Hours

5. **Billed Hours**
   - Actual hours billed to client
   - Must be >= 0
   - Must be <= Available Hours for utilization calculations

#### 2.6.2 FTE Calculation Constraints
1. **Total FTE**
   - Formula: Submitted Hours / Total Hours
   - Must be >= 0
   - For single project allocation: Must be <= 1.0
   - For multiple project allocations: Sum across all projects must equal 1.0

2. **Billed FTE**
   - Formula: Approved TS hours / Total Hours
   - If Approved Hours unavailable, use Submitted Hours
   - Must be >= 0
   - Must be <= Total FTE

3. **Project Utilization (Proj UTL)**
   - Formula: Billed Hours / Available Hours
   - Must be >= 0
   - Can exceed 1.0 if overtime is billed
   - Typically should be between 0 and 1.2

#### 2.6.3 Financial Calculation Constraints
1. **Gross Profit (GP)**
   - Formula: Revenue - Cost
   - Can be negative (loss scenarios)
   - Must be calculated consistently across tables

2. **Gross Profit Margin (GPM)**
   - Formula: (GP / Revenue) × 100
   - Can be negative
   - Typically between -50% and 100%

3. **Markup**
   - Formula: ((Bill Rate - Pay Rate) / Pay Rate) × 100
   - Must be >= 0 for most cases
   - actual_markup <= maximum_allowed_markup (business constraint)

#### 2.6.4 Headcount Movement Constraints
1. **Headcount Reconciliation**
   - Formula: Begin HC + Starts - Terms - OffBoard = End HC
   - Must balance for each month
   - All components must be >= 0

2. **Movement Categories**
   - Starts - New Project: New resource additions
   - Starts - Internal movements: Internal transfers
   - Terms: Terminations
   - Other project Ends: Project completions
   - OffBoard: Offboarding activities
   - All must be >= 0 and <= Begin HC + Starts

### 2.7 Business Rule Constraints

#### 2.7.1 India Billing Matrix Constraints
1. **India Billing - Client-NBL**
   - Constraint: ITSSProjectName LIKE 'India Billing%Pipeline%' AND Billing_Type = 'NBL'
   - Status must be 'Unbilled'

2. **India Billing - Billable**
   - Constraint: Client name CONTAINS 'India-Billing' AND Billing_Type = 'Billable'
   - Status must be 'Billed'

3. **India Billing - Project NBL**
   - Constraint: Client name CONTAINS 'India-Billing' AND Billing_Type = 'NBL'
   - Status must be 'Unbilled'

#### 2.7.2 Client Project Matrix Constraints
1. **Client-NBL**
   - Constraint: Client name NOT LIKE '%India-Billing%' AND ITSSProjectName LIKE '%Pipeline%' AND Billing_Type = 'NBL'
   - Status must be 'Unbilled'

2. **Project-NBL**
   - Constraint: Client name NOT LIKE '%India-Billing%' AND ITSSProjectName NOT LIKE '%Pipeline%' AND Billing_Type = 'NBL'
   - Status must be 'Unbilled'

3. **Billable**
   - Constraint: Client name NOT LIKE '%India-Billing%' AND ITSSProjectName NOT LIKE '%Pipeline%' AND Billing_Type = 'Billable'
   - Status must be 'Billed'
   - Alternative: Billing_Type IS NULL AND Actual Hours > 0 → Billable

#### 2.7.3 SGA (Selling, General & Administrative) Constraints
1. **SGA Resources**
   - Must be identified from approved SGA list
   - Category must be 'SGA'
   - Status must be 'SGA'
   - Specific GCI IDs marked as SGA based on business approval

#### 2.7.4 Bench & AVA Matrix Constraints
1. **AVA Projects**
   - ITSSProjectName in predefined AVA project list
   - Category = 'AVA'
   - Status = 'AVA'

2. **ELT Projects**
   - ITSSProjectName in ('ASC-ELT Program-2024', 'CES - ELT\'s Program')
   - Category = 'ELT Project'
   - Status = 'Bench'

3. **Bench Projects**
   - ITSSProjectName in predefined bench project list
   - Category = 'Bench'
   - Status = 'Bench'

#### 2.7.5 Multiple Allocation Constraints
1. **Weighted Average Logic**
   - When resource allocated to multiple projects:
     - Total Hours distributed based on ratio of Submitted Hours for each project
     - Sum of Total FTE across all projects must equal 1.0
     - Any difference adjusted proportionally

2. **Project-Level FTE**
   - Each project allocation must have:
     - Total FTE = (Project Submitted Hours) / (Total Available Hours)
     - Avl Hrs = Total Hours × Total FTE
     - Billed Hrs = Approved Hours for that project
     - Proj UTL = Billed Hrs / Avl Hrs

---

## 3. BUSINESS RULES

Business Rules define the operational logic, transformation guidelines, reporting calculations, and decision-making criteria that govern how data is processed, categorized, and reported.

### 3.1 Hour Calculation Business Rules

#### 3.1.1 Total Hours Calculation
1. **Location-Based Hours Per Day**
   - **Rule**: Offshore (India) resources work 9 hours per day
   - **Rule**: Onshore (US, Canada, LATAM, Mexico) resources work 8 hours per day
   - **Source**: IS_Offshore field or resource location
   - **Application**: Used in Total Hours calculation

2. **Working Days Determination**
   - **Rule**: Exclude weekends (Saturday and Sunday) from working days
   - **Source**: DimDate table (DayName field)
   - **Rule**: Exclude location-specific holidays from working days
   - **Source**: holidays, holidays_India, holidays_Canada, holidays_Mexico tables
   - **Calculation**: Working Days = Total Days in Month - Weekends - Holidays

3. **Total Hours Formula**
   - **Rule**: Total Hours = Number of Working Days × Location-Specific Hours
   - **Example**: US August with 19 working days = 19 × 8 = 152 hours
   - **Example**: India August with 19 working days = 19 × 9 = 171 hours
   - **Application**: Denominator for FTE calculations

4. **Holiday Mapping**
   - **Rule**: Match resource location to appropriate holiday table
   - **Mapping**:
     - India location → holidays_India
     - US location → holidays
     - Canada location → holidays_Canada
     - Mexico location → holidays_Mexico
   - **Validation**: Holiday_Date must exist in DimDate

#### 3.1.2 Submitted Hours Business Rules
1. **Timesheet Hour Types**
   - **Rule**: Submitted Hours include multiple hour types:
     - ST (Standard Time): Regular working hours
     - OT (Overtime): Overtime hours
     - DT (Double Time): Double time hours
     - TIME_OFF: Time off hours
     - HO (Holiday): Holiday hours worked
     - Sick_Time: Sick leave hours
   - **Source**: Timesheet_New table columns

2. **Submitted Hours Aggregation**
   - **Rule**: Submitted Hours = ST + OT + DT + TIME_OFF + HO + Sick_Time
   - **Application**: Used for Total FTE calculation
   - **Validation**: Must be >= 0

3. **Consultant vs Approved Hours**
   - **Rule**: Consultant submits hours in columns: ST, OT, DT, Sick_Time
   - **Source**: vw_consultant_timesheet_daywise (Consultant_hours)
   - **Rule**: Manager approves hours in columns: NON_ST, NON_OT, NON_DT, NON_Sick_Time
   - **Source**: vw_billing_timesheet_daywise_ne (Approved_hours)

#### 3.1.3 Approved Hours Business Rules
1. **Approval Process**
   - **Rule**: Approved hours recorded by Project Manager, Client, or designated Approver
   - **Columns**: NON_ST, NON_OT, NON_DT, NON_Sick_Time
   - **Validation**: Approved Hours <= Submitted Hours

2. **Approved Hours Aggregation**
   - **Rule**: Approved Hours = NON_ST + NON_OT + NON_DT + NON_Sick_Time
   - **Application**: Used for Billed FTE calculation

3. **Fallback Logic**
   - **Rule**: If Approved Hours is NULL or unavailable, use Submitted Hours
   - **Application**: Ensures Billed FTE can always be calculated
   - **Rationale**: Assumes submitted hours are approved in absence of explicit approval

#### 3.1.4 Available and Billed Hours Business Rules
1. **Available Hours Calculation**
   - **Rule**: Available Hours = Monthly Hours × Total FTE
   - **Purpose**: Represents hours available for billing based on resource allocation
   - **Application**: Denominator for Project Utilization calculation

2. **Billed Hours Definition**
   - **Rule**: Billed Hours = Actual hours billed to client
   - **Source**: Approved timesheet hours for billable projects
   - **Validation**: Should not exceed Available Hours under normal circumstances

3. **Expected Hours**
   - **Rule**: Hard coded as 8 hours per day
   - **Source**: report_392_all and New_Monthly_HC_Report
   - **Note**: This is a standard expectation, actual may vary

4. **Total Available Hours**
   - **Rule**: Total Available Hours = Monthly Expected Hours
   - **Application**: Used in headcount and capacity planning

### 3.2 FTE Calculation Business Rules

#### 3.2.1 Total FTE Calculation
1. **Single Project Allocation**
   - **Rule**: Total FTE = Submitted Hours / Total Hours
   - **Range**: 0 to 1.0 for single project
   - **Interpretation**: 1.0 = Full-time allocation, 0.5 = Half-time allocation

2. **Multiple Project Allocation**
   - **Rule**: Calculate FTE for each project separately
   - **Formula**: Project FTE = (Project Submitted Hours) / Total Hours
   - **Constraint**: Sum of all Project FTEs must equal 1.0
   - **Example**:
     - Resource: Mukesh Agrawal
     - Total Hours: 176 (location-based monthly hours)
     - Project 1: 40 hours → FTE = 40/176 = 0.23392
     - Project 2: 43 hours → FTE = 43/176 = 0.25146
     - Project 3: 44 hours → FTE = 44/176 = 0.25731
     - Project 4: 44 hours → FTE = 44/176 = 0.25731
     - Total: 171 hours → Total FTE = 1.00000

3. **Weighted Average Logic (Post Q3 2024)**
   - **Background**: Prior to Q3 2024, multiple allocations counted as 1 FTE each (overcounting)
   - **New Rule**: Implement weighted average to accurately reflect fractional FTE
   - **Application**: Total Hours distributed based on ratio of Submitted Hours
   - **Adjustment**: Any rounding difference adjusted proportionally across projects

#### 3.2.2 Billed FTE Calculation
1. **Primary Formula**
   - **Rule**: Billed FTE = Approved TS Hours / Total Hours
   - **Source**: Approved hours from timesheet approval process

2. **Fallback Formula**
   - **Rule**: If Approved Hours unavailable, Billed FTE = Submitted Hours / Total Hours
   - **Application**: Ensures calculation always possible

3. **Relationship to Total FTE**
   - **Rule**: Billed FTE <= Total FTE
   - **Interpretation**: Cannot bill more than allocated time
   - **Exception**: Overtime scenarios may result in Billed FTE > Total FTE

#### 3.2.3 Project Utilization Calculation
1. **Formula**
   - **Rule**: Project Utilization (Proj UTL) = Billed Hours / Available Hours
   - **Range**: Typically 0 to 1.0 (0% to 100%)
   - **Interpretation**: Percentage of available time actually billed

2. **Multiple Project Example**
   - **Resource**: Mukesh Agrawal
   - **Location Available Hours**: 176
   - **Project 1**: Avl Hrs = 41.17, Billed Hrs = 40, Proj UTL = 97.16%
   - **Project 2**: Avl Hrs = 44.26, Billed Hrs = 43, Proj UTL = 97.16%
   - **Project 3**: Avl Hrs = 45.29, Billed Hrs = 44, Proj UTL = 97.16%
   - **Project 4**: Avl Hrs = 45.29, Billed Hrs = 44, Proj UTL = 97.16%
   - **Total**: Avl Hrs = 176, Billed Hrs = 171, Proj UTL = 97.16%

3. **Utilization Thresholds**
   - **High Utilization**: > 90% (efficient resource usage)
   - **Optimal Utilization**: 80-90% (balanced workload)
   - **Low Utilization**: < 70% (underutilization concern)
   - **Over-Utilization**: > 100% (overtime or overbilling)

### 3.3 Resource Classification Business Rules

#### 3.3.1 FTE vs Consultant Classification
1. **Source of Classification**
   - **Rule**: Classification determined from Workflow (SchTask table)
   - **Field**: HWF_Process_name (Workflow Process Name)
   - **Field**: HR_Subtier_Company (Subtier Company)

2. **FTE Classification Rules**
   - **Rule 1**: Process_name LIKE '%office%' AND HR_Subtier_Company = 'Ascendion Engineering Private Limited' → FTE
   - **Rule 2**: Process_name LIKE '%office%' AND HR_Subtier_Company = 'Ascendion Engineering Solutions Mexico' → FTE
   - **Rule 3**: Process_name LIKE '%office%' AND ISNULL(HR_Subtier_Company, '') = '' → FTE
   - **Interpretation**: Office-based employees in Ascendion entities are FTE

3. **Consultant Classification Rules**
   - **Rule 1**: Process_name LIKE '%Contractor%' AND HR_Subtier_Company NOT IN (
     - 'Collabera Technologies Pvt. Ltd.',
     - 'Collaborate Solutions, Inc',
     - 'Ascendion Engineering Private Limited',
     - 'Ascendion Engineering Solutions Mexico',
     - 'Ascendion Canada Inc.',
     - 'Ascendion Engineering Solutions Europe Limited',
     - 'Ascendion Digital Solution Pvt. Ltd'
   ) → Consultant
   - **Rule 2**: ELSE → Consultant (default classification)
   - **Interpretation**: Contractors outside Ascendion entities are Consultants

4. **C2C/W2/FTE Classification**
   - **C2C (Corp-to-Corp)**: Independent contractor through their own corporation
   - **W2**: Employee on company payroll (W2 tax form)
   - **FTE (Full-Time Employee)**: Permanent employee
   - **Source**: C2C_W2_FTE field in report_392_all

#### 3.3.2 Employee Type and Status
1. **Employee Type**
   - **Values**: 'FTE', 'Consultant', 'Contractor', 'Temporary'
   - **Source**: employee type field in report_392_all
   - **Application**: Determines benefits, billing rates, and reporting category

2. **Employee Status**
   - **Values**: 'Active', 'Terminated', 'On Leave', 'Suspended'
   - **Source**: employee_status, Emp_Status fields
   - **Rules**:
     - Active: start date <= current date AND (end date IS NULL OR end date >= current date)
     - Terminated: termdate IS NOT NULL AND termdate <= current date

3. **Employee Category**
   - **Source**: employee_category field in New_Monthly_HC_Report
   - **Application**: Used for headcount reporting and workforce segmentation

### 3.4 Billing and Revenue Business Rules

#### 3.4.1 Billing Type Determination
1. **Non-Billable (NBL) Rules**
   - **Rule 1**: Client code IN ('IT010', 'IT008', 'CE035', 'CO120') → NBL
   - **Rationale**: Specific internal or non-billable client codes
   
   - **Rule 2**: ITSSProjectName LIKE '% - pipeline%' → NBL
   - **Rationale**: Pipeline projects are pre-sales, not yet billable
   
   - **Rule 3**: Net_Bill_Rate <= 0.1 → NBL
   - **Rationale**: Negligible bill rate indicates non-billable arrangement
   
   - **Rule 4**: HWF_Process_name = 'JUMP Hourly Trainee Onboarding' → NBL
   - **Rationale**: Training programs are non-billable

2. **Billable Rules**
   - **Rule**: ELSE → Billable (default if none of NBL rules apply)
   - **Validation**: Net_Bill_Rate > 0.1
   - **Validation**: Client is external paying client

3. **Billing Type Application**
   - **Field**: Billing_Type or Billig_Type
   - **Values**: 'Billable', 'NBL'
   - **Usage**: Determines if hours contribute to revenue

#### 3.4.2 Category Assignment Rules

**India Billing Matrix**

1. **India Billing - Client-NBL**
   - **Condition**: ITSSProjectName LIKE 'India Billing%Pipeline%' AND Billing_Type = 'NBL'
   - **Exclusion**: NOT IN (AVA, ELT, Bench project list)
   - **Category**: 'India Billing - Client-NBL'
   - **Status**: 'Unbilled'

2. **India Billing - Billable**
   - **Condition**: Client name CONTAINS 'India-Billing' AND Billing_Type = 'Billable'
   - **Category**: 'India Billing - Billable'
   - **Status**: 'Billed'

3. **India Billing - Project NBL**
   - **Condition**: Client name CONTAINS 'India-Billing' AND Billing_Type = 'NBL'
   - **Category**: 'India Billing - Project NBL'
   - **Status**: 'Unbilled'

**Client Project Matrix (Excluding India Billing)**

4. **Client-NBL**
   - **Condition**: Client name NOT LIKE '%India-Billing%' AND ITSSProjectName LIKE '%Pipeline%' AND Billing_Type = 'NBL'
   - **Category**: 'Client-NBL'
   - **Status**: 'Unbilled'

5. **Project-NBL**
   - **Condition**: Client name NOT LIKE '%India-Billing%' AND ITSSProjectName NOT LIKE '%Pipeline%' AND Billing_Type = 'NBL'
   - **Category**: 'Project-NBL'
   - **Status**: 'Unbilled'

6. **Billable**
   - **Condition**: Client name NOT LIKE '%India-Billing%' AND ITSSProjectName NOT LIKE '%Pipeline%' AND Billing_Type = 'Billable'
   - **Category**: 'Billable'
   - **Status**: 'Billed'
   
   - **Alternative Condition**: Billing_Type IS NULL AND Actual Hours > 0
   - **Category**: 'Billable'
   - **Status**: 'Billed'

7. **Default**
   - **Condition**: ELSE (none of above conditions met)
   - **Category**: 'Project-NBL'
   - **Status**: 'Unbilled'

**SGA (Selling, General & Administrative)**

8. **SGA Resources**
   - **Source**: Approved SGA list provided by business (e.g., JayaLaxmi)
   - **Identification**: Specific GCI IDs marked as SGA
   - **Category**: 'SGA'
   - **Status**: 'SGA'
   - **Application**: Override other category rules for approved SGA resources

**Bench & AVA Matrix**

9. **AVA (Available for Assignment)**
   - **Condition**: ITSSProjectName IN (
     - 'AVA_Architecture, Development & Testing Project',
     - 'CapEx - GenAI Project',
     - 'CapEx - Web3.0+Gaming 2 (Gaming/Metaverse)',
     - 'Capex - Data Assets',
     - 'AVA_Support, Management & Planning Project',
     - 'Dummy Project - TIQE Bench Project'
   )
   - **Category**: 'AVA'
   - **Status**: 'AVA'

10. **ELT Project (Executive Leadership Training)**
    - **Condition**: ITSSProjectName IN (
      - 'ASC-ELT Program-2024',
      - 'CES - ELT\'s Program'
    )
    - **Category**: 'ELT Project'
    - **Status**: 'Bench'

11. **Bench**
    - **Condition**: ITSSProjectName IN (
      - 'Dummy Project - Managed Services Hiring',
      - 'GenAI Capability Project - ITSS Collabera',
      - 'Gaming/Metaverse CapEx Project Bench'
    )
    - **Category**: 'Bench'
    - **Status**: 'Bench'

#### 3.4.3 Status Determination Rules
1. **Billed Status**
   - **Condition**: Category = 'Billable' OR Category = 'India Billing - Billable'
   - **Status**: 'Billed'
   - **Implication**: Hours contribute to revenue

2. **Unbilled Status**
   - **Condition**: Category IN ('Client-NBL', 'Project-NBL', 'India Billing - Client-NBL', 'India Billing - Project NBL')
   - **Status**: 'Unbilled'
   - **Implication**: Hours do not contribute to revenue

3. **SGA Status**
   - **Condition**: Category = 'SGA'
   - **Status**: 'SGA'
   - **Implication**: Administrative overhead, not project-related

4. **AVA Status**
   - **Condition**: Category = 'AVA'
   - **Status**: 'AVA'
   - **Implication**: Available for assignment, internal capability building

5. **Bench Status**
   - **Condition**: Category IN ('Bench', 'ELT Project')
   - **Status**: 'Bench'
   - **Implication**: Not assigned to billable project, awaiting assignment

#### 3.4.4 Financial Metrics Calculation
1. **Net Bill Rate**
   - **Source**: Net_Bill_Rate field in report_392_all
   - **Validation**: Must be > 0 for billable resources
   - **Application**: Used in Billing_Type determination (NBL if <= 0.1)

2. **Gross Profit (GP)**
   - **Formula**: GP = Revenue - Cost
   - **Revenue**: Bill Rate × Billed Hours
   - **Cost**: Pay Rate × Billed Hours + Overhead
   - **Fields**: gp, GP, GP2020 in various tables

3. **Gross Profit Margin (GPM)**
   - **Formula**: GPM = (GP / Revenue) × 100
   - **Fields**: gpm, GPM2020, SUB_GPM
   - **Interpretation**: Percentage profitability

4. **Markup**
   - **Formula**: Markup = ((Bill Rate - Pay Rate) / Pay Rate) × 100
   - **Fields**: markup, actual_markup, maximum_allowed_markup, client_Markup
   - **Validation**: actual_markup <= maximum_allowed_markup

5. **Derived Revenue and GP**
   - **Fields**: Derived_Rev, Derived_GP in New_Monthly_HC_Report
   - **Application**: Projected revenue and profit based on current rates and allocation

6. **Backlog Revenue and GP**
   - **Fields**: Backlog_Rev, Backlog_GP in New_Monthly_HC_Report
   - **Application**: Future committed revenue and profit

### 3.5 Headcount and Workforce Movement Business Rules

#### 3.5.1 Monthly Headcount Calculation
1. **Begin HC (Beginning Headcount)**
   - **Definition**: Number of resources at the start of the month
   - **Source**: End HC from previous month
   - **First Month**: Actual count of active resources

2. **Starts - New Project**
   - **Definition**: New resources added to projects during the month
   - **Identification**: start date within the month AND new to the organization
   - **FTE Value**: Fractional based on days active in month

3. **Starts - Internal Movements**
   - **Definition**: Existing resources moved to different projects
   - **Identification**: Project change within the month for existing resource
   - **FTE Value**: Fractional based on allocation change

4. **Terms (Terminations)**
   - **Definition**: Resources terminated during the month
   - **Identification**: termdate, NewTermdate within the month
   - **FTE Value**: Fractional based on days active before termination

5. **Other Project Ends**
   - **Definition**: Project assignments ending without termination
   - **Identification**: end date, Final_End_date within month, but resource remains active
   - **FTE Value**: Fractional based on project end timing

6. **OffBoard**
   - **Definition**: Resources offboarded from the organization
   - **Identification**: Newoffboardingdate, Offboarding_Initiated within month
   - **FTE Value**: Fractional based on offboarding timing

7. **End HC (Ending Headcount)**
   - **Formula**: End HC = Begin HC + Starts - New Project + Starts - Internal Movements - Terms - Other Project Ends - OffBoard
   - **Validation**: Must reconcile with actual count at month end

8. **Vol_term (Voluntary Termination)**
   - **Definition**: Subset of Terms where termination_reason indicates voluntary departure
   - **Application**: Used for attrition analysis

9. **Adjustment (adj)**
   - **Definition**: Reconciliation adjustment to balance headcount equation
   - **Application**: Corrects for timing differences or data discrepancies

#### 3.5.2 Headcount Reporting Dimensions
1. **Business Area**
   - **Values**: 'NA' (North America), 'LATAM', 'Others', 'India'
   - **Source**: Geographic location, market field
   - **Application**: Regional headcount reporting

2. **Tower / Practice**
   - **Source**: tower1, DTCUChoice1 fields
   - **Application**: Skill-based or service line headcount

3. **Requirement Type**
   - **Source**: req type field
   - **Application**: Categorizes type of resource requirement

4. **ITSS Project**
   - **Source**: ITSSProjectName, ITSS fields
   - **Application**: Project-level headcount tracking

5. **Onsite/Offshore**
   - **Source**: IS_Offshore field
   - **Values**: 'Onsite', 'Offshore'
   - **Application**: Location-based headcount and cost analysis

6. **Subtier**
   - **Source**: Subtier field
   - **Application**: Legal entity or subsidiary headcount

7. **Visa Type**
   - **Source**: New_Visa_type, visa type fields
   - **Application**: Immigration and compliance reporting

8. **Practice Type**
   - **Source**: Practice_type field
   - **Application**: Service offering categorization

9. **Vertical**
   - **Source**: vertical, VerticalName fields
   - **Application**: Industry vertical headcount

10. **Client Group**
    - **Source**: CL_Group, Client_Group, Client_Group1 fields
    - **Application**: Client-based headcount segmentation

#### 3.5.3 Workforce Movement Tracking
1. **Employment Status Tracking**
   - **FirstDay**: First day of employment or project assignment
   - **LastDay**: Last day of employment or project assignment
   - **Emp_Status**: Current employment status
   - **Application**: Lifecycle tracking from hire to termination

2. **Termination Tracking**
   - **termdate**: Original termination date
   - **newtermdate**: Updated termination date
   - **NewTermdate**: Latest termination date
   - **termination_reason**: Reason for termination
   - **latest_termination_reason**: Most recent termination reason
   - **latest_termination_date**: Most recent termination date
   - **Application**: Attrition analysis and exit management

3. **Offboarding Tracking**
   - **Newoffboardingdate**: Scheduled offboarding date
   - **Offboarding_Initiated**: Date offboarding process started
   - **Offboarding_Reason**: Reason for offboarding
   - **Offboarding_Status**: Current status of offboarding process
   - **Application**: Offboarding process management

4. **End Date Tracking**
   - **end date**: Project or assignment end date
   - **Final_End_date**: Calculated final end date
   - **newenddate**: Updated end date
   - **newhrisenddate**: HRIS system end date
   - **Derived_System_End_date**: System-calculated end date
   - **Application**: Project lifecycle and resource planning

5. **Workforce Reason Tracking**
   - **ee_wf_reason**: Employee workflow reason
   - **EE_WF_Reasons**: Workflow reason codes
   - **Application**: Categorizes workforce actions (hire, transfer, termination)

### 3.6 Project and Client Management Business Rules

#### 3.6.1 Project Classification
1. **Project Type (FP_TM)**
   - **FP (Fixed Price)**: Project billed at fixed total price
   - **TM (Time & Material)**: Project billed based on hours worked
   - **Source**: FP_TM field
   - **Application**: Determines billing and revenue recognition approach

2. **SOW (Statement of Work)**
   - **Definition**: Client engagement governed by SOW document
   - **Source**: IS_SOW field
   - **Values**: 'Yes', 'No'
   - **Application**: Contractual and compliance tracking

3. **VAS (Value Added Services)**
   - **Source**: New_VAS, defined_New_VAS, VAS_Type fields
   - **Application**: Categorizes value-added service offerings

4. **Offshore Indicator**
   - **Source**: IS_Offshore field
   - **Values**: 'Onsite', 'Offshore'
   - **Application**: Determines location-based hours (8 vs 9) and cost structure

5. **MSP (Managed Service Provider)**
   - **Source**: MSP field
   - **Application**: Identifies managed service engagements

6. **Project Billing Type**
   - **Source**: Project_billing_type, Resource_billing_type fields
   - **Application**: Defines billing arrangement at project and resource level

#### 3.6.2 Client Classification
1. **Client Code**
   - **Source**: client code field
   - **Format**: Alphanumeric (e.g., IT010, CE035)
   - **Application**: Unique client identifier

2. **Client Name**
   - **Source**: client name field
   - **Application**: Client identification and reporting

3. **Client Type**
   - **Source**: client_type field
   - **Application**: Categorizes client relationship

4. **Client Sector**
   - **Source**: client_sector field
   - **Application**: Industry sector classification

5. **Client Group**
   - **Source**: Client_Group, Client_Group1, CL_Group fields
   - **Application**: Groups related clients for reporting

6. **Super Merged Name**
   - **Definition**: Parent client name for consolidated reporting
   - **Source**: Super Merged Name field
   - **Application**: Rolls up subsidiary clients to parent organization

7. **Merged Name**
   - **Definition**: Intermediate client grouping
   - **Source**: Merged Name field
   - **Application**: Client hierarchy management

8. **Client Entity**
   - **Source**: client_entity field
   - **Application**: Legal entity of client for compliance

9. **Client Class**
   - **Source**: client_class field
   - **Application**: Client tier or classification

10. **Client Region**
    - **Source**: client_region field
    - **Application**: Geographic region of client

#### 3.6.3 Opportunity and Sales Tracking
1. **Opportunity ID**
   - **Source**: OpportunityID field
   - **Application**: Links resource to sales opportunity

2. **Opportunity Name**
   - **Source**: OpportunityName field
   - **Application**: Describes sales opportunity

3. **MS Project ID**
   - **Source**: Ms_ProjectId field
   - **Application**: Microsoft Project system identifier

4. **MS Project Name**
   - **Source**: MS_ProjectName field
   - **Application**: Project name in Microsoft Project

5. **Netsuite Project ID**
   - **Source**: NetsuiteProjectId field
   - **Application**: Financial system project identifier

6. **FP Project ID**
   - **Source**: FP_Proj_ID field
   - **Application**: Fixed price project identifier

7. **FP Project Name**
   - **Source**: FP_Proj_Name field
   - **Application**: Fixed price project name

### 3.7 Organizational Hierarchy Business Rules

#### 3.7.1 Management Hierarchy
1. **Portfolio Leader**
   - **Source**: PortfolioLeader field
   - **Application**: Top-level portfolio management
   - **Note**: Included in base for Power BI filtering

2. **Client Partner**
   - **Source**: ClientPartner field
   - **Application**: Client relationship owner

3. **Market Leader**
   - **Source**: Market_Leader field
   - **Application**: Market segment leadership

4. **Account Owner**
   - **Source**: Acct_Owner field
   - **Application**: Account management responsibility

5. **Delivery Leader**
   - **Source**: Delivery Leader column (calculated)
   - **Source Mapping**: Provided by JayaLaxmi
   - **Application**: Delivery organization hierarchy

6. **Senior Manager**
   - **Source**: Senior Manager field
   - **Application**: Senior management level

7. **Associate Manager**
   - **Source**: Associate Manager field
   - **Application**: Associate management level

8. **Director - Talent Engine**
   - **Source**: Director - Talent Engine field
   - **Application**: Talent acquisition leadership

9. **Manager**
   - **Source**: Manager field
   - **Application**: Direct manager

#### 3.7.2 Recruiting and Sales Hierarchy
1. **Recruiting Manager**
   - **Source**: recruiting manager, recruiting_manager, HR_Recruiting_Manager fields
   - **Application**: Recruiting team management

2. **Resource Manager**
   - **Source**: resource manager, resource_manager fields
   - **Application**: Resource allocation and management

3. **Sales Representative**
   - **Source**: salesrep field
   - **Application**: Sales ownership

4. **Inside Sales Person**
   - **Source**: Inside_Sales_Person, inside_sales fields
   - **Application**: Inside sales team member

5. **Recruiter**
   - **Source**: recruiter field
   - **Application**: Individual recruiter

6. **VMO (Vendor Management Office)**
   - **Source**: vmo, HR_Recruiting_VMO, VMO_Access fields
   - **Application**: Vendor management coordination

7. **Team Lead (TL)**
   - **Source**: tl, HR_Recruiting_TL fields
   - **Application**: Team leadership

8. **NAM (National Account Manager)**
   - **Source**: nam, HR_Recruiting_NAM fields
   - **Application**: National account management

9. **Delivery Manager (DM)**
   - **Source**: dm field
   - **Application**: Delivery management

10. **Delivery Director**
    - **Source**: delivery_director field
    - **Application**: Delivery organization director

#### 3.7.3 Organizational Structure
1. **Business Unit (BU)**
   - **Source**: bu, ESG_BU fields
   - **Application**: Business unit classification

2. **Circle**
   - **Source**: Circle, circle, Circle_Metal, Circle_new fields
   - **Source Detail**: Circle_new from connection file 392
   - **Application**: Organizational circle or pod structure

3. **Community**
   - **Source**: Community, community_new, Community_New_Metal fields
   - **Application**: Community of practice or skill group

4. **Tower**
   - **Source**: tower1 field
   - **Logic**: DTCUChoice1
   - **Application**: Service tower or practice area

5. **Vertical**
   - **Source**: vertical, VerticalName, ESG_Vertical fields
   - **Application**: Industry vertical

6. **Division**
   - **Source**: division, req_division fields
   - **Application**: Organizational division

7. **Department**
   - **Source**: Dept field
   - **Application**: Department classification

8. **HCU (Horizontal Capability Unit)**
   - **Source**: hcu, HCU fields
   - **Application**: Capability-based organizational unit

9. **HSU (Horizontal Service Unit)**
   - **Source**: hsu, HSU, assigned_hsu fields
   - **Application**: Service-based organizational unit

10. **Operations Group**
    - **Source**: OpsGrp field
    - **Application**: Operations team grouping

### 3.8 Timesheet and Approval Business Rules

#### 3.8.1 Timesheet Submission Rules
1. **Submission Frequency**
   - **Rule**: Timesheets submitted based on payroll cycle
   - **Source**: pe_date (period end date)
   - **Typical Cycle**: Weekly or bi-weekly

2. **Hour Types**
   - **ST (Standard Time)**: Regular working hours
   - **OT (Overtime)**: Hours beyond standard (typically > 8 or 9 hours/day)
   - **DT (Double Time)**: Premium overtime hours
   - **TIME_OFF**: Paid time off
   - **HO (Holiday)**: Holiday hours worked
   - **Sick_Time**: Sick leave hours

3. **Submission Validation**
   - **Rule**: At least one hour type must have value > 0
   - **Rule**: Total daily hours should not exceed 24
   - **Rule**: Timesheet date (c_date) must be within employment period

4. **Task Assignment**
   - **Rule**: Each timesheet entry must link to task_id
   - **Source**: task_id in Timesheet_New references SchTask.ID
   - **Validation**: Task must be active and assigned to resource

#### 3.8.2 Approval Workflow Rules
1. **Approval Hierarchy**
   - **Level 1**: Project Manager or Team Lead
   - **Level 2**: Client Approver (if required)
   - **Level 3**: Final Approver
   - **Source**: Level_ID in SchTask

2. **Approved Hour Types**
   - **NON_ST**: Approved standard time
   - **NON_OT**: Approved overtime
   - **NON_DT**: Approved double time
   - **NON_Sick_Time**: Approved sick time

3. **Approval Validation**
   - **Rule**: Approved hours <= Submitted hours for each hour type
   - **Rule**: Approval must occur within defined timeframe
   - **Rule**: Approver must have authority for the project

4. **Billable Indicator**
   - **Source**: BILLABLE field in vw_billing_timesheet_daywise_ne
   - **Values**: 'Yes', 'No'
   - **Application**: Determines if approved hours are billable

#### 3.8.3 Timesheet Aggregation Rules
1. **Daily Aggregation**
   - **Source**: c_date (calendar date)
   - **Aggregation**: Sum all hour types for each resource per day

2. **Weekly Aggregation**
   - **Source**: WEEK_DATE field
   - **Aggregation**: Sum daily hours for each week
   - **Application**: Weekly payroll and billing

3. **Period Aggregation**
   - **Source**: pe_date (period end date)
   - **Aggregation**: Sum hours for payroll period
   - **Application**: Payroll processing

4. **Monthly Aggregation**
   - **Source**: YYMM field (derived from c_date)
   - **Aggregation**: Sum hours for calendar month
   - **Application**: Monthly utilization and billing reports

### 3.9 Date and Calendar Business Rules

#### 3.9.1 YYMM Calculation
1. **Formula**
   - **Rule**: YYMM = (DATEPART(yyyy, c_date) * 100 + DATEPART(MONTH, c_date))
   - **Example**: August 2024 → 202408
   - **Format**: Integer (YYYYMM)
   - **Application**: Month-based aggregation and reporting

2. **Source Tables**
   - **Timesheet_New**: Calculated from c_date
   - **New_Monthly_HC_Report**: Stored as YYMM field
   - **DimDate**: Stored as YYYYMM field

#### 3.9.2 Working Days Calculation
1. **Weekend Exclusion**
   - **Rule**: Exclude Saturday and Sunday from working days
   - **Source**: DimDate.DayName
   - **Validation**: DayName NOT IN ('Saturday', 'Sunday')

2. **Holiday Exclusion**
   - **Rule**: Exclude location-specific holidays from working days
   - **Source**: holidays, holidays_India, holidays_Canada, holidays_Mexico tables
   - **Matching**: Holiday_Date = DimDate.Date AND Location matches resource location

3. **Working Days Formula**
   - **Rule**: Working Days = Total Days in Month - Weekends - Holidays
   - **Source**: DimDate.DaysInMonth for total days
   - **Application**: Used in Total Hours calculation

#### 3.9.3 Business Days Calculation
1. **Business Days**
   - **Source**: Bus_days field in New_Monthly_HC_Report
   - **Definition**: Working days available for business operations
   - **Application**: Capacity planning and resource allocation

2. **Expected Hours Calculation**
   - **Rule**: Expected_Hrs = Business Days × 8 (hard coded)
   - **Source**: Expected_Hrs field
   - **Application**: Standard expected hours for planning

3. **Expected Total Hours**
   - **Source**: Expected_Total_Hrs field
   - **Application**: Total expected hours for the period

### 3.10 Special Classification Business Rules

#### 3.10.1 ELT (Executive Leadership Training) Classification
1. **ELT Identification**
   - **Source**: Selected GCI IDs marked as ELT
   - **Provided By**: JayaLaxmi (business stakeholder)
   - **Field**: ELT\Non ELT column
   - **Application**: Identifies resources in leadership development program

2. **ELT Project Assignment**
   - **Projects**: 'ASC-ELT Program-2024', 'CES - ELT\'s Program'
   - **Category**: 'ELT Project'
   - **Status**: 'Bench'
   - **Application**: Tracks ELT program participation

#### 3.10.2 Onsite/Offshore Hours Tracking
1. **Onsite Hours**
   - **Rule**: IF Type = 'OnSite' THEN ActualHours ELSE 0
   - **Application**: Tracks hours worked at client location

2. **Offshore Hours**
   - **Rule**: IF Type = 'Offshore' THEN ActualHours ELSE 0
   - **Application**: Tracks hours worked at offshore location

3. **Total Actual Hours**
   - **Rule**: Total Billed Hours / Actual Hours = Onsite Hours + Offshore Hours
   - **Application**: Reconciles total hours across locations

#### 3.10.3 Rate Change Tracking
1. **Bill Rate Start Date**
   - **Source**: BR_Start_date field
   - **Application**: Tracks when current bill rate became effective

2. **Current Bill Rate**
   - **Source**: Bill_ST field
   - **Application**: Current standard time bill rate

3. **Previous Bill Rate**
   - **Source**: Prev_BR field
   - **Application**: Previous bill rate for comparison

4. **Months in Same Rate**
   - **Source**: Mons_in_Same_Rate field
   - **Application**: Duration at current rate

5. **Rate Time Group**
   - **Source**: Rate_Time_Gr field
   - **Application**: Categorizes rate duration

6. **Rate Change Type**
   - **Source**: Rate_Change_Type field
   - **Application**: Type of rate change (increase, decrease, no change)

#### 3.10.4 Consultant Aging
1. **Consultant Aging**
   - **Source**: Cons_Ageing field
   - **Calculation**: Days since start date
   - **Application**: Tracks tenure of consultant on project

2. **Aging Buckets**
   - **< 90 days**: New consultant
   - **90-180 days**: Established consultant
   - **180-365 days**: Long-term consultant
   - **> 365 days**: Very long-term consultant
   - **Application**: Retention and stability analysis

### 3.11 Reporting and Analytics Business Rules

#### 3.11.1 KPI Definitions
1. **Total Hours**
   - **Definition**: Number of working days × respective location hours (8 or 9)
   - **Application**: Denominator for FTE calculations

2. **Submitted Hours**
   - **Definition**: Timesheet hours submitted by the resource
   - **Application**: Numerator for Total FTE calculation

3. **Approved Hours**
   - **Definition**: Timesheet hours approved by the manager
   - **Application**: Numerator for Billed FTE calculation

4. **Total FTE**
   - **Definition**: Submitted Hours / Total Hours
   - **Application**: Measures resource allocation

5. **Billed FTE**
   - **Definition**: Approved Timesheet Hours / Total Hours (or Submitted Hours if Approved unavailable)
   - **Application**: Measures billable allocation

6. **Project Utilization (Proj UTL)**
   - **Definition**: Billed Hours / Available Hours
   - **Application**: Measures project-level utilization efficiency

7. **Available Hours**
   - **Definition**: Monthly Hours × Total FTE
   - **Application**: Capacity available for billing

8. **Billed Hours**
   - **Definition**: Actual hours billed to client
   - **Application**: Revenue-generating hours

#### 3.11.2 Reporting Dimensions
1. **Time Dimensions**
   - YYMM (Year-Month)
   - Quarter
   - Year
   - Week
   - Date

2. **Resource Dimensions**
   - GCI ID
   - Resource Name
   - Employee Type (FTE/Consultant)
   - Job Title
   - Location
   - Visa Type

3. **Project Dimensions**
   - Client Code
   - Client Name
   - ITSS Project Name
   - Project Type (FP/TM)
   - SOW Indicator

4. **Financial Dimensions**
   - Billing Type (Billable/NBL)
   - Category
   - Status (Billed/Unbilled/SGA)
   - Bill Rate
   - Pay Rate

5. **Organizational Dimensions**
   - Business Unit
   - Circle
   - Community
   - Tower
   - Vertical
   - Portfolio Leader
   - Client Partner

#### 3.11.3 Report Filtering Rules
1. **Active Resources**
   - **Rule**: start date <= report date AND (end date IS NULL OR end date >= report date)
   - **Application**: Filters to currently active resources

2. **Billable Resources**
   - **Rule**: Billing_Type = 'Billable' AND Status = 'Billed'
   - **Application**: Filters to revenue-generating resources

3. **Bench Resources**
   - **Rule**: Status = 'Bench' OR Category IN ('Bench', 'AVA', 'ELT Project')
   - **Application**: Identifies unassigned resources

4. **Location-Based Filtering**
   - **Rule**: Filter by IS_Offshore, project state, project city, Location
   - **Application**: Geographic analysis

5. **Portfolio Filtering**
   - **Rule**: Filter by PortfolioLeader
   - **Note**: Included in base specifically for Power BI dashboard filtering
   - **Application**: Portfolio-level reporting

---

## 4. API COST CALCULATION

**Cost for this particular API Call to LLM model: $0.15**

---

## 5. SUMMARY

This document defines comprehensive Data Expectations, Constraints, and Business Rules for the UTL (Utilization) Reporting Requirements. The specifications ensure:

1. **Data Quality**: Through completeness, accuracy, format, and consistency expectations
2. **Data Integrity**: Through mandatory fields, uniqueness, data types, and referential integrity constraints
3. **Business Alignment**: Through operational rules, transformation logic, and reporting calculations
4. **Compliance**: Through proper categorization, status determination, and audit trail requirements
5. **Analytical Capability**: Through well-defined KPIs, dimensions, and filtering rules

All rules and constraints are derived directly from the source requirements (UTL_Logic.md) and data model (Source_Layer_DDL.sql) to ensure alignment with business needs and technical implementation.

---
**End of Document**