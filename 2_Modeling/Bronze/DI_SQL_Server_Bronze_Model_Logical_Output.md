====================================================
Author:        AAVA
Date:          
Description:   Comprehensive Logical Data Model for Bronze Layer in Medallion Architecture
====================================================

# BRONZE LAYER LOGICAL DATA MODEL

## 1. PII CLASSIFICATION

### 1.1 Bz_New_Monthly_HC_Report

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| gci id | Employee identifier that can be used to identify an individual employee |
| first name | Direct personal identifier containing employee's first name |
| last name | Direct personal identifier containing employee's last name |
| Merged Name | Full name of employee combining first and last name, direct personal identifier |
| Super Merged Name | Extended full name information that can identify an individual |
| User_Name | Username that can be linked to a specific individual |

### 1.2 Bz_SchTask

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| SSN | Social Security Number - highly sensitive personal identifier protected under GDPR and various privacy laws |
| GCI_ID | Employee identifier that can be used to identify an individual employee |
| FName | Direct personal identifier containing employee's first name |
| LName | Direct personal identifier containing employee's last name |
| Initiator | Name or identifier of the person who initiated the task, can identify an individual |
| Initiator_Mail | Email address - personal contact information protected under privacy regulations |

### 1.3 Bz_Hiring_Initiator_Project_Info

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| Candidate_LName | Direct personal identifier containing candidate's last name |
| Candidate_MI | Middle initial - part of candidate's personal name |
| Candidate_FName | Direct personal identifier containing candidate's first name |
| Candidate_SSN | Social Security Number - highly sensitive personal identifier protected under GDPR and various privacy laws |
| HR_Candidate_DOB | Date of Birth - sensitive personal information that can identify age and individual |
| HR_ClientInfo_Phone | Personal phone number - contact information protected under privacy regulations |
| HR_ClientInfo_Email | Email address - personal contact information protected under privacy regulations |
| HR_ClientInfo_Cell | Mobile phone number - personal contact information |
| HR_ClientInfo_Pager | Pager number - personal contact information |
| HR_ClientInfo_Pager_Pin | Pager PIN - personal access code |
| HR_ClientAgreements_Phone | Personal phone number - contact information |
| HR_ClientAgreements_Email | Email address - personal contact information |
| HR_ClientAgreements_Cell | Mobile phone number - personal contact information |
| HR_ClientAgreements_Pager | Pager number - personal contact information |
| HR_ClientAgreements_Pager_Pin | Pager PIN - personal access code |
| HR_Project_Phone | Personal phone number - contact information |
| HR_Project_Email | Email address - personal contact information |
| HR_Project_Cell | Mobile phone number - personal contact information |
| HR_Project_Pager | Pager number - personal contact information |
| HR_Project_Pager_Pin | Pager PIN - personal access code |
| HR_Accounts_PhoneNo | Personal phone number - contact information |
| HR_Accounts_Email | Email address - personal contact information |
| HR_Accounts_Cell | Mobile phone number - personal contact information |
| HR_Accounts_Pager | Pager number - personal contact information |
| HR_Accounts_Pager_Pin | Pager PIN - personal access code |
| Collabera_Email_ID | Email address - personal contact information |
| Timesheet_Manager_Phone | Personal phone number - contact information |
| Timesheet_Manager_Email | Email address - personal contact information |

### 1.4 Bz_Timesheet_New

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| gci_id | Employee identifier that can be used to identify an individual employee |

### 1.5 Bz_report_392_all

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| gci id | Employee identifier that can be used to identify an individual employee |
| first name | Direct personal identifier containing employee's first name |
| last name | Direct personal identifier containing employee's last name |
| CandidateEmail | Email address - personal contact information protected under privacy regulations |
| Candidate city | Personal address information - location data that can identify residence |
| Candidate State | Personal address information - location data that can identify residence |

### 1.6 Bz_vw_billing_timesheet_daywise_ne

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| GCI_ID | Employee identifier that can be used to identify an individual employee |

### 1.7 Bz_vw_consultant_timesheet_daywise

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| GCI_ID | Employee identifier that can be used to identify an individual employee |

### 1.8 Bz_DimDate

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| No PII fields identified | This is a dimension table containing only date-related information |

### 1.9 Bz_holidays_Mexico

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| No PII fields identified | This table contains only holiday reference data |

### 1.10 Bz_holidays_Canada

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| No PII fields identified | This table contains only holiday reference data |

### 1.11 Bz_holidays

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| No PII fields identified | This table contains only holiday reference data |

### 1.12 Bz_holidays_India

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| No PII fields identified | This table contains only holiday reference data |

---

## 2. BRONZE LAYER LOGICAL MODEL

### 2.1 Bz_New_Monthly_HC_Report

**Table Description:** Bronze layer table capturing monthly headcount report data from source system. This table mirrors the source structure and contains employee assignment, project, financial, and operational metrics for workforce management and reporting.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| id | NUMERIC(18,0) | Unique identifier for each record in the monthly headcount report |
| gci id | VARCHAR(50) | Global Consultant Identifier - unique employee identification number |
| first name | VARCHAR(50) | Employee's first name |
| last name | VARCHAR(50) | Employee's last name |
| job title | VARCHAR(50) | Current job title or role of the employee |
| hr_business_type | VARCHAR(50) | Business type classification for HR purposes (e.g., consulting, permanent) |
| client code | VARCHAR(50) | Unique code identifying the client organization |
| start date | DATETIME | Employee's project or assignment start date |
| termdate | DATETIME | Employee's termination date if applicable |
| Final_End_date | DATETIME | Final calculated end date for the employee assignment |
| NBR | MONEY | Net Bill Rate - the rate charged to client for employee services |
| Merged Name | VARCHAR(100) | Combined full name of the employee |
| Super Merged Name | VARCHAR(100) | Extended merged name with additional identifiers |
| market | VARCHAR(50) | Geographic market or region where employee is assigned |
| defined_New_VAS | VARCHAR(8) | Value Added Services classification indicator |
| IS_SOW | VARCHAR(7) | Indicator whether the engagement is Statement of Work based |
| GP | MONEY | Gross Profit amount for the employee assignment |
| NextValue | DATETIME | Next calculated date value for forecasting purposes |
| termination_reason | VARCHAR(100) | Reason code or description for employee termination |
| FirstDay | DATETIME | First working day of the employee in the reporting period |
| Emp_Status | VARCHAR(25) | Current employment status (Active, Terminated, On Leave, etc.) |
| employee_category | VARCHAR(50) | Category classification of employee (Consultant, FTE, Contractor) |
| LastDay | DATETIME | Last working day of the employee in the reporting period |
| ee_wf_reason | VARCHAR(50) | Employee workflow reason code |
| old_Begin | NUMERIC(2,1) | Previous beginning headcount value |
| Begin HC | NUMERIC(38,36) | Beginning headcount for the reporting period |
| Starts - New Project | NUMERIC(38,36) | Count of employees starting new projects |
| Starts- Internal movements | NUMERIC(38,36) | Count of employees with internal movements or transfers |
| Terms | NUMERIC(38,36) | Count of terminations in the period |
| Other project Ends | NUMERIC(38,36) | Count of other project endings |
| OffBoard | NUMERIC(38,36) | Count of employees offboarded |
| End HC | NUMERIC(38,36) | Ending headcount for the reporting period |
| Vol_term | NUMERIC(38,36) | Voluntary termination count |
| adj | NUMERIC(38,36) | Adjustment value for headcount reconciliation |
| YYMM | INT | Year and month in YYMM format |
| tower1 | VARCHAR(60) | Primary service tower or practice area |
| req type | VARCHAR(50) | Requisition type for the position |
| ITSSProjectName | VARCHAR(200) | IT Service Solutions project name |
| IS_Offshore | VARCHAR(20) | Indicator whether the position is offshore |
| Subtier | VARCHAR(50) | Sub-tier client classification |
| New_Visa_type | VARCHAR(50) | Visa type for the employee if applicable |
| Practice_type | VARCHAR(50) | Type of practice or service line |
| vertical | VARCHAR(50) | Industry vertical classification |
| CL_Group | VARCHAR(32) | Client group classification |
| salesrep | VARCHAR(50) | Sales representative assigned to the account |
| recruiter | VARCHAR(50) | Recruiter who placed the employee |
| PO_End | DATETIME | Purchase Order end date |
| PO_End_Count | NUMERIC(38,36) | Count of purchase orders ending |
| Derived_Rev | REAL | Derived revenue calculation |
| Derived_GP | REAL | Derived gross profit calculation |
| Backlog_Rev | REAL | Backlog revenue amount |
| Backlog_GP | REAL | Backlog gross profit amount |
| Expected_Hrs | REAL | Expected hours for the period |
| Expected_Total_Hrs | REAL | Expected total hours including all categories |
| ITSS | VARCHAR(100) | IT Service Solutions indicator or classification |
| client_entity | VARCHAR(50) | Legal entity of the client |
| newtermdate | DATETIME | Newly calculated termination date |
| Newoffboardingdate | DATETIME | Newly calculated offboarding date |
| HWF_Process_name | VARCHAR(100) | Human Workforce process name |
| Derived_System_End_date | DATETIME | System-derived end date |
| Cons_Ageing | INT | Consultant aging in days |
| CP_Name | NVARCHAR(50) | Client Partner name |
| bill st units | VARCHAR(50) | Billing straight time units (hourly, daily, etc.) |
| project city | VARCHAR(50) | City where the project is located |
| project state | VARCHAR(50) | State where the project is located |
| OpportunityID | VARCHAR(50) | Sales opportunity identifier |
| OpportunityName | VARCHAR(200) | Sales opportunity name |
| Bus_days | REAL | Business days calculation |
| circle | VARCHAR(100) | Circle or organizational grouping |
| community_new | VARCHAR(100) | Community classification |
| ALT | NVARCHAR(50) | Account Leadership Team member |
| Market_Leader | VARCHAR(MAX) | Market leader name |
| Acct_Owner | NVARCHAR(50) | Account owner name |
| st_yymm | INT | Start year-month in YYMM format |
| PortfolioLeader | VARCHAR(MAX) | Portfolio leader name |
| ClientPartner | VARCHAR(MAX) | Client partner name |
| FP_Proj_ID | VARCHAR(10) | Financial Planning project identifier |
| FP_Proj_Name | VARCHAR(MAX) | Financial Planning project name |
| FP_TM | VARCHAR(2) | Financial Planning time marker |
| project_type | VARCHAR(500) | Type of project classification |
| FP_Proj_Planned | VARCHAR(10) | Financial Planning project planned indicator |
| Standard Job Title Horizon | NVARCHAR(2000) | Standardized job title from Horizon system |
| Experience Level Title | VARCHAR(200) | Experience level classification title |
| User_Name | VARCHAR(50) | Username of the person who created or modified the record |
| Status | VARCHAR(50) | Current status of the record |
| asstatus | VARCHAR(50) | Assignment status |
| system_runtime | DATETIME | System runtime timestamp |
| BR_Start_date | DATETIME | Bill rate start date |
| Bill_ST | FLOAT | Billing straight time rate |
| Prev_BR | FLOAT | Previous bill rate |
| ProjType | VARCHAR(2) | Project type code |
| Mons_in_Same_Rate | INT | Number of months in the same rate |
| Rate_Time_Gr | VARCHAR(20) | Rate time group classification |
| Rate_Change_Type | VARCHAR(20) | Type of rate change |
| Net_Addition | NUMERIC(38,36) | Net addition to headcount |
| load_timestamp | DATETIME | Timestamp when the record was loaded into Bronze layer |
| update_timestamp | DATETIME | Timestamp when the record was last updated |
| source_system | VARCHAR(100) | Source system name from which data originated |

---

### 2.2 Bz_SchTask

**Table Description:** Bronze layer table capturing scheduled task and workflow information from source system. This table contains employee workflow processes, task assignments, and status tracking for HR and operational processes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| SSN | VARCHAR(50) | Social Security Number of the employee |
| GCI_ID | VARCHAR(50) | Global Consultant Identifier - unique employee identification number |
| FName | VARCHAR(50) | Employee's first name |
| LName | VARCHAR(50) | Employee's last name |
| Process_ID | NUMERIC(18,0) | Identifier for the workflow process |
| Level_ID | INT | Current level or stage in the workflow process |
| Last_Level | INT | Last completed level in the workflow |
| Initiator | VARCHAR(50) | Name or identifier of the person who initiated the task |
| Initiator_Mail | VARCHAR(50) | Email address of the task initiator |
| Status | VARCHAR(50) | Current status of the task (Pending, In Progress, Completed, etc.) |
| Comments | VARCHAR(8000) | Comments or notes related to the task |
| DateCreated | DATETIME | Date and time when the task was created |
| TrackID | VARCHAR(50) | Tracking identifier for the task |
| DateCompleted | DATETIME | Date and time when the task was completed |
| Existing_Resource | VARCHAR(3) | Indicator whether this is for an existing resource |
| Term_ID | NUMERIC(18,0) | Termination identifier if applicable |
| legal_entity | VARCHAR(50) | Legal entity associated with the task |
| TS | TIMESTAMP | Timestamp for record versioning |
| load_timestamp | DATETIME | Timestamp when the record was loaded into Bronze layer |
| update_timestamp | DATETIME | Timestamp when the record was last updated |
| source_system | VARCHAR(100) | Source system name from which data originated |

---

### 2.3 Bz_Hiring_Initiator_Project_Info

**Table Description:** Bronze layer table capturing comprehensive hiring, candidate, project, and client information from source system. This table contains detailed information about candidates, projects, client agreements, billing rates, and relocation details for the hiring process.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Candidate_LName | VARCHAR(50) | Candidate's last name |
| Candidate_MI | VARCHAR(50) | Candidate's middle initial |
| Candidate_FName | VARCHAR(50) | Candidate's first name |
| Candidate_SSN | VARCHAR(50) | Candidate's Social Security Number |
| HR_Candidate_JobTitle | VARCHAR(50) | Job title for the candidate position |
| HR_Candidate_JobDescription | VARCHAR(100) | Job description for the candidate position |
| HR_Candidate_DOB | VARCHAR(50) | Candidate's date of birth |
| HR_Candidate_Employee_Type | VARCHAR(50) | Type of employment (Contractor, FTE, etc.) |
| HR_Project_Referred_By | VARCHAR(50) | Name of person who referred the candidate |
| HR_Project_Referral_Fees | VARCHAR(50) | Referral fees amount |
| HR_Project_Referral_Units | VARCHAR(50) | Units for referral fees (percentage, flat amount) |
| HR_Relocation_Request | VARCHAR(50) | Indicator whether relocation is requested |
| HR_Relocation_departure_city | VARCHAR(50) | Departure city for relocation |
| HR_Relocation_departure_state | VARCHAR(50) | Departure state for relocation |
| HR_Relocation_departure_airport | VARCHAR(50) | Departure airport code |
| HR_Relocation_departure_date | VARCHAR(50) | Departure date for relocation |
| HR_Relocation_departure_time | VARCHAR(50) | Departure time for relocation |
| HR_Relocation_arrival_city | VARCHAR(50) | Arrival city for relocation |
| HR_Relocation_arrival_state | VARCHAR(50) | Arrival state for relocation |
| HR_Relocation_arrival_airport | VARCHAR(50) | Arrival airport code |
| HR_Relocation_arrival_date | VARCHAR(50) | Arrival date for relocation |
| HR_Relocation_arrival_time | VARCHAR(50) | Arrival time for relocation |
| HR_Relocation_AccomodationStartDate | VARCHAR(50) | Accommodation start date |
| HR_Relocation_AccomodationEndDate | VARCHAR(50) | Accommodation end date |
| HR_Relocation_AccomodationStartTime | VARCHAR(50) | Accommodation start time |
| HR_Relocation_AccomodationEndTime | VARCHAR(50) | Accommodation end time |
| HR_Relocation_CarPickup_Place | VARCHAR(50) | Car pickup location name |
| HR_Relocation_CarPickup_AddressLine1 | VARCHAR(50) | Car pickup address line 1 |
| HR_Relocation_CarPickup_AddressLine2 | VARCHAR(50) | Car pickup address line 2 |
| HR_Relocation_CarPickup_City | VARCHAR(50) | Car pickup city |
| HR_Relocation_CarPickup_State | VARCHAR(50) | Car pickup state |
| HR_Relocation_CarPickup_Zip | VARCHAR(50) | Car pickup zip code |
| HR_Relocation_CarReturn_City | VARCHAR(50) | Car return city |
| HR_Relocation_CarReturn_State | VARCHAR(50) | Car return state |
| HR_Relocation_CarReturn_Place | VARCHAR(50) | Car return location name |
| HR_Relocation_CarReturn_AddressLine1 | VARCHAR(50) | Car return address line 1 |
| HR_Relocation_CarReturn_AddressLine2 | VARCHAR(50) | Car return address line 2 |
| HR_Relocation_CarReturn_Zip | VARCHAR(50) | Car return zip code |
| HR_Relocation_RentalCarStartDate | VARCHAR(50) | Rental car start date |
| HR_Relocation_RentalCarEndDate | VARCHAR(50) | Rental car end date |
| HR_Relocation_RentalCarStartTime | VARCHAR(50) | Rental car start time |
| HR_Relocation_RentalCarEndTime | VARCHAR(50) | Rental car end time |
| HR_Relocation_MaxClientInvoice | VARCHAR(50) | Maximum client invoice amount for relocation |
| HR_Relocation_approving_manager | VARCHAR(50) | Manager approving the relocation |
| HR_Relocation_Notes | VARCHAR(5000) | Additional notes for relocation |
| HR_Recruiting_Manager | VARCHAR(50) | Recruiting manager name |
| HR_Recruiting_AccountExecutive | VARCHAR(50) | Account executive name |
| HR_Recruiting_Recruiter | VARCHAR(50) | Recruiter name |
| HR_Recruiting_ResourceManager | VARCHAR(50) | Resource manager name |
| HR_Recruiting_Office | VARCHAR(50) | Recruiting office location |
| HR_Recruiting_ReqNo | VARCHAR(100) | Requisition number |
| HR_Recruiting_Direct | VARCHAR(50) | Direct hire indicator |
| HR_Recruiting_Replacement_For_GCIID | VARCHAR(50) | GCI ID of person being replaced |
| HR_Recruiting_Replacement_For | VARCHAR(50) | Name of person being replaced |
| HR_Recruiting_Replacement_Reason | VARCHAR(50) | Reason for replacement |
| HR_ClientInfo_ID | VARCHAR(50) | Client information identifier |
| HR_ClientInfo_Name | VARCHAR(60) | Client name |
| HR_ClientInfo_DNB | VARCHAR(50) | Dun & Bradstreet number |
| HR_ClientInfo_Sector | VARCHAR(50) | Client industry sector |
| HR_ClientInfo_Manager_ID | VARCHAR(50) | Client manager identifier |
| HR_ClientInfo_Manager | VARCHAR(50) | Client manager name |
| HR_ClientInfo_Phone | VARCHAR(50) | Client phone number |
| HR_ClientInfo_Phone_Extn | VARCHAR(50) | Client phone extension |
| HR_ClientInfo_Email | VARCHAR(50) | Client email address |
| HR_ClientInfo_Fax | VARCHAR(50) | Client fax number |
| HR_ClientInfo_Cell | VARCHAR(50) | Client cell phone number |
| HR_ClientInfo_Pager | VARCHAR(50) | Client pager number |
| HR_ClientInfo_Pager_Pin | VARCHAR(50) | Client pager PIN |
| HR_ClientAgreements_SendTo | VARCHAR(50) | Name of person to send agreements to |
| HR_ClientAgreements_Phone | VARCHAR(50) | Phone number for agreements contact |
| HR_ClientAgreements_Phone_Extn | VARCHAR(50) | Phone extension for agreements contact |
| HR_ClientAgreements_Email | VARCHAR(50) | Email for agreements contact |
| HR_ClientAgreements_Fax | VARCHAR(50) | Fax number for agreements contact |
| HR_ClientAgreements_Cell | VARCHAR(50) | Cell phone for agreements contact |
| HR_ClientAgreements_Pager | VARCHAR(50) | Pager number for agreements contact |
| HR_ClientAgreements_Pager_Pin | VARCHAR(50) | Pager PIN for agreements contact |
| HR_Project_SendInvoicesTo | VARCHAR(100) | Name of person or department to send invoices to |
| HR_Project_AddressToSend1 | VARCHAR(150) | Invoice address line 1 |
| HR_Project_AddressToSend2 | VARCHAR(150) | Invoice address line 2 |
| HR_Project_City | VARCHAR(50) | Invoice city |
| HR_Project_State | VARCHAR(50) | Invoice state |
| HR_Project_Zip | VARCHAR(50) | Invoice zip code |
| HR_Project_Phone | VARCHAR(50) | Project contact phone number |
| HR_Project_Phone_Extn | VARCHAR(50) | Project contact phone extension |
| HR_Project_Email | VARCHAR(50) | Project contact email |
| HR_Project_Fax | VARCHAR(50) | Project contact fax number |
| HR_Project_Cell | VARCHAR(50) | Project contact cell phone |
| HR_Project_Pager | VARCHAR(50) | Project contact pager number |
| HR_Project_Pager_Pin | VARCHAR(50) | Project contact pager PIN |
| HR_Project_ST | VARCHAR(50) | Project straight time rate |
| HR_Project_OT | VARCHAR(50) | Project overtime rate |
| HR_Project_ST_Off | VARCHAR(50) | Project straight time offshore rate |
| HR_Project_OT_Off | VARCHAR(50) | Project overtime offshore rate |
| HR_Project_ST_Units | VARCHAR(50) | Units for straight time rate |
| HR_Project_OT_Units | VARCHAR(50) | Units for overtime rate |
| HR_Project_ST_Off_Units | VARCHAR(50) | Units for straight time offshore rate |
| HR_Project_OT_Off_Units | VARCHAR(50) | Units for overtime offshore rate |
| HR_Project_StartDate | VARCHAR(50) | Project start date |
| HR_Project_EndDate | VARCHAR(50) | Project end date |
| HR_Project_Location_AddressLine1 | VARCHAR(50) | Project location address line 1 |
| HR_Project_Location_AddressLine2 | VARCHAR(50) | Project location address line 2 |
| HR_Project_Location_City | VARCHAR(50) | Project location city |
| HR_Project_Location_State | VARCHAR(50) | Project location state |
| HR_Project_Location_Zip | VARCHAR(50) | Project location zip code |
| HR_Project_InvoicingTerms | VARCHAR(50) | Invoicing terms for the project |
| HR_Project_PaymentTerms | VARCHAR(50) | Payment terms for the project |
| HR_Project_EndClient_ID | VARCHAR(50) | End client identifier |
| HR_Project_EndClient_Name | VARCHAR(60) | End client name |
| HR_Project_EndClient_Sector | VARCHAR(50) | End client industry sector |
| HR_Accounts_Person | VARCHAR(50) | Accounts payable/receivable contact person |
| HR_Accounts_PhoneNo | VARCHAR(50) | Accounts contact phone number |
| HR_Accounts_PhoneNo_Extn | VARCHAR(50) | Accounts contact phone extension |
| HR_Accounts_Email | VARCHAR(50) | Accounts contact email |
| HR_Accounts_FaxNo | VARCHAR(50) | Accounts contact fax number |
| HR_Accounts_Cell | VARCHAR(50) | Accounts contact cell phone |
| HR_Accounts_Pager | VARCHAR(50) | Accounts contact pager number |
| HR_Accounts_Pager_Pin | VARCHAR(50) | Accounts contact pager PIN |
| HR_Project_Referrer_ID | VARCHAR(50) | Project referrer identifier |
| UserCreated | VARCHAR(50) | User who created the record |
| DateCreated | VARCHAR(50) | Date when the record was created |
| HR_Week_Cycle | INT | Week cycle for payroll or billing |
| Project_Name | VARCHAR(255) | Name of the project |
| transition | VARCHAR(50) | Transition indicator or status |
| Is_OT_Allowed | VARCHAR(50) | Indicator whether overtime is allowed |
| HR_Business_Type | VARCHAR(50) | Business type classification |
| WebXl_EndClient_ID | VARCHAR(50) | WebXL end client identifier |
| WebXl_EndClient_Name | VARCHAR(60) | WebXL end client name |
| Client_Offer_Acceptance_Date | VARCHAR(50) | Date when client offer was accepted |
| Project_Type | VARCHAR(50) | Type of project |
| req_division | VARCHAR(200) | Requisition division |
| Client_Compliance_Checks_Reqd | VARCHAR(50) | Indicator whether client compliance checks are required |
| HSU | VARCHAR(50) | Horizontal Service Unit |
| HSUDM | VARCHAR(50) | Horizontal Service Unit Delivery Manager |
| Payroll_Location | VARCHAR(50) | Payroll processing location |
| Is_DT_Allowed | VARCHAR(50) | Indicator whether double time is allowed |
| SBU | VARCHAR(2) | Strategic Business Unit |
| BU | VARCHAR(50) | Business Unit |
| Dept | VARCHAR(2) | Department code |
| HCU | VARCHAR(50) | Horizontal Capability Unit |
| Project_Category | VARCHAR(50) | Category of the project |
| Delivery_Model | VARCHAR(50) | Delivery model (Onsite, Offshore, Hybrid) |
| BPOS_Project | VARCHAR(3) | Business Process Outsourcing Services project indicator |
| ER_Person | VARCHAR(50) | Employee Relations person |
| Print_Invoice_Address1 | VARCHAR(100) | Print invoice address line 1 |
| Print_Invoice_Address2 | VARCHAR(100) | Print invoice address line 2 |
| Print_Invoice_City | VARCHAR(50) | Print invoice city |
| Print_Invoice_State | VARCHAR(50) | Print invoice state |
| Print_Invoice_Zip | VARCHAR(50) | Print invoice zip code |
| Mail_Invoice_Address1 | VARCHAR(100) | Mail invoice address line 1 |
| Mail_Invoice_Address2 | VARCHAR(100) | Mail invoice address line 2 |
| Mail_Invoice_City | VARCHAR(50) | Mail invoice city |
| Mail_Invoice_State | VARCHAR(50) | Mail invoice state |
| Mail_Invoice_Zip | VARCHAR(50) | Mail invoice zip code |
| Project_Zone | VARCHAR(50) | Geographic zone of the project |
| Emp_Identifier | VARCHAR(50) | Employee identifier |
| CRE_Person | VARCHAR(50) | Client Relationship Executive person |
| HR_Project_Location_Country | VARCHAR(50) | Project location country |
| Agency | VARCHAR(50) | Agency name if applicable |
| pwd | VARCHAR(50) | Person with disability indicator |
| PES_Doc_Sent | VARCHAR(50) | Pre-Employment Screening document sent indicator |
| PES_Confirm_Doc_Rcpt | VARCHAR(50) | Pre-Employment Screening document receipt confirmation |
| PES_Clearance_Rcvd | VARCHAR(50) | Pre-Employment Screening clearance received indicator |
| PES_Doc_Sent_Date | VARCHAR(50) | Date PES documents were sent |
| PES_Confirm_Doc_Rcpt_Date | VARCHAR(50) | Date PES document receipt was confirmed |
| PES_Clearance_Rcvd_Date | VARCHAR(50) | Date PES clearance was received |
| Inv_Pay_Terms_Notes | TEXT | Invoice and payment terms notes |
| CBC_Notes | TEXT | Client Background Check notes |
| Benefits_Plan | VARCHAR(50) | Benefits plan type |
| BillingCompany | VARCHAR(50) | Billing company name |
| SPINOFF_CPNY | VARCHAR(50) | Spin-off company indicator |
| Position_Type | VARCHAR(50) | Type of position |
| I9_Approver | VARCHAR(50) | I-9 form approver name |
| FP_BILL_Rate | VARCHAR(50) | Fixed price bill rate |
| TSLead | VARCHAR(50) | Technical Services Lead |
| Inside_Sales | VARCHAR(50) | Inside sales representative |
| Markup | VARCHAR(50) | Markup percentage or amount |
| Maximum_Allowed_Markup | VARCHAR(50) | Maximum allowed markup |
| Actual_Markup | VARCHAR(50) | Actual markup applied |
| SCA_Hourly_Bill_Rate | VARCHAR(50) | Service Contract Act hourly bill rate |
| HR_Project_StartDate_Change_Reason | VARCHAR(100) | Reason for project start date change |
| source | VARCHAR(50) | Source of the record |
| HR_Recruiting_VMO | VARCHAR(50) | Vendor Management Office recruiter |
| HR_Recruiting_Inside_Sales | VARCHAR(50) | Inside sales person for recruiting |
| HR_Recruiting_TL | VARCHAR(50) | Team Lead for recruiting |
| HR_Recruiting_NAM | VARCHAR(50) | National Account Manager for recruiting |
| HR_Recruiting_ARM | VARCHAR(50) | Account Relationship Manager for recruiting |
| HR_Recruiting_RM | VARCHAR(50) | Relationship Manager for recruiting |
| HR_Recruiting_ReqID | VARCHAR(50) | Recruiting requisition identifier |
| HR_Recruiting_TAG | VARCHAR(50) | Recruiting tag or classification |
| DateUpdated | VARCHAR(50) | Date when the record was last updated |
| UserUpdated | VARCHAR(50) | User who last updated the record |
| Is_Swing_Shift_Associated_With_It | VARCHAR(50) | Indicator whether swing shift is associated |
| FP_Bill_Rate_OT | VARCHAR(50) | Fixed price bill rate for overtime |
| Not_To_Exceed_YESNO | VARCHAR(10) | Not to exceed indicator |
| Exceed_YESNO | VARCHAR(10) | Exceed indicator |
| Is_OT_Billable | VARCHAR(5) | Indicator whether overtime is billable |
| Is_premium_project_Associated_With_It | VARCHAR(50) | Indicator whether premium project is associated |
| ITSS_Business_Development_Manager | VARCHAR(50) | IT Service Solutions Business Development Manager |
| Practice_type | VARCHAR(50) | Practice type classification |
| Project_billing_type | VARCHAR(50) | Project billing type |
| Resource_billing_type | VARCHAR(50) | Resource billing type |
| Type_Consultant_category | VARCHAR(50) | Consultant category type |
| Unique_identification_ID_Doc | VARCHAR(100) | Unique identification document type |
| Region1 | VARCHAR(100) | Primary region |
| Region2 | VARCHAR(100) | Secondary region |
| Region1_percentage | VARCHAR(10) | Percentage allocation to region 1 |
| Region2_percentage | VARCHAR(10) | Percentage allocation to region 2 |
| Soc_Code | VARCHAR(300) | Standard Occupational Classification code |
| Soc_Desc | VARCHAR(300) | Standard Occupational Classification description |
| req_duration | INT | Requisition duration in days or months |
| Non_Billing_Type | VARCHAR(50) | Non-billing type classification |
| Worker_Entity_ID | VARCHAR(30) | Worker entity identifier |
| OraclePersonID | VARCHAR(30) | Oracle person identifier |
| Collabera_Email_ID | VARCHAR(100) | Collabera email identifier |
| Onsite_Consultant_Relationship_Manager | VARCHAR(50) | Onsite consultant relationship manager |
| HR_project_county | VARCHAR(100) | Project county location |
| EE_WF_Reasons | VARCHAR(50) | Employee workflow reasons |
| GradeName | VARCHAR(50) | Grade name or level |
| ROLEFAMILY | VARCHAR(50) | Role family classification |
| SUBDEPARTMENT | VARCHAR(100) | Sub-department name |
| MSProjectType | VARCHAR(50) | Microsoft Project type |
| NetsuiteProjectId | VARCHAR(50) | NetSuite project identifier |
| NetsuiteCreatedDate | VARCHAR(50) | NetSuite record creation date |
| NetsuiteModifiedDate | VARCHAR(50) | NetSuite record modification date |
| StandardJobTitle | VARCHAR(100) | Standardized job title |
| community | VARCHAR(100) | Community classification |
| parent_Account_name | VARCHAR(100) | Parent account name |
| Timesheet_Manager | VARCHAR(255) | Timesheet manager name |
| TimeSheetManagerType | VARCHAR(255) | Timesheet manager type |
| Timesheet_Manager_Phone | VARCHAR(255) | Timesheet manager phone number |
| Timesheet_Manager_Email | VARCHAR(255) | Timesheet manager email address |
| HR_Project_Major_Group | VARCHAR(255) | Project major group classification |
| HR_Project_Minor_Group | VARCHAR(255) | Project minor group classification |
| HR_Project_Broad_Group | VARCHAR(255) | Project broad group classification |
| HR_Project_Detail_Group | VARCHAR(255) | Project detail group classification |
| 9Hours_Allowed | VARCHAR(3) | Indicator whether 9 hours per day is allowed |
| 9Hours_Effective_Date | VARCHAR(50) | Effective date for 9 hours allowance |
| load_timestamp | DATETIME | Timestamp when the record was loaded into Bronze layer |
| update_timestamp | DATETIME | Timestamp when the record was last updated |
| source_system | VARCHAR(100) | Source system name from which data originated |

---

### 2.4 Bz_Timesheet_New

**Table Description:** Bronze layer table capturing daily timesheet entries from source system. This table contains employee time tracking information including regular hours, overtime, time off, and various other time categories for payroll and billing purposes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| gci_id | INT | Global Consultant Identifier - unique employee identification number |
| pe_date | DATETIME | Period ending date for the timesheet entry |
| task_id | NUMERIC(18,9) | Task or project identifier for time allocation |
| c_date | DATETIME | Creation date of the timesheet entry |
| ST | FLOAT | Straight Time hours worked |
| OT | FLOAT | Overtime hours worked |
| TIME_OFF | FLOAT | Time off hours (vacation, personal time) |
| HO | FLOAT | Holiday hours |
| DT | FLOAT | Double Time hours worked |
| NON_ST | FLOAT | Non-billable straight time hours |
| NON_OT | FLOAT | Non-billable overtime hours |
| Sick_Time | FLOAT | Sick time hours |
| NON_Sick_Time | FLOAT | Non-billable sick time hours |
| NON_DT | FLOAT | Non-billable double time hours |
| load_timestamp | DATETIME | Timestamp when the record was loaded into Bronze layer |
| update_timestamp | DATETIME | Timestamp when the record was last updated |
| source_system | VARCHAR(100) | Source system name from which data originated |

---

### 2.5 Bz_report_392_all

**Table Description:** Bronze layer table capturing comprehensive employee and project reporting data from source system. This table contains detailed information about employees, assignments, clients, financial metrics, recruiting details, and operational data for enterprise-wide reporting and analytics.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| id | NUMERIC(18,9) | Unique identifier for each record in the report |
| gci id | VARCHAR(50) | Global Consultant Identifier - unique employee identification number |
| first name | VARCHAR(50) | Employee's first name |
| last name | VARCHAR(50) | Employee's last name |
| employee type | VARCHAR(8000) | Type of employment (Contractor, FTE, Consultant, etc.) |
| recruiting manager | VARCHAR(50) | Recruiting manager name |
| resource manager | VARCHAR(50) | Resource manager name |
| salesrep | VARCHAR(50) | Sales representative assigned to the account |
| inside_sales | VARCHAR(50) | Inside sales representative |
| recruiter | VARCHAR(50) | Recruiter who placed the employee |
| req type | VARCHAR(50) | Requisition type |
| ms_type | VARCHAR(28) | Microsoft type classification |
| client code | VARCHAR(50) | Unique code identifying the client organization |
| client name | VARCHAR(60) | Client organization name |
| client_type | VARCHAR(50) | Type of client classification |
| job title | VARCHAR(50) | Current job title or role of the employee |
| bill st | VARCHAR(50) | Bill straight time rate |
| visa type | VARCHAR(50) | Visa type for the employee if applicable |
| bill st units | VARCHAR(50) | Billing straight time units (hourly, daily, etc.) |
| salary | MONEY | Salary amount |
| salary units | VARCHAR(50) | Salary units (annual, monthly, hourly) |
| pay st | FLOAT | Pay straight time rate |
| pay st units | VARCHAR(50) | Pay straight time units |
| start date | DATETIME | Employee's project or assignment start date |
| end date | DATETIME | Employee's project or assignment end date |
| po start date | VARCHAR(50) | Purchase order start date |
| po end date | VARCHAR(50) | Purchase order end date |
| project city | VARCHAR(50) | City where the project is located |
| project state | VARCHAR(50) | State where the project is located |
| no of free hours | VARCHAR(50) | Number of free hours |
| hr_business_type | VARCHAR(50) | Business type classification for HR purposes |
| ee_wf_reason | VARCHAR(50) | Employee workflow reason code |
| singleman company | VARCHAR(50) | Singleman company indicator |
| status | VARCHAR(50) | Current status of the employee or assignment |
| termination_reason | VARCHAR(100) | Reason code or description for employee termination |
| wf created on | DATETIME | Workflow creation date |
| hcu | VARCHAR(50) | Horizontal Capability Unit |
| hsu | VARCHAR(50) | Horizontal Service Unit |
| project zip | VARCHAR(50) | Project location zip code |
| cre_person | VARCHAR(50) | Client Relationship Executive person |
| assigned_hsu | VARCHAR(10) | Assigned Horizontal Service Unit |
| req_category | VARCHAR(50) | Requisition category |
| gpm | MONEY | Gross Profit Margin amount |
| gp | MONEY | Gross Profit amount |
| aca_cost | REAL | Affordable Care Act cost |
| aca_classification | VARCHAR(50) | Affordable Care Act classification |
| markup | VARCHAR(3) | Markup indicator |
| actual_markup | VARCHAR(50) | Actual markup percentage or amount |
| maximum_allowed_markup | VARCHAR(50) | Maximum allowed markup |
| submitted_bill_rate | MONEY | Submitted bill rate to client |
| req_division | VARCHAR(200) | Requisition division |
| pay rate to consultant | VARCHAR(50) | Pay rate to consultant |
| location | VARCHAR(50) | Location of the assignment |
| rec_region | VARCHAR(50) | Recruiting region |
| client_region | VARCHAR(50) | Client region |
| dm | VARCHAR(50) | Delivery Manager |
| delivery_director | VARCHAR(50) | Delivery Director |
| bu | VARCHAR(50) | Business Unit |
| es | VARCHAR(50) | Enterprise Services |
| nam | VARCHAR(50) | National Account Manager |
| client_sector | VARCHAR(50) | Client industry sector |
| skills | VARCHAR(2500) | Employee skills list |
| pskills | VARCHAR(4000) | Primary skills list |
| business_manager | NVARCHAR(MAX) | Business manager name |
| vmo | VARCHAR(50) | Vendor Management Office |
| rec_name | VARCHAR(500) | Recruiter name |
| Req_ID | NUMERIC(18,9) | Requisition identifier |
| received | DATETIME | Date requisition was received |
| Submitted | DATETIME | Date candidate was submitted |
| responsetime | VARCHAR(53) | Response time calculation |
| Inhouse | VARCHAR(3) | In-house employee indicator |
| Net_Bill_Rate | MONEY | Net bill rate after deductions |
| Loaded_Pay_Rate | MONEY | Loaded pay rate including benefits and taxes |
| NSO | VARCHAR(100) | National Sales Office |
| ESG_Vertical | VARCHAR(100) | Enterprise Services Group vertical |
| ESG_Industry | VARCHAR(100) | Enterprise Services Group industry |
| ESG_DNA | VARCHAR(100) | Enterprise Services Group DNA classification |
| ESG_NAM1 | VARCHAR(100) | Enterprise Services Group National Account Manager 1 |
| ESG_NAM2 | VARCHAR(100) | Enterprise Services Group National Account Manager 2 |
| ESG_NAM3 | VARCHAR(100) | Enterprise Services Group National Account Manager 3 |
| ESG_SAM | VARCHAR(100) | Enterprise Services Group Strategic Account Manager |
| ESG_ES | VARCHAR(100) | Enterprise Services Group Enterprise Services |
| ESG_BU | VARCHAR(100) | Enterprise Services Group Business Unit |
| SUB_GPM | MONEY | Submitted Gross Profit Margin |
| manager_id | NUMERIC(18,9) | Manager identifier |
| Submitted_By | VARCHAR(50) | Name of person who submitted the candidate |
| HWF_Process_name | VARCHAR(100) | Human Workforce process name |
| Transition | VARCHAR(100) | Transition status or type |
| ITSS | VARCHAR(100) | IT Service Solutions indicator |
| GP2020 | MONEY | Gross Profit for year 2020 |
| GPM2020 | MONEY | Gross Profit Margin for year 2020 |
| isbulk | BIT | Bulk requisition indicator |
| jump | BIT | Jump indicator |
| client_class | VARCHAR(20) | Client classification |
| MSP | VARCHAR(50) | Managed Service Provider |
| DTCUChoice1 | VARCHAR(60) | DTCU Choice 1 classification |
| SubCat | VARCHAR(60) | Sub-category |
| IsClassInitiative | BIT | Class initiative indicator |
| division | VARCHAR(50) | Division name |
| divstart_date | DATETIME | Division start date |
| divend_date | DATETIME | Division end date |
| tl | VARCHAR(50) | Team Lead |
| resource_manager | VARCHAR(50) | Resource manager name |
| recruiting_manager | VARCHAR(50) | Recruiting manager name |
| VAS_Type | VARCHAR(100) | Value Added Services type |
| BUCKET | VARCHAR(50) | Bucket classification |
| RTR_DM | VARCHAR(50) | RTR Delivery Manager |
| ITSSProjectName | VARCHAR(200) | IT Service Solutions project name |
| RegionGroup | VARCHAR(50) | Region group classification |
| client_Markup | VARCHAR(20) | Client markup percentage |
| Subtier | VARCHAR(50) | Sub-tier client classification |
| Subtier_Address1 | VARCHAR(50) | Sub-tier address line 1 |
| Subtier_Address2 | VARCHAR(50) | Sub-tier address line 2 |
| Subtier_City | VARCHAR(50) | Sub-tier city |
| Subtier_State | VARCHAR(50) | Sub-tier state |
| Hiresource | VARCHAR(100) | Hire source |
| is_Hotbook_Hire | INT | Hotbook hire indicator |
| Client_RM | VARCHAR(50) | Client Relationship Manager |
| Job_Description | VARCHAR(100) | Job description |
| Client_Manager | VARCHAR(50) | Client manager name |
| end_date_at_client | DATETIME | End date at client location |
| term_date | DATETIME | Termination date |
| employee_status | VARCHAR(50) | Employee status |
| Level_ID | INT | Level identifier in workflow |
| OpsGrp | VARCHAR(50) | Operations group |
| Level_Name | VARCHAR(50) | Level name in workflow |
| Min_levelDatetime | DATETIME | Minimum level datetime |
| Max_levelDatetime | DATETIME | Maximum level datetime |
| First_Interview_date | DATETIME | First interview date |
| Is REC CES? | VARCHAR(5) | Is recruiter CES indicator |
| Is CES Initiative? | VARCHAR(5) | Is CES initiative indicator |
| VMO_Access | VARCHAR(50) | Vendor Management Office access |
| Billing_Type | VARCHAR(50) | Billing type classification |
| VASSOW | VARCHAR(3) | VAS or SOW indicator |
| Worker_Entity_ID | VARCHAR(30) | Worker entity identifier |
| Circle | VARCHAR(50) | Circle classification |
| VMO_Access1 | VARCHAR(50) | Vendor Management Office access level 1 |
| VMO_Access2 | VARCHAR(50) | Vendor Management Office access level 2 |
| VMO_Access3 | VARCHAR(50) | Vendor Management Office access level 3 |
| VMO_Access4 | VARCHAR(50) | Vendor Management Office access level 4 |
| Inside_Sales_Person | VARCHAR(50) | Inside sales person name |
| admin_1701 | VARCHAR(50) | Admin 1701 classification |
| corrected_staffadmin_1701 | VARCHAR(50) | Corrected staff admin 1701 |
| HR_Billing_Placement_Net_Fee | MONEY | HR billing placement net fee |
| New_Visa_type | VARCHAR(50) | New visa type classification |
| newenddate | DATETIME | New end date |
| Newoffboardingdate | DATETIME | New offboarding date |
| NewTermdate | DATETIME | New termination date |
| newhrisenddate | DATETIME | New HRIS end date |
| rtr_location | VARCHAR(50) | RTR location |
| HR_Recruiting_TL | VARCHAR(100) | HR recruiting team lead |
| client_entity | VARCHAR(50) | Client legal entity |
| client_consent | BIT | Client consent indicator |
| Ascendion_MetalReqID | NUMERIC(18,9) | Ascendion Metal requisition identifier |
| eeo | VARCHAR(200) | Equal Employment Opportunity classification |
| veteran | VARCHAR(150) | Veteran status |
| Gender | VARCHAR(50) | Gender |
| Er_person | VARCHAR(50) | Employee Relations person |
| wfmetaljobdescription | NVARCHAR(MAX) | Workflow metal job description |
| HR_Candidate_Salary | MONEY | HR candidate salary |
| Interview_CreatedDate | DATETIME | Interview creation date |
| Interview_on_Date | DATETIME | Interview date |
| IS_SOW | VARCHAR(7) | Is Statement of Work indicator |
| IS_Offshore | VARCHAR(20) | Is offshore indicator |
| New_VAS | VARCHAR(4) | New Value Added Services indicator |
| VerticalName | NVARCHAR(510) | Vertical name |
| Client_Group1 | VARCHAR(19) | Client group 1 classification |
| Billig_Type | VARCHAR(8) | Billing type |
| Super Merged Name | VARCHAR(200) | Super merged name |
| New_Category | VARCHAR(11) | New category classification |
| New_business_type | VARCHAR(100) | New business type |
| OpportunityID | VARCHAR(50) | Sales opportunity identifier |
| OpportunityName | VARCHAR(200) | Sales opportunity name |
| Ms_ProjectId | INT | Microsoft project identifier |
| MS_ProjectName | VARCHAR(200) | Microsoft project name |
| ORC_ID | VARCHAR(30) | Oracle identifier |
| Market_Leader | NVARCHAR(MAX) | Market leader name |
| Circle_Metal | VARCHAR(100) | Circle metal classification |
| Community_New_Metal | VARCHAR(100) | Community new metal classification |
| Employee_Category | VARCHAR(50) | Employee category |
| IsBillRateSkip | BIT | Is bill rate skip indicator |
| BillRate | DECIMAL(18,9) | Bill rate amount |
| RoleFamily | VARCHAR(300) | Role family classification |
| SubRoleFamily | VARCHAR(300) | Sub-role family classification |
| Standard JobTitle | VARCHAR(500) | Standard job title |
| ClientInterviewRequired | INT | Client interview required indicator |
| Redeploymenthire | INT | Redeployment hire indicator |
| HRBrandLevelId | INT | HR brand level identifier |
| HRBandTitle | VARCHAR(300) | HR band title |
| latest_termination_reason | VARCHAR(200) | Latest termination reason |
| latest_termination_date | DATETIME | Latest termination date |
| Community | VARCHAR(100) | Community classification |
| ReqFulfillmentReason | VARCHAR(200) | Requisition fulfillment reason |
| EngagementType | VARCHAR(500) | Engagement type |
| RedepLedBy | VARCHAR(200) | Redeployment led by |
| Can_ExperienceLevelTitle | VARCHAR(200) | Candidate experience level title |
| Can_StandardJobTitleHorizon | NVARCHAR(4000) | Candidate standard job title from Horizon |
| CandidateEmail | VARCHAR(100) | Candidate email address |
| Offboarding_Reason | VARCHAR(100) | Offboarding reason |
| Offboarding_Initiated | DATETIME | Offboarding initiated date |
| Offboarding_Status | VARCHAR(100) | Offboarding status |
| replcament_GCIID | INT | Replacement GCI identifier |
| replcament_EmployeeName | VARCHAR(500) | Replacement employee name |
| Senior Manager | VARCHAR(50) | Senior manager name |
| Associate Manager | VARCHAR(50) | Associate manager name |
| Director - Talent Engine | VARCHAR(50) | Director of Talent Engine |
| Manager | VARCHAR(50) | Manager name |
| Rec_ExperienceLevelTitle | VARCHAR(200) | Recruiter experience level title |
| Rec_StandardJobTitleHorizon | NVARCHAR(4000) | Recruiter standard job title from Horizon |
| Task_Id | INT | Task identifier |
| proj_ID | VARCHAR(50) | Project identifier |
| Projdesc | CHAR(60) | Project description |
| Client_Group | VARCHAR(19) | Client group |
| billST_New | FLOAT | New bill straight time rate |
| Candidate city | VARCHAR(50) | Candidate city |
| Candidate State | VARCHAR(50) | Candidate state |
| C2C_W2_FTE | VARCHAR(13) | Corp-to-Corp, W2, or FTE classification |
| FP_TM | VARCHAR(2) | Fixed price time marker |
| load_timestamp | DATETIME | Timestamp when the record was loaded into Bronze layer |
| update_timestamp | DATETIME | Timestamp when the record was last updated |
| source_system | VARCHAR(100) | Source system name from which data originated |

---

### 2.6 Bz_vw_billing_timesheet_daywise_ne

**Table Description:** Bronze layer table capturing billing timesheet data on a daily basis from source system view. This table contains approved billable and non-billable hours by day for billing and revenue recognition purposes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| ID | NUMERIC(18,9) | Unique identifier for the timesheet record |
| GCI_ID | INT | Global Consultant Identifier - unique employee identification number |
| PE_DATE | DATETIME | Period ending date for the timesheet entry |
| WEEK_DATE | DATETIME | Week ending date for the timesheet entry |
| BILLABLE | VARCHAR(3) | Indicator whether the hours are billable (Yes/No) |
| Approved_hours(ST) | FLOAT | Approved straight time hours |
| Approved_hours(Non_ST) | FLOAT | Approved non-billable straight time hours |
| Approved_hours(OT) | FLOAT | Approved overtime hours |
| Approved_hours(Non_OT) | FLOAT | Approved non-billable overtime hours |
| Approved_hours(DT) | FLOAT | Approved double time hours |
| Approved_hours(Non_DT) | FLOAT | Approved non-billable double time hours |
| Approved_hours(Sick_Time) | FLOAT | Approved sick time hours |
| Approved_hours(Non_Sick_Time) | FLOAT | Approved non-billable sick time hours |
| load_timestamp | DATETIME | Timestamp when the record was loaded into Bronze layer |
| update_timestamp | DATETIME | Timestamp when the record was last updated |
| source_system | VARCHAR(100) | Source system name from which data originated |

---

### 2.7 Bz_vw_consultant_timesheet_daywise

**Table Description:** Bronze layer table capturing consultant timesheet data on a daily basis from source system view. This table contains consultant-submitted hours by day for time tracking and payroll processing.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| ID | NUMERIC(18,9) | Unique identifier for the timesheet record |
| GCI_ID | INT | Global Consultant Identifier - unique employee identification number |
| PE_DATE | DATETIME | Period ending date for the timesheet entry |
| WEEK_DATE | DATETIME | Week ending date for the timesheet entry |
| BILLABLE | VARCHAR(3) | Indicator whether the hours are billable (Yes/No) |
| Consultant_hours(ST) | FLOAT | Consultant straight time hours submitted |
| Consultant_hours(OT) | FLOAT | Consultant overtime hours submitted |
| Consultant_hours(DT) | FLOAT | Consultant double time hours submitted |
| load_timestamp | DATETIME | Timestamp when the record was loaded into Bronze layer |
| update_timestamp | DATETIME | Timestamp when the record was last updated |
| source_system | VARCHAR(100) | Source system name from which data originated |

---

### 2.8 Bz_DimDate

**Table Description:** Bronze layer dimension table containing date attributes from source system. This table provides comprehensive date-related attributes for time-based analysis and reporting across all data layers.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Date | DATETIME | Actual date value |
| DayOfMonth | VARCHAR(2) | Day of the month (1-31) |
| DayName | VARCHAR(9) | Name of the day (Monday, Tuesday, etc.) |
| WeekOfYear | VARCHAR(2) | Week number of the year (1-52) |
| Month | VARCHAR(2) | Month number (1-12) |
| MonthName | VARCHAR(9) | Name of the month (January, February, etc.) |
| MonthOfQuarter | VARCHAR(2) | Month within the quarter (1-3) |
| Quarter | CHAR(1) | Quarter number (1-4) |
| QuarterName | VARCHAR(9) | Quarter name (Q1, Q2, Q3, Q4) |
| Year | CHAR(4) | Four-digit year |
| YearName | CHAR(7) | Year name with prefix |
| MonthYear | CHAR(10) | Month and year combined |
| MMYYYY | CHAR(6) | Month and year in MMYYYY format |
| DaysInMonth | INT | Number of days in the month |
| MM-YYYY | VARCHAR(10) | Month and year in MM-YYYY format |
| YYYYMM | VARCHAR(10) | Year and month in YYYYMM format |
| load_timestamp | DATETIME | Timestamp when the record was loaded into Bronze layer |
| update_timestamp | DATETIME | Timestamp when the record was last updated |
| source_system | VARCHAR(100) | Source system name from which data originated |

---

### 2.9 Bz_holidays_Mexico

**Table Description:** Bronze layer reference table containing Mexico holiday information from source system. This table stores holiday dates and descriptions specific to Mexico for workforce planning and payroll processing.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Holiday_Date | DATETIME | Date of the holiday |
| Description | VARCHAR(50) | Description or name of the holiday |
| Location | VARCHAR(10) | Location code for the holiday (Mexico) |
| Source_type | VARCHAR(50) | Source type or category of the holiday |
| load_timestamp | DATETIME | Timestamp when the record was loaded into Bronze layer |
| update_timestamp | DATETIME | Timestamp when the record was last updated |
| source_system | VARCHAR(100) | Source system name from which data originated |

---

### 2.10 Bz_holidays_Canada

**Table Description:** Bronze layer reference table containing Canada holiday information from source system. This table stores holiday dates and descriptions specific to Canada for workforce planning and payroll processing.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Holiday_Date | DATETIME | Date of the holiday |
| Description | VARCHAR(100) | Description or name of the holiday |
| Location | VARCHAR(10) | Location code for the holiday (Canada) |
| Source_type | VARCHAR(50) | Source type or category of the holiday |
| load_timestamp | DATETIME | Timestamp when the record was loaded into Bronze layer |
| update_timestamp | DATETIME | Timestamp when the record was last updated |
| source_system | VARCHAR(100) | Source system name from which data originated |

---

### 2.11 Bz_holidays

**Table Description:** Bronze layer reference table containing general holiday information from source system. This table stores holiday dates and descriptions for various locations for workforce planning and payroll processing.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Holiday_Date | DATETIME | Date of the holiday |
| Description | VARCHAR(50) | Description or name of the holiday |
| Location | VARCHAR(10) | Location code for the holiday |
| Source_type | VARCHAR(50) | Source type or category of the holiday |
| load_timestamp | DATETIME | Timestamp when the record was loaded into Bronze layer |
| update_timestamp | DATETIME | Timestamp when the record was last updated |
| source_system | VARCHAR(100) | Source system name from which data originated |

---

### 2.12 Bz_holidays_India

**Table Description:** Bronze layer reference table containing India holiday information from source system. This table stores holiday dates and descriptions specific to India for workforce planning and payroll processing.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Holiday_Date | DATETIME | Date of the holiday |
| Description | VARCHAR(50) | Description or name of the holiday |
| Location | VARCHAR(10) | Location code for the holiday (India) |
| Source_type | VARCHAR(50) | Source type or category of the holiday |
| load_timestamp | DATETIME | Timestamp when the record was loaded into Bronze layer |
| update_timestamp | DATETIME | Timestamp when the record was last updated |
| source_system | VARCHAR(100) | Source system name from which data originated |

---

## 3. AUDIT TABLE DESIGN

### 3.1 Bz_Audit_Log

**Table Description:** Audit table for tracking all data loading and processing activities in the Bronze layer. This table maintains a comprehensive log of all ETL operations, data quality checks, and processing metrics for compliance and troubleshooting purposes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| record_id | BIGINT | Unique identifier for each audit log entry, auto-incrementing |
| source_table | VARCHAR(200) | Name of the source table being processed (e.g., Bz_New_Monthly_HC_Report) |
| load_timestamp | DATETIME | Timestamp when the data load operation started |
| processed_by | VARCHAR(100) | Name of the ETL process, job, or user that processed the data |
| processing_time | DECIMAL(18,6) | Time taken to process the data in seconds |
| status | VARCHAR(50) | Status of the processing operation (Success, Failed, Partial, Warning) |
| records_read | BIGINT | Number of records read from the source |
| records_inserted | BIGINT | Number of records successfully inserted |
| records_updated | BIGINT | Number of records updated |
| records_failed | BIGINT | Number of records that failed to process |
| error_message | VARCHAR(MAX) | Detailed error message if the operation failed |
| source_system | VARCHAR(100) | Source system name from which data was extracted |
| batch_id | VARCHAR(100) | Batch identifier for grouping related processing operations |
| load_type | VARCHAR(50) | Type of load operation (Full, Incremental, Delta) |
| start_datetime | DATETIME | Start date and time of the processing operation |
| end_datetime | DATETIME | End date and time of the processing operation |
| data_quality_score | DECIMAL(5,2) | Data quality score as a percentage (0-100) |
| validation_status | VARCHAR(50) | Status of data validation checks (Passed, Failed, Skipped) |
| file_name | VARCHAR(500) | Name of the source file if applicable |
| file_size_mb | DECIMAL(18,2) | Size of the source file in megabytes |
| checksum | VARCHAR(100) | Checksum or hash value for data integrity verification |
| created_by | VARCHAR(100) | User or process that created the audit entry |
| created_timestamp | DATETIME | Timestamp when the audit entry was created |

---

## 4. CONCEPTUAL DATA MODEL RELATIONSHIPS

### 4.1 Table Relationships

| Source Table | Related Table | Relationship Type | Relationship Key Field | Description |
|--------------|---------------|-------------------|------------------------|-------------|
| Bz_New_Monthly_HC_Report | Bz_SchTask | One-to-Many | gci id → GCI_ID | Links employee headcount records to their workflow tasks and processes |
| Bz_New_Monthly_HC_Report | Bz_Hiring_Initiator_Project_Info | One-to-One | gci id → (derived from candidate info) | Links employee headcount to their original hiring and project information |
| Bz_New_Monthly_HC_Report | Bz_Timesheet_New | One-to-Many | gci id → gci_id | Links employee headcount records to their daily timesheet entries |
| Bz_New_Monthly_HC_Report | Bz_report_392_all | One-to-One | gci id → gci id | Links employee headcount to comprehensive reporting data |
| Bz_New_Monthly_HC_Report | Bz_DimDate | Many-to-One | start date → Date | Links employee start dates to date dimension for time-based analysis |
| Bz_New_Monthly_HC_Report | Bz_DimDate | Many-to-One | termdate → Date | Links employee termination dates to date dimension |
| Bz_New_Monthly_HC_Report | Bz_DimDate | Many-to-One | YYMM → YYYYMM | Links reporting period to date dimension |
| Bz_SchTask | Bz_Hiring_Initiator_Project_Info | Many-to-One | GCI_ID → (derived from candidate info) | Links workflow tasks to hiring project information |
| Bz_Timesheet_New | Bz_report_392_all | Many-to-One | gci_id → gci id | Links timesheet entries to employee reporting data |
| Bz_Timesheet_New | Bz_DimDate | Many-to-One | pe_date → Date | Links timesheet period ending dates to date dimension |
| Bz_Timesheet_New | Bz_vw_billing_timesheet_daywise_ne | One-to-One | gci_id, pe_date → GCI_ID, PE_DATE | Links raw timesheet to approved billing timesheet |
| Bz_Timesheet_New | Bz_vw_consultant_timesheet_daywise | One-to-One | gci_id, pe_date → GCI_ID, PE_DATE | Links raw timesheet to consultant submitted timesheet |
| Bz_report_392_all | Bz_Hiring_Initiator_Project_Info | Many-to-One | gci id → (derived from candidate info) | Links comprehensive report to hiring project details |
| Bz_report_392_all | Bz_DimDate | Many-to-One | start date → Date | Links assignment start dates to date dimension |
| Bz_report_392_all | Bz_DimDate | Many-to-One | end date → Date | Links assignment end dates to date dimension |
| Bz_vw_billing_timesheet_daywise_ne | Bz_DimDate | Many-to-One | PE_DATE → Date | Links billing timesheet dates to date dimension |
| Bz_vw_billing_timesheet_daywise_ne | Bz_DimDate | Many-to-One | WEEK_DATE → Date | Links billing timesheet week dates to date dimension |
| Bz_vw_consultant_timesheet_daywise | Bz_DimDate | Many-to-One | PE_DATE → Date | Links consultant timesheet dates to date dimension |
| Bz_vw_consultant_timesheet_daywise | Bz_DimDate | Many-to-One | WEEK_DATE → Date | Links consultant timesheet week dates to date dimension |
| Bz_holidays_Mexico | Bz_DimDate | Many-to-One | Holiday_Date → Date | Links Mexico holidays to date dimension |
| Bz_holidays_Canada | Bz_DimDate | Many-to-One | Holiday_Date → Date | Links Canada holidays to date dimension |
| Bz_holidays | Bz_DimDate | Many-to-One | Holiday_Date → Date | Links general holidays to date dimension |
| Bz_holidays_India | Bz_DimDate | Many-to-One | Holiday_Date → Date | Links India holidays to date dimension |
| Bz_Audit_Log | All Bronze Tables | One-to-Many | source_table → Table Name | Tracks audit information for all Bronze layer tables |

### 4.2 Relationship Diagram (Tabular Format)

#### Core Employee and Assignment Relationships

```
Bz_New_Monthly_HC_Report (Central Fact Table)
    ├── Related to: Bz_SchTask
    │   └── Via: gci id = GCI_ID
    │   └── Cardinality: 1:M (One employee can have many workflow tasks)
    │
    ├── Related to: Bz_Hiring_Initiator_Project_Info
    │   └── Via: gci id matches candidate information
    │   └── Cardinality: 1:1 (One employee has one hiring record)
    │
    ├── Related to: Bz_Timesheet_New
    │   └── Via: gci id = gci_id
    │   └── Cardinality: 1:M (One employee has many timesheet entries)
    │
    ├── Related to: Bz_report_392_all
    │   └── Via: gci id = gci id
    │   └── Cardinality: 1:1 (One employee has one comprehensive report record)
    │
    └── Related to: Bz_DimDate
        └── Via: start date, termdate, YYMM = Date, YYYYMM
        └── Cardinality: M:1 (Many employees can have same dates)
```

#### Timesheet Relationships

```
Bz_Timesheet_New (Timesheet Fact Table)
    ├── Related to: Bz_vw_billing_timesheet_daywise_ne
    │   └── Via: gci_id, pe_date = GCI_ID, PE_DATE
    │   └── Cardinality: 1:1 (One raw timesheet maps to one billing timesheet)
    │
    ├── Related to: Bz_vw_consultant_timesheet_daywise
    │   └── Via: gci_id, pe_date = GCI_ID, PE_DATE
    │   └── Cardinality: 1:1 (One raw timesheet maps to one consultant timesheet)
    │
    ├── Related to: Bz_report_392_all
    │   └── Via: gci_id = gci id
    │   └── Cardinality: M:1 (Many timesheets for one employee)
    │
    └── Related to: Bz_DimDate
        └── Via: pe_date = Date
        └── Cardinality: M:1 (Many timesheets for one date)
```

#### Holiday Reference Relationships

```
Bz_holidays (General Holidays)
    └── Related to: Bz_DimDate
        └── Via: Holiday_Date = Date
        └── Cardinality: M:1 (Multiple holidays can fall on same date)

Bz_holidays_Mexico (Mexico Holidays)
    └── Related to: Bz_DimDate
        └── Via: Holiday_Date = Date
        └── Cardinality: M:1 (Multiple holidays can fall on same date)

Bz_holidays_Canada (Canada Holidays)
    └── Related to: Bz_DimDate
        └── Via: Holiday_Date = Date
        └── Cardinality: M:1 (Multiple holidays can fall on same date)

Bz_holidays_India (India Holidays)
    └── Related to: Bz_DimDate
        └── Via: Holiday_Date = Date
        └── Cardinality: M:1 (Multiple holidays can fall on same date)
```

#### Audit Relationships

```
Bz_Audit_Log (Audit Tracking)
    └── Related to: All Bronze Layer Tables
        └── Via: source_table = Table Name
        └── Cardinality: 1:M (One table can have many audit entries)
        └── Tracks: Load operations, data quality, processing metrics
```

---

## 5. DESIGN DECISIONS AND RATIONALE

### 5.1 Bronze Layer Design Principles

**Decision 1: Exact Source Structure Mirroring**
- **Rationale:** The Bronze layer follows the principle of preserving raw data exactly as it appears in the source system. This ensures data lineage, enables source system reconciliation, and provides a reliable foundation for downstream transformations.
- **Implementation:** All tables maintain the same column names, data types, and structure as the source, with only primary key and foreign key fields removed as per requirements.

**Decision 2: Metadata Column Addition**
- **Rationale:** Adding load_timestamp, update_timestamp, and source_system columns enables tracking of data lineage, supports incremental loading strategies, and facilitates troubleshooting and auditing.
- **Implementation:** These three metadata columns are consistently added to all Bronze layer tables.

**Decision 3: Naming Convention (Bz_ Prefix)**
- **Rationale:** The 'Bz_' prefix clearly identifies tables as belonging to the Bronze layer, making it easy to distinguish between layers in the Medallion architecture and preventing naming conflicts.
- **Implementation:** All Bronze layer tables are prefixed with 'Bz_' followed by the original source table name.

### 5.2 PII Classification Approach

**Decision 4: Comprehensive PII Identification**
- **Rationale:** Identifying PII fields is critical for GDPR compliance, data privacy regulations, and implementing appropriate security controls such as encryption, masking, and access restrictions.
- **Implementation:** PII fields are classified based on:
  - Direct identifiers (names, SSN, email)
  - Contact information (phone, address)
  - Unique identifiers that can be linked to individuals (GCI_ID)
  - Sensitive personal data (DOB, gender, veteran status)

**Decision 5: PII Documentation**
- **Rationale:** Documenting why each field is considered PII helps data governance teams understand the sensitivity level and implement appropriate controls.
- **Implementation:** Each PII field includes a detailed explanation of why it's classified as sensitive.

### 5.3 Audit Table Design

**Decision 6: Comprehensive Audit Logging**
- **Rationale:** A robust audit table is essential for tracking data lineage, monitoring ETL performance, troubleshooting failures, and meeting compliance requirements.
- **Implementation:** The audit table includes:
  - Processing metrics (records read, inserted, updated, failed)
  - Performance metrics (processing time)
  - Data quality metrics (quality score, validation status)
  - Error tracking (error messages, status)
  - File-level tracking (file name, size, checksum)

**Decision 7: Audit Table Granularity**
- **Rationale:** Capturing detailed information at the table and batch level enables precise tracking of data flows and quick identification of issues.
- **Implementation:** Each audit entry tracks a specific table load operation with unique record_id and batch_id for grouping related operations.

### 5.4 Data Type Preservation

**Decision 8: Source Data Type Retention**
- **Rationale:** Maintaining source data types in the Bronze layer prevents data loss, preserves precision, and ensures accurate representation of source data.
- **Implementation:** All data types from the source DDL are preserved exactly, including precision and scale for numeric types.

### 5.5 Relationship Documentation

**Decision 9: Explicit Relationship Mapping**
- **Rationale:** Documenting relationships between tables helps downstream developers understand data connections, supports query optimization, and guides Silver layer design.
- **Implementation:** Relationships are documented with:
  - Source and target tables
  - Relationship type (1:1, 1:M, M:1)
  - Key fields used for joining
  - Business description of the relationship

### 5.6 Key Assumptions

**Assumption 1: GCI_ID as Primary Employee Identifier**
- All employee-related tables use GCI_ID (or variations like gci id, gci_id) as the primary identifier for linking employee records across tables.

**Assumption 2: Date Dimension as Central Time Reference**
- The DimDate table serves as the central reference for all time-based analysis and is related to multiple tables through various date fields.

**Assumption 3: Source System Stability**
- The source system structure is assumed to be relatively stable. Any schema changes in the source will require corresponding updates to the Bronze layer.

**Assumption 4: Data Quality Validation in Silver Layer**
- The Bronze layer stores raw data without transformation. Data quality rules, cleansing, and standardization are assumed to be implemented in the Silver layer.

**Assumption 5: Incremental Loading Strategy**
- The metadata columns (load_timestamp, update_timestamp) support an incremental loading strategy, though the specific implementation details are not defined in this logical model.

**Assumption 6: Single Source System**
- The source_system column suggests potential for multiple source systems, but the current model assumes a single SQL Server source system.

**Assumption 7: Audit Retention Policy**
- The audit table design assumes a retention policy will be defined separately for managing audit log growth over time.

### 5.7 Scalability Considerations

**Decision 10: Partitioning Strategy (Future)**
- **Rationale:** Large fact tables like Bz_New_Monthly_HC_Report and Bz_Timesheet_New may benefit from partitioning by date for improved query performance.
- **Recommendation:** Consider implementing date-based partitioning in the physical implementation phase.

**Decision 11: Indexing Strategy (Future)**
- **Rationale:** While the logical model doesn't define indexes, key fields like gci_id, pe_date, and date fields should be indexed in the physical implementation.
- **Recommendation:** Create indexes on frequently joined and filtered columns in the physical implementation.

---

## 6. DATA GOVERNANCE AND COMPLIANCE

### 6.1 PII Protection Requirements

**Encryption:** All PII fields identified in Section 1 should be encrypted at rest and in transit.

**Access Control:** Implement role-based access control (RBAC) to restrict access to PII fields to authorized personnel only.

**Masking:** Consider implementing dynamic data masking for PII fields in non-production environments.

**Audit Logging:** All access to PII fields should be logged in the audit table for compliance purposes.

### 6.2 Data Retention

**Bronze Layer Retention:** Define retention policies for Bronze layer data based on business and regulatory requirements.

**Audit Log Retention:** Maintain audit logs for a minimum period as required by compliance regulations (typically 7 years for financial data).

### 6.3 Data Quality Framework

**Validation Rules:** Implement data quality validation rules in the ETL process and log results in the audit table.

**Data Quality Metrics:** Track data quality scores over time to identify trends and issues.

**Reconciliation:** Implement source-to-target reconciliation processes to ensure data completeness and accuracy.

---

## 7. IMPLEMENTATION NOTES

### 7.1 ETL Process Guidelines

1. **Extract:** Extract data from source system tables as-is without transformation
2. **Load:** Load data into Bronze layer tables with metadata columns populated
3. **Audit:** Create audit log entry for each table load operation
4. **Validate:** Perform basic data quality checks and log results
5. **Error Handling:** Capture and log any errors in the audit table

### 7.2 Metadata Column Population

- **load_timestamp:** Set to current timestamp when record is first inserted
- **update_timestamp:** Set to current timestamp on every update
- **source_system:** Set to 'SQL_Server_Source' or appropriate source system identifier

### 7.3 Audit Table Usage

- Create one audit entry per table per load operation
- Use batch_id to group related table loads in a single ETL run
- Update audit entry with final status and metrics upon completion
- Log errors with detailed error messages for troubleshooting

---

## 8. NEXT STEPS

### 8.1 Silver Layer Design

- Design Silver layer tables with cleansed and standardized data
- Implement data quality rules and transformations
- Create conformed dimensions and fact tables
- Establish slowly changing dimension (SCD) strategies

### 8.2 Physical Implementation

- Create physical database schema in target platform
- Implement partitioning and indexing strategies
- Configure security and access controls
- Set up monitoring and alerting

### 8.3 ETL Development

- Develop ETL pipelines for Bronze layer loading
- Implement incremental loading logic
- Create data quality validation processes
- Build audit logging framework

---

## 9. API COST ESTIMATION

**apiCost:** 0.00

**Note:** This logical data model was created through analysis and documentation without consuming external API resources. The cost represents the computational effort for reading source files and generating comprehensive documentation.

---

## DOCUMENT CONTROL

**Version:** 1.0
**Status:** Final
**Last Updated:** 2024
**Document Owner:** AAVA
**Review Cycle:** Quarterly

---

**END OF DOCUMENT**