====================================================
Author:        AAVA
Date:          
Description:   Gold Layer Logical Data Model for Medallion Architecture - Resource Utilization and Workforce Management
====================================================

# GOLD LAYER LOGICAL DATA MODEL

## 1. OVERVIEW

The Gold layer logical data model is designed as a dimensional model to support Resource Utilization and Workforce Management analytics and reporting. This model transforms the Silver layer data into Facts, Dimensions, and Aggregated tables optimized for business intelligence and analytical workloads. The model includes process audit and error data structures to ensure data governance and quality monitoring.

## 2. GOLD LAYER DIMENSIONAL MODEL

### 2.1 DIMENSION TABLES

---

### Table: Go_Dim_Resource
**Description:** Dimension table containing resource master data with historical tracking capabilities for workforce members and their attributes.
**Table Type:** Dimension
**SCD Type:** Type 2 (Slowly Changing Dimension)

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
| Start_Date | datetime | Resource's employment start date | Non-PII |
| Termination_Date | datetime | Resource's employment end date | Non-PII |
| Market | varchar(50) | Market or region of the resource | Non-PII |
| Visa_Type | varchar(50) | Type of work visa held by the resource | PII - Sensitive Personal Data |
| Practice_Type | varchar(50) | Practice or business unit classification | Non-PII |
| Vertical | varchar(50) | Industry vertical assignment | Non-PII |
| Status | varchar(50) | Current employment status (Active, Terminated) | Non-PII |
| Employee_Category | varchar(50) | Category of the employee (Bench, AVA) | Non-PII |
| Portfolio_Leader | varchar(100) | Business portfolio leader name | Non-PII |
| Business_Area | varchar(50) | Geographic business area (NA, LATAM, India) | Non-PII |
| SOW | varchar(7) | Statement of Work indicator | Non-PII |
| Super_Merged_Name | varchar(100) | Parent client name for consolidated reporting | Non-PII |
| New_Business_Type | varchar(100) | Contract/Direct Hire/Project NBL classification | Non-PII |
| Requirement_Region | varchar(50) | Region for the requirement | Non-PII |
| Is_Offshore | varchar(20) | Offshore location indicator | Non-PII |
| Effective_Start_Date | datetime | Start date for this version of the record | Non-PII |
| Effective_End_Date | datetime | End date for this version of the record | Non-PII |
| Is_Current | bit | Flag indicating if this is the current version | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated | Non-PII |
| source_system | varchar(100) | Source system identifier | Non-PII |

---

### Table: Go_Dim_Project
**Description:** Dimension table containing project information with historical tracking for billing types, client information, and project attributes.
**Table Type:** Dimension
**SCD Type:** Type 2 (Slowly Changing Dimension)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Project_Key | bigint | Surrogate key for the project dimension | Non-PII |
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
| Bill_Rate | decimal(18,9) | Standard bill rate | Non-PII |
| Project_Start_Date | datetime | Project start date | Non-PII |
| Project_End_Date | datetime | Project end date | Non-PII |
| Effective_Start_Date | datetime | Start date for this version of the record | Non-PII |
| Effective_End_Date | datetime | End date for this version of the record | Non-PII |
| Is_Current | bit | Flag indicating if this is the current version | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated | Non-PII |
| source_system | varchar(100) | Source system identifier | Non-PII |

---

### Table: Go_Dim_Date
**Description:** Dimension table providing comprehensive calendar and working day context for time-based analytics and calculations.
**Table Type:** Dimension
**SCD Type:** Type 1 (No historical tracking needed)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Date_Key | int | Surrogate key in YYYYMMDD format | Non-PII |
| Calendar_Date | datetime | Actual calendar date | Non-PII |
| Day_Name | varchar(9) | Name of the day (Monday, Tuesday, etc.) | Non-PII |
| Day_Of_Month | int | Day of the month (1-31) | Non-PII |
| Day_Of_Week | int | Day of the week (1-7, Sunday=1) | Non-PII |
| Day_Of_Year | int | Day of the year (1-366) | Non-PII |
| Week_Of_Year | int | Week number of the year (1-53) | Non-PII |
| Month_Name | varchar(9) | Name of the month | Non-PII |
| Month_Number | int | Month number (1-12) | Non-PII |
| Month_Abbreviation | varchar(3) | Three-letter month abbreviation | Non-PII |
| Quarter | int | Quarter of the year (1-4) | Non-PII |
| Quarter_Name | varchar(9) | Quarter name (Q1, Q2, Q3, Q4) | Non-PII |
| Year | int | Four-digit year | Non-PII |
| Is_Working_Day | bit | Indicator if the date is a working day | Non-PII |
| Is_Weekend | bit | Indicator if the date is a weekend | Non-PII |
| Is_Holiday | bit | Indicator if the date is a holiday | Non-PII |
| Month_Year | varchar(10) | Month and year combination (MM-YYYY) | Non-PII |
| YYMM | varchar(6) | Year and month in YYYYMM format | Non-PII |
| Fiscal_Year | int | Fiscal year based on business calendar | Non-PII |
| Fiscal_Quarter | int | Fiscal quarter based on business calendar | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated | Non-PII |
| source_system | varchar(100) | Source system identifier | Non-PII |

---

### Table: Go_Dim_Holiday
**Description:** Dimension table containing holiday information by location for accurate working day calculations.
**Table Type:** Dimension
**SCD Type:** Type 1 (No historical tracking needed)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Holiday_Key | bigint | Surrogate key for the holiday dimension | Non-PII |
| Holiday_Date | datetime | Date of the holiday | Non-PII |
| Holiday_Name | varchar(100) | Name/description of the holiday | Non-PII |
| Location | varchar(50) | Location for which the holiday applies | Non-PII |
| Country | varchar(50) | Country where the holiday is observed | Non-PII |
| Region | varchar(50) | Region or state where holiday applies | Non-PII |
| Holiday_Type | varchar(50) | Type of holiday (National, Regional, Religious) | Non-PII |
| Is_Observed | bit | Indicator if holiday is officially observed | Non-PII |
| Source_Type | varchar(50) | Source of the holiday data | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated | Non-PII |
| source_system | varchar(100) | Source system identifier | Non-PII |

---

### 2.2 FACT TABLES

---

### Table: Go_Fact_Timesheet
**Description:** Fact table capturing daily timesheet entries with various hour types and associated metrics for resource utilization analysis.
**Table Type:** Fact

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Timesheet_Key | bigint | Surrogate key for the timesheet fact | Non-PII |
| Resource_Key | bigint | Foreign key to Go_Dim_Resource | Non-PII |
| Project_Key | bigint | Foreign key to Go_Dim_Project | Non-PII |
| Date_Key | int | Foreign key to Go_Dim_Date | Non-PII |
| Standard_Hours | decimal(10,2) | Number of standard hours worked | Non-PII |
| Overtime_Hours | decimal(10,2) | Number of overtime hours worked | Non-PII |
| Double_Time_Hours | decimal(10,2) | Number of double time hours worked | Non-PII |
| Sick_Time_Hours | decimal(10,2) | Number of sick time hours recorded | Non-PII |
| Holiday_Hours | decimal(10,2) | Number of hours recorded as holiday | Non-PII |
| Time_Off_Hours | decimal(10,2) | Number of time off hours recorded | Non-PII |
| Non_Standard_Hours | decimal(10,2) | Number of non-standard hours worked | Non-PII |
| Non_Overtime_Hours | decimal(10,2) | Number of non-overtime hours worked | Non-PII |
| Non_Double_Time_Hours | decimal(10,2) | Number of non-double time hours worked | Non-PII |
| Non_Sick_Time_Hours | decimal(10,2) | Number of non-sick time hours recorded | Non-PII |
| Total_Submitted_Hours | decimal(10,2) | Total hours submitted for the day | Non-PII |
| Total_Billable_Hours | decimal(10,2) | Total billable hours for the day | Non-PII |
| Total_Non_Billable_Hours | decimal(10,2) | Total non-billable hours for the day | Non-PII |
| Creation_Date | datetime | Date when timesheet entry was created | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated | Non-PII |
| source_system | varchar(100) | Source system identifier | Non-PII |

---

### Table: Go_Fact_Timesheet_Approval
**Description:** Fact table capturing approved timesheet hours by resource, date, and billing type for utilization and billing analysis.
**Table Type:** Fact

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Approval_Key | bigint | Surrogate key for the timesheet approval fact | Non-PII |
| Resource_Key | bigint | Foreign key to Go_Dim_Resource | Non-PII |
| Project_Key | bigint | Foreign key to Go_Dim_Project | Non-PII |
| Date_Key | int | Foreign key to Go_Dim_Date | Non-PII |
| Week_Date_Key | int | Foreign key to Go_Dim_Date for week date | Non-PII |
| Approved_Standard_Hours | decimal(10,2) | Approved standard hours for the day | Non-PII |
| Approved_Overtime_Hours | decimal(10,2) | Approved overtime hours for the day | Non-PII |
| Approved_Double_Time_Hours | decimal(10,2) | Approved double time hours for the day | Non-PII |
| Approved_Sick_Time_Hours | decimal(10,2) | Approved sick time hours for the day | Non-PII |
| Total_Approved_Hours | decimal(10,2) | Total approved hours for the day | Non-PII |
| Consultant_Standard_Hours | decimal(10,2) | Consultant-submitted standard hours | Non-PII |
| Consultant_Overtime_Hours | decimal(10,2) | Consultant-submitted overtime hours | Non-PII |
| Consultant_Double_Time_Hours | decimal(10,2) | Consultant-submitted double time hours | Non-PII |
| Total_Consultant_Hours | decimal(10,2) | Total consultant-submitted hours | Non-PII |
| Billing_Indicator | varchar(3) | Indicates if the hours are billable (Yes/No) | Non-PII |
| Approval_Status | varchar(50) | Status of the approval process | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated | Non-PII |
| source_system | varchar(100) | Source system identifier | Non-PII |

---

### Table: Go_Fact_Resource_Utilization
**Description:** Fact table capturing calculated resource utilization metrics including FTE, available hours, and project utilization.
**Table Type:** Fact

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Utilization_Key | bigint | Surrogate key for the resource utilization fact | Non-PII |
| Resource_Key | bigint | Foreign key to Go_Dim_Resource | Non-PII |
| Project_Key | bigint | Foreign key to Go_Dim_Project | Non-PII |
| Date_Key | int | Foreign key to Go_Dim_Date | Non-PII |
| Month_Year_Key | int | Foreign key to Go_Dim_Date for month aggregation | Non-PII |
| Expected_Hours | decimal(10,2) | Expected working hours for the period | Non-PII |
| Available_Hours | decimal(10,2) | Calculated available hours for the resource | Non-PII |
| Total_Hours | decimal(10,2) | Total working hours for the period | Non-PII |
| Submitted_Hours | decimal(10,2) | Total timesheet hours submitted | Non-PII |
| Approved_Hours | decimal(10,2) | Total timesheet hours approved | Non-PII |
| Billable_Hours | decimal(10,2) | Total billable hours | Non-PII |
| Non_Billable_Hours | decimal(10,2) | Total non-billable hours | Non-PII |
| Actual_Hours | decimal(10,2) | Actual hours worked by the resource | Non-PII |
| Onsite_Hours | decimal(10,2) | Actual hours worked onsite | Non-PII |
| Offshore_Hours | decimal(10,2) | Actual hours worked offshore | Non-PII |
| Total_FTE | decimal(10,4) | Calculated Total FTE (Submitted Hours / Total Hours) | Non-PII |
| Billed_FTE | decimal(10,4) | Calculated Billed FTE (Approved Hours / Total Hours) | Non-PII |
| Project_Utilization | decimal(10,4) | Project utilization percentage (Billed Hours / Available Hours) | Non-PII |
| Working_Days | int | Number of working days in the period | Non-PII |
| Location_Hours_Per_Day | int | Standard hours per day based on location (8 or 9) | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated | Non-PII |
| source_system | varchar(100) | Source system identifier | Non-PII |

---

### 2.3 PROCESS AUDIT AND ERROR DATA TABLES

---

### Table: Go_Process_Audit
**Description:** Audit table for tracking Gold layer pipeline execution details, data lineage, and processing metrics.
**Table Type:** Audit

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Audit_Key | bigint | Surrogate key for the audit record | Non-PII |
| Pipeline_Name | varchar(200) | Name of the Gold layer data pipeline | Non-PII |
| Pipeline_Run_ID | varchar(100) | Unique identifier for the pipeline run | Non-PII |
| Source_System | varchar(100) | Source system name (Silver layer) | Non-PII |
| Source_Table | varchar(200) | Source table name from Silver layer | Non-PII |
| Target_Table | varchar(200) | Target Gold layer table name | Non-PII |
| Processing_Type | varchar(50) | Type of processing (Full Load, Incremental, Delta) | Non-PII |
| Transformation_Type | varchar(50) | Type of transformation (Dimension, Fact, Aggregate) | Non-PII |
| Start_Time | datetime | Pipeline start timestamp | Non-PII |
| End_Time | datetime | Pipeline end timestamp | Non-PII |
| Duration_Seconds | decimal(10,2) | Processing duration in seconds | Non-PII |
| Status | varchar(50) | Pipeline execution status (Success, Failed, Partial, Warning) | Non-PII |
| Records_Read | bigint | Number of records read from Silver layer | Non-PII |
| Records_Processed | bigint | Number of records processed | Non-PII |
| Records_Inserted | bigint | Number of records inserted into Gold layer | Non-PII |
| Records_Updated | bigint | Number of records updated in Gold layer | Non-PII |
| Records_Deleted | bigint | Number of records deleted from Gold layer | Non-PII |
| Records_Rejected | bigint | Number of records rejected due to quality issues | Non-PII |
| SCD_Records_Created | bigint | Number of new SCD records created | Non-PII |
| SCD_Records_Updated | bigint | Number of SCD records updated | Non-PII |
| Data_Quality_Score | decimal(5,2) | Overall data quality score percentage | Non-PII |
| Business_Rules_Applied | varchar(1000) | List of business rules applied during processing | Non-PII |
| Dimensional_Rules_Applied | varchar(1000) | List of dimensional modeling rules applied | Non-PII |
| Error_Count | int | Total number of errors encountered | Non-PII |
| Warning_Count | int | Total number of warnings encountered | Non-PII |
| Error_Message | varchar(max) | Detailed error message if pipeline failed | Non-PII |
| Checkpoint_Data | varchar(max) | Checkpoint data for incremental processing | Non-PII |
| Resource_Utilization | varchar(500) | Resource utilization metrics during processing | Non-PII |
| Data_Lineage | varchar(1000) | Data lineage information | Non-PII |
| Executed_By | varchar(100) | User or service account that executed the pipeline | Non-PII |
| Environment | varchar(50) | Environment where pipeline was executed (Dev, Test, Prod) | Non-PII |
| Version | varchar(50) | Version of the pipeline | Non-PII |
| Configuration | varchar(max) | Pipeline configuration parameters | Non-PII |
| load_date | datetime | Date when audit record was created | Non-PII |
| update_date | datetime | Date when audit record was last modified | Non-PII |
| source_system | varchar(100) | Source system identifier | Non-PII |

---

### Table: Go_Data_Quality_Errors
**Description:** Error data table for storing data validation errors and data quality issues identified during Gold layer processing.
**Table Type:** Error Data

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Error_Key | bigint | Surrogate key for the error record | Non-PII |
| Pipeline_Run_ID | varchar(100) | Pipeline run identifier for traceability | Non-PII |
| Source_Table | varchar(200) | Name of the source Silver table where error occurred | Non-PII |
| Target_Table | varchar(200) | Name of the target Gold table | Non-PII |
| Record_Identifier | varchar(500) | Identifier of the record that failed validation | PII - Potentially Sensitive |
| Error_Type | varchar(100) | Type of error (Data Quality, Business Rule, SCD, Constraint Violation) | Non-PII |
| Error_Category | varchar(100) | Category of error (Completeness, Accuracy, Consistency, Validity, Dimensional) | Non-PII |
| Error_Severity | varchar(50) | Severity level (Critical, High, Medium, Low) | Non-PII |
| Error_Code | varchar(50) | Standardized error code for categorization | Non-PII |
| Error_Description | varchar(1000) | Detailed description of the error | Non-PII |
| Field_Name | varchar(200) | Name of the field that caused the error | Non-PII |
| Field_Value | varchar(500) | Value that caused the error | PII - Potentially Sensitive |
| Expected_Value | varchar(500) | Expected value or format | Non-PII |
| Business_Rule | varchar(500) | Business rule that was violated | Non-PII |
| Dimensional_Rule | varchar(500) | Dimensional modeling rule that was violated | Non-PII |
| Error_Date | datetime | Date and time when error occurred | Non-PII |
| Batch_ID | varchar(100) | Batch identifier for grouping related errors | Non-PII |
| Processing_Stage | varchar(100) | Stage of processing where error occurred | Non-PII |
| Transformation_Step | varchar(100) | Specific transformation step where error occurred | Non-PII |
| Resolution_Status | varchar(50) | Status of error resolution (Open, In Progress, Resolved, Ignored) | Non-PII |
| Resolution_Notes | varchar(1000) | Notes about error resolution | Non-PII |
| Impact_Assessment | varchar(500) | Assessment of error impact on downstream processes | Non-PII |
| Remediation_Action | varchar(500) | Action taken or recommended to remediate the error | Non-PII |
| Created_By | varchar(100) | System or user that created the error record | Non-PII |
| Assigned_To | varchar(100) | Person or team assigned to resolve the error | Non-PII |
| load_date | datetime | Date when error record was created | Non-PII |
| update_date | datetime | Date when error record was last modified | Non-PII |
| source_system | varchar(100) | Source system identifier | Non-PII |

---

### 2.4 AGGREGATED TABLES

---

### Table: Go_Agg_Monthly_Resource_Utilization
**Description:** Monthly aggregated table for resource utilization metrics optimized for executive reporting and dashboards.
**Table Type:** Aggregated

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Monthly_Utilization_Key | bigint | Surrogate key for monthly utilization record | Non-PII |
| Resource_Key | bigint | Foreign key to Go_Dim_Resource | Non-PII |
| Month_Year_Key | int | Foreign key to Go_Dim_Date for month | Non-PII |
| Year | int | Year of the aggregation | Non-PII |
| Month | int | Month of the aggregation | Non-PII |
| Month_Name | varchar(9) | Name of the month | Non-PII |
| Total_Expected_Hours | decimal(10,2) | Total expected hours for the month | Non-PII |
| Total_Available_Hours | decimal(10,2) | Total available hours for the month | Non-PII |
| Total_Working_Hours | decimal(10,2) | Total working hours for the month | Non-PII |
| Total_Submitted_Hours | decimal(10,2) | Total submitted hours for the month | Non-PII |
| Total_Approved_Hours | decimal(10,2) | Total approved hours for the month | Non-PII |
| Total_Billable_Hours | decimal(10,2) | Total billable hours for the month | Non-PII |
| Total_Non_Billable_Hours | decimal(10,2) | Total non-billable hours for the month | Non-PII |
| Total_Standard_Hours | decimal(10,2) | Total standard hours for the month | Non-PII |
| Total_Overtime_Hours | decimal(10,2) | Total overtime hours for the month | Non-PII |
| Total_Double_Time_Hours | decimal(10,2) | Total double time hours for the month | Non-PII |
| Total_Sick_Time_Hours | decimal(10,2) | Total sick time hours for the month | Non-PII |
| Total_Holiday_Hours | decimal(10,2) | Total holiday hours for the month | Non-PII |
| Total_Time_Off_Hours | decimal(10,2) | Total time off hours for the month | Non-PII |
| Average_Daily_Hours | decimal(10,2) | Average daily hours worked | Non-PII |
| Working_Days_Count | int | Number of working days in the month | Non-PII |
| Days_Worked | int | Number of days actually worked | Non-PII |
| Monthly_Total_FTE | decimal(10,4) | Monthly Total FTE calculation | Non-PII |
| Monthly_Billed_FTE | decimal(10,4) | Monthly Billed FTE calculation | Non-PII |
| Monthly_Utilization_Rate | decimal(10,4) | Monthly utilization rate percentage | Non-PII |
| Billable_Utilization_Rate | decimal(10,4) | Billable utilization rate percentage | Non-PII |
| Project_Count | int | Number of projects worked on during the month | Non-PII |
| Primary_Project_Key | bigint | Foreign key to primary project for the month | Non-PII |
| Primary_Project_Hours | decimal(10,2) | Hours worked on primary project | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated | Non-PII |
| source_system | varchar(100) | Source system identifier | Non-PII |

---

### Table: Go_Agg_Project_Summary
**Description:** Project-level aggregated table for project performance metrics and resource allocation analysis.
**Table Type:** Aggregated

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Project_Summary_Key | bigint | Surrogate key for project summary record | Non-PII |
| Project_Key | bigint | Foreign key to Go_Dim_Project | Non-PII |
| Month_Year_Key | int | Foreign key to Go_Dim_Date for month | Non-PII |
| Year | int | Year of the aggregation | Non-PII |
| Month | int | Month of the aggregation | Non-PII |
| Month_Name | varchar(9) | Name of the month | Non-PII |
| Total_Resources_Assigned | int | Total number of resources assigned to project | Non-PII |
| Active_Resources_Count | int | Number of active resources during the month | Non-PII |
| FTE_Resources_Count | int | Number of FTE resources on the project | Non-PII |
| Consultant_Resources_Count | int | Number of consultant resources on the project | Non-PII |
| Onsite_Resources_Count | int | Number of onsite resources | Non-PII |
| Offshore_Resources_Count | int | Number of offshore resources | Non-PII |
| Total_Project_Hours | decimal(10,2) | Total hours logged to the project | Non-PII |
| Total_Billable_Hours | decimal(10,2) | Total billable hours for the project | Non-PII |
| Total_Non_Billable_Hours | decimal(10,2) | Total non-billable hours for the project | Non-PII |
| Total_Approved_Hours | decimal(10,2) | Total approved hours for the project | Non-PII |
| Total_Standard_Hours | decimal(10,2) | Total standard hours for the project | Non-PII |
| Total_Overtime_Hours | decimal(10,2) | Total overtime hours for the project | Non-PII |
| Total_Onsite_Hours | decimal(10,2) | Total onsite hours for the project | Non-PII |
| Total_Offshore_Hours | decimal(10,2) | Total offshore hours for the project | Non-PII |
| Average_Hours_Per_Resource | decimal(10,2) | Average hours per resource | Non-PII |
| Project_FTE_Allocation | decimal(10,4) | Total FTE allocation to the project | Non-PII |
| Project_Utilization_Rate | decimal(10,4) | Project utilization rate | Non-PII |
| Billing_Efficiency | decimal(10,4) | Percentage of billable vs total hours | Non-PII |
| Average_Bill_Rate | decimal(10,2) | Average bill rate for the project | Non-PII |
| Total_Revenue | decimal(18,2) | Total revenue generated by the project | Non-PII |
| Revenue_Per_Hour | decimal(10,2) | Revenue per hour calculation | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated | Non-PII |
| source_system | varchar(100) | Source system identifier | Non-PII |

---

### Table: Go_Agg_Client_Portfolio
**Description:** Client-level aggregated table for portfolio management and client relationship analytics.
**Table Type:** Aggregated

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Client_Portfolio_Key | bigint | Surrogate key for client portfolio record | Non-PII |
| Client_Code | varchar(50) | Business key - Client code | Non-PII |
| Client_Name | varchar(60) | Client organization name | Non-PII |
| Super_Merged_Name | varchar(100) | Parent client name for consolidated reporting | Non-PII |
| Month_Year_Key | int | Foreign key to Go_Dim_Date for month | Non-PII |
| Year | int | Year of the aggregation | Non-PII |
| Month | int | Month of the aggregation | Non-PII |
| Month_Name | varchar(9) | Name of the month | Non-PII |
| Total_Projects | int | Total number of projects for the client | Non-PII |
| Active_Projects | int | Number of active projects during the month | Non-PII |
| Billable_Projects | int | Number of billable projects | Non-PII |
| Non_Billable_Projects | int | Number of non-billable projects | Non-PII |
| Total_Resources_Allocated | int | Total resources allocated to client projects | Non-PII |
| FTE_Resources_Count | int | Number of FTE resources | Non-PII |
| Consultant_Resources_Count | int | Number of consultant resources | Non-PII |
| Onsite_Resources_Count | int | Number of onsite resources | Non-PII |
| Offshore_Resources_Count | int | Number of offshore resources | Non-PII |
| Total_Client_Hours | decimal(10,2) | Total hours worked for the client | Non-PII |
| Total_Billable_Hours | decimal(10,2) | Total billable hours for the client | Non-PII |
| Total_Non_Billable_Hours | decimal(10,2) | Total non-billable hours for the client | Non-PII |
| Total_Approved_Hours | decimal(10,2) | Total approved hours for the client | Non-PII |
| Total_Onsite_Hours | decimal(10,2) | Total onsite hours for the client | Non-PII |
| Total_Offshore_Hours | decimal(10,2) | Total offshore hours for the client | Non-PII |
| Client_FTE_Allocation | decimal(10,4) | Total FTE allocation to client | Non-PII |
| Client_Utilization_Rate | decimal(10,4) | Client utilization rate | Non-PII |
| Billing_Efficiency | decimal(10,4) | Percentage of billable vs total hours | Non-PII |
| Average_Bill_Rate | decimal(10,2) | Average bill rate across client projects | Non-PII |
| Total_Revenue | decimal(18,2) | Total revenue from the client | Non-PII |
| Revenue_Growth_Rate | decimal(10,4) | Month-over-month revenue growth rate | Non-PII |
| Portfolio_Leader | varchar(100) | Portfolio leader responsible for the client | Non-PII |
| Business_Area | varchar(50) | Primary business area for the client | Non-PII |
| SOW_Indicator | varchar(7) | Statement of Work indicator | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated | Non-PII |
| source_system | varchar(100) | Source system identifier | Non-PII |

---

## 3. CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORM)

| Entity | Related Entity | Relationship Key Field(s) | Relationship Description |
|--------|----------------|---------------------------|--------------------------|
| Go_Dim_Resource | Go_Fact_Timesheet | Resource_Key | One resource can have many timesheet entries |
| Go_Dim_Resource | Go_Fact_Timesheet_Approval | Resource_Key | One resource can have many approved timesheet records |
| Go_Dim_Resource | Go_Fact_Resource_Utilization | Resource_Key | One resource can have many utilization records |
| Go_Dim_Resource | Go_Agg_Monthly_Resource_Utilization | Resource_Key | One resource can have many monthly utilization records |
| Go_Dim_Project | Go_Fact_Timesheet | Project_Key | One project can have many timesheet entries |
| Go_Dim_Project | Go_Fact_Timesheet_Approval | Project_Key | One project can have many approved timesheet records |
| Go_Dim_Project | Go_Fact_Resource_Utilization | Project_Key | One project can have many utilization records |
| Go_Dim_Project | Go_Agg_Project_Summary | Project_Key | One project can have many monthly summary records |
| Go_Dim_Date | Go_Fact_Timesheet | Date_Key | One date can have many timesheet entries |
| Go_Dim_Date | Go_Fact_Timesheet_Approval | Date_Key | One date can have many approved timesheet records |
| Go_Dim_Date | Go_Fact_Resource_Utilization | Date_Key | One date can have many utilization records |
| Go_Dim_Date | Go_Agg_Monthly_Resource_Utilization | Month_Year_Key | One month can have many monthly utilization records |
| Go_Dim_Date | Go_Agg_Project_Summary | Month_Year_Key | One month can have many project summary records |
| Go_Dim_Date | Go_Agg_Client_Portfolio | Month_Year_Key | One month can have many client portfolio records |
| Go_Dim_Holiday | Go_Dim_Date | Holiday_Date = Calendar_Date | Many holidays can reference one calendar date |
| Go_Process_Audit | Go_Data_Quality_Errors | Pipeline_Run_ID | One pipeline run can have many error records |
| Go_Agg_Monthly_Resource_Utilization | Go_Dim_Project | Primary_Project_Key | Many monthly records can reference one primary project |

---

## 4. DESIGN DECISIONS AND RATIONALE

### 4.1 Dimensional Model Design
- **Star Schema**: Implemented star schema design for optimal query performance and ease of understanding
- **Surrogate Keys**: Used surrogate keys for all dimensions to ensure referential integrity and support SCD
- **Business Keys**: Maintained business keys alongside surrogate keys for data lineage and debugging

### 4.2 Slowly Changing Dimensions
- **Go_Dim_Resource (SCD Type 2)**: Tracks historical changes in resource attributes like job title, client assignment, status
- **Go_Dim_Project (SCD Type 2)**: Tracks historical changes in project attributes like billing type, status, rates
- **Go_Dim_Date (SCD Type 1)**: No historical tracking needed as date attributes are static
- **Go_Dim_Holiday (SCD Type 1)**: No historical tracking needed as holiday information is typically static

### 4.3 Fact Table Design
- **Go_Fact_Timesheet**: Transaction-level fact table for detailed timesheet analysis
- **Go_Fact_Timesheet_Approval**: Separate fact table for approval workflow tracking
- **Go_Fact_Resource_Utilization**: Calculated fact table for utilization metrics and KPIs

### 4.4 Aggregation Strategy
- **Monthly Aggregations**: Pre-calculated monthly aggregations for performance optimization
- **Multiple Grain Levels**: Resource-level, project-level, and client-level aggregations for different analytical needs
- **KPI Pre-calculation**: Key performance indicators calculated and stored for fast retrieval

### 4.5 Data Quality and Governance
- **Comprehensive Audit Trail**: Detailed audit logging for all pipeline executions
- **Error Tracking**: Structured error data capture with severity levels and resolution tracking
- **PII Classification**: Proper classification of personally identifiable information for compliance

---

## 5. ASSUMPTIONS MADE

1. **Data Refresh Frequency**: Assumed daily refresh for fact tables and weekly refresh for dimension tables
2. **Historical Retention**: Assumed 7-year retention policy for all historical data
3. **Business Calendar**: Assumed standard business calendar with location-specific holidays
4. **Currency**: Assumed all financial amounts are in USD unless specified otherwise
5. **Time Zone**: Assumed all timestamps are in UTC for consistency
6. **Resource Allocation**: Assumed resources can be allocated to multiple projects simultaneously
7. **Approval Workflow**: Assumed hierarchical approval workflow with manager and client approvals
8. **Data Quality Thresholds**: Assumed 95% data quality score threshold for successful pipeline execution

---

## 6. API COST CALCULATION

**apiCost**: 0.045

---

**END OF DOCUMENT**