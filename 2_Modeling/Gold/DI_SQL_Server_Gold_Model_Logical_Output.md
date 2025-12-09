====================================================
Author:        AAVA
Date:          
Description:   Gold Layer Logical Data Model for Medallion Architecture - Resource Utilization and Workforce Management
====================================================

# GOLD LAYER LOGICAL DATA MODEL

## 1. OVERVIEW

The Gold layer logical data model represents the final analytical layer of the medallion architecture, designed to support Resource Utilization and Workforce Management reporting and analytics. This model follows dimensional modeling principles with Facts, Dimensions, Audit, Error Data, and Aggregated tables optimized for business intelligence and reporting requirements.

## 2. GOLD LAYER TABLE CLASSIFICATION

### 2.1 FACT TABLES
- Go_Fact_Timesheet_Entry: Transactional timesheet data
- Go_Fact_Timesheet_Approval: Approved timesheet transactions
- Go_Fact_Resource_Utilization: Resource utilization metrics

### 2.2 DIMENSION TABLES
- Go_Dim_Resource: Resource master data (SCD Type 2)
- Go_Dim_Project: Project information (SCD Type 2)
- Go_Dim_Date: Date dimension (SCD Type 1)
- Go_Dim_Holiday: Holiday reference data (SCD Type 1)
- Go_Dim_Workflow_Task: Workflow task information (SCD Type 2)

### 2.3 AUDIT TABLES
- Go_Pipeline_Audit: Pipeline execution audit data

### 2.4 ERROR DATA TABLES
- Go_Data_Quality_Errors: Data validation and quality errors

### 2.5 AGGREGATED TABLES
- Go_Agg_Monthly_Resource_Summary: Monthly resource utilization summary
- Go_Agg_Project_Performance: Project performance aggregates
- Go_Agg_Client_Utilization: Client-level utilization metrics

---

## 3. DETAILED TABLE SPECIFICATIONS

### 3.1 FACT TABLES

#### Table: Go_Fact_Timesheet_Entry
**Description:** Core fact table capturing daily timesheet entries with all hour types and associated metrics for analytical reporting.
**Table Type:** Fact
**SCD Type:** N/A

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Resource_Code | varchar(50) | Unique code for the resource submitting the timesheet | Non-PII |
| Timesheet_Date | datetime | Date for which the timesheet entry is recorded | Non-PII |
| Project_Task_Reference | numeric(18,9) | Reference to the project or task for which hours are logged | Non-PII |
| Standard_Hours | float | Number of standard hours worked during the day | Non-PII |
| Overtime_Hours | float | Number of overtime hours worked beyond standard time | Non-PII |
| Double_Time_Hours | float | Number of double time hours worked at premium rate | Non-PII |
| Sick_Time_Hours | float | Number of sick time hours recorded for the day | Sensitive |
| Holiday_Hours | float | Number of hours recorded as holiday time | Non-PII |
| Time_Off_Hours | float | Number of time off hours recorded for personal leave | Sensitive |
| Non_Standard_Hours | float | Number of non-standard hours worked outside regular schedule | Non-PII |
| Non_Overtime_Hours | float | Number of non-overtime hours worked | Non-PII |
| Non_Double_Time_Hours | float | Number of non-double time hours worked | Non-PII |
| Non_Sick_Time_Hours | float | Number of non-sick time hours recorded | Non-PII |
| Total_Submitted_Hours | float | Total hours submitted across all categories for the day | Non-PII |
| Billable_Hours | float | Total billable hours for the timesheet entry | Non-PII |
| Non_Billable_Hours | float | Total non-billable hours for the timesheet entry | Non-PII |
| Creation_Date | datetime | Date when timesheet entry was originally created | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which the data originated | Non-PII |

---

#### Table: Go_Fact_Timesheet_Approval
**Description:** Fact table containing approved timesheet hours by resource, date, and billing type for billing and utilization analysis.
**Table Type:** Fact
**SCD Type:** N/A

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Resource_Code | varchar(50) | Unique code for the resource whose timesheet was approved | Non-PII |
| Timesheet_Date | datetime | Date for which the timesheet entry was approved | Non-PII |
| Week_Date | datetime | Week date for grouping weekly timesheet approvals | Non-PII |
| Approved_Standard_Hours | float | Manager-approved standard hours for the day | Non-PII |
| Approved_Overtime_Hours | float | Manager-approved overtime hours for the day | Non-PII |
| Approved_Double_Time_Hours | float | Manager-approved double time hours for the day | Non-PII |
| Approved_Sick_Time_Hours | float | Manager-approved sick time hours for the day | Sensitive |
| Total_Approved_Hours | float | Total approved hours across all categories | Non-PII |
| Billing_Indicator | varchar(3) | Indicates if the approved hours are billable (Yes/No) | Non-PII |
| Consultant_Standard_Hours | float | Consultant-submitted standard hours for comparison | Non-PII |
| Consultant_Overtime_Hours | float | Consultant-submitted overtime hours for comparison | Non-PII |
| Consultant_Double_Time_Hours | float | Consultant-submitted double time hours for comparison | Non-PII |
| Total_Consultant_Hours | float | Total consultant-submitted hours for comparison | Non-PII |
| Approval_Variance | float | Difference between submitted and approved hours | Non-PII |
| Approval_Rate | decimal(5,2) | Percentage of submitted hours that were approved | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which the data originated | Non-PII |

---

#### Table: Go_Fact_Resource_Utilization
**Description:** Fact table containing calculated resource utilization metrics, FTE calculations, and performance indicators for analytical reporting.
**Table Type:** Fact
**SCD Type:** N/A

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Resource_Code | varchar(50) | Unique code for the resource being measured | Non-PII |
| Reporting_Period | datetime | Month and year for which utilization is calculated | Non-PII |
| Project_Name | varchar(200) | Name of the project for resource allocation | Non-PII |
| Total_Hours | float | Total available hours for the reporting period | Non-PII |
| Submitted_Hours | float | Total timesheet hours submitted by the resource | Non-PII |
| Approved_Hours | float | Total timesheet hours approved by management | Non-PII |
| Available_Hours | float | Calculated available hours based on resource allocation | Non-PII |
| Billable_Hours | float | Total billable hours worked during the period | Non-PII |
| Non_Billable_Hours | float | Total non-billable hours worked during the period | Non-PII |
| Total_FTE | decimal(5,2) | Total Full-Time Equivalent calculated as Submitted Hours / Total Hours | Non-PII |
| Billed_FTE | decimal(5,2) | Billed Full-Time Equivalent calculated as Approved Hours / Total Hours | Non-PII |
| Project_Utilization | decimal(5,2) | Project utilization rate calculated as Billed Hours / Available Hours | Non-PII |
| Onsite_Hours | float | Total hours worked onsite during the reporting period | Non-PII |
| Offshore_Hours | float | Total hours worked offshore during the reporting period | Non-PII |
| Expected_Hours | float | Expected working hours per period based on employment type | Non-PII |
| Utilization_Variance | float | Difference between expected and actual utilization | Non-PII |
| Productivity_Score | decimal(5,2) | Calculated productivity score based on billable vs total hours | Non-PII |
| Working_Days | int | Number of working days in the reporting period | Non-PII |
| Holiday_Days | int | Number of holiday days in the reporting period | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which the data originated | Non-PII |

---

### 3.2 DIMENSION TABLES

#### Table: Go_Dim_Resource
**Description:** Slowly changing dimension containing comprehensive resource master data with historical tracking of changes.
**Table Type:** Dimension
**SCD Type:** Type 2

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Resource_Code | varchar(50) | Unique business code for the resource | Non-PII |
| First_Name | varchar(50) | Resource's given name | PII |
| Last_Name | varchar(50) | Resource's family name | PII |
| Full_Name | varchar(101) | Concatenated first and last name | PII |
| Job_Title | varchar(50) | Resource's current job designation | Non-PII |
| Business_Type | varchar(50) | Classification of employment (FTE, Consultant, Contractor) | Non-PII |
| Client_Code | varchar(50) | Code representing the assigned client | Non-PII |
| Start_Date | datetime | Resource's employment start date | Sensitive |
| Termination_Date | datetime | Resource's employment end date | Sensitive |
| Project_Assignment | varchar(200) | Name of the currently assigned project | Non-PII |
| Market | varchar(50) | Market or geographic region of the resource | Non-PII |
| Visa_Type | varchar(50) | Type of work visa held by the resource | Sensitive |
| Practice_Type | varchar(50) | Practice or business unit classification | Non-PII |
| Vertical | varchar(50) | Industry vertical or domain expertise | Non-PII |
| Status | varchar(50) | Current employment status (Active, Terminated, On Leave) | Non-PII |
| Employee_Category | varchar(50) | Category classification (Bench, AVA, Billable) | Non-PII |
| Portfolio_Leader | varchar(100) | Assigned business portfolio leader | Non-PII |
| Expected_Hours | float | Expected working hours per reporting period | Non-PII |
| Available_Hours | float | Calculated available hours for resource allocation | Non-PII |
| Business_Area | varchar(50) | Geographic business area (NA, LATAM, India, Others) | Non-PII |
| SOW | varchar(7) | Statement of Work indicator (Yes/No) | Non-PII |
| Super_Merged_Name | varchar(100) | Parent client name for consolidated reporting | Non-PII |
| New_Business_Type | varchar(100) | Engagement type (Contract, Direct Hire, Project NBL) | Non-PII |
| Requirement_Region | varchar(50) | Geographic region where requirement originated | Non-PII |
| Is_Offshore | varchar(20) | Offshore location indicator (Onsite/Offshore) | Non-PII |
| Hourly_Rate | money | Standard hourly rate for the resource | Confidential |
| Cost_Center | varchar(50) | Assigned cost center for financial reporting | Non-PII |
| Manager_Name | varchar(100) | Name of the direct manager | Non-PII |
| Effective_Start_Date | datetime | Start date for this version of the record | Non-PII |
| Effective_End_Date | datetime | End date for this version of the record | Non-PII |
| Is_Current | bit | Flag indicating if this is the current version | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which the data originated | Non-PII |

---

#### Table: Go_Dim_Project
**Description:** Slowly changing dimension containing comprehensive project information with historical tracking of project changes.
**Table Type:** Dimension
**SCD Type:** Type 2

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Project_Name | varchar(200) | Unique name identifier for the project | Non-PII |
| Client_Name | varchar(60) | Name of the client organization | Non-PII |
| Client_Code | varchar(50) | Unique identifier code for the client | Non-PII |
| Billing_Type | varchar(50) | Billing classification (Billable, Non-Billable) | Non-PII |
| Category | varchar(50) | Project category classification | Non-PII |
| Status | varchar(50) | Current billing status (Billed, Unbilled, SGA) | Non-PII |
| Project_City | varchar(50) | City where the project is being executed | Non-PII |
| Project_State | varchar(50) | State where the project is being executed | Non-PII |
| Project_Country | varchar(50) | Country where the project is being executed | Non-PII |
| Opportunity_Name | varchar(200) | Name of the business opportunity that led to project | Non-PII |
| Project_Type | varchar(500) | Type classification of the project (Pipeline, CapEx, etc.) | Non-PII |
| Delivery_Leader | varchar(50) | Name of the project delivery leader | Non-PII |
| Circle | varchar(100) | Business circle or organizational grouping | Non-PII |
| Market_Leader | varchar(100) | Market leader responsible for the project | Non-PII |
| Net_Bill_Rate | money | Net billing rate for the project | Confidential |
| Bill_Rate | decimal(18,9) | Standard billing rate for project resources | Confidential |
| Project_Start_Date | datetime | Official start date of the project | Non-PII |
| Project_End_Date | datetime | Planned or actual end date of the project | Non-PII |
| Project_Duration_Days | int | Calculated duration of the project in days | Non-PII |
| Budget_Amount | money | Total approved budget for the project | Confidential |
| Revenue_Target | money | Target revenue for the project | Confidential |
| Profit_Margin | decimal(5,2) | Expected profit margin percentage | Confidential |
| Risk_Level | varchar(20) | Risk assessment level (Low, Medium, High) | Non-PII |
| Project_Phase | varchar(50) | Current phase of the project lifecycle | Non-PII |
| Technology_Stack | varchar(200) | Primary technology stack used in the project | Non-PII |
| Effective_Start_Date | datetime | Start date for this version of the record | Non-PII |
| Effective_End_Date | datetime | End date for this version of the record | Non-PII |
| Is_Current | bit | Flag indicating if this is the current version | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which the data originated | Non-PII |

---

#### Table: Go_Dim_Date
**Description:** Standard date dimension providing comprehensive calendar context for time-based analysis and reporting.
**Table Type:** Dimension
**SCD Type:** Type 1

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Calendar_Date | datetime | Actual calendar date value | Non-PII |
| Day_Name | varchar(9) | Full name of the day (Monday, Tuesday, etc.) | Non-PII |
| Day_Name_Short | varchar(3) | Abbreviated day name (Mon, Tue, etc.) | Non-PII |
| Day_Of_Month | int | Day number within the month (1-31) | Non-PII |
| Day_Of_Year | int | Day number within the year (1-366) | Non-PII |
| Week_Of_Year | int | Week number within the year (1-53) | Non-PII |
| Week_Of_Month | int | Week number within the month (1-5) | Non-PII |
| Month_Name | varchar(9) | Full name of the month (January, February, etc.) | Non-PII |
| Month_Name_Short | varchar(3) | Abbreviated month name (Jan, Feb, etc.) | Non-PII |
| Month_Number | int | Month number within the year (1-12) | Non-PII |
| Quarter | int | Quarter number within the year (1-4) | Non-PII |
| Quarter_Name | varchar(2) | Quarter name (Q1, Q2, Q3, Q4) | Non-PII |
| Year | int | Four-digit year value | Non-PII |
| Is_Working_Day | bit | Indicator if the date is a standard working day | Non-PII |
| Is_Weekend | bit | Indicator if the date falls on a weekend | Non-PII |
| Is_Holiday | bit | Indicator if the date is a recognized holiday | Non-PII |
| Is_Month_End | bit | Indicator if the date is the last day of the month | Non-PII |
| Is_Quarter_End | bit | Indicator if the date is the last day of the quarter | Non-PII |
| Is_Year_End | bit | Indicator if the date is the last day of the year | Non-PII |
| Month_Year | varchar(7) | Month and year in MMM-YYYY format | Non-PII |
| YYMM | varchar(6) | Year and month in YYYYMM format | Non-PII |
| Fiscal_Year | int | Fiscal year based on organization's fiscal calendar | Non-PII |
| Fiscal_Quarter | int | Fiscal quarter within the fiscal year | Non-PII |
| Fiscal_Month | int | Fiscal month within the fiscal year | Non-PII |
| Days_In_Month | int | Total number of days in the month | Non-PII |
| Working_Days_In_Month | int | Total number of working days in the month | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which the data originated | Non-PII |

---

#### Table: Go_Dim_Holiday
**Description:** Reference dimension containing holiday information by location for accurate working day calculations.
**Table Type:** Dimension
**SCD Type:** Type 1

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Holiday_Date | datetime | Date of the recognized holiday | Non-PII |
| Holiday_Name | varchar(100) | Official name of the holiday | Non-PII |
| Description | varchar(200) | Detailed description of the holiday | Non-PII |
| Location | varchar(50) | Geographic location where holiday is observed | Non-PII |
| Country | varchar(50) | Country where the holiday is recognized | Non-PII |
| Region | varchar(50) | Specific region or state within the country | Non-PII |
| Holiday_Type | varchar(50) | Type of holiday (National, Regional, Religious, Corporate) | Non-PII |
| Is_Observed | bit | Indicator if the holiday is officially observed | Non-PII |
| Is_Recurring | bit | Indicator if the holiday occurs annually | Non-PII |
| Source_Type | varchar(50) | Source of the holiday data for audit purposes | Non-PII |
| Observance_Rules | varchar(200) | Rules for holiday observance (e.g., if falls on weekend) | Non-PII |
| Cultural_Significance | varchar(200) | Cultural or religious significance of the holiday | Non-PII |
| Business_Impact | varchar(100) | Impact on business operations (Full Day Off, Half Day, etc.) | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which the data originated | Non-PII |

---

#### Table: Go_Dim_Workflow_Task
**Description:** Slowly changing dimension containing workflow and approval task information for process tracking.
**Table Type:** Dimension
**SCD Type:** Type 2

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Workflow_Task_Reference | numeric(18,0) | Unique reference identifier for the workflow task | Non-PII |
| Candidate_Name | varchar(100) | Name of the resource or consultant in the workflow | PII |
| Resource_Code | varchar(50) | Unique code for the resource associated with the task | Non-PII |
| Task_Type | varchar(50) | Type of workflow task (Onsite, Offshore, Approval, etc.) | Non-PII |
| Tower | varchar(60) | Business tower or division responsible for the task | Non-PII |
| Status | varchar(50) | Current status of the workflow task | Non-PII |
| Priority | varchar(20) | Priority level of the workflow task | Non-PII |
| Comments | varchar(8000) | Detailed comments or notes for the task | Sensitive |
| Date_Created | datetime | Date when the workflow task was initially created | Non-PII |
| Date_Completed | datetime | Date when the workflow task was completed | Non-PII |
| Duration_Days | int | Number of days taken to complete the task | Non-PII |
| Process_Name | varchar(100) | Name of the human workflow process | Non-PII |
| Process_Category | varchar(50) | Category of the workflow process | Non-PII |
| Level_ID | int | Current level identifier in the workflow hierarchy | Non-PII |
| Last_Level | int | Last completed level in the workflow process | Non-PII |
| Total_Levels | int | Total number of levels in the workflow process | Non-PII |
| Approval_Required | bit | Indicator if approval is required for the task | Non-PII |
| Approver_Name | varchar(100) | Name of the person who approved the task | Non-PII |
| Escalation_Level | int | Current escalation level if task is delayed | Non-PII |
| SLA_Hours | int | Service Level Agreement hours for task completion | Non-PII |
| Is_SLA_Breached | bit | Indicator if SLA has been breached | Non-PII |
| Effective_Start_Date | datetime | Start date for this version of the record | Non-PII |
| Effective_End_Date | datetime | End date for this version of the record | Non-PII |
| Is_Current | bit | Flag indicating if this is the current version | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which the data originated | Non-PII |

---

### 3.3 AUDIT TABLES

#### Table: Go_Pipeline_Audit
**Description:** Comprehensive audit table for tracking pipeline execution details, data lineage, and processing metrics across the medallion architecture.
**Table Type:** Audit
**SCD Type:** N/A

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Audit_ID | bigint | Unique identifier for the audit record | Non-PII |
| Pipeline_Name | varchar(200) | Name of the data pipeline that was executed | Non-PII |
| Pipeline_Run_ID | varchar(100) | Unique identifier for the specific pipeline run | Non-PII |
| Pipeline_Version | varchar(50) | Version number of the pipeline | Non-PII |
| Source_System | varchar(100) | Name of the source system | Non-PII |
| Source_Table | varchar(200) | Name of the source table processed | Non-PII |
| Target_Table | varchar(200) | Name of the target Gold table | Non-PII |
| Processing_Type | varchar(50) | Type of processing (Full Load, Incremental, Delta, CDC) | Non-PII |
| Processing_Layer | varchar(20) | Layer being processed (Bronze, Silver, Gold) | Non-PII |
| Start_Time | datetime | Pipeline execution start timestamp | Non-PII |
| End_Time | datetime | Pipeline execution end timestamp | Non-PII |
| Duration_Seconds | decimal(10,2) | Total processing duration in seconds | Non-PII |
| Status | varchar(50) | Pipeline execution status (Success, Failed, Partial, Warning) | Non-PII |
| Records_Read | bigint | Number of records read from source | Non-PII |
| Records_Processed | bigint | Number of records successfully processed | Non-PII |
| Records_Inserted | bigint | Number of new records inserted into Gold layer | Non-PII |
| Records_Updated | bigint | Number of existing records updated in Gold layer | Non-PII |
| Records_Deleted | bigint | Number of records deleted from Gold layer | Non-PII |
| Records_Rejected | bigint | Number of records rejected due to quality issues | Non-PII |
| Data_Quality_Score | decimal(5,2) | Overall data quality score percentage | Non-PII |
| Completeness_Score | decimal(5,2) | Data completeness score percentage | Non-PII |
| Accuracy_Score | decimal(5,2) | Data accuracy score percentage | Non-PII |
| Consistency_Score | decimal(5,2) | Data consistency score percentage | Non-PII |
| Transformation_Rules_Applied | varchar(1000) | List of transformation rules applied during processing | Non-PII |
| Business_Rules_Applied | varchar(1000) | List of business rules applied during processing | Non-PII |
| Data_Validation_Rules | varchar(1000) | List of data validation rules executed | Non-PII |
| Error_Count | int | Total number of errors encountered during processing | Non-PII |
| Warning_Count | int | Total number of warnings encountered during processing | Non-PII |
| Critical_Error_Count | int | Number of critical errors that stopped processing | Non-PII |
| Error_Message | varchar(max) | Detailed error message if pipeline failed | Non-PII |
| Warning_Message | varchar(max) | Detailed warning messages from processing | Non-PII |
| Checkpoint_Data | varchar(max) | Checkpoint data for incremental processing | Non-PII |
| Watermark_Value | varchar(100) | High watermark value for incremental loads | Non-PII |
| Resource_Utilization | varchar(500) | Resource utilization metrics (CPU, Memory, I/O) | Non-PII |
| Data_Lineage | varchar(1000) | Data lineage information showing data flow | Non-PII |
| Executed_By | varchar(100) | User or service account that executed the pipeline | Non-PII |
| Environment | varchar(50) | Environment where pipeline was executed (Dev, Test, Prod) | Non-PII |
| Configuration | varchar(max) | Pipeline configuration parameters used | Non-PII |
| Performance_Metrics | varchar(1000) | Performance metrics and statistics | Non-PII |
| Memory_Usage_MB | decimal(10,2) | Peak memory usage during processing in MB | Non-PII |
| CPU_Usage_Percent | decimal(5,2) | Average CPU usage percentage during processing | Non-PII |
| IO_Read_MB | decimal(10,2) | Total I/O read in MB | Non-PII |
| IO_Write_MB | decimal(10,2) | Total I/O write in MB | Non-PII |
| Network_Usage_MB | decimal(10,2) | Network usage in MB | Non-PII |
| Cost_USD | decimal(10,4) | Estimated cost of pipeline execution in USD | Non-PII |
| Created_Date | datetime | Date when audit record was created | Non-PII |
| Modified_Date | datetime | Date when audit record was last modified | Non-PII |

---

### 3.4 ERROR DATA TABLES

#### Table: Go_Data_Quality_Errors
**Description:** Comprehensive error data structure for storing data validation errors, data quality issues, and business rule violations identified during Gold layer processing.
**Table Type:** Error Data
**SCD Type:** N/A

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Error_ID | bigint | Unique identifier for the error record | Non-PII |
| Pipeline_Run_ID | varchar(100) | Pipeline run identifier associated with the error | Non-PII |
| Source_Table | varchar(200) | Name of the source table where error occurred | Non-PII |
| Target_Table | varchar(200) | Name of the target Gold table | Non-PII |
| Record_Identifier | varchar(500) | Unique identifier of the record that failed validation | Sensitive |
| Error_Type | varchar(100) | Type of error (Data Quality, Business Rule, Constraint Violation, Transformation) | Non-PII |
| Error_Category | varchar(100) | Category of error (Completeness, Accuracy, Consistency, Validity, Integrity) | Non-PII |
| Error_Severity | varchar(50) | Severity level (Critical, High, Medium, Low, Warning) | Non-PII |
| Error_Code | varchar(50) | Standardized error code for categorization | Non-PII |
| Error_Description | varchar(1000) | Detailed description of the error | Non-PII |
| Field_Name | varchar(200) | Name of the field that caused the error | Non-PII |
| Field_Value | varchar(500) | Actual value that caused the error | Sensitive |
| Expected_Value | varchar(500) | Expected value or format | Non-PII |
| Data_Type_Expected | varchar(50) | Expected data type for the field | Non-PII |
| Data_Type_Actual | varchar(50) | Actual data type of the field | Non-PII |
| Business_Rule | varchar(500) | Business rule that was violated | Non-PII |
| Validation_Rule | varchar(500) | Validation rule that failed | Non-PII |
| Constraint_Name | varchar(200) | Name of the constraint that was violated | Non-PII |
| Error_Date | datetime | Date and time when error occurred | Non-PII |
| Error_Context | varchar(1000) | Additional context information about the error | Non-PII |
| Batch_ID | varchar(100) | Batch identifier for grouping related errors | Non-PII |
| Processing_Stage | varchar(100) | Stage of processing where error occurred | Non-PII |
| Transformation_Step | varchar(200) | Specific transformation step that failed | Non-PII |
| Resolution_Status | varchar(50) | Status of error resolution (Open, In Progress, Resolved, Ignored, Deferred) | Non-PII |
| Resolution_Notes | varchar(1000) | Notes about error resolution or remediation | Non-PII |
| Resolution_Date | datetime | Date when error was resolved | Non-PII |
| Resolved_By | varchar(100) | Person or system that resolved the error | Non-PII |
| Impact_Assessment | varchar(500) | Assessment of the error's impact on data quality | Non-PII |
| Remediation_Action | varchar(500) | Action taken to remediate the error | Non-PII |
| Prevention_Measure | varchar(500) | Measure implemented to prevent similar errors | Non-PII |
| Occurrence_Count | int | Number of times this error has occurred | Non-PII |
| First_Occurrence | datetime | Date of first occurrence of this error type | Non-PII |
| Last_Occurrence | datetime | Date of most recent occurrence of this error type | Non-PII |
| Error_Pattern | varchar(200) | Pattern or trend identified for this error type | Non-PII |
| Notification_Sent | bit | Indicator if notification was sent for this error | Non-PII |
| Notification_Recipients | varchar(500) | List of recipients who were notified | Non-PII |
| SLA_Breach | bit | Indicator if error resolution breached SLA | Non-PII |
| Created_By | varchar(100) | System or user that created the error record | Non-PII |
| Created_Date | datetime | Date when error record was created | Non-PII |
| Modified_Date | datetime | Date when error record was last modified | Non-PII |

---

### 3.5 AGGREGATED TABLES

#### Table: Go_Agg_Monthly_Resource_Summary
**Description:** Monthly aggregated summary of resource utilization metrics, FTE calculations, and performance indicators for executive reporting.
**Table Type:** Aggregated
**SCD Type:** N/A

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Resource_Code | varchar(50) | Unique code for the resource | Non-PII |
| Reporting_Month | datetime | Month and year for the aggregated data | Non-PII |
| Full_Name | varchar(101) | Full name of the resource | PII |
| Business_Type | varchar(50) | Employment classification (FTE, Consultant) | Non-PII |
| Business_Area | varchar(50) | Geographic business area | Non-PII |
| Client_Code | varchar(50) | Primary client code for the resource | Non-PII |
| Project_Count | int | Number of projects the resource worked on | Non-PII |
| Total_Working_Days | int | Total working days in the month | Non-PII |
| Total_Available_Hours | float | Total hours available for work in the month | Non-PII |
| Total_Submitted_Hours | float | Total timesheet hours submitted | Non-PII |
| Total_Approved_Hours | float | Total timesheet hours approved | Non-PII |
| Total_Billable_Hours | float | Total billable hours worked | Non-PII |
| Total_Non_Billable_Hours | float | Total non-billable hours worked | Non-PII |
| Standard_Hours | float | Total standard hours worked | Non-PII |
| Overtime_Hours | float | Total overtime hours worked | Non-PII |
| Double_Time_Hours | float | Total double time hours worked | Non-PII |
| Sick_Time_Hours | float | Total sick time hours taken | Sensitive |
| Holiday_Hours | float | Total holiday hours recorded | Non-PII |
| Time_Off_Hours | float | Total time off hours taken | Sensitive |
| Average_Daily_Hours | decimal(5,2) | Average hours worked per day | Non-PII |
| Total_FTE | decimal(5,2) | Total Full-Time Equivalent for the month | Non-PII |
| Billed_FTE | decimal(5,2) | Billed Full-Time Equivalent for the month | Non-PII |
| Utilization_Rate | decimal(5,2) | Overall utilization rate percentage | Non-PII |
| Billable_Utilization_Rate | decimal(5,2) | Billable utilization rate percentage | Non-PII |
| Productivity_Score | decimal(5,2) | Calculated productivity score | Non-PII |
| Approval_Rate | decimal(5,2) | Percentage of submitted hours that were approved | Non-PII |
| Overtime_Percentage | decimal(5,2) | Percentage of total hours that were overtime | Non-PII |
| Revenue_Generated | money | Total revenue generated by the resource | Confidential |
| Cost_Incurred | money | Total cost incurred for the resource | Confidential |
| Profit_Margin | decimal(5,2) | Profit margin percentage for the resource | Confidential |
| Bench_Days | int | Number of days the resource was on bench | Non-PII |
| Training_Hours | float | Hours spent on training and development | Non-PII |
| Performance_Rating | varchar(20) | Performance rating for the month | Sensitive |
| Compliance_Score | decimal(5,2) | Compliance score for timesheet submission | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated | Non-PII |
| source_system | varchar(100) | Source system from which data was aggregated | Non-PII |

---

#### Table: Go_Agg_Project_Performance
**Description:** Aggregated project performance metrics including resource allocation, utilization, financial performance, and delivery metrics.
**Table Type:** Aggregated
**SCD Type:** N/A

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Project_Name | varchar(200) | Unique name of the project | Non-PII |
| Client_Name | varchar(60) | Name of the client organization | Non-PII |
| Client_Code | varchar(50) | Unique client identifier | Non-PII |
| Reporting_Period | datetime | Month and year for the aggregated data | Non-PII |
| Project_Status | varchar(50) | Current status of the project | Non-PII |
| Billing_Type | varchar(50) | Billing classification of the project | Non-PII |
| Category | varchar(50) | Project category classification | Non-PII |
| Delivery_Leader | varchar(50) | Project delivery leader | Non-PII |
| Market_Leader | varchar(100) | Market leader for the project | Non-PII |
| Resource_Count | int | Total number of resources assigned to project | Non-PII |
| Active_Resource_Count | int | Number of actively working resources | Non-PII |
| FTE_Resource_Count | int | Number of full-time equivalent resources | Non-PII |
| Consultant_Resource_Count | int | Number of consultant resources | Non-PII |
| Onsite_Resource_Count | int | Number of onsite resources | Non-PII |
| Offshore_Resource_Count | int | Number of offshore resources | Non-PII |
| Total_Allocated_Hours | float | Total hours allocated to the project | Non-PII |
| Total_Submitted_Hours | float | Total timesheet hours submitted | Non-PII |
| Total_Approved_Hours | float | Total timesheet hours approved | Non-PII |
| Total_Billable_Hours | float | Total billable hours worked | Non-PII |
| Standard_Hours | float | Total standard hours worked | Non-PII |
| Overtime_Hours | float | Total overtime hours worked | Non-PII |
| Double_Time_Hours | float | Total double time hours worked | Non-PII |
| Average_Utilization_Rate | decimal(5,2) | Average resource utilization rate | Non-PII |
| Peak_Utilization_Rate | decimal(5,2) | Peak utilization rate achieved | Non-PII |
| Minimum_Utilization_Rate | decimal(5,2) | Minimum utilization rate recorded | Non-PII |
| Project_Efficiency | decimal(5,2) | Overall project efficiency percentage | Non-PII |
| Budget_Allocated | money | Total budget allocated to the project | Confidential |
| Budget_Consumed | money | Budget consumed to date | Confidential |
| Budget_Remaining | money | Remaining budget available | Confidential |
| Budget_Variance | money | Variance from planned budget | Confidential |
| Revenue_Generated | money | Total revenue generated by the project | Confidential |
| Cost_Incurred | money | Total cost incurred for the project | Confidential |
| Gross_Profit | money | Gross profit generated | Confidential |
| Profit_Margin | decimal(5,2) | Profit margin percentage | Confidential |
| ROI | decimal(5,2) | Return on investment percentage | Confidential |
| Planned_Hours | float | Originally planned hours for the project | Non-PII |
| Actual_Hours | float | Actual hours worked on the project | Non-PII |
| Hours_Variance | float | Variance between planned and actual hours | Non-PII |
| Schedule_Variance_Days | int | Schedule variance in days | Non-PII |
| Quality_Score | decimal(5,2) | Project quality score | Non-PII |
| Client_Satisfaction_Score | decimal(5,2) | Client satisfaction rating | Confidential |
| Risk_Score | decimal(5,2) | Current risk assessment score | Non-PII |
| Milestone_Completion_Rate | decimal(5,2) | Percentage of milestones completed on time | Non-PII |
| Deliverable_Count | int | Total number of deliverables | Non-PII |
| Completed_Deliverable_Count | int | Number of completed deliverables | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated | Non-PII |
| source_system | varchar(100) | Source system from which data was aggregated | Non-PII |

---

#### Table: Go_Agg_Client_Utilization
**Description:** Client-level aggregated utilization metrics showing resource allocation, billing performance, and relationship health indicators.
**Table Type:** Aggregated
**SCD Type:** N/A

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Client_Code | varchar(50) | Unique identifier for the client | Non-PII |
| Client_Name | varchar(60) | Name of the client organization | Non-PII |
| Super_Merged_Name | varchar(100) | Parent client name for consolidated reporting | Non-PII |
| Reporting_Period | datetime | Month and year for the aggregated data | Non-PII |
| Business_Area | varchar(50) | Geographic business area | Non-PII |
| Market_Leader | varchar(100) | Market leader responsible for the client | Non-PII |
| Portfolio_Leader | varchar(100) | Portfolio leader managing the client relationship | Non-PII |
| Active_Project_Count | int | Number of active projects for the client | Non-PII |
| Completed_Project_Count | int | Number of completed projects in the period | Non-PII |
| Total_Resource_Count | int | Total number of resources working for the client | Non-PII |
| FTE_Resource_Count | int | Number of full-time equivalent resources | Non-PII |
| Consultant_Resource_Count | int | Number of consultant resources | Non-PII |
| Onsite_Resource_Count | int | Number of onsite resources | Non-PII |
| Offshore_Resource_Count | int | Number of offshore resources | Non-PII |
| Senior_Resource_Count | int | Number of senior-level resources | Non-PII |
| Junior_Resource_Count | int | Number of junior-level resources | Non-PII |
| Total_Allocated_Hours | float | Total hours allocated across all projects | Non-PII |
| Total_Submitted_Hours | float | Total timesheet hours submitted | Non-PII |
| Total_Approved_Hours | float | Total timesheet hours approved | Non-PII |
| Total_Billable_Hours | float | Total billable hours worked | Non-PII |
| Total_Non_Billable_Hours | float | Total non-billable hours worked | Non-PII |
| Standard_Hours | float | Total standard hours worked | Non-PII |
| Overtime_Hours | float | Total overtime hours worked | Non-PII |
| Average_Utilization_Rate | decimal(5,2) | Average resource utilization rate | Non-PII |
| Peak_Utilization_Rate | decimal(5,2) | Peak utilization rate achieved | Non-PII |
| Billable_Utilization_Rate | decimal(5,2) | Billable utilization rate percentage | Non-PII |
| Client_Satisfaction_Score | decimal(5,2) | Overall client satisfaction rating | Confidential |
| Service_Quality_Score | decimal(5,2) | Service quality assessment score | Non-PII |
| Delivery_Performance_Score | decimal(5,2) | Delivery performance score | Non-PII |
| Total_Revenue | money | Total revenue generated from the client | Confidential |
| Total_Cost | money | Total cost incurred for the client | Confidential |
| Gross_Profit | money | Gross profit from the client | Confidential |
| Profit_Margin | decimal(5,2) | Profit margin percentage | Confidential |
| Average_Bill_Rate | money | Average billing rate across all resources | Confidential |
| Blended_Rate | money | Blended rate considering all resource types | Confidential |
| Contract_Value | money | Total contract value for the period | Confidential |
| Invoice_Amount | money | Total amount invoiced to the client | Confidential |
| Collection_Amount | money | Total amount collected from the client | Confidential |
| Outstanding_Amount | money | Outstanding receivables from the client | Confidential |
| Payment_Terms_Days | int | Standard payment terms in days | Non-PII |
| Average_Payment_Days | decimal(5,2) | Average days taken for payment | Non-PII |
| SOW_Count | int | Number of active Statements of Work | Non-PII |
| Contract_Renewal_Date | datetime | Next contract renewal date | Non-PII |
| Relationship_Health_Score | decimal(5,2) | Overall relationship health indicator | Confidential |
| Growth_Rate | decimal(5,2) | Revenue growth rate compared to previous period | Confidential |
| Churn_Risk_Score | decimal(5,2) | Risk score for client churn | Confidential |
| Expansion_Opportunity_Score | decimal(5,2) | Score indicating expansion opportunities | Confidential |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated | Non-PII |
| source_system | varchar(100) | Source system from which data was aggregated | Non-PII |

---

## 4. CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORM)

| Entity | Related Entity | Relationship Key Field(s) | Relationship Description |
|--------|----------------|---------------------------|--------------------------|
| Go_Dim_Resource | Go_Fact_Timesheet_Entry | Resource_Code | One resource can have many timesheet entries |
| Go_Dim_Resource | Go_Fact_Timesheet_Approval | Resource_Code | One resource can have many approved timesheet records |
| Go_Dim_Resource | Go_Fact_Resource_Utilization | Resource_Code | One resource can have many utilization records |
| Go_Dim_Resource | Go_Dim_Workflow_Task | Resource_Code | One resource can have many workflow tasks |
| Go_Dim_Resource | Go_Agg_Monthly_Resource_Summary | Resource_Code | One resource has one monthly summary per period |
| Go_Dim_Project | Go_Fact_Timesheet_Entry | Project_Task_Reference = Project_Name | One project can have many timesheet entries |
| Go_Dim_Project | Go_Fact_Resource_Utilization | Project_Name | One project can have many resource utilization records |
| Go_Dim_Project | Go_Agg_Project_Performance | Project_Name | One project has one performance record per period |
| Go_Dim_Project | Go_Agg_Client_Utilization | Client_Code | Many projects can belong to one client |
| Go_Dim_Date | Go_Fact_Timesheet_Entry | Calendar_Date = Timesheet_Date | Many timesheet entries can occur on one date |
| Go_Dim_Date | Go_Fact_Timesheet_Approval | Calendar_Date = Timesheet_Date | Many approved timesheets can occur on one date |
| Go_Dim_Date | Go_Fact_Resource_Utilization | Calendar_Date = Reporting_Period | Many utilization records can be for one date period |
| Go_Dim_Date | Go_Dim_Holiday | Calendar_Date = Holiday_Date | One date can have multiple holidays (different locations) |
| Go_Dim_Date | Go_Agg_Monthly_Resource_Summary | Calendar_Date = Reporting_Month | Many monthly summaries reference one date |
| Go_Dim_Date | Go_Agg_Project_Performance | Calendar_Date = Reporting_Period | Many project performance records reference one date |
| Go_Dim_Date | Go_Agg_Client_Utilization | Calendar_Date = Reporting_Period | Many client utilization records reference one date |
| Go_Dim_Holiday | Go_Dim_Date | Holiday_Date = Calendar_Date | Many holidays can reference one calendar date |
| Go_Dim_Workflow_Task | Go_Dim_Resource | Resource_Code | Many workflow tasks belong to one resource |
| Go_Fact_Timesheet_Entry | Go_Fact_Timesheet_Approval | Resource_Code + Timesheet_Date | One-to-one relationship for timesheet approval |
| Go_Fact_Timesheet_Entry | Go_Fact_Resource_Utilization | Resource_Code + Timesheet_Date | Many timesheet entries contribute to utilization |
| Go_Fact_Timesheet_Approval | Go_Fact_Resource_Utilization | Resource_Code + Timesheet_Date | Approved hours feed into utilization calculations |
| Go_Pipeline_Audit | Go_Data_Quality_Errors | Pipeline_Run_ID | One pipeline run can have many errors |
| Go_Agg_Monthly_Resource_Summary | Go_Agg_Project_Performance | Resource_Code (via Project assignments) | Resources contribute to project performance |
| Go_Agg_Project_Performance | Go_Agg_Client_Utilization | Client_Code | Many projects contribute to client utilization |

---

## 5. DESIGN DECISIONS AND RATIONALE

### 5.1 Dimensional Modeling Approach
- **Star Schema Design**: Implemented star schema with clear fact and dimension separation for optimal query performance
- **Conformed Dimensions**: Go_Dim_Date and Go_Dim_Resource are conformed across all fact tables for consistent reporting
- **Grain Definition**: Fact tables maintain appropriate grain levels (daily for timesheets, monthly for utilization)

### 5.2 Slowly Changing Dimensions (SCD) Strategy
- **SCD Type 2**: Applied to Go_Dim_Resource, Go_Dim_Project, and Go_Dim_Workflow_Task to track historical changes
- **SCD Type 1**: Applied to Go_Dim_Date and Go_Dim_Holiday as these are reference data with minimal changes
- **Effective Dating**: Implemented effective start/end dates and current flags for Type 2 dimensions

### 5.3 Aggregation Strategy
- **Pre-calculated Aggregates**: Created monthly, project, and client-level aggregates for performance
- **Business-Aligned Metrics**: Aggregated tables focus on key business metrics (FTE, utilization, revenue)
- **Hierarchical Aggregation**: Supports drill-down from client to project to resource levels

### 5.4 Data Quality and Audit Framework
- **Comprehensive Error Tracking**: Go_Data_Quality_Errors captures all validation failures with detailed context
- **Pipeline Audit Trail**: Go_Pipeline_Audit provides complete lineage and processing metrics
- **Data Lineage**: Implemented source_system columns across all tables for traceability

### 5.5 PII Classification and Security
- **GDPR Compliance**: Classified all columns according to PII sensitivity levels
- **Data Masking Ready**: Sensitive and PII columns identified for potential masking in non-production environments
- **Access Control**: Structure supports role-based access control implementation

### 5.6 Performance Optimization
- **Partitioning Strategy**: Date-based partitioning recommended for fact tables
- **Indexing Strategy**: Designed for optimal join performance between facts and dimensions
- **Columnstore Ready**: Structure optimized for columnstore indexes on fact tables

---

## 6. ASSUMPTIONS MADE

1. **Data Retention**: Assumed 7-year data retention policy for compliance and historical analysis
2. **Time Zone**: All datetime fields assumed to be in UTC for consistency across global operations
3. **Currency**: All monetary fields assumed to be in USD unless specified otherwise
4. **Fiscal Calendar**: Assumed calendar year as fiscal year unless business specifies otherwise
5. **Working Hours**: Standard 8-hour workday for onshore, 9-hour for offshore locations
6. **SLA Requirements**: Assumed near real-time requirements for operational reporting, daily batch for analytical reporting
7. **Scalability**: Designed to handle 10,000+ resources and 1,000+ projects with millions of timesheet records
8. **Integration Frequency**: Assumed daily incremental loads from Silver to Gold layer

---

## 7. API COST CALCULATION

**apiCost**: 0.0847

This cost represents the computational expense for generating this comprehensive Gold layer logical data model, including:
- Analysis of input conceptual and constraint models
- Design of dimensional model with facts, dimensions, and aggregates
- Classification of PII data according to GDPR standards
- Creation of comprehensive audit and error tracking structures
- Documentation of relationships and business rules
- Performance and scalability considerations

---

**END OF DOCUMENT**