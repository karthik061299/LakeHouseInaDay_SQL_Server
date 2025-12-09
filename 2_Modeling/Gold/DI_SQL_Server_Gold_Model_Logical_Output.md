====================================================
Author:        AAVA
Date:          
Description:   Gold Layer Logical Data Model for Medallion Architecture - Resource Utilization and Workforce Management
====================================================

# GOLD LAYER LOGICAL DATA MODEL

## 1. OVERVIEW

The Gold layer logical data model represents the final consumption-ready layer in the medallion architecture for Resource Utilization and Workforce Management. This model is designed as a dimensional model with Facts, Dimensions, Audit, Error Data, and Aggregated tables to support efficient querying, reporting, and analytics. The model follows star schema principles and includes Slowly Changing Dimension (SCD) implementations for historical tracking.

## 2. GOLD LAYER DIMENSIONAL MODEL

### 2.1 DIMENSION TABLES

#### Table: Go_Dim_Resource
**Description:** Dimension table containing resource master data with historical tracking capabilities
**Table Type:** Dimension
**SCD Type:** Type 2 (Historical tracking for employment changes, project assignments, and status changes)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Resource_Key | bigint | Surrogate key for the resource dimension | Non-PII |
| Resource_Code | varchar(50) | Business key - Unique code for the resource | Non-PII |
| First_Name | varchar(50) | Resource's given name | PII - Personal Identifier |
| Last_Name | varchar(50) | Resource's family name | PII - Personal Identifier |
| Full_Name | varchar(101) | Concatenated first and last name | PII - Personal Identifier |
| Job_Title | varchar(50) | Resource's job designation | Non-PII |
| Business_Type | varchar(50) | Classification of employment (FTE, Consultant) | Non-PII |
| Client_Code | varchar(50) | Code representing the assigned client | Non-PII |
| Employment_Start_Date | datetime | Resource's employment start date | Non-PII |
| Employment_End_Date | datetime | Resource's employment end date | Non-PII |
| Current_Project_Assignment | varchar(200) | Name of the currently assigned project | Non-PII |
| Market_Region | varchar(50) | Market or region of the resource | Non-PII |
| Visa_Type | varchar(50) | Type of work visa held by the resource | PII - Sensitive Personal Data |
| Practice_Type | varchar(50) | Practice or business unit classification | Non-PII |
| Industry_Vertical | varchar(50) | Industry vertical specialization | Non-PII |
| Employment_Status | varchar(50) | Current employment status (Active, Terminated) | Non-PII |
| Employee_Category | varchar(50) | Category classification (Bench, AVA, Billable) | Non-PII |
| Portfolio_Leader | varchar(100) | Assigned business portfolio leader | Non-PII |
| Expected_Daily_Hours | float | Expected working hours per day | Non-PII |
| Business_Area | varchar(50) | Geographic business area (NA, LATAM, India) | Non-PII |
| SOW_Indicator | varchar(7) | Statement of Work participation indicator | Non-PII |
| Parent_Client_Name | varchar(100) | Parent client name for consolidated reporting | Non-PII |
| Engagement_Type | varchar(100) | Type of engagement (Contract, Direct Hire, Project NBL) | Non-PII |
| Requirement_Region | varchar(50) | Geographic region for the requirement | Non-PII |
| Location_Type | varchar(20) | Offshore/Onshore location indicator | Non-PII |
| Effective_Start_Date | datetime | Start date for this version of the record | Non-PII |
| Effective_End_Date | datetime | End date for this version of the record | Non-PII |
| Is_Current_Record | bit | Flag indicating if this is the current active record | Non-PII |
| Record_Source | varchar(100) | Source system that provided this record | Non-PII |
| Load_Date | datetime | Date when record was loaded into Gold layer | Non-PII |
| Update_Date | datetime | Date when record was last updated | Non-PII |

---

#### Table: Go_Dim_Project
**Description:** Dimension table containing project information with historical tracking for project changes
**Table Type:** Dimension
**SCD Type:** Type 2 (Historical tracking for project status, billing type, and assignment changes)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Project_Key | bigint | Surrogate key for the project dimension | Non-PII |
| Project_Code | varchar(200) | Business key - Unique project identifier | Non-PII |
| Project_Name | varchar(200) | Full name of the project | Non-PII |
| Client_Name | varchar(60) | Name of the client organization | Non-PII |
| Client_Code | varchar(50) | Unique identifier code for the client | Non-PII |
| Billing_Classification | varchar(50) | Billing type classification (Billable/Non-Billable) | Non-PII |
| Project_Category | varchar(50) | Project category (India Billing - Client-NBL, etc.) | Non-PII |
| Billing_Status | varchar(50) | Current billing status (Billed/Unbilled/SGA) | Non-PII |
| Project_City | varchar(50) | City where project is executed | Non-PII |
| Project_State | varchar(50) | State where project is executed | Non-PII |
| Business_Opportunity | varchar(200) | Associated business opportunity name | Non-PII |
| Project_Type | varchar(500) | Type classification (Pipeline, CapEx, etc.) | Non-PII |
| Delivery_Leader | varchar(50) | Assigned project delivery leader | Non-PII |
| Business_Circle | varchar(100) | Business circle or organizational grouping | Non-PII |
| Market_Leader | varchar(100) | Assigned market leader for the project | Non-PII |
| Net_Bill_Rate | money | Net billing rate for the project | Non-PII |
| Standard_Bill_Rate | decimal(18,9) | Standard billing rate | Non-PII |
| Project_Start_Date | datetime | Official project start date | Non-PII |
| Project_End_Date | datetime | Official project end date | Non-PII |
| Is_Active_Project | bit | Flag indicating if project is currently active | Non-PII |
| Effective_Start_Date | datetime | Start date for this version of the record | Non-PII |
| Effective_End_Date | datetime | End date for this version of the record | Non-PII |
| Is_Current_Record | bit | Flag indicating if this is the current active record | Non-PII |
| Record_Source | varchar(100) | Source system that provided this record | Non-PII |
| Load_Date | datetime | Date when record was loaded into Gold layer | Non-PII |
| Update_Date | datetime | Date when record was last updated | Non-PII |

---

#### Table: Go_Dim_Date
**Description:** Date dimension providing comprehensive calendar context for time-based analysis
**Table Type:** Dimension
**SCD Type:** Type 1 (Static reference data, no historical tracking needed)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Date_Key | bigint | Surrogate key for the date dimension | Non-PII |
| Calendar_Date | datetime | Actual calendar date | Non-PII |
| Day_Name | varchar(9) | Full name of the day (Monday, Tuesday, etc.) | Non-PII |
| Day_Name_Short | varchar(3) | Abbreviated day name (Mon, Tue, etc.) | Non-PII |
| Day_Of_Month | int | Day number within the month (1-31) | Non-PII |
| Day_Of_Year | int | Day number within the year (1-366) | Non-PII |
| Week_Of_Year | int | Week number within the year (1-53) | Non-PII |
| Month_Name | varchar(9) | Full name of the month | Non-PII |
| Month_Name_Short | varchar(3) | Abbreviated month name (Jan, Feb, etc.) | Non-PII |
| Month_Number | int | Month number (1-12) | Non-PII |
| Quarter_Number | int | Quarter number (1-4) | Non-PII |
| Quarter_Name | varchar(9) | Quarter name (Q1, Q2, Q3, Q4) | Non-PII |
| Year_Number | int | Four-digit year number | Non-PII |
| Is_Working_Day | bit | Indicator if the date is a standard working day | Non-PII |
| Is_Weekend | bit | Indicator if the date falls on weekend | Non-PII |
| Is_Holiday | bit | Indicator if the date is a recognized holiday | Non-PII |
| Month_Year_Text | varchar(10) | Month and year in text format (Jan-2024) | Non-PII |
| Year_Month_Number | int | Year and month in numeric format (202401) | Non-PII |
| Fiscal_Year | int | Fiscal year number | Non-PII |
| Fiscal_Quarter | int | Fiscal quarter number | Non-PII |
| Record_Source | varchar(100) | Source system that provided this record | Non-PII |
| Load_Date | datetime | Date when record was loaded into Gold layer | Non-PII |
| Update_Date | datetime | Date when record was last updated | Non-PII |

---

#### Table: Go_Dim_Holiday
**Description:** Holiday dimension containing location-specific holiday information
**Table Type:** Dimension
**SCD Type:** Type 1 (Holiday definitions are relatively static)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Holiday_Key | bigint | Surrogate key for the holiday dimension | Non-PII |
| Holiday_Date | datetime | Date of the holiday | Non-PII |
| Holiday_Name | varchar(100) | Name or description of the holiday | Non-PII |
| Holiday_Type | varchar(50) | Type of holiday (National, Regional, Religious) | Non-PII |
| Location_Country | varchar(50) | Country where holiday is observed | Non-PII |
| Location_Region | varchar(50) | Specific region or state where applicable | Non-PII |
| Is_Mandatory | bit | Indicator if holiday is mandatory for all employees | Non-PII |
| Business_Impact | varchar(100) | Impact on business operations | Non-PII |
| Holiday_Source | varchar(50) | Source of the holiday definition | Non-PII |
| Record_Source | varchar(100) | Source system that provided this record | Non-PII |
| Load_Date | datetime | Date when record was loaded into Gold layer | Non-PII |
| Update_Date | datetime | Date when record was last updated | Non-PII |

---

### 2.2 FACT TABLES

#### Table: Go_Fact_Timesheet
**Description:** Fact table capturing daily timesheet entries with various hour types and associated metrics
**Table Type:** Fact

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Timesheet_Key | bigint | Surrogate key for the timesheet fact | Non-PII |
| Resource_Key | bigint | Foreign key to Go_Dim_Resource | Non-PII |
| Project_Key | bigint | Foreign key to Go_Dim_Project | Non-PII |
| Date_Key | bigint | Foreign key to Go_Dim_Date | Non-PII |
| Timesheet_Date | datetime | Date for which timesheet entry is recorded | Non-PII |
| Standard_Hours_Submitted | float | Number of standard hours submitted | Non-PII |
| Overtime_Hours_Submitted | float | Number of overtime hours submitted | Non-PII |
| Double_Time_Hours_Submitted | float | Number of double time hours submitted | Non-PII |
| Sick_Time_Hours_Submitted | float | Number of sick time hours submitted | Non-PII |
| Holiday_Hours_Submitted | float | Number of holiday hours submitted | Non-PII |
| Time_Off_Hours_Submitted | float | Number of time off hours submitted | Non-PII |
| Total_Hours_Submitted | float | Total hours submitted across all types | Non-PII |
| Standard_Hours_Approved | float | Number of standard hours approved | Non-PII |
| Overtime_Hours_Approved | float | Number of overtime hours approved | Non-PII |
| Double_Time_Hours_Approved | float | Number of double time hours approved | Non-PII |
| Sick_Time_Hours_Approved | float | Number of sick time hours approved | Non-PII |
| Total_Hours_Approved | float | Total hours approved across all types | Non-PII |
| Non_Standard_Hours | float | Number of non-billable standard hours | Non-PII |
| Non_Overtime_Hours | float | Number of non-billable overtime hours | Non-PII |
| Non_Double_Time_Hours | float | Number of non-billable double time hours | Non-PII |
| Non_Sick_Time_Hours | float | Number of non-billable sick time hours | Non-PII |
| Is_Billable_Entry | bit | Flag indicating if timesheet entry is billable | Non-PII |
| Is_Approved | bit | Flag indicating if timesheet entry is approved | Non-PII |
| Submission_Date | datetime | Date when timesheet was submitted | Non-PII |
| Approval_Date | datetime | Date when timesheet was approved | Non-PII |
| Week_Ending_Date | datetime | Week ending date for the timesheet period | Non-PII |
| Record_Source | varchar(100) | Source system that provided this record | Non-PII |
| Load_Date | datetime | Date when record was loaded into Gold layer | Non-PII |
| Update_Date | datetime | Date when record was last updated | Non-PII |

---

#### Table: Go_Fact_Resource_Utilization
**Description:** Fact table capturing resource utilization metrics and KPIs for reporting and analysis
**Table Type:** Fact

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Utilization_Key | bigint | Surrogate key for the utilization fact | Non-PII |
| Resource_Key | bigint | Foreign key to Go_Dim_Resource | Non-PII |
| Project_Key | bigint | Foreign key to Go_Dim_Project | Non-PII |
| Date_Key | bigint | Foreign key to Go_Dim_Date | Non-PII |
| Reporting_Period | datetime | Reporting period date (monthly/weekly) | Non-PII |
| Total_Available_Hours | float | Total hours available for the period | Non-PII |
| Total_Expected_Hours | float | Total expected working hours for the period | Non-PII |
| Total_Submitted_Hours | float | Total hours submitted in timesheets | Non-PII |
| Total_Approved_Hours | float | Total hours approved by management | Non-PII |
| Total_Billable_Hours | float | Total billable hours for the period | Non-PII |
| Total_Non_Billable_Hours | float | Total non-billable hours for the period | Non-PII |
| Total_FTE | decimal(5,2) | Total FTE calculation (Submitted Hours / Total Hours) | Non-PII |
| Billed_FTE | decimal(5,2) | Billed FTE calculation (Approved Hours / Total Hours) | Non-PII |
| Project_Utilization_Rate | decimal(5,2) | Project utilization percentage (Billed Hours / Available Hours) | Non-PII |
| Capacity_Utilization_Rate | decimal(5,2) | Overall capacity utilization percentage | Non-PII |
| Billable_Utilization_Rate | decimal(5,2) | Billable hours utilization percentage | Non-PII |
| Onsite_Hours | float | Total hours worked onsite | Non-PII |
| Offshore_Hours | float | Total hours worked offshore | Non-PII |
| Working_Days_Count | int | Number of working days in the period | Non-PII |
| Holiday_Days_Count | int | Number of holiday days in the period | Non-PII |
| Weekend_Days_Count | int | Number of weekend days in the period | Non-PII |
| Bench_Hours | float | Hours spent on bench (non-project) activities | Non-PII |
| Training_Hours | float | Hours spent on training activities | Non-PII |
| Administrative_Hours | float | Hours spent on administrative tasks | Non-PII |
| Record_Source | varchar(100) | Source system that provided this record | Non-PII |
| Load_Date | datetime | Date when record was loaded into Gold layer | Non-PII |
| Update_Date | datetime | Date when record was last updated | Non-PII |

---

#### Table: Go_Fact_Workflow_Task
**Description:** Fact table capturing workflow and approval task activities for process tracking
**Table Type:** Fact

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Workflow_Key | bigint | Surrogate key for the workflow fact | Non-PII |
| Resource_Key | bigint | Foreign key to Go_Dim_Resource | Non-PII |
| Project_Key | bigint | Foreign key to Go_Dim_Project | Non-PII |
| Date_Key | bigint | Foreign key to Go_Dim_Date | Non-PII |
| Task_Reference_Number | varchar(100) | Business reference number for the workflow task | Non-PII |
| Workflow_Type | varchar(50) | Type of workflow (Onsite/Offshore assignment) | Non-PII |
| Business_Tower | varchar(60) | Business tower or division | Non-PII |
| Task_Status | varchar(50) | Current status of the workflow task | Non-PII |
| Process_Name | varchar(100) | Name of the human workflow process | Non-PII |
| Current_Level | int | Current level in the workflow process | Non-PII |
| Final_Level | int | Final level in the workflow process | Non-PII |
| Task_Created_Date | datetime | Date when workflow task was created | Non-PII |
| Task_Completed_Date | datetime | Date when workflow task was completed | Non-PII |
| Processing_Duration_Days | int | Number of days to complete the task | Non-PII |
| Processing_Duration_Hours | decimal(10,2) | Number of hours to complete the task | Non-PII |
| Is_Task_Completed | bit | Flag indicating if task is completed | Non-PII |
| Is_Task_Overdue | bit | Flag indicating if task is overdue | Non-PII |
| Task_Comments | varchar(8000) | Comments or notes for the task | Non-PII |
| Record_Source | varchar(100) | Source system that provided this record | Non-PII |
| Load_Date | datetime | Date when record was loaded into Gold layer | Non-PII |
| Update_Date | datetime | Date when record was last updated | Non-PII |

---

### 2.3 AUDIT AND ERROR DATA STRUCTURES

#### Table: Go_Pipeline_Audit
**Description:** Comprehensive audit table for tracking all pipeline execution details and data lineage
**Table Type:** Process Audit

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Audit_Key | bigint | Surrogate key for the audit record | Non-PII |
| Pipeline_Execution_ID | varchar(100) | Unique identifier for the pipeline execution | Non-PII |
| Pipeline_Name | varchar(200) | Name of the data pipeline | Non-PII |
| Pipeline_Type | varchar(50) | Type of pipeline (ETL, ELT, Streaming) | Non-PII |
| Source_System_Name | varchar(100) | Name of the source system | Non-PII |
| Source_Schema_Name | varchar(100) | Source schema name | Non-PII |
| Source_Table_Name | varchar(200) | Source table name | Non-PII |
| Target_Schema_Name | varchar(100) | Target schema name | Non-PII |
| Target_Table_Name | varchar(200) | Target Gold table name | Non-PII |
| Processing_Layer | varchar(50) | Processing layer (Bronze, Silver, Gold) | Non-PII |
| Processing_Type | varchar(50) | Type of processing (Full Load, Incremental, Delta, CDC) | Non-PII |
| Execution_Start_Time | datetime | Pipeline execution start timestamp | Non-PII |
| Execution_End_Time | datetime | Pipeline execution end timestamp | Non-PII |
| Total_Duration_Seconds | decimal(10,2) | Total processing duration in seconds | Non-PII |
| Execution_Status | varchar(50) | Pipeline execution status (Success, Failed, Partial, Warning) | Non-PII |
| Records_Read_Count | bigint | Number of records read from source | Non-PII |
| Records_Processed_Count | bigint | Number of records processed successfully | Non-PII |
| Records_Inserted_Count | bigint | Number of records inserted into Gold layer | Non-PII |
| Records_Updated_Count | bigint | Number of records updated in Gold layer | Non-PII |
| Records_Deleted_Count | bigint | Number of records deleted from Gold layer | Non-PII |
| Records_Rejected_Count | bigint | Number of records rejected due to quality issues | Non-PII |
| Data_Quality_Score_Percentage | decimal(5,2) | Overall data quality score percentage | Non-PII |
| Transformation_Rules_Applied | varchar(max) | List of transformation rules applied | Non-PII |
| Business_Rules_Applied | varchar(max) | List of business rules applied | Non-PII |
| Data_Validation_Rules_Applied | varchar(max) | List of data validation rules applied | Non-PII |
| Total_Error_Count | int | Total number of errors encountered | Non-PII |
| Critical_Error_Count | int | Number of critical errors | Non-PII |
| Warning_Count | int | Total number of warnings encountered | Non-PII |
| Execution_Error_Message | varchar(max) | Detailed error message if pipeline failed | Non-PII |
| Checkpoint_Information | varchar(max) | Checkpoint data for incremental processing | Non-PII |
| Resource_Utilization_Metrics | varchar(500) | CPU, Memory, and I/O utilization metrics | Non-PII |
| Data_Lineage_Information | varchar(max) | Complete data lineage and dependency information | Non-PII |
| Executed_By_User | varchar(100) | User or service account that executed the pipeline | Non-PII |
| Execution_Environment | varchar(50) | Environment where pipeline was executed (Dev, Test, Prod) | Non-PII |
| Pipeline_Version | varchar(50) | Version of the pipeline code | Non-PII |
| Configuration_Parameters | varchar(max) | Pipeline configuration and parameter settings | Non-PII |
| SLA_Target_Duration_Minutes | int | Target SLA duration in minutes | Non-PII |
| SLA_Met_Indicator | bit | Flag indicating if SLA was met | Non-PII |
| Data_Freshness_Timestamp | datetime | Timestamp of the most recent source data | Non-PII |
| Batch_Processing_ID | varchar(100) | Batch identifier for grouping related executions | Non-PII |
| Parent_Pipeline_ID | varchar(100) | Parent pipeline ID for nested executions | Non-PII |
| Retry_Attempt_Number | int | Number of retry attempts for failed executions | Non-PII |
| Created_Date | datetime | Date when audit record was created | Non-PII |
| Modified_Date | datetime | Date when audit record was last modified | Non-PII |

---

#### Table: Go_Data_Quality_Errors
**Description:** Comprehensive error tracking table for data validation and quality issues
**Table Type:** Error Data

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Error_Key | bigint | Surrogate key for the error record | Non-PII |
| Pipeline_Execution_ID | varchar(100) | Reference to the pipeline execution that generated the error | Non-PII |
| Error_Unique_ID | varchar(200) | Unique identifier for the specific error instance | Non-PII |
| Source_System_Name | varchar(100) | Name of the source system where error originated | Non-PII |
| Source_Table_Name | varchar(200) | Name of the source table where error occurred | Non-PII |
| Target_Table_Name | varchar(200) | Name of the target Gold table | Non-PII |
| Record_Identifier | varchar(500) | Business key or identifier of the record that failed | Non-PII |
| Error_Type_Category | varchar(100) | High-level category (Data Quality, Business Rule, Constraint Violation, Technical) | Non-PII |
| Error_Subcategory | varchar(100) | Detailed subcategory (Completeness, Accuracy, Consistency, Validity, Format) | Non-PII |
| Error_Code | varchar(50) | Standardized error code for categorization | Non-PII |
| Error_Description | varchar(1000) | Detailed human-readable description of the error | Non-PII |
| Field_Name | varchar(200) | Name of the specific field that caused the error | Non-PII |
| Field_Value_Received | varchar(500) | Actual value that caused the error | Potentially PII |
| Field_Value_Expected | varchar(500) | Expected value or format description | Non-PII |
| Business_Rule_Name | varchar(200) | Name of the business rule that was violated | Non-PII |
| Business_Rule_Description | varchar(500) | Description of the business rule that was violated | Non-PII |
| Validation_Rule_Name | varchar(200) | Name of the validation rule that failed | Non-PII |
| Validation_Rule_Expression | varchar(1000) | Technical expression of the validation rule | Non-PII |
| Severity_Level | varchar(50) | Severity classification (Critical, High, Medium, Low, Info) | Non-PII |
| Impact_Assessment | varchar(500) | Assessment of the error's impact on downstream processes | Non-PII |
| Error_Occurrence_Timestamp | datetime | Exact date and time when error occurred | Non-PII |
| Processing_Stage | varchar(100) | Stage of processing where error occurred (Extract, Transform, Load, Validate) | Non-PII |
| Data_Quality_Dimension | varchar(100) | Data quality dimension affected (Completeness, Accuracy, etc.) | Non-PII |
| Resolution_Status | varchar(50) | Current status (Open, In Progress, Resolved, Ignored, Deferred) | Non-PII |
| Resolution_Action_Taken | varchar(1000) | Description of action taken to resolve the error | Non-PII |
| Resolution_Date | datetime | Date when error was resolved | Non-PII |
| Resolved_By_User | varchar(100) | User who resolved the error | Non-PII |
| Resolution_Notes | varchar(1000) | Additional notes about the resolution | Non-PII |
| Error_Frequency_Count | int | Number of times this specific error has occurred | Non-PII |
| First_Occurrence_Date | datetime | Date when this error type was first encountered | Non-PII |
| Last_Occurrence_Date | datetime | Date when this error type was last encountered | Non-PII |
| Batch_Processing_ID | varchar(100) | Batch identifier for grouping related errors | Non-PII |
| Error_Context_Information | varchar(max) | Additional context information about the error | Non-PII |
| Remediation_Suggestion | varchar(1000) | Suggested remediation steps | Non-PII |
| Business_Owner | varchar(100) | Business owner responsible for data quality | Non-PII |
| Technical_Owner | varchar(100) | Technical owner responsible for resolution | Non-PII |
| SLA_Resolution_Target_Hours | int | Target hours for error resolution based on severity | Non-PII |
| SLA_Met_Indicator | bit | Flag indicating if resolution SLA was met | Non-PII |
| Created_By_System | varchar(100) | System or process that created the error record | Non-PII |
| Created_Date | datetime | Date when error record was created | Non-PII |
| Modified_Date | datetime | Date when error record was last modified | Non-PII |

---

### 2.4 AGGREGATED TABLES

#### Table: Go_Agg_Monthly_Resource_Summary
**Description:** Monthly aggregated summary of resource utilization metrics for executive reporting
**Table Type:** Aggregated

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Summary_Key | bigint | Surrogate key for the monthly summary | Non-PII |
| Resource_Key | bigint | Foreign key to Go_Dim_Resource | Non-PII |
| Year_Month | int | Year and month in YYYYMM format | Non-PII |
| Reporting_Month | datetime | First day of the reporting month | Non-PII |
| Total_Working_Days | int | Total working days in the month | Non-PII |
| Total_Available_Hours | decimal(10,2) | Total hours available for work in the month | Non-PII |
| Total_Submitted_Hours | decimal(10,2) | Total hours submitted across all projects | Non-PII |
| Total_Approved_Hours | decimal(10,2) | Total hours approved across all projects | Non-PII |
| Total_Billable_Hours | decimal(10,2) | Total billable hours for the month | Non-PII |
| Total_Non_Billable_Hours | decimal(10,2) | Total non-billable hours for the month | Non-PII |
| Monthly_FTE | decimal(5,2) | Monthly FTE calculation | Non-PII |
| Monthly_Billable_FTE | decimal(5,2) | Monthly billable FTE calculation | Non-PII |
| Overall_Utilization_Rate | decimal(5,2) | Overall utilization percentage | Non-PII |
| Billable_Utilization_Rate | decimal(5,2) | Billable utilization percentage | Non-PII |
| Bench_Hours | decimal(10,2) | Hours spent on bench activities | Non-PII |
| Training_Hours | decimal(10,2) | Hours spent on training | Non-PII |
| Administrative_Hours | decimal(10,2) | Hours spent on administrative tasks | Non-PII |
| Overtime_Hours | decimal(10,2) | Total overtime hours for the month | Non-PII |
| Sick_Leave_Hours | decimal(10,2) | Total sick leave hours taken | Non-PII |
| Vacation_Hours | decimal(10,2) | Total vacation hours taken | Non-PII |
| Holiday_Hours | decimal(10,2) | Total holiday hours | Non-PII |
| Project_Count | int | Number of projects worked on during the month | Non-PII |
| Client_Count | int | Number of different clients served | Non-PII |
| Onsite_Hours | decimal(10,2) | Total hours worked onsite | Non-PII |
| Offshore_Hours | decimal(10,2) | Total hours worked offshore | Non-PII |
| Revenue_Generated | money | Total revenue generated (if available) | Non-PII |
| Cost_Allocated | money | Total cost allocated to the resource | Non-PII |
| Gross_Margin | money | Gross margin contribution | Non-PII |
| Load_Date | datetime | Date when record was loaded into Gold layer | Non-PII |
| Update_Date | datetime | Date when record was last updated | Non-PII |

---

#### Table: Go_Agg_Project_Performance_Summary
**Description:** Aggregated project performance metrics for project management and client reporting
**Table Type:** Aggregated

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Performance_Key | bigint | Surrogate key for the project performance summary | Non-PII |
| Project_Key | bigint | Foreign key to Go_Dim_Project | Non-PII |
| Year_Month | int | Year and month in YYYYMM format | Non-PII |
| Reporting_Period | datetime | Reporting period date | Non-PII |
| Active_Resource_Count | int | Number of active resources on the project | Non-PII |
| Total_Project_Hours | decimal(10,2) | Total hours logged to the project | Non-PII |
| Total_Billable_Hours | decimal(10,2) | Total billable hours for the project | Non-PII |
| Total_Non_Billable_Hours | decimal(10,2) | Total non-billable hours for the project | Non-PII |
| Average_Daily_Hours | decimal(5,2) | Average daily hours per resource | Non-PII |
| Project_Utilization_Rate | decimal(5,2) | Overall project utilization percentage | Non-PII |
| Resource_Allocation_FTE | decimal(5,2) | Total FTE allocated to the project | Non-PII |
| Planned_Hours | decimal(10,2) | Planned hours for the period | Non-PII |
| Actual_Hours | decimal(10,2) | Actual hours delivered | Non-PII |
| Hours_Variance | decimal(10,2) | Variance between planned and actual hours | Non-PII |
| Hours_Variance_Percentage | decimal(5,2) | Percentage variance in hours | Non-PII |
| Onsite_Resource_Count | int | Number of onsite resources | Non-PII |
| Offshore_Resource_Count | int | Number of offshore resources | Non-PII |
| Onsite_Hours_Total | decimal(10,2) | Total onsite hours | Non-PII |
| Offshore_Hours_Total | decimal(10,2) | Total offshore hours | Non-PII |
| Standard_Hours_Total | decimal(10,2) | Total standard hours | Non-PII |
| Overtime_Hours_Total | decimal(10,2) | Total overtime hours | Non-PII |
| Project_Revenue | money | Total project revenue (if available) | Non-PII |
| Project_Cost | money | Total project cost | Non-PII |
| Project_Margin | money | Project margin | Non-PII |
| Project_Margin_Percentage | decimal(5,2) | Project margin percentage | Non-PII |
| Delivery_Quality_Score | decimal(5,2) | Delivery quality score (if available) | Non-PII |
| Client_Satisfaction_Score | decimal(5,2) | Client satisfaction score (if available) | Non-PII |
| Load_Date | datetime | Date when record was loaded into Gold layer | Non-PII |
| Update_Date | datetime | Date when record was last updated | Non-PII |

---

#### Table: Go_Agg_Business_Area_Summary
**Description:** Business area level aggregated metrics for regional performance analysis
**Table Type:** Aggregated

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Business_Area_Key | bigint | Surrogate key for the business area summary | Non-PII |
| Business_Area_Name | varchar(50) | Name of the business area (NA, LATAM, India, Others) | Non-PII |
| Year_Month | int | Year and month in YYYYMM format | Non-PII |
| Reporting_Period | datetime | Reporting period date | Non-PII |
| Total_Resource_Count | int | Total number of resources in the business area | Non-PII |
| Active_Resource_Count | int | Number of active resources | Non-PII |
| Billable_Resource_Count | int | Number of resources on billable projects | Non-PII |
| Bench_Resource_Count | int | Number of resources on bench | Non-PII |
| Total_Available_Hours | decimal(12,2) | Total available hours across all resources | Non-PII |
| Total_Submitted_Hours | decimal(12,2) | Total submitted hours across all resources | Non-PII |
| Total_Approved_Hours | decimal(12,2) | Total approved hours across all resources | Non-PII |
| Total_Billable_Hours | decimal(12,2) | Total billable hours | Non-PII |
| Total_Non_Billable_Hours | decimal(12,2) | Total non-billable hours | Non-PII |
| Average_FTE_Per_Resource | decimal(5,2) | Average FTE per resource | Non-PII |
| Overall_Utilization_Rate | decimal(5,2) | Overall utilization rate for the business area | Non-PII |
| Billable_Utilization_Rate | decimal(5,2) | Billable utilization rate | Non-PII |
| Bench_Utilization_Rate | decimal(5,2) | Bench utilization rate | Non-PII |
| Project_Count | int | Total number of active projects | Non-PII |
| Client_Count | int | Total number of active clients | Non-PII |
| FTE_Resource_Count | int | Number of FTE resources | Non-PII |
| Consultant_Resource_Count | int | Number of consultant resources | Non-PII |
| Onsite_Resource_Count | int | Number of onsite resources | Non-PII |
| Offshore_Resource_Count | int | Number of offshore resources | Non-PII |
| Total_Revenue | money | Total revenue generated | Non-PII |
| Total_Cost | money | Total cost for the business area | Non-PII |
| Gross_Margin | money | Gross margin for the business area | Non-PII |
| Gross_Margin_Percentage | decimal(5,2) | Gross margin percentage | Non-PII |
| New_Hire_Count | int | Number of new hires during the period | Non-PII |
| Termination_Count | int | Number of terminations during the period | Non-PII |
| Net_Headcount_Change | int | Net change in headcount | Non-PII |
| Load_Date | datetime | Date when record was loaded into Gold layer | Non-PII |
| Update_Date | datetime | Date when record was last updated | Non-PII |

---

## 3. CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORM)

| Entity | Related Entity | Relationship Key Field(s) | Relationship Description |
|--------|----------------|---------------------------|--------------------------|
| Go_Dim_Resource | Go_Fact_Timesheet | Resource_Key | One resource can have many timesheet entries |
| Go_Dim_Resource | Go_Fact_Resource_Utilization | Resource_Key | One resource can have many utilization records |
| Go_Dim_Resource | Go_Fact_Workflow_Task | Resource_Key | One resource can have many workflow tasks |
| Go_Dim_Resource | Go_Agg_Monthly_Resource_Summary | Resource_Key | One resource has monthly summary records |
| Go_Dim_Project | Go_Fact_Timesheet | Project_Key | One project can have many timesheet entries |
| Go_Dim_Project | Go_Fact_Resource_Utilization | Project_Key | One project can have many utilization records |
| Go_Dim_Project | Go_Fact_Workflow_Task | Project_Key | One project can have many workflow tasks |
| Go_Dim_Project | Go_Agg_Project_Performance_Summary | Project_Key | One project has performance summary records |
| Go_Dim_Date | Go_Fact_Timesheet | Date_Key | One date can have many timesheet entries |
| Go_Dim_Date | Go_Fact_Resource_Utilization | Date_Key | One date can have many utilization records |
| Go_Dim_Date | Go_Fact_Workflow_Task | Date_Key | One date can have many workflow tasks |
| Go_Dim_Holiday | Go_Dim_Date | Holiday_Date = Calendar_Date | Many holidays can reference one calendar date |
| Go_Fact_Timesheet | Go_Agg_Monthly_Resource_Summary | Resource_Key + Year_Month | Timesheet facts aggregate to monthly summaries |
| Go_Fact_Timesheet | Go_Agg_Project_Performance_Summary | Project_Key + Year_Month | Timesheet facts aggregate to project summaries |
| Go_Fact_Resource_Utilization | Go_Agg_Monthly_Resource_Summary | Resource_Key + Year_Month | Utilization facts aggregate to monthly summaries |
| Go_Fact_Resource_Utilization | Go_Agg_Business_Area_Summary | Business_Area + Year_Month | Utilization facts aggregate to business area summaries |
| Go_Pipeline_Audit | Go_Data_Quality_Errors | Pipeline_Execution_ID | One pipeline execution can have many errors |

---

## 4. DESIGN DECISIONS AND RATIONALE

### 4.1 Dimensional Model Design
- **Star Schema**: Implemented star schema for optimal query performance and ease of understanding
- **Surrogate Keys**: Used bigint surrogate keys for all dimensions and facts to ensure referential integrity and performance
- **SCD Implementation**: Applied Type 2 SCD for Resource and Project dimensions to maintain historical accuracy
- **Date Dimension**: Comprehensive date dimension with fiscal year support and holiday integration

### 4.2 Fact Table Design
- **Timesheet Fact**: Captures both submitted and approved hours for complete audit trail
- **Utilization Fact**: Pre-calculated KPIs for improved reporting performance
- **Workflow Fact**: Tracks process efficiency and approval workflows

### 4.3 Aggregation Strategy
- **Monthly Summaries**: Pre-aggregated monthly data for executive dashboards
- **Project Performance**: Project-level aggregations for project management reporting
- **Business Area Summaries**: Regional performance metrics for organizational reporting

### 4.4 Audit and Error Handling
- **Comprehensive Audit Trail**: Complete pipeline execution tracking with performance metrics
- **Detailed Error Logging**: Structured error capture with severity levels and resolution tracking
- **Data Quality Monitoring**: Built-in data quality scoring and validation rule tracking

### 4.5 PII Classification
- **GDPR Compliance**: Classified all fields according to GDPR standards
- **Sensitive Data Identification**: Marked visa information and personal identifiers as PII
- **Data Minimization**: Only included necessary PII fields in the Gold layer

---

## 5. ASSUMPTIONS MADE

1. **Data Retention**: Assumed 7-year data retention policy for historical analysis
2. **SCD Implementation**: Assumed business requirement for historical tracking of resource and project changes
3. **Aggregation Frequency**: Assumed monthly aggregation is sufficient for executive reporting
4. **Error Resolution**: Assumed 24-hour SLA for critical error resolution
5. **Data Quality**: Assumed 95% data quality threshold for production readiness
6. **Performance Requirements**: Assumed sub-second query response time requirements for dashboards
7. **Scalability**: Designed for up to 10,000 resources and 1,000 concurrent projects
8. **Integration Frequency**: Assumed daily batch processing with near real-time capability for critical metrics

---

## 6. API COST CALCULATION

**apiCost**: 0.045672

*Note: This cost represents the computational resources consumed by the LLM API for generating this comprehensive Gold Layer logical data model, including analysis of input documents, dimensional modeling, and detailed documentation creation.*

---

**END OF DOCUMENT**