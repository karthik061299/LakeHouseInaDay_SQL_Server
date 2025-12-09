====================================================
Author:        AAVA
Date:          
Description:   Gold Layer Logical Data Model for Medallion Architecture - Resource Utilization and Workforce Management
====================================================

# GOLD LAYER LOGICAL DATA MODEL

## 1. OVERVIEW

The Gold layer logical data model provides a dimensional, analytics-ready structure for reporting on resource utilization, workforce management, project allocation, and operational KPIs. This model is designed for efficient querying, historical tracking, and compliance with data governance and quality standards.

## 2. GOLD LAYER TABLES

### 2.1 DIMENSION TABLES

#### Table: Go_Dim_Resource
**Description:** Master data for workforce members, their employment details, project assignments, and business attributes.
**Table Type:** Dimension
**SCD Type:** Type 2 (historical tracking of changes in resource attributes)

| Column Name         | Data Type    | Description                                               | PII Classification |
|---------------------|-------------|-----------------------------------------------------------|--------------------|
| Resource_Code       | varchar(50) | Unique code for the resource                              | Identifier         |
| First_Name          | varchar(50) | Resource's given name                                     | PII                |
| Last_Name           | varchar(50) | Resource's family name                                    | PII                |
| Job_Title           | varchar(50) | Resource's job designation                                |                    |
| Business_Type       | varchar(50) | Employment classification (e.g., FTE, Consultant)         |                    |
| Client_Code         | varchar(50) | Code representing the client                              |                    |
| Start_Date          | datetime    | Employment start date                                     |                    |
| Termination_Date    | datetime    | Employment end date                                       |                    |
| Project_Assignment  | varchar(200)| Name of the project assigned                              |                    |
| Market              | varchar(50) | Market or region of the resource                          |                    |
| Visa_Type           | varchar(50) | Type of work visa held                                    |                    |
| Practice_Type       | varchar(50) | Practice or business unit                                 |                    |
| Vertical            | varchar(50) | Industry vertical                                         |                    |
| Status              | varchar(50) | Current employment status                                 |                    |
| Employee_Category   | varchar(50) | Employee category (e.g., Bench, AVA)                      |                    |
| Portfolio_Leader    | varchar(100)| Business portfolio leader                                 |                    |
| Expected_Hours      | float       | Expected working hours per period                         |                    |
| Available_Hours     | float       | Calculated available hours                                |                    |
| Business_Area       | varchar(50) | Geographic business area                                  |                    |
| SOW                 | varchar(7)  | Statement of Work indicator                               |                    |
| Super_Merged_Name   | varchar(100)| Parent client name                                        |                    |
| New_Business_Type   | varchar(100)| Contract/Direct Hire/Project NBL                          |                    |
| Requirement_Region  | varchar(50) | Region for the requirement                                |                    |
| Is_Offshore         | varchar(20) | Offshore location indicator                               |                    |
| load_date           | datetime    | Date when record was loaded into Gold layer               |                    |
| update_date         | datetime    | Date when record was last updated in Gold layer           |                    |
| source_system       | varchar(100)| Source system name                                        |                    |

---

#### Table: Go_Dim_Project
**Description:** Project master data including billing types, client information, and project attributes.
**Table Type:** Dimension
**SCD Type:** Type 2 (historical tracking of project attribute changes)

| Column Name         | Data Type      | Description                                         | PII Classification |
|---------------------|---------------|-----------------------------------------------------|--------------------|
| Project_Name        | varchar(200)  | Name of the project                                 |                    |
| Client_Name         | varchar(60)   | Name of the client                                  |                    |
| Client_Code         | varchar(50)   | Unique client code                                  |                    |
| Billing_Type        | varchar(50)   | Billing classification (Billable/Non-Billable)      |                    |
| Category            | varchar(50)   | Project category                                    |                    |
| Status              | varchar(50)   | Billing status                                      |                    |
| Project_City        | varchar(50)   | City where project is executed                      |                    |
| Project_State       | varchar(50)   | State where project is executed                     |                    |
| Opportunity_Name    | varchar(200)  | Business opportunity name                           |                    |
| Project_Type        | varchar(500)  | Type of project (e.g., Pipeline, CapEx)             |                    |
| Delivery_Leader     | varchar(50)   | Project delivery leader                             |                    |
| Circle              | varchar(100)  | Business circle or grouping                         |                    |
| Market_Leader       | varchar(100)  | Market leader for the project                       |                    |
| Net_Bill_Rate       | money         | Net bill rate for the project                       |                    |
| Bill_Rate           | decimal(18,9) | Standard bill rate                                  |                    |
| Project_Start_Date  | datetime      | Project start date                                  |                    |
| Project_End_Date    | datetime      | Project end date                                    |                    |
| load_date           | datetime      | Date when record was loaded into Gold layer         |                    |
| update_date         | datetime      | Date when record was last updated in Gold layer     |                    |
| source_system       | varchar(100)  | Source system name                                  |                    |

---

#### Table: Go_Dim_Date
**Description:** Date dimension for calendar and working day context.
**Table Type:** Dimension
**SCD Type:** Type 1 (no historical tracking required)

| Column Name         | Data Type    | Description                                         | PII Classification |
|---------------------|-------------|-----------------------------------------------------|--------------------|
| Calendar_Date       | datetime    | Actual calendar date                                |                    |
| Day_Name            | varchar(9)  | Name of the day                                     |                    |
| Day_Of_Month        | varchar(2)  | Day of the month                                   |                    |
| Week_Of_Year        | varchar(2)  | Week number of the year                            |                    |
| Month_Name          | varchar(9)  | Name of the month                                  |                    |
| Month_Number        | varchar(2)  | Month number                                       |                    |
| Quarter             | char(1)     | Quarter of the year                                |                    |
| Quarter_Name        | varchar(9)  | Quarter name (Q1, Q2, Q3, Q4)                      |                    |
| Year                | char(4)     | Year                                               |                    |
| Is_Working_Day      | bit         | Indicator if the date is a working day             |                    |
| Is_Weekend          | bit         | Indicator if the date is a weekend                 |                    |
| Month_Year          | char(10)    | Month and year combination                         |                    |
| YYMM                | varchar(10) | Year and month in YYYYMM format                    |                    |
| load_date           | datetime    | Date when record was loaded into Gold layer         |                    |
| update_date         | datetime    | Date when record was last updated in Gold layer     |                    |
| source_system       | varchar(100)| Source system name                                  |                    |

---

#### Table: Go_Dim_Holiday
**Description:** Holiday dimension for storing holiday dates by location.
**Table Type:** Dimension
**SCD Type:** Type 1 (no historical tracking required)

| Column Name         | Data Type    | Description                                         | PII Classification |
|---------------------|-------------|-----------------------------------------------------|--------------------|
| Holiday_Date        | datetime    | Date of the holiday                                 |                    |
| Description         | varchar(100)| Description of the holiday                          |                    |
| Location            | varchar(50) | Location for which the holiday applies              |                    |
| Source_Type         | varchar(50) | Source of the holiday data                          |                    |
| load_date           | datetime    | Date when record was loaded into Gold layer         |                    |
| update_date         | datetime    | Date when record was last updated in Gold layer     |                    |
| source_system       | varchar(100)| Source system name                                  |                    |

---

#### Table: Go_Dim_Workflow_Task
**Description:** Workflow task dimension for approval and process tracking.
**Table Type:** Dimension
**SCD Type:** Type 2 (historical tracking of workflow task status and attributes)

| Column Name             | Data Type      | Description                                         | PII Classification |
|-------------------------|---------------|-----------------------------------------------------|--------------------|
| Candidate_Name          | varchar(100)  | Name of the resource or consultant                  | PII                |
| Resource_Code           | varchar(50)   | Unique code for the resource                        | Identifier         |
| Workflow_Task_Reference | numeric(18,0) | Reference to the workflow or approval task          |                    |
| Type                    | varchar(50)   | Onsite/Offshore indicator                           |                    |
| Tower                   | varchar(60)   | Business tower or division                          |                    |
| Status                  | varchar(50)   | Current status of the workflow task                 |                    |
| Comments                | varchar(8000) | Comments or notes for the task                      |                    |
| Date_Created            | datetime      | Date the workflow task was created                  |                    |
| Date_Completed          | datetime      | Date the workflow task was completed                |                    |
| Process_Name            | varchar(100)  | Human workflow process name                         |                    |
| Level_ID                | int           | Current level identifier in the workflow process    |                    |
| Last_Level              | int           | Last completed level in the workflow process        |                    |
| load_date               | datetime      | Date when record was loaded into Gold layer         |                    |
| update_date             | datetime      | Date when record was last updated in Gold layer     |                    |
| source_system           | varchar(100)  | Source system name                                  |                    |

---

### 2.2 FACT TABLES

#### Table: Go_Fact_Timesheet_Entry
**Description:** Captures daily timesheet entries for each resource, including hours worked by type and associated dates.
**Table Type:** Fact

| Column Name             | Data Type      | Description                                         | PII Classification |
|-------------------------|---------------|-----------------------------------------------------|--------------------|
| Resource_Code           | varchar(50)   | Unique code for the resource                        | Identifier         |
| Timesheet_Date          | datetime      | Date for which the timesheet entry is recorded      |                    |
| Project_Task_Reference  | numeric(18,9) | Reference to the project or task                    |                    |
| Standard_Hours          | float         | Number of standard hours worked                     |                    |
| Overtime_Hours          | float         | Number of overtime hours worked                     |                    |
| Double_Time_Hours       | float         | Number of double time hours worked                  |                    |
| Sick_Time_Hours         | float         | Number of sick time hours recorded                  |                    |
| Holiday_Hours           | float         | Number of hours recorded as holiday                 |                    |
| Time_Off_Hours          | float         | Number of time off hours recorded                   |                    |
| Non_Standard_Hours      | float         | Number of non-standard hours worked                 |                    |
| Non_Overtime_Hours      | float         | Number of non-overtime hours worked                 |                    |
| Non_Double_Time_Hours   | float         | Number of non-double time hours worked              |                    |
| Non_Sick_Time_Hours     | float         | Number of non-sick time hours recorded              |                    |
| Creation_Date           | datetime      | Date when timesheet entry was created               |                    |
| load_date               | datetime      | Date when record was loaded into Gold layer         |                    |
| update_date             | datetime      | Date when record was last updated in Gold layer     |                    |
| source_system           | varchar(100)  | Source system name                                  |                    |

---

#### Table: Go_Fact_Timesheet_Approval
**Description:** Contains submitted and approved timesheet hours by resource, date, and billing type.
**Table Type:** Fact

| Column Name                 | Data Type      | Description                                         | PII Classification |
|-----------------------------|---------------|-----------------------------------------------------|--------------------|
| Resource_Code               | varchar(50)   | Unique code for the resource                        | Identifier         |
| Timesheet_Date              | datetime      | Date for which the timesheet entry is recorded      |                    |
| Week_Date                   | datetime      | Week date for the timesheet entry                   |                    |
| Approved_Standard_Hours     | float         | Approved standard hours for the day                 |                    |
| Approved_Overtime_Hours     | float         | Approved overtime hours for the day                 |                    |
| Approved_Double_Time_Hours  | float         | Approved double time hours for the day              |                    |
| Approved_Sick_Time_Hours    | float         | Approved sick time hours for the day                |                    |
| Billing_Indicator           | varchar(3)    | Indicates if the hours are billable                 |                    |
| Consultant_Standard_Hours   | float         | Consultant-submitted standard hours                 |                    |
| Consultant_Overtime_Hours   | float         | Consultant-submitted overtime hours                 |                    |
| Consultant_Double_Time_Hours| float         | Consultant-submitted double time hours              |                    |
| load_date                   | datetime      | Date when record was loaded into Gold layer         |                    |
| update_date                 | datetime      | Date when record was last updated in Gold layer     |                    |
| source_system               | varchar(100)  | Source system name                                  |                    |

---

### 2.3 AGGREGATED TABLES

#### Table: Go_Agg_Resource_Utilization
**Description:** Aggregated resource utilization metrics by resource, project, and time period.
**Table Type:** Aggregated

| Column Name         | Data Type      | Description                                         | PII Classification |
|---------------------|---------------|-----------------------------------------------------|--------------------|
| Resource_Code       | varchar(50)   | Unique code for the resource                        | Identifier         |
| Project_Name        | varchar(200)  | Name of the project                                 |                    |
| Calendar_Date       | datetime      | Calendar date (from Go_Dim_Date)                    |                    |
| Total_Hours         | float         | Total hours (working days × location hours)         |                    |
| Submitted_Hours     | float         | Total timesheet hours submitted                     |                    |
| Approved_Hours      | float         | Total timesheet hours approved                      |                    |
| Total_FTE           | float         | Submitted Hours / Total Hours                       |                    |
| Billed_FTE          | float         | Approved Hours / Total Hours                        |                    |
| Project_Utilization | float         | Billed Hours / Available Hours                      |                    |
| Available_Hours     | float         | Monthly Hours × Total FTE                           |                    |
| Actual_Hours        | float         | Actual hours worked                                 |                    |
| Onsite_Hours        | float         | Actual hours worked onsite                          |                    |
| Offsite_Hours       | float         | Actual hours worked offshore                        |                    |
| load_date           | datetime      | Date when record was loaded into Gold layer         |                    |
| update_date         | datetime      | Date when record was last updated in Gold layer     |                    |
| source_system       | varchar(100)  | Source system name                                  |                    |

---

### 2.4 PROCESS AUDIT AND ERROR DATA TABLES

#### Table: Go_Process_Audit
**Description:** Stores process audit details from pipeline execution.
**Table Type:** Audit

| Column Name             | Data Type      | Description                                         | PII Classification |
|-------------------------|---------------|-----------------------------------------------------|--------------------|
| Pipeline_Name           | varchar(200)  | Name of the data pipeline                           |                    |
| Pipeline_Run_ID         | varchar(100)  | Unique identifier for the pipeline run              |                    |
| Source_System           | varchar(100)  | Source system name                                  |                    |
| Source_Table            | varchar(200)  | Source table name                                   |                    |
| Target_Table            | varchar(200)  | Target Gold table name                              |                    |
| Processing_Type         | varchar(50)   | Type of processing (Full Load, Incremental, Delta)  |                    |
| Start_Time              | datetime      | Pipeline start timestamp                            |                    |
| End_Time                | datetime      | Pipeline end timestamp                              |                    |
| Duration_Seconds        | decimal(10,2) | Processing duration in seconds                      |                    |
| Status                  | varchar(50)   | Pipeline execution status                           |                    |
| Records_Read            | bigint        | Number of records read from source                  |                    |
| Records_Processed       | bigint        | Number of records processed                         |                    |
| Records_Inserted        | bigint        | Number of records inserted into Gold                |                    |
| Records_Updated         | bigint        | Number of records updated in Gold                   |                    |
| Records_Deleted         | bigint        | Number of records deleted from Gold                 |                    |
| Records_Rejected        | bigint        | Number of records rejected due to quality issues    |                    |
| Data_Quality_Score      | decimal(5,2)  | Overall data quality score percentage               |                    |
| Transformation_Rules_Applied | varchar(1000) | List of transformation rules applied           |                    |
| Business_Rules_Applied  | varchar(1000) | List of business rules applied                      |                    |
| Error_Count             | int           | Total number of errors encountered                  |                    |
| Warning_Count           | int           | Total number of warnings encountered                |                    |
| Error_Message           | varchar(max)  | Detailed error message if pipeline failed           |                    |
| Checkpoint_Data         | varchar(max)  | Checkpoint data for incremental processing          |                    |
| Resource_Utilization    | varchar(500)  | Resource utilization metrics                        |                    |
| Data_Lineage            | varchar(1000) | Data lineage information                            |                    |
| Executed_By             | varchar(100)  | User or service account that executed the pipeline  |                    |
| Environment             | varchar(50)   | Environment where pipeline was executed             |                    |
| Version                 | varchar(50)   | Version of the pipeline                             |                    |
| Configuration           | varchar(max)  | Pipeline configuration parameters                   |                    |
| Created_Date            | datetime      | Date when audit record was created                  |                    |
| Modified_Date           | datetime      | Date when audit record was last modified            |                    |

---

#### Table: Go_Error_Data
**Description:** Stores error data from the data validation process.
**Table Type:** Error Data

| Column Name         | Data Type      | Description                                         | PII Classification |
|---------------------|---------------|-----------------------------------------------------|--------------------|
| Source_Table        | varchar(200)  | Name of the source table where error occurred        |                    |
| Target_Table        | varchar(200)  | Name of the target Gold table                       |                    |
| Record_Identifier   | varchar(500)  | Identifier of the record that failed validation      |                    |
| Error_Type          | varchar(100)  | Type of error (Data Quality, Business Rule, etc.)   |                    |
| Error_Category      | varchar(100)  | Category of error                                   |                    |
| Error_Description   | varchar(1000) | Detailed description of the error                   |                    |
| Field_Name          | varchar(200)  | Name of the field that caused the error             |                    |
| Field_Value         | varchar(500)  | Value that caused the error                         |                    |
| Expected_Value      | varchar(500)  | Expected value or format                            |                    |
| Business_Rule       | varchar(500)  | Business rule that was violated                     |                    |
| Severity_Level      | varchar(50)   | Severity level (Critical, High, Medium, Low)        |                    |
| Error_Date          | datetime      | Date and time when error occurred                   |                    |
| Batch_ID            | varchar(100)  | Batch identifier for grouping related errors         |                    |
| Processing_Stage    | varchar(100)  | Stage of processing where error occurred            |                    |
| Resolution_Status   | varchar(50)   | Status of error resolution                          |                    |
| Resolution_Notes    | varchar(1000) | Notes about error resolution                        |                    |
| Created_By          | varchar(100)  | System or user that created the error record        |                    |
| Created_Date        | datetime      | Date when error record was created                  |                    |
| Modified_Date       | datetime      | Date when error record was last modified            |                    |

---

## 3. CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORM)

| Table                  | Related Table           | Relationship Key Field(s)                | Relationship Description |
|------------------------|------------------------|------------------------------------------|-------------------------|
| Go_Dim_Resource        | Go_Fact_Timesheet_Entry| Resource_Code                            | One resource can have many timesheet entries |
| Go_Dim_Resource        | Go_Fact_Timesheet_Approval | Resource_Code                        | One resource can have many timesheet approvals |
| Go_Dim_Resource        | Go_Dim_Workflow_Task   | Resource_Code                            | One resource can have many workflow tasks |
| Go_Dim_Project         | Go_Fact_Timesheet_Entry| Project_Task_Reference                   | One project can have many timesheet entries |
| Go_Dim_Project         | Go_Agg_Resource_Utilization | Project_Name                         | One project can have many utilization records |
| Go_Fact_Timesheet_Entry| Go_Dim_Date            | Timesheet_Date = Calendar_Date           | Many timesheet entries can occur on one date |
| Go_Fact_Timesheet_Entry| Go_Fact_Timesheet_Approval | Resource_Code + Timesheet_Date       | One-to-one for timesheet approval |
| Go_Fact_Timesheet_Approval | Go_Dim_Date         | Timesheet_Date = Calendar_Date           | Many approvals can occur on one date |
| Go_Dim_Date            | Go_Dim_Holiday         | Calendar_Date = Holiday_Date             | One date can have multiple holidays |
| Go_Dim_Workflow_Task   | Go_Dim_Resource        | Resource_Code                            | Many workflow tasks belong to one resource |
| Go_Dim_Holiday         | Go_Dim_Date            | Holiday_Date = Calendar_Date             | Many holidays can reference one calendar date |
| Go_Agg_Resource_Utilization | Go_Dim_Resource   | Resource_Code                            | Aggregated utilization by resource |
| Go_Agg_Resource_Utilization | Go_Dim_Project    | Project_Name                             | Aggregated utilization by project |
| Go_Agg_Resource_Utilization | Go_Dim_Date       | Calendar_Date                            | Aggregated utilization by date |

---

## 4. RATIONALE AND ASSUMPTIONS

- **Fact tables** are transactional (timesheet entry, approval) and support analytics at the lowest granularity.
- **Dimension tables** are descriptive and support SCD Type 2 for historical tracking where business meaning changes over time (Resource, Project, Workflow Task).
- **Aggregated tables** are designed for reporting KPIs and support efficient dashboarding.
- **Process audit and error data tables** ensure traceability, compliance, and data quality monitoring.
- **PII fields** are classified based on GDPR/common standards (names, identifiers).
- **No physical key/ID fields** are included as per instruction.
- **Naming convention**: All tables prefixed with 'Go_' and follow the required structure.

## 5. API COST

**apiCost:** 0.03

---

END OF DOCUMENT
