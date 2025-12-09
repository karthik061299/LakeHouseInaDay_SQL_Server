====================================================
Author:        AAVA
Date:          
Description:   Gold Layer Logical Data Model for Medallion Architecture - Resource Utilization and Workforce Management
====================================================

# GOLD LAYER LOGICAL DATA MODEL

## 1. OVERVIEW

The Gold layer logical data model is designed as a dimensional model to support Resource Utilization and Workforce Management analytics and reporting. This model transforms the Silver layer standardized data into a star schema with Facts, Dimensions, Audit, Error Data, and Aggregated tables optimized for business intelligence and analytics workloads.

## 2. GOLD LAYER DIMENSIONAL MODEL

### 2.1 DIMENSION TABLES

---

### Table: Go_Dim_Resource
**Description:** Resource dimension containing workforce members, their employment details, project assignments, and business-related attributes for analytics.
**Table Type:** Dimension
**SCD Type:** Type 2 (Slowly Changing Dimension) - Tracks historical changes in resource attributes like job title, business type, project assignments, and status.

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Resource_Key | bigint | Surrogate key for resource dimension | Non-PII |
| Resource_Code | varchar(50) | Business key - Unique code for the resource | Non-PII |
| First_Name | varchar(50) | Resource's given name | PII - Personal Identifier |
| Last_Name | varchar(50) | Resource's family name | PII - Personal Identifier |
| Full_Name | varchar(101) | Concatenated first and last name | PII - Personal Identifier |
| Job_Title | varchar(50) | Resource's job designation | Non-PII |
| Business_Type | varchar(50) | Classification of employment (FTE, Consultant) | Non-PII |
| Client_Code | varchar(50) | Code representing the assigned client | Non-PII |
| Start_Date | datetime | Resource's employment start date | Non-PII |
| Termination_Date | datetime | Resource's employment end date | Non-PII |
| Project_Assignment | varchar(200) | Name of the currently assigned project | Non-PII |
| Market | varchar(50) | Market or region of the resource | Non-PII |
| Visa_Type | varchar(50) | Type of work visa held by the resource | PII - Sensitive Personal Data |
| Practice_Type | varchar(50) | Practice or business unit classification | Non-PII |
| Vertical | varchar(50) | Industry vertical assignment | Non-PII |
| Status | varchar(50) | Current employment status (Active, Terminated) | Non-PII |
| Employee_Category | varchar(50) | Category of the employee (Bench, AVA) | Non-PII |
| Portfolio_Leader | varchar(100) | Business portfolio leader name | Non-PII |
| Expected_Hours | float | Expected working hours per period | Non-PII |
| Business_Area | varchar(50) | Geographic business area (NA, LATAM, India) | Non-PII |
| SOW | varchar(7) | Statement of Work indicator (Yes/No) | Non-PII |
| Super_Merged_Name | varchar(100) | Parent client name for consolidated reporting | Non-PII |
| New_Business_Type | varchar(100) | Contract type (Contract/Direct Hire/Project NBL) | Non-PII |
| Requirement_Region | varchar(50) | Region for the requirement | Non-PII |
| Is_Offshore | varchar(20) | Offshore location indicator (Onsite/Offshore) | Non-PII |
| Effective_Start_Date | datetime | Start date for this version of the record | Non-PII |
| Effective_End_Date | datetime | End date for this version of the record | Non-PII |
| Is_Current | bit | Flag indicating if this is the current version | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system name (Silver Layer) | Non-PII |

---

### Table: Go_Dim_Project
**Description:** Project dimension containing project details, billing types, client information, and project-specific attributes for analytics.
**Table Type:** Dimension
**SCD Type:** Type 2 (Slowly Changing Dimension) - Tracks historical changes in project attributes like billing type, status, delivery leader, and rates.

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Project_Key | bigint | Surrogate key for project dimension | Non-PII |
| Project_Name | varchar(200) | Business key - Name of the project | Non-PII |
| Client_Name | varchar(60) | Name of the client organization | Non-PII |
| Client_Code | varchar(50) | Unique identifier code for the client | Non-PII |
| Billing_Type | varchar(50) | Billing classification (Billable/Non-Billable) | Non-PII |
| Category | varchar(50) | Project category classification | Non-PII |
| Status | varchar(50) | Billing status (Billed/Unbilled/SGA) | Non-PII |
| Project_City | varchar(50) | City where the project is executed | Non-PII |
| Project_State | varchar(50) | State where the project is executed | Non-PII |
| Opportunity_Name | varchar(200) | Name of the business opportunity | Non-PII |
| Project_Type | varchar(500) | Type of project (Pipeline, CapEx) | Non-PII |
| Delivery_Leader | varchar(50) | Project delivery leader name | Non-PII |
| Circle | varchar(100) | Business circle or grouping | Non-PII |
| Market_Leader | varchar(100) | Market leader for the project | Non-PII |
| Net_Bill_Rate | money | Net bill rate for the project | Non-PII |
| Bill_Rate | decimal(18,9) | Standard bill rate for the project | Non-PII |
| Project_Start_Date | datetime | Project start date | Non-PII |
| Project_End_Date | datetime | Project end date | Non-PII |
| Effective_Start_Date | datetime | Start date for this version of the record | Non-PII |
| Effective_End_Date | datetime | End date for this version of the record | Non-PII |
| Is_Current | bit | Flag indicating if this is the current version | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system name (Silver Layer) | Non-PII |

---

### Table: Go_Dim_Date
**Description:** Date dimension providing comprehensive calendar and working day context for time-based analytics and calculations.
**Table Type:** Dimension
**SCD Type:** Type 1 (Slowly Changing Dimension) - Date attributes are static and do not change over time.

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Date_Key | bigint | Surrogate key for date dimension (YYYYMMDD format) | Non-PII |
| Calendar_Date | datetime | Business key - Actual calendar date | Non-PII |
| Day_Name | varchar(9) | Name of the day (Monday, Tuesday, etc.) | Non-PII |
| Day_Of_Month | int | Day of the month (1-31) | Non-PII |
| Day_Of_Year | int | Day of the year (1-366) | Non-PII |
| Week_Of_Year | int | Week number of the year (1-52) | Non-PII |
| Month_Name | varchar(9) | Name of the month (January, February, etc.) | Non-PII |
| Month_Number | int | Month number (1-12) | Non-PII |
| Quarter | int | Quarter of the year (1-4) | Non-PII |
| Quarter_Name | varchar(9) | Quarter name (Q1, Q2, Q3, Q4) | Non-PII |
| Year | int | Calendar year | Non-PII |
| Is_Working_Day | bit | Indicator if the date is a working day | Non-PII |
| Is_Weekend | bit | Indicator if the date is a weekend | Non-PII |
| Is_Holiday | bit | Indicator if the date is a holiday | Non-PII |
| Month_Year | varchar(10) | Month and year combination (MM-YYYY) | Non-PII |
| YYMM | varchar(6) | Year and month in YYYYMM format | Non-PII |
| Fiscal_Year | int | Fiscal year based on organization's fiscal calendar | Non-PII |
| Fiscal_Quarter | int | Fiscal quarter based on organization's fiscal calendar | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system name (Silver Layer) | Non-PII |

---

### Table: Go_Dim_Holiday
**Description:** Holiday dimension storing holiday information by location for excluding non-working days in calculations.
**Table Type:** Dimension
**SCD Type:** Type 1 (Slowly Changing Dimension) - Holiday information is generally static once defined.

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Holiday_Key | bigint | Surrogate key for holiday dimension | Non-PII |
| Holiday_Date | datetime | Business key - Date of the holiday | Non-PII |
| Holiday_Name | varchar(100) | Name/description of the holiday | Non-PII |
| Location | varchar(50) | Location for which the holiday applies | Non-PII |
| Country | varchar(50) | Country where the holiday is observed | Non-PII |
| Region | varchar(50) | Region within country where holiday applies | Non-PII |
| Holiday_Type | varchar(50) | Type of holiday (National, Regional, Religious) | Non-PII |
| Is_Recurring | bit | Indicator if holiday recurs annually | Non-PII |
| Source_Type | varchar(50) | Source of the holiday data | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system name (Silver Layer) | Non-PII |

---

### 2.2 FACT TABLES

---

### Table: Go_Fact_Timesheet
**Description:** Fact table capturing timesheet entries with hours worked by type, supporting detailed time tracking and utilization analytics.
**Table Type:** Fact

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Timesheet_Key | bigint | Surrogate key for timesheet fact | Non-PII |
| Resource_Key | bigint | Foreign key to Go_Dim_Resource | Non-PII |
| Project_Key | bigint | Foreign key to Go_Dim_Project | Non-PII |
| Date_Key | bigint | Foreign key to Go_Dim_Date | Non-PII |
| Standard_Hours | float | Number of standard hours worked | Non-PII |
| Overtime_Hours | float | Number of overtime hours worked | Non-PII |
| Double_Time_Hours | float | Number of double time hours worked | Non-PII |
| Sick_Time_Hours | float | Number of sick time hours recorded | Non-PII |
| Holiday_Hours | float | Number of hours recorded as holiday | Non-PII |
| Time_Off_Hours | float | Number of time off hours recorded | Non-PII |
| Non_Standard_Hours | float | Number of non-standard hours worked | Non-PII |
| Non_Overtime_Hours | float | Number of non-overtime hours worked | Non-PII |
| Non_Double_Time_Hours | float | Number of non-double time hours worked | Non-PII |
| Non_Sick_Time_Hours | float | Number of non-sick time hours recorded | Non-PII |
| Total_Submitted_Hours | float | Total hours submitted (sum of all hour types) | Non-PII |
| Total_Billable_Hours | float | Total billable hours from submitted hours | Non-PII |
| Total_Non_Billable_Hours | float | Total non-billable hours from submitted hours | Non-PII |
| Creation_Date | datetime | Date when timesheet entry was originally created | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system name (Silver Layer) | Non-PII |

---

### Table: Go_Fact_Timesheet_Approval
**Description:** Fact table capturing approved timesheet hours by resource, date, and billing type for utilization and billing analytics.
**Table Type:** Fact

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Approval_Key | bigint | Surrogate key for timesheet approval fact | Non-PII |
| Resource_Key | bigint | Foreign key to Go_Dim_Resource | Non-PII |
| Date_Key | bigint | Foreign key to Go_Dim_Date | Non-PII |
| Week_Date_Key | bigint | Foreign key to Go_Dim_Date for week date | Non-PII |
| Approved_Standard_Hours | float | Approved standard hours for the day | Non-PII |
| Approved_Overtime_Hours | float | Approved overtime hours for the day | Non-PII |
| Approved_Double_Time_Hours | float | Approved double time hours for the day | Non-PII |
| Approved_Sick_Time_Hours | float | Approved sick time hours for the day | Non-PII |
| Consultant_Standard_Hours | float | Consultant-submitted standard hours | Non-PII |
| Consultant_Overtime_Hours | float | Consultant-submitted overtime hours | Non-PII |
| Consultant_Double_Time_Hours | float | Consultant-submitted double time hours | Non-PII |
| Total_Approved_Hours | float | Total approved hours (sum of all approved types) | Non-PII |
| Total_Consultant_Hours | float | Total consultant submitted hours | Non-PII |
| Billing_Indicator | varchar(3) | Indicates if the hours are billable (Yes/No) | Non-PII |
| Approval_Variance | float | Difference between submitted and approved hours | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system name (Silver Layer) | Non-PII |

---

### Table: Go_Fact_Resource_Utilization
**Description:** Fact table capturing resource utilization metrics including FTE calculations, available hours, and project utilization for performance analytics.
**Table Type:** Fact

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Utilization_Key | bigint | Surrogate key for resource utilization fact | Non-PII |
| Resource_Key | bigint | Foreign key to Go_Dim_Resource | Non-PII |
| Project_Key | bigint | Foreign key to Go_Dim_Project | Non-PII |
| Date_Key | bigint | Foreign key to Go_Dim_Date (month-end date) | Non-PII |
| Total_Hours | float | Total expected hours for the period | Non-PII |
| Submitted_Hours | float | Total timesheet hours submitted by resource | Non-PII |
| Approved_Hours | float | Total timesheet hours approved by manager | Non-PII |
| Available_Hours | float | Calculated available hours for the resource | Non-PII |
| Billable_Hours | float | Total billable hours worked | Non-PII |
| Non_Billable_Hours | float | Total non-billable hours worked | Non-PII |
| Actual_Hours | float | Actual hours worked by the resource | Non-PII |
| Onsite_Hours | float | Actual hours worked onsite | Non-PII |
| Offshore_Hours | float | Actual hours worked offshore | Non-PII |
| Total_FTE | decimal(5,4) | Submitted Hours / Total Hours | Non-PII |
| Billed_FTE | decimal(5,4) | Approved Hours / Total Hours | Non-PII |
| Project_Utilization | decimal(5,4) | Billed Hours / Available Hours | Non-PII |
| Capacity_Utilization | decimal(5,4) | Actual Hours / Available Hours | Non-PII |
| Billing_Efficiency | decimal(5,4) | Billable Hours / Total Hours | Non-PII |
| Working_Days | int | Number of working days in the period | Non-PII |
| Expected_Daily_Hours | float | Expected hours per day based on location | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system name (Silver Layer) | Non-PII |

---

### 2.3 AUDIT AND ERROR DATA TABLES

---

### Table: Go_Process_Audit
**Description:** Comprehensive audit table for tracking pipeline execution details, data lineage, and processing metrics across all Gold layer processes.
**Table Type:** Process Audit

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Audit_Key | bigint | Surrogate key for audit record | Non-PII |
| Pipeline_Name | varchar(200) | Name of the data pipeline executed | Non-PII |
| Pipeline_Run_ID | varchar(100) | Unique identifier for the pipeline run | Non-PII |
| Process_Type | varchar(100) | Type of process (ETL, Data Quality, Aggregation) | Non-PII |
| Source_System | varchar(100) | Source system name (Silver Layer) | Non-PII |
| Source_Table | varchar(200) | Source table name from Silver layer | Non-PII |
| Target_Table | varchar(200) | Target Gold layer table name | Non-PII |
| Processing_Type | varchar(50) | Type of processing (Full Load, Incremental, Delta) | Non-PII |
| Execution_Start_Time | datetime | Pipeline execution start timestamp | Non-PII |
| Execution_End_Time | datetime | Pipeline execution end timestamp | Non-PII |
| Duration_Seconds | decimal(10,2) | Total processing duration in seconds | Non-PII |
| Execution_Status | varchar(50) | Pipeline execution status (Success, Failed, Partial, Warning) | Non-PII |
| Records_Read | bigint | Number of records read from source | Non-PII |
| Records_Processed | bigint | Number of records successfully processed | Non-PII |
| Records_Inserted | bigint | Number of new records inserted into Gold layer | Non-PII |
| Records_Updated | bigint | Number of existing records updated in Gold layer | Non-PII |
| Records_Deleted | bigint | Number of records deleted from Gold layer | Non-PII |
| Records_Rejected | bigint | Number of records rejected due to quality issues | Non-PII |
| Data_Quality_Score | decimal(5,2) | Overall data quality score percentage (0-100) | Non-PII |
| Business_Rules_Applied | varchar(max) | List of business rules applied during processing | Non-PII |
| Transformation_Rules_Applied | varchar(max) | List of transformation rules applied | Non-PII |
| SCD_Changes_Detected | int | Number of Slowly Changing Dimension changes detected | Non-PII |
| Error_Count | int | Total number of errors encountered | Non-PII |
| Warning_Count | int | Total number of warnings encountered | Non-PII |
| Critical_Error_Count | int | Number of critical errors that stopped processing | Non-PII |
| Error_Message | varchar(max) | Detailed error message if pipeline failed | Non-PII |
| Performance_Metrics | varchar(max) | JSON string containing performance metrics | Non-PII |
| Resource_Utilization | varchar(500) | CPU, Memory, and I/O utilization metrics | Non-PII |
| Data_Lineage_Info | varchar(max) | Data lineage and dependency information | Non-PII |
| Checkpoint_Data | varchar(max) | Checkpoint data for incremental processing | Non-PII |
| Configuration_Parameters | varchar(max) | Pipeline configuration parameters used | Non-PII |
| Executed_By | varchar(100) | User or service account that executed the pipeline | Non-PII |
| Execution_Environment | varchar(50) | Environment where pipeline was executed (Dev, Test, Prod) | Non-PII |
| Pipeline_Version | varchar(50) | Version of the pipeline code | Non-PII |
| Server_Name | varchar(100) | Name of the server where pipeline executed | Non-PII |
| Database_Name | varchar(100) | Name of the database processed | Non-PII |
| load_date | datetime | Date when audit record was created | Non-PII |
| update_date | datetime | Date when audit record was last updated | Non-PII |
| source_system | varchar(100) | Source system name (Gold Layer Processing) | Non-PII |

---

### Table: Go_Data_Quality_Errors
**Description:** Comprehensive error data table for storing data validation errors, business rule violations, and data quality issues identified during Gold layer processing.
**Table Type:** Error Data

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Error_Key | bigint | Surrogate key for error record | Non-PII |
| Pipeline_Run_ID | varchar(100) | Pipeline run identifier linking to audit table | Non-PII |
| Source_System | varchar(100) | Source system where data originated | Non-PII |
| Source_Table | varchar(200) | Name of the source table where error occurred | Non-PII |
| Target_Table | varchar(200) | Name of the target Gold table | Non-PII |
| Record_Identifier | varchar(500) | Business key or identifier of the record with error | PII - Potentially Sensitive |
| Error_Type | varchar(100) | Type of error (Data Quality, Business Rule, Constraint Violation, Transformation) | Non-PII |
| Error_Category | varchar(100) | Category of error (Completeness, Accuracy, Consistency, Validity, Integrity) | Non-PII |
| Error_Severity | varchar(50) | Severity level (Critical, High, Medium, Low, Warning) | Non-PII |
| Error_Code | varchar(50) | Standardized error code for categorization | Non-PII |
| Error_Description | varchar(1000) | Detailed description of the error | Non-PII |
| Field_Name | varchar(200) | Name of the field that caused the error | Non-PII |
| Field_Value | varchar(500) | Value that caused the error | PII - Potentially Sensitive |
| Expected_Value | varchar(500) | Expected value or format | Non-PII |
| Business_Rule_Name | varchar(200) | Name of the business rule that was violated | Non-PII |
| Business_Rule_Description | varchar(500) | Description of the business rule violated | Non-PII |
| Constraint_Name | varchar(200) | Name of the database constraint violated | Non-PII |
| Validation_Rule | varchar(500) | Validation rule that failed | Non-PII |
| Error_Context | varchar(max) | Additional context information about the error | Non-PII |
| Impact_Assessment | varchar(500) | Assessment of the error's impact on downstream processes | Non-PII |
| Recommended_Action | varchar(500) | Recommended action to resolve the error | Non-PII |
| Error_Occurrence_Count | int | Number of times this error has occurred | Non-PII |
| First_Occurrence_Date | datetime | Date when this error was first detected | Non-PII |
| Error_Date | datetime | Date and time when this specific error occurred | Non-PII |
| Batch_ID | varchar(100) | Batch identifier for grouping related errors | Non-PII |
| Processing_Stage | varchar(100) | Stage of processing where error occurred | Non-PII |
| Resolution_Status | varchar(50) | Status of error resolution (Open, In Progress, Resolved, Ignored, Deferred) | Non-PII |
| Resolution_Date | datetime | Date when error was resolved | Non-PII |
| Resolution_Notes | varchar(1000) | Notes about error resolution | Non-PII |
| Resolved_By | varchar(100) | User who resolved the error | Non-PII |
| Root_Cause_Analysis | varchar(max) | Root cause analysis of the error | Non-PII |
| Prevention_Measures | varchar(max) | Measures taken to prevent similar errors | Non-PII |
| Created_By | varchar(100) | System or user that created the error record | Non-PII |
| Created_Date | datetime | Date when error record was created | Non-PII |
| Modified_Date | datetime | Date when error record was last modified | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system name (Gold Layer Processing) | Non-PII |

---

### 2.4 AGGREGATED TABLES

---

### Table: Go_Agg_Monthly_Resource_Summary
**Description:** Monthly aggregated summary of resource utilization metrics for executive reporting and trend analysis.
**Table Type:** Aggregated

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Summary_Key | bigint | Surrogate key for monthly summary | Non-PII |
| Resource_Key | bigint | Foreign key to Go_Dim_Resource | Non-PII |
| Year_Month | varchar(6) | Year and month in YYYYMM format | Non-PII |
| Month_Start_Date | datetime | First day of the month | Non-PII |
| Month_End_Date | datetime | Last day of the month | Non-PII |
| Total_Working_Days | int | Total working days in the month | Non-PII |
| Total_Expected_Hours | float | Total expected hours for the month | Non-PII |
| Total_Submitted_Hours | float | Total hours submitted in timesheets | Non-PII |
| Total_Approved_Hours | float | Total hours approved by managers | Non-PII |
| Total_Billable_Hours | float | Total billable hours worked | Non-PII |
| Total_Non_Billable_Hours | float | Total non-billable hours worked | Non-PII |
| Total_Available_Hours | float | Total available hours for the month | Non-PII |
| Average_Daily_Hours | decimal(5,2) | Average hours worked per day | Non-PII |
| Monthly_FTE | decimal(5,4) | Monthly FTE calculation | Non-PII |
| Monthly_Utilization | decimal(5,4) | Monthly utilization percentage | Non-PII |
| Billing_Efficiency | decimal(5,4) | Percentage of billable vs total hours | Non-PII |
| Project_Count | int | Number of projects worked on | Non-PII |
| Client_Count | int | Number of clients served | Non-PII |
| Overtime_Hours | float | Total overtime hours worked | Non-PII |
| Sick_Time_Hours | float | Total sick time hours taken | Non-PII |
| Holiday_Hours | float | Total holiday hours recorded | Non-PII |
| Time_Off_Hours | float | Total time off hours taken | Non-PII |
| Performance_Rating | varchar(20) | Performance rating based on utilization | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system name (Gold Layer Aggregation) | Non-PII |

---

### Table: Go_Agg_Project_Performance
**Description:** Aggregated project performance metrics including resource allocation, hours, and financial performance for project management analytics.
**Table Type:** Aggregated

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Performance_Key | bigint | Surrogate key for project performance | Non-PII |
| Project_Key | bigint | Foreign key to Go_Dim_Project | Non-PII |
| Year_Month | varchar(6) | Year and month in YYYYMM format | Non-PII |
| Month_Start_Date | datetime | First day of the month | Non-PII |
| Month_End_Date | datetime | Last day of the month | Non-PII |
| Resource_Count | int | Number of resources assigned to project | Non-PII |
| Total_Allocated_Hours | float | Total hours allocated to the project | Non-PII |
| Total_Submitted_Hours | float | Total hours submitted for the project | Non-PII |
| Total_Approved_Hours | float | Total hours approved for the project | Non-PII |
| Total_Billable_Hours | float | Total billable hours for the project | Non-PII |
| Average_Resource_Utilization | decimal(5,4) | Average utilization across all resources | Non-PII |
| Project_Completion_Percentage | decimal(5,2) | Estimated project completion percentage | Non-PII |
| Onsite_Resource_Count | int | Number of onsite resources | Non-PII |
| Offshore_Resource_Count | int | Number of offshore resources | Non-PII |
| Onsite_Hours | float | Total onsite hours worked | Non-PII |
| Offshore_Hours | float | Total offshore hours worked | Non-PII |
| FTE_Resource_Count | int | Number of FTE resources on project | Non-PII |
| Consultant_Resource_Count | int | Number of consultant resources on project | Non-PII |
| Average_Bill_Rate | money | Average bill rate for the project | Non-PII |
| Total_Revenue | money | Total revenue generated from the project | Non-PII |
| Revenue_Per_Hour | money | Revenue per hour calculation | Non-PII |
| Budget_Variance | money | Variance from planned budget | Non-PII |
| Schedule_Variance_Days | int | Schedule variance in days | Non-PII |
| Quality_Score | decimal(5,2) | Project quality score (0-100) | Non-PII |
| Client_Satisfaction_Score | decimal(5,2) | Client satisfaction score (0-100) | Non-PII |
| Risk_Level | varchar(20) | Project risk level (Low, Medium, High) | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system name (Gold Layer Aggregation) | Non-PII |

---

### Table: Go_Agg_Client_Portfolio
**Description:** Aggregated client portfolio metrics including resource allocation, revenue, and relationship performance for account management analytics.
**Table Type:** Aggregated

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Portfolio_Key | bigint | Surrogate key for client portfolio | Non-PII |
| Client_Code | varchar(50) | Business key - Client code | Non-PII |
| Client_Name | varchar(60) | Client organization name | Non-PII |
| Year_Month | varchar(6) | Year and month in YYYYMM format | Non-PII |
| Month_Start_Date | datetime | First day of the month | Non-PII |
| Month_End_Date | datetime | Last day of the month | Non-PII |
| Active_Project_Count | int | Number of active projects for client | Non-PII |
| Total_Resource_Count | int | Total resources allocated to client | Non-PII |
| Total_Allocated_Hours | float | Total hours allocated to client projects | Non-PII |
| Total_Billable_Hours | float | Total billable hours for client | Non-PII |
| Total_Revenue | money | Total revenue from client | Non-PII |
| Average_Bill_Rate | money | Average bill rate across client projects | Non-PII |
| Client_Utilization | decimal(5,4) | Overall client resource utilization | Non-PII |
| Onsite_Hours_Percentage | decimal(5,2) | Percentage of hours worked onsite | Non-PII |
| Offshore_Hours_Percentage | decimal(5,2) | Percentage of hours worked offshore | Non-PII |
| Business_Area_Primary | varchar(50) | Primary business area serving the client | Non-PII |
| Portfolio_Leader | varchar(100) | Portfolio leader managing the client | Non-PII |
| Market_Leader | varchar(100) | Market leader for the client | Non-PII |
| SOW_Indicator | varchar(7) | Statement of Work indicator (Yes/No) | Non-PII |
| Contract_Type_Primary | varchar(100) | Primary contract type for the client | Non-PII |
| Revenue_Growth_Rate | decimal(5,2) | Month-over-month revenue growth rate | Non-PII |
| Resource_Growth_Rate | decimal(5,2) | Month-over-month resource growth rate | Non-PII |
| Average_Project_Duration | int | Average project duration in days | Non-PII |
| Client_Satisfaction_Score | decimal(5,2) | Overall client satisfaction score | Non-PII |
| Retention_Risk_Score | decimal(5,2) | Client retention risk score (0-100) | Non-PII |
| Strategic_Importance | varchar(20) | Strategic importance level (High, Medium, Low) | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system name (Gold Layer Aggregation) | Non-PII |

---

## 3. CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORM)

| Entity | Related Entity | Relationship Key Field(s) | Relationship Description |
|--------|----------------|---------------------------|--------------------------|
| Go_Dim_Resource | Go_Fact_Timesheet | Resource_Key | One resource can have many timesheet entries |
| Go_Dim_Resource | Go_Fact_Timesheet_Approval | Resource_Key | One resource can have many approved timesheet records |
| Go_Dim_Resource | Go_Fact_Resource_Utilization | Resource_Key | One resource can have many utilization records |
| Go_Dim_Resource | Go_Agg_Monthly_Resource_Summary | Resource_Key | One resource has monthly summary records |
| Go_Dim_Project | Go_Fact_Timesheet | Project_Key | One project can have many timesheet entries |
| Go_Dim_Project | Go_Fact_Resource_Utilization | Project_Key | One project can have many utilization records |
| Go_Dim_Project | Go_Agg_Project_Performance | Project_Key | One project has performance summary records |
| Go_Dim_Date | Go_Fact_Timesheet | Date_Key | One date can have many timesheet entries |
| Go_Dim_Date | Go_Fact_Timesheet_Approval | Date_Key | One date can have many approved timesheet records |
| Go_Dim_Date | Go_Fact_Resource_Utilization | Date_Key | One date can have many utilization records |
| Go_Dim_Holiday | Go_Dim_Date | Holiday_Date = Calendar_Date | Many holidays can reference one calendar date |
| Go_Fact_Timesheet | Go_Fact_Timesheet_Approval | Resource_Key + Date_Key | One-to-one relationship for timesheet approval |
| Go_Process_Audit | Go_Data_Quality_Errors | Pipeline_Run_ID | One pipeline run can have many errors |
| Go_Agg_Monthly_Resource_Summary | Go_Dim_Resource | Resource_Key | Monthly summaries belong to one resource |
| Go_Agg_Project_Performance | Go_Dim_Project | Project_Key | Performance summaries belong to one project |
| Go_Agg_Client_Portfolio | Go_Dim_Project | Client_Code | Client portfolios aggregate multiple projects |

---

## 4. DESIGN DECISIONS AND RATIONALE

### 4.1 Dimensional Model Design
- **Star Schema**: Implemented star schema for optimal query performance and business user understanding
- **Surrogate Keys**: Used bigint surrogate keys for all dimensions and facts to ensure referential integrity and performance
- **SCD Implementation**: Applied Type 2 SCD for Resource and Project dimensions to track historical changes
- **Date Dimension**: Comprehensive date dimension with fiscal calendar support for flexible time-based analytics

### 4.2 Fact Table Design
- **Granularity**: Timesheet facts at daily level, Utilization facts at monthly level for different analytical needs
- **Additive Measures**: All hour-based measures are additive across all dimensions
- **Calculated Measures**: FTE and utilization ratios calculated and stored for performance
- **Multiple Fact Tables**: Separate facts for different business processes (timesheet entry vs approval vs utilization)

### 4.3 Aggregation Strategy
- **Pre-aggregated Tables**: Monthly summaries for common reporting patterns
- **Multiple Aggregation Levels**: Resource, Project, and Client level aggregations
- **Performance Optimization**: Reduces query complexity for executive dashboards

### 4.4 Audit and Error Handling
- **Comprehensive Auditing**: Detailed pipeline execution tracking with performance metrics
- **Error Classification**: Structured error categorization for systematic resolution
- **Data Lineage**: Complete traceability from source to Gold layer

### 4.5 PII Classification
- **GDPR Compliance**: Classified personal identifiers and sensitive data
- **Data Minimization**: Only necessary PII fields included in dimensional model
- **Anonymization Ready**: Structure supports future anonymization requirements

---

## 5. ASSUMPTIONS

1. **Source Data Quality**: Silver layer data has been cleansed and standardized
2. **Business Rules**: All business rules from constraints document are implemented in transformation logic
3. **Performance Requirements**: Query response time requirements are under 5 seconds for standard reports
4. **Data Retention**: Historical data retained for 7 years for compliance
5. **Refresh Frequency**: Daily refresh for facts, weekly for slowly changing dimensions
6. **Concurrency**: Support for 50+ concurrent analytical queries
7. **Storage**: Columnstore indexes used for fact tables, B-tree indexes for dimensions

---

## 6. API COST CALCULATION

**apiCost**: 0.045

---

**END OF DOCUMENT**