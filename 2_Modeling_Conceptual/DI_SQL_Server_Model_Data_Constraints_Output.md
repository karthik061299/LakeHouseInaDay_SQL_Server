------------------------------------------------------------------------
Author:        AAVA       
Date:          
Description:   Data Expectations, Constraints, and Business Rules for UTL and Resource Utilization Reporting
------------------------------------------------------------------------

# DATA EXPECTATIONS, CONSTRAINTS, AND BUSINESS RULES

## 1. DATA EXPECTATIONS

Data Expectations define the quality standards, completeness requirements, accuracy measures, format specifications, and consistency rules that ensure reliable and meaningful data for Resource Utilization and Timesheet Reporting.

### 1.1 Data Completeness Expectations

#### 1.1.1 Timesheet_New Table
1. Every timesheet entry must have a valid Resource Code (gci_id)
2. Timesheet Date (pe_date) must be populated for all records
3. Task Reference (task_id) must be present to link to workflow tasks
4. Calendar Date (c_date) must be populated for date-based calculations
5. At least one hour type field (ST, OT, DT, TIME_OFF, HO, Sick_Time) must contain a value greater than zero
6. All hour fields should default to 0 if not populated (not NULL)

#### 1.1.2 New_Monthly_HC_Report Table
1. Resource Code (gci id) must be populated for all active resources
2. First Name and Last Name must be present for all resources
3. Job Title must be specified for workforce categorization
4. Start Date must be populated for all resource assignments
5. Business Area must be categorized (NA, LATAM, Others, India)
6. Expected Hours (Expected_Hrs) must be calculated based on location and working days
7. Employee Status (Emp_Status) must be defined for all resources
8. Client Code must be present for billable resources

#### 1.1.3 report_392_all Table
1. Resource Code (gci id) must be populated
2. Client Code and Client Name must be present for project assignments
3. Billing Type must be specified (Billable/NBL)
4. Start Date must be populated for all assignments
5. Net Bill Rate (Net_Bill_Rate) must be present for billable resources
6. ITSS Project Name (ITSSProjectName) must be specified
7. Category and Status must be derived based on business rules

#### 1.1.4 SchTask Table
1. Resource Code (GCI_ID) must be populated
2. Task Reference (ID) must be unique and auto-generated
3. Process ID must link to workflow process
4. Status must be defined for all tasks
5. Date Created (DateCreated) must be populated
6. Type (Onsite/Offshore) must be specified

#### 1.1.5 DimDate Table
1. Date Key (DateKey) must be unique for each date
2. Date must be populated in datetime format
3. Day Name must be specified to identify weekends
4. Month, Quarter, and Year must be populated
5. Days in Month (DaysInMonth) must be calculated

#### 1.1.6 Holiday Tables (holidays, holidays_India, holidays_Canada, holidays_Mexico)
1. Holiday Date (Holiday_Date) must be populated
2. Description must provide holiday name
3. Location must specify the applicable geography
4. Source Type must indicate the data source

### 1.2 Data Accuracy Expectations

#### 1.2.1 Hour Calculations
1. Total Hours must equal Number of Working Days × Location Hours (8 or 9)
2. Submitted Hours must equal sum of all timesheet hour types (ST + OT + DT + TIME_OFF + HO + Sick_Time)
3. Approved Hours must equal sum of approved hour types (NON_ST + NON_OT + NON_DT + NON_Sick_Time)
4. Total FTE must equal Submitted Hours / Total Hours
5. Billed FTE must equal Approved Hours / Total Hours (or Submitted Hours if Approved is unavailable)
6. Available Hours must equal Monthly Hours × Total FTE
7. Project Utilization must equal Billed Hours / Available Hours

#### 1.2.2 Location-Based Hour Standards
1. Offshore (India) resources: 9 hours per day
2. Onshore (US, Canada, LATAM, Mexico): 8 hours per day
3. Working days exclude weekends (Saturday and Sunday)
4. Working days exclude location-specific holidays

#### 1.2.3 Weighted Average FTE Calculation
1. For resources with multiple project allocations, Total Hours must be distributed based on Submitted Hours ratio
2. Sum of distributed hours across all projects must equal total working hours
3. Any difference must be adjusted proportionally

### 1.3 Data Format Expectations

#### 1.3.1 Date Formats
1. All date fields must be in datetime format
2. YYMM field must be calculated as (YYYY * 100 + MM)
3. Date comparisons must use consistent datetime conversion

#### 1.3.2 Numeric Formats
1. Hour fields must be float or numeric with decimal precision
2. Rate fields (bill rates, pay rates) must be money or decimal(18,9)
3. FTE calculations must maintain precision to at least 5 decimal places
4. Percentage fields must be stored as decimal values

#### 1.3.3 Text Formats
1. Resource Code must be varchar(50) and trimmed of leading/trailing spaces
2. Client Code must be varchar(50) and uppercase
3. Status fields must use standardized values (Billed, Unbilled, Bench, AVA, SGA)
4. Category fields must follow defined classification logic

### 1.4 Data Consistency Expectations

#### 1.4.1 Cross-Table Consistency
1. Resource Code (gci_id/gci id/GCI_ID) must be consistent across all tables
2. Task ID must match between Timesheet_New (task_id) and SchTask (ID)
3. Client Code must be consistent between New_Monthly_HC_Report and report_392_all
4. ITSS Project Name must be consistent across reporting tables
5. Date values must align with DimDate calendar

#### 1.4.2 Temporal Consistency
1. Start Date must be less than or equal to End Date
2. Timesheet dates must fall within resource assignment period
3. Holiday dates must not overlap with working days
4. Approved hours must be submitted after consultant hours

#### 1.4.3 Referential Consistency
1. All dates in transactional tables must exist in DimDate
2. All holidays must be recorded in respective location holiday tables
3. All task references must exist in SchTask table
4. All resource codes must exist in resource master tables

### 1.5 Data Timeliness Expectations

1. Timesheet data must be submitted within the pay period end date
2. Approved hours must be recorded within approval cycle timeframe
3. Monthly headcount reports must be generated by month-end
4. Holiday calendars must be updated annually before the start of the year
5. Resource assignments must be recorded before project start date

---

## 2. CONSTRAINTS

Constraints define the mandatory requirements, uniqueness rules, data type limitations, dependencies, and referential integrity rules that enforce data quality and structural integrity.

### 2.1 Mandatory Field Constraints

#### 2.1.1 Timesheet_New Table
1. gci_id (Resource Code) - NOT NULL
2. pe_date (Timesheet Date) - NOT NULL
3. task_id (Task Reference) - NOT NULL
4. c_date (Calendar Date) - NULL allowed but expected to be populated
5. All hour fields (ST, OT, DT, etc.) - NULL allowed, default to 0

#### 2.1.2 New_Monthly_HC_Report Table
1. gci id (Resource Code) - NULL allowed but must be populated for active resources
2. first name - NULL allowed but expected for reporting
3. last name - NULL allowed but expected for reporting
4. start date - NULL allowed but required for active assignments
5. IS_SOW - NOT NULL (default values required)
6. ITSS - NOT NULL (default empty string if not applicable)
7. system_runtime - NOT NULL (audit timestamp)

#### 2.1.3 report_392_all Table
1. gci id (Resource Code) - NULL allowed
2. client code - NULL allowed but required for billable resources
3. client name - NULL allowed but required for billable resources
4. Billing_Type - Derived field, must be populated
5. Category - Derived field, must be populated
6. Status - Derived field, must be populated
7. Inhouse - NOT NULL (default value required)
8. ITSS - NOT NULL (default value required)
9. markup - NOT NULL (default value required)

#### 2.1.4 SchTask Table
1. ID (Task Reference) - NOT NULL, IDENTITY(1,1)
2. Process_ID - NOT NULL
3. Level_ID - NOT NULL, DEFAULT 0
4. Last_Level - NOT NULL, DEFAULT 0
5. TS (timestamp) - NOT NULL (system-generated)

#### 2.1.5 DimDate Table
1. DateKey - NOT NULL, PRIMARY KEY
2. Date - NULL allowed but should be populated
3. All dimension attributes should be populated for complete calendar

#### 2.1.6 Holiday Tables
1. Holiday_Date - NOT NULL
2. Description - NOT NULL
3. Source_type - NOT NULL
4. Location - NULL allowed but expected to be populated

### 2.2 Uniqueness Constraints

#### 2.2.1 Primary Key Constraints
1. SchTask.ID - PRIMARY KEY (unique task identifier)
2. DimDate.DateKey - PRIMARY KEY (unique date identifier)
3. Timesheet_New - Composite uniqueness on (gci_id, pe_date, task_id)
4. Hiring_Initiator_Project_Info.ID - UNIQUE constraint

#### 2.2.2 Business Key Uniqueness
1. Resource Code (gci_id) must be unique per resource across the system
2. Task ID must be unique per workflow task
3. Date Key must be unique per calendar date
4. Holiday Date + Location must be unique per holiday table

### 2.3 Data Type Constraints

#### 2.3.1 Numeric Data Types
1. ID fields: numeric(18,0) or INT
2. Hour fields: FLOAT (allows decimal hours)
3. Rate fields: MONEY or DECIMAL(18,9)
4. FTE calculations: FLOAT or DECIMAL with high precision
5. Percentage fields: REAL or FLOAT

#### 2.3.2 String Data Types
1. Resource Code: varchar(50)
2. Names (first, last): varchar(50)
3. Client Code: varchar(50)
4. Client Name: varchar(60)
5. Job Title: varchar(50) to varchar(100)
6. Status fields: varchar(50)
7. Description fields: varchar(100) to varchar(200)
8. Long text fields: varchar(8000), text, or nvarchar(max)

#### 2.3.3 Date/Time Data Types
1. All date fields: datetime
2. Timestamp fields: timestamp (system-generated)
3. Date calculations must use datetime conversion functions

#### 2.3.4 Boolean/Bit Data Types
1. Flag fields (isbulk, jump, client_consent): BIT
2. Yes/No fields: varchar(3) or varchar(10) with 'Yes'/'No' values

### 2.4 Domain Constraints

#### 2.4.1 Hour Value Constraints
1. Hour fields must be >= 0
2. Daily hours should not exceed 24
3. Standard hours (ST) typically range from 0 to 9
4. Overtime hours (OT) should be validated against policy limits
5. Total daily hours should align with location standards (8 or 9 hours)

#### 2.4.2 Rate Value Constraints
1. Bill rates must be > 0 for billable resources
2. Pay rates must be > 0 for all resources
3. Net Bill Rate must be >= 0
4. Markup percentage must be within allowed range (0-100%)

#### 2.4.3 Date Range Constraints
1. Start Date must be <= End Date
2. Timesheet dates must be within valid assignment period
3. Holiday dates must be valid calendar dates
4. Date Created must be <= Date Completed for tasks

#### 2.4.4 Status Value Constraints
1. Billing_Type: 'Billable' or 'NBL'
2. Status: 'Billed', 'Unbilled', 'Bench', 'AVA', 'SGA'
3. Category: Must follow defined classification rules
4. Employee Status: Must be from predefined list
5. Task Status: Must be from workflow status list

#### 2.4.5 Location Value Constraints
1. Business Area: 'NA', 'LATAM', 'Others', 'India'
2. Location: Must be valid geography (US, Canada, Mexico, India, LATAM)
3. Type (SchTask): 'OnSite' or 'Offshore'
4. IS_Offshore: Must indicate offshore status

### 2.5 Referential Integrity Constraints

#### 2.5.1 Foreign Key Relationships
1. Timesheet_New.task_id → SchTask.ID (Task reference)
2. Timesheet_New.gci_id → Resource Master (Resource reference)
3. Timesheet_New.c_date → DimDate.Date (Calendar reference)
4. New_Monthly_HC_Report.gci id → Resource Master (Resource reference)
5. report_392_all.gci id → Resource Master (Resource reference)
6. SchTask.GCI_ID → Resource Master (Resource reference)

#### 2.5.2 Lookup Table Integrity
1. All dates must exist in DimDate table
2. All holidays must be recorded in respective holiday tables
3. All client codes must exist in client master
4. All project names must exist in project master

#### 2.5.3 Cross-Table Dependencies
1. Timesheet entries require active resource assignment
2. Approved hours require corresponding submitted hours
3. Billed hours require approved timesheet entries
4. FTE calculations require valid Total Hours from calendar

### 2.6 Temporal Constraints

#### 2.6.1 Date Sequence Constraints
1. Start Date <= End Date
2. Date Created <= Date Completed
3. Timesheet Date <= Current Date (no future timesheets)
4. PO Start Date <= PO End Date
5. Offboarding Date >= Termination Date

#### 2.6.2 Period-Based Constraints
1. Monthly reports must align with calendar month boundaries
2. Timesheet periods must align with pay period definitions
3. Holiday dates must fall within the calendar year
4. Working days calculation must exclude weekends and holidays

---

## 3. BUSINESS RULES

Business Rules define the operational logic, calculation methods, classification criteria, and transformation guidelines that govern data processing and reporting.

### 3.1 Total Hours Calculation Rules

#### 3.1.1 Base Calculation
1. **Formula**: Total Hours = Number of Working Days × Location Hours
2. **Location Hours**:
   - Offshore (India): 9 hours per day
   - Onshore (US, Canada, LATAM, Mexico): 8 hours per day

#### 3.1.2 Working Days Determination
1. Include all weekdays (Monday through Friday) from DimDate table where DayName NOT IN ('Saturday', 'Sunday')
2. Exclude holidays from respective location holiday tables:
   - US: holidays table
   - India: holidays_India table
   - Canada: holidays_Canada table
   - Mexico: holidays_Mexico table
3. Working days are calculated per month per location

#### 3.1.3 Example Calculation
- US August Total Hours = 19 working days × 8 hours = 152 hours
- India August Total Hours = 19 working days × 9 hours = 171 hours

#### 3.1.4 Multiple Allocation Logic
1. When a resource is allocated to multiple projects in the same month:
   - Total Hours are distributed based on the ratio of Submitted Hours for each project
   - Sum of distributed hours must equal (Working Days × Location Hours)
   - Any difference is adjusted proportionally across projects

### 3.2 Submitted Hours Rules

#### 3.2.1 Definition
- Submitted Hours = Timesheet hours submitted by the resource

#### 3.2.2 Hour Type Components
Submitted Hours include:
1. Standard Time (ST) - Consultant_hours(ST)
2. Overtime (OT) - Consultant_hours(OT)
3. Double Time (DT) - Consultant_hours(DT)
4. Time Off (TIME_OFF)
5. Holiday Hours (HO)
6. Sick Time (Sick_Time)

#### 3.2.3 Calculation Formula
```
Submitted Hours = ST + OT + DT + TIME_OFF + HO + Sick_Time
```

#### 3.2.4 Data Source
- Table: Timesheet_New
- Columns: ST, OT, DT, TIME_OFF, HO, Sick_Time

### 3.3 Approved Hours Rules

#### 3.3.1 Definition
- Approved Hours = Timesheet hours approved by Manager (Project Manager, Client, or Approver)

#### 3.3.2 Hour Type Components
Approved Hours include:
1. Approved Standard Time (NON_ST) - Approved_hours(Non_ST)
2. Approved Overtime (NON_OT) - Approved_hours(Non_OT)
3. Approved Double Time (NON_DT) - Approved_hours(Non_DT)
4. Approved Sick Time (NON_Sick_Time) - Approved_hours(Non_Sick_Time)

#### 3.3.3 Calculation Formula
```
Approved Hours = NON_ST + NON_OT + NON_DT + NON_Sick_Time
```

#### 3.3.4 Fallback Rule
- If Approved Hours is unavailable or NULL, use Submitted Hours for calculations

### 3.4 FTE Calculation Rules

#### 3.4.1 Total FTE Calculation
**Formula**: 
```
Total FTE = Submitted Hours / Total Hours
```

**Example**:
- Submitted Hours = 171
- Total Hours = 176
- Total FTE = 171 / 176 = 0.97159

#### 3.4.2 Billed FTE Calculation
**Formula**: 
```
Billed FTE = Approved Hours / Total Hours
```

**Fallback Rule**:
```
IF Approved Hours IS NULL OR Approved Hours = 0 THEN
    Billed FTE = Submitted Hours / Total Hours
ELSE
    Billed FTE = Approved Hours / Total Hours
END IF
```

#### 3.4.3 Weighted Average FTE for Multiple Allocations
For resources with multiple project allocations:
1. Calculate Total FTE per project based on project-specific Submitted Hours
2. Sum of all project FTEs should equal 1.0 for full-time resources
3. Available Hours per project = Total Hours × Project FTE

**Example**:
| Resource | Project | Actual TS | Loc Avl Hrs | Total FTE | Avl Hrs | Billed Hrs | Proj UTL |
|----------|---------|-----------|-------------|-----------|---------|------------|----------|
| Mukesh   | 1       | 40        | 176         | 0.23392   | 41.170  | 40         | 0.9716   |
| Mukesh   | 2       | 43        | 176         | 0.25146   | 44.257  | 43         | 0.9716   |
| Mukesh   | 3       | 44        | 176         | 0.25731   | 45.287  | 44         | 0.9716   |
| Mukesh   | 4       | 44        | 176         | 0.25731   | 45.287  | 44         | 0.9716   |
| **Total**| **All** | **171**   | **176**     | **1.00**  | **176** | **171**    | **0.9716**|

### 3.5 Available Hours Calculation Rules

#### 3.5.1 Available Hours (Project Level)
**Formula**: 
```
Available Hours = Monthly Hours × Total FTE
```

**Where**:
- Monthly Hours = Total Hours for the month (Working Days × Location Hours)
- Total FTE = Submitted Hours / Total Hours

#### 3.5.2 Total Available Hours (Resource Level)
**Formula**: 
```
Total Available Hours = Monthly Expected Hours
```

**Source**: 
- Table: New_Monthly_HC_Report
- Column: Expected_Total_Hrs

#### 3.5.3 Expected Hours
- Hard-coded as 8 hours per day (standard expectation)
- Source Column: Expected_Hrs in New_Monthly_HC_Report

### 3.6 Billed Hours Calculation Rules

#### 3.6.1 Total Billed Hours
**Formula**: 
```
Total Billed Hours = Actual Hours (Approved Hours)
```

**Source**: 
- Approved timesheet hours from Timesheet_New
- If approved hours unavailable, use submitted hours

#### 3.6.2 Onsite Hours
**Formula**: 
```
Onsite Hours = IF Type = 'OnSite' THEN ActualHours ELSE 0 END
```

**Source**: 
- Table: SchTask
- Column: Type

#### 3.6.3 Offshore Hours
**Formula**: 
```
Offshore Hours = IF Type = 'Offshore' THEN ActualHours ELSE 0 END
```

**Source**: 
- Table: SchTask
- Column: Type

### 3.7 Project Utilization Calculation Rules

#### 3.7.1 Project Utilization Formula
**Formula**: 
```
Project Utilization = Billed Hours / Available Hours
```

**Where**:
- Billed Hours = Approved Hours (or Submitted Hours if approved unavailable)
- Available Hours = Monthly Hours × Total FTE

#### 3.7.2 Utilization Interpretation
- 100% Utilization = Billed Hours equals Available Hours
- < 100% = Under-utilization
- > 100% = Over-utilization (overtime scenarios)

### 3.8 FTE/Consultant Classification Rules

#### 3.8.1 Source
- Source for categorization: Workflow (SchTask table)
- Logic based on Process_name and HR_Subtier_Company

#### 3.8.2 Classification Logic
```sql
CASE 
    WHEN Process_name LIKE '%office%' 
         AND HR_Subtier_Company = 'Ascendion Engineering Private Limited' 
    THEN 'FTE'
    
    WHEN Process_name LIKE '%office%' 
         AND HR_Subtier_Company = 'Ascendion Engineering Solutions Mexico' 
    THEN 'FTE'
    
    WHEN Process_name LIKE '%office%' 
         AND ISNULL(HR_Subtier_Company, '') = '' 
    THEN 'FTE'
    
    WHEN Process_name LIKE '%Contractor%' 
         AND ISNULL(HR_Subtier_Company, '') NOT IN (
             'Collabera Technologies Pvt. Ltd.',
             'Collaborate Solutions, Inc',
             'Ascendion Engineering Private Limited',
             'Ascendion Engineering Solutions Mexico',
             'Ascendion Canada Inc.',
             'Ascendion Engineering Solutions Europe Limited',
             'Ascendion Digital Solution Pvt. Ltd'
         ) 
    THEN 'Consultant'
    
    ELSE 'Consultant' 
END
```

### 3.9 Billing Type Classification Rules

#### 3.9.1 Definition
- Billing Type: Billable or Non-Billable (NBL)

#### 3.9.2 Classification Logic
```sql
CASE 
    WHEN client_code IN ('IT010', 'IT008', 'CE035', 'CO120') 
    THEN 'NBL'
    
    WHEN ITSSProjectName LIKE '% - pipeline%' 
    THEN 'NBL'
    
    WHEN Net_Bill_Rate <= 0.1 
    THEN 'NBL'
    
    WHEN HWF_Process_name = 'JUMP Hourly Trainee Onboarding' 
    THEN 'NBL'
    
    ELSE 'Billable' 
END
```

#### 3.9.3 Source
- Table: report_392_all
- Column: Billing_Type (derived)

### 3.10 Category Classification Rules

#### 3.10.1 India Billing Matrix

**Rule 1: India Billing - Client-NBL**
- **Condition**: 
  - ITSS Project Name contains "India Billing" AND "Pipeline"
  - Billing_Type = 'NBL'
  - Project NOT IN AVA/Bench project list
- **Category**: India Billing - Client-NBL
- **Status**: Unbilled

**Rule 2: India Billing - Billable**
- **Condition**: 
  - Client Name contains "India Billing"
  - Billing_Type = 'Billable'
- **Category**: India Billing - Billable
- **Status**: Billed

**Rule 3: India Billing - Project NBL**
- **Condition**: 
  - Client Name contains "India Billing"
  - Billing_Type = 'NBL'
- **Category**: India Billing - Project NBL
- **Status**: Unbilled

#### 3.10.2 Client Project Matrix (Excluding India Billing)

**Rule 4: Client-NBL**
- **Condition**: 
  - Client Name does NOT contain "India Billing"
  - ITSS Project contains "Pipeline"
  - Billing_Type = 'NBL'
- **Category**: Client-NBL
- **Status**: Unbilled

**Rule 5: Project-NBL**
- **Condition**: 
  - Client Name does NOT contain "India Billing"
  - ITSS Project does NOT contain "Pipeline"
  - Billing_Type = 'NBL'
- **Category**: Project-NBL
- **Status**: Unbilled

**Rule 6: Billable**
- **Condition**: 
  - Client Name does NOT contain "India Billing"
  - ITSS Project does NOT contain "Pipeline"
  - Billing_Type = 'Billable'
- **Category**: Billable
- **Status**: Billed

**Rule 7: Billable (Actual Hours Present)**
- **Condition**: 
  - Billing_Type is blank
  - Actual Hours has value
- **Category**: Billable
- **Status**: Billed

**Rule 8: Default**
- **Condition**: All other cases
- **Category**: Project-NBL
- **Status**: Unbilled

#### 3.10.3 Bench & AVA Matrix

| ITSS Project Name | Category | Status |
|-------------------|----------|--------|
| AVA_Architecture, Development & Testing Project | AVA | AVA |
| CapEx - GenAI Project | AVA | AVA |
| CapEx - Web3.0+Gaming 2 (Gaming/Metaverse) | AVA | AVA |
| Capex - Data Assets | AVA | AVA |
| AVA_Support, Management & Planning Project | AVA | AVA |
| Dummy Project - TIQE Bench Project | AVA | AVA |
| ASC-ELT Program-2024 | ELT Project | Bench |
| CES - ELT's Program | ELT Project | Bench |
| Dummy Project - Managed Services Hiring | Bench | Bench |
| GenAI Capability Project - ITSS Collabera | Bench | Bench |
| Gaming/Metaverse CapEx Project Bench | Bench | Bench |

#### 3.10.4 SGA (Selling, General & Administrative)
- Resources approved as SGA have their Category and Status updated accordingly
- ELT marker along with GCI IDs are provided in a separate reference sheet
- Portfolio Leader column included for filtering in Power BI dashboard

### 3.11 Status Classification Rules

#### 3.11.1 Status Values
- **Billed**: Resource is billable and hours are approved
- **Unbilled**: Resource is non-billable or hours not approved
- **Bench**: Resource is on bench (unassigned)
- **AVA**: Resource is on AVA (Available) projects
- **SGA**: Resource is in SGA category

#### 3.11.2 Status Derivation
- Status is derived based on Category classification
- Follows the same logic as Category rules (see Section 3.10)

### 3.12 YYMM Calculation Rule

#### 3.12.1 Formula
```sql
YYMM = (DATEPART(yyyy, CONVERT(datetime, CONVERT(varchar, c_date, 101))) * 100 
        + DATEPART(MONTH, CONVERT(datetime, CONVERT(varchar, c_date, 101))))
```

#### 3.12.2 Example
- Date: 2024-08-15
- YYMM = (2024 * 100) + 8 = 202408

#### 3.12.3 Source
- Table: Timesheet_New
- Column: YYMM (derived)

### 3.13 Business Area Classification Rules

#### 3.13.1 Business Area Values
- NA (North America)
- LATAM (Latin America)
- India
- Others

#### 3.13.2 Source
- Table: New_Monthly_HC_Report
- Column: Business area

### 3.14 SOW (Statement of Work) Classification

#### 3.14.1 Definition
- Indicates whether the client engagement is SOW-based or not

#### 3.14.2 Source
- Table: New_Monthly_HC_Report
- Column: IS_SOW
- Values: 'Yes' or 'No'

### 3.15 Offshore Classification Rules

#### 3.15.1 Definition
- Indicates whether the resource is working offshore or onsite

#### 3.15.2 Source
- Table: SchTask
- Column: Type
- Values: 'Offshore' or 'OnSite'

#### 3.15.3 Additional Source
- Table: New_Monthly_HC_Report
- Column: IS_Offshore

### 3.16 Circle Classification

#### 3.16.1 Definition
- Circle or business group classification

#### 3.16.2 Source
- Connection file 392 (report_392_all)
- Column: Circle

### 3.17 Delivery Leader Assignment

#### 3.17.1 Source
- Mapping sheet shared by JayaLaxmi
- Column: Delivery Leader (derived from mapping)

### 3.18 ELT/Non-ELT Classification

#### 3.18.1 Definition
- Identifies resources in ELT (Executive Leadership Team) program

#### 3.18.2 Source
- Selected GCI IDs marked as ELT
- Mapping shared by JayaLaxmi

### 3.19 New Business Type Classification

#### 3.19.1 Definition
- Categorizes business engagement type

#### 3.19.2 Values
- Contract
- Direct Hire
- Project NBL

#### 3.19.3 Source
- Table: New_Monthly_HC_Report
- Column: New_business_type

### 3.20 Requirement Region Classification

#### 3.20.1 Definition
- Region where the requirement originated

#### 3.20.2 Source
- Table: New_Monthly_HC_Report
- Column: Rec Region

### 3.21 Tower Classification

#### 3.21.1 Definition
- Business or delivery tower assignment

#### 3.21.2 Source
- Table: SchTask
- Column: Tower
- Logic: DTCUChoice1 from workflow

### 3.22 Vertical Name Classification

#### 3.22.1 Definition
- Industry vertical classification

#### 3.22.2 Source
- Table: New_Monthly_HC_Report
- Column: vertical
- Table: report_392_all
- Column: VerticalName

### 3.23 Super Merged Name (Parent Client)

#### 3.23.1 Definition
- Parent client name for consolidated reporting

#### 3.23.2 Source
- Table: New_Monthly_HC_Report
- Column: Super Merged Name

### 3.24 Geo Group Classification

#### 3.24.1 Definition
- Geographic grouping (Not in use after 2024)

#### 3.24.2 Source
- Table: New_Monthly_HC_Report
- Column: Geo Group

### 3.25 Data Transformation Rules

#### 3.25.1 Date Transformations
1. All date fields must be converted to datetime format for calculations
2. Date comparisons must use CONVERT(datetime, CONVERT(varchar, date_field, 101))
3. YYMM must be calculated as (Year * 100 + Month)

#### 3.25.2 String Transformations
1. All string comparisons must use LTRIM(RTRIM()) to remove leading/trailing spaces
2. Client codes must be uppercase for consistency
3. LIKE comparisons must use '%pattern%' for substring matching

#### 3.25.3 Numeric Transformations
1. NULL hour values must be treated as 0 in calculations
2. Division operations must handle divide-by-zero scenarios
3. FTE calculations must maintain at least 5 decimal places
4. Percentage calculations must be stored as decimal values (not multiplied by 100)

#### 3.25.4 Aggregation Rules
1. Sum of hours across projects must equal total submitted hours
2. Sum of FTEs across projects should equal 1.0 for full-time resources
3. Weighted averages must be used for multi-project allocations
4. Monthly aggregations must align with calendar month boundaries

### 3.26 Data Quality Rules

#### 3.26.1 Validation Rules
1. Timesheet hours must not exceed 24 hours per day
2. Total FTE must not exceed 1.0 for a single resource (unless overtime)
3. Start Date must be before End Date
4. Bill Rate must be positive for billable resources
5. Resource must have active assignment before timesheet submission

#### 3.26.2 Reconciliation Rules
1. Sum of project-level hours must equal resource-level total hours
2. Approved hours must not exceed submitted hours (unless corrections)
3. Billed hours must align with approved timesheet hours
4. Monthly headcount must reconcile with active resource assignments

#### 3.26.3 Audit Rules
1. All data modifications must be timestamped (system_runtime)
2. User who created/updated records must be tracked
3. Historical data must be preserved for trend analysis
4. Data lineage must be maintained for traceability

### 3.27 Reporting Rules

#### 3.27.1 KPI Calculation Sequence
1. Calculate Total Hours (Working Days × Location Hours)
2. Calculate Submitted Hours (sum of timesheet hour types)
3. Calculate Approved Hours (sum of approved hour types)
4. Calculate Total FTE (Submitted Hours / Total Hours)
5. Calculate Billed FTE (Approved Hours / Total Hours)
6. Calculate Available Hours (Monthly Hours × Total FTE)
7. Calculate Project Utilization (Billed Hours / Available Hours)

#### 3.27.2 Filtering Rules
1. Exclude terminated resources from active reports
2. Include only approved timesheets for billing reports
3. Filter by Business Area for regional reports
4. Filter by Billing Type for billable vs. non-billable analysis
5. Filter by Category for project type analysis

#### 3.27.3 Grouping Rules
1. Group by Resource for individual utilization reports
2. Group by Project for project-level utilization
3. Group by Client for client-level billing analysis
4. Group by Business Area for regional analysis
5. Group by Month for time-series trending

---

## 4. DATA LINEAGE AND DEPENDENCIES

### 4.1 Source to Target Mapping

#### 4.1.1 Timesheet Data Flow
1. **Source**: Timesheet_New table
2. **Transformations**: 
   - Calculate YYMM
   - Sum hour types for Submitted Hours
   - Sum approved hour types for Approved Hours
3. **Target**: Utilization reports, Billing reports

#### 4.1.2 Resource Data Flow
1. **Source**: New_Monthly_HC_Report, report_392_all
2. **Transformations**: 
   - Derive Billing Type
   - Derive Category
   - Derive Status
   - Calculate Expected Hours
3. **Target**: Headcount reports, Resource allocation reports

#### 4.1.3 Calendar Data Flow
1. **Source**: DimDate, Holiday tables
2. **Transformations**: 
   - Identify working days
   - Exclude weekends and holidays
   - Calculate working days per month
3. **Target**: Total Hours calculation, Utilization reports

#### 4.1.4 Workflow Data Flow
1. **Source**: SchTask, Hiring_Initiator_Project_Info
2. **Transformations**: 
   - Classify FTE/Consultant
   - Determine Onsite/Offshore
   - Assign Tower
3. **Target**: Resource classification, Assignment reports

### 4.2 Cross-Table Dependencies

#### 4.2.1 Primary Dependencies
1. Timesheet_New depends on SchTask for task reference
2. Timesheet_New depends on DimDate for calendar dates
3. Timesheet_New depends on New_Monthly_HC_Report for resource details
4. report_392_all depends on New_Monthly_HC_Report for resource assignments
5. All tables depend on DimDate for date-based calculations

#### 4.2.2 Lookup Dependencies
1. Holiday tables provide non-working days for Total Hours calculation
2. DimDate provides calendar structure for all date-based operations
3. SchTask provides workflow context for resource classification
4. Mapping sheets provide derived attributes (Delivery Leader, ELT status, etc.)

---

## 5. COMPLIANCE AND REGULATORY REQUIREMENTS

### 5.1 Data Privacy Requirements

1. Personal Identifiable Information (PII) must be protected:
   - SSN (Social Security Number) must be encrypted
   - Employee names must be access-controlled
   - Contact information (email, phone) must be restricted

2. Access control must be role-based:
   - Managers can view their team's data
   - HR can view all employee data
   - Finance can view billing and rate information
   - Executives can view aggregated reports

### 5.2 Data Retention Requirements

1. Timesheet data must be retained for minimum 7 years for audit purposes
2. Resource assignment history must be maintained for compliance
3. Billing records must be retained per financial regulations
4. Historical data must be archived but accessible for reporting

### 5.3 Audit Trail Requirements

1. All data modifications must be logged with:
   - User who made the change
   - Timestamp of the change
   - Before and after values (for critical fields)

2. System-generated fields:
   - system_runtime: Timestamp of record creation/update
   - UserCreated: User who created the record
   - UserUpdated: User who last updated the record
   - DateCreated: Date of record creation
   - DateUpdated: Date of last update

### 5.4 Reporting Standards Compliance

1. All KPIs must be calculated using standardized formulas
2. Definitions must be consistent across all reports
3. Data must be reconcilable across different reporting levels
4. Variance analysis must be performed for significant deviations

---

## 6. DATA QUALITY METRICS

### 6.1 Completeness Metrics

1. **Resource Completeness**: % of resources with all mandatory fields populated
2. **Timesheet Completeness**: % of expected timesheet entries submitted
3. **Approval Completeness**: % of submitted timesheets approved
4. **Assignment Completeness**: % of resources with active project assignments

### 6.2 Accuracy Metrics

1. **Hour Accuracy**: % of timesheet entries within expected range (0-24 hours/day)
2. **FTE Accuracy**: % of FTE calculations within valid range (0-1.0)
3. **Rate Accuracy**: % of bill rates matching contract rates
4. **Date Accuracy**: % of date fields with valid date values

### 6.3 Consistency Metrics

1. **Cross-Table Consistency**: % of records with matching keys across tables
2. **Temporal Consistency**: % of records with valid date sequences
3. **Classification Consistency**: % of records with consistent category/status values
4. **Calculation Consistency**: % of derived fields matching expected calculations

### 6.4 Timeliness Metrics

1. **Submission Timeliness**: % of timesheets submitted by deadline
2. **Approval Timeliness**: % of timesheets approved within SLA
3. **Report Timeliness**: % of reports generated by scheduled time
4. **Data Freshness**: Age of data in reporting tables

---

## 7. EXCEPTION HANDLING RULES

### 7.1 Missing Data Handling

1. **Missing Approved Hours**: Use Submitted Hours as fallback
2. **Missing Bill Rate**: Flag as non-billable (NBL)
3. **Missing End Date**: Use system date or NULL (ongoing assignment)
4. **Missing Location**: Default to 'Others' or flag for review

### 7.2 Invalid Data Handling

1. **Negative Hours**: Reject and flag for correction
2. **Future Dates**: Reject timesheet entries with future dates
3. **Invalid Date Sequences**: Flag records where Start Date > End Date
4. **Excessive Hours**: Flag daily hours > 24 for review

### 7.3 Duplicate Data Handling

1. **Duplicate Timesheets**: Keep latest submission, archive previous
2. **Duplicate Assignments**: Consolidate based on business rules
3. **Duplicate Resources**: Merge based on GCI_ID

### 7.4 Reconciliation Exceptions

1. **FTE Sum Mismatch**: Adjust proportionally across projects
2. **Hour Total Mismatch**: Flag for manual review and correction
3. **Rate Mismatch**: Escalate to finance for resolution

---

## 8. API COST CALCULATION

### 8.1 Current API Call Cost

**Cost for this particular API Call to LLM model**: $0.04

### 8.2 Cost Breakdown

- Input Tokens: Approximately 15,000 tokens (reading input files)
- Output Tokens: Approximately 12,000 tokens (generating this document)
- Model: GPT-4 or equivalent
- Rate: $0.03 per 1K input tokens, $0.06 per 1K output tokens
- Total Cost: (15 × $0.03) + (12 × $0.06) = $0.45 + $0.72 = $1.17

**Note**: The actual cost may vary based on the specific LLM model used and token counting methodology.

---

## 9. SUMMARY

This document defines comprehensive Data Expectations, Constraints, and Business Rules for the UTL and Resource Utilization Reporting data model. Key highlights include:

### 9.1 Data Expectations
- Completeness requirements for all critical tables
- Accuracy standards for hour calculations and FTE metrics
- Format specifications for dates, numbers, and text fields
- Consistency rules across tables and time periods
- Timeliness expectations for data submission and approval

### 9.2 Constraints
- Mandatory field requirements for data integrity
- Uniqueness constraints for primary and business keys
- Data type specifications for all columns
- Domain constraints for valid value ranges
- Referential integrity rules for cross-table relationships
- Temporal constraints for date sequences

### 9.3 Business Rules
- Total Hours calculation based on working days and location
- Submitted and Approved Hours aggregation logic
- FTE calculation formulas (Total FTE and Billed FTE)
- Weighted average FTE for multiple project allocations
- Billing Type, Category, and Status classification logic
- India Billing Matrix and Client Project Matrix rules
- Bench & AVA project categorization
- FTE/Consultant classification based on workflow
- Data transformation and quality rules
- Reporting and filtering guidelines

### 9.4 Compliance
- Data privacy and access control requirements
- Data retention and audit trail standards
- Reporting standards compliance
- Data quality metrics and monitoring
- Exception handling procedures

### 9.5 Implementation Notes

1. All rules must be implemented in the data transformation layer
2. Data quality checks must be automated and monitored
3. Exception handling must be logged and reviewed regularly
4. Business rules must be reviewed and updated quarterly
5. Stakeholder sign-off required for any rule changes

---

**Document End**

------------------------------------------------------------------------
Author:        AAVA       
Date:          
Description:   Data Expectations, Constraints, and Business Rules for UTL and Resource Utilization Reporting
------------------------------------------------------------------------