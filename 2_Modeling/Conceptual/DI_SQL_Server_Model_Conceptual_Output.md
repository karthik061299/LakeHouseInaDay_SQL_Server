------------------------------------------------------------------------
Author:        AAVA       
Date:          
Description:   Conceptual Data Model for UTL Reporting Requirements
------------------------------------------------------------------------

1. Domain Overview
The primary business domain covered by the reports is Workforce Utilization and Billing, focusing on resource allocation, timesheet management, project billing, and workforce categorization across multiple geographies (India, US, Canada, LATAM, Mexico).

2. Entity List with Descriptions

2.1. Timesheet
- Description: Captures timesheet entries submitted by resources, including hours worked, overtime, and sick time, mapped to projects and dates.

2.2. Report_392_All
- Description: Contains consolidated resource, project, client, and billing information used for reporting and categorization.

2.3. New_Monthly_HC_Report
- Description: Holds monthly headcount and workforce movement data, including business area, project, and employment status.

2.4. SchTask
- Description: Represents workflow tasks related to resource management, such as onboarding, offboarding, and project assignments.

2.5. DimDate
- Description: Provides calendar and date-related attributes, including working days, weekends, and mapping to holidays.

2.6. Holidays (holidays, holidays_India, holidays_Canada, holidays_Mexico)
- Description: Stores holiday dates for different geographies, used to calculate working days and total available hours.

3. Attributes for Each Entity (excluding IDs)

3.1. Timesheet (Timesheet_New)
- gci_id: Resource code for the employee
- pe_date: Period end date for the timesheet entry
- c_date: Calendar date of the entry
- ST: Standard hours worked
- OT: Overtime hours worked
- TIME_OFF: Time taken off
- HO: Holiday hours
- DT: Double time hours worked
- NON_ST: Non-standard hours
- NON_OT: Non-overtime hours
- Sick_Time: Sick leave hours
- NON_Sick_Time: Non-sick leave hours
- NON_DT: Non-double time hours

3.2. Report_392_All
- first name: Resource's first name
- last name: Resource's last name
- employee type: Type of employment (FTE/Consultant)
- recruiting manager: Name of the recruiting manager
- resource manager: Name of the resource manager
- salesrep: Sales representative assigned
- recruiter: Recruiter assigned
- req type: Type of requirement
- ms_type: Managed services type
- client code: Unique code for the client
- client name: Name of the client
- client_type: Type of client
- job title: Job title of the resource
- bill st: Billable status
- visa type: Visa type of the resource
- bill st units: Billing units
- salary: Salary amount
- salary units: Salary units
- pay st: Pay status
- pay st units: Pay status units
- start date: Resource start date
- end date: Resource end date
- po start date: Purchase order start date
- po end date: Purchase order end date
- project city: City of the project
- project state: State of the project
- no of free hours: Number of free hours
- hr_business_type: HR business classification
- ee_wf_reason: Workforce reason
- singleman company: Singleman company indicator
- status: Resource status (Billed/Unbilled/SGA)
- termination_reason: Reason for termination
- wf created on: Workflow creation date
- hcu: HCU code
- hsu: HSU code
- project zip: Project ZIP code
- cre_person: CRE person
- assigned_hsu: Assigned HSU
- req_category: Requirement category
- gpm: Gross profit margin
- gp: Gross profit
- aca_cost: ACA cost
- aca_classification: ACA classification
- markup: Markup percentage
- actual_markup: Actual markup
- maximum_allowed_markup: Maximum allowed markup
- submitted_bill_rate: Submitted bill rate
- req_division: Requirement division
- pay rate to consultant: Pay rate to consultant
- location: Resource location
- rec_region: Recruitment region
- client_region: Client region
- dm: Delivery manager
- delivery_director: Delivery director
- bu: Business unit
- es: ES code
- nam: NAM code
- client_sector: Client sector
- skills: Skills of the resource
- pskills: Primary skills
- business_manager: Business manager
- vmo: VMO code
- rec_name: Recruitment name
- received: Date received
- Submitted: Date submitted
- responsetime: Response time
- Inhouse: Inhouse indicator
- Net_Bill_Rate: Net billing rate
- Loaded_Pay_Rate: Loaded pay rate
- NSO: NSO code
- ESG_Vertical: ESG vertical
- ESG_Industry: ESG industry
- ESG_DNA: ESG DNA
- ESG_NAM1: ESG NAM1
- ESG_NAM2: ESG NAM2
- ESG_NAM3: ESG NAM3
- ESG_SAM: ESG SAM
- ESG_ES: ESG ES
- ESG_BU: ESG BU
- SUB_GPM: Sub gross profit margin
- Submitted_By: Submitted by
- HWF_Process_name: HWF process name
- Transition: Transition status
- ITSS: ITSS code
- GP2020: GP for 2020
- GPM2020: GPM for 2020
- client_class: Client class
- MSP: MSP code
- DTCUChoice1: DTCU Choice 1
- SubCat: Sub category
- IsClassInitiative: Class initiative indicator
- division: Division
- divstart_date: Division start date
- divend_date: Division end date
- tl: TL code
- resource_manager: Resource manager
- recruiting_manager: Recruiting manager
- VAS_Type: VAS type
- BUCKET: Bucket
- RTR_DM: RTR DM
- ITSSProjectName: ITSS project name
- RegionGroup: Region group
- client_Markup: Client markup
- Subtier: Subtier
- Subtier_Address1: Subtier address 1
- Subtier_Address2: Subtier address 2
- Subtier_City: Subtier city
- Subtier_State: Subtier state
- Hiresource: Hire source
- is_Hotbook_Hire: Hotbook hire indicator
- Client_RM: Client RM
- Job_Description: Job description
- Client_Manager: Client manager
- end_date_at_client: End date at client
- term_date: Termination date
- employee_status: Employee status
- Level_ID: Level ID
- OpsGrp: Operations group
- Level_Name: Level name
- Min_levelDatetime: Minimum level date
- Max_levelDatetime: Maximum level date
- First_Interview_date: First interview date
- Is REC CES?: REC CES indicator
- Is CES Initiative?: CES initiative indicator
- VMO_Access: VMO access
- Billing_Type: Billing type (Billable/NBL)
- VASSOW: VAS SOW indicator
- Worker_Entity_ID: Worker entity ID
- Circle: Circle
- VMO_Access1: VMO access 1
- VMO_Access2: VMO access 2
- VMO_Access3: VMO access 3
- VMO_Access4: VMO access 4
- Inside_Sales_Person: Inside sales person
- admin_1701: Admin 1701
- corrected_staffadmin_1701: Corrected staff admin 1701
- HR_Billing_Placement_Net_Fee: HR billing placement net fee
- New_Visa_type: New visa type
- newenddate: New end date
- Newoffboardingdate: New offboarding date
- NewTermdate: New term date
- newhrisenddate: New HRIS end date
- rtr_location: RTR location
- HR_Recruiting_TL: HR recruiting TL
- client_entity: Client entity
- client_consent: Client consent
- Ascendion_MetalReqID: Ascendion metal requirement ID
- eeo: EEO code
- veteran: Veteran status
- Gender: Gender
- Er_person: ER person
- wfmetaljobdescription: Metal job description
- HR_Candidate_Salary: Candidate salary
- Interview_CreatedDate: Interview created date
- Interview_on_Date: Interview on date
- IS_SOW: SOW indicator
- IS_Offshore: Offshore indicator
- New_VAS: New VAS
- VerticalName: Vertical name
- Client_Group1: Client group 1
- Billig_Type: Billing type
- Super Merged Name: Parent client name
- New_Category: New category
- New_business_type: New business type
- OpportunityID: Opportunity ID
- OpportunityName: Opportunity name
- Ms_ProjectId: MS project ID
- MS_ProjectName: MS project name
- ORC_ID: ORC ID
- Market_Leader: Market leader
- Circle_Metal: Circle metal
- Community_New_Metal: Community new metal
- Employee_Category: Employee category
- IsBillRateSkip: Bill rate skip indicator
- BillRate: Bill rate
- RoleFamily: Role family
- SubRoleFamily: Sub role family
- Standard JobTitle: Standard job title
- ClientInterviewRequired: Client interview required
- Redeploymenthire: Redeployment hire indicator
- HRBrandLevelId: Brand level ID
- HRBandTitle: Band title
- latest_termination_reason: Latest termination reason
- latest_termination_date: Latest termination date
- Community: Community
- ReqFulfillmentReason: Requirement fulfillment reason
- EngagementType: Engagement type
- RedepLedBy: Redeployment led by
- Can_ExperienceLevelTitle: Experience level title
- Can_StandardJobTitleHorizon: Standard job title horizon
- CandidateEmail: Candidate email
- Offboarding_Reason: Offboarding reason
- Offboarding_Initiated: Offboarding initiated date
- Offboarding_Status: Offboarding status
- replcament_GCIID: Replacement GCI ID
- replcament_EmployeeName: Replacement employee name
- Senior Manager: Senior manager
- Associate Manager: Associate manager
- Director - Talent Engine: Director of talent engine
- Manager: Manager
- Rec_ExperienceLevelTitle: Recruitment experience level title
- Rec_StandardJobTitleHorizon: Recruitment standard job title horizon
- Task_Id: Task ID
- proj_ID: Project ID
- Projdesc: Project description
- Client_Group: Client group
- billST_New: New bill ST
- Candidate city: Candidate city
- Candidate State: Candidate state
- C2C_W2_FTE: C2C/W2/FTE indicator
- FP_TM: FP TM

3.3. New_Monthly_HC_Report
- first name: Resource's first name
- last name: Resource's last name
- job title: Job title
- hr_business_type: HR business type
- client code: Client code
- start date: Start date
- termdate: Termination date
- Final_End_date: Final end date
- NBR: Net bill rate
- Merged Name: Merged client name
- Super Merged Name: Parent client name
- market: Market
- defined_New_VAS: New VAS definition
- IS_SOW: SOW indicator
- GP: Gross profit
- NextValue: Next value date
- termination_reason: Termination reason
- FirstDay: First day
- Emp_Status: Employee status
- employee_category: Employee category
- LastDay: Last day
- ee_wf_reason: Workforce reason
- old_Begin: Old begin value
- Begin HC: Begin headcount
- Starts - New Project: New project starts
- Starts- Internal movements: Internal movement starts
- Terms: Terms
- Other project Ends: Other project ends
- OffBoard: Offboard
- End HC: End headcount
- Vol_term: Voluntary termination
- adj: Adjustment
- YYMM: Year and month
- tower1: Tower
- req type: Requirement type
- ITSSProjectName: ITSS project name
- IS_Offshore: Offshore indicator
- Subtier: Subtier
- New_Visa_type: New visa type
- Practice_type: Practice type
- vertical: Vertical
- CL_Group: Client group
- salesrep: Sales representative
- recruiter: Recruiter
- PO_End: Purchase order end date
- PO_End_Count: PO end count
- Derived_Rev: Derived revenue
- Derived_GP: Derived gross profit
- Backlog_Rev: Backlog revenue
- Backlog_GP: Backlog gross profit
- Expected_Hrs: Expected hours
- Expected_Total_Hrs: Expected total hours
- ITSS: ITSS code
- client_entity: Client entity
- newtermdate: New termination date
- Newoffboardingdate: New offboarding date
- HWF_Process_name: HWF process name
- Derived_System_End_date: System end date
- Cons_Ageing: Consultant aging
- CP_Name: CP name
- bill st units: Bill ST units
- project city: Project city
- project state: Project state
- OpportunityID: Opportunity ID
- OpportunityName: Opportunity name
- Bus_days: Business days
- circle: Circle
- community_new: Community new
- ALT: ALT code
- Market_Leader: Market leader
- Acct_Owner: Account owner
- st_yymm: Start year and month
- PortfolioLeader: Portfolio leader
- ClientPartner: Client partner
- FP_Proj_ID: FP project ID
- FP_Proj_Name: FP project name
- FP_TM: FP TM
- project_type: Project type
- FP_Proj_Planned: FP project planned
- Standard Job Title Horizon: Standard job title horizon
- Experience Level Title: Experience level title
- User_Name: User name
- Status: Status
- asstatus: As status
- system_runtime: System runtime
- BR_Start_date: BR start date
- Bill_ST: Bill ST
- Prev_BR: Previous BR
- ProjType: Project type
- Mons_in_Same_Rate: Months in same rate
- Rate_Time_Gr: Rate time group
- Rate_Change_Type: Rate change type
- Net_Addition: Net addition

3.4. SchTask
- SSN: Social security number
- GCI_ID: Employee code
- FName: First name
- LName: Last name
- Process_ID: Workflow process ID
- Level_ID: Workflow level ID
- Last_Level: Last workflow level
- Initiator: Task initiator
- Initiator_Mail: Initiator email
- Status: Task status
- Comments: Comments
- DateCreated: Date created
- TrackID: Tracking ID
- DateCompleted: Date completed
- Existing_Resource: Existing resource indicator
- Term_ID: Termination ID
- legal_entity: Legal entity

3.5. DimDate
- Date: Calendar date
- DayOfMonth: Day of the month
- DayName: Name of the day
- WeekOfYear: Week of the year
- Month: Month number
- MonthName: Name of the month
- MonthOfQuarter: Month of the quarter
- Quarter: Quarter number
- QuarterName: Name of the quarter
- Year: Year
- YearName: Year name
- MonthYear: Month and year
- MMYYYY: Month and year (MMYYYY)
- DaysInMonth: Number of days in the month
- MM-YYYY: Month and year (MM-YYYY)
- YYYYMM: Year and month (YYYYMM)

3.6. Holidays (holidays, holidays_India, holidays_Canada, holidays_Mexico)
- Holiday_Date: Date of the holiday
- Description: Description of the holiday
- Location: Location code
- Source_type: Source type of the holiday

4. Key Performance Indicators (KPIs)
- Total Hours: Number of working days * respective location hours (8 or 9)
- Submitted Hours: Timesheet hours submitted by the resource
- Approved Hours: Timesheet hours approved by the manager
- Total FTE: Submitted Hours / Total Hours
- Billed FTE: Approved Timesheet Hours / Total Hours (or Submitted Hours if Approved is unavailable)
- Project Utilization (Proj UTL): Billed Hours / Available Hours
- Available Hours: Monthly Hours * Total FTE
- Billed Hours: Actual hours billed to client

5. Conceptual Data Model Diagram (Tabular Relationship Overview)
| Table/Entity              | Related Table/Entity         | Relationship Key Field(s)                |
|--------------------------|------------------------------|------------------------------------------|
| Timesheet_New            | SchTask                      | gci_id <-> GCI_ID                       |
| Timesheet_New            | DimDate                      | c_date <-> Date                         |
| Timesheet_New            | report_392_all               | gci_id <-> gci id                       |
| report_392_all           | New_Monthly_HC_Report        | gci id <-> gci id                       |
| report_392_all           | holidays/holidays_India/...  | project location <-> Location            |
| New_Monthly_HC_Report    | DimDate                      | YYMM <-> YYYYMM                         |
| SchTask                  | report_392_all               | GCI_ID <-> gci id                       |
| DimDate                  | holidays/holidays_India/...  | Date <-> Holiday_Date                   |

6. Common Data Elements Referenced Across Multiple Reports
- gci_id / GCI_ID (Resource code)
- client code
- ITSSProjectName
- job title
- start date
- end date / termdate
- Status
- project city
- project state
- recruiter
- salesrep
- PortfolioLeader
- Business area
- IS_SOW
- Super Merged Name
- Expected_Hrs
- Available Hours
- Billed Hours
- Category
- Billing_Type

7. API Cost Calculation
   – Cost for this Call: $0.10
