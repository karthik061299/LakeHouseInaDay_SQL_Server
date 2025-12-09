------------------------------------------------------------------------
Author: AAVA
Date: 2024-06-10
Description: Conceptual Data Model for UTL Reporting System
------------------------------------------------------------------------

1. Domain Overview
The reporting system focuses on workforce utilization, timesheet management, billing categorization, project allocation, and holiday management across multiple geographies (India, US, Canada, Mexico, LATAM, NA, Others). The primary business domains are Resource Management, Project Billing, Timesheet Tracking, and Holiday/Calendar Management.

2. List of Entity Name with Description

2.1 source_layer.New_Monthly_HC_Report
- Description: Captures monthly headcount and resource allocation details, including business area, SOW status, vertical, client, and project information.

2.2 source_layer.SchTask
- Description: Represents workflow tasks related to resource management, including candidate details, process information, and status.

2.3 source_layer.Hiring_Initiator_Project_Info
- Description: Stores candidate and project information for hiring and onboarding processes.

2.4 source_layer.Timesheet_New
- Description: Contains timesheet entries for resources, including hours worked by type and associated dates.

2.5 source_layer.report_392_all
- Description: Aggregates resource, client, billing, and project information for reporting and categorization.

2.6 source_layer.vw_billing_timesheet_daywise_ne
- Description: Provides day-wise approved timesheet hours for resources, categorized by billing type.

2.7 source_layer.vw_consultant_timesheet_daywise
- Description: Provides day-wise consultant timesheet hours for resources, categorized by billing type.

2.8 source_layer.DimDate
- Description: Calendar dimension table for date-based reporting, including weekends and working days.

2.9 source_layer.holidays_Mexico, source_layer.holidays_Canada, source_layer.holidays_India, source_layer.holidays
- Description: Holiday tables for respective geographies, used to exclude holidays from working day calculations.

3. List of Attributes for Each Entity with Business Description

3.1 source_layer.New_Monthly_HC_Report
- Business area: Region of business operation (e.g., NA, LATAM, India)
- SOW: Indicates if client is Statement of Work or not
- VerticalName: Industry name
- Super Merged Name: Parent client name
- New_business_type: Contract/Direct Hire/Project NBL
- Rec Region: Requirement region name
- ITSSProjectName: Project name
- IS_Offshore: Indicates if resource is offshore
- Practice_type: Practice area of resource
- PortfolioLeader: Portfolio lead for filtering in reports
- Status: Resource status (Billed, Unbilled, SGA, Bench, AVA)
- Expected_Hrs: Expected hours per day (hardcoded as 8)
- Expected_Total_Hrs: Expected total hours for the month
- ClientPartner: Client partner name
- Market_Leader: Market leader name
- Emp_Status: Employee status
- employee_category: Employee category
- Termination_reason: Reason for termination
- Start date: Resource start date
- End date: Resource end date
- Derived_Rev: Derived revenue
- Derived_GP: Derived gross profit

3.2 source_layer.SchTask
- Candidate Name: Consultant/FTE name
- GCI_ID: Employee code
- Type: OnSite/Offshore indicator
- Tower: DTCUChoice1 logic for resource grouping
- Status: Task status
- DateCreated: Task creation date
- DateCompleted: Task completion date

3.3 source_layer.Hiring_Initiator_Project_Info
- Candidate_LName: Candidate last name
- Candidate_FName: Candidate first name
- HR_Candidate_JobTitle: Candidate job title
- HR_Candidate_Employee_Type: Employee type
- HR_Project_Referred_By: Referral source
- HR_Project_Referral_Fees: Referral fees
- HR_Project_StartDate: Project start date
- HR_Project_EndDate: Project end date
- HR_Project_Location_City: Project location city
- HR_Project_Location_State: Project location state
- HR_Project_Location_Country: Project location country
- HR_Business_Type: Business type
- Project_Name: Project name

3.4 source_layer.Timesheet_New
- gci_id: Resource code
- pe_date: Period end date
- c_date: Calendar date
- ST: Standard hours worked
- OT: Overtime hours worked
- DT: Double time hours worked
- TIME_OFF: Time off hours
- HO: Holiday hours
- NON_ST: Non-standard hours
- NON_OT: Non-overtime hours
- Sick_Time: Sick time hours
- NON_Sick_Time: Non-sick time hours
- NON_DT: Non-double time hours

3.5 source_layer.report_392_all
- first name: Resource first name
- last name: Resource last name
- employee type: Employee type (FTE/Consultant)
- client code: Client code
- client name: Client name
- job title: Job title
- bill st: Billable status
- start date: Resource start date
- end date: Resource end date
- ITSSProjectName: Project name
- Billing_Type: Billable/Non-Billable indicator
- Category: Billing category (India Billing, Client-NBL, Project-NBL, Billable, etc.)
- Status: Billed/Unbilled/SGA/Bench/AVA
- Market_Leader: Market leader name
- PortfolioLeader: Portfolio lead name
- Super Merged Name: Parent client name
- New_business_type: Contract/Direct Hire/Project NBL

3.6 source_layer.vw_billing_timesheet_daywise_ne
- GCI_ID: Resource code
- PE_DATE: Period end date
- BILLABLE: Billable indicator
- Approved_hours(ST): Approved standard hours
- Approved_hours(Non_ST): Approved non-standard hours
- Approved_hours(OT): Approved overtime hours
- Approved_hours(Non_OT): Approved non-overtime hours
- Approved_hours(DT): Approved double time hours
- Approved_hours(Non_DT): Approved non-double time hours
- Approved_hours(Sick_Time): Approved sick time hours
- Approved_hours(Non_Sick_Time): Approved non-sick time hours

3.7 source_layer.vw_consultant_timesheet_daywise
- GCI_ID: Resource code
- PE_DATE: Period end date
- BILLABLE: Billable indicator
- Consultant_hours(ST): Consultant standard hours
- Consultant_hours(OT): Consultant overtime hours
- Consultant_hours(DT): Consultant double time hours

3.8 source_layer.DimDate
- DateKey: Unique date key
- Date: Calendar date
- DayOfMonth: Day of the month
- DayName: Name of the day
- WeekOfYear: Week number in year
- Month: Month number
- MonthName: Month name
- Quarter: Quarter number
- Year: Year
- DaysInMonth: Number of days in month
- MMYYYY: Month and year
- YYYYMM: Year and month

3.9 source_layer.holidays_Mexico / holidays_Canada / holidays_India / holidays
- Holiday_Date: Holiday date
- Description: Holiday description
- Location: Location name
- Source_type: Source type of holiday

4. KPI List
- Total Hours: Number of working days × respective location hours (9 for offshore, 8 for onshore)
- Submitted Hours: Timesheet hours submitted by resource
- Approved Hours: Timesheet hours approved by manager
- Total FTE: Submitted Hours / Total Hours
- Billed FTE: Approved TS hours / Total Hours (or Submitted Hours if Approved is unavailable)
- Project Utilization (Proj UTL): Billed Hours / Available Hours
- Total Available Hours: Monthly Expected Hours
- Total Billed Hours / Actual Hours: Actual hours worked
- Onsite Hours: Actual hours for onsite type
- Offsite Hours: Actual hours for offshore type

5. Conceptual Data Model Diagram (Tabular Form)

| Table Name                        | Related Table(s)                | Relationship Key Field(s)         |
|-----------------------------------|----------------------------------|-----------------------------------|
| source_layer.New_Monthly_HC_Report| source_layer.report_392_all      | [gci id], ITSSProjectName         |
| source_layer.report_392_all       | source_layer.Timesheet_New       | [gci id], ITSSProjectName         |
| source_layer.Timesheet_New        | source_layer.vw_billing_timesheet_daywise_ne | gci_id, pe_date           |
| source_layer.Timesheet_New        | source_layer.vw_consultant_timesheet_daywise | gci_id, pe_date           |
| source_layer.Timesheet_New        | source_layer.DimDate             | c_date = Date                     |
| source_layer.DimDate              | source_layer.holidays_Mexico      | Date = Holiday_Date               |
| source_layer.DimDate              | source_layer.holidays_Canada      | Date = Holiday_Date               |
| source_layer.DimDate              | source_layer.holidays_India       | Date = Holiday_Date               |
| source_layer.DimDate              | source_layer.holidays             | Date = Holiday_Date               |
| source_layer.SchTask              | source_layer.New_Monthly_HC_Report| GCI_ID = [gci id]                 |
| source_layer.Hiring_Initiator_Project_Info | source_layer.New_Monthly_HC_Report | Candidate_FName/LastName = [first name]/[last name] |

6. Common Data Elements in Report Requirements
- gci id / GCI_ID: Resource/employee code (referenced in multiple tables)
- ITSSProjectName: Project name (referenced in multiple tables)
- Approved_hours, Consultant_hours: Timesheet hour fields (referenced in timesheet and reporting tables)
- Status: Resource/project status (used in multiple reports)
- Category: Billing category (used in multiple reports)
- PortfolioLeader: Portfolio lead (used for filtering)
- Market_Leader: Market leader (used for reporting)
- Super Merged Name: Parent client name (used in multiple reports)
- New_business_type: Business type (used in multiple reports)
- Date / c_date / pe_date: Date fields (used for joining calendar and holiday tables)

7. API Cost Calculation
– Cost for this Call: $0.06