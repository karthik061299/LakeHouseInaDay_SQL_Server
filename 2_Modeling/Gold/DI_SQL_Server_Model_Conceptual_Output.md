------------------------------------------------------------------------
Author: AAVA
Date: 2024-06-08
Description: Conceptual Data Model for UTL Reporting System
------------------------------------------------------------------------

1. Domain Overview
------------------
The reporting system covers Workforce Utilization, Timesheet Management, Project Billing, Resource Allocation, and Holiday/Calendar Management across multiple geographies (India, US, Canada, Mexico, LATAM, NA, Others).

2. Entity List & Descriptions
-----------------------------

2.1. source_layer.New_Monthly_HC_Report
- Description: Contains monthly headcount and workforce details including business area, vertical, client, project, and employment status.

2.2. source_layer.SchTask
- Description: Captures workflow tasks related to resource management, including candidate details, type (Onsite/Offshore), and workflow status.

2.3. source_layer.Hiring_Initiator_Project_Info
- Description: Stores candidate and project information for hiring and onboarding processes, including job details, relocation, and client info.

2.4. source_layer.Timesheet_New
- Description: Records timesheet entries for resources, including hours worked by type (standard, overtime, sick, etc.) and associated dates.

2.5. source_layer.report_392_all
- Description: Aggregates resource, project, and billing information for reporting, including client, project, billing type, category, and status.

2.6. source_layer.vw_billing_timesheet_daywise_ne
- Description: Provides day-wise approved timesheet hours for resources, categorized by billing type.

2.7. source_layer.vw_consultant_timesheet_daywise
- Description: Provides day-wise consultant timesheet hours for resources, categorized by billing type.

2.8. source_layer.DimDate
- Description: Calendar dimension table providing date, day, month, quarter, year, and working day/weekend indicators.

2.9. source_layer.holidays_Mexico
- Description: Contains holiday dates and descriptions for Mexico location.

2.10. source_layer.holidays_Canada
- Description: Contains holiday dates and descriptions for Canada location.

2.11. source_layer.holidays_India
- Description: Contains holiday dates and descriptions for India location.

2.12. source_layer.holidays
- Description: Contains holiday dates and descriptions for US location.


3. Entity Attributes & Descriptions
-----------------------------------

3.1. source_layer.New_Monthly_HC_Report
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
- GP: Gross profit
- Emp Status: Employment status
- Employee Category: Category of employee (FTE/Consultant)
- ITSSProjectName: Project name
- IS Offshore: Indicates offshore status
- Subtier: Subtier company
- New Visa Type: Visa type
- Practice Type: Practice area
- Vertical: Industry vertical
- CL Group: Client group
- Salesrep: Sales representative
- Recruiter: Recruiter name
- PO End: Purchase order end date
- Derived Rev: Derived revenue
- Derived GP: Derived gross profit
- Backlog Rev: Backlog revenue
- Backlog GP: Backlog gross profit
- Expected Hrs: Expected hours per month
- Expected Total Hrs: Total expected hours
- ITSS: ITSS identifier
- Client Entity: Client entity name
- PortfolioLeader: Portfolio lead
- Status: Resource/project status
- Market Leader: Market leader
- ClientPartner: Client partner
- Project Type: Type of project
- Standard Job Title Horizon: Standard job title horizon
- Experience Level Title: Experience level title
- User Name: User name
- asstatus: Additional status
- Bill ST: Billable standard time
- Prev BR: Previous bill rate
- ProjType: Project type
- Rate Time Gr: Rate time group
- Rate Change Type: Rate change type
- Net Addition: Net addition to headcount

3.2. source_layer.SchTask
- SSN: Social Security Number
- GCI_ID: Employee code
- FName: Candidate first name
- LName: Candidate last name
- Process_ID: Workflow process identifier
- Level_ID: Workflow level identifier
- Last_Level: Last workflow level
- Initiator: Workflow initiator
- Initiator_Mail: Initiator email
- Status: Workflow status
- Comments: Workflow comments
- DateCreated: Date created
- TrackID: Tracking identifier
- DateCompleted: Date completed
- Existing_Resource: Indicates if resource is existing
- Term_ID: Termination identifier
- Legal Entity: Legal entity name

3.3. source_layer.Hiring_Initiator_Project_Info
- Candidate_LName: Candidate last name
- Candidate_MI: Candidate middle initial
- Candidate_FName: Candidate first name
- HR_Candidate_JobTitle: Candidate job title
- HR_Candidate_JobDescription: Candidate job description
- HR_Candidate_DOB: Candidate date of birth
- HR_Candidate_Employee_Type: Employee type
- HR_Project_Referred_By: Project referred by
- HR_Project_Referral_Fees: Referral fees
- HR_Project_Referral_Units: Referral units
- HR_Relocation_Request: Relocation request status
- HR_Relocation_departure_city: Departure city
- HR_Relocation_departure_state: Departure state
- HR_Relocation_departure_airport: Departure airport
- HR_Relocation_departure_date: Departure date
- HR_Relocation_departure_time: Departure time
- HR_Relocation_arrival_city: Arrival city
- HR_Relocation_arrival_state: Arrival state
- HR_Relocation_arrival_airport: Arrival airport
- HR_Relocation_arrival_date: Arrival date
- HR_Relocation_arrival_time: Arrival time
- HR_Relocation_AccomodationStartDate: Accommodation start date
- HR_Relocation_AccomodationEndDate: Accommodation end date
- HR_Relocation_CarPickup_Place: Car pickup place
- HR_Relocation_CarPickup_City: Car pickup city
- HR_Relocation_CarReturn_City: Car return city
- HR_Relocation_CarReturn_State: Car return state
- HR_Relocation_RentalCarStartDate: Rental car start date
- HR_Relocation_RentalCarEndDate: Rental car end date
- HR_Relocation_approving_manager: Approving manager
- HR_Recruiting_Manager: Recruiting manager
- HR_Recruiting_AccountExecutive: Account executive
- HR_Recruiting_Recruiter: Recruiter
- HR_Recruiting_ResourceManager: Resource manager
- HR_ClientInfo_ID: Client info ID
- HR_ClientInfo_Name: Client info name
- HR_ClientInfo_Sector: Client sector
- HR_ClientInfo_Manager: Client manager
- HR_ClientInfo_Phone: Client phone
- HR_ClientInfo_Email: Client email
- HR_Project_SendInvoicesTo: Invoice recipient
- HR_Project_AddressToSend1: Project address line 1
- HR_Project_City: Project city
- HR_Project_State: Project state
- HR_Project_Zip: Project zip
- HR_Project_Phone: Project phone
- HR_Project_Email: Project email
- HR_Project_StartDate: Project start date
- HR_Project_EndDate: Project end date
- HR_Project_Location_Country: Project location country
- HR_Business_Type: Business type
- Project_Name: Project name
- Practice_type: Practice area
- Project_billing_type: Project billing type
- Resource_billing_type: Resource billing type
- Type_Consultant_category: Consultant category

3.4. source_layer.Timesheet_New
- pe_date: Period end date
- c_date: Calendar date
- ST: Standard hours
- OT: Overtime hours
- TIME_OFF: Time off hours
- HO: Holiday hours
- DT: Double time hours
- NON_ST: Non-standard hours
- NON_OT: Non-overtime hours
- Sick_Time: Sick time hours
- NON_Sick_Time: Non-sick time hours
- NON_DT: Non-double time hours

3.5. source_layer.report_392_all
- First Name: Resource first name
- Last Name: Resource last name
- Employee Type: Employee type
- Recruiting Manager: Recruiting manager
- Resource Manager: Resource manager
- Salesrep: Sales representative
- Inside Sales: Inside sales person
- Recruiter: Recruiter name
- Req Type: Requirement type
- Client Code: Client code
- Client Name: Client name
- Client Type: Client type
- Job Title: Job title
- Bill ST: Billable standard time
- Visa Type: Visa type
- Bill ST Units: Billable standard time units
- Salary: Salary
- Salary Units: Salary units
- Pay ST: Pay standard time
- Pay ST Units: Pay standard time units
- Start Date: Start date
- End Date: End date
- Project City: Project city
- Project State: Project state
- HR Business Type: HR business type
- Status: Status (Billed/Unbilled/SGA)
- Termination Reason: Termination reason
- HWF_Process_name: Workflow process name
- ITSSProjectName: Project name
- Billing_Type: Billing type (Billable/NBL)
- Category: Project category
- Market Leader: Market leader
- ClientPartner: Client partner
- VerticalName: Industry vertical
- New_business_type: Business type
- PortfolioLeader: Portfolio lead
- Circle: Circle
- Community: Community
- Employee_Category: Employee category

3.6. source_layer.vw_billing_timesheet_daywise_ne
- GCI_ID: Employee code
- PE_DATE: Period end date
- WEEK_DATE: Week date
- BILLABLE: Billable indicator
- Approved_hours(ST): Approved standard hours
- Approved_hours(Non_ST): Approved non-standard hours
- Approved_hours(OT): Approved overtime hours
- Approved_hours(Non_OT): Approved non-overtime hours
- Approved_hours(DT): Approved double time hours
- Approved_hours(Non_DT): Approved non-double time hours
- Approved_hours(Sick_Time): Approved sick time hours
- Approved_hours(Non_Sick_Time): Approved non-sick time hours

3.7. source_layer.vw_consultant_timesheet_daywise
- GCI_ID: Employee code
- PE_DATE: Period end date
- WEEK_DATE: Week date
- BILLABLE: Billable indicator
- Consultant_hours(ST): Consultant standard hours
- Consultant_hours(OT): Consultant overtime hours
- Consultant_hours(DT): Consultant double time hours

3.8. source_layer.DimDate
- Date: Calendar date
- DayOfMonth: Day of month
- DayName: Day name
- WeekOfYear: Week of year
- Month: Month
- MonthName: Month name
- Quarter: Quarter
- Year: Year
- MonthYear: Month and year
- DaysInMonth: Number of days in month
- MM-YYYY: Month and year (formatted)
- YYYYMM: Year and month (formatted)

3.9. source_layer.holidays_Mexico
- Holiday_Date: Holiday date
- Description: Holiday description
- Location: Location name
- Source_type: Source type

3.10. source_layer.holidays_Canada
- Holiday_Date: Holiday date
- Description: Holiday description
- Location: Location name
- Source_type: Source type

3.11. source_layer.holidays_India
- Holiday_Date: Holiday date
- Description: Holiday description
- Location: Location name
- Source_type: Source type

3.12. source_layer.holidays
- Holiday_Date: Holiday date
- Description: Holiday description
- Location: Location name
- Source_type: Source type


4. KPI List
------------
- Total Hours: Number of working days × respective location hours (8 or 9)
- Submitted Hours: Timesheet hours submitted by resource
- Approved Hours: Timesheet hours approved by manager
- Total FTE: Submitted Hours / Total Hours
- Billed FTE: Approved TS hours / Total Hours
- Project Utilization (Proj UTL): Billed Hours / Available Hours
- Available Hours: Monthly Hours × Total FTE
- Actual Hours: Actual hours worked
- Onsite Hours: Actual hours worked onsite
- Offsite Hours: Actual hours worked offshore
- Status: Billed/Unbilled/SGA
- Category: Project/Resource category (India Billing, AVA, Bench, ELT, etc.)


5. Conceptual Data Model Diagram (Tabular Relationship)
-------------------------------------------------------
| Table Name                        | Related Table Name                | Relationship Key Field(s)           |
|-----------------------------------|-----------------------------------|-------------------------------------|
| source_layer.New_Monthly_HC_Report| source_layer.report_392_all       | [gci id], ITSSProjectName           |
| source_layer.report_392_all       | source_layer.Timesheet_New        | [gci id], ITSSProjectName           |
| source_layer.Timesheet_New        | source_layer.vw_billing_timesheet_daywise_ne | gci_id, pe_date           |
| source_layer.Timesheet_New        | source_layer.vw_consultant_timesheet_daywise | gci_id, pe_date           |
| source_layer.Timesheet_New        | source_layer.DimDate              | c_date = Date                       |
| source_layer.DimDate              | source_layer.holidays_Mexico      | Date = Holiday_Date (Mexico)        |
| source_layer.DimDate              | source_layer.holidays_Canada      | Date = Holiday_Date (Canada)        |
| source_layer.DimDate              | source_layer.holidays_India       | Date = Holiday_Date (India)         |
| source_layer.DimDate              | source_layer.holidays             | Date = Holiday_Date (US)            |
| source_layer.SchTask              | source_layer.New_Monthly_HC_Report| GCI_ID = [gci id]                   |
| source_layer.Hiring_Initiator_Project_Info | source_layer.New_Monthly_HC_Report | Candidate_FName = [first name], Candidate_LName = [last name] |


6. Common Data Elements in Report Requirements
----------------------------------------------
- GCI_ID / [gci id]: Employee code (referenced in multiple tables)
- ITSSProjectName: Project name (referenced in multiple tables)
- Client Code: Client code
- First Name / Last Name: Resource name
- Job Title: Resource job title
- Status: Resource/project status
- Category: Project/resource category
- Approved Hours / Submitted Hours: Timesheet metrics
- PortfolioLeader: Portfolio lead
- Market Leader: Market leader
- ClientPartner: Client partner
- VerticalName: Industry vertical
- Practice_type: Practice area
- Billable/Non-Billable: Billing type
- Date / c_date / pe_date: Calendar dates

7. API Cost Calculation
-----------------------
– Cost for this Call: $0.08
