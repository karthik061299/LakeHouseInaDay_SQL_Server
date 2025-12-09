====================================================
Author:        AAVA
Date:          
Description:   Silver Layer Logical Data Model for Medallion Architecture - Resource Utilization and Workforce Management
====================================================

# SILVER LAYER LOGICAL DATA MODEL

## 1. OVERVIEW

The Silver layer logical data model is designed to support Resource Utilization and Workforce Management reporting requirements. This model derives only the required tables and columns as specified in the Conceptual data model and Data Constraints, focusing on business entities that support timesheet management, resource tracking, project allocation, and utilization reporting.

## 2. SILVER LAYER TABLES

### Table: Si_Resource
**Description:** Standardized resource master data containing workforce members, their employment details, project assignments, and business-related attributes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Resource_Code | varchar(50) | Unique code for the resource (derived from gci_id) |
| First_Name | varchar(50) | Resource's given name |
| Last_Name | varchar(50) | Resource's family name |
| Job_Title | varchar(50) | Resource's job designation |
| Business_Type | varchar(50) | Classification of employment (e.g., FTE, Consultant) |
| Client_Code | varchar(50) | Code representing the client |
| Start_Date | datetime | Resource's employment start date |
| Termination_Date | datetime | Resource's employment end date |
| Project_Assignment | varchar(200) | Name of the project assigned |
| Market | varchar(50) | Market or region of the resource |
| Visa_Type | varchar(50) | Type of work visa held by the resource |
| Practice_Type | varchar(50) | Practice or business unit |
| Vertical | varchar(50) | Industry vertical |
| Status | varchar(50) | Current employment status (e.g., Active, Terminated) |
| Employee_Category | varchar(50) | Category of the employee (e.g., Bench, AVA) |
| Portfolio_Leader | varchar(100) | Business portfolio leader |
| Expected_Hours | float | Expected working hours per period |
| Available_Hours | float | Calculated available hours for the resource |
| Business_Area | varchar(50) | Geographic business area (NA, LATAM, India, etc.) |
| SOW | varchar(7) | Statement of Work indicator |
| Super_Merged_Name | varchar(100) | Parent client name |
| New_Business_Type | varchar(100) | Contract/Direct Hire/Project NBL |
| Requirement_Region | varchar(50) | Region for the requirement |
| Is_Offshore | varchar(20) | Offshore location indicator |
| load_timestamp | datetime | Timestamp when record was loaded into Silver layer |
| update_timestamp | datetime | Timestamp when record was last updated in Silver layer |

---

### Table: Si_Project
**Description:** Standardized project information containing details of projects, billing types, client information, and project-specific attributes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Project_Name | varchar(200) | Name of the project |
| Client_Name | varchar(60) | Name of the client |
| Client_Code | varchar(50) | Unique identifier code assigned to the client organization |
| Billing_Type | varchar(50) | Billing classification (Billable/Non-Billable) |
| Category | varchar(50) | Project category (e.g., India Billing - Client-NBL) |
| Status | varchar(50) | Billing status (Billed/Unbilled/SGA) |
| Project_City | varchar(50) | City where the project is executed |
| Project_State | varchar(50) | State where the project is executed |
| Opportunity_Name | varchar(200) | Name of the business opportunity |
| Project_Type | varchar(500) | Type of project (e.g., Pipeline, CapEx) |
| Delivery_Leader | varchar(50) | Project delivery leader |
| Circle | varchar(100) | Business circle or grouping |
| Market_Leader | varchar(100) | Market leader for the project |
| Net_Bill_Rate | money | Net bill rate for the project |
| Bill_Rate | decimal(18,9) | Standard bill rate |
| Project_Start_Date | datetime | Project start date |
| Project_End_Date | datetime | Project end date |
| load_timestamp | datetime | Timestamp when record was loaded into Silver layer |
| update_timestamp | datetime | Timestamp when record was last updated in Silver layer |

---

### Table: Si_Timesheet_Entry
**Description:** Standardized timesheet entries capturing daily timesheet entries for each resource, including hours worked by type and associated dates.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Resource_Code | varchar(50) | Unique code for the resource submitting the timesheet |
| Timesheet_Date | datetime | Date for which the timesheet entry is recorded |
| Project_Task_Reference | numeric(18,9) | Reference to the project or task for which hours are logged |
| Standard_Hours | float | Number of standard hours worked |
| Overtime_Hours | float | Number of overtime hours worked |
| Double_Time_Hours | float | Number of double time hours worked |
| Sick_Time_Hours | float | Number of sick time hours recorded |
| Holiday_Hours | float | Number of hours recorded as holiday |
| Time_Off_Hours | float | Number of time off hours recorded |
| Non_Standard_Hours | float | Number of non-standard hours worked |
| Non_Overtime_Hours | float | Number of non-overtime hours worked |
| Non_Double_Time_Hours | float | Number of non-double time hours worked |
| Non_Sick_Time_Hours | float | Number of non-sick time hours recorded |
| Creation_Date | datetime | Date when timesheet entry was created |
| load_timestamp | datetime | Timestamp when record was loaded into Silver layer |
| update_timestamp | datetime | Timestamp when record was last updated in Silver layer |

---

### Table: Si_Timesheet_Approval
**Description:** Standardized timesheet approval data containing submitted and approved timesheet hours by resource, date, and billing type.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Resource_Code | varchar(50) | Unique code for the resource |
| Timesheet_Date | datetime | Date for which the timesheet entry is recorded |
| Week_Date | datetime | Week date for the timesheet entry |
| Approved_Standard_Hours | float | Approved standard hours for the day |
| Approved_Overtime_Hours | float | Approved overtime hours for the day |
| Approved_Double_Time_Hours | float | Approved double time hours for the day |
| Approved_Sick_Time_Hours | float | Approved sick time hours for the day |
| Billing_Indicator | varchar(3) | Indicates if the hours are billable |
| Consultant_Standard_Hours | float | Consultant-submitted standard hours |
| Consultant_Overtime_Hours | float | Consultant-submitted overtime hours |
| Consultant_Double_Time_Hours | float | Consultant-submitted double time hours |
| load_timestamp | datetime | Timestamp when record was loaded into Silver layer |
| update_timestamp | datetime | Timestamp when record was last updated in Silver layer |

---

### Table: Si_Date
**Description:** Standardized date dimension providing calendar and working day context for time-based calculations, including weekends and holidays.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Calendar_Date | datetime | Actual calendar date |
| Day_Name | varchar(9) | Name of the day (e.g., Monday) |
| Day_Of_Month | varchar(2) | Day of the month (1-31) |
| Week_Of_Year | varchar(2) | Week number of the year (1-52) |
| Month_Name | varchar(9) | Name of the month |
| Month_Number | varchar(2) | Month number (1-12) |
| Quarter | char(1) | Quarter of the year |
| Quarter_Name | varchar(9) | Quarter name (Q1, Q2, Q3, Q4) |
| Year | char(4) | Year |
| Is_Working_Day | bit | Indicator if the date is a working day |
| Is_Weekend | bit | Indicator if the date is a weekend |
| Month_Year | char(10) | Month and year combination |
| YYMM | varchar(10) | Year and month in YYYYMM format |
| load_timestamp | datetime | Timestamp when record was loaded into Silver layer |
| update_timestamp | datetime | Timestamp when record was last updated in Silver layer |

---

### Table: Si_Holiday
**Description:** Standardized holiday information storing holiday dates by location, used to exclude non-working days in hour calculations.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Holiday_Date | datetime | Date of the holiday |
| Description | varchar(100) | Description of the holiday |
| Location | varchar(50) | Location for which the holiday applies |
| Source_Type | varchar(50) | Source of the holiday data |
| load_timestamp | datetime | Timestamp when record was loaded into Silver layer |
| update_timestamp | datetime | Timestamp when record was last updated in Silver layer |

---

### Table: Si_Workflow_Task
**Description:** Standardized workflow task information representing workflow or approval tasks related to resources and timesheet processes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Candidate_Name | varchar(100) | Name of the resource or consultant |
| Resource_Code | varchar(50) | Unique code for the resource |
| Workflow_Task_Reference | numeric(18,0) | Reference to the workflow or approval task |
| Type | varchar(50) | Onsite/Offshore indicator |
| Tower | varchar(60) | Business tower or division |
| Status | varchar(50) | Current status of the workflow task |
| Comments | varchar(8000) | Comments or notes for the task |
| Date_Created | datetime | Date the workflow task was created |
| Date_Completed | datetime | Date the workflow task was completed |
| Process_Name | varchar(100) | Human workflow process name |
| Level_ID | int | Current level identifier in the workflow process |
| Last_Level | int | Last completed level in the workflow process |
| load_timestamp | datetime | Timestamp when record was loaded into Silver layer |
| update_timestamp | datetime | Timestamp when record was last updated in Silver layer |

---

## 3. ERROR AND AUDIT STRUCTURES

### Table: Si_Data_Quality_Errors
**Description:** Standardized error data structure for storing data validation errors and data quality issues identified during Silver layer processing.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Error_ID | bigint | Unique identifier for the error record |
| Source_Table | varchar(200) | Name of the source table where error occurred |
| Target_Table | varchar(200) | Name of the target Silver table |
| Record_Identifier | varchar(500) | Identifier of the record that failed validation |
| Error_Type | varchar(100) | Type of error (Data Quality, Business Rule, Constraint Violation) |
| Error_Category | varchar(100) | Category of error (Completeness, Accuracy, Consistency, Validity) |
| Error_Description | varchar(1000) | Detailed description of the error |
| Field_Name | varchar(200) | Name of the field that caused the error |
| Field_Value | varchar(500) | Value that caused the error |
| Expected_Value | varchar(500) | Expected value or format |
| Business_Rule | varchar(500) | Business rule that was violated |
| Severity_Level | varchar(50) | Severity level (Critical, High, Medium, Low) |
| Error_Date | datetime | Date and time when error occurred |
| Batch_ID | varchar(100) | Batch identifier for grouping related errors |
| Processing_Stage | varchar(100) | Stage of processing where error occurred |
| Resolution_Status | varchar(50) | Status of error resolution (Open, In Progress, Resolved, Ignored) |
| Resolution_Notes | varchar(1000) | Notes about error resolution |
| Created_By | varchar(100) | System or user that created the error record |
| Created_Date | datetime | Date when error record was created |
| Modified_Date | datetime | Date when error record was last modified |

---

### Table: Si_Pipeline_Audit
**Description:** Standardized audit structure for tracking pipeline execution details, data lineage, and processing metrics.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Audit_ID | bigint | Unique identifier for the audit record |
| Pipeline_Name | varchar(200) | Name of the data pipeline |
| Pipeline_Run_ID | varchar(100) | Unique identifier for the pipeline run |
| Source_System | varchar(100) | Source system name |
| Source_Table | varchar(200) | Source table name |
| Target_Table | varchar(200) | Target Silver table name |
| Processing_Type | varchar(50) | Type of processing (Full Load, Incremental, Delta) |
| Start_Time | datetime | Pipeline start timestamp |
| End_Time | datetime | Pipeline end timestamp |
| Duration_Seconds | decimal(10,2) | Processing duration in seconds |
| Status | varchar(50) | Pipeline execution status (Success, Failed, Partial, Warning) |
| Records_Read | bigint | Number of records read from source |
| Records_Processed | bigint | Number of records processed |
| Records_Inserted | bigint | Number of records inserted into Silver |
| Records_Updated | bigint | Number of records updated in Silver |
| Records_Deleted | bigint | Number of records deleted from Silver |
| Records_Rejected | bigint | Number of records rejected due to quality issues |
| Data_Quality_Score | decimal(5,2) | Overall data quality score percentage |
| Transformation_Rules_Applied | varchar(1000) | List of transformation rules applied |
| Business_Rules_Applied | varchar(1000) | List of business rules applied |
| Error_Count | int | Total number of errors encountered |
| Warning_Count | int | Total number of warnings encountered |
| Error_Message | varchar(max) | Detailed error message if pipeline failed |
| Checkpoint_Data | varchar(max) | Checkpoint data for incremental processing |
| Resource_Utilization | varchar(500) | Resource utilization metrics |
| Data_Lineage | varchar(1000) | Data lineage information |
| Executed_By | varchar(100) | User or service account that executed the pipeline |
| Environment | varchar(50) | Environment where pipeline was executed (Dev, Test, Prod) |
| Version | varchar(50) | Version of the pipeline |
| Configuration | varchar(max) | Pipeline configuration parameters |
| Created_Date | datetime | Date when audit record was created |
| Modified_Date | datetime | Date when audit record was last modified |

---

## 4. CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORM)

| Entity | Related Entity | Relationship Key Field(s) | Relationship Description |
|--------|----------------|---------------------------|--------------------------|
| Si_Resource | Si_Timesheet_Entry | Resource_Code | One resource can have many timesheet entries |
| Si_Resource | Si_Project | Resource_Code matches Project_Assignment | Many-to-many relationship through project assignments |
| Si_Resource | Si_Timesheet_Approval | Resource_Code | One resource can have many approved timesheet records |
| Si_Resource | Si_Workflow_Task | Resource_Code | One resource can have many workflow tasks |
| Si_Project | Si_Timesheet_Entry | Project_Task_Reference | One project can have many timesheet entries |
| Si_Timesheet_Entry | Si_Date | Timesheet_Date = Calendar_Date | Many timesheet entries can occur on one date |
| Si_Timesheet_Entry | Si_Timesheet_Approval | Resource_Code + Timesheet_Date | One-to-one relationship for timesheet approval |
| Si_Timesheet_Approval | Si_Date | Timesheet_Date = Calendar_Date | Many approved timesheets can occur on one date |
| Si_Date | Si_Holiday | Calendar_Date = Holiday_Date | One date can have multiple holidays (different locations) |
| Si_Workflow_Task | Si_Resource | Resource_Code | Many workflow tasks belong to one resource |
| Si_Holiday | Si_Date | Holiday_Date = Calendar_Date | Many holidays can reference one calendar date |

---

## 5. API COST CALCULATION

**apiCost**: 0.02

---

END OF DOCUMENT
