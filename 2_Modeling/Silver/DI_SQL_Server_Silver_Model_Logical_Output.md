====================================================
Author:        AAVA
Date:          
Description:   Silver Layer Logical Data Model for Medallion Architecture - Resource Utilization and Workforce Management
====================================================

# SILVER LAYER LOGICAL DATA MODEL

## 1. OVERVIEW

This document defines the Silver Layer logical data model for the Resource Utilization and Workforce Management system. The Silver layer serves as the curated, validated, and business-ready layer in the Medallion architecture, transforming raw Bronze layer data into clean, standardized, and enriched datasets suitable for analytics and reporting.

### Design Principles:
- **Data Quality**: All data undergoes validation and quality checks before entering Silver layer
- **Business Alignment**: Tables and columns reflect business terminology and concepts
- **Standardization**: Consistent data types, naming conventions, and structures across all tables
- **Auditability**: Complete tracking of data lineage, transformations, and quality metrics
- **Selective Inclusion**: Only business-required attributes from Bronze layer are included

---

## 2. SILVER LAYER TABLES

### 2.1 Si_Resource
**Description:** Curated resource master data containing employee information, employment details, and organizational assignments. This table represents the single source of truth for all workforce members.

**Source:** Derived from Bz_New_Monthly_HC_Report and Bz_report_392_all

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Resource_Code | VARCHAR(50) | Unique identifier for the resource (derived from gci_id) |
| First_Name | VARCHAR(50) | Employee's legal first name |
| Last_Name | VARCHAR(50) | Employee's legal last name |
| Job_Title | VARCHAR(50) | Official job title or position of the employee |
| Business_Type | VARCHAR(50) | Business type classification (FTE, Consultant, Contractor) |
| Client_Code | VARCHAR(50) | Unique identifier code assigned to the client organization |
| Start_Date | DATETIME | Employee's project or employment start date |
| Termination_Date | DATETIME | Employee's termination date if applicable |
| Project_Assignment | VARCHAR(200) | Name of the project currently assigned to the resource |
| Market | VARCHAR(50) | Geographic or business market segment |
| Visa_Type | VARCHAR(50) | Visa type classification for the employee |
| Practice_Type | VARCHAR(50) | Practice area or business unit classification |
| Vertical | VARCHAR(50) | Industry vertical classification |
| Status | VARCHAR(25) | Current employment status (Active, Terminated, On Leave) |
| Employee_Category | VARCHAR(50) | Employee classification category (Bench, AVA, Billable) |
| Portfolio_Leader | VARCHAR(MAX) | Business portfolio leader name |
| Expected_Hours | REAL | Expected working hours per period |
| Available_Hours | REAL | Calculated available hours for the resource |
| Business_Area | VARCHAR(50) | Geographic business area (NA, LATAM, India, Others) |
| SOW | VARCHAR(7) | Statement of Work indicator (Yes/No) |
| Super_Merged_Name | VARCHAR(200) | Parent client name for consolidated reporting |
| New_Business_Type | VARCHAR(100) | Contract/Direct Hire/Project NBL classification |
| Requirement_Region | VARCHAR(50) | Region for the requirement |
| Is_Offshore | VARCHAR(20) | Offshore/Onsite location indicator |
| Community | VARCHAR(100) | Community classification for organizational structure |
| Circle | VARCHAR(100) | Circle or region classification |
| load_timestamp | DATETIME | Timestamp when record was loaded into Silver layer |
| update_timestamp | DATETIME | Timestamp when record was last updated in Silver layer |
| data_quality_score | DECIMAL(5,2) | Data quality score percentage (0-100) |
| validation_status | VARCHAR(50) | Validation status (Passed, Failed, Warning) |

---

### 2.2 Si_Timesheet_Entry
**Description:** Curated timesheet entries capturing daily time worked by resources across different hour types. This table contains validated and standardized timesheet data.

**Source:** Derived from Bz_Timesheet_New

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Resource_Code | VARCHAR(50) | Unique code for the resource submitting the timesheet |
| Timesheet_Date | DATETIME | Date for which the timesheet entry is recorded |
| Project_Task_Reference | NUMERIC(18,9) | Reference to the project or task for which hours are logged |
| Standard_Hours | FLOAT | Number of standard hours worked (ST) |
| Overtime_Hours | FLOAT | Number of overtime hours worked (OT) |
| Double_Time_Hours | FLOAT | Number of double time hours worked (DT) |
| Sick_Time_Hours | FLOAT | Number of sick time hours recorded |
| Holiday_Hours | FLOAT | Number of hours recorded as holiday (HO) |
| Time_Off_Hours | FLOAT | Number of time off hours taken |
| Non_Standard_Hours | FLOAT | Number of non-billable standard hours worked |
| Non_Overtime_Hours | FLOAT | Number of non-billable overtime hours worked |
| Non_Double_Time_Hours | FLOAT | Number of non-billable double time hours worked |
| Non_Sick_Time_Hours | FLOAT | Number of non-billable sick time hours recorded |
| Total_Hours_Submitted | FLOAT | Total hours submitted (sum of all hour types) |
| Creation_Date | DATETIME | Date when timesheet entry was created |
| load_timestamp | DATETIME | Timestamp when record was loaded into Silver layer |
| update_timestamp | DATETIME | Timestamp when record was last updated in Silver layer |
| data_quality_score | DECIMAL(5,2) | Data quality score percentage (0-100) |
| validation_status | VARCHAR(50) | Validation status (Passed, Failed, Warning) |

---

### 2.3 Si_Project
**Description:** Curated project master data containing project details, billing information, and client associations. This table represents all active and historical projects.

**Source:** Derived from Bz_report_392_all and Bz_Hiring_Initiator_Project_Info

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Project_Name | VARCHAR(200) | Name of the project (ITSSProjectName) |
| Client_Name | VARCHAR(60) | Name of the client organization |
| Client_Code | VARCHAR(50) | Unique identifier code for the client |
| Billing_Type | VARCHAR(50) | Billing classification (Billable/Non-Billable) |
| Category | VARCHAR(50) | Project category (India Billing - Client-NBL, Billable, etc.) |
| Status | VARCHAR(50) | Billing status (Billed/Unbilled/SGA) |
| Project_City | VARCHAR(50) | City where the project is executed |
| Project_State | VARCHAR(50) | State where the project is executed |
| Opportunity_Name | VARCHAR(200) | Name of the business opportunity |
| Project_Type | VARCHAR(500) | Type of project classification |
| Delivery_Leader | VARCHAR(50) | Project delivery leader name |
| Circle | VARCHAR(50) | Business circle or grouping |
| Market_Leader | NVARCHAR(MAX) | Market leader for the project |
| Net_Bill_Rate | MONEY | Net bill rate for the project |
| Bill_ST | VARCHAR(50) | Bill straight time rate |
| Bill_ST_Units | VARCHAR(50) | Billing straight time units |
| Project_Start_Date | DATETIME | Project start date |
| Project_End_Date | DATETIME | Project end date |
| Subtier | VARCHAR(50) | Sub-tier client classification |
| Super_Merged_Name | VARCHAR(200) | Parent client name for enterprise reporting |
| load_timestamp | DATETIME | Timestamp when record was loaded into Silver layer |
| update_timestamp | DATETIME | Timestamp when record was last updated in Silver layer |
| data_quality_score | DECIMAL(5,2) | Data quality score percentage (0-100) |
| validation_status | VARCHAR(50) | Validation status (Passed, Failed, Warning) |

---

### 2.4 Si_Date_Dimension
**Description:** Curated date dimension providing comprehensive calendar and working day context for time-based calculations. This table includes weekend and holiday indicators.

**Source:** Derived from Bz_DimDate

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Calendar_Date | DATETIME | Actual calendar date (primary business key) |
| Day_Name | VARCHAR(9) | Name of the day (Monday, Tuesday, Wednesday, etc.) |
| Day_Of_Month | VARCHAR(2) | Day of the month (1-31) |
| Week_Of_Year | VARCHAR(2) | Week number of the year (1-52) |
| Month_Number | VARCHAR(2) | Month number (1-12) |
| Month_Name | VARCHAR(9) | Name of the month (January, February, etc.) |
| Month_Of_Quarter | VARCHAR(2) | Month number within the quarter (1-3) |
| Quarter | CHAR(1) | Quarter number (1-4) |
| Quarter_Name | VARCHAR(9) | Quarter name (Q1, Q2, Q3, Q4) |
| Year | CHAR(4) | Four-digit year |
| Year_Name | CHAR(7) | Year name with prefix |
| Month_Year | CHAR(10) | Month and year combination |
| MMYYYY | CHAR(6) | Month and year in MMYYYY format |
| MM_YYYY | VARCHAR(10) | Month and year in MM-YYYY format |
| YYYYMM | VARCHAR(10) | Year and month in YYYYMM format |
| Days_In_Month | INT | Number of days in the month |
| Is_Working_Day | BIT | Indicator if the date is a working day (1=Yes, 0=No) |
| Is_Weekend | BIT | Indicator if the date is a weekend (1=Yes, 0=No) |
| load_timestamp | DATETIME | Timestamp when record was loaded into Silver layer |
| update_timestamp | DATETIME | Timestamp when record was last updated in Silver layer |
| data_quality_score | DECIMAL(5,2) | Data quality score percentage (0-100) |
| validation_status | VARCHAR(50) | Validation status (Passed, Failed, Warning) |

---

### 2.5 Si_Holiday
**Description:** Curated holiday master data containing holiday dates by location. This table is used to exclude non-working days in hour calculations and supports multi-location holiday tracking.

**Source:** Derived from Bz_holidays, Bz_holidays_India, Bz_holidays_Mexico, Bz_holidays_Canada

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Holiday_Date | DATETIME | Date of the holiday |
| Description | VARCHAR(100) | Description or name of the holiday |
| Location | VARCHAR(10) | Location for which the holiday applies (US, India, Mexico, Canada) |
| Source_Type | VARCHAR(50) | Source of the holiday data for audit purposes |
| Is_Active | BIT | Indicator if the holiday is currently active (1=Yes, 0=No) |
| load_timestamp | DATETIME | Timestamp when record was loaded into Silver layer |
| update_timestamp | DATETIME | Timestamp when record was last updated in Silver layer |
| data_quality_score | DECIMAL(5,2) | Data quality score percentage (0-100) |
| validation_status | VARCHAR(50) | Validation status (Passed, Failed, Warning) |

---

### 2.6 Si_Timesheet_Approval
**Description:** Curated timesheet approval data containing submitted and approved timesheet hours by resource, date, and billing type. This table tracks manager-approved hours for billing purposes.

**Source:** Derived from Bz_vw_billing_timesheet_daywise_ne and Bz_vw_consultant_timesheet_daywise

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Resource_Code | VARCHAR(50) | Unique code for the resource |
| Timesheet_Date | DATETIME | Date for which the timesheet entry is recorded |
| Week_Date | DATETIME | Week date for the timesheet entry |
| Billing_Indicator | VARCHAR(3) | Indicates if the hours are billable (Yes/No) |
| Approved_Standard_Hours | FLOAT | Approved standard hours for the day |
| Approved_Overtime_Hours | FLOAT | Approved overtime hours for the day |
| Approved_Double_Time_Hours | FLOAT | Approved double time hours for the day |
| Approved_Sick_Time_Hours | FLOAT | Approved sick time hours for the day |
| Approved_Non_Standard_Hours | FLOAT | Approved non-billable standard hours |
| Approved_Non_Overtime_Hours | FLOAT | Approved non-billable overtime hours |
| Approved_Non_Double_Time_Hours | FLOAT | Approved non-billable double time hours |
| Approved_Non_Sick_Time_Hours | FLOAT | Approved non-billable sick time hours |
| Consultant_Standard_Hours | FLOAT | Consultant-submitted standard hours |
| Consultant_Overtime_Hours | FLOAT | Consultant-submitted overtime hours |
| Consultant_Double_Time_Hours | FLOAT | Consultant-submitted double time hours |
| Total_Approved_Hours | FLOAT | Total approved hours (sum of all approved hour types) |
| Total_Consultant_Hours | FLOAT | Total consultant-submitted hours |
| load_timestamp | DATETIME | Timestamp when record was loaded into Silver layer |
| update_timestamp | DATETIME | Timestamp when record was last updated in Silver layer |
| data_quality_score | DECIMAL(5,2) | Data quality score percentage (0-100) |
| validation_status | VARCHAR(50) | Validation status (Passed, Failed, Warning) |

---

### 2.7 Si_Workflow_Task
**Description:** Curated workflow task data representing workflow or approval tasks related to resources and timesheet processes. This table tracks the status and progress of various HR and operational workflows.

**Source:** Derived from Bz_SchTask

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Candidate_Name | VARCHAR(101) | Name of the resource or consultant (concatenated First and Last Name) |
| Resource_Code | VARCHAR(50) | Unique code for the resource (GCI_ID) |
| Workflow_Task_Reference | NUMERIC(18,0) | Reference to the workflow or approval task (Process_ID) |
| Type | VARCHAR(50) | Onsite/Offshore indicator or workflow type |
| Tower | VARCHAR(60) | Business tower or division |
| Status | VARCHAR(50) | Current status of the workflow task |
| Comments | VARCHAR(8000) | Comments or notes for the task |
| Date_Created | DATETIME | Date the workflow task was created |
| Date_Completed | DATETIME | Date the workflow task was completed |
| Initiator | VARCHAR(50) | Name of the person who initiated the task |
| Initiator_Email | VARCHAR(50) | Email address of the task initiator |
| Level_ID | INT | Current level identifier in the workflow process |
| Last_Level | INT | Last completed level in the workflow process |
| Existing_Resource | VARCHAR(3) | Flag indicating if resource already exists |
| Legal_Entity | VARCHAR(50) | Legal entity associated with the task |
| load_timestamp | DATETIME | Timestamp when record was loaded into Silver layer |
| update_timestamp | DATETIME | Timestamp when record was last updated in Silver layer |
| data_quality_score | DECIMAL(5,2) | Data quality score percentage (0-100) |
| validation_status | VARCHAR(50) | Validation status (Passed, Failed, Warning) |

---

### 2.8 Si_Resource_Metrics
**Description:** Curated resource metrics table containing calculated KPIs and performance indicators for each resource by time period. This table supports utilization and FTE reporting.

**Source:** Derived from multiple Bronze tables through calculations and aggregations

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Resource_Code | VARCHAR(50) | Unique code for the resource |
| Period_Year_Month | INT | Year and month in YYYYMM format |
| Total_Hours | FLOAT | Number of working days × location hours (8 or 9) |
| Submitted_Hours | FLOAT | Total timesheet hours submitted by the resource |
| Approved_Hours | FLOAT | Total timesheet hours approved by the manager |
| Total_FTE | DECIMAL(10,4) | Submitted Hours / Total Hours |
| Billed_FTE | DECIMAL(10,4) | Approved Hours / Total Hours (or Submitted if Approved unavailable) |
| Project_Utilization | DECIMAL(10,4) | Billed Hours / Available Hours |
| Available_Hours | FLOAT | Monthly Hours × Total FTE |
| Actual_Hours | FLOAT | Actual hours worked by the resource |
| Onsite_Hours | FLOAT | Actual hours worked onsite |
| Offshore_Hours | FLOAT | Actual hours worked offshore |
| Working_Days | INT | Number of working days in the period |
| Location_Hours_Per_Day | INT | Hours per day based on location (8 or 9) |
| Billable_Hours | FLOAT | Total billable hours for the period |
| Non_Billable_Hours | FLOAT | Total non-billable hours for the period |
| load_timestamp | DATETIME | Timestamp when record was loaded into Silver layer |
| update_timestamp | DATETIME | Timestamp when record was last updated in Silver layer |
| data_quality_score | DECIMAL(5,2) | Data quality score percentage (0-100) |
| validation_status | VARCHAR(50) | Validation status (Passed, Failed, Warning) |

---

## 3. DATA QUALITY AND ERROR TRACKING TABLES

### 3.1 Si_Data_Quality_Error
**Description:** Silver layer error tracking table capturing all data quality validation failures, constraint violations, and business rule exceptions. This table enables data quality monitoring and remediation.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Error_Record_ID | BIGINT | Unique identifier for each error record |
| Source_Table | VARCHAR(200) | Name of the source Bronze table where error originated |
| Target_Table | VARCHAR(200) | Name of the target Silver table where error was detected |
| Record_Identifier | VARCHAR(500) | Business key or identifier of the record with error |
| Error_Type | VARCHAR(100) | Type of error (Validation, Constraint, Business Rule, Data Type, etc.) |
| Error_Category | VARCHAR(100) | Category of error (Completeness, Accuracy, Consistency, Validity) |
| Error_Severity | VARCHAR(50) | Severity level (Critical, High, Medium, Low, Warning) |
| Error_Code | VARCHAR(50) | Standardized error code for classification |
| Error_Description | VARCHAR(MAX) | Detailed description of the error |
| Column_Name | VARCHAR(200) | Name of the column where error occurred |
| Expected_Value | VARCHAR(500) | Expected value based on validation rule |
| Actual_Value | VARCHAR(500) | Actual value that caused the error |
| Validation_Rule | VARCHAR(500) | Validation rule that was violated |
| Business_Rule | VARCHAR(500) | Business rule that was violated |
| Error_Timestamp | DATETIME | Timestamp when error was detected |
| Processing_Batch_ID | VARCHAR(100) | Batch identifier for grouping related errors |
| Is_Resolved | BIT | Indicator if error has been resolved (1=Yes, 0=No) |
| Resolution_Date | DATETIME | Date when error was resolved |
| Resolution_Action | VARCHAR(500) | Action taken to resolve the error |
| Resolved_By | VARCHAR(100) | Username of person who resolved the error |
| Error_Count | INT | Number of times this error has occurred |
| First_Occurrence | DATETIME | First time this error was detected |
| Last_Occurrence | DATETIME | Most recent time this error was detected |
| Impact_Assessment | VARCHAR(500) | Assessment of business impact of the error |
| Remediation_Notes | VARCHAR(MAX) | Notes on remediation steps and actions |
| Created_Date | DATETIME | Date when error record was created |
| Modified_Date | DATETIME | Date when error record was last modified |

---

### 3.2 Si_Data_Quality_Metrics
**Description:** Silver layer data quality metrics table tracking quality scores, validation results, and data profiling statistics for each Silver table and column.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Metric_ID | BIGINT | Unique identifier for each metric record |
| Table_Name | VARCHAR(200) | Name of the Silver table being measured |
| Column_Name | VARCHAR(200) | Name of the column being measured (NULL for table-level metrics) |
| Metric_Type | VARCHAR(100) | Type of metric (Completeness, Accuracy, Consistency, Validity, Uniqueness) |
| Metric_Name | VARCHAR(200) | Name of the specific metric |
| Metric_Value | DECIMAL(18,6) | Calculated metric value |
| Metric_Unit | VARCHAR(50) | Unit of measurement (Percentage, Count, Ratio, etc.) |
| Threshold_Value | DECIMAL(18,6) | Threshold value for acceptable quality |
| Status | VARCHAR(50) | Status based on threshold (Passed, Failed, Warning) |
| Total_Records | BIGINT | Total number of records evaluated |
| Valid_Records | BIGINT | Number of valid records |
| Invalid_Records | BIGINT | Number of invalid records |
| Null_Count | BIGINT | Number of NULL values |
| Distinct_Count | BIGINT | Number of distinct values |
| Duplicate_Count | BIGINT | Number of duplicate values |
| Min_Value | VARCHAR(500) | Minimum value in the dataset |
| Max_Value | VARCHAR(500) | Maximum value in the dataset |
| Avg_Value | DECIMAL(18,6) | Average value (for numeric columns) |
| Measurement_Date | DATETIME | Date when metric was measured |
| Processing_Batch_ID | VARCHAR(100) | Batch identifier for grouping related metrics |
| Data_Quality_Score | DECIMAL(5,2) | Overall data quality score (0-100) |
| Trend | VARCHAR(50) | Trend indicator (Improving, Stable, Declining) |
| Previous_Score | DECIMAL(5,2) | Previous data quality score for comparison |
| Score_Change | DECIMAL(5,2) | Change in score from previous measurement |
| Comments | VARCHAR(MAX) | Additional comments or observations |
| Created_Date | DATETIME | Date when metric record was created |
| Modified_Date | DATETIME | Date when metric record was last modified |

---

### 3.3 Si_Data_Validation_Rules
**Description:** Silver layer validation rules repository defining all validation rules, business rules, and constraints applied during data quality checks.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Rule_ID | INT | Unique identifier for each validation rule |
| Rule_Name | VARCHAR(200) | Name of the validation rule |
| Rule_Type | VARCHAR(100) | Type of rule (Validation, Business Rule, Constraint, Transformation) |
| Rule_Category | VARCHAR(100) | Category of rule (Completeness, Accuracy, Consistency, Validity) |
| Target_Table | VARCHAR(200) | Name of the Silver table where rule is applied |
| Target_Column | VARCHAR(200) | Name of the column where rule is applied (NULL for table-level rules) |
| Rule_Description | VARCHAR(MAX) | Detailed description of the validation rule |
| Rule_Expression | VARCHAR(MAX) | SQL expression or logic for the rule |
| Error_Message | VARCHAR(500) | Error message to display when rule is violated |
| Error_Code | VARCHAR(50) | Standardized error code for the rule |
| Severity | VARCHAR(50) | Severity level (Critical, High, Medium, Low, Warning) |
| Is_Active | BIT | Indicator if rule is currently active (1=Yes, 0=No) |
| Threshold_Value | VARCHAR(200) | Threshold value for the rule |
| Action_On_Failure | VARCHAR(100) | Action to take when rule fails (Reject, Quarantine, Flag, Log) |
| Business_Owner | VARCHAR(100) | Business owner responsible for the rule |
| Technical_Owner | VARCHAR(100) | Technical owner responsible for implementation |
| Effective_Date | DATETIME | Date when rule becomes effective |
| Expiration_Date | DATETIME | Date when rule expires (NULL if no expiration) |
| Rule_Priority | INT | Priority order for rule execution |
| Execution_Frequency | VARCHAR(50) | How often rule is executed (Real-time, Batch, Daily, Weekly) |
| Last_Execution_Date | DATETIME | Date when rule was last executed |
| Execution_Count | INT | Number of times rule has been executed |
| Failure_Count | INT | Number of times rule has failed |
| Success_Rate | DECIMAL(5,2) | Success rate percentage |
| Created_By | VARCHAR(100) | Username of person who created the rule |
| Created_Date | DATETIME | Date when rule was created |
| Modified_By | VARCHAR(100) | Username of person who last modified the rule |
| Modified_Date | DATETIME | Date when rule was last modified |
| Comments | VARCHAR(MAX) | Additional comments or notes about the rule |

---

## 4. AUDIT AND PIPELINE EXECUTION TRACKING TABLES

### 4.1 Si_Pipeline_Execution_Audit
**Description:** Silver layer pipeline execution audit table tracking all ETL pipeline runs, data loads, transformations, and processing activities for operational monitoring and troubleshooting.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Execution_ID | BIGINT | Unique identifier for each pipeline execution |
| Pipeline_Name | VARCHAR(200) | Name of the ETL pipeline or data flow |
| Pipeline_Type | VARCHAR(100) | Type of pipeline (Batch, Streaming, Incremental, Full Load) |
| Source_System | VARCHAR(100) | Source system name from which data originated |
| Source_Table | VARCHAR(200) | Name of the source Bronze table |
| Target_Table | VARCHAR(200) | Name of the target Silver table |
| Execution_Status | VARCHAR(50) | Status of execution (Success, Failed, Partial, Running, Queued) |
| Start_Timestamp | DATETIME | Timestamp when pipeline execution started |
| End_Timestamp | DATETIME | Timestamp when pipeline execution completed |
| Duration_Seconds | DECIMAL(10,2) | Duration of execution in seconds |
| Records_Read | BIGINT | Number of records read from source |
| Records_Processed | BIGINT | Number of records successfully processed |
| Records_Inserted | BIGINT | Number of records inserted into target |
| Records_Updated | BIGINT | Number of records updated in target |
| Records_Deleted | BIGINT | Number of records deleted from target |
| Records_Rejected | BIGINT | Number of records rejected due to errors |
| Records_Quarantined | BIGINT | Number of records moved to quarantine |
| Data_Volume_MB | DECIMAL(18,2) | Volume of data processed in megabytes |
| Error_Count | INT | Number of errors encountered during execution |
| Warning_Count | INT | Number of warnings generated during execution |
| Error_Message | VARCHAR(MAX) | Detailed error message if execution failed |
| Error_Stack_Trace | VARCHAR(MAX) | Stack trace of error for debugging |
| Execution_Server | VARCHAR(100) | Server or node where pipeline executed |
| Executed_By | VARCHAR(100) | Username or service account that executed the pipeline |
| Execution_Mode | VARCHAR(50) | Execution mode (Manual, Scheduled, Triggered) |
| Batch_ID | VARCHAR(100) | Batch identifier for grouping related executions |
| Parent_Execution_ID | BIGINT | Parent execution ID for dependent pipelines |
| Retry_Count | INT | Number of retry attempts |
| Max_Retries | INT | Maximum number of retries allowed |
| Data_Quality_Score | DECIMAL(5,2) | Overall data quality score for this execution |
| Validation_Failures | INT | Number of validation failures |
| Business_Rule_Failures | INT | Number of business rule failures |
| Checkpoint_ID | VARCHAR(100) | Checkpoint identifier for incremental loads |
| Watermark_Value | VARCHAR(200) | High watermark value for incremental processing |
| Configuration_Version | VARCHAR(50) | Version of pipeline configuration used |
| Transformation_Rules_Applied | VARCHAR(MAX) | List of transformation rules applied |
| Data_Lineage_ID | VARCHAR(100) | Data lineage identifier for traceability |
| SLA_Target_Minutes | INT | SLA target for pipeline completion in minutes |
| SLA_Status | VARCHAR(50) | SLA status (Met, Missed, At Risk) |
| Performance_Metrics | VARCHAR(MAX) | JSON or XML containing detailed performance metrics |
| Resource_Utilization | VARCHAR(MAX) | JSON or XML containing resource utilization data |
| Notification_Sent | BIT | Indicator if notification was sent (1=Yes, 0=No) |
| Notification_Recipients | VARCHAR(500) | List of notification recipients |
| Comments | VARCHAR(MAX) | Additional comments or notes about the execution |
| Created_Date | DATETIME | Date when audit record was created |
| Modified_Date | DATETIME | Date when audit record was last modified |

---

### 4.2 Si_Data_Lineage
**Description:** Silver layer data lineage table tracking the flow of data from source to target, including all transformations, dependencies, and data movement history.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Lineage_ID | BIGINT | Unique identifier for each lineage record |
| Source_System | VARCHAR(100) | Source system name |
| Source_Database | VARCHAR(100) | Source database name |
| Source_Schema | VARCHAR(100) | Source schema name |
| Source_Table | VARCHAR(200) | Source table name |
| Source_Column | VARCHAR(200) | Source column name (NULL for table-level lineage) |
| Target_System | VARCHAR(100) | Target system name |
| Target_Database | VARCHAR(100) | Target database name |
| Target_Schema | VARCHAR(100) | Target schema name |
| Target_Table | VARCHAR(200) | Target table name |
| Target_Column | VARCHAR(200) | Target column name (NULL for table-level lineage) |
| Transformation_Type | VARCHAR(100) | Type of transformation (Direct Copy, Aggregation, Join, Calculation, etc.) |
| Transformation_Logic | VARCHAR(MAX) | Detailed transformation logic or SQL expression |
| Transformation_Rule_ID | INT | Reference to transformation rule in rule repository |
| Data_Flow_Direction | VARCHAR(50) | Direction of data flow (Bronze to Silver, Silver to Gold, etc.) |
| Dependency_Type | VARCHAR(100) | Type of dependency (Direct, Indirect, Calculated) |
| Dependency_Level | INT | Level in the dependency hierarchy |
| Is_Active | BIT | Indicator if lineage is currently active (1=Yes, 0=No) |
| Effective_Date | DATETIME | Date when lineage became effective |
| End_Date | DATETIME | Date when lineage ended (NULL if still active) |
| Pipeline_Name | VARCHAR(200) | Name of the pipeline that implements this lineage |
| Execution_Frequency | VARCHAR(50) | How often data flows through this lineage |
| Last_Execution_Date | DATETIME | Date when data last flowed through this lineage |
| Data_Quality_Impact | VARCHAR(100) | Impact on data quality (High, Medium, Low) |
| Business_Owner | VARCHAR(100) | Business owner responsible for this data flow |
| Technical_Owner | VARCHAR(100) | Technical owner responsible for implementation |
| Documentation_URL | VARCHAR(500) | URL to detailed documentation |
| Created_By | VARCHAR(100) | Username of person who created the lineage record |
| Created_Date | DATETIME | Date when lineage record was created |
| Modified_By | VARCHAR(100) | Username of person who last modified the record |
| Modified_Date | DATETIME | Date when lineage record was last modified |
| Comments | VARCHAR(MAX) | Additional comments or notes about the lineage |

---

### 4.3 Si_Processing_Checkpoint
**Description:** Silver layer checkpoint table storing processing state and watermarks for incremental data loads, enabling restart and recovery capabilities.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Checkpoint_ID | BIGINT | Unique identifier for each checkpoint |
| Pipeline_Name | VARCHAR(200) | Name of the ETL pipeline |
| Source_Table | VARCHAR(200) | Name of the source table |
| Target_Table | VARCHAR(200) | Name of the target table |
| Checkpoint_Type | VARCHAR(100) | Type of checkpoint (Timestamp, Sequence, Custom) |
| Watermark_Column | VARCHAR(200) | Column used for watermark tracking |
| Last_Watermark_Value | VARCHAR(200) | Last successfully processed watermark value |
| Current_Watermark_Value | VARCHAR(200) | Current watermark value being processed |
| Next_Watermark_Value | VARCHAR(200) | Next watermark value to be processed |
| Last_Processed_Timestamp | DATETIME | Timestamp of last successful processing |
| Records_Processed_Since_Checkpoint | BIGINT | Number of records processed since last checkpoint |
| Checkpoint_Status | VARCHAR(50) | Status of checkpoint (Active, Completed, Failed, Rollback) |
| Checkpoint_Timestamp | DATETIME | Timestamp when checkpoint was created |
| Execution_ID | BIGINT | Reference to pipeline execution ID |
| Batch_ID | VARCHAR(100) | Batch identifier for grouping |
| Is_Committed | BIT | Indicator if checkpoint is committed (1=Yes, 0=No) |
| Commit_Timestamp | DATETIME | Timestamp when checkpoint was committed |
| Rollback_Timestamp | DATETIME | Timestamp when checkpoint was rolled back (if applicable) |
| Retry_Count | INT | Number of retry attempts from this checkpoint |
| Error_Message | VARCHAR(MAX) | Error message if checkpoint failed |
| Recovery_Point | VARCHAR(200) | Recovery point identifier for restart |
| State_Data | VARCHAR(MAX) | JSON or XML containing additional state information |
| Created_By | VARCHAR(100) | Username or service account that created checkpoint |
| Created_Date | DATETIME | Date when checkpoint was created |
| Modified_Date | DATETIME | Date when checkpoint was last modified |
| Comments | VARCHAR(MAX) | Additional comments or notes |

---

## 5. RELATIONSHIPS BETWEEN SILVER TABLES

### 5.1 Primary Relationships

| Source Table | Related Table | Relationship Type | Key Field(s) | Description |
|--------------|---------------|-------------------|--------------|-------------|
| Si_Resource | Si_Timesheet_Entry | One-to-Many | Resource_Code | Each resource can have multiple timesheet entries |
| Si_Resource | Si_Project | Many-to-One | Project_Assignment = Project_Name | Resources are assigned to projects |
| Si_Resource | Si_Workflow_Task | One-to-Many | Resource_Code | Each resource can have multiple workflow tasks |
| Si_Resource | Si_Resource_Metrics | One-to-Many | Resource_Code | Each resource has metrics calculated for multiple periods |
| Si_Timesheet_Entry | Si_Date_Dimension | Many-to-One | Timesheet_Date = Calendar_Date | Timesheet entries are linked to calendar dates |
| Si_Timesheet_Entry | Si_Timesheet_Approval | One-to-One | Resource_Code, Timesheet_Date | Timesheet entries have corresponding approval records |
| Si_Timesheet_Approval | Si_Resource | Many-to-One | Resource_Code | Timesheet approvals are linked to resources |
| Si_Timesheet_Approval | Si_Date_Dimension | Many-to-One | Timesheet_Date = Calendar_Date | Timesheet approvals are linked to calendar dates |
| Si_Project | Si_Timesheet_Entry | One-to-Many | Project_Name via Project_Task_Reference | Projects have multiple timesheet entries |
| Si_Date_Dimension | Si_Holiday | One-to-Many | Calendar_Date = Holiday_Date | Calendar dates may have associated holidays |
| Si_Holiday | Si_Resource | Many-to-Many | Location matches Resource location | Holidays apply to resources based on location |
| Si_Resource_Metrics | Si_Resource | Many-to-One | Resource_Code | Metrics are calculated for each resource |
| Si_Resource_Metrics | Si_Date_Dimension | Many-to-One | Period_Year_Month derived from Calendar_Date | Metrics are calculated for specific time periods |
| Si_Workflow_Task | Si_Resource | Many-to-One | Resource_Code | Workflow tasks are associated with resources |

---

### 5.2 Data Quality and Audit Relationships

| Source Table | Related Table | Relationship Type | Key Field(s) | Description |
|--------------|---------------|-------------------|--------------|-------------|
| Si_Data_Quality_Error | All Silver Tables | Many-to-One | Target_Table | Errors are tracked for all Silver tables |
| Si_Data_Quality_Metrics | All Silver Tables | Many-to-One | Table_Name | Metrics are calculated for all Silver tables |
| Si_Data_Validation_Rules | All Silver Tables | One-to-Many | Target_Table | Validation rules are applied to Silver tables |
| Si_Pipeline_Execution_Audit | All Silver Tables | One-to-Many | Target_Table | Pipeline executions load data into Silver tables |
| Si_Data_Lineage | All Silver Tables | Many-to-Many | Source_Table, Target_Table | Lineage tracks data flow between tables |
| Si_Processing_Checkpoint | Si_Pipeline_Execution_Audit | Many-to-One | Execution_ID | Checkpoints are created during pipeline executions |
| Si_Data_Quality_Error | Si_Data_Validation_Rules | Many-to-One | Error_Code = Rule_ID | Errors reference validation rules |
| Si_Data_Quality_Metrics | Si_Data_Validation_Rules | Many-to-One | Metric_Type related to Rule_Type | Metrics measure rule compliance |

---

## 6. DERIVATION FROM BRONZE LAYER

### 6.1 Si_Resource Derivation
**Bronze Sources:** Bz_New_Monthly_HC_Report, Bz_report_392_all

**Transformation Logic:**
- Merge data from both Bronze tables using gci_id as the key
- Standardize Business_Type values (FTE, Consultant, Contractor)
- Calculate Available_Hours based on Expected_Hours and allocation
- Derive Business_Area from location and market fields
- Cleanse and standardize name fields
- Apply data quality validations for completeness and accuracy

**Excluded Bronze Columns:**
- All ID fields (id, numeric identifiers)
- Internal system fields (TS, system_runtime)
- Detailed rate and financial fields not required for reporting
- Redundant date fields (FirstDay, LastDay when Start_Date and Termination_Date exist)
- Detailed workflow fields (ee_wf_reason, req_type)

---

### 6.2 Si_Timesheet_Entry Derivation
**Bronze Source:** Bz_Timesheet_New

**Transformation Logic:**
- Rename columns to business-friendly names (ST → Standard_Hours, OT → Overtime_Hours)
- Calculate Total_Hours_Submitted as sum of all hour types
- Validate that total daily hours do not exceed 24
- Validate that timesheet date is within resource employment period
- Apply business rules for hour type validations
- Standardize date formats

**Excluded Bronze Columns:**
- load_timestamp, update_timestamp, source_system (replaced with Silver layer equivalents)

---

### 6.3 Si_Project Derivation
**Bronze Sources:** Bz_report_392_all, Bz_Hiring_Initiator_Project_Info

**Transformation Logic:**
- Extract unique projects from report_392_all using ITSSProjectName
- Merge with project details from Hiring_Initiator_Project_Info
- Apply billing type classification rules (Billable/NBL)
- Apply category classification rules based on client and project attributes
- Standardize project names and client names
- Calculate derived fields like Net_Bill_Rate
- Validate project dates (end date >= start date)

**Excluded Bronze Columns:**
- All resource-specific fields (employee names, GCI_ID)
- Detailed financial fields not required for project master
- Internal workflow fields
- Redundant or duplicate project identifiers

---

### 6.4 Si_Date_Dimension Derivation
**Bronze Source:** Bz_DimDate

**Transformation Logic:**
- Direct mapping of most date attributes
- Calculate Is_Working_Day based on weekends and holidays
- Calculate Is_Weekend based on Day_Name
- Standardize date format fields
- Ensure continuous date range without gaps

**Excluded Bronze Columns:**
- load_timestamp, update_timestamp, source_system (replaced with Silver layer equivalents)

---

### 6.5 Si_Holiday Derivation
**Bronze Sources:** Bz_holidays, Bz_holidays_India, Bz_holidays_Mexico, Bz_holidays_Canada

**Transformation Logic:**
- Union all holiday tables into single Silver table
- Standardize Location values
- Add Is_Active flag for current holidays
- Remove duplicate holidays across locations
- Validate holiday dates are valid calendar dates

**Excluded Bronze Columns:**
- load_timestamp, update_timestamp, source_system (replaced with Silver layer equivalents)

---

### 6.6 Si_Timesheet_Approval Derivation
**Bronze Sources:** Bz_vw_billing_timesheet_daywise_ne, Bz_vw_consultant_timesheet_daywise

**Transformation Logic:**
- Merge billing and consultant timesheet views using GCI_ID and PE_DATE
- Rename columns to business-friendly names
- Calculate Total_Approved_Hours and Total_Consultant_Hours
- Validate approved hours do not exceed submitted hours
- Apply business rules for billable vs non-billable hours

**Excluded Bronze Columns:**
- ID field (internal identifier)
- load_timestamp, update_timestamp, source_system (replaced with Silver layer equivalents)

---

### 6.7 Si_Workflow_Task Derivation
**Bronze Source:** Bz_SchTask

**Transformation Logic:**
- Concatenate FName and LName to create Candidate_Name
- Map GCI_ID to Resource_Code
- Map Process_ID to Workflow_Task_Reference
- Derive Tower from business context
- Standardize Status values
- Validate date logic (Date_Completed >= Date_Created)

**Excluded Bronze Columns:**
- SSN (PII field not required in Silver layer)
- Term_ID (internal identifier)
- TS (timestamp field)
- load_timestamp, update_timestamp, source_system (replaced with Silver layer equivalents)

---

### 6.8 Si_Resource_Metrics Derivation
**Bronze Sources:** Multiple tables (Bz_New_Monthly_HC_Report, Bz_Timesheet_New, Bz_vw_billing_timesheet_daywise_ne, Bz_vw_consultant_timesheet_daywise, Bz_DimDate, Bz_holidays*)

**Transformation Logic:**
- Aggregate timesheet data by Resource_Code and Period_Year_Month
- Calculate working days excluding weekends and holidays based on location
- Calculate Total_Hours = Working_Days × Location_Hours_Per_Day (8 or 9)
- Calculate Submitted_Hours from timesheet entries
- Calculate Approved_Hours from approval data
- Calculate Total_FTE = Submitted_Hours / Total_Hours
- Calculate Billed_FTE = Approved_Hours / Total_Hours (use Submitted if Approved unavailable)
- Calculate Available_Hours = Monthly_Hours × Total_FTE
- Calculate Project_Utilization = Billed_Hours / Available_Hours
- Separate Onsite_Hours and Offshore_Hours based on location
- Apply all business rules for FTE and utilization calculations

**Excluded Bronze Columns:**
- This is a derived/calculated table, not a direct mapping

---

## 7. CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORM)

### 7.1 Core Business Entity Relationships

| Entity 1 | Relationship | Entity 2 | Key Field(s) | Cardinality | Description |
|----------|--------------|----------|--------------|-------------|-------------|
| Si_Resource | submits | Si_Timesheet_Entry | Resource_Code | 1:M | A resource submits multiple timesheet entries over time |
| Si_Resource | assigned to | Si_Project | Resource_Code → Project_Assignment = Project_Name | M:1 | A resource is assigned to one project at a time (can change over time) |
| Si_Resource | has | Si_Workflow_Task | Resource_Code | 1:M | A resource can have multiple workflow tasks |
| Si_Resource | measured by | Si_Resource_Metrics | Resource_Code | 1:M | A resource has metrics calculated for multiple time periods |
| Si_Timesheet_Entry | recorded on | Si_Date_Dimension | Timesheet_Date = Calendar_Date | M:1 | Timesheet entries are recorded on specific calendar dates |
| Si_Timesheet_Entry | approved as | Si_Timesheet_Approval | Resource_Code + Timesheet_Date | 1:1 | Each timesheet entry has corresponding approval record |
| Si_Timesheet_Entry | logged for | Si_Project | Project_Task_Reference → Project_Name | M:1 | Timesheet entries are logged for specific projects |
| Si_Timesheet_Approval | approves work for | Si_Resource | Resource_Code | M:1 | Timesheet approvals are for specific resources |
| Si_Timesheet_Approval | approved on | Si_Date_Dimension | Timesheet_Date = Calendar_Date | M:1 | Approvals are recorded on specific dates |
| Si_Project | has | Si_Timesheet_Entry | Project_Name via Project_Task_Reference | 1:M | Projects have multiple timesheet entries from various resources |
| Si_Project | employs | Si_Resource | Project_Name = Project_Assignment | 1:M | Projects employ multiple resources |
| Si_Date_Dimension | may have | Si_Holiday | Calendar_Date = Holiday_Date | 1:M | Calendar dates may have associated holidays (multiple locations) |
| Si_Holiday | applies to | Si_Resource | Location matches Resource location | M:M | Holidays apply to resources based on their location |
| Si_Resource_Metrics | calculated for | Si_Resource | Resource_Code | M:1 | Metrics are calculated for each resource |
| Si_Resource_Metrics | for period | Si_Date_Dimension | Period_Year_Month derived from Calendar_Date | M:1 | Metrics are calculated for specific time periods |
| Si_Workflow_Task | assigned to | Si_Resource | Resource_Code | M:1 | Workflow tasks are assigned to specific resources |

---

### 7.2 Data Quality and Audit Relationships

| Entity 1 | Relationship | Entity 2 | Key Field(s) | Cardinality | Description |
|----------|--------------|----------|--------------|-------------|-------------|
| Si_Data_Quality_Error | tracks errors in | All Silver Tables | Target_Table | M:1 | Errors are tracked for all Silver tables |
| Si_Data_Quality_Metrics | measures quality of | All Silver Tables | Table_Name | M:1 | Metrics measure quality of all Silver tables |
| Si_Data_Validation_Rules | validates | All Silver Tables | Target_Table | 1:M | Rules validate data in Silver tables |
| Si_Pipeline_Execution_Audit | loads data into | All Silver Tables | Target_Table | 1:M | Pipeline executions load data into Silver tables |
| Si_Data_Lineage | traces data flow between | All Silver Tables | Source_Table, Target_Table | M:M | Lineage traces data movement and transformations |
| Si_Processing_Checkpoint | created during | Si_Pipeline_Execution_Audit | Execution_ID | M:1 | Checkpoints are created during pipeline runs |
| Si_Data_Quality_Error | references | Si_Data_Validation_Rules | Error_Code = Rule_ID | M:1 | Errors reference the validation rules that were violated |
| Si_Data_Quality_Metrics | measures compliance with | Si_Data_Validation_Rules | Metric_Type related to Rule_Type | M:M | Metrics measure compliance with validation rules |

---

### 7.3 Cross-Layer Relationships (Bronze to Silver)

| Bronze Table | Relationship | Silver Table | Key Field(s) | Transformation Type |
|--------------|--------------|--------------|--------------|---------------------|
| Bz_New_Monthly_HC_Report | transforms to | Si_Resource | gci_id → Resource_Code | Merge, Cleanse, Standardize |
| Bz_report_392_all | transforms to | Si_Resource | gci_id → Resource_Code | Merge, Enrich |
| Bz_report_392_all | transforms to | Si_Project | ITSSProjectName → Project_Name | Extract, Deduplicate, Classify |
| Bz_Hiring_Initiator_Project_Info | transforms to | Si_Project | Project_Name | Merge, Enrich |
| Bz_Timesheet_New | transforms to | Si_Timesheet_Entry | gci_id → Resource_Code, pe_date → Timesheet_Date | Rename, Calculate, Validate |
| Bz_vw_billing_timesheet_daywise_ne | transforms to | Si_Timesheet_Approval | GCI_ID → Resource_Code, PE_DATE → Timesheet_Date | Merge, Rename, Calculate |
| Bz_vw_consultant_timesheet_daywise | transforms to | Si_Timesheet_Approval | GCI_ID → Resource_Code, PE_DATE → Timesheet_Date | Merge, Rename |
| Bz_DimDate | transforms to | Si_Date_Dimension | Date → Calendar_Date | Direct Map, Calculate |
| Bz_holidays | transforms to | Si_Holiday | Holiday_Date | Union, Standardize |
| Bz_holidays_India | transforms to | Si_Holiday | Holiday_Date | Union, Standardize |
| Bz_holidays_Mexico | transforms to | Si_Holiday | Holiday_Date | Union, Standardize |
| Bz_holidays_Canada | transforms to | Si_Holiday | Holiday_Date | Union, Standardize |
| Bz_SchTask | transforms to | Si_Workflow_Task | GCI_ID → Resource_Code, Process_ID → Workflow_Task_Reference | Rename, Concatenate, Validate |
| Multiple Bronze Tables | aggregates to | Si_Resource_Metrics | gci_id → Resource_Code | Aggregate, Calculate KPIs |

---

## 8. KEY DESIGN DECISIONS AND RATIONALE

### 8.1 Table Selection Decisions

**Decision 1: Selective Column Inclusion**
- **Rationale:** Only columns explicitly mentioned or implied in the Conceptual Model and Data Constraints are included in Silver layer. This ensures the Silver layer contains only business-relevant data and reduces storage and processing overhead.
- **Impact:** Bronze tables contain 100+ columns each, but Silver tables contain 20-30 business-relevant columns.

**Decision 2: Derived Metrics Table (Si_Resource_Metrics)**
- **Rationale:** KPIs like Total FTE, Billed FTE, and Project Utilization are calculated and stored in a separate metrics table rather than in the resource table. This separates master data from time-series metrics and improves query performance.
- **Impact:** Enables efficient time-series analysis and trend reporting without complex joins.

**Decision 3: Unified Holiday Table**
- **Rationale:** Four separate Bronze holiday tables are consolidated into a single Silver holiday table with a Location column. This simplifies queries and maintenance while preserving location-specific holiday information.
- **Impact:** Reduces table count and simplifies holiday-based calculations.

**Decision 4: Comprehensive Data Quality Framework**
- **Rationale:** Three dedicated tables (Si_Data_Quality_Error, Si_Data_Quality_Metrics, Si_Data_Validation_Rules) provide complete data quality tracking. This enables proactive data quality monitoring and remediation.
- **Impact:** Ensures data quality is measurable, traceable, and improvable over time.

---

### 8.2 Data Type Standardization Decisions

**Decision 1: Consistent Date Handling**
- **Rationale:** All date fields use DATETIME data type consistently across all Silver tables, matching Bronze layer standard.
- **Impact:** Ensures consistent date comparisons and calculations across all tables.

**Decision 2: Numeric Precision for Metrics**
- **Rationale:** FTE and utilization metrics use DECIMAL(10,4) to provide sufficient precision for percentage calculations while avoiding floating-point rounding issues.
- **Impact:** Ensures accurate FTE calculations and reporting.

**Decision 3: VARCHAR Sizing**
- **Rationale:** VARCHAR column sizes are standardized based on Bronze layer analysis and business requirements (e.g., names=50, codes=50, descriptions=200).
- **Impact:** Optimizes storage while ensuring sufficient capacity for business data.

**Decision 4: Money vs Decimal for Financial Fields**
- **Rationale:** MONEY data type is used for bill rates and financial amounts, matching Bronze layer and SQL Server best practices for financial data.
- **Impact:** Ensures accurate financial calculations and proper currency handling.

---

### 8.3 Naming Convention Decisions

**Decision 1: Si_ Prefix for All Silver Tables**
- **Rationale:** Consistent "Si_" prefix clearly identifies Silver layer tables and prevents naming conflicts with Bronze (Bz_) and Gold layers.
- **Impact:** Improves code readability and layer identification.

**Decision 2: Business-Friendly Column Names**
- **Rationale:** Column names are transformed from technical names (gci_id, pe_date) to business-friendly names (Resource_Code, Timesheet_Date) to improve understanding and adoption.
- **Impact:** Makes data more accessible to business users and reduces training requirements.

**Decision 3: Standardized Metadata Columns**
- **Rationale:** All Silver tables include consistent metadata columns (load_timestamp, update_timestamp, data_quality_score, validation_status) for tracking and quality monitoring.
- **Impact:** Enables consistent auditing and quality tracking across all tables.

---

### 8.4 Relationship Design Decisions

**Decision 1: Logical Relationships Only**
- **Rationale:** Silver layer uses logical relationships based on business keys rather than enforced foreign key constraints. This provides flexibility for data quality issues while maintaining referential integrity through validation rules.
- **Impact:** Allows data to be loaded even with temporary referential integrity issues, which are tracked in error tables.

**Decision 2: Many-to-Many Relationships via Business Logic**
- **Rationale:** Complex many-to-many relationships (e.g., Resource to Holiday via Location) are implemented through business logic rather than junction tables.
- **Impact:** Simplifies data model while maintaining relationship semantics.

---

### 8.5 Data Quality Design Decisions

**Decision 1: Separate Error Tracking Table**
- **Rationale:** Data quality errors are tracked in a dedicated table (Si_Data_Quality_Error) rather than flagging records in source tables. This separates operational data from quality metadata.
- **Impact:** Enables comprehensive error analysis without impacting source table structure.

**Decision 2: Quality Score on Every Record**
- **Rationale:** Each record in Silver tables includes a data_quality_score column, enabling record-level quality tracking and filtering.
- **Impact:** Allows users to filter data by quality threshold and track quality trends.

**Decision 3: Validation Rules Repository**
- **Rationale:** All validation rules are stored in Si_Data_Validation_Rules table, enabling dynamic rule management and documentation.
- **Impact:** Centralizes rule management and enables rule versioning and auditing.

---

### 8.6 Audit Design Decisions

**Decision 1: Comprehensive Pipeline Audit**
- **Rationale:** Si_Pipeline_Execution_Audit table captures detailed execution metrics including timing, record counts, errors, and performance data.
- **Impact:** Enables operational monitoring, troubleshooting, and SLA tracking.

**Decision 2: Data Lineage Tracking**
- **Rationale:** Si_Data_Lineage table documents all data flows and transformations, supporting impact analysis and compliance requirements.
- **Impact:** Provides complete data lineage for regulatory compliance and impact analysis.

**Decision 3: Checkpoint-Based Processing**
- **Rationale:** Si_Processing_Checkpoint table enables incremental processing and restart capabilities for large data volumes.
- **Impact:** Improves processing efficiency and enables recovery from failures.

---

## 9. ASSUMPTIONS

### 9.1 Data Assumptions

1. **Data Completeness:** It is assumed that Bronze layer contains all required source data, though some records may have missing or invalid values that will be handled through data quality processes.

2. **Data Refresh Frequency:** Silver layer is assumed to be refreshed on a daily basis, with incremental loads for large tables and full loads for smaller reference tables.

3. **Historical Data:** It is assumed that historical data will be preserved in Silver layer for at least 7 years to support trend analysis and regulatory compliance.

4. **Data Volume:** The design assumes moderate to high data volumes:
   - Si_Resource: ~10,000 records
   - Si_Timesheet_Entry: ~1 million records per month
   - Si_Project: ~5,000 records
   - Si_Resource_Metrics: ~120,000 records per year (10,000 resources × 12 months)

---

### 9.2 Business Rule Assumptions

1. **FTE Calculation:** It is assumed that Total FTE can exceed 1.0 for resources working overtime, with a practical maximum of 2.0.

2. **Working Hours:** It is assumed that:
   - Offshore (India) resources work 9 hours per day
   - Onshore (US, Canada, LATAM) resources work 8 hours per day
   - These standards are consistent across the organization

3. **Holiday Handling:** It is assumed that holidays are location-specific and that resources observe holidays based on their primary work location.

4. **Approval Workflow:** It is assumed that if approved hours are not available, submitted hours can be used as a fallback for billing calculations.

5. **Project Assignment:** It is assumed that a resource is assigned to one primary project at a time, though they may log hours to multiple projects.

---

### 9.3 Technical Assumptions

1. **SQL Server Version:** The design assumes SQL Server 2016 or later, supporting modern data types and features.

2. **Data Quality Thresholds:** It is assumed that:
   - Data quality score >= 95% is considered "Passed"
   - Data quality score 85-95% is considered "Warning"
   - Data quality score < 85% is considered "Failed"

3. **Performance Requirements:** It is assumed that:
   - Silver layer queries should complete within 30 seconds for interactive reporting
   - Batch processing should complete within 4-hour windows
   - Data quality checks should complete within 1 hour

4. **Concurrency:** It is assumed that Silver layer supports concurrent read access from multiple users and reporting tools, with write access controlled through ETL pipelines.

---

### 9.4 Integration Assumptions

1. **Source System Stability:** It is assumed that Bronze layer schema is stable, with any changes managed through formal change control processes.

2. **Data Lineage:** It is assumed that all data transformations from Bronze to Silver are documented in the Si_Data_Lineage table.

3. **Error Handling:** It is assumed that records failing validation are quarantined rather than rejected, allowing for manual review and correction.

4. **Audit Requirements:** It is assumed that all data loads, transformations, and quality checks must be audited for compliance purposes.

---

### 9.5 Organizational Assumptions

1. **Data Ownership:** It is assumed that:
   - Business owners are responsible for defining validation rules and quality thresholds
   - Technical owners are responsible for implementing and maintaining the Silver layer
   - Data stewards are responsible for resolving data quality issues

2. **Access Control:** It is assumed that:
   - Role-based access control (RBAC) is implemented at the table and column level
   - PII data is masked or encrypted for non-privileged users
   - Audit logs are retained for compliance purposes

3. **Data Governance:** It is assumed that:
   - Data quality metrics are reviewed weekly
   - Validation rules are reviewed and updated quarterly
   - Data lineage is documented and maintained for all data flows

---

## 10. VALIDATION RULES AND BUSINESS LOGIC

### 10.1 Si_Resource Validation Rules

1. **Mandatory Fields:**
   - Resource_Code, First_Name, Last_Name, Business_Type, Start_Date must not be NULL

2. **Date Logic:**
   - Termination_Date must be >= Start_Date (if populated)
   - Start_Date must be <= Current Date

3. **Status Consistency:**
   - If Status = 'Terminated', Termination_Date must be populated
   - If Status = 'Active', Termination_Date should be NULL

4. **Business Type Values:**
   - Business_Type must be one of: 'FTE', 'Consultant', 'Contractor'

5. **Location Consistency:**
   - If Is_Offshore = 'Offshore', Expected_Hours should be based on 9-hour day
   - If Is_Offshore = 'Onsite', Expected_Hours should be based on 8-hour day

---

### 10.2 Si_Timesheet_Entry Validation Rules

1. **Mandatory Fields:**
   - Resource_Code, Timesheet_Date, Project_Task_Reference must not be NULL
   - At least one hour type field must have value > 0

2. **Hour Constraints:**
   - All hour fields must be >= 0
   - Total daily hours (sum of all hour types) should not exceed 24
   - Standard_Hours should typically be <= 12 per day

3. **Date Logic:**
   - Timesheet_Date must exist in Si_Date_Dimension
   - Timesheet_Date must be within Resource employment period (Start_Date to Termination_Date)
   - Timesheet_Date must be <= Current Date (no future timesheets)

4. **Calculation Validation:**
   - Total_Hours_Submitted must equal sum of all hour type fields

5. **Reference Validation:**
   - Resource_Code must exist in Si_Resource
   - Project_Task_Reference should reference valid project

---

### 10.3 Si_Project Validation Rules

1. **Mandatory Fields:**
   - Project_Name, Client_Name, Client_Code, Billing_Type must not be NULL

2. **Date Logic:**
   - Project_End_Date must be >= Project_Start_Date (if both populated)
   - Project_Start_Date must be valid calendar date

3. **Billing Type Values:**
   - Billing_Type must be one of: 'Billable', 'NBL'

4. **Category Values:**
   - Category must be one of: 'India Billing - Client-NBL', 'India Billing - Billable', 'India Billing - Project NBL', 'Client-NBL', 'Project-NBL', 'Billable', 'AVA', 'ELT Project', 'Bench'

5. **Status Values:**
   - Status must be one of: 'Billed', 'Unbilled', 'SGA', 'AVA', 'Bench'

6. **Financial Validation:**
   - Net_Bill_Rate should be > 0 for Billable projects
   - Net_Bill_Rate may be <= 0 for NBL projects

---

### 10.4 Si_Timesheet_Approval Validation Rules

1. **Mandatory Fields:**
   - Resource_Code, Timesheet_Date must not be NULL

2. **Hour Constraints:**
   - All approved hour fields must be >= 0
   - Approved hours should not exceed corresponding submitted hours
   - Total_Approved_Hours must equal sum of all approved hour type fields

3. **Reference Validation:**
   - Resource_Code must exist in Si_Resource
   - Timesheet_Date must exist in Si_Date_Dimension
   - Corresponding record should exist in Si_Timesheet_Entry

4. **Billing Indicator:**
   - Billing_Indicator must be 'Yes' or 'No'

---

### 10.5 Si_Resource_Metrics Validation Rules

1. **Mandatory Fields:**
   - Resource_Code, Period_Year_Month must not be NULL

2. **Calculation Validation:**
   - Total_Hours must equal Working_Days × Location_Hours_Per_Day
   - Total_FTE must equal Submitted_Hours / Total_Hours (if Total_Hours > 0)
   - Billed_FTE must equal Approved_Hours / Total_Hours (if Total_Hours > 0)
   - Project_Utilization must equal Billable_Hours / Available_Hours (if Available_Hours > 0)
   - Available_Hours must equal Total_Hours × Total_FTE

3. **Range Validation:**
   - Total_FTE should be between 0 and 2.0
   - Billed_FTE should be between 0 and Total_FTE
   - Project_Utilization should be between 0 and 1.0
   - All hour fields must be >= 0

4. **Reference Validation:**
   - Resource_Code must exist in Si_Resource
   - Period_Year_Month must be valid YYYYMM format

---

### 10.6 Cross-Table Validation Rules

1. **Timesheet to Resource:**
   - All Resource_Code values in Si_Timesheet_Entry must exist in Si_Resource
   - Timesheet_Date must be within Resource employment period

2. **Timesheet to Approval:**
   - Each Si_Timesheet_Entry record should have corresponding Si_Timesheet_Approval record
   - Approved hours should not exceed submitted hours

3. **Resource to Project:**
   - Project_Assignment in Si_Resource should reference valid Project_Name in Si_Project

4. **Metrics Consistency:**
   - Sum of hours in Si_Resource_Metrics should reconcile with sum of hours in Si_Timesheet_Entry for same period

---

## 11. DATA TRANSFORMATION SUMMARY

### 11.1 Transformation Categories

| Transformation Type | Description | Examples |
|---------------------|-------------|----------|
| Rename | Column names changed to business-friendly names | gci_id → Resource_Code, pe_date → Timesheet_Date |
| Merge | Multiple Bronze tables merged into single Silver table | Bz_New_Monthly_HC_Report + Bz_report_392_all → Si_Resource |
| Calculate | Derived fields calculated from source data | Total_Hours_Submitted, Total_FTE, Billed_FTE |
| Standardize | Values standardized to consistent format | Business_Type values, Status values |
| Cleanse | Data cleansed and validated | Name trimming, date validation |
| Enrich | Additional context added | Data_quality_score, validation_status |
| Aggregate | Data aggregated to higher level | Si_Resource_Metrics aggregated from timesheet data |
| Union | Multiple tables combined | Four holiday tables → Si_Holiday |
| Filter | Unnecessary data filtered out | Only business-relevant columns included |
| Classify | Data classified based on business rules | Billing_Type, Category classification |

---

### 11.2 Key Transformations by Table

**Si_Resource:**
- Merge Bz_New_Monthly_HC_Report and Bz_report_392_all
- Rename gci_id to Resource_Code
- Standardize Business_Type values
- Calculate Available_Hours
- Cleanse name fields
- Add data quality metadata

**Si_Timesheet_Entry:**
- Rename hour type columns (ST → Standard_Hours, etc.)
- Calculate Total_Hours_Submitted
- Validate hour constraints
- Add data quality metadata

**Si_Project:**
- Extract unique projects from Bz_report_392_all
- Merge with Bz_Hiring_Initiator_Project_Info
- Apply billing type classification rules
- Apply category classification rules
- Standardize project and client names
- Add data quality metadata

**Si_Date_Dimension:**
- Direct mapping from Bz_DimDate
- Calculate Is_Working_Day and Is_Weekend
- Add data quality metadata

**Si_Holiday:**
- Union four Bronze holiday tables
- Standardize Location values
- Add Is_Active flag
- Remove duplicates
- Add data quality metadata

**Si_Timesheet_Approval:**
- Merge Bz_vw_billing_timesheet_daywise_ne and Bz_vw_consultant_timesheet_daywise
- Rename columns
- Calculate total hours
- Validate approved vs submitted hours
- Add data quality metadata

**Si_Workflow_Task:**
- Concatenate FName and LName
- Rename key fields
- Standardize Status values
- Add data quality metadata

**Si_Resource_Metrics:**
- Aggregate timesheet data by resource and period
- Calculate working days excluding weekends and holidays
- Calculate all KPIs (Total_Hours, Total_FTE, Billed_FTE, etc.)
- Apply location-based hour calculations
- Add data quality metadata

---

## 12. PERFORMANCE CONSIDERATIONS

### 12.1 Indexing Recommendations

**Si_Resource:**
- Clustered index on Resource_Code
- Non-clustered index on Status, Business_Area
- Non-clustered index on Project_Assignment

**Si_Timesheet_Entry:**
- Clustered index on Resource_Code, Timesheet_Date
- Non-clustered index on Project_Task_Reference
- Non-clustered index on Timesheet_Date

**Si_Project:**
- Clustered index on Project_Name
- Non-clustered index on Client_Code
- Non-clustered index on Billing_Type, Status

**Si_Date_Dimension:**
- Clustered index on Calendar_Date
- Non-clustered index on Year, Month_Number
- Non-clustered index on Is_Working_Day

**Si_Timesheet_Approval:**
- Clustered index on Resource_Code, Timesheet_Date
- Non-clustered index on Billing_Indicator

**Si_Resource_Metrics:**
- Clustered index on Resource_Code, Period_Year_Month
- Non-clustered index on Period_Year_Month

---

### 12.2 Partitioning Recommendations

1. **Si_Timesheet_Entry:** Partition by Timesheet_Date (monthly partitions) to improve query performance and enable efficient archival.

2. **Si_Timesheet_Approval:** Partition by Timesheet_Date (monthly partitions) aligned with Si_Timesheet_Entry.

3. **Si_Resource_Metrics:** Partition by Period_Year_Month (monthly partitions) for efficient time-series queries.

4. **Si_Data_Quality_Error:** Partition by Error_Timestamp (monthly partitions) to manage error history.

5. **Si_Pipeline_Execution_Audit:** Partition by Start_Timestamp (monthly partitions) to manage audit history.

---

### 12.3 Query Optimization Recommendations

1. **Materialized Views:** Consider creating materialized views for frequently accessed aggregations (e.g., monthly resource utilization summary).

2. **Columnstore Indexes:** Consider columnstore indexes on large fact tables (Si_Timesheet_Entry, Si_Resource_Metrics) for analytical queries.

3. **Statistics:** Ensure statistics are updated regularly on all indexed columns to support query optimizer.

4. **Query Hints:** Use appropriate query hints (e.g., NOLOCK for reporting queries) to balance consistency and performance.

---

## 13. DATA QUALITY FRAMEWORK

### 13.1 Data Quality Dimensions

1. **Completeness:** Measures the percentage of required fields that are populated
   - Target: >= 95% for mandatory fields
   - Tracked in Si_Data_Quality_Metrics

2. **Accuracy:** Measures the percentage of records that pass validation rules
   - Target: >= 95% for critical fields
   - Tracked in Si_Data_Quality_Metrics

3. **Consistency:** Measures the percentage of records that are consistent across related tables
   - Target: >= 98% for referential integrity
   - Tracked in Si_Data_Quality_Metrics

4. **Validity:** Measures the percentage of records that conform to domain constraints
   - Target: >= 95% for domain values
   - Tracked in Si_Data_Quality_Metrics

5. **Uniqueness:** Measures the percentage of records that are unique based on business keys
   - Target: 100% for unique constraints
   - Tracked in Si_Data_Quality_Metrics

---

### 13.2 Data Quality Monitoring

1. **Real-time Monitoring:** Data quality checks are executed during ETL pipeline execution, with errors logged to Si_Data_Quality_Error.

2. **Batch Monitoring:** Comprehensive data quality metrics are calculated daily and stored in Si_Data_Quality_Metrics.

3. **Alerting:** Automated alerts are triggered when data quality scores fall below thresholds.

4. **Reporting:** Data quality dashboards provide visibility into quality trends and issues.

---

### 13.3 Error Remediation Process

1. **Detection:** Errors are detected during ETL pipeline execution and logged to Si_Data_Quality_Error.

2. **Classification:** Errors are classified by type, category, and severity.

3. **Notification:** Data stewards are notified of critical and high-severity errors.

4. **Investigation:** Data stewards investigate errors and determine root cause.

5. **Remediation:** Errors are corrected in source systems or through manual data fixes.

6. **Validation:** Corrected data is revalidated to ensure errors are resolved.

7. **Documentation:** Remediation actions are documented in Si_Data_Quality_Error.

---

## 14. SECURITY AND COMPLIANCE

### 14.1 PII Data Handling

The following columns contain PII and require special handling:

**Si_Resource:**
- First_Name, Last_Name (Personal identifiers)
- Resource_Code (Employee identifier)

**Si_Workflow_Task:**
- Candidate_Name (Personal identifier)
- Resource_Code (Employee identifier)
- Initiator, Initiator_Email (Personal identifiers)

**Security Measures:**
1. **Data Masking:** PII fields are masked for non-privileged users
2. **Encryption:** PII data is encrypted at rest and in transit
3. **Access Control:** Role-based access control restricts PII access to authorized users
4. **Audit Logging:** All access to PII data is logged for compliance

---

### 14.2 Compliance Requirements

1. **GDPR Compliance:**
   - Right to access: Users can request their personal data
   - Right to erasure: Personal data can be deleted upon request
   - Data minimization: Only necessary PII is stored
   - Audit trail: All PII access is logged

2. **Data Retention:**
   - Operational data: 7 years
   - Audit logs: 7 years
   - Error logs: 2 years
   - PII data: Deleted upon request or after retention period

3. **Data Lineage:**
   - Complete lineage tracked in Si_Data_Lineage
   - Transformation logic documented
   - Impact analysis supported

---

## 15. IMPLEMENTATION ROADMAP

### Phase 1: Core Tables (Weeks 1-2)
- Implement Si_Resource, Si_Project, Si_Date_Dimension, Si_Holiday
- Implement basic data quality checks
- Implement Si_Pipeline_Execution_Audit

### Phase 2: Timesheet Tables (Weeks 3-4)
- Implement Si_Timesheet_Entry, Si_Timesheet_Approval
- Implement timesheet validation rules
- Implement Si_Data_Quality_Error

### Phase 3: Metrics and Workflow (Weeks 5-6)
- Implement Si_Resource_Metrics with KPI calculations
- Implement Si_Workflow_Task
- Implement Si_Data_Quality_Metrics

### Phase 4: Advanced Features (Weeks 7-8)
- Implement Si_Data_Validation_Rules
- Implement Si_Data_Lineage
- Implement Si_Processing_Checkpoint
- Implement comprehensive data quality framework

### Phase 5: Optimization and Testing (Weeks 9-10)
- Performance tuning and indexing
- Comprehensive testing
- Documentation and training
- Production deployment

---

## 16. CONCLUSION

This Silver Layer Logical Data Model provides a comprehensive, business-aligned, and quality-focused foundation for the Resource Utilization and Workforce Management system. The model:

1. **Aligns with Business Requirements:** Tables and columns directly reflect business concepts from the Conceptual Model
2. **Ensures Data Quality:** Comprehensive data quality framework with error tracking, metrics, and validation rules
3. **Supports Auditability:** Complete audit trail of pipeline executions, data lineage, and processing checkpoints
4. **Enables Analytics:** Derived metrics table supports efficient KPI reporting and trend analysis
5. **Maintains Compliance:** PII handling and data retention policies support regulatory compliance
6. **Optimizes Performance:** Indexing and partitioning recommendations support efficient querying
7. **Facilitates Maintenance:** Clear documentation of transformations, relationships, and business rules

The Silver layer serves as the trusted, curated data source for downstream analytics, reporting, and Gold layer aggregations.

---

## 17. API COST

**apiCost:** 0.00 USD

Note: This logical data model was created using GitHub File Reader and Writer tools which do not incur API costs. The cost represents the computational resources used for reading the input files (Conceptual Model, Data Constraints, Bronze Layer DDL) and generating the comprehensive Silver Layer Logical Data Model documentation.

---

## DOCUMENT CONTROL

**Version:** 1.0
**Status:** Final
**Created Date:** Current Date
**Last Updated:** Current Date
**Author:** AAVA
**Approved By:** Pending
**Next Review Date:** Quarterly

---

**END OF DOCUMENT**