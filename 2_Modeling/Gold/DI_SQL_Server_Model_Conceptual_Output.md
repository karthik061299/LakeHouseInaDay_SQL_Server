------------------------------------------------------------------------
Author: AAVA
Date: 2024-06-10
Description: Conceptual Data Model for UTL Reporting System
------------------------------------------------------------------------

1. Domain Overview
The reporting system covers workforce utilization, billing, timesheet management, project allocation, holiday management, and resource categorization across multiple geographies (India, US, Canada, LATAM, Mexico).

2. List of Entities with Description

2.1 source_layer.New_Monthly_HC_Report
   - Captures monthly headcount, business area, project, and client details for resources.

2.2 source_layer.SchTask
   - Represents workflow tasks and resource assignments, including candidate and project information.

2.3 source_layer.Hiring_Initiator_Project_Info
   - Contains candidate and project hiring details, including relocation and client information.

2.4 source_layer.Timesheet_New
   - Stores timesheet entries for resources, including hours worked by type and date.

2.5 source_layer.report_392_all
   - Aggregates resource, project, billing, and client details for reporting purposes.

2.6 source_layer.vw_billing_timesheet_daywise_ne
   - Provides day-wise approved timesheet hours for resources, categorized by billing type.

2.7 source_layer.vw_consultant_timesheet_daywise
   - Provides day-wise consultant timesheet hours for resources, categorized by billing type.

2.8 source_layer.DimDate
   - Calendar dimension table for date, working days, weekends, and holidays.

2.9 source_layer.holidays_Mexico
   - Contains holiday dates and descriptions for Mexico location.

2.10 source_layer.holidays_Canada
   - Contains holiday dates and descriptions for Canada location.

2.11 source_layer.holidays_India
   - Contains holiday dates and descriptions for India location.

2.12 source_layer.holidays
   - Contains holiday dates and descriptions for US location.

3. List of Attributes for Each Entity (Business Name & Description)

3.1 source_layer.New_Monthly_HC_Report
   - First Name: Resource first name
   - Last Name: Resource last name
   - Job Title: Resource job title
   - HR Business Type: Type of business engagement (Contract/Direct Hire/Project NBL)
   - Client Code: Unique code for client
   - Start Date: Resource start date
   - Termination Date: Resource termination date
   - Final End Date: Resource final end date
   - Merged Name: Merged client/project name
   - Super Merged Name: Parent client name
   - Market: Market segment
   - IS SOW: Indicates if client is SOW
   - Emp Status: Employment status
   - Employee Category: Resource category
   - ITSS Project Name: Project name
   - IS Offshore: Indicates if resource is offshore
   - Subtier: Subtier company
   - Practice Type: Practice area
   - Vertical: Industry vertical
   - Sales Rep: Sales representative
   - Recruiter: Recruiter name
   - PO End: Purchase order end date
   - Derived Revenue: Derived revenue for resource/project
   - Derived GP: Derived gross profit
   - Expected Hours: Expected working hours per month
   - Expected Total Hours: Total expected hours for the month
   - Status: Resource/project status (Billed, Unbilled, SGA)
   - Portfolio Leader: Portfolio lead for filtering/reporting
   - Business Area: Business area (NA, LATAM, Others, India)
   - SOW: Indicates if client is SOW
   - Vertical Name: Industry name
   - Rec Region: Requirement region name

3.2 source_layer.SchTask
   - Candidate Name: Consultant/FTE name
   - GCI ID: Employee code
   - Type: OnSite/Offshore indicator
   - Tower: Project tower/logic
   - Status: Workflow status
   - Date Created: Task creation date
   - Date Completed: Task completion date

3.3 source_layer.Hiring_Initiator_Project_Info
   - Candidate Last Name: Candidate last name
   - Candidate First Name: Candidate first name
   - Candidate Job Title: Candidate job title
   - Candidate Job Description: Job description
   - Candidate DOB: Date of birth
   - Candidate Employee Type: Employee type
   - Project Name: Project name
   - HR Project Referred By: Referral source
   - HR Project Referral Fees: Referral fees
   - HR Project Referral Units: Referral units
   - HR Relocation Request: Relocation request status
   - HR Relocation Departure City: Departure city for relocation
   - HR Relocation Arrival City: Arrival city for relocation
   - HR Relocation Notes: Relocation notes
   - HR Recruiting Manager: Recruiting manager
   - HR ClientInfo Name: Client name
   - HR ClientInfo Sector: Client sector
   - HR ClientInfo Manager: Client manager
   - HR Project StartDate: Project start date
   - HR Project EndDate: Project end date
   - HR Business Type: Business type
   - Project Type: Project type
   - Payroll Location: Payroll location
   - Delivery Model: Delivery model
   - Benefits Plan: Benefits plan
   - Billing Company: Billing company

3.4 source_layer.Timesheet_New
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

3.5 source_layer.report_392_all
   - First Name: Resource first name
   - Last Name: Resource last name
   - Employee Type: Type of employee (FTE/Consultant)
   - Recruiting Manager: Recruiting manager
   - Resource Manager: Resource manager
   - Sales Rep: Sales representative
   - Recruiter: Recruiter name
   - Req Type: Requirement type
   - Client Code: Unique client code
   - Client Name: Client name
   - Job Title: Resource job title
   - Bill ST: Billable standard time
   - Visa Type: Visa type
   - Salary: Resource salary
   - Start Date: Resource start date
   - End Date: Resource end date
   - Project City: Project city
   - Project State: Project state
   - HR Business Type: Business type
   - Status: Resource/project status
   - Termination Reason: Reason for termination
   - HWF Process Name: Workflow process name
   - ITSS Project Name: Project name
   - Billing Type: Billable/Non-Billable indicator
   - Category: Resource/project category
   - Expected Hours: Expected working hours
   - Available Hours: Available hours for resource
   - Actual Hours: Actual hours worked
   - Onsite Hours: Hours worked onsite
   - Offsite Hours: Hours worked offshore
   - Delivery Leader: Delivery leader name
   - Circle: Circle/region indicator
   - Portfolio Leader: Portfolio lead
   - Vertical Name: Industry name
   - Super Merged Name: Parent client name
   - New Business Type: Contract/Direct Hire/Project NBL
   - Rec Region: Requirement region

3.6 source_layer.vw_billing_timesheet_daywise_ne
   - GCI ID: Resource code
   - PE Date: Period end date
   - Week Date: Week date
   - Billable: Billable indicator
   - Approved Hours (ST): Approved standard hours
   - Approved Hours (Non ST): Approved non-standard hours
   - Approved Hours (OT): Approved overtime hours
   - Approved Hours (Non OT): Approved non-overtime hours
   - Approved Hours (DT): Approved double time hours
   - Approved Hours (Non DT): Approved non-double time hours
   - Approved Hours (Sick Time): Approved sick leave hours
   - Approved Hours (Non Sick Time): Approved non-sick leave hours

3.7 source_layer.vw_consultant_timesheet_daywise
   - GCI ID: Resource code
   - PE Date: Period end date
   - Week Date: Week date
   - Billable: Billable indicator
   - Consultant Hours (ST): Consultant standard hours
   - Consultant Hours (OT): Consultant overtime hours
   - Consultant Hours (DT): Consultant double time hours

3.8 source_layer.DimDate
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
   - MM-YYYY: Month and year
   - YYYYMM: Year and month

3.9 source_layer.holidays_Mexico
   - Holiday Date: Date of holiday
   - Description: Holiday description
   - Location: Location indicator
   - Source Type: Source type of holiday

3.10 source_layer.holidays_Canada
   - Holiday Date: Date of holiday
   - Description: Holiday description
   - Location: Location indicator
   - Source Type: Source type of holiday

3.11 source_layer.holidays_India
   - Holiday Date: Date of holiday
   - Description: Holiday description
   - Location: Location indicator
   - Source Type: Source type of holiday

3.12 source_layer.holidays
   - Holiday Date: Date of holiday
   - Description: Holiday description
   - Location: Location indicator
   - Source Type: Source type of holiday

4. KPI List
   - Total Hours: Number of working days × respective location hours
   - Submitted Hours: Timesheet hours submitted by resource
   - Approved Hours: Timesheet hours approved by manager
   - Total FTE: Submitted Hours / Total Hours
   - Billed FTE: Approved TS hours / Total Hours
   - Project Utilization (Proj UTL): Billed Hours / Available Hours
   - Actual Hours: Actual hours worked
   - Available Hours: Monthly Hours × Total FTE
   - Onsite Hours: Actual hours worked onsite
   - Offsite Hours: Actual hours worked offshore

5. Conceptual Data Model Diagram (Tabular Form)

| Entity Name                       | Related Entity                    | Relationship Key Field(s)         |
|-----------------------------------|-----------------------------------|-----------------------------------|
| source_layer.New_Monthly_HC_Report| source_layer.report_392_all       | [gci id], [ITSSProjectName]       |
| source_layer.New_Monthly_HC_Report| source_layer.Timesheet_New        | [gci id]                          |
| source_layer.New_Monthly_HC_Report| source_layer.SchTask              | [gci id]                          |
| source_layer.New_Monthly_HC_Report| source_layer.DimDate              | [YYMM], [Date]                    |
| source_layer.Timesheet_New        | source_layer.DimDate              | [c_date] = [Date]                 |
| source_layer.Timesheet_New        | source_layer.vw_billing_timesheet_daywise_ne | [gci_id], [pe_date]      |
| source_layer.Timesheet_New        | source_layer.vw_consultant_timesheet_daywise | [gci_id], [pe_date]      |
| source_layer.DimDate              | source_layer.holidays_Mexico      | [Date] = [Holiday_Date]           |
| source_layer.DimDate              | source_layer.holidays_Canada      | [Date] = [Holiday_Date]           |
| source_layer.DimDate              | source_layer.holidays_India       | [Date] = [Holiday_Date]           |
| source_layer.DimDate              | source_layer.holidays             | [Date] = [Holiday_Date]           |
| source_layer.report_392_all       | source_layer.SchTask              | [gci id]                          |
| source_layer.report_392_all       | source_layer.Hiring_Initiator_Project_Info | [gci id]                |

6. Common Data Elements in Report Requirements
   - GCI ID / gci id (Resource code)
   - ITSS Project Name
   - Client Code
   - First Name
   - Last Name
   - Job Title
   - Status
   - Vertical Name
   - Portfolio Leader
   - Approved Hours
   - Submitted Hours
   - Actual Hours
   - Available Hours
   - Category
   - Billing Type
   - Rec Region
   - Super Merged Name
   - Employee Category
   - Practice Type
   - Recruiter
   - Sales Rep
   - Start Date
   - End Date
   - Holiday Date
   - Description (Holiday)

7. API Cost Calculation
   – Cost for this Call: $0.10