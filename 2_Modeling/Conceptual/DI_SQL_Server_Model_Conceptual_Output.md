------------------------------------------------------------------------
Author:        AAVA       
Date:          
Description:   Conceptual data model for UTL and resource utilization reporting system
------------------------------------------------------------------------

1. Domain Overview
The primary business domain is Resource Utilization and Workforce Management. The reports focus on tracking hours, FTE, billing, project allocation, and resource status across multiple geographies and clients.

2. Entities and Descriptions

2.1. Timesheet Entry (Table: Timesheet_New)
   - Description: Captures daily timesheet entries for each resource, including hours worked by type and associated dates.

2.2. Resource (Table: New_Monthly_HC_Report)
   - Description: Represents workforce members, their employment details, project assignments, and business-related attributes.

2.3. Project (Table: report_392_all)
   - Description: Contains details of projects, billing types, client information, and project-specific attributes.

2.4. Date (Table: DimDate)
   - Description: Provides calendar and working day context for time-based calculations, including weekends and holidays.

2.5. Holiday (Tables: holidays, holidays_India, holidays_Mexico, holidays_Canada)
   - Description: Stores holiday dates by location, used to exclude non-working days in hour calculations.

2.6. Timesheet Approval (Tables: vw_billing_timesheet_daywise_ne, vw_consultant_timesheet_daywise)
   - Description: Contains submitted and approved timesheet hours by resource, date, and billing type.

2.7. Workflow Task (Table: SchTask)
   - Description: Represents workflow or approval tasks related to resources and timesheet processes.

3. Entity Attributes (Business Names and Descriptions)

3.1. Timesheet Entry
   - Resource Code: Unique code for the resource submitting the timesheet
   - Timesheet Date: Date for which the timesheet entry is recorded
   - Project Task Reference: Reference to the project or task for which hours are logged
   - Standard Hours: Number of standard hours worked
   - Overtime Hours: Number of overtime hours worked
   - Double Time Hours: Number of double time hours worked
   - Sick Time Hours: Number of sick time hours recorded
   - Holiday Hours: Number of hours recorded as holiday
   - Non-Standard Hours: Number of non-standard hours worked
   - Non-Overtime Hours: Number of non-overtime hours worked
   - Non-Double Time Hours: Number of non-double time hours worked
   - Non-Sick Time Hours: Number of non-sick time hours recorded

3.2. Resource
   - First Name: Resource's given name
   - Last Name: Resource's family name
   - Job Title: Resource's job designation
   - Business Type: Classification of employment (e.g., FTE, Consultant)
   - Client Code: Code representing the client
   - Start Date: Resource's employment start date
   - Termination Date: Resource's employment end date
   - Project Assignment: Name of the project assigned
   - Market: Market or region of the resource
   - Visa Type: Type of work visa held by the resource
   - Practice Type: Practice or business unit
   - Vertical: Industry vertical
   - Status: Current employment status (e.g., Active, Terminated)
   - Employee Category: Category of the employee (e.g., Bench, AVA)
   - Portfolio Leader: Business portfolio leader
   - Expected Hours: Expected working hours per period
   - Available Hours: Calculated available hours for the resource
   - Business Area: Geographic business area (NA, LATAM, India, etc.)
   - SOW: Statement of Work indicator
   - Super Merged Name: Parent client name
   - New Business Type: Contract/Direct Hire/Project NBL
   - Requirement Region: Region for the requirement

3.3. Project
   - Project Name: Name of the project
   - Client Name: Name of the client
   - Billing Type: Billing classification (Billable/Non-Billable)
   - Category: Project category (e.g., India Billing - Client-NBL)
   - Status: Billing status (Billed/Unbilled/SGA)
   - Project City: City where the project is executed
   - Project State: State where the project is executed
   - Opportunity Name: Name of the business opportunity
   - Project Type: Type of project (e.g., Pipeline, CapEx)
   - Delivery Leader: Project delivery leader
   - Circle: Business circle or grouping
   - Market Leader: Market leader for the project

3.4. Date
   - Calendar Date: Actual calendar date
   - Day Name: Name of the day (e.g., Monday)
   - Month Name: Name of the month
   - Quarter: Quarter of the year
   - Year: Year
   - Is Working Day: Indicator if the date is a working day
   - Is Weekend: Indicator if the date is a weekend

3.5. Holiday
   - Holiday Date: Date of the holiday
   - Description: Description of the holiday
   - Location: Location for which the holiday applies
   - Source Type: Source of the holiday data

3.6. Timesheet Approval
   - Resource Code: Unique code for the resource
   - Timesheet Date: Date for which the timesheet entry is recorded
   - Approved Standard Hours: Approved standard hours for the day
   - Approved Overtime Hours: Approved overtime hours for the day
   - Approved Double Time Hours: Approved double time hours for the day
   - Approved Sick Time Hours: Approved sick time hours for the day
   - Billing Indicator: Indicates if the hours are billable

3.7. Workflow Task
   - Candidate Name: Name of the resource or consultant
   - Workflow Task Reference: Reference to the workflow or approval task
   - Type: Onsite/Offshore indicator
   - Tower: Business tower or division
   - Status: Current status of the workflow task
   - Comments: Comments or notes for the task
   - Date Created: Date the workflow task was created
   - Date Completed: Date the workflow task was completed

4. Key Performance Indicators (KPIs)
   1. Total Hours: Number of working days * respective location hours (8 or 9)
   2. Submitted Hours: Total timesheet hours submitted by the resource
   3. Approved Hours: Total timesheet hours approved by the manager
   4. Total FTE: Submitted Hours / Total Hours
   5. Billed FTE: Approved Hours / Total Hours (or Submitted Hours if Approved not available)
   6. Project Utilization: Billed Hours / Available Hours
   7. Available Hours: Monthly Hours * Total FTE
   8. Actual Hours: Actual hours worked by the resource
   9. Onsite Hours: Actual hours worked onsite
   10. Offsite Hours: Actual hours worked offshore

5. Conceptual Data Model Diagram (Tabular Relationship Form)

| Entity                | Related Entity         | Relationship Key Field(s)                |
|-----------------------|-----------------------|------------------------------------------|
| Timesheet Entry       | Resource              | Resource Code                            |
| Timesheet Entry       | Project               | Project Task Reference                   |
| Timesheet Entry       | Date                  | Timesheet Date                           |
| Timesheet Entry       | Timesheet Approval    | Resource Code, Timesheet Date            |
| Timesheet Approval    | Resource              | Resource Code                            |
| Timesheet Approval    | Date                  | Timesheet Date                           |
| Resource              | Project               | Project Assignment / Project Name        |
| Resource              | Workflow Task         | Candidate Name / Resource Code           |
| Project               | Workflow Task         | Project Name                             |
| Date                  | Holiday               | Calendar Date = Holiday Date             |

6. Common Data Elements in Report Requirements
   1. Resource Code / GCI_ID
   2. Timesheet Date / PE_DATE
   3. Project Name / ITSSProjectName
   4. Client Name
   5. Billing Type
   6. Category
   7. Status
   8. Approved Hours
   9. Submitted Hours
   10. Available Hours
   11. Actual Hours
   12. Onsite/Offsite Indicator
   13. Portfolio Leader
   14. Business Area
   15. SOW
   16. Super Merged Name

7. API Cost Calculation
   – Cost for this Call: $0.02
