------------------------------------------------------------------------
Author: AAVA
Date: 2024-06-11
Description: Conceptual Data Model for UTL Reporting System
------------------------------------------------------------------------

1. Domain Overview
------------------
The reporting requirements focus on workforce utilization, timesheet management, billing categorization, project allocation, and holiday management across multiple geographies (India, US, Canada, Mexico, LATAM). The primary business domains are:
- Workforce Management
- Timesheet & Utilization Tracking
- Project & Billing Categorization
- Holiday & Calendar Management

2. Entity List with Description
------------------------------
2.1. New_Monthly_HC_Report
   - Description: Captures monthly headcount and workforce details, including business area, client, project, and employment status.
2.2. Timesheet_New
   - Description: Stores timesheet entries for resources, including hours worked, type of hours, and associated dates.
2.3. vw_billing_timesheet_daywise_ne
   - Description: Provides day-wise approved timesheet hours for resources, categorized by billing type.
2.4. vw_consultant_timesheet_daywise
   - Description: Provides day-wise consultant timesheet hours for resources, categorized by billing type.
2.5. report_392_all
   - Description: Contains comprehensive resource, project, and billing information for reporting and categorization.
2.6. SchTask
   - Description: Workflow and task management for resource allocation and project assignment.
2.7. DimDate
   - Description: Calendar dimension table for date, day, month, year, and working day/weekend identification.
2.8. holidays, holidays_India, holidays_Canada, holidays_Mexico
   - Description: Holiday details for respective locations, used for calculating working days and available hours.

3. Attributes for Each Entity (Business Name & Description)
----------------------------------------------------------
3.1. New_Monthly_HC_Report
   - First Name: Resource's first name
   - Last Name: Resource's last name
   - Job Title: Resource's job designation
   - HR Business Type: Type of employment (Contract/Direct Hire/Project NBL)
   - Client Code: Unique code for client
   - Start Date: Resource's start date
   - Termination Date: Resource's termination date
   - Final End Date: Final date of employment
   - Merged Name: Merged client/project name
   - Super Merged Name: Parent client name
   - Market: Market segment
   - IS SOW: Indicates if client is SOW
   - GP: Gross profit
   - Emp Status: Employment status
   - Employee Category: Category of employee (FTE/Consultant)
   - ITSS Project Name: Project name in ITSS system
   - IS Offshore: Indicates if resource is offshore
   - Subtier: Subtier company name
   - Practice Type: Practice area
   - Vertical: Industry vertical
   - CL Group: Client group
   - Sales Rep: Sales representative
   - Recruiter: Recruiter name
   - PO End: Purchase order end date
   - Expected Hrs: Expected hours per month
   - Expected Total Hrs: Total expected hours
   - Portfolio Leader: Portfolio lead for filtering
   - Status: Billing status (Billed/Unbilled/SGA)
   - Community: Community name
   - Circle: Circle name
   - Market Leader: Market leader name
   - Client Partner: Client partner name
   - Project Type: Type of project
   - Standard Job Title Horizon: Standardized job title
   - Experience Level Title: Experience level
   - User Name: Resource user name
   - Vertical Name: Industry name
   - New Business Type: Business type
   - Rec Region: Requirement region

3.2. Timesheet_New
   - GCI ID: Resource code
   - PE Date: Period end date
   - Task ID: Task identifier
   - C Date: Calendar date
   - ST: Standard hours worked
   - OT: Overtime hours worked
   - TIME OFF: Time off hours
   - HO: Holiday hours
   - DT: Double time hours
   - NON ST: Non-standard hours
   - NON OT: Non-overtime hours
   - Sick Time: Sick leave hours
   - NON Sick Time: Non-sick leave hours
   - NON DT: Non-double time hours

3.3. vw_billing_timesheet_daywise_ne
   - GCI ID: Resource code
   - PE Date: Period end date
   - Week Date: Week date
   - Billable: Billing type indicator
   - Approved Hours (ST): Approved standard hours
   - Approved Hours (Non ST): Approved non-standard hours
   - Approved Hours (OT): Approved overtime hours
   - Approved Hours (Non OT): Approved non-overtime hours
   - Approved Hours (DT): Approved double time hours
   - Approved Hours (Non DT): Approved non-double time hours
   - Approved Hours (Sick Time): Approved sick leave hours
   - Approved Hours (Non Sick Time): Approved non-sick leave hours

3.4. vw_consultant_timesheet_daywise
   - GCI ID: Resource code
   - PE Date: Period end date
   - Week Date: Week date
   - Billable: Billing type indicator
   - Consultant Hours (ST): Consultant standard hours
   - Consultant Hours (OT): Consultant overtime hours
   - Consultant Hours (DT): Consultant double time hours

3.5. report_392_all
   - First Name: Resource's first name
   - Last Name: Resource's last name
   - Employee Type: FTE/Consultant
   - Recruiting Manager: Manager responsible for recruitment
   - Resource Manager: Resource manager name
   - Sales Rep: Sales representative
   - Recruiter: Recruiter name
   - Client Code: Unique client code
   - Client Name: Client name
   - Job Title: Resource job title
   - Bill ST: Billable standard hours
   - Visa Type: Visa type
   - Salary: Resource salary
   - Start Date: Resource start date
   - End Date: Resource end date
   - Project City: Project location city
   - Project State: Project location state
   - HR Business Type: Employment type
   - Status: Billing status
   - Termination Reason: Reason for termination
   - HCU: HCU code
   - HSU: HSU code
   - Billing Type: Billable/Non-Billable
   - ITSS Project Name: Project name in ITSS system
   - Subtier: Subtier company name
   - Vertical Name: Industry name
   - Super Merged Name: Parent client name
   - New Business Type: Business type
   - Rec Region: Requirement region
   - Circle: Circle name
   - Community: Community name
   - Portfolio Leader: Portfolio lead
   - Client Partner: Client partner name
   - Project Type: Type of project
   - Standard Job Title: Standardized job title
   - Experience Level Title: Experience level
   - User Name: Resource user name

3.6. SchTask
   - SSN: Resource social security number
   - GCI ID: Resource code
   - FName: Resource first name
   - LName: Resource last name
   - Process ID: Workflow process identifier
   - Level ID: Workflow level identifier
   - Initiator: Task initiator
   - Status: Task status
   - Comments: Workflow comments
   - Date Created: Task creation date
   - Track ID: Tracking identifier
   - Date Completed: Task completion date
   - Existing Resource: Indicates if resource is existing
   - Legal Entity: Legal entity name

3.7. DimDate
   - Date: Calendar date
   - Day Of Month: Day number in month
   - Day Name: Name of the day
   - Week Of Year: Week number in year
   - Month: Month number
   - Month Name: Name of the month
   - Quarter: Quarter number
   - Quarter Name: Name of the quarter
   - Year: Year
   - Month Year: Month and year
   - Days In Month: Number of days in month
   - MM-YYYY: Month and year (formatted)
   - YYYYMM: Year and month (formatted)

3.8. holidays, holidays_India, holidays_Canada, holidays_Mexico
   - Holiday Date: Date of holiday
   - Description: Holiday description
   - Location: Location of holiday
   - Source Type: Source of holiday data

4. KPI List
-----------
4.1. Total Hours: Number of working days × respective location hours (8 or 9)
4.2. Submitted Hours: Timesheet hours submitted by resource
4.3. Approved Hours: Timesheet hours approved by manager
4.4. Total FTE: Submitted Hours / Total Hours
4.5. Billed FTE: Approved TS hours / Total Hours
4.6. Project Utilization: Billed Hours / Available Hours
4.7. Available Hours: Monthly Hours × Total FTE
4.8. Actual Hours: Actual hours worked
4.9. Onsite Hours: Actual onsite hours
4.10. Offsite Hours: Actual offshore hours

5. Conceptual Data Model Diagram (Tabular Relationship)
------------------------------------------------------
| Source Table                 | Related Table(s)                | Relationship Key Field(s)         |
|------------------------------|----------------------------------|-----------------------------------|
| New_Monthly_HC_Report        | report_392_all                   | gci id, ITSSProjectName           |
| Timesheet_New                | vw_billing_timesheet_daywise_ne  | gci_id, pe_date                   |
| Timesheet_New                | vw_consultant_timesheet_daywise  | gci_id, pe_date                   |
| Timesheet_New                | DimDate                          | c_date = Date                     |
| Timesheet_New                | SchTask                          | gci_id                            |
| DimDate                      | holidays, holidays_India,        | Date = Holiday_Date               |
|                              | holidays_Canada, holidays_Mexico |                                   |
| report_392_all               | New_Monthly_HC_Report            | gci id, ITSSProjectName           |
| SchTask                      | New_Monthly_HC_Report            | gci id                            |

6. Common Data Elements in Report Requirements
----------------------------------------------
- GCI ID (Resource code)
- ITSS Project Name
- Client Code
- First Name
- Last Name
- Job Title
- HR Business Type
- Start Date
- End Date
- Status
- Portfolio Leader
- Circle
- Community
- Vertical Name
- New Business Type
- Rec Region
- Approved Hours
- Submitted Hours
- Actual Hours
- Available Hours
- Billed Hours
- Category
- Billing Type

7. API Cost Calculation
-----------------------
– Cost for this Call: $0.08
