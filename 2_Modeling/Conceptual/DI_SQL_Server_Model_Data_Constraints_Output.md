------------------------------------------------------------------------
Author:        AAVA       
Date:          
Description:   Data Expectations, Constraints, and Business Rules for UTL Reporting Requirements
------------------------------------------------------------------------

# DATA EXPECTATIONS, CONSTRAINTS, AND BUSINESS RULES

## 1. DATA EXPECTATIONS

Data expectations define the quality standards, completeness requirements, format specifications, and consistency rules that ensure reliable and accurate reporting.

### 1.1 Data Completeness Expectations

1. **Resource Identification**
   - Every resource must have a valid gci_id (GCI ID) populated
   - First name and last name must be present for all active resources
   - Employee type classification (FTE/Consultant) must be defined for all resources

2. **Timesheet Data Completeness**
   - Timesheet entries must have valid gci_id, pe_date (period end date), task_id, and c_date (calendar date)
   - At least one hour type field must be populated (ST, OT, DT, TIME_OFF, HO, Sick_Time)
   - Submitted hours and approved hours must be tracked for billing calculations

3. **Project Assignment Completeness**
   - All active assignments must have client code, client name, and project details
   - Start date is mandatory for all assignments
   - End date must be populated for terminated or completed assignments
   - ITSSProjectName must be present for project categorization

4. **Date Dimension Completeness**
   - DimDate table must contain continuous date records covering all reporting periods
   - All date attributes (DayOfMonth, DayName, WeekOfYear, Month, MonthName, Quarter, Year) must be populated
   - YYYYMM format must be available for monthly aggregations

5. **Holiday Data Completeness**
   - Holiday tables (holidays, holidays_India, holidays_Canada, holidays_Mexico) must contain all applicable holidays for each location
   - Holiday_Date and Description must be populated for all holiday records
   - Location identifier must be present to map holidays to resource locations

### 1.2 Data Accuracy Expectations

1. **Rate and Financial Data Accuracy**
   - Bill rates (bill st) must be numeric and greater than or equal to zero
   - Pay rates (pay st) must be numeric and less than or equal to bill rates
   - Net Bill Rate (NBR) calculations must be accurate and consistent
   - Gross Profit (GP) and Gross Profit Margin (GPM) must be calculated correctly

2. **Hours Calculation Accuracy**
   - Total Hours = Number of Working Days × Hours per Day (9 for offshore India, 8 for onshore US/Canada/LATAM)
   - Working days must exclude weekends (Saturday and Sunday) and location-specific holidays
   - Submitted Hours must equal the sum of all timesheet hour types submitted by resource
   - Approved Hours must equal the sum of all approved hour types (Non_ST, Non_OT, Non_DT, Non_Sick_Time)

3. **FTE Calculation Accuracy**
   - Total FTE = Submitted Hours / Total Hours
   - Billed FTE = Approved Hours / Total Hours (if Approved Hours unavailable, use Submitted Hours)
   - Project Utilization = Billed Hours / Available Hours
   - Available Hours = Monthly Hours × Total FTE

4. **Date Accuracy**
   - All date fields must contain valid datetime values
   - Start date must be less than or equal to end date
   - Period end date (pe_date) must align with calendar date (c_date) in timesheet entries
   - YYMM calculation must accurately reflect year and month: (DATEPART(yyyy, c_date) * 100 + DATEPART(MONTH, c_date))

### 1.3 Data Format Expectations

1. **Identifier Formats**
   - gci_id: Alphanumeric, maximum 50 characters
   - client code: Alphanumeric, maximum 50 characters
   - task_id: Numeric (18,9)
   - Process_ID: Numeric (18,0)

2. **Name Formats**
   - first name: Varchar(50)
   - last name: Varchar(50)
   - client name: Varchar(60)
   - ITSSProjectName: Varchar(200)

3. **Date Formats**
   - All date fields: Datetime format
   - YYMM: Integer format (YYYYMM)
   - MM-YYYY: Varchar(10) format
   - YYYYMM: Varchar(10) format

4. **Numeric Formats**
   - Hour fields (ST, OT, DT, etc.): Float
   - Rate fields (bill st, pay st, NBR): Money or Float
   - Percentage fields (Total FTE, Billed FTE): Decimal with precision

5. **Text Formats**
   - Status fields: Varchar with predefined values (Billed, Unbilled, SGA, Bench, AVA)
   - Category fields: Varchar with predefined values based on business logic
   - Location fields: Varchar(50)

### 1.4 Data Consistency Expectations

1. **Cross-Table Consistency**
   - gci_id must be consistent across Timesheet_New, report_392_all, New_Monthly_HC_Report, and SchTask tables
   - task_id in Timesheet_New must match ID in SchTask table
   - c_date in Timesheet_New must exist in DimDate.Date
   - Location identifiers must match between resource tables and holiday tables

2. **Temporal Consistency**
   - Resource assignment periods must not overlap for the same resource unless multiple allocations are intended
   - Timesheet dates must fall within the assignment start date and end date range
   - Holiday dates must align with calendar dates in DimDate

3. **Business Logic Consistency**
   - Employee type classification must be consistent with workflow process names
   - Billing Type (Billable/NBL) must be consistent with client code, project name, and Net Bill Rate
   - Category and Status must be derived consistently based on defined business rules
   - IS_SOW and IS_Offshore flags must be consistent across related tables

4. **Hierarchical Consistency**
   - Super Merged Name (parent client) must be consistent with client name
   - Circle and Community assignments must be consistent with organizational structure
   - Portfolio Leader, Client Partner, and Sales Rep assignments must be consistent

---

## 2. CONSTRAINTS

Constraints define the mandatory requirements, uniqueness rules, data type limitations, dependencies, and referential integrity rules that govern the data model.

### 2.1 Mandatory Field Constraints (NOT NULL)

#### 2.1.1 DimDate Table
1. DateKey (Primary Key) - NOT NULL
2. Date - Required for all date dimension records

#### 2.1.2 Timesheet_New Table
1. gci_id - NOT NULL (Resource identifier)
2. pe_date - NOT NULL (Period end date)
3. task_id - NOT NULL (Task/Workflow identifier)

#### 2.1.3 report_392_all Table
1. gci id - Required for resource identification
2. client code - Required for client association
3. start date - Required for assignment tracking

#### 2.1.4 New_Monthly_HC_Report Table
1. gci id - Required for resource identification
2. YYMM - Required for monthly reporting
3. IS_SOW - NOT NULL (Default: 'Yes' or 'No')

#### 2.1.5 SchTask Table
1. ID - NOT NULL, IDENTITY(1,1) (Primary Key)
2. Process_ID - NOT NULL (Workflow process identifier)
3. Level_ID - NOT NULL, DEFAULT 0
4. Last_Level - NOT NULL, DEFAULT 0
5. TS (Timestamp) - NOT NULL

#### 2.1.6 Holiday Tables (holidays, holidays_India, holidays_Canada, holidays_Mexico)
1. Holiday_Date - NOT NULL
2. Description - NOT NULL
3. Source_type - NOT NULL

### 2.2 Uniqueness Constraints

1. **Primary Key Constraints**
   - DimDate.DateKey - Unique identifier for each date
   - SchTask.ID - Unique identifier for each workflow task

2. **Composite Uniqueness**
   - Timesheet_New: Combination of (gci_id, pe_date, task_id, c_date) should be unique
   - Holiday tables: Combination of (Holiday_Date, Location) should be unique

3. **Business Key Uniqueness**
   - gci_id should be unique per resource across all active assignments
   - client code should be unique per client

### 2.3 Data Type Constraints

#### 2.3.1 Numeric Type Constraints
1. **Integer Fields**
   - gci_id in Timesheet_New: INT
   - YYMM: INT (format YYYYMM)
   - DateKey: INT

2. **Decimal/Numeric Fields**
   - task_id: NUMERIC(18,9)
   - Process_ID: NUMERIC(18,0)
   - ID in report_392_all: NUMERIC(18,9)

3. **Float Fields**
   - All hour fields (ST, OT, DT, TIME_OFF, HO, Sick_Time, etc.): FLOAT
   - Expected_Hrs: FLOAT/REAL
   - Bus_days: REAL

4. **Money Fields**
   - salary: MONEY
   - NBR (Net Bill Rate): MONEY
   - GP (Gross Profit): MONEY
   - Net_Bill_Rate: MONEY

#### 2.3.2 String Type Constraints
1. **VARCHAR(50) Fields**
   - gci id, first name, last name, job title, client code, salesrep, recruiter, etc.

2. **VARCHAR(100) Fields**
   - ITSSProjectName (up to VARCHAR(200))
   - HWF_Process_name
   - Merged Name, Super Merged Name

3. **VARCHAR(10) Fields**
   - Location
   - MM-YYYY, YYYYMM

#### 2.3.3 Date/Time Type Constraints
1. All date fields: DATETIME
2. Timestamp field (TS in SchTask): TIMESTAMP

### 2.4 Value Range Constraints

1. **Rate Constraints**
   - Bill rates must be >= 0
   - Pay rates must be >= 0 and <= Bill rates
   - Net Bill Rate > 0.1 indicates Billable (otherwise NBL)

2. **Hour Constraints**
   - All hour fields must be >= 0
   - Daily hours should not exceed 24
   - Expected hours per day: 8 (onshore) or 9 (offshore)

3. **Percentage Constraints**
   - Total FTE should be between 0 and 1 (or 0% to 100%)
   - Billed FTE should be between 0 and 1
   - Markup percentages should be within defined limits

4. **Date Range Constraints**
   - Start date <= End date
   - c_date should be within the assignment period (start date to end date)
   - pe_date should be >= c_date

### 2.5 Referential Integrity Constraints

1. **Foreign Key Relationships**
   - Timesheet_New.task_id → SchTask.ID
   - Timesheet_New.gci_id → report_392_all.[gci id]
   - Timesheet_New.c_date → DimDate.Date
   - report_392_all.[gci id] → New_Monthly_HC_Report.[gci id]
   - New_Monthly_HC_Report.YYMM → DimDate.YYYYMM

2. **Location-Based Relationships**
   - report_392_all.location → Holidays.Location (for US)
   - report_392_all.location → holidays_India.Location (for India)
   - report_392_all.location → holidays_Canada.Location (for Canada)
   - report_392_all.location → holidays_Mexico.Location (for Mexico)
   - New_Monthly_HC_Report.market → Holidays.Location

3. **Lookup Integrity**
   - client code must exist in a valid client master
   - ITSSProjectName must exist in a valid project master
   - Process_ID must exist in a valid workflow process master

### 2.6 Dependency Constraints

1. **Conditional Dependencies**
   - If Billing_Type = 'Billable', then bill st must be > 0
   - If Status = 'Billed', then Approved Hours or Submitted Hours must be > 0
   - If employee type = 'Consultant', then hr_business_type should indicate contract type
   - If IS_Offshore = 'Offshore', then Expected_Hrs per day = 9; else = 8

2. **Calculation Dependencies**
   - Total FTE depends on Submitted Hours and Total Hours
   - Billed FTE depends on Approved Hours (or Submitted Hours if unavailable) and Total Hours
   - Available Hours depends on Monthly Hours and Total FTE
   - Total Hours depends on Number of Working Days and Hours per Day (location-based)

3. **Workflow Dependencies**
   - SchTask.Status must progress through defined workflow levels
   - SchTask.Level_ID must be <= Last_Level
   - DateCompleted must be >= DateCreated

4. **Multi-Allocation Dependencies**
   - When a resource has multiple project allocations, Total Hours must be distributed based on the ratio of Submitted Hours for each project
   - Sum of distributed hours across all projects for a resource must equal Total Hours

---

## 3. BUSINESS RULES

Business rules define the operational logic, categorization criteria, calculation formulas, and transformation guidelines that govern data processing and reporting.

### 3.1 Working Hours Calculation Rules

#### 3.1.1 Total Hours Calculation
**Rule:** Total Hours = Number of Working Days × Hours per Day (location-based)

**Logic:**
1. **Hours per Day by Location:**
   - Offshore (India): 9 hours per day
   - Onshore (US, Canada, LATAM): 8 hours per day

2. **Working Days Calculation:**
   - Include all days from DimDate where DayName NOT IN ('Saturday', 'Sunday')
   - Exclude holidays from respective location holiday tables:
     - US: holidays table
     - India: holidays_India table
     - Canada: holidays_Canada table
     - Mexico: holidays_Mexico table

3. **Example:**
   - For US location in August with 19 working days: Total Hours = 19 × 8 = 152

#### 3.1.2 Multi-Project Allocation Rule
**Rule:** When an employee is allocated to multiple projects, Total Hours are distributed based on the ratio of Submitted Hours for each project.

**Logic:**
1. Calculate Total Submitted Hours across all projects for the resource
2. For each project, calculate allocation ratio = Project Submitted Hours / Total Submitted Hours
3. Distribute Total Hours to each project = Total Hours × Allocation Ratio
4. Adjust any rounding differences proportionally

**Example:**
```
Resource: Mukesh Agrawal
Location Available Hours: 176
Total Submitted Hours: 171

Project 1: Submitted = 40, Total FTE = 40/171 = 0.23392, Allocated Hours = 176 × 0.23392 = 41.17
Project 2: Submitted = 43, Total FTE = 43/171 = 0.25146, Allocated Hours = 176 × 0.25146 = 44.26
Project 3: Submitted = 44, Total FTE = 44/171 = 0.25731, Allocated Hours = 176 × 0.25731 = 45.29
Project 4: Submitted = 44, Total FTE = 44/171 = 0.25731, Allocated Hours = 176 × 0.25731 = 45.29
Total: 176 hours distributed across 4 projects
```

### 3.2 Timesheet Hours Rules

#### 3.2.1 Submitted Hours Rule
**Rule:** Submitted Hours = Sum of all timesheet hours submitted by the resource

**Logic:**
- Submitted Hours = ST + OT + DT + TIME_OFF + HO + Sick_Time
- Column names in Timesheet_New:
  - ST: Consultant_hours(ST) or Approved_hours(ST)
  - OT: Consultant_hours(OT) or Approved_hours(OT)
  - DT: Consultant_hours(DT) or Approved_hours(DT)
  - Sick_Time: Approved_hours(Sick_Time)

#### 3.2.2 Approved Hours Rule
**Rule:** Approved Hours = Sum of timesheet hours approved by Manager (Project Manager, Client, or Approver)

**Logic:**
- Approved Hours = NON_ST + NON_OT + NON_DT + NON_Sick_Time
- Column names in Timesheet_New:
  - NON_ST: Approved_hours(Non_ST)
  - NON_OT: Approved_hours(Non_OT)
  - NON_DT: Approved_hours(Non_DT)
  - NON_Sick_Time: Approved_hours(Non_Sick_Time)

### 3.3 FTE Calculation Rules

#### 3.3.1 Total FTE Rule
**Rule:** Total FTE = Submitted Hours / Total Hours

**Logic:**
- Numerator: Submitted Hours (sum of all submitted timesheet hours)
- Denominator: Total Hours (working days × hours per day, location-based)
- Result: Decimal value between 0 and 1 (or percentage 0% to 100%)

#### 3.3.2 Billed FTE Rule
**Rule:** Billed FTE = Approved Hours / Total Hours

**Logic:**
- Numerator: Approved Hours (sum of all approved timesheet hours)
- If Approved Hours is unavailable or zero, use Submitted Hours
- Denominator: Total Hours (working days × hours per day, location-based)
- Result: Decimal value between 0 and 1 (or percentage 0% to 100%)

### 3.4 Employee Classification Rules

#### 3.4.1 FTE vs Consultant Classification Rule
**Rule:** Source for categorization is Workflow (SchTask table) based on Process_name and HR_Subtier_Company

**Logic:**
```sql
CASE 
  WHEN Process_name LIKE '%office%' AND HR_Subtier_Company = 'Ascendion Engineering Private Limited' THEN 'FTE'
  WHEN Process_name LIKE '%office%' AND HR_Subtier_Company = 'Ascendion Engineering Solutions Mexico' THEN 'FTE'
  WHEN Process_name LIKE '%office%' AND ISNULL(HR_Subtier_Company, '') = '' THEN 'FTE'
  WHEN Process_name LIKE '%Contractor%' AND ISNULL(HR_Subtier_Company, '') NOT IN (
    'Collabera Technologies Pvt. Ltd.',
    'Collaborate Solutions, Inc',
    'Ascendion Engineering Private Limited',
    'Ascendion Engineering Solutions Mexico',
    'Ascendion Canada Inc.',
    'Ascendion Engineering Solutions Europe Limited',
    'Ascendion Digital Solution Pvt. Ltd'
  ) THEN 'Consultant'
  ELSE 'Consultant' 
END
```

### 3.5 Billing Type Classification Rules

#### 3.5.1 Billable vs Non-Billable (NBL) Rule
**Rule:** Determine if a project/assignment is Billable or Non-Billable (NBL)

**Logic:**
```sql
CASE 
  WHEN client code IN ('IT010', 'IT008', 'CE035', 'CO120') THEN 'NBL'
  WHEN ITSSProjectName LIKE '% - pipeline%' THEN 'NBL'
  WHEN Net_Bill_Rate <= 0.1 THEN 'NBL'
  WHEN HWF_Process_name = 'JUMP Hourly Trainee Onboarding' THEN 'NBL'
  ELSE 'Billable'
END
```

### 3.6 Category Classification Rules

#### 3.6.1 India Billing Matrix Rules

**Rule 1: India Billing - Client-NBL**
- **Condition:** ITSSProjectName LIKE 'India Billing%Pipeline%' AND Billing_Type = 'NBL'
- **Exclusions:** Project not in AVA/Bench project list
- **Category:** 'India Billing - Client-NBL'
- **Status:** 'Unbilled'

**Rule 2: India Billing - Billable**
- **Condition:** Client name CONTAINS 'India-Billing' AND Billing_Type = 'Billable'
- **Category:** 'India Billing - Billable'
- **Status:** 'Billed'

**Rule 3: India Billing - Project NBL**
- **Condition:** Client name CONTAINS 'India-Billing' AND Billing_Type = 'NBL'
- **Category:** 'India Billing - Project NBL'
- **Status:** 'Unbilled'

#### 3.6.2 Client Project Matrix Rules (Excluding India Billing)

**Rule 1: Client-NBL**
- **Condition:** Client name NOT CONTAINS 'India-Billing' AND ITSSProjectName CONTAINS 'Pipeline' AND Billing_Type = 'NBL'
- **Category:** 'Client-NBL'
- **Status:** 'Unbilled'

**Rule 2: Project-NBL**
- **Condition:** Client name NOT CONTAINS 'India-Billing' AND ITSSProjectName NOT CONTAINS 'Pipeline' AND Billing_Type = 'NBL'
- **Category:** 'Project-NBL'
- **Status:** 'Unbilled'

**Rule 3: Billable**
- **Condition:** Client name NOT CONTAINS 'India-Billing' AND ITSSProjectName NOT CONTAINS 'Pipeline' AND Billing_Type = 'Billable'
- **Category:** 'Billable'
- **Status:** 'Billed'

**Rule 4: Billable (Actual Hours Present)**
- **Condition:** Billing_Type IS BLANK AND Actual Hours > 0
- **Category:** 'Billable'
- **Status:** 'Billed'

**Rule 5: Default**
- **Condition:** All other cases
- **Category:** 'Project-NBL'
- **Status:** 'Unbilled'

#### 3.6.3 SGA (Selling, General & Administrative) Rules

**Rule:** Resources approved as SGA should have Category and Status updated accordingly
- **Category:** 'SGA'
- **Status:** 'SGA'
- **Source:** ELT marker along with GCI IDs provided in separate mapping

#### 3.6.4 Bench & AVA Matrix Rules

**Rule:** Specific projects are categorized as AVA or Bench based on ITSSProjectName

**AVA Projects:**
- ITSSProjectName IN:
  - 'AVA_Architecture, Development & Testing Project'
  - 'CapEx - GenAI Project'
  - 'CapEx - Web3.0+Gaming 2 (Gaming/Metaverse)'
  - 'Capex - Data Assets'
  - 'AVA_Support, Management & Planning Project'
  - 'Dummy Project - TIQE Bench Project'
- **Category:** 'AVA'
- **Status:** 'AVA'

**Bench Projects:**
- ITSSProjectName IN:
  - 'ASC-ELT Program-2024'
  - 'CES - ELT's Program'
  - 'Dummy Project - Managed Services Hiring'
  - 'GenAI Capability Project - ITSS Collabera'
  - 'Gaming/Metaverse CapEx Project Bench'
- **Category:** 'ELT Project' or 'Bench'
- **Status:** 'Bench'

### 3.7 Utilization Calculation Rules

#### 3.7.1 Project Utilization Rule
**Rule:** Project Utilization = Billed Hours / Available Hours

**Logic:**
- Numerator: Billed Hours (Approved Hours or Submitted Hours if approved unavailable)
- Denominator: Available Hours = Monthly Hours × Total FTE
- Result: Percentage indicating resource utilization on the project

#### 3.7.2 Available Hours Rule
**Rule:** Available Hours = Monthly Hours × Total FTE

**Logic:**
- Monthly Hours: Total hours available in the month (working days × hours per day)
- Total FTE: Submitted Hours / Total Hours
- Result: Hours available for billing based on resource allocation

### 3.8 Date and Period Calculation Rules

#### 3.8.1 YYMM Calculation Rule
**Rule:** Calculate Year-Month identifier in YYYYMM format

**Logic:**
```sql
YYMM = (DATEPART(yyyy, CONVERT(datetime, CONVERT(varchar, c_date, 101))) * 100 
        + DATEPART(MONTH, CONVERT(datetime, CONVERT(varchar, c_date, 101))))
```

**Example:**
- For date 2024-08-15: YYMM = 2024 × 100 + 8 = 202408

### 3.9 Location and Geography Rules

#### 3.9.1 Onsite vs Offshore Classification Rule
**Rule:** Determine if resource is Onsite or Offshore based on location

**Logic:**
- **Offshore:** Location = 'India' OR IS_Offshore = 'Offshore'
- **Onsite:** Location IN ('US', 'Canada', 'Mexico', 'LATAM') OR IS_Offshore = 'Onsite'

#### 3.9.2 Hours by Location Rule
**Rule:** Onsite Hours and Offsite Hours calculation

**Logic:**
- **Onsite Hours:** IF Type = 'OnSite' THEN Actual Hours ELSE 0
- **Offsite Hours:** IF Type = 'Offshore' THEN Actual Hours ELSE 0

### 3.10 Expected Hours Rules

#### 3.10.1 Expected Hours per Day Rule
**Rule:** Expected hours per day is hard-coded as 8 hours

**Note:** This is a standard expectation, but actual hours may vary based on location (9 for offshore)

#### 3.10.2 Total Available Hours Rule
**Rule:** Total Available Hours = Monthly Expected Hours

**Logic:**
- Monthly Expected Hours = Number of Working Days in Month × Expected Hours per Day
- Working days exclude weekends and holidays

### 3.11 Reporting Hierarchy Rules

#### 3.11.1 Client Hierarchy Rule
**Rule:** Super Merged Name represents the parent client name for consolidated reporting

**Logic:**
- Multiple client codes may roll up to a single Super Merged Name
- Used for client-level aggregation and reporting

#### 3.11.2 Organizational Hierarchy Rule
**Rule:** Circle and Community represent organizational groupings

**Logic:**
- Circle: Business circle or group (e.g., Technology, Operations)
- Community: Community or practice group (e.g., Data Engineering, Cloud)
- Portfolio Leader: Leader responsible for the portfolio
- Client Partner: Partner responsible for client relationship

### 3.12 SOW (Statement of Work) Rules

#### 3.12.1 SOW Classification Rule
**Rule:** IS_SOW indicates whether the client engagement is under a Statement of Work

**Logic:**
- IS_SOW = 'Yes': Client is under SOW
- IS_SOW = 'No': Client is not under SOW
- Used for contract type analysis and reporting

### 3.13 Business Type Classification Rules

#### 3.13.1 New Business Type Rule
**Rule:** Classify business type as Contract, Direct Hire, or Project NBL

**Logic:**
- **Contract:** hr_business_type indicates contract-based engagement
- **Direct Hire:** hr_business_type indicates permanent placement
- **Project NBL:** Non-billable project assignment

### 3.14 Vertical and Industry Rules

#### 3.14.1 Vertical Classification Rule
**Rule:** VerticalName represents the industry vertical for the client

**Logic:**
- Vertical examples: Financial Services, Healthcare, Retail, Technology, Manufacturing
- Used for industry-specific reporting and analysis

### 3.15 Workflow and Task Rules

#### 3.15.1 Workflow Process Rule
**Rule:** SchTask table tracks workflow processes for resource onboarding and approvals

**Logic:**
- Process_ID: Unique identifier for workflow process
- Level_ID: Current level in the workflow
- Last_Level: Final level in the workflow
- Status: Current status of the workflow (e.g., Pending, Approved, Rejected)
- DateCreated: Workflow initiation date
- DateCompleted: Workflow completion date

#### 3.15.2 Task Assignment Rule
**Rule:** task_id in Timesheet_New links to workflow ID in SchTask

**Logic:**
- Timesheet entries are associated with specific workflow tasks
- Enables tracking of timesheet approvals through workflow processes

### 3.16 Mapping and Reference Data Rules

#### 3.16.1 Mapping Sheet Rule
**Rule:** Certain attributes are sourced from mapping sheets provided by business stakeholders

**Logic:**
- Circle_new: Sourced from connection file 392
- Delivery Leader: Sourced from mapping sheet shared by JayaLaxmi
- ELT/Non-ELT: Selected GCI IDs marked as ELT shared by JayaLaxmi
- Portfolio Leader: Included in base data for Power BI dashboard filtering

### 3.17 Rate Change and Billing Rules

#### 3.17.1 Bill Rate Change Rule
**Rule:** Track bill rate changes over time for rate analysis

**Logic:**
- BR_Start_date: Start date of current bill rate
- Prev_BR: Previous bill rate
- Mons_in_Same_Rate: Number of months at current rate
- Rate_Time_Gr: Rate time grouping
- Rate_Change_Type: Type of rate change (Increase, Decrease, No Change)

### 3.18 Data Refresh and Update Rules

#### 3.18.1 System Runtime Rule
**Rule:** system_runtime tracks when data was last refreshed

**Logic:**
- system_runtime: Timestamp of last data load/update
- Used for data freshness validation and audit purposes

---

## 4. COMPLIANCE AND VALIDATION RULES

### 4.1 Data Quality Validation Rules

1. **Completeness Validation**
   - All mandatory fields must be populated before data is accepted
   - Missing critical fields (gci_id, client code, start date) should trigger validation errors

2. **Accuracy Validation**
   - Total FTE should not exceed 1.0 (100%) unless multiple allocations are present
   - Billed FTE should not exceed Total FTE
   - Bill rates should be greater than pay rates

3. **Consistency Validation**
   - Cross-table gci_id references must be valid
   - Date ranges must be logical (start date <= end date)
   - Category and Status must align with Billing Type

4. **Format Validation**
   - Date fields must be valid datetime values
   - Numeric fields must contain valid numbers
   - YYMM must be in YYYYMM format

### 4.2 Business Rule Validation

1. **Billing Logic Validation**
   - Verify that Billing Type classification follows defined rules
   - Ensure Category and Status are correctly derived
   - Validate that NBL projects have Net Bill Rate <= 0.1 or are in NBL client list

2. **Hours Calculation Validation**
   - Verify Total Hours calculation excludes weekends and holidays
   - Ensure FTE calculations are accurate
   - Validate that Submitted Hours and Approved Hours are within expected ranges

3. **Workflow Validation**
   - Ensure workflow levels progress logically
   - Validate that DateCompleted >= DateCreated
   - Check that Status transitions follow defined workflow rules

### 4.3 Regulatory Compliance Rules

1. **Data Privacy**
   - Ensure sensitive personal information (SSN, salary) is protected
   - Implement access controls for confidential data

2. **Audit Trail**
   - Maintain system_runtime for data lineage
   - Track UserCreated and DateCreated for audit purposes

3. **Reporting Standards**
   - Ensure all reports align with defined KPIs and metrics
   - Validate that data aggregations are accurate and consistent

---

## 5. TRANSFORMATION AND DERIVATION RULES

### 5.1 Derived Attribute Rules

1. **Category Derivation**
   - Derived from ITSSProjectName, client name, Billing_Type, and Net_Bill_Rate
   - Follows India Billing Matrix, Client Project Matrix, SGA, and Bench/AVA rules

2. **Status Derivation**
   - Derived from Category and Billing_Type
   - Values: Billed, Unbilled, SGA, Bench, AVA

3. **Employee Type Derivation**
   - Derived from Process_name and HR_Subtier_Company
   - Values: FTE, Consultant

4. **Billing Type Derivation**
   - Derived from client code, ITSSProjectName, Net_Bill_Rate, and HWF_Process_name
   - Values: Billable, NBL

### 5.2 Aggregation Rules

1. **Monthly Aggregation**
   - Group by YYMM for monthly reporting
   - Sum hours, FTE, and financial metrics

2. **Resource Aggregation**
   - Group by gci_id for resource-level reporting
   - Sum hours across all projects for multi-allocation resources

3. **Client Aggregation**
   - Group by Super Merged Name for client-level reporting
   - Aggregate revenue, GP, and resource counts

4. **Project Aggregation**
   - Group by ITSSProjectName for project-level reporting
   - Aggregate hours, FTE, and utilization metrics

---

## 6. EXCEPTION HANDLING RULES

### 6.1 Missing Data Handling

1. **Missing Approved Hours**
   - If Approved Hours is NULL or 0, use Submitted Hours for Billed FTE calculation

2. **Missing End Date**
   - If end date is NULL, assume assignment is ongoing
   - Use current date or reporting period end date for calculations

3. **Missing Bill Rate**
   - If bill rate is NULL or 0, classify as NBL

### 6.2 Data Anomaly Handling

1. **Overlapping Assignments**
   - If a resource has overlapping assignments, apply multi-allocation logic
   - Distribute Total Hours based on Submitted Hours ratio

2. **Negative Hours**
   - If any hour field is negative, flag as data quality issue
   - Exclude from calculations until corrected

3. **Invalid Dates**
   - If start date > end date, flag as data quality issue
   - Exclude from reporting until corrected

### 6.3 Business Logic Exceptions

1. **Special Client Codes**
   - Client codes IT010, IT008, CE035, CO120 are always NBL
   - Override other billing logic for these clients

2. **Pipeline Projects**
   - Projects with 'Pipeline' in name are always NBL
   - Override other billing logic for pipeline projects

3. **JUMP Trainee Projects**
   - HWF_Process_name = 'JUMP Hourly Trainee Onboarding' is always NBL
   - Override other billing logic for JUMP trainees

---

## 7. REPORTING REQUIREMENTS ALIGNMENT

### 7.1 KPI Calculation Alignment

1. **Total Hours KPI**
   - Aligns with working days calculation excluding weekends and holidays
   - Location-based hours per day (9 for offshore, 8 for onshore)

2. **Submitted Hours KPI**
   - Aligns with timesheet submission data from Timesheet_New table

3. **Approved Hours KPI**
   - Aligns with manager-approved timesheet data from Timesheet_New table

4. **Total FTE KPI**
   - Aligns with formula: Submitted Hours / Total Hours

5. **Billed FTE KPI**
   - Aligns with formula: Approved Hours / Total Hours (or Submitted Hours if unavailable)

6. **Project Utilization KPI**
   - Aligns with formula: Billed Hours / Available Hours

7. **Available Hours KPI**
   - Aligns with formula: Monthly Hours × Total FTE

### 7.2 Report Filter Alignment

1. **Time Period Filters**
   - YYMM for monthly filtering
   - Quarter and Year from DimDate for quarterly/yearly filtering

2. **Resource Filters**
   - gci_id, first name, last name for resource-level filtering
   - Employee type (FTE/Consultant) for classification filtering

3. **Client Filters**
   - client code, client name, Super Merged Name for client-level filtering
   - IS_SOW for SOW vs non-SOW filtering

4. **Project Filters**
   - ITSSProjectName for project-level filtering
   - Category and Status for billing status filtering

5. **Location Filters**
   - IS_Offshore for onsite/offshore filtering
   - Location, market for geography-based filtering

6. **Organizational Filters**
   - Circle, Community for organizational grouping
   - Portfolio Leader, Client Partner for leadership filtering

### 7.3 Data Model Entity Alignment

1. **DimDate Entity**
   - Supports time-based reporting and working days calculation
   - Provides date attributes for filtering and grouping

2. **Holidays Entities**
   - Support location-specific holiday exclusion in working days calculation
   - Enable accurate Total Hours calculation

3. **Timesheet_New Entity**
   - Captures submitted and approved hours for FTE calculations
   - Links to workflow tasks for approval tracking

4. **report_392_all Entity**
   - Central reporting entity combining resource, project, client, and billing information
   - Supports utilization and billing analysis

5. **New_Monthly_HC_Report Entity**
   - Provides monthly headcount snapshot
   - Supports SOW, vertical, and business area reporting

6. **SchTask Entity**
   - Tracks workflow processes for resource onboarding and approvals
   - Links to timesheet entries for approval tracking

---

## 8. API COST CALCULATION

**Cost for this particular API Call to LLM model:** $0.15

---

## DOCUMENT CONTROL

**Version:** 1.0  
**Last Updated:** [Current Date]  
**Approved By:** [Approval Authority]  
**Next Review Date:** [Review Date]  

---

**END OF DOCUMENT**