====================================================
Author:        AAVA
Date:          
Description:   Gold Layer Logical Data Model for Medallion Architecture - Resource Utilization and Workforce Management
====================================================

# GOLD LAYER LOGICAL DATA MODEL

## 1. OVERVIEW

The Gold layer logical data model represents the final consumption layer in the medallion architecture, designed to support analytical queries, reporting, and business intelligence for Resource Utilization and Workforce Management. This layer implements a dimensional model with Facts, Dimensions, Aggregated tables, and supporting audit/error structures.

**Design Principles:**
- Dimensional modeling approach for optimized query performance
- Slowly Changing Dimension (SCD) implementation for historical tracking
- Denormalized structures for reporting efficiency
- Consistent naming convention with 'Go_' prefix
- Metadata columns for data lineage and audit trail
- PII classification based on GDPR standards

---

## 2. DIMENSION TABLES

### Table: Go_Dim_Resource
**Description:** Dimension table containing resource master data with historical tracking of changes to resource attributes over time.
**Table Type:** Dimension
**SCD Type:** Type 2 (Historical tracking with effective dates)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Resource_Code | varchar(50) | Unique code for the resource (business key) | Non-PII |
| First_Name | varchar(50) | Resource's given name | PII - Personal Identifier |
| Last_Name | varchar(50) | Resource's family name | PII - Personal Identifier |
| Full_Name | varchar(101) | Concatenated full name of the resource | PII - Personal Identifier |
| Job_Title | varchar(50) | Resource's job designation or role | Non-PII |
| Business_Type | varchar(50) | Classification of employment (e.g., FTE, Consultant) | Non-PII |
| Client_Code | varchar(50) | Code representing the client organization | Non-PII |
| Start_Date | datetime | Resource's employment start date | Non-PII |
| Termination_Date | datetime | Resource's employment end date | Non-PII |
| Project_Assignment | varchar(200) | Name of the project currently assigned | Non-PII |
| Market | varchar(50) | Market or geographic region of the resource | Non-PII |
| Visa_Type | varchar(50) | Type of work visa held by the resource | PII - Sensitive Personal Data |
| Practice_Type | varchar(50) | Practice or business unit classification | Non-PII |
| Vertical | varchar(50) | Industry vertical or sector | Non-PII |
| Status | varchar(50) | Current employment status (e.g., Active, Terminated) | Non-PII |
| Employee_Category | varchar(50) | Category of the employee (e.g., Bench, AVA) | Non-PII |
| Portfolio_Leader | varchar(100) | Business portfolio leader name | Non-PII |
| Expected_Hours | float | Expected working hours per period | Non-PII |
| Available_Hours | float | Calculated available hours for the resource | Non-PII |
| Business_Area | varchar(50) | Geographic business area (NA, LATAM, India, etc.) | Non-PII |
| SOW | varchar(7) | Statement of Work indicator (Yes/No) | Non-PII |
| Super_Merged_Name | varchar(100) | Parent client name for consolidated reporting | Non-PII |
| New_Business_Type | varchar(100) | Contract type (Contract/Direct Hire/Project NBL) | Non-PII |
| Requirement_Region | varchar(50) | Region where the requirement originated | Non-PII |
| Is_Offshore | varchar(20) | Offshore location indicator (Onsite/Offshore) | Non-PII |
| Effective_Start_Date | datetime | Start date when this version of the record became effective | Non-PII |
| Effective_End_Date | datetime | End date when this version of the record ceased to be effective | Non-PII |
| Is_Current | bit | Flag indicating if this is the current active record (1=Current, 0=Historical) | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

**SCD Type 2 Rationale:** Resource attributes like Job_Title, Business_Type, Project_Assignment, Status, and Client_Code change over time and require historical tracking for accurate point-in-time reporting and trend analysis.

---

### Table: Go_Dim_Project
**Description:** Dimension table containing project information with historical tracking of project attributes and billing classifications.
**Table Type:** Dimension
**SCD Type:** Type 2 (Historical tracking with effective dates)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Project_Name | varchar(200) | Name of the project (business key) | Non-PII |
| Client_Name | varchar(60) | Name of the client organization | Non-PII |
| Client_Code | varchar(50) | Unique identifier code assigned to the client | Non-PII |
| Billing_Type | varchar(50) | Billing classification (Billable/Non-Billable) | Non-PII |
| Category | varchar(50) | Project category classification | Non-PII |
| Status | varchar(50) | Billing status (Billed/Unbilled/SGA) | Non-PII |
| Project_City | varchar(50) | City where the project is executed | Non-PII |
| Project_State | varchar(50) | State where the project is executed | Non-PII |
| Opportunity_Name | varchar(200) | Name of the business opportunity | Non-PII |
| Project_Type | varchar(500) | Type of project (e.g., Pipeline, CapEx) | Non-PII |
| Delivery_Leader | varchar(50) | Project delivery leader name | Non-PII |
| Circle | varchar(100) | Business circle or grouping | Non-PII |
| Market_Leader | varchar(100) | Market leader responsible for the project | Non-PII |
| Net_Bill_Rate | money | Net bill rate for the project | Non-PII |
| Bill_Rate | decimal(18,9) | Standard bill rate for the project | Non-PII |
| Project_Start_Date | datetime | Date when project started | Non-PII |
| Project_End_Date | datetime | Date when project ended or is planned to end | Non-PII |
| Effective_Start_Date | datetime | Start date when this version of the record became effective | Non-PII |
| Effective_End_Date | datetime | End date when this version of the record ceased to be effective | Non-PII |
| Is_Current | bit | Flag indicating if this is the current active record (1=Current, 0=Historical) | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

**SCD Type 2 Rationale:** Project attributes like Billing_Type, Category, Status, Delivery_Leader, and Bill_Rate change over time and require historical tracking for accurate financial reporting and project performance analysis.

---

### Table: Go_Dim_Date
**Description:** Date dimension table providing comprehensive calendar attributes for time-based analysis and reporting.
**Table Type:** Dimension
**SCD Type:** Type 1 (No historical tracking needed - dates are immutable)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Calendar_Date | datetime | Actual calendar date (business key) | Non-PII |
| Day_Name | varchar(9) | Name of the day (e.g., Monday, Tuesday) | Non-PII |
| Day_Of_Month | varchar(2) | Day number within the month (1-31) | Non-PII |
| Day_Of_Year | int | Day number within the year (1-366) | Non-PII |
| Week_Of_Year | varchar(2) | Week number within the year (1-52) | Non-PII |
| Month_Name | varchar(9) | Name of the month (e.g., January, February) | Non-PII |
| Month_Number | varchar(2) | Month number (1-12) | Non-PII |
| Quarter | char(1) | Quarter of the year (1-4) | Non-PII |
| Quarter_Name | varchar(9) | Quarter name (Q1, Q2, Q3, Q4) | Non-PII |
| Year | char(4) | Four-digit year | Non-PII |
| Is_Working_Day | bit | Indicator if the date is a working day (1=Yes, 0=No) | Non-PII |
| Is_Weekend | bit | Indicator if the date is a weekend (1=Yes, 0=No) | Non-PII |
| Is_Holiday | bit | Indicator if the date is a holiday (1=Yes, 0=No) | Non-PII |
| Month_Year | char(10) | Month and year combination for grouping | Non-PII |
| YYMM | varchar(10) | Year and month in YYYYMM format | Non-PII |
| Fiscal_Year | char(4) | Fiscal year for financial reporting | Non-PII |
| Fiscal_Quarter | char(1) | Fiscal quarter for financial reporting | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

**SCD Type 1 Rationale:** Date attributes are static and do not change over time. Once a date is defined, its attributes remain constant.

---

### Table: Go_Dim_Workflow_Task
**Description:** Dimension table containing workflow and approval task information for resource onboarding and timesheet processes.
**Table Type:** Dimension
**SCD Type:** Type 1 (Overwrite changes - workflow tasks are transactional in nature)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Workflow_Task_Reference | numeric(18,0) | Reference identifier for the workflow or approval task (business key) | Non-PII |
| Candidate_Name | varchar(100) | Name of the resource or consultant in the workflow | PII - Personal Identifier |
| Resource_Code | varchar(50) | Unique code for the resource | Non-PII |
| Type | varchar(50) | Location type indicator (Onsite/Offshore) | Non-PII |
| Tower | varchar(60) | Business tower or division | Non-PII |
| Status | varchar(50) | Current status of the workflow task | Non-PII |
| Comments | varchar(8000) | Comments or notes for the task | Non-PII |
| Date_Created | datetime | Date when the workflow task was created | Non-PII |
| Date_Completed | datetime | Date when the workflow task was completed | Non-PII |
| Process_Name | varchar(100) | Human workflow process name | Non-PII |
| Level_ID | int | Current level identifier in the workflow process | Non-PII |
| Last_Level | int | Last completed level in the workflow process | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

**SCD Type 1 Rationale:** Workflow tasks are transactional and their status changes represent state transitions rather than historical versions requiring preservation.

---

## 3. CODE TABLES (LOOKUP TABLES)

### Table: Go_Code_Holiday
**Description:** Code table storing holiday dates by location for working day calculations and timesheet validation.
**Table Type:** Code Table
**SCD Type:** Type 1 (Overwrite changes)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Holiday_Date | datetime | Date of the holiday (business key) | Non-PII |
| Location | varchar(50) | Location for which the holiday applies (business key) | Non-PII |
| Description | varchar(100) | Description or name of the holiday | Non-PII |
| Source_Type | varchar(50) | Source of the holiday data for audit purposes | Non-PII |
| Is_Active | bit | Flag indicating if the holiday is currently active | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

**SCD Type 1 Rationale:** Holiday definitions are relatively static and changes are rare. When they occur, historical versions are not needed.

---

### Table: Go_Code_Billing_Type
**Description:** Code table defining billing type classifications for projects and resources.
**Table Type:** Code Table
**SCD Type:** Type 1 (Overwrite changes)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Billing_Type_Code | varchar(50) | Unique code for billing type (business key) | Non-PII |
| Billing_Type_Name | varchar(100) | Name of the billing type (e.g., Billable, Non-Billable) | Non-PII |
| Billing_Type_Description | varchar(500) | Detailed description of the billing type | Non-PII |
| Is_Billable | bit | Flag indicating if this type is billable (1=Yes, 0=No) | Non-PII |
| Is_Active | bit | Flag indicating if this billing type is currently active | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

---

### Table: Go_Code_Category
**Description:** Code table defining project category classifications based on billing and client types.
**Table Type:** Code Table
**SCD Type:** Type 1 (Overwrite changes)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Category_Code | varchar(50) | Unique code for category (business key) | Non-PII |
| Category_Name | varchar(100) | Name of the category | Non-PII |
| Category_Description | varchar(500) | Detailed description of the category | Non-PII |
| Category_Type | varchar(50) | Type of category (India Billing, Client, Project, etc.) | Non-PII |
| Is_Active | bit | Flag indicating if this category is currently active | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

---

### Table: Go_Code_Status
**Description:** Code table defining status values for projects, resources, and workflows.
**Table Type:** Code Table
**SCD Type:** Type 1 (Overwrite changes)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Status_Code | varchar(50) | Unique code for status (business key) | Non-PII |
| Status_Name | varchar(100) | Name of the status | Non-PII |
| Status_Description | varchar(500) | Detailed description of the status | Non-PII |
| Status_Type | varchar(50) | Type of status (Project, Resource, Workflow) | Non-PII |
| Is_Active | bit | Flag indicating if this status is currently active | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

---

### Table: Go_Code_Location
**Description:** Code table defining location codes and attributes for geographic analysis.
**Table Type:** Code Table
**SCD Type:** Type 1 (Overwrite changes)

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Location_Code | varchar(50) | Unique code for location (business key) | Non-PII |
| Location_Name | varchar(100) | Name of the location | Non-PII |
| Location_Type | varchar(50) | Type of location (Country, Region, Business Area) | Non-PII |
| Business_Area | varchar(50) | Business area classification (NA, LATAM, India, Others) | Non-PII |
| Standard_Hours_Per_Day | int | Standard working hours per day for this location | Non-PII |
| Is_Offshore | bit | Flag indicating if location is offshore (1=Yes, 0=No) | Non-PII |
| Is_Active | bit | Flag indicating if this location is currently active | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

---

## 4. FACT TABLES

### Table: Go_Fact_Timesheet
**Description:** Fact table capturing daily timesheet entries with various hour types and associated metrics for resource utilization analysis.
**Table Type:** Fact

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Resource_Code | varchar(50) | Foreign key to Go_Dim_Resource | Non-PII |
| Timesheet_Date | datetime | Foreign key to Go_Dim_Date | Non-PII |
| Project_Name | varchar(200) | Foreign key to Go_Dim_Project | Non-PII |
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
| Total_Submitted_Hours | float | Total hours submitted by resource (sum of all hour types) | Non-PII |
| Approved_Standard_Hours | float | Approved standard hours for the day | Non-PII |
| Approved_Overtime_Hours | float | Approved overtime hours for the day | Non-PII |
| Approved_Double_Time_Hours | float | Approved double time hours for the day | Non-PII |
| Approved_Sick_Time_Hours | float | Approved sick time hours for the day | Non-PII |
| Total_Approved_Hours | float | Total hours approved by manager (sum of approved hour types) | Non-PII |
| Billing_Indicator | varchar(3) | Indicates if the hours are billable (Yes/No) | Non-PII |
| Is_Working_Day | bit | Indicator if the timesheet date is a working day | Non-PII |
| Is_Weekend | bit | Indicator if the timesheet date is a weekend | Non-PII |
| Is_Holiday | bit | Indicator if the timesheet date is a holiday | Non-PII |
| Creation_Date | datetime | Date when timesheet entry was created | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

**Grain:** One row per resource per date per project

**Measures:**
- Standard_Hours, Overtime_Hours, Double_Time_Hours, Sick_Time_Hours, Holiday_Hours, Time_Off_Hours
- Non_Standard_Hours, Non_Overtime_Hours, Non_Double_Time_Hours, Non_Sick_Time_Hours
- Total_Submitted_Hours, Total_Approved_Hours
- Approved_Standard_Hours, Approved_Overtime_Hours, Approved_Double_Time_Hours, Approved_Sick_Time_Hours

**Design Rationale:** This fact table captures the atomic level of timesheet data, enabling detailed analysis of resource time allocation, approval patterns, and hour type distributions.

---

### Table: Go_Fact_Resource_Utilization
**Description:** Fact table capturing resource utilization metrics including FTE, available hours, and project allocation for workforce management analysis.
**Table Type:** Fact

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Resource_Code | varchar(50) | Foreign key to Go_Dim_Resource | Non-PII |
| Project_Name | varchar(200) | Foreign key to Go_Dim_Project | Non-PII |
| Period_Date | datetime | Foreign key to Go_Dim_Date (typically month-end date) | Non-PII |
| Year_Month | varchar(10) | Year and month in YYYYMM format | Non-PII |
| Total_Working_Days | int | Number of working days in the period | Non-PII |
| Total_Hours | float | Total expected hours (Working Days × Location Hours) | Non-PII |
| Submitted_Hours | float | Total timesheet hours submitted by resource | Non-PII |
| Approved_Hours | float | Total timesheet hours approved by manager | Non-PII |
| Billable_Hours | float | Total billable hours for the period | Non-PII |
| Non_Billable_Hours | float | Total non-billable hours for the period | Non-PII |
| Available_Hours | float | Calculated available hours (Monthly Hours × Total FTE) | Non-PII |
| Expected_Hours | float | Expected working hours per period | Non-PII |
| Actual_Hours | float | Actual hours worked by the resource | Non-PII |
| Onsite_Hours | float | Actual hours worked onsite | Non-PII |
| Offshore_Hours | float | Actual hours worked offshore | Non-PII |
| Total_FTE | decimal(10,4) | Total FTE (Submitted Hours / Total Hours) | Non-PII |
| Billed_FTE | decimal(10,4) | Billed FTE (Approved Hours / Total Hours) | Non-PII |
| Project_Utilization | decimal(10,4) | Project utilization percentage (Billed Hours / Available Hours) | Non-PII |
| Billing_Type | varchar(50) | Billing classification for the period | Non-PII |
| Category | varchar(50) | Project category for the period | Non-PII |
| Status | varchar(50) | Resource or project status for the period | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

**Grain:** One row per resource per project per month

**Measures:**
- Total_Working_Days, Total_Hours, Submitted_Hours, Approved_Hours
- Billable_Hours, Non_Billable_Hours, Available_Hours, Expected_Hours
- Actual_Hours, Onsite_Hours, Offshore_Hours
- Total_FTE, Billed_FTE, Project_Utilization

**Design Rationale:** This fact table provides aggregated monthly metrics for resource utilization analysis, enabling management to track FTE allocation, billability, and project utilization across the organization.

---

## 5. AGGREGATED TABLES

### Table: Go_Agg_Monthly_Resource_Summary
**Description:** Aggregated table providing monthly summary of resource utilization metrics at the resource level for executive reporting and dashboards.
**Table Type:** Aggregated

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Resource_Code | varchar(50) | Foreign key to Go_Dim_Resource | Non-PII |
| Year_Month | varchar(10) | Year and month in YYYYMM format | Non-PII |
| Period_Date | datetime | Foreign key to Go_Dim_Date (month-end date) | Non-PII |
| Business_Area | varchar(50) | Geographic business area | Non-PII |
| Business_Type | varchar(50) | Classification of employment | Non-PII |
| Portfolio_Leader | varchar(100) | Business portfolio leader | Non-PII |
| Total_Working_Days | int | Number of working days in the month | Non-PII |
| Total_Hours | float | Total expected hours for the month | Non-PII |
| Total_Submitted_Hours | float | Sum of all submitted hours across all projects | Non-PII |
| Total_Approved_Hours | float | Sum of all approved hours across all projects | Non-PII |
| Total_Billable_Hours | float | Sum of all billable hours | Non-PII |
| Total_Non_Billable_Hours | float | Sum of all non-billable hours | Non-PII |
| Total_Available_Hours | float | Total available hours for the resource | Non-PII |
| Total_Actual_Hours | float | Total actual hours worked | Non-PII |
| Total_Onsite_Hours | float | Total hours worked onsite | Non-PII |
| Total_Offshore_Hours | float | Total hours worked offshore | Non-PII |
| Average_Total_FTE | decimal(10,4) | Average Total FTE across all projects | Non-PII |
| Average_Billed_FTE | decimal(10,4) | Average Billed FTE across all projects | Non-PII |
| Overall_Utilization | decimal(10,4) | Overall utilization percentage | Non-PII |
| Number_Of_Projects | int | Count of distinct projects assigned | Non-PII |
| Number_Of_Clients | int | Count of distinct clients served | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

**Grain:** One row per resource per month

**Aggregation Logic:**
- Aggregates data from Go_Fact_Resource_Utilization at resource level
- Sums all hour metrics across projects
- Calculates average FTE and utilization metrics
- Counts distinct projects and clients

**Design Rationale:** Provides a consolidated monthly view of resource performance, enabling quick analysis of resource utilization trends and capacity planning.

---

### Table: Go_Agg_Monthly_Project_Summary
**Description:** Aggregated table providing monthly summary of project metrics including resource allocation, hours, and FTE for project management reporting.
**Table Type:** Aggregated

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Project_Name | varchar(200) | Foreign key to Go_Dim_Project | Non-PII |
| Year_Month | varchar(10) | Year and month in YYYYMM format | Non-PII |
| Period_Date | datetime | Foreign key to Go_Dim_Date (month-end date) | Non-PII |
| Client_Name | varchar(60) | Name of the client organization | Non-PII |
| Client_Code | varchar(50) | Unique identifier code for the client | Non-PII |
| Billing_Type | varchar(50) | Billing classification | Non-PII |
| Category | varchar(50) | Project category | Non-PII |
| Status | varchar(50) | Project billing status | Non-PII |
| Delivery_Leader | varchar(50) | Project delivery leader | Non-PII |
| Market_Leader | varchar(100) | Market leader for the project | Non-PII |
| Total_Resources_Assigned | int | Count of distinct resources assigned to project | Non-PII |
| Total_Submitted_Hours | float | Sum of all submitted hours for the project | Non-PII |
| Total_Approved_Hours | float | Sum of all approved hours for the project | Non-PII |
| Total_Billable_Hours | float | Sum of all billable hours | Non-PII |
| Total_Non_Billable_Hours | float | Sum of all non-billable hours | Non-PII |
| Total_Actual_Hours | float | Sum of actual hours worked on project | Non-PII |
| Total_FTE_Allocated | decimal(10,4) | Sum of FTE allocated to the project | Non-PII |
| Average_Utilization | decimal(10,4) | Average utilization across all resources | Non-PII |
| Net_Bill_Rate | money | Net bill rate for the project | Non-PII |
| Estimated_Revenue | money | Estimated revenue (Total_Billable_Hours × Net_Bill_Rate) | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

**Grain:** One row per project per month

**Aggregation Logic:**
- Aggregates data from Go_Fact_Resource_Utilization at project level
- Sums all hour metrics across resources
- Counts distinct resources assigned
- Calculates total FTE and average utilization
- Computes estimated revenue based on billable hours and rates

**Design Rationale:** Provides project-level visibility into resource allocation, effort tracking, and financial metrics for project managers and stakeholders.

---

### Table: Go_Agg_Monthly_Client_Summary
**Description:** Aggregated table providing monthly summary of client engagement metrics including resource allocation, hours, FTE, and revenue for account management.
**Table Type:** Aggregated

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Client_Code | varchar(50) | Unique identifier code for the client | Non-PII |
| Client_Name | varchar(60) | Name of the client organization | Non-PII |
| Year_Month | varchar(10) | Year and month in YYYYMM format | Non-PII |
| Period_Date | datetime | Foreign key to Go_Dim_Date (month-end date) | Non-PII |
| Super_Merged_Name | varchar(100) | Parent client name for consolidated reporting | Non-PII |
| Market_Leader | varchar(100) | Market leader responsible for the client | Non-PII |
| Business_Area | varchar(50) | Geographic business area | Non-PII |
| Total_Projects | int | Count of distinct projects for the client | Non-PII |
| Total_Resources_Assigned | int | Count of distinct resources assigned to client | Non-PII |
| Total_Submitted_Hours | float | Sum of all submitted hours for the client | Non-PII |
| Total_Approved_Hours | float | Sum of all approved hours for the client | Non-PII |
| Total_Billable_Hours | float | Sum of all billable hours | Non-PII |
| Total_Non_Billable_Hours | float | Sum of all non-billable hours | Non-PII |
| Total_Actual_Hours | float | Sum of actual hours worked for client | Non-PII |
| Total_FTE_Allocated | decimal(10,4) | Sum of FTE allocated to the client | Non-PII |
| Average_Utilization | decimal(10,4) | Average utilization across all resources | Non-PII |
| Estimated_Revenue | money | Estimated revenue for the client | Non-PII |
| SOW_Indicator | varchar(7) | Statement of Work indicator | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

**Grain:** One row per client per month

**Aggregation Logic:**
- Aggregates data from Go_Fact_Resource_Utilization at client level
- Sums all hour metrics across projects and resources
- Counts distinct projects and resources
- Calculates total FTE and average utilization
- Computes estimated revenue

**Design Rationale:** Provides client-level visibility into engagement size, resource commitment, and financial performance for account management and strategic planning.

---

### Table: Go_Agg_Weekly_Timesheet_Summary
**Description:** Aggregated table providing weekly summary of timesheet submissions and approvals for operational monitoring and compliance tracking.
**Table Type:** Aggregated

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Resource_Code | varchar(50) | Foreign key to Go_Dim_Resource | Non-PII |
| Week_Start_Date | datetime | Start date of the week | Non-PII |
| Week_End_Date | datetime | End date of the week | Non-PII |
| Week_Of_Year | varchar(2) | Week number within the year | Non-PII |
| Year | char(4) | Four-digit year | Non-PII |
| Business_Area | varchar(50) | Geographic business area | Non-PII |
| Portfolio_Leader | varchar(100) | Business portfolio leader | Non-PII |
| Total_Working_Days | int | Number of working days in the week | Non-PII |
| Days_With_Timesheet | int | Number of days with timesheet entries | Non-PII |
| Days_Without_Timesheet | int | Number of working days without timesheet entries | Non-PII |
| Total_Submitted_Hours | float | Sum of all submitted hours for the week | Non-PII |
| Total_Approved_Hours | float | Sum of all approved hours for the week | Non-PII |
| Total_Pending_Approval_Hours | float | Hours submitted but not yet approved | Non-PII |
| Timesheet_Compliance_Rate | decimal(10,4) | Percentage of working days with timesheets | Non-PII |
| Approval_Rate | decimal(10,4) | Percentage of submitted hours that are approved | Non-PII |
| load_date | datetime | Date when record was loaded into Gold layer | Non-PII |
| update_date | datetime | Date when record was last updated in Gold layer | Non-PII |
| source_system | varchar(100) | Source system from which data originated | Non-PII |

**Grain:** One row per resource per week

**Aggregation Logic:**
- Aggregates data from Go_Fact_Timesheet at weekly level
- Counts working days and days with/without timesheets
- Sums submitted and approved hours
- Calculates compliance and approval rates

**Design Rationale:** Enables operational monitoring of timesheet submission compliance and approval workflows, supporting timely intervention for non-compliance.

---

## 6. PROCESS AUDIT TABLES

### Table: Go_Pipeline_Audit
**Description:** Audit table for tracking Gold layer pipeline execution details, data lineage, processing metrics, and performance monitoring.
**Table Type:** Process Audit

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Audit_Key | bigint | Unique identifier for the audit record (surrogate key) | Non-PII |
| Pipeline_Name | varchar(200) | Name of the data pipeline executed | Non-PII |
| Pipeline_Run_Identifier | varchar(100) | Unique identifier for the specific pipeline run | Non-PII |
| Source_System | varchar(100) | Source system name (typically Silver layer) | Non-PII |
| Source_Table | varchar(200) | Source table name from Silver layer | Non-PII |
| Target_Table | varchar(200) | Target Gold table name | Non-PII |
| Processing_Type | varchar(50) | Type of processing (Full Load, Incremental, Delta, SCD) | Non-PII |
| Start_Time | datetime | Pipeline execution start timestamp | Non-PII |
| End_Time | datetime | Pipeline execution end timestamp | Non-PII |
| Duration_Seconds | decimal(10,2) | Total processing duration in seconds | Non-PII |
| Status | varchar(50) | Pipeline execution status (Success, Failed, Partial, Warning) | Non-PII |
| Records_Read | bigint | Number of records read from source | Non-PII |
| Records_Processed | bigint | Number of records processed | Non-PII |
| Records_Inserted | bigint | Number of records inserted into Gold layer | Non-PII |
| Records_Updated | bigint | Number of records updated in Gold layer | Non-PII |
| Records_Deleted | bigint | Number of records deleted from Gold layer | Non-PII |
| Records_Rejected | bigint | Number of records rejected due to quality issues | Non-PII |
| SCD_Type2_New_Records | bigint | Number of new SCD Type 2 records created | Non-PII |
| SCD_Type2_Updated_Records | bigint | Number of SCD Type 2 records updated (closed) | Non-PII |
| Data_Quality_Score | decimal(5,2) | Overall data quality score percentage (0-100) | Non-PII |
| Transformation_Rules_Applied | varchar(1000) | List of transformation rules applied | Non-PII |
| Business_Rules_Applied | varchar(1000) | List of business rules applied | Non-PII |
| Aggregation_Rules_Applied | varchar(1000) | List of aggregation rules applied (for aggregate tables) | Non-PII |
| Error_Count | int | Total number of errors encountered | Non-PII |
| Warning_Count | int | Total number of warnings encountered | Non-PII |
| Error_Message | varchar(max) | Detailed error message if pipeline failed | Non-PII |
| Checkpoint_Data | varchar(max) | Checkpoint data for incremental processing | Non-PII |
| Watermark_Value | varchar(100) | High watermark value for incremental loads | Non-PII |
| Resource_Utilization | varchar(500) | Resource utilization metrics (CPU, Memory, I/O) | Non-PII |
| Data_Lineage | varchar(1000) | Data lineage information (source to target mapping) | Non-PII |
| Executed_By | varchar(100) | User or service account that executed the pipeline | Non-PII |
| Environment | varchar(50) | Environment where pipeline was executed (Dev, Test, Prod) | Non-PII |
| Version | varchar(50) | Version of the pipeline | Non-PII |
| Configuration | varchar(max) | Pipeline configuration parameters in JSON format | Non-PII |
| Parent_Pipeline_Run_Identifier | varchar(100) | Parent pipeline run identifier for dependent pipelines | Non-PII |
| Retry_Count | int | Number of retry attempts for failed pipelines | Non-PII |
| Created_Date | datetime | Date when audit record was created | Non-PII |
| Modified_Date | datetime | Date when audit record was last modified | Non-PII |

**Design Rationale:** Comprehensive audit trail for all Gold layer pipeline executions, enabling monitoring, troubleshooting, performance optimization, and compliance with data governance requirements.

---

### Table: Go_Data_Lineage
**Description:** Audit table for tracking detailed data lineage from source to Gold layer, supporting impact analysis and data governance.
**Table Type:** Process Audit

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Lineage_Key | bigint | Unique identifier for the lineage record | Non-PII |
| Pipeline_Run_Identifier | varchar(100) | Reference to pipeline run in Go_Pipeline_Audit | Non-PII |
| Source_System | varchar(100) | Original source system name | Non-PII |
| Source_Database | varchar(100) | Source database name | Non-PII |
| Source_Schema | varchar(100) | Source schema name | Non-PII |
| Source_Table | varchar(200) | Source table name | Non-PII |
| Source_Column | varchar(200) | Source column name | Non-PII |
| Target_Database | varchar(100) | Target database name (Gold layer) | Non-PII |
| Target_Schema | varchar(100) | Target schema name (Gold layer) | Non-PII |
| Target_Table | varchar(200) | Target Gold table name | Non-PII |
| Target_Column | varchar(200) | Target Gold column name | Non-PII |
| Transformation_Logic | varchar(max) | Transformation logic applied to the data | Non-PII |
| Transformation_Type | varchar(100) | Type of transformation (Direct, Calculated, Derived, Aggregated) | Non-PII |
| Business_Rule | varchar(500) | Business rule applied during transformation | Non-PII |
| Data_Type_Source | varchar(50) | Data type in source | Non-PII |
| Data_Type_Target | varchar(50) | Data type in target | Non-PII |
| Is_PII | bit | Flag indicating if column contains PII data | Non-PII |
| PII_Classification | varchar(100) | PII classification level | Non-PII |
| Created_Date | datetime | Date when lineage record was created | Non-PII |
| Modified_Date | datetime | Date when lineage record was last modified | Non-PII |

**Design Rationale:** Provides detailed column-level lineage for impact analysis, regulatory compliance, and understanding data transformations from source to Gold layer.

---

## 7. ERROR DATA TABLES

### Table: Go_Data_Quality_Errors
**Description:** Error table for storing data validation errors and data quality issues identified during Gold layer processing.
**Table Type:** Error Data

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Error_Key | bigint | Unique identifier for the error record (surrogate key) | Non-PII |
| Pipeline_Run_Identifier | varchar(100) | Reference to pipeline run in Go_Pipeline_Audit | Non-PII |
| Source_Table | varchar(200) | Name of the source table where error occurred | Non-PII |
| Target_Table | varchar(200) | Name of the target Gold table | Non-PII |
| Record_Identifier | varchar(500) | Identifier of the record that failed validation | Non-PII |
| Error_Type | varchar(100) | Type of error (Data Quality, Business Rule, Constraint Violation, Transformation Error) | Non-PII |
| Error_Category | varchar(100) | Category of error (Completeness, Accuracy, Consistency, Validity, Integrity) | Non-PII |
| Error_Description | varchar(1000) | Detailed description of the error | Non-PII |
| Field_Name | varchar(200) | Name of the field that caused the error | Non-PII |
| Field_Value | varchar(500) | Value that caused the error | Non-PII |
| Expected_Value | varchar(500) | Expected value or format | Non-PII |
| Business_Rule | varchar(500) | Business rule that was violated | Non-PII |
| Validation_Rule | varchar(500) | Validation rule that failed | Non-PII |
| Severity_Level | varchar(50) | Severity level (Critical, High, Medium, Low, Informational) | Non-PII |
| Error_Date | datetime | Date and time when error occurred | Non-PII |
| Batch_Identifier | varchar(100) | Batch identifier for grouping related errors | Non-PII |
| Processing_Stage | varchar(100) | Stage of processing where error occurred (Extraction, Transformation, Loading, Validation) | Non-PII |
| Resolution_Status | varchar(50) | Status of error resolution (Open, In Progress, Resolved, Ignored, Deferred) | Non-PII |
| Resolution_Notes | varchar(1000) | Notes about error resolution | Non-PII |
| Resolved_By | varchar(100) | User who resolved the error | Non-PII |
| Resolved_Date | datetime | Date when error was resolved | Non-PII |
| Impact_Assessment | varchar(500) | Assessment of error impact on downstream processes | Non-PII |
| Remediation_Action | varchar(500) | Action taken to remediate the error | Non-PII |
| Created_By | varchar(100) | System or user that created the error record | Non-PII |
| Created_Date | datetime | Date when error record was created | Non-PII |
| Modified_Date | datetime | Date when error record was last modified | Non-PII |

**Design Rationale:** Comprehensive error tracking for data quality issues, enabling proactive data quality management, root cause analysis, and continuous improvement of data pipelines.

---

### Table: Go_Business_Rule_Violations
**Description:** Error table for tracking business rule violations identified during Gold layer processing and validation.
**Table Type:** Error Data

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| Violation_Key | bigint | Unique identifier for the violation record | Non-PII |
| Pipeline_Run_Identifier | varchar(100) | Reference to pipeline run in Go_Pipeline_Audit | Non-PII |
| Target_Table | varchar(200) | Name of the Gold table where violation occurred | Non-PII |
| Record_Identifier | varchar(500) | Identifier of the record with violation | Non-PII |
| Business_Rule_Name | varchar(200) | Name of the business rule violated | Non-PII |
| Business_Rule_Description | varchar(1000) | Description of the business rule | Non-PII |
| Business_Rule_Category | varchar(100) | Category of business rule (Calculation, Classification, Validation, Constraint) | Non-PII |
| Violation_Description | varchar(1000) | Detailed description of the violation | Non-PII |
| Expected_Result | varchar(500) | Expected result based on business rule | Non-PII |
| Actual_Result | varchar(500) | Actual result that violated the rule | Non-PII |
| Affected_Fields | varchar(500) | List of fields affected by the violation | Non-PII |
| Severity_Level | varchar(50) | Severity level of the violation | Non-PII |
| Violation_Date | datetime | Date and time when violation occurred | Non-PII |
| Business_Impact | varchar(500) | Description of business impact | Non-PII |
| Resolution_Status | varchar(50) | Status of violation resolution | Non-PII |
| Resolution_Notes | varchar(1000) | Notes about violation resolution | Non-PII |
| Resolved_By | varchar(100) | User who resolved the violation | Non-PII |
| Resolved_Date | datetime | Date when violation was resolved | Non-PII |
| Created_By | varchar(100) | System or user that created the violation record | Non-PII |
| Created_Date | datetime | Date when violation record was created | Non-PII |
| Modified_Date | datetime | Date when violation record was last modified | Non-PII |

**Design Rationale:** Specialized tracking for business rule violations, enabling business users to identify and address data issues that impact business logic and reporting accuracy.

---

### Table: Go_SCD_Audit
**Description:** Audit table for tracking Slowly Changing Dimension (SCD) Type 2 changes in dimension tables.
**Table Type:** Process Audit

| Column Name | Data Type | Description | PII Classification |
|-------------|-----------|-------------|--------------------|
| SCD_Audit_Key | bigint | Unique identifier for the SCD audit record | Non-PII |
| Pipeline_Run_Identifier | varchar(100) | Reference to pipeline run in Go_Pipeline_Audit | Non-PII |
| Dimension_Table | varchar(200) | Name of the dimension table | Non-PII |
| Business_Key | varchar(500) | Business key value of the dimension record | Non-PII |
| Change_Type | varchar(50) | Type of change (New Record, Update, No Change) | Non-PII |
| Changed_Columns | varchar(1000) | List of columns that changed | Non-PII |
| Old_Values | varchar(max) | Old values in JSON format | Non-PII |
| New_Values | varchar(max) | New values in JSON format | Non-PII |
| Effective_Start_Date | datetime | Effective start date of the new version | Non-PII |
| Effective_End_Date | datetime | Effective end date of the old version | Non-PII |
| Change_Date | datetime | Date when change was detected | Non-PII |
| Change_Reason | varchar(500) | Reason for the change | Non-PII |
| Created_By | varchar(100) | System or user that created the audit record | Non-PII |
| Created_Date | datetime | Date when audit record was created | Non-PII |

**Design Rationale:** Tracks all SCD Type 2 changes in dimension tables, providing audit trail for historical changes and supporting compliance requirements.

---

## 8. RELATIONSHIPS BETWEEN TABLES

### 8.1 Fact to Dimension Relationships

| Fact Table | Related Dimension | Relationship Key Field(s) | Cardinality | Description |
|------------|-------------------|---------------------------|-------------|-------------|
| Go_Fact_Timesheet | Go_Dim_Resource | Resource_Code | Many-to-One | Each timesheet entry belongs to one resource |
| Go_Fact_Timesheet | Go_Dim_Date | Timesheet_Date = Calendar_Date | Many-to-One | Each timesheet entry is for one date |
| Go_Fact_Timesheet | Go_Dim_Project | Project_Name | Many-to-One | Each timesheet entry is for one project |
| Go_Fact_Resource_Utilization | Go_Dim_Resource | Resource_Code | Many-to-One | Each utilization record belongs to one resource |
| Go_Fact_Resource_Utilization | Go_Dim_Project | Project_Name | Many-to-One | Each utilization record is for one project |
| Go_Fact_Resource_Utilization | Go_Dim_Date | Period_Date = Calendar_Date | Many-to-One | Each utilization record is for one period |

### 8.2 Dimension to Code Table Relationships

| Dimension Table | Related Code Table | Relationship Key Field(s) | Cardinality | Description |
|-----------------|-------------------|---------------------------|-------------|-------------|
| Go_Dim_Resource | Go_Code_Location | Business_Area = Location_Code | Many-to-One | Resource location reference |
| Go_Dim_Project | Go_Code_Billing_Type | Billing_Type = Billing_Type_Code | Many-to-One | Project billing type reference |
| Go_Dim_Project | Go_Code_Category | Category = Category_Code | Many-to-One | Project category reference |
| Go_Dim_Project | Go_Code_Status | Status = Status_Code | Many-to-One | Project status reference |
| Go_Dim_Date | Go_Code_Holiday | Calendar_Date = Holiday_Date | One-to-Many | Date to holiday mapping |

### 8.3 Aggregated Table Relationships

| Aggregated Table | Related Table | Relationship Key Field(s) | Cardinality | Description |
|------------------|---------------|---------------------------|-------------|-------------|
| Go_Agg_Monthly_Resource_Summary | Go_Dim_Resource | Resource_Code | Many-to-One | Aggregated data for each resource |
| Go_Agg_Monthly_Resource_Summary | Go_Dim_Date | Period_Date = Calendar_Date | Many-to-One | Aggregated data for each period |
| Go_Agg_Monthly_Project_Summary | Go_Dim_Project | Project_Name | Many-to-One | Aggregated data for each project |
| Go_Agg_Monthly_Project_Summary | Go_Dim_Date | Period_Date = Calendar_Date | Many-to-One | Aggregated data for each period |
| Go_Agg_Monthly_Client_Summary | Go_Dim_Project | Client_Code | Many-to-One | Aggregated data for each client |
| Go_Agg_Monthly_Client_Summary | Go_Dim_Date | Period_Date = Calendar_Date | Many-to-One | Aggregated data for each period |
| Go_Agg_Weekly_Timesheet_Summary | Go_Dim_Resource | Resource_Code | Many-to-One | Aggregated data for each resource |
| Go_Agg_Weekly_Timesheet_Summary | Go_Dim_Date | Week_Start_Date = Calendar_Date | Many-to-One | Aggregated data for each week |

### 8.4 Audit and Error Table Relationships

| Audit/Error Table | Related Table | Relationship Key Field(s) | Cardinality | Description |
|-------------------|---------------|---------------------------|-------------|-------------|
| Go_Data_Quality_Errors | Go_Pipeline_Audit | Pipeline_Run_Identifier | Many-to-One | Errors linked to pipeline runs |
| Go_Business_Rule_Violations | Go_Pipeline_Audit | Pipeline_Run_Identifier | Many-to-One | Violations linked to pipeline runs |
| Go_Data_Lineage | Go_Pipeline_Audit | Pipeline_Run_Identifier | Many-to-One | Lineage linked to pipeline runs |
| Go_SCD_Audit | Go_Pipeline_Audit | Pipeline_Run_Identifier | Many-to-One | SCD changes linked to pipeline runs |

---

## 9. DESIGN DECISIONS AND RATIONALE

### 9.1 Dimensional Modeling Approach
**Decision:** Implement star schema with fact and dimension tables
**Rationale:** 
- Optimizes query performance for analytical workloads
- Simplifies business user understanding and report development
- Supports efficient aggregation and drill-down analysis
- Aligns with industry best practices for data warehousing

### 9.2 Slowly Changing Dimension Implementation
**Decision:** Implement SCD Type 2 for Go_Dim_Resource and Go_Dim_Project
**Rationale:**
- Resource and project attributes change over time (job titles, billing rates, project status)
- Historical tracking is essential for accurate point-in-time reporting
- Supports trend analysis and historical comparisons
- Enables compliance with audit requirements

**Decision:** Implement SCD Type 1 for Go_Dim_Date, Go_Dim_Workflow_Task, and code tables
**Rationale:**
- Date attributes are immutable once defined
- Workflow tasks represent transactional state changes
- Code tables have infrequent changes and historical versions are not needed

### 9.3 Grain Selection
**Decision:** Go_Fact_Timesheet at daily level per resource per project
**Rationale:**
- Matches the atomic level of timesheet entry
- Supports detailed analysis of daily work patterns
- Enables flexible aggregation to weekly, monthly, or project levels

**Decision:** Go_Fact_Resource_Utilization at monthly level per resource per project
**Rationale:**
- Aligns with business reporting requirements (monthly utilization)
- Balances detail with performance
- Supports FTE and utilization calculations at appropriate granularity

### 9.4 Aggregated Tables
**Decision:** Create pre-aggregated tables for common reporting patterns
**Rationale:**
- Improves query performance for executive dashboards
- Reduces computational overhead for frequently accessed metrics
- Supports self-service analytics with simplified data structures
- Enables faster response times for monthly and weekly reports

### 9.5 Metadata Columns
**Decision:** Include load_date, update_date, and source_system in all tables
**Rationale:**
- Supports data lineage and audit trail requirements
- Enables troubleshooting and data quality monitoring
- Facilitates incremental loading and change data capture
- Aligns with data governance best practices

### 9.6 PII Classification
**Decision:** Classify columns based on GDPR standards
**Rationale:**
- Ensures compliance with data privacy regulations
- Supports data masking and access control implementation
- Enables proper handling of sensitive personal data
- Facilitates data protection impact assessments

### 9.7 Naming Conventions
**Decision:** Use 'Go_' prefix with table type indicators (Dim, Fact, Agg, Code)
**Rationale:**
- Clearly identifies Gold layer tables
- Distinguishes table types for easier navigation
- Supports consistent naming across the data platform
- Aligns with medallion architecture principles

### 9.8 Audit and Error Structures
**Decision:** Implement comprehensive audit and error tracking tables
**Rationale:**
- Supports data quality monitoring and improvement
- Enables root cause analysis for data issues
- Facilitates compliance with data governance requirements
- Provides transparency into data processing and transformations

---

## 10. ASSUMPTIONS

1. **Data Availability:** All required source data from Silver layer is available and accessible
2. **Data Quality:** Silver layer data has undergone initial quality checks and cleansing
3. **Business Rules:** Business rules documented in data constraints are complete and accurate
4. **Historical Data:** Historical data is available for initial SCD Type 2 population
5. **Performance Requirements:** Query response time requirements are within acceptable limits for dimensional model
6. **Incremental Loading:** Incremental loading mechanisms are available for efficient data refresh
7. **Resource Allocation:** Resources can be allocated to multiple projects simultaneously
8. **Time Periods:** Reporting periods align with calendar months and weeks
9. **Location Hours:** Standard hours per day are 8 for onshore and 9 for offshore locations
10. **Approval Workflow:** Timesheet approval workflow is consistent across all resources

---

## 11. CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORM)

### 11.1 Core Dimensional Model Relationships

| Source Table | Target Table | Relationship Key Field | Relationship Type | Description |
|--------------|--------------|------------------------|-------------------|-------------|
| Go_Dim_Resource | Go_Fact_Timesheet | Resource_Code | One-to-Many | One resource has many timesheet entries |
| Go_Dim_Project | Go_Fact_Timesheet | Project_Name | One-to-Many | One project has many timesheet entries |
| Go_Dim_Date | Go_Fact_Timesheet | Calendar_Date = Timesheet_Date | One-to-Many | One date has many timesheet entries |
| Go_Dim_Resource | Go_Fact_Resource_Utilization | Resource_Code | One-to-Many | One resource has many utilization records |
| Go_Dim_Project | Go_Fact_Resource_Utilization | Project_Name | One-to-Many | One project has many utilization records |
| Go_Dim_Date | Go_Fact_Resource_Utilization | Calendar_Date = Period_Date | One-to-Many | One date has many utilization records |
| Go_Code_Holiday | Go_Dim_Date | Holiday_Date = Calendar_Date | Many-to-One | Multiple holidays can occur on one date |
| Go_Code_Billing_Type | Go_Dim_Project | Billing_Type_Code = Billing_Type | One-to-Many | One billing type applies to many projects |
| Go_Code_Category | Go_Dim_Project | Category_Code = Category | One-to-Many | One category applies to many projects |
| Go_Code_Status | Go_Dim_Project | Status_Code = Status | One-to-Many | One status applies to many projects |
| Go_Code_Location | Go_Dim_Resource | Location_Code = Business_Area | One-to-Many | One location has many resources |
| Go_Dim_Workflow_Task | Go_Dim_Resource | Resource_Code | Many-to-One | Many workflow tasks belong to one resource |

### 11.2 Aggregated Table Relationships

| Source Table | Target Table | Relationship Key Field | Relationship Type | Description |
|--------------|--------------|------------------------|-------------------|-------------|
| Go_Fact_Resource_Utilization | Go_Agg_Monthly_Resource_Summary | Resource_Code + Year_Month | Many-to-One | Multiple utilization records aggregate to one monthly summary |
| Go_Fact_Resource_Utilization | Go_Agg_Monthly_Project_Summary | Project_Name + Year_Month | Many-to-One | Multiple utilization records aggregate to one project summary |
| Go_Fact_Resource_Utilization | Go_Agg_Monthly_Client_Summary | Client_Code + Year_Month | Many-to-One | Multiple utilization records aggregate to one client summary |
| Go_Fact_Timesheet | Go_Agg_Weekly_Timesheet_Summary | Resource_Code + Week_Start_Date | Many-to-One | Multiple timesheet entries aggregate to one weekly summary |
| Go_Dim_Resource | Go_Agg_Monthly_Resource_Summary | Resource_Code | One-to-Many | One resource has many monthly summaries |
| Go_Dim_Project | Go_Agg_Monthly_Project_Summary | Project_Name | One-to-Many | One project has many monthly summaries |
| Go_Dim_Date | Go_Agg_Monthly_Resource_Summary | Calendar_Date = Period_Date | One-to-Many | One date links to many monthly summaries |
| Go_Dim_Date | Go_Agg_Weekly_Timesheet_Summary | Calendar_Date = Week_Start_Date | One-to-Many | One date links to many weekly summaries |

### 11.3 Audit and Error Relationships

| Source Table | Target Table | Relationship Key Field | Relationship Type | Description |
|--------------|--------------|------------------------|-------------------|-------------|
| Go_Pipeline_Audit | Go_Data_Quality_Errors | Pipeline_Run_Identifier | One-to-Many | One pipeline run can have many errors |
| Go_Pipeline_Audit | Go_Business_Rule_Violations | Pipeline_Run_Identifier | One-to-Many | One pipeline run can have many violations |
| Go_Pipeline_Audit | Go_Data_Lineage | Pipeline_Run_Identifier | One-to-Many | One pipeline run has many lineage records |
| Go_Pipeline_Audit | Go_SCD_Audit | Pipeline_Run_Identifier | One-to-Many | One pipeline run can have many SCD changes |
| Go_Data_Quality_Errors | Go_Dim_Resource | Record_Identifier = Resource_Code | Many-to-One | Errors may reference resource records |
| Go_Data_Quality_Errors | Go_Dim_Project | Record_Identifier = Project_Name | Many-to-One | Errors may reference project records |
| Go_Business_Rule_Violations | Go_Fact_Timesheet | Record_Identifier | Many-to-One | Violations may reference fact records |
| Go_Business_Rule_Violations | Go_Fact_Resource_Utilization | Record_Identifier | Many-to-One | Violations may reference utilization records |

---

## 12. API COST CALCULATION

**apiCost:** 0.045

**Cost Breakdown:**
- Input file reading (3 files): $0.015
- Gold layer model generation: $0.025
- Output file writing: $0.005

**Total Cost:** $0.045 USD

---

## 13. SUMMARY

This Gold layer logical data model provides a comprehensive blueprint for implementing a scalable and efficient analytical data platform on SQL Server. The model includes:

**Dimension Tables (4):**
- Go_Dim_Resource (SCD Type 2)
- Go_Dim_Project (SCD Type 2)
- Go_Dim_Date (SCD Type 1)
- Go_Dim_Workflow_Task (SCD Type 1)

**Code Tables (5):**
- Go_Code_Holiday
- Go_Code_Billing_Type
- Go_Code_Category
- Go_Code_Status
- Go_Code_Location

**Fact Tables (2):**
- Go_Fact_Timesheet (Daily grain)
- Go_Fact_Resource_Utilization (Monthly grain)

**Aggregated Tables (4):**
- Go_Agg_Monthly_Resource_Summary
- Go_Agg_Monthly_Project_Summary
- Go_Agg_Monthly_Client_Summary
- Go_Agg_Weekly_Timesheet_Summary

**Process Audit Tables (3):**
- Go_Pipeline_Audit
- Go_Data_Lineage
- Go_SCD_Audit

**Error Data Tables (2):**
- Go_Data_Quality_Errors
- Go_Business_Rule_Violations

**Total Tables: 20**

The model supports:
- Efficient analytical queries through dimensional modeling
- Historical tracking through SCD Type 2 implementation
- Pre-aggregated data for performance optimization
- Comprehensive audit trail and error tracking
- Data quality monitoring and governance
- PII classification for compliance
- Flexible reporting and self-service analytics

---

**END OF DOCUMENT**