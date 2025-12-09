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

## 4. TABLE RELATIONSHIPS AND DERIVATION

### 4.1 Silver to Bronze Table Derivation

| Silver Table | Derived From Bronze Table(s) | Derivation Logic |
|--------------|------------------------------|------------------|
| Si_Resource | Bz_New_Monthly_HC_Report, Bz_report_392_all | Merge resource data from both tables using gci_id, standardize field names and data types |
| Si_Project | Bz_report_392_all, Bz_New_Monthly_HC_Report | Extract project information, standardize project names and client codes |
| Si_Timesheet_Entry | Bz_Timesheet_New | Direct mapping with standardized column names and data validation |
| Si_Timesheet_Approval | Bz_vw_billing_timesheet_daywise_ne, Bz_vw_consultant_timesheet_daywise | Merge approved and consultant timesheet data using GCI_ID and PE_DATE |
| Si_Date | Bz_DimDate | Direct mapping with additional calculated fields and standardized naming |
| Si_Holiday | Bz_holidays, Bz_holidays_India, Bz_holidays_Mexico, Bz_holidays_Canada | Union all holiday tables with location standardization |
| Si_Workflow_Task | Bz_SchTask, Bz_Hiring_Initiator_Project_Info | Merge workflow and hiring data using GCI_ID |

### 4.2 Silver Layer Table Relationships

| Primary Table | Related Table | Relationship Key Field(s) | Relationship Type |
|---------------|---------------|---------------------------|-------------------|
| Si_Resource | Si_Timesheet_Entry | Resource_Code | One-to-Many |
| Si_Resource | Si_Project | Resource_Code = Project_Assignment | Many-to-Many |
| Si_Resource | Si_Timesheet_Approval | Resource_Code | One-to-Many |
| Si_Resource | Si_Workflow_Task | Resource_Code | One-to-Many |
| Si_Project | Si_Timesheet_Entry | Project_Task_Reference | One-to-Many |
| Si_Timesheet_Entry | Si_Date | Timesheet_Date = Calendar_Date | Many-to-One |
| Si_Timesheet_Entry | Si_Timesheet_Approval | Resource_Code, Timesheet_Date | One-to-One |
| Si_Timesheet_Approval | Si_Date | Timesheet_Date = Calendar_Date | Many-to-One |
| Si_Date | Si_Holiday | Calendar_Date = Holiday_Date | One-to-Many |
| Si_Workflow_Task | Si_Resource | Resource_Code | Many-to-One |

---

## 5. KEY PERFORMANCE INDICATORS (KPIs) SUPPORT

The Silver layer model supports the following KPI calculations as defined in the conceptual model:

1. **Total Hours**: Calculated using Si_Date (working days) × location hours from Si_Resource (Is_Offshore)
2. **Submitted Hours**: Sum of all hour types from Si_Timesheet_Entry
3. **Approved Hours**: Sum of approved hours from Si_Timesheet_Approval
4. **Total FTE**: Submitted Hours / Total Hours
5. **Billed FTE**: Approved Hours / Total Hours
6. **Project Utilization**: Billed Hours / Available Hours (from Si_Resource)
7. **Available Hours**: Monthly Hours × Total FTE
8. **Actual Hours**: Actual hours worked from Si_Timesheet_Entry
9. **Onsite Hours**: Hours where Si_Resource.Is_Offshore = 'Onsite'
10. **Offsite Hours**: Hours where Si_Resource.Is_Offshore = 'Offshore'

---

## 6. DESIGN DECISIONS AND RATIONALE

### 6.1 Inclusion Decisions

1. **Resource-Centric Model**: Focused on entities directly related to resource utilization and workforce management as specified in the conceptual model.

2. **Timesheet Focus**: Included both raw timesheet entries and approval data to support submitted vs approved hours analysis.

3. **Project Integration**: Included project information necessary for billing type classification and utilization calculations.

4. **Date Dimension**: Included comprehensive date attributes to support working day calculations and time-based reporting.

5. **Holiday Support**: Included holiday data from all locations to support accurate working day calculations.

6. **Workflow Tracking**: Included workflow tasks to support resource onboarding and approval processes.

### 6.2 Exclusion Decisions

1. **Detailed Financial Data**: Excluded detailed salary, markup, and financial fields not required for utilization reporting.

2. **Hiring Details**: Excluded extensive hiring and relocation details from Bz_Hiring_Initiator_Project_Info not needed for utilization analysis.

3. **Administrative Fields**: Excluded system-specific administrative fields like timestamps and user tracking from Bronze layer.

4. **Redundant Data**: Excluded duplicate or redundant fields that appear in multiple Bronze tables.

### 6.3 Standardization Decisions

1. **Naming Convention**: Standardized column names to business-friendly terms (e.g., gci_id → Resource_Code).

2. **Data Types**: Standardized data types across similar attributes for consistency.

3. **Status Values**: Standardized status and classification values across tables.

4. **Date Handling**: Standardized all date fields to datetime type for consistency.

---

## 7. CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORM)

| Entity | Related Entity | Relationship Key Field(s) | Relationship Description |
|--------|----------------|---------------------------|-------------------------|
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

## 8. ASSUMPTIONS

1. **Data Quality**: Silver layer will implement data quality checks and cleansing based on the constraints defined in the Data Constraints document.

2. **Business Rules**: All business rules defined in the constraints document will be implemented during Silver layer processing.

3. **Incremental Processing**: Silver layer will support incremental data processing using load_timestamp and update_timestamp fields.

4. **Data Retention**: Silver layer data will be retained according to business requirements and regulatory compliance needs.

5. **Performance**: Silver layer tables will be optimized for analytical queries and reporting workloads.

6. **Data Lineage**: Audit tables will maintain complete data lineage from Bronze to Silver layer transformations.

7. **Error Handling**: All data quality issues and processing errors will be captured in the error tracking tables.

8. **Location-Based Processing**: Holiday and working day calculations will be location-aware based on resource assignments.

---

## 9. IMPLEMENTATION NOTES

1. **Transformation Logic**: Implement business rules for billing type classification, category assignment, and FTE calculations during Bronze to Silver transformation.

2. **Data Validation**: Implement all mandatory field constraints, data type validations, and business rule validations defined in the constraints document.

3. **Error Handling**: Route all validation failures to Si_Data_Quality_Errors table with appropriate error categorization.

4. **Audit Logging**: Log all pipeline executions, data lineage, and processing metrics in Si_Pipeline_Audit table.

5. **Performance Optimization**: Consider partitioning large tables by date or resource code for improved query performance.

6. **Data Refresh**: Implement appropriate refresh strategies (full vs incremental) based on data volume and business requirements.

---

## 10. API COST CALCULATION

**apiCost**: 0.02

---

END OF DOCUMENT