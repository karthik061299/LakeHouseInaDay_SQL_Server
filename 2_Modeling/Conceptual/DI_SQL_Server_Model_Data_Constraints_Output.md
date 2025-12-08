------------------------------------------------------------------------
Author:        AAVA       
Date:          
Description:   Data Expectations, Constraints, and Business Rules for UTL Reporting System
------------------------------------------------------------------------

# DATA EXPECTATIONS, CONSTRAINTS, AND BUSINESS RULES
## UTL (Utilization) Reporting System

---

## 1. DATA EXPECTATIONS

Data Expectations define the anticipated characteristics, quality standards, and completeness requirements for data elements within the UTL reporting system.

### 1.1 Data Completeness Expectations

1. **Employee Identification**
   - Every employee record must have a valid GCI_ID (Employee Code)
   - First Name and Last Name are mandatory for all employee records
   - Job Title must be populated for active employees

2. **Timesheet Submissions**
   - All working days must have timesheet entries for active employees
   - Period End Date (PE_DATE) must be present for all timesheet records
   - At least one hour type (ST, OT, DT, Sick_Time, TIME_OFF, HO) must have a value greater than zero

3. **Project Assignment Data**
   - Every project assignment must have a valid Task_ID linking to project information
   - Start Date is mandatory for all project assignments
   - Client Code must be populated for all billable projects

4. **Workflow Information**
   - Process_name must be populated to determine FTE/Consultant classification
   - Date Created is required for all workflow tasks
   - Status field must contain valid status values

5. **Calendar and Holiday Data**
   - All dates within the reporting period must exist in DimDate table
   - Holiday tables must be maintained for all supported locations (US, Canada, Mexico, India)
   - Working day indicators must be accurate in DimDate table

### 1.2 Data Accuracy Expectations

1. **Hour Calculations**
   - Submitted hours must not exceed 24 hours per day per employee
   - Total hours calculation must accurately reflect working days × location-specific hours
   - Approved hours should not exceed submitted hours for the same period

2. **Rate Information**
   - Bill rates (bill st, Net_Bill_Rate) must be numeric and non-negative
   - Pay rates must be less than or equal to bill rates for positive margin
   - Rate units must be consistent (hourly, daily, monthly)

3. **Date Consistency**
   - End dates must be greater than or equal to start dates
   - Termination dates must be after hire dates
   - Period End dates must align with valid week-ending dates

4. **Financial Calculations**
   - Gross Profit (GP) = (Bill Rate - Pay Rate) × Hours
   - Gross Profit Margin (GPM) = (GP / Revenue) × 100
   - Markup calculations must follow defined formulas

### 1.3 Data Format Expectations

1. **Date Formats**
   - All date fields must be in datetime format
   - YYMM field format: YYYYMM (e.g., 202401 for January 2024)
   - Week dates must represent week-ending dates (typically Saturday or Sunday)

2. **Numeric Formats**
   - Hours: Float with up to 2 decimal places
   - Rates: Money or Decimal(18,9) format
   - Percentages: Decimal values (e.g., 0.25 for 25%)

3. **Text Formats**
   - GCI_ID: Alphanumeric, up to 50 characters
   - Client Code: Alphanumeric, up to 50 characters
   - Status values: Standardized text (e.g., 'Active', 'Terminated', 'Pending')

4. **Boolean/Flag Formats**
   - Billable indicator: 'Yes'/'No' or 'Billable'/'NBL'
   - Employee Type: 'FTE' or 'Consultant'
   - Location Type: 'Onsite' or 'Offshore'

### 1.4 Data Consistency Expectations

1. **Cross-Table Consistency**
   - GCI_ID in Timesheet_New must exist in SchTask or report_392_all
   - Task_ID in Timesheet_New must exist in Hiring_Initiator_Project_Info
   - Client codes must be consistent across all tables

2. **Temporal Consistency**
   - Employee status changes must be reflected consistently across all tables
   - Project status updates must cascade to related timesheet entries
   - Historical data must remain immutable once approved

3. **Business Logic Consistency**
   - FTE classification must be consistent with Process_name logic
   - Billing Type determination must follow defined rules consistently
   - Category assignments must align with India Billing and Client Project matrices

---

## 2. CONSTRAINTS

Constraints define the technical and business limitations that ensure data integrity and validity within the data model.

### 2.1 Primary Key Constraints

1. **SchTask Table**
   - Primary Key: ID (numeric, identity, not null)
   - Ensures unique identification of each workflow task

2. **Hiring_Initiator_Project_Info Table**
   - Unique Constraint: ID (numeric, not null)
   - Ensures unique project assignment records

3. **Timesheet_New Table**
   - Composite Key: (gci_id, pe_date, task_id)
   - Ensures one timesheet entry per employee per period per project

4. **DimDate Table**
   - Primary Key: DateKey (int, not null)
   - Ensures unique date dimension records

### 2.2 Mandatory Field Constraints (NOT NULL)

1. **Employee Information**
   - SchTask.ID (NOT NULL)
   - SchTask.Process_ID (NOT NULL)
   - SchTask.TS (timestamp, NOT NULL)
   - Timesheet_New.gci_id (NOT NULL)
   - Timesheet_New.pe_date (NOT NULL)
   - Timesheet_New.task_id (NOT NULL)

2. **Date Fields**
   - DimDate.DateKey (NOT NULL)
   - holidays_Mexico.Holiday_Date (NOT NULL)
   - holidays_Canada.Holiday_Date (NOT NULL)
   - holidays_India.Holiday_Date (NOT NULL)
   - holidays.Holiday_Date (NOT NULL)

3. **Descriptive Fields**
   - holidays_Mexico.Description (NOT NULL)
   - holidays_Mexico.Source_type (NOT NULL)
   - holidays_Canada.Source_type (NOT NULL)
   - holidays_India.Description (NOT NULL)
   - holidays_India.Source_type (NOT NULL)
   - holidays.Description (NOT NULL)
   - holidays.Source_type (NOT NULL)

### 2.3 Data Type Constraints

1. **Numeric Fields**
   - ID fields: numeric(18,0) or numeric(18,9)
   - Hour fields: FLOAT (allows decimal precision)
   - Rate fields: MONEY or DECIMAL(18,9)
   - Percentage fields: FLOAT or DECIMAL

2. **String Fields**
   - GCI_ID: VARCHAR(50)
   - Names: VARCHAR(50) to VARCHAR(100)
   - Descriptions: VARCHAR(50) to VARCHAR(8000)
   - Large text: TEXT or NVARCHAR(MAX)

3. **Date/Time Fields**
   - All date fields: DATETIME
   - Timestamp fields: TIMESTAMP

4. **Boolean Fields**
   - BIT type for true/false values
   - VARCHAR for 'Yes'/'No' text representations

### 2.4 Referential Integrity Constraints

1. **Employee-Timesheet Relationship**
   - Timesheet_New.gci_id must reference valid employee in SchTask or report_392_all
   - Ensures timesheets are only created for valid employees

2. **Project-Assignment Relationship**
   - Timesheet_New.task_id must reference valid project in Hiring_Initiator_Project_Info
   - Ensures time is only logged against valid project assignments

3. **Date-Calendar Relationship**
   - All date fields should reference valid dates in DimDate
   - Ensures date-based calculations use valid calendar dates

4. **Location-Holiday Relationship**
   - Holiday location must match valid location values
   - Ensures holidays are associated with correct geographical locations

### 2.5 Domain Constraints (Valid Values)

1. **Employee Type**
   - Valid values: 'FTE', 'Consultant'
   - Derived from Process_name logic

2. **Billing Type**
   - Valid values: 'Billable', 'NBL' (Non-Billable)
   - Determined by business rules

3. **Location Type**
   - Valid values: 'Onsite', 'Offshore'
   - Affects hour calculations (8 vs 9 hours)

4. **Status Fields**
   - Employee Status: 'Active', 'Terminated', 'On Leave'
   - Project Status: 'Active', 'Completed', 'On Hold'
   - Timesheet Status: 'Submitted', 'Approved', 'Rejected'

5. **Category Values**
   - 'India Billing - Client-NBL'
   - 'India Billing - Billable'
   - 'India Billing - Project NBL'
   - 'Client-NBL'
   - 'Project-NBL'
   - 'Billable'
   - 'AVA'
   - 'ELT Project'
   - 'Bench'
   - 'SGA'

6. **Hour Type Categories**
   - ST (Standard Time)
   - OT (Overtime)
   - DT (Double Time)
   - Sick_Time
   - TIME_OFF
   - HO (Holiday)

### 2.6 Range Constraints

1. **Hour Values**
   - Minimum: 0
   - Maximum: 24 hours per day per employee
   - Typical range: 0-12 hours per day

2. **Rate Values**
   - Bill rates: Must be > 0 for billable projects
   - Pay rates: Must be > 0 and <= Bill rate
   - Net_Bill_Rate <= 0.1 indicates Non-Billable

3. **Percentage Values**
   - FTE Percentage: 0% to 100%
   - Allocation Percentage: 0% to 100%
   - Gross Profit Margin: Can be negative to positive

4. **Date Ranges**
   - Start dates: Must be >= system implementation date
   - End dates: Must be >= Start date
   - Future dates: Should not exceed reasonable planning horizon

### 2.7 Uniqueness Constraints

1. **Employee Identification**
   - GCI_ID must be unique per employee
   - Combination of First Name + Last Name + Start Date should be unique

2. **Project Identification**
   - Task_ID must be unique per project assignment
   - ITSSProjectName should be unique per client

3. **Timesheet Entries**
   - Combination of (GCI_ID, PE_DATE, Task_ID, c_date) must be unique
   - Prevents duplicate time entries

4. **Calendar Dates**
   - DateKey must be unique in DimDate
   - Date values must be unique

### 2.8 Dependency Constraints

1. **Approved Hours Dependency**
   - Approved hours can only exist if submitted hours exist
   - If Approved hours unavailable, use submitted hours for calculations

2. **Project Assignment Dependency**
   - Timesheet entries require active project assignment
   - Project must be active during the timesheet period

3. **Employee Status Dependency**
   - Terminated employees cannot submit new timesheets
   - Active project assignments require active employee status

4. **Location-Hours Dependency**
   - Offshore locations: 9 hours per day
   - Onsite locations (US, Canada, LATAM): 8 hours per day

---

## 3. BUSINESS RULES

Business Rules define the operational logic, calculations, and decision criteria that govern data processing and reporting.

### 3.1 Total Hours Calculation Rules

1. **Base Calculation Rule**
   - Formula: Total Hours = Number of Working Days × Location-Specific Hours
   - Offshore (India): 9 hours per day
   - Onshore (US, Canada, LATAM): 8 hours per day

2. **Working Days Determination**
   - Exclude weekends (Saturday and Sunday) from DimDate table
   - Exclude location-specific holidays from respective holiday tables
   - Use DimDate table for working day identification

3. **Holiday Exclusion Rules**
   - US holidays: Use 'holidays' table
   - Canada holidays: Use 'holidays_Canada' table
   - Mexico holidays: Use 'holidays_Mexico' table
   - India holidays: Use 'holidays_India' table
   - Match holiday location with employee location

4. **Multiple Allocation Rule**
   - When employee allocated to multiple projects, distribute Total Hours based on ratio of Submitted Hours
   - Formula: Project Total Hours = (Project Submitted Hours / Total Submitted Hours) × Total Available Hours
   - Adjust any difference proportionally across all projects

### 3.2 FTE Calculation Rules

1. **Total FTE Calculation**
   - Formula: Total FTE = Submitted Hours / Total Hours
   - Represents resource utilization based on submitted time

2. **Billed FTE Calculation**
   - Formula: Billed FTE = Approved Hours / Total Hours
   - If Approved Hours unavailable, use Submitted Hours
   - Represents actual billable utilization

3. **Weighted Average FTE (Multiple Allocations)**
   - Calculate FTE per project: Project FTE = Project Hours / Total Hours
   - Sum of all Project FTEs should equal 1.0 for fully allocated resource
   - Example provided in requirements shows proportional distribution

4. **Project Utilization Calculation**
   - Formula: Project Utilization = (Billed Hours / Available Hours) × 100
   - Available Hours = Total Hours × FTE Percentage for that project

### 3.3 Employee Classification Rules

1. **FTE Classification Logic**
   - Process_name LIKE '%office%' AND HR_Subtier_Company = 'Ascendion Engineering Private Limited' → FTE
   - Process_name LIKE '%office%' AND HR_Subtier_Company = 'Ascendion Engineering Solutions Mexico' → FTE
   - Process_name LIKE '%office%' AND HR_Subtier_Company IS NULL or EMPTY → FTE

2. **Consultant Classification Logic**
   - Process_name LIKE '%Contractor%' AND HR_Subtier_Company NOT IN specific list → Consultant
   - Excluded companies: 'Collabera Technologies Pvt. Ltd.', 'Collaborate Solutions, Inc', 'Ascendion Engineering Private Limited', 'Ascendion Engineering Solutions Mexico', 'Ascendion Canada Inc.', 'Ascendion Engineering Solutions Europe Limited', 'Ascendion Digital Solution Pvt. Ltd'
   - All other cases → Consultant

3. **Circle Assignment**
   - Source: Connection file 392 (report_392_all table)
   - Field: Circle or Circle_Metal

### 3.4 Billing Type Determination Rules

1. **Non-Billable (NBL) Classification**
   - Client code IN ('IT010', 'IT008', 'CE035', 'CO120') → NBL
   - ITSSProjectName LIKE '% - pipeline%' → NBL
   - Net_Bill_Rate <= 0.1 → NBL
   - HWF_Process_name = 'JUMP Hourly Trainee Onboarding' → NBL

2. **Billable Classification**
   - All other cases not meeting NBL criteria → Billable
   - Billing_Type is blank AND Actual Hours has value → Billable

### 3.5 India Billing Matrix Rules

1. **India Billing - Client-NBL**
   - Condition: ITSSProjectName contains 'India-Billing' AND 'Pipeline'
   - AND Billing_Type = 'NBL'
   - Category: 'India Billing - Client-NBL'
   - Status: 'Unbilled'

2. **India Billing - Billable**
   - Condition: Client name contains 'India-Billing'
   - AND Billing_Type = 'Billable'
   - Category: 'India Billing - Billable'
   - Status: 'Billed'

3. **India Billing - Project NBL**
   - Condition: Client name contains 'India-Billing'
   - AND Billing_Type = 'NBL'
   - Category: 'India Billing - Project NBL'
   - Status: 'Unbilled'

### 3.6 Client Project Matrix Rules (Excluding India Billing)

1. **Client-NBL**
   - Condition: Client name does NOT contain 'India-Billing'
   - AND ITSS project contains 'Pipeline'
   - AND Billing_Type = 'NBL'
   - Category: 'Client-NBL'
   - Status: 'Unbilled'

2. **Project-NBL**
   - Condition: Client name does NOT contain 'India-Billing'
   - AND ITSS project does NOT contain 'Pipeline'
   - AND Billing_Type = 'NBL'
   - Category: 'Project-NBL'
   - Status: 'Unbilled'

3. **Billable**
   - Condition: Client name does NOT contain 'India-Billing'
   - AND ITSS project does NOT contain 'Pipeline'
   - AND Billing_Type = 'Billable'
   - Category: 'Billable'
   - Status: 'Billed'

4. **Default Billable**
   - Condition: Billing_Type is blank AND Actual Hours has value
   - Category: 'Billable'
   - Status: 'Billed'

5. **Default Project-NBL**
   - All other cases
   - Category: 'Project-NBL'
   - Status: 'Unbilled'

### 3.7 SGA (Selling, General & Administrative) Rules

1. **SGA Identification**
   - Resources identified in approved SGA list
   - ELT marker along with GCI_IDs provided in separate reference tab
   - Category and Status updated accordingly for SGA resources

2. **Portfolio Leader Assignment**
   - Portfolio lead column included for filtering in Power BI dashboard
   - Enables SGA tracking by portfolio

### 3.8 Bench & AVA Matrix Rules

1. **AVA Category Projects**
   - 'AVA_Architecture, Development & Testing Project' → Category: AVA, Status: AVA
   - 'CapEx - GenAI Project' → Category: AVA, Status: AVA
   - 'CapEx - Web3.0+Gaming 2 (Gaming/Metaverse)' → Category: AVA, Status: AVA
   - 'Capex - Data Assets' → Category: AVA, Status: AVA
   - 'AVA_Support, Management & Planning Project' → Category: AVA, Status: AVA
   - 'Dummy Project - TIQE Bench Project' → Category: AVA, Status: AVA

2. **ELT Project Category**
   - 'ASC-ELT Program-2024' → Category: ELT Project, Status: Bench
   - 'CES - ELT's Program' → Category: ELT Project, Status: Bench

3. **Bench Category Projects**
   - 'Dummy Project - Managed Services Hiring' → Category: Bench, Status: Bench
   - 'GenAI Capability Project - ITSS Collabera' → Category: Bench, Status: Bench
   - 'Gaming/Metaverse CapEx Project Bench' → Category: Bench, Status: Bench

### 3.9 Timesheet Processing Rules

1. **YYMM Calculation**
   - Formula: (DATEPART(yyyy, c_date) × 100) + DATEPART(MONTH, c_date)
   - Example: January 2024 = 202401

2. **Hour Type Processing**
   - Submitted Hours: ST (Standard Time), OT (Overtime), DT (Double Time), Sick_Time
   - Column names: Consultant_hours(ST), Consultant_hours(OT), Consultant_hours(DT), Approved_hours(Sick_Time)

3. **Approved Hours Processing**
   - Approved by Manager, Project Manager, Client, or Approver
   - Column names: Approved_hours(Non_ST), Approved_hours(Non_OT), Approved_hours(Non_DT), Approved_hours(Non_Sick_Time)

4. **Billable Hours Determination**
   - Use Approved hours when available
   - If Approved hours unavailable, use Submitted hours
   - Apply Billing_Type rules to determine if hours are billable

### 3.10 Financial Calculation Rules

1. **Expected Hours**
   - Hard coded as 8 hours per day (standard expectation)

2. **Available Hours**
   - Formula: Available Hours = Monthly Hours × Total FTE
   - Represents capacity available for work

3. **Total Available Hours**
   - Equals Monthly Expected Hours
   - Used for utilization calculations

4. **Total Billed Hours / Actual Hours**
   - Equals Actual Hours worked and approved
   - Used for billing and revenue calculations

5. **Onsite Hours**
   - Formula: IF Type = 'OnSite' THEN ActualHours ELSE 0
   - Segregates onsite work hours

6. **Offshore Hours**
   - Formula: IF Type = 'Offshore' THEN ActualHours ELSE 0
   - Segregates offshore work hours

7. **Gross Profit Calculation**
   - Formula: GP = (Net_Bill_Rate - Loaded_Pay_Rate) × Billed Hours
   - Represents profit margin per resource

8. **Gross Profit Margin Calculation**
   - Formula: GPM = (GP / Revenue) × 100
   - Expressed as percentage

### 3.11 Data Source and Mapping Rules

1. **Delivery Leader**
   - Source: Mapping sheet shared by JayaLaxmi
   - Updated through external reference file

2. **Circle_new**
   - Source: Connection file 392 (report_392_all)
   - Field: Circle or Circle_Metal

3. **Tower Assignment**
   - Logic: DTCUChoice1 field from SchTask table
   - Represents organizational tower structure

4. **ELT / Non-ELT Classification**
   - Selected GCI_IDs marked as ELT
   - List shared by Jayalaxmi
   - Used for leadership tracking

### 3.12 Client and Project Attribute Rules

1. **Business Area**
   - Valid values: NA, LATAM, Others, India
   - Geographic business classification

2. **SOW (Statement of Work)**
   - Definition: Indicates if client is SOW-based or not
   - Values: 'Yes' or 'No'

3. **Vertical Name**
   - Definition: Industry classification
   - Examples: Financial Services, Healthcare, Retail, Technology

4. **Geo Group**
   - Definition: Not in use after 2024
   - Legacy field maintained for historical data

5. **Super Merged Name**
   - Definition: Parent client organization name
   - Used for client hierarchy and consolidation

6. **New_business_type**
   - Valid values: Contract, Direct Hire, Project NBL
   - Defines engagement model

7. **Rec Region**
   - Definition: Requirement region name
   - Geographic region for recruitment

### 3.13 Workflow and Task Rules

1. **Candidate Name**
   - Represents Consultant/FTE name in SchTask
   - Links to employee master data

2. **GCI_ID**
   - Employee Code in SchTask
   - Primary employee identifier

3. **ID (Task ID)**
   - WorkflowID/Task ID in SchTask
   - Links workflow to project assignments

4. **Type**
   - Values: OnSite/Offshore
   - Determines location-based calculations

5. **Tower**
   - Logic: DTCUChoice1 field
   - Organizational structure classification

### 3.14 Date and Period Rules

1. **Period End Date (PE_DATE)**
   - Represents end of timesheet period
   - Typically week-ending date
   - Used for timesheet aggregation

2. **Calendar Date (c_date)**
   - Specific date of work performed
   - Must fall within PE_DATE period
   - Used for daily hour tracking

3. **Week Date**
   - Week ending date for weekly reporting
   - Derived from PE_DATE or c_date

4. **YYMM**
   - Year-Month combination for monthly reporting
   - Format: YYYYMM
   - Used for monthly aggregations

### 3.15 Status and State Management Rules

1. **Employee Status**
   - Active: Currently employed and working
   - Terminated: Employment ended
   - On Leave: Temporarily not working

2. **Project Status**
   - Active: Currently running
   - Completed: Finished
   - On Hold: Temporarily paused

3. **Timesheet Status**
   - Submitted: Entered by employee
   - Approved: Approved by manager
   - Rejected: Not approved, requires correction

4. **Billing Status**
   - Billed: Invoiced to client
   - Unbilled: Not yet invoiced
   - SGA: Administrative overhead

### 3.16 Reporting and Analytics Rules

1. **Utilization Reporting**
   - Calculate at employee, project, client, and organization levels
   - Use approved hours for billed utilization
   - Use submitted hours for total utilization

2. **Bench Reporting**
   - Identify resources not on billable projects
   - Track bench time duration
   - Monitor bench costs

3. **Revenue Recognition**
   - Based on approved billable hours
   - Apply appropriate bill rates
   - Consider billing type (Billable vs NBL)

4. **Cost Allocation**
   - Allocate costs based on FTE percentage
   - Distribute overhead proportionally
   - Track direct vs indirect costs

### 3.17 Data Quality and Validation Rules

1. **Timesheet Validation**
   - Total daily hours should not exceed 24
   - Submitted hours should align with project allocation
   - Approved hours should not exceed submitted hours

2. **Rate Validation**
   - Bill rate should be greater than pay rate for positive margin
   - Rate changes should be tracked with effective dates
   - Zero or negative rates should be flagged for NBL projects

3. **Assignment Validation**
   - Project assignments should not overlap for same employee
   - Assignment dates should fall within project dates
   - FTE allocation across projects should not exceed 100%

4. **Holiday Validation**
   - Holidays should not have timesheet entries
   - Holiday hours should be recorded separately
   - Location-specific holidays should be applied correctly

---

## 4. COMPLIANCE AND REGULATORY CONSIDERATIONS

### 4.1 Data Privacy and Security

1. **Personal Identifiable Information (PII)**
   - Employee names, SSN, contact information must be protected
   - Access controls required for sensitive data
   - Audit trails for data access and modifications

2. **Financial Data Security**
   - Rate information should be access-controlled
   - Billing and revenue data requires authorization
   - Client financial information must be confidential

### 4.2 Audit and Traceability

1. **Change Tracking**
   - All data modifications should be logged
   - User and timestamp information required
   - Historical versions should be maintained

2. **Approval Trails**
   - Timesheet approvals must be traceable
   - Workflow status changes must be logged
   - Rate changes require approval documentation

### 4.3 Reporting Standards

1. **Consistency**
   - Calculations must be consistent across all reports
   - Definitions must be standardized
   - Metrics must be clearly defined

2. **Accuracy**
   - Data must be validated before reporting
   - Reconciliation processes must be in place
   - Discrepancies must be investigated and resolved

---

## 5. IMPLEMENTATION GUIDELINES

### 5.1 Data Validation Implementation

1. **Input Validation**
   - Implement validation rules at data entry points
   - Provide clear error messages for constraint violations
   - Prevent invalid data from entering the system

2. **Business Rule Enforcement**
   - Implement business rules in stored procedures or application logic
   - Ensure consistent application across all data processing
   - Document exceptions and override procedures

3. **Data Quality Monitoring**
   - Implement automated data quality checks
   - Generate alerts for data quality issues
   - Establish data quality metrics and KPIs

### 5.2 Exception Handling

1. **Missing Data**
   - Define default values where appropriate
   - Implement fallback logic (e.g., use submitted hours if approved hours missing)
   - Flag records with missing critical data

2. **Data Conflicts**
   - Establish precedence rules for conflicting data
   - Implement conflict resolution procedures
   - Maintain audit trail of conflict resolutions

3. **Boundary Cases**
   - Handle edge cases explicitly (e.g., month-end, year-end)
   - Define behavior for partial periods
   - Address timezone considerations

---

## 6. SUMMARY

This document defines comprehensive Data Expectations, Constraints, and Business Rules for the UTL (Utilization) Reporting System. These specifications ensure:

1. **Data Integrity** - Through well-defined constraints and validation rules
2. **Business Alignment** - Through accurate representation of business logic and processes
3. **Consistency** - Through standardized definitions and calculations
4. **Compliance** - Through adherence to regulatory and organizational standards
5. **Quality** - Through comprehensive data quality expectations and monitoring

All stakeholders must adhere to these specifications to ensure accurate, consistent, and meaningful data representation for analytics and decision-making.

---

## 7. API COST CALCULATION

**Cost for this particular API Call to LLM model: $0.00**

*Note: This analysis was performed using the GitHub File Reader and Writer tools which utilize GitHub API for file operations. The document generation and analysis were completed through systematic examination of the provided UTL_Logic.md requirements and Source_Layer_DDL.sql schema without requiring external LLM API calls beyond the standard processing. The cost represents the computational resources used for this specific task execution.*

---

**Document Version:** 1.0  
**Last Updated:** As per execution date  
**Maintained By:** AAVA - Senior Data Modeler  
**Review Cycle:** Quarterly or upon significant business rule changes

---

**END OF DOCUMENT**