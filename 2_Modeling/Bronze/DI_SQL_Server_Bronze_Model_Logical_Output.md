====================================================
Author:        AAVA
Date:          
Description:   Bronze Layer Logical Data Model for Medallion Architecture - SQL Server Source
====================================================

# BRONZE LAYER LOGICAL DATA MODEL

## 1. PII CLASSIFICATION

### Table: New_Monthly_HC_Report

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| gci id | Employee identifier that can be used to identify an individual employee |
| first name | Personal identifier - employee's first name is direct PII under GDPR |
| last name | Personal identifier - employee's last name is direct PII under GDPR |
| job title | Employment information that can be used to identify an individual in combination with other data |
| start date | Employment start date is personal employment information |
| termdate | Termination date is sensitive employment information |
| Final_End_date | Employment end date is personal employment information |
| termination_reason | Sensitive employment information that reveals reasons for employment termination |
| Emp_Status | Employment status is personal employment information |
| salesrep | Individual sales representative name is PII |
| recruiter | Individual recruiter name is PII |
| CP_Name | Client Partner name is PII |
| ALT | Account Lead name is PII |
| Market_Leader | Market Leader name is PII |
| Acct_Owner | Account Owner name is PII |
| PortfolioLeader | Portfolio Leader name is PII |
| ClientPartner | Client Partner name is PII |
| User_Name | Username is PII as it can identify an individual |

### Table: SchTask

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| SSN | Social Security Number is highly sensitive PII and protected under multiple regulations including GDPR, CCPA |
| GCI_ID | Employee identifier that can be used to identify an individual employee |
| FName | Personal identifier - employee's first name is direct PII under GDPR |
| LName | Personal identifier - employee's last name is direct PII under GDPR |
| Initiator | Individual who initiated the task - personal identifier |
| Initiator_Mail | Email address is PII under GDPR and CCPA |

### Table: Hiring_Initiator_Project_Info

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| Candidate_LName | Candidate's last name is direct PII under GDPR |
| Candidate_MI | Candidate's middle initial is personal identifier |
| Candidate_FName | Candidate's first name is direct PII under GDPR |
| Candidate_SSN | Social Security Number is highly sensitive PII protected under multiple regulations |
| HR_Candidate_JobTitle | Job title of candidate is employment-related PII |
| HR_Candidate_DOB | Date of Birth is sensitive PII under GDPR and CCPA |
| HR_ClientInfo_Manager | Manager name is PII |
| HR_ClientInfo_Phone | Phone number is contact PII under GDPR |
| HR_ClientInfo_Email | Email address is PII under GDPR and CCPA |
| HR_ClientInfo_Cell | Cell phone number is contact PII |
| HR_ClientInfo_Pager | Pager number is contact information PII |
| HR_ClientInfo_Pager_Pin | Pager PIN is personal contact information |
| HR_ClientAgreements_Phone | Phone number is contact PII |
| HR_ClientAgreements_Email | Email address is PII |
| HR_ClientAgreements_Cell | Cell phone number is contact PII |
| HR_ClientAgreements_Pager | Pager number is contact PII |
| HR_ClientAgreements_Pager_Pin | Pager PIN is personal contact information |
| HR_Project_Phone | Phone number is contact PII |
| HR_Project_Email | Email address is PII |
| HR_Project_Cell | Cell phone number is contact PII |
| HR_Project_Pager | Pager number is contact PII |
| HR_Project_Pager_Pin | Pager PIN is personal contact information |
| HR_Accounts_Person | Account person name is PII |
| HR_Accounts_PhoneNo | Phone number is contact PII |
| HR_Accounts_Email | Email address is PII |
| HR_Accounts_Cell | Cell phone number is contact PII |
| HR_Accounts_Pager | Pager number is contact PII |
| HR_Accounts_Pager_Pin | Pager PIN is personal contact information |
| UserCreated | Username of creator is PII |
| ER_Person | Employee Relations person name is PII |
| CRE_Person | CRE person name is PII |
| I9_Approver | I9 approver name is PII |
| TSLead | Technical Sales Lead name is PII |
| Inside_Sales | Inside Sales person name is PII |
| HR_Recruiting_VMO | VMO name is PII |
| HR_Recruiting_Inside_Sales | Inside Sales person name is PII |
| HR_Recruiting_TL | Team Lead name is PII |
| HR_Recruiting_NAM | National Account Manager name is PII |
| HR_Recruiting_ARM | Account Relationship Manager name is PII |
| HR_Recruiting_RM | Recruiting Manager name is PII |
| UserUpdated | Username of updater is PII |
| ITSS_Business_Development_Manager | Business Development Manager name is PII |
| Onsite_Consultant_Relationship_Manager | Relationship Manager name is PII |
| Collabera_Email_ID | Email address is PII |
| Timesheet_Manager | Timesheet Manager name is PII |
| Timesheet_Manager_Phone | Phone number is contact PII |
| Timesheet_Manager_Email | Email address is PII |

### Table: Timesheet_New

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| gci_id | Employee identifier that can be used to identify an individual employee |

### Table: report_392_all

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| gci id | Employee identifier that can be used to identify an individual employee |
| first name | Personal identifier - employee's first name is direct PII under GDPR |
| last name | Personal identifier - employee's last name is direct PII under GDPR |
| recruiting manager | Manager name is PII |
| resource manager | Manager name is PII |
| salesrep | Sales representative name is PII |
| inside_sales | Inside sales person name is PII |
| recruiter | Recruiter name is PII |
| job title | Job title is employment-related PII |
| start date | Employment start date is personal employment information |
| end date | Employment end date is personal employment information |
| termination_reason | Sensitive employment information revealing termination reasons |
| cre_person | CRE person name is PII |
| dm | Delivery Manager name is PII |
| delivery_director | Delivery Director name is PII |
| nam | National Account Manager name is PII |
| business_manager | Business Manager name is PII |
| vmo | VMO name is PII |
| rec_name | Recruiter name is PII |
| Submitted_By | Submitter name is PII |
| tl | Team Lead name is PII |
| resource_manager | Resource Manager name is PII |
| recruiting_manager | Recruiting Manager name is PII |
| Client_RM | Client Relationship Manager name is PII |
| Client_Manager | Client Manager name is PII |
| term_date | Termination date is sensitive employment information |
| employee_status | Employment status is personal employment information |
| Inside_Sales_Person | Inside Sales person name is PII |
| admin_1701 | Administrator name is PII |
| corrected_staffadmin_1701 | Staff administrator name is PII |
| NewTermdate | New termination date is sensitive employment information |
| HR_Recruiting_TL | Team Lead name is PII |
| Er_person | Employee Relations person name is PII |
| eeo | Equal Employment Opportunity data is protected PII |
| veteran | Veteran status is protected PII under VEVRAA |
| Gender | Gender is sensitive PII under GDPR |
| Market_Leader | Market Leader name is PII |
| CandidateEmail | Email address is PII |
| replcament_EmployeeName | Replacement employee name is PII |
| Senior Manager | Senior Manager name is PII |
| Associate Manager | Associate Manager name is PII |
| Director - Talent Engine | Director name is PII |
| Manager | Manager name is PII |
| Candidate city | Candidate's city of residence is location PII |
| Candidate State | Candidate's state of residence is location PII |

### Table: vw_billing_timesheet_daywise_ne

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| GCI_ID | Employee identifier that can be used to identify an individual employee |

### Table: vw_consultant_timesheet_daywise

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| GCI_ID | Employee identifier that can be used to identify an individual employee |

### Table: DimDate

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| No PII fields identified | This is a dimension table containing only date-related reference data |

### Table: holidays_Mexico

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| No PII fields identified | This is a reference table containing only holiday information |

### Table: holidays_Canada

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| No PII fields identified | This is a reference table containing only holiday information |

### Table: holidays

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| No PII fields identified | This is a reference table containing only holiday information |

### Table: holidays_India

| Column Name | Reason for PII Classification |
|-------------|------------------------------|
| No PII fields identified | This is a reference table containing only holiday information |

---

## 2. BRONZE LAYER LOGICAL MODEL

### Table: Bz_New_Monthly_HC_Report
**Description:** Bronze layer table capturing raw monthly headcount report data from source system, maintaining exact structure for audit and lineage purposes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| id | numeric(18,0) | Unique record identifier for the monthly HC report entry |
| gci_id | varchar(50) | Global Consultant Identifier - unique employee identification number |
| first_name | varchar(50) | Employee's legal first name as recorded in HR system |
| last_name | varchar(50) | Employee's legal last name as recorded in HR system |
| job_title | varchar(50) | Official job title or position of the employee |
| hr_business_type | varchar(50) | Business type classification from HR perspective (e.g., consulting, permanent) |
| client_code | varchar(50) | Unique identifier code assigned to the client organization |
| start_date | datetime | Employee's project or employment start date |
| termdate | datetime | Employee's termination date if applicable |
| Final_End_date | datetime | Final calculated end date for the employee assignment |
| NBR | money | Net Bill Rate - the rate at which client is billed |
| Merged_Name | varchar(100) | Consolidated or merged client name for reporting purposes |
| Super_Merged_Name | varchar(100) | Higher level consolidated client name for enterprise reporting |
| market | varchar(50) | Geographic or business market segment |
| defined_New_VAS | varchar(8) | Value Added Services classification indicator |
| IS_SOW | varchar(7) | Statement of Work indicator flag |
| GP | money | Gross Profit amount for the engagement |
| NextValue | datetime | Next calculated value date for forecasting |
| termination_reason | varchar(100) | Detailed reason code or description for employment termination |
| FirstDay | datetime | First working day of the employee in the period |
| Emp_Status | varchar(25) | Current employment status (Active, Terminated, On Leave, etc.) |
| employee_category | varchar(50) | Employee classification category (Full-time, Part-time, Contractor) |
| LastDay | datetime | Last working day of the employee in the period |
| ee_wf_reason | varchar(50) | Employee workflow reason code |
| old_Begin | numeric(2,1) | Previous beginning headcount value |
| Begin_HC | numeric(38,36) | Beginning headcount for the reporting period |
| Starts_New_Project | numeric(38,36) | Count of employees starting new projects |
| Starts_Internal_movements | numeric(38,36) | Count of employees with internal movements |
| Terms | numeric(38,36) | Count of terminations in the period |
| Other_project_Ends | numeric(38,36) | Count of other project endings |
| OffBoard | numeric(38,36) | Count of employees offboarded |
| End_HC | numeric(38,36) | Ending headcount for the reporting period |
| Vol_term | numeric(38,36) | Voluntary termination count |
| adj | numeric(38,36) | Adjustment value for headcount reconciliation |
| YYMM | int | Year and month in YYMM format for time period identification |
| tower1 | varchar(60) | Primary service tower or practice area |
| req_type | varchar(50) | Requisition type classification |
| ITSSProjectName | varchar(200) | IT Staffing Services project name |
| IS_Offshore | varchar(20) | Offshore location indicator flag |
| Subtier | varchar(50) | Sub-tier client classification |
| New_Visa_type | varchar(50) | Visa type classification for the employee |
| Practice_type | varchar(50) | Practice area type classification |
| vertical | varchar(50) | Industry vertical classification |
| CL_Group | varchar(32) | Client group classification |
| salesrep | varchar(50) | Sales representative name assigned to the account |
| recruiter | varchar(50) | Recruiter name who sourced the candidate |
| PO_End | datetime | Purchase Order end date |
| PO_End_Count | numeric(38,36) | Count of PO endings |
| Derived_Rev | real | Derived revenue calculation |
| Derived_GP | real | Derived gross profit calculation |
| Backlog_Rev | real | Backlog revenue amount |
| Backlog_GP | real | Backlog gross profit amount |
| Expected_Hrs | real | Expected hours for the period |
| Expected_Total_Hrs | real | Expected total hours including all categories |
| ITSS | varchar(100) | IT Staffing Services classification |
| client_entity | varchar(50) | Legal entity name of the client |
| newtermdate | datetime | Newly updated termination date |
| Newoffboardingdate | datetime | Newly updated offboarding date |
| HWF_Process_name | varchar(100) | Human Workflow process name identifier |
| Derived_System_End_date | datetime | System-derived end date calculation |
| Cons_Ageing | int | Consultant aging in days |
| CP_Name | nvarchar(50) | Client Partner name |
| bill_st_units | varchar(50) | Billing straight time units |
| project_city | varchar(50) | City where project is located |
| project_state | varchar(50) | State where project is located |
| OpportunityID | varchar(50) | Unique opportunity identifier from CRM |
| OpportunityName | varchar(200) | Opportunity name from CRM system |
| Bus_days | real | Business days count |
| circle | varchar(100) | Circle or region classification |
| community_new | varchar(100) | Community classification for organizational structure |
| ALT | nvarchar(50) | Account Lead name |
| Market_Leader | varchar(max) | Market Leader name for the region |
| Acct_Owner | nvarchar(50) | Account Owner name |
| st_yymm | int | Start year-month in YYMM format |
| PortfolioLeader | varchar(max) | Portfolio Leader name |
| ClientPartner | varchar(max) | Client Partner name |
| FP_Proj_ID | varchar(10) | Financial Planning Project ID |
| FP_Proj_Name | varchar(max) | Financial Planning Project Name |
| FP_TM | varchar(2) | Financial Planning Time Material indicator |
| project_type | varchar(500) | Type of project classification |
| FP_Proj_Planned | varchar(10) | Financial Planning Project Planned indicator |
| Standard_Job_Title_Horizon | nvarchar(2000) | Standardized job title from Horizon system |
| Experience_Level_Title | varchar(200) | Experience level title classification |
| User_Name | varchar(50) | Username of the person who created or modified the record |
| Status | varchar(50) | Current status of the record |
| asstatus | varchar(50) | Assignment status |
| system_runtime | datetime | System runtime timestamp when record was processed |
| BR_Start_date | datetime | Bill Rate start date |
| Bill_ST | float | Bill straight time rate |
| Prev_BR | float | Previous bill rate |
| ProjType | varchar(2) | Project type code |
| Mons_in_Same_Rate | int | Number of months in same rate |
| Rate_Time_Gr | varchar(20) | Rate time group classification |
| Rate_Change_Type | varchar(20) | Type of rate change |
| Net_Addition | numeric(38,36) | Net addition to headcount |
| load_timestamp | datetime | Timestamp when record was loaded into Bronze layer |
| update_timestamp | datetime | Timestamp when record was last updated in Bronze layer |
| source_system | varchar(100) | Source system name from which data originated |

---

### Table: Bz_SchTask
**Description:** Bronze layer table capturing raw scheduled task data from source system, tracking workflow processes and task assignments.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| SSN | varchar(50) | Social Security Number of the employee |
| GCI_ID | varchar(50) | Global Consultant Identifier - unique employee identification number |
| FName | varchar(50) | Employee's first name |
| LName | varchar(50) | Employee's last name |
| Process_ID | numeric(18,0) | Unique identifier for the workflow process |
| Level_ID | int | Current level identifier in the workflow process |
| Last_Level | int | Last completed level in the workflow process |
| Initiator | varchar(50) | Name of the person who initiated the task |
| Initiator_Mail | varchar(50) | Email address of the task initiator |
| Status | varchar(50) | Current status of the scheduled task |
| Comments | varchar(8000) | Comments or notes associated with the task |
| DateCreated | datetime | Date and time when the task was created |
| TrackID | varchar(50) | Tracking identifier for the task |
| DateCompleted | datetime | Date and time when the task was completed |
| Existing_Resource | varchar(3) | Flag indicating if resource already exists |
| Term_ID | numeric(18,0) | Termination identifier if applicable |
| legal_entity | varchar(50) | Legal entity associated with the task |
| TS | timestamp | Timestamp for record versioning |
| load_timestamp | datetime | Timestamp when record was loaded into Bronze layer |
| update_timestamp | datetime | Timestamp when record was last updated in Bronze layer |
| source_system | varchar(100) | Source system name from which data originated |

---

### Table: Bz_Hiring_Initiator_Project_Info
**Description:** Bronze layer table capturing raw hiring and project information data, containing comprehensive candidate and project details.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Candidate_LName | varchar(50) | Candidate's last name |
| Candidate_MI | varchar(50) | Candidate's middle initial |
| Candidate_FName | varchar(50) | Candidate's first name |
| Candidate_SSN | varchar(50) | Candidate's Social Security Number |
| HR_Candidate_JobTitle | varchar(50) | Job title for the candidate position |
| HR_Candidate_JobDescription | varchar(100) | Job description for the candidate position |
| HR_Candidate_DOB | varchar(50) | Candidate's date of birth |
| HR_Candidate_Employee_Type | varchar(50) | Type of employment (Full-time, Part-time, Contract) |
| HR_Project_Referred_By | varchar(50) | Name of person who referred the candidate |
| HR_Project_Referral_Fees | varchar(50) | Referral fees amount if applicable |
| HR_Project_Referral_Units | varchar(50) | Units for referral fees calculation |
| HR_Relocation_Request | varchar(50) | Relocation request indicator |
| HR_Relocation_departure_city | varchar(50) | Departure city for relocation |
| HR_Relocation_departure_state | varchar(50) | Departure state for relocation |
| HR_Relocation_departure_airport | varchar(50) | Departure airport code |
| HR_Relocation_departure_date | varchar(50) | Departure date for relocation |
| HR_Relocation_departure_time | varchar(50) | Departure time for relocation |
| HR_Relocation_arrival_city | varchar(50) | Arrival city for relocation |
| HR_Relocation_arrival_state | varchar(50) | Arrival state for relocation |
| HR_Relocation_arrival_airport | varchar(50) | Arrival airport code |
| HR_Relocation_arrival_date | varchar(50) | Arrival date for relocation |
| HR_Relocation_arrival_time | varchar(50) | Arrival time for relocation |
| HR_Relocation_AccomodationStartDate | varchar(50) | Accommodation start date |
| HR_Relocation_AccomodationEndDate | varchar(50) | Accommodation end date |
| HR_Relocation_AccomodationStartTime | varchar(50) | Accommodation start time |
| HR_Relocation_AccomodationEndTime | varchar(50) | Accommodation end time |
| HR_Relocation_CarPickup_Place | varchar(50) | Car pickup location name |
| HR_Relocation_CarPickup_AddressLine1 | varchar(50) | Car pickup address line 1 |
| HR_Relocation_CarPickup_AddressLine2 | varchar(50) | Car pickup address line 2 |
| HR_Relocation_CarPickup_City | varchar(50) | Car pickup city |
| HR_Relocation_CarPickup_State | varchar(50) | Car pickup state |
| HR_Relocation_CarPickup_Zip | varchar(50) | Car pickup zip code |
| HR_Relocation_CarReturn_City | varchar(50) | Car return city |
| HR_Relocation_CarReturn_State | varchar(50) | Car return state |
| HR_Relocation_CarReturn_Place | varchar(50) | Car return location name |
| HR_Relocation_CarReturn_AddressLine1 | varchar(50) | Car return address line 1 |
| HR_Relocation_CarReturn_AddressLine2 | varchar(50) | Car return address line 2 |
| HR_Relocation_CarReturn_Zip | varchar(50) | Car return zip code |
| HR_Relocation_RentalCarStartDate | varchar(50) | Rental car start date |
| HR_Relocation_RentalCarEndDate | varchar(50) | Rental car end date |
| HR_Relocation_RentalCarStartTime | varchar(50) | Rental car start time |
| HR_Relocation_RentalCarEndTime | varchar(50) | Rental car end time |
| HR_Relocation_MaxClientInvoice | varchar(50) | Maximum client invoice amount for relocation |
| HR_Relocation_approving_manager | varchar(50) | Manager approving the relocation |
| HR_Relocation_Notes | varchar(5000) | Additional notes for relocation |
| HR_Recruiting_Manager | varchar(50) | Recruiting manager name |
| HR_Recruiting_AccountExecutive | varchar(50) | Account executive name |
| HR_Recruiting_Recruiter | varchar(50) | Recruiter name |
| HR_Recruiting_ResourceManager | varchar(50) | Resource manager name |
| HR_Recruiting_Office | varchar(50) | Recruiting office location |
| HR_Recruiting_ReqNo | varchar(100) | Requisition number |
| HR_Recruiting_Direct | varchar(50) | Direct recruiting indicator |
| HR_Recruiting_Replacement_For_GCIID | varchar(50) | GCI ID of person being replaced |
| HR_Recruiting_Replacement_For | varchar(50) | Name of person being replaced |
| HR_Recruiting_Replacement_Reason | varchar(50) | Reason for replacement |
| HR_ClientInfo_ID | varchar(50) | Client information identifier |
| HR_ClientInfo_Name | varchar(60) | Client name |
| HR_ClientInfo_DNB | varchar(50) | Dun & Bradstreet number |
| HR_ClientInfo_Sector | varchar(50) | Client industry sector |
| HR_ClientInfo_Manager_ID | varchar(50) | Client manager identifier |
| HR_ClientInfo_Manager | varchar(50) | Client manager name |
| HR_ClientInfo_Phone | varchar(50) | Client phone number |
| HR_ClientInfo_Phone_Extn | varchar(50) | Client phone extension |
| HR_ClientInfo_Email | varchar(50) | Client email address |
| HR_ClientInfo_Fax | varchar(50) | Client fax number |
| HR_ClientInfo_Cell | varchar(50) | Client cell phone number |
| HR_ClientInfo_Pager | varchar(50) | Client pager number |
| HR_ClientInfo_Pager_Pin | varchar(50) | Client pager PIN |
| HR_ClientAgreements_SendTo | varchar(50) | Name of person to send agreements to |
| HR_ClientAgreements_Phone | varchar(50) | Phone number for agreements contact |
| HR_ClientAgreements_Phone_Extn | varchar(50) | Phone extension for agreements contact |
| HR_ClientAgreements_Email | varchar(50) | Email for agreements contact |
| HR_ClientAgreements_Fax | varchar(50) | Fax number for agreements contact |
| HR_ClientAgreements_Cell | varchar(50) | Cell phone for agreements contact |
| HR_ClientAgreements_Pager | varchar(50) | Pager number for agreements contact |
| HR_ClientAgreements_Pager_Pin | varchar(50) | Pager PIN for agreements contact |
| HR_Project_SendInvoicesTo | varchar(100) | Name of person to send invoices to |
| HR_Project_AddressToSend1 | varchar(150) | Invoice address line 1 |
| HR_Project_AddressToSend2 | varchar(150) | Invoice address line 2 |
| HR_Project_City | varchar(50) | Invoice city |
| HR_Project_State | varchar(50) | Invoice state |
| HR_Project_Zip | varchar(50) | Invoice zip code |
| HR_Project_Phone | varchar(50) | Project contact phone number |
| HR_Project_Phone_Extn | varchar(50) | Project contact phone extension |
| HR_Project_Email | varchar(50) | Project contact email |
| HR_Project_Fax | varchar(50) | Project contact fax number |
| HR_Project_Cell | varchar(50) | Project contact cell phone |
| HR_Project_Pager | varchar(50) | Project contact pager number |
| HR_Project_Pager_Pin | varchar(50) | Project contact pager PIN |
| HR_Project_ST | varchar(50) | Project straight time rate |
| HR_Project_OT | varchar(50) | Project overtime rate |
| HR_Project_ST_Off | varchar(50) | Project straight time offshore rate |
| HR_Project_OT_Off | varchar(50) | Project overtime offshore rate |
| HR_Project_ST_Units | varchar(50) | Project straight time units |
| HR_Project_OT_Units | varchar(50) | Project overtime units |
| HR_Project_ST_Off_Units | varchar(50) | Project straight time offshore units |
| HR_Project_OT_Off_Units | varchar(50) | Project overtime offshore units |
| HR_Project_StartDate | varchar(50) | Project start date |
| HR_Project_EndDate | varchar(50) | Project end date |
| HR_Project_Location_AddressLine1 | varchar(50) | Project location address line 1 |
| HR_Project_Location_AddressLine2 | varchar(50) | Project location address line 2 |
| HR_Project_Location_City | varchar(50) | Project location city |
| HR_Project_Location_State | varchar(50) | Project location state |
| HR_Project_Location_Zip | varchar(50) | Project location zip code |
| HR_Project_InvoicingTerms | varchar(50) | Invoicing terms for the project |
| HR_Project_PaymentTerms | varchar(50) | Payment terms for the project |
| HR_Project_EndClient_ID | varchar(50) | End client identifier |
| HR_Project_EndClient_Name | varchar(60) | End client name |
| HR_Project_EndClient_Sector | varchar(50) | End client industry sector |
| HR_Accounts_Person | varchar(50) | Accounts contact person name |
| HR_Accounts_PhoneNo | varchar(50) | Accounts contact phone number |
| HR_Accounts_PhoneNo_Extn | varchar(50) | Accounts contact phone extension |
| HR_Accounts_Email | varchar(50) | Accounts contact email |
| HR_Accounts_FaxNo | varchar(50) | Accounts contact fax number |
| HR_Accounts_Cell | varchar(50) | Accounts contact cell phone |
| HR_Accounts_Pager | varchar(50) | Accounts contact pager number |
| HR_Accounts_Pager_Pin | varchar(50) | Accounts contact pager PIN |
| HR_Project_Referrer_ID | varchar(50) | Project referrer identifier |
| UserCreated | varchar(50) | Username of person who created the record |
| DateCreated | varchar(50) | Date when record was created |
| HR_Week_Cycle | int | Week cycle for HR processing |
| Project_Name | varchar(255) | Project name |
| transition | varchar(50) | Transition indicator |
| Is_OT_Allowed | varchar(50) | Overtime allowed indicator |
| HR_Business_Type | varchar(50) | HR business type classification |
| WebXl_EndClient_ID | varchar(50) | WebXL end client identifier |
| WebXl_EndClient_Name | varchar(60) | WebXL end client name |
| Client_Offer_Acceptance_Date | varchar(50) | Date client offer was accepted |
| Project_Type | varchar(50) | Type of project |
| req_division | varchar(200) | Requisition division |
| Client_Compliance_Checks_Reqd | varchar(50) | Client compliance checks required indicator |
| HSU | varchar(50) | Horizontal Service Unit |
| HSUDM | varchar(50) | Horizontal Service Unit Delivery Manager |
| Payroll_Location | varchar(50) | Payroll processing location |
| Is_DT_Allowed | varchar(50) | Double time allowed indicator |
| SBU | varchar(2) | Strategic Business Unit |
| BU | varchar(50) | Business Unit |
| Dept | varchar(2) | Department code |
| HCU | varchar(50) | Horizontal Capability Unit |
| Project_Category | varchar(50) | Project category classification |
| Delivery_Model | varchar(50) | Delivery model type |
| BPOS_Project | varchar(3) | BPOS project indicator |
| ER_Person | varchar(50) | Employee Relations person name |
| Print_Invoice_Address1 | varchar(100) | Print invoice address line 1 |
| Print_Invoice_Address2 | varchar(100) | Print invoice address line 2 |
| Print_Invoice_City | varchar(50) | Print invoice city |
| Print_Invoice_State | varchar(50) | Print invoice state |
| Print_Invoice_Zip | varchar(50) | Print invoice zip code |
| Mail_Invoice_Address1 | varchar(100) | Mail invoice address line 1 |
| Mail_Invoice_Address2 | varchar(100) | Mail invoice address line 2 |
| Mail_Invoice_City | varchar(50) | Mail invoice city |
| Mail_Invoice_State | varchar(50) | Mail invoice state |
| Mail_Invoice_Zip | varchar(50) | Mail invoice zip code |
| Project_Zone | varchar(50) | Project zone classification |
| Emp_Identifier | varchar(50) | Employee identifier |
| CRE_Person | varchar(50) | CRE person name |
| HR_Project_Location_Country | varchar(50) | Project location country |
| Agency | varchar(50) | Agency name |
| pwd | varchar(50) | Password or PWD indicator |
| PES_Doc_Sent | varchar(50) | PES document sent indicator |
| PES_Confirm_Doc_Rcpt | varchar(50) | PES confirm document receipt indicator |
| PES_Clearance_Rcvd | varchar(50) | PES clearance received indicator |
| PES_Doc_Sent_Date | varchar(50) | PES document sent date |
| PES_Confirm_Doc_Rcpt_Date | varchar(50) | PES confirm document receipt date |
| PES_Clearance_Rcvd_Date | varchar(50) | PES clearance received date |
| Inv_Pay_Terms_Notes | text | Invoice payment terms notes |
| CBC_Notes | text | CBC notes |
| Benefits_Plan | varchar(50) | Benefits plan type |
| BillingCompany | varchar(50) | Billing company name |
| SPINOFF_CPNY | varchar(50) | Spinoff company name |
| Position_Type | varchar(50) | Position type classification |
| I9_Approver | varchar(50) | I9 form approver name |
| FP_BILL_Rate | varchar(50) | Financial planning bill rate |
| TSLead | varchar(50) | Technical Sales Lead name |
| Inside_Sales | varchar(50) | Inside Sales person name |
| Markup | varchar(50) | Markup percentage |
| Maximum_Allowed_Markup | varchar(50) | Maximum allowed markup percentage |
| Actual_Markup | varchar(50) | Actual markup percentage |
| SCA_Hourly_Bill_Rate | varchar(50) | SCA hourly bill rate |
| HR_Project_StartDate_Change_Reason | varchar(100) | Reason for project start date change |
| source | varchar(50) | Source system identifier |
| HR_Recruiting_VMO | varchar(50) | VMO name |
| HR_Recruiting_Inside_Sales | varchar(50) | Inside Sales person name |
| HR_Recruiting_TL | varchar(50) | Team Lead name |
| HR_Recruiting_NAM | varchar(50) | National Account Manager name |
| HR_Recruiting_ARM | varchar(50) | Account Relationship Manager name |
| HR_Recruiting_RM | varchar(50) | Recruiting Manager name |
| HR_Recruiting_ReqID | varchar(50) | Recruiting requisition ID |
| HR_Recruiting_TAG | varchar(50) | Recruiting tag |
| DateUpdated | varchar(50) | Date when record was updated |
| UserUpdated | varchar(50) | Username of person who updated the record |
| Is_Swing_Shift_Associated_With_It | varchar(50) | Swing shift association indicator |
| FP_Bill_Rate_OT | varchar(50) | Financial planning bill rate overtime |
| Not_To_Exceed_YESNO | varchar(10) | Not to exceed indicator |
| Exceed_YESNO | varchar(10) | Exceed indicator |
| Is_OT_Billable | varchar(5) | Overtime billable indicator |
| Is_premium_project_Associated_With_It | varchar(50) | Premium project association indicator |
| ITSS_Business_Development_Manager | varchar(50) | ITSS Business Development Manager name |
| Practice_type | varchar(50) | Practice type classification |
| Project_billing_type | varchar(50) | Project billing type |
| Resource_billing_type | varchar(50) | Resource billing type |
| Type_Consultant_category | varchar(50) | Type of consultant category |
| Unique_identification_ID_Doc | varchar(100) | Unique identification document |
| Region1 | varchar(100) | Primary region |
| Region2 | varchar(100) | Secondary region |
| Region1_percentage | varchar(10) | Primary region percentage |
| Region2_percentage | varchar(10) | Secondary region percentage |
| Soc_Code | varchar(300) | Standard Occupational Classification code |
| Soc_Desc | varchar(300) | Standard Occupational Classification description |
| req_duration | int | Requisition duration in days |
| Non_Billing_Type | varchar(50) | Non-billing type classification |
| Worker_Entity_ID | varchar(30) | Worker entity identifier |
| OraclePersonID | varchar(30) | Oracle person identifier |
| Collabera_Email_ID | varchar(100) | Collabera email address |
| Onsite_Consultant_Relationship_Manager | varchar(50) | Onsite consultant relationship manager name |
| HR_project_county | varchar(100) | Project county location |
| EE_WF_Reasons | varchar(50) | Employee workflow reasons |
| GradeName | varchar(50) | Grade name classification |
| ROLEFAMILY | varchar(50) | Role family classification |
| SUBDEPARTMENT | varchar(100) | Sub-department name |
| MSProjectType | varchar(50) | Microsoft Project type |
| NetsuiteProjectId | varchar(50) | NetSuite project identifier |
| NetsuiteCreatedDate | varchar(50) | NetSuite created date |
| NetsuiteModifiedDate | varchar(50) | NetSuite modified date |
| StandardJobTitle | varchar(100) | Standard job title |
| community | varchar(100) | Community classification |
| parent_Account_name | varchar(100) | Parent account name |
| Timesheet_Manager | varchar(255) | Timesheet manager name |
| TimeSheetManagerType | varchar(255) | Timesheet manager type |
| Timesheet_Manager_Phone | varchar(255) | Timesheet manager phone number |
| Timesheet_Manager_Email | varchar(255) | Timesheet manager email address |
| HR_Project_Major_Group | varchar(255) | Project major group classification |
| HR_Project_Minor_Group | varchar(255) | Project minor group classification |
| HR_Project_Broad_Group | varchar(255) | Project broad group classification |
| HR_Project_Detail_Group | varchar(255) | Project detail group classification |
| 9Hours_Allowed | varchar(3) | Nine hours allowed indicator |
| 9Hours_Effective_Date | varchar(50) | Nine hours effective date |
| load_timestamp | datetime | Timestamp when record was loaded into Bronze layer |
| update_timestamp | datetime | Timestamp when record was last updated in Bronze layer |
| source_system | varchar(100) | Source system name from which data originated |

---

### Table: Bz_Timesheet_New
**Description:** Bronze layer table capturing raw timesheet data from source system, tracking employee time entries across various categories.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| gci_id | INT | Global Consultant Identifier - unique employee identification number |
| pe_date | DATETIME | Period end date for the timesheet entry |
| task_id | NUMERIC(18,9) | Task identifier for the timesheet entry |
| c_date | DATETIME | Creation date of the timesheet entry |
| ST | FLOAT | Straight Time hours worked |
| OT | FLOAT | Overtime hours worked |
| TIME_OFF | FLOAT | Time off hours taken |
| HO | FLOAT | Holiday hours |
| DT | FLOAT | Double time hours worked |
| NON_ST | FLOAT | Non-billable straight time hours |
| NON_OT | FLOAT | Non-billable overtime hours |
| Sick_Time | FLOAT | Sick time hours taken |
| NON_Sick_Time | FLOAT | Non-billable sick time hours |
| NON_DT | FLOAT | Non-billable double time hours |
| load_timestamp | datetime | Timestamp when record was loaded into Bronze layer |
| update_timestamp | datetime | Timestamp when record was last updated in Bronze layer |
| source_system | varchar(100) | Source system name from which data originated |

---

### Table: Bz_report_392_all
**Description:** Bronze layer table capturing raw comprehensive report data from source system, containing detailed employee, project, and financial information.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| id | NUMERIC(18,9) | Unique record identifier |
| gci_id | VARCHAR(50) | Global Consultant Identifier - unique employee identification number |
| first_name | VARCHAR(50) | Employee's first name |
| last_name | VARCHAR(50) | Employee's last name |
| employee_type | VARCHAR(8000) | Type of employment classification |
| recruiting_manager | VARCHAR(50) | Recruiting manager name |
| resource_manager | VARCHAR(50) | Resource manager name |
| salesrep | VARCHAR(50) | Sales representative name |
| inside_sales | VARCHAR(50) | Inside sales person name |
| recruiter | VARCHAR(50) | Recruiter name |
| req_type | VARCHAR(50) | Requisition type |
| ms_type | VARCHAR(28) | Microsoft type classification |
| client_code | VARCHAR(50) | Client code identifier |
| client_name | VARCHAR(60) | Client name |
| client_type | VARCHAR(50) | Client type classification |
| job_title | VARCHAR(50) | Job title |
| bill_st | VARCHAR(50) | Bill straight time rate |
| visa_type | VARCHAR(50) | Visa type classification |
| bill_st_units | VARCHAR(50) | Bill straight time units |
| salary | MONEY | Salary amount |
| salary_units | VARCHAR(50) | Salary units |
| pay_st | FLOAT | Pay straight time rate |
| pay_st_units | VARCHAR(50) | Pay straight time units |
| start_date | DATETIME | Start date |
| end_date | DATETIME | End date |
| po_start_date | VARCHAR(50) | Purchase order start date |
| po_end_date | VARCHAR(50) | Purchase order end date |
| project_city | VARCHAR(50) | Project city location |
| project_state | VARCHAR(50) | Project state location |
| no_of_free_hours | VARCHAR(50) | Number of free hours |
| hr_business_type | VARCHAR(50) | HR business type classification |
| ee_wf_reason | VARCHAR(50) | Employee workflow reason |
| singleman_company | VARCHAR(50) | Singleman company name |
| status | VARCHAR(50) | Status of the record |
| termination_reason | VARCHAR(100) | Termination reason |
| wf_created_on | DATETIME | Workflow created on date |
| hcu | VARCHAR(50) | Horizontal Capability Unit |
| hsu | VARCHAR(50) | Horizontal Service Unit |
| project_zip | VARCHAR(50) | Project zip code |
| cre_person | VARCHAR(50) | CRE person name |
| assigned_hsu | VARCHAR(10) | Assigned HSU |
| req_category | VARCHAR(50) | Requisition category |
| gpm | MONEY | Gross profit margin amount |
| gp | MONEY | Gross profit amount |
| aca_cost | REAL | ACA cost |
| aca_classification | VARCHAR(50) | ACA classification |
| markup | VARCHAR(3) | Markup indicator |
| actual_markup | VARCHAR(50) | Actual markup percentage |
| maximum_allowed_markup | VARCHAR(50) | Maximum allowed markup percentage |
| submitted_bill_rate | MONEY | Submitted bill rate |
| req_division | VARCHAR(200) | Requisition division |
| pay_rate_to_consultant | VARCHAR(50) | Pay rate to consultant |
| location | VARCHAR(50) | Location |
| rec_region | VARCHAR(50) | Recruiting region |
| client_region | VARCHAR(50) | Client region |
| dm | VARCHAR(50) | Delivery Manager name |
| delivery_director | VARCHAR(50) | Delivery Director name |
| bu | VARCHAR(50) | Business Unit |
| es | VARCHAR(50) | Enterprise Services |
| nam | VARCHAR(50) | National Account Manager name |
| client_sector | VARCHAR(50) | Client sector |
| skills | VARCHAR(2500) | Skills list |
| pskills | VARCHAR(4000) | Primary skills list |
| business_manager | NVARCHAR(MAX) | Business Manager name |
| vmo | VARCHAR(50) | VMO name |
| rec_name | VARCHAR(500) | Recruiter name |
| Req_ID | NUMERIC(18,9) | Requisition identifier |
| received | DATETIME | Received date |
| Submitted | DATETIME | Submitted date |
| responsetime | VARCHAR(53) | Response time |
| Inhouse | VARCHAR(3) | In-house indicator |
| Net_Bill_Rate | MONEY | Net bill rate |
| Loaded_Pay_Rate | MONEY | Loaded pay rate |
| NSO | VARCHAR(100) | NSO classification |
| ESG_Vertical | VARCHAR(100) | ESG vertical |
| ESG_Industry | VARCHAR(100) | ESG industry |
| ESG_DNA | VARCHAR(100) | ESG DNA |
| ESG_NAM1 | VARCHAR(100) | ESG NAM level 1 |
| ESG_NAM2 | VARCHAR(100) | ESG NAM level 2 |
| ESG_NAM3 | VARCHAR(100) | ESG NAM level 3 |
| ESG_SAM | VARCHAR(100) | ESG SAM |
| ESG_ES | VARCHAR(100) | ESG ES |
| ESG_BU | VARCHAR(100) | ESG BU |
| SUB_GPM | MONEY | Sub gross profit margin |
| manager_id | NUMERIC(18,9) | Manager identifier |
| Submitted_By | VARCHAR(50) | Submitted by name |
| HWF_Process_name | VARCHAR(100) | Human workflow process name |
| Transition | VARCHAR(100) | Transition indicator |
| ITSS | VARCHAR(100) | IT Staffing Services classification |
| GP2020 | MONEY | Gross profit 2020 |
| GPM2020 | MONEY | Gross profit margin 2020 |
| isbulk | BIT | Is bulk indicator |
| jump | BIT | Jump indicator |
| client_class | VARCHAR(20) | Client class |
| MSP | VARCHAR(50) | Managed Service Provider |
| DTCUChoice1 | VARCHAR(60) | DTCU choice 1 |
| SubCat | VARCHAR(60) | Sub-category |
| IsClassInitiative | BIT | Is class initiative indicator |
| division | VARCHAR(50) | Division |
| divstart_date | DATETIME | Division start date |
| divend_date | DATETIME | Division end date |
| tl | VARCHAR(50) | Team Lead name |
| resource_manager | VARCHAR(50) | Resource manager name |
| recruiting_manager | VARCHAR(50) | Recruiting manager name |
| VAS_Type | VARCHAR(100) | Value Added Services type |
| BUCKET | VARCHAR(50) | Bucket classification |
| RTR_DM | VARCHAR(50) | RTR Delivery Manager |
| ITSSProjectName | VARCHAR(200) | ITSS project name |
| RegionGroup | VARCHAR(50) | Region group |
| client_Markup | VARCHAR(20) | Client markup |
| Subtier | VARCHAR(50) | Sub-tier classification |
| Subtier_Address1 | VARCHAR(50) | Sub-tier address line 1 |
| Subtier_Address2 | VARCHAR(50) | Sub-tier address line 2 |
| Subtier_City | VARCHAR(50) | Sub-tier city |
| Subtier_State | VARCHAR(50) | Sub-tier state |
| Hiresource | VARCHAR(100) | Hire source |
| is_Hotbook_Hire | INT | Is hotbook hire indicator |
| Client_RM | VARCHAR(50) | Client Relationship Manager name |
| Job_Description | VARCHAR(100) | Job description |
| Client_Manager | VARCHAR(50) | Client Manager name |
| end_date_at_client | DATETIME | End date at client |
| term_date | DATETIME | Termination date |
| employee_status | VARCHAR(50) | Employee status |
| Level_ID | INT | Level identifier |
| OpsGrp | VARCHAR(50) | Operations group |
| Level_Name | VARCHAR(50) | Level name |
| Min_levelDatetime | DATETIME | Minimum level datetime |
| Max_levelDatetime | DATETIME | Maximum level datetime |
| First_Interview_date | DATETIME | First interview date |
| Is_REC_CES | VARCHAR(5) | Is recruiting CES indicator |
| Is_CES_Initiative | VARCHAR(5) | Is CES initiative indicator |
| VMO_Access | VARCHAR(50) | VMO access |
| Billing_Type | VARCHAR(50) | Billing type |
| VASSOW | VARCHAR(3) | VAS SOW indicator |
| Worker_Entity_ID | VARCHAR(30) | Worker entity identifier |
| Circle | VARCHAR(50) | Circle classification |
| VMO_Access1 | VARCHAR(50) | VMO access level 1 |
| VMO_Access2 | VARCHAR(50) | VMO access level 2 |
| VMO_Access3 | VARCHAR(50) | VMO access level 3 |
| VMO_Access4 | VARCHAR(50) | VMO access level 4 |
| Inside_Sales_Person | VARCHAR(50) | Inside Sales person name |
| admin_1701 | VARCHAR(50) | Administrator 1701 |
| corrected_staffadmin_1701 | VARCHAR(50) | Corrected staff administrator 1701 |
| HR_Billing_Placement_Net_Fee | MONEY | HR billing placement net fee |
| New_Visa_type | VARCHAR(50) | New visa type |
| newenddate | DATETIME | New end date |
| Newoffboardingdate | DATETIME | New offboarding date |
| NewTermdate | DATETIME | New termination date |
| newhrisenddate | DATETIME | New HRIS end date |
| rtr_location | VARCHAR(50) | RTR location |
| HR_Recruiting_TL | VARCHAR(100) | HR recruiting team lead |
| client_entity | VARCHAR(50) | Client entity |
| client_consent | BIT | Client consent indicator |
| Ascendion_MetalReqID | NUMERIC(18,9) | Ascendion Metal requisition ID |
| eeo | VARCHAR(200) | Equal Employment Opportunity data |
| veteran | VARCHAR(150) | Veteran status |
| Gender | VARCHAR(50) | Gender |
| Er_person | VARCHAR(50) | Employee Relations person name |
| wfmetaljobdescription | NVARCHAR(MAX) | Workflow metal job description |
| HR_Candidate_Salary | MONEY | HR candidate salary |
| Interview_CreatedDate | DATETIME | Interview created date |
| Interview_on_Date | DATETIME | Interview on date |
| IS_SOW | VARCHAR(7) | Is Statement of Work indicator |
| IS_Offshore | VARCHAR(20) | Is offshore indicator |
| New_VAS | VARCHAR(4) | New Value Added Services |
| VerticalName | NVARCHAR(510) | Vertical name |
| Client_Group1 | VARCHAR(19) | Client group 1 |
| Billig_Type | VARCHAR(8) | Billing type |
| Super_Merged_Name | VARCHAR(200) | Super merged name |
| New_Category | VARCHAR(11) | New category |
| New_business_type | VARCHAR(100) | New business type |
| OpportunityID | VARCHAR(50) | Opportunity identifier |
| OpportunityName | VARCHAR(200) | Opportunity name |
| Ms_ProjectId | INT | Microsoft Project identifier |
| MS_ProjectName | VARCHAR(200) | Microsoft Project name |
| ORC_ID | VARCHAR(30) | ORC identifier |
| Market_Leader | NVARCHAR(MAX) | Market Leader name |
| Circle_Metal | VARCHAR(100) | Circle metal classification |
| Community_New_Metal | VARCHAR(100) | Community new metal classification |
| Employee_Category | VARCHAR(50) | Employee category |
| IsBillRateSkip | BIT | Is bill rate skip indicator |
| BillRate | DECIMAL(18,9) | Bill rate |
| RoleFamily | VARCHAR(300) | Role family |
| SubRoleFamily | VARCHAR(300) | Sub-role family |
| Standard_JobTitle | VARCHAR(500) | Standard job title |
| ClientInterviewRequired | INT | Client interview required indicator |
| Redeploymenthire | INT | Redeployment hire indicator |
| HRBrandLevelId | INT | HR brand level identifier |
| HRBandTitle | VARCHAR(300) | HR band title |
| latest_termination_reason | VARCHAR(200) | Latest termination reason |
| latest_termination_date | DATETIME | Latest termination date |
| Community | VARCHAR(100) | Community |
| ReqFulfillmentReason | VARCHAR(200) | Requisition fulfillment reason |
| EngagementType | VARCHAR(500) | Engagement type |
| RedepLedBy | VARCHAR(200) | Redeployment led by |
| Can_ExperienceLevelTitle | VARCHAR(200) | Candidate experience level title |
| Can_StandardJobTitleHorizon | NVARCHAR(4000) | Candidate standard job title horizon |
| CandidateEmail | VARCHAR(100) | Candidate email address |
| Offboarding_Reason | VARCHAR(100) | Offboarding reason |
| Offboarding_Initiated | DATETIME | Offboarding initiated date |
| Offboarding_Status | VARCHAR(100) | Offboarding status |
| replcament_GCIID | INT | Replacement GCI ID |
| replcament_EmployeeName | VARCHAR(500) | Replacement employee name |
| Senior_Manager | VARCHAR(50) | Senior Manager name |
| Associate_Manager | VARCHAR(50) | Associate Manager name |
| Director_Talent_Engine | VARCHAR(50) | Director Talent Engine name |
| Manager | VARCHAR(50) | Manager name |
| Rec_ExperienceLevelTitle | VARCHAR(200) | Recruiting experience level title |
| Rec_StandardJobTitleHorizon | NVARCHAR(4000) | Recruiting standard job title horizon |
| Task_Id | INT | Task identifier |
| proj_ID | VARCHAR(50) | Project identifier |
| Projdesc | CHAR(60) | Project description |
| Client_Group | VARCHAR(19) | Client group |
| billST_New | FLOAT | Bill straight time new |
| Candidate_city | VARCHAR(50) | Candidate city |
| Candidate_State | VARCHAR(50) | Candidate state |
| C2C_W2_FTE | VARCHAR(13) | C2C W2 FTE classification |
| FP_TM | VARCHAR(2) | Financial planning time material |
| load_timestamp | datetime | Timestamp when record was loaded into Bronze layer |
| update_timestamp | datetime | Timestamp when record was last updated in Bronze layer |
| source_system | varchar(100) | Source system name from which data originated |

---

### Table: Bz_vw_billing_timesheet_daywise_ne
**Description:** Bronze layer table capturing raw billing timesheet daywise data from source system, tracking approved hours by category.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| ID | numeric(18,9) | Unique identifier for the timesheet record |
| GCI_ID | int | Global Consultant Identifier - unique employee identification number |
| PE_DATE | datetime | Period end date for the timesheet entry |
| WEEK_DATE | datetime | Week date for the timesheet entry |
| BILLABLE | varchar(3) | Billable indicator flag |
| Approved_hours_ST | float | Approved straight time hours |
| Approved_hours_Non_ST | float | Approved non-billable straight time hours |
| Approved_hours_OT | float | Approved overtime hours |
| Approved_hours_Non_OT | float | Approved non-billable overtime hours |
| Approved_hours_DT | float | Approved double time hours |
| Approved_hours_Non_DT | float | Approved non-billable double time hours |
| Approved_hours_Sick_Time | float | Approved sick time hours |
| Approved_hours_Non_Sick_Time | float | Approved non-billable sick time hours |
| load_timestamp | datetime | Timestamp when record was loaded into Bronze layer |
| update_timestamp | datetime | Timestamp when record was last updated in Bronze layer |
| source_system | varchar(100) | Source system name from which data originated |

---

### Table: Bz_vw_consultant_timesheet_daywise
**Description:** Bronze layer table capturing raw consultant timesheet daywise data from source system, tracking consultant-submitted hours.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| ID | numeric(18,9) | Unique identifier for the timesheet record |
| GCI_ID | int | Global Consultant Identifier - unique employee identification number |
| PE_DATE | datetime | Period end date for the timesheet entry |
| WEEK_DATE | datetime | Week date for the timesheet entry |
| BILLABLE | varchar(3) | Billable indicator flag |
| Consultant_hours_ST | float | Consultant-submitted straight time hours |
| Consultant_hours_OT | float | Consultant-submitted overtime hours |
| Consultant_hours_DT | float | Consultant-submitted double time hours |
| load_timestamp | datetime | Timestamp when record was loaded into Bronze layer |
| update_timestamp | datetime | Timestamp when record was last updated in Bronze layer |
| source_system | varchar(100) | Source system name from which data originated |

---

### Table: Bz_DimDate
**Description:** Bronze layer table capturing raw date dimension data from source system, providing comprehensive date attributes for time-based analysis.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Date | datetime | Full date value |
| DayOfMonth | varchar(2) | Day of the month (1-31) |
| DayName | varchar(9) | Name of the day (Monday, Tuesday, etc.) |
| WeekOfYear | varchar(2) | Week number of the year (1-52) |
| Month | varchar(2) | Month number (1-12) |
| MonthName | varchar(9) | Name of the month (January, February, etc.) |
| MonthOfQuarter | varchar(2) | Month number within the quarter (1-3) |
| Quarter | char(1) | Quarter number (1-4) |
| QuarterName | varchar(9) | Quarter name (Q1, Q2, Q3, Q4) |
| Year | char(4) | Four-digit year |
| YearName | char(7) | Year name with prefix |
| MonthYear | char(10) | Month and year combination |
| MMYYYY | char(6) | Month and year in MMYYYY format |
| DaysInMonth | int | Number of days in the month |
| MM_YYYY | varchar(10) | Month and year in MM-YYYY format |
| YYYYMM | varchar(10) | Year and month in YYYYMM format |
| load_timestamp | datetime | Timestamp when record was loaded into Bronze layer |
| update_timestamp | datetime | Timestamp when record was last updated in Bronze layer |
| source_system | varchar(100) | Source system name from which data originated |

---

### Table: Bz_holidays_Mexico
**Description:** Bronze layer table capturing raw Mexico holiday data from source system, containing holiday dates and descriptions for Mexico location.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Holiday_Date | datetime | Date of the holiday |
| Description | varchar(50) | Description of the holiday |
| Location | varchar(10) | Location identifier for the holiday (Mexico) |
| Source_type | varchar(50) | Source type of the holiday data |
| load_timestamp | datetime | Timestamp when record was loaded into Bronze layer |
| update_timestamp | datetime | Timestamp when record was last updated in Bronze layer |
| source_system | varchar(100) | Source system name from which data originated |

---

### Table: Bz_holidays_Canada
**Description:** Bronze layer table capturing raw Canada holiday data from source system, containing holiday dates and descriptions for Canada location.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Holiday_Date | datetime | Date of the holiday |
| Description | varchar(100) | Description of the holiday |
| Location | varchar(10) | Location identifier for the holiday (Canada) |
| Source_type | varchar(50) | Source type of the holiday data |
| load_timestamp | datetime | Timestamp when record was loaded into Bronze layer |
| update_timestamp | datetime | Timestamp when record was last updated in Bronze layer |
| source_system | varchar(100) | Source system name from which data originated |

---

### Table: Bz_holidays
**Description:** Bronze layer table capturing raw holiday data from source system, containing general holiday dates and descriptions.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Holiday_Date | datetime | Date of the holiday |
| Description | varchar(50) | Description of the holiday |
| Location | varchar(10) | Location identifier for the holiday |
| Source_type | varchar(50) | Source type of the holiday data |
| load_timestamp | datetime | Timestamp when record was loaded into Bronze layer |
| update_timestamp | datetime | Timestamp when record was last updated in Bronze layer |
| source_system | varchar(100) | Source system name from which data originated |

---

### Table: Bz_holidays_India
**Description:** Bronze layer table capturing raw India holiday data from source system, containing holiday dates and descriptions for India location.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Holiday_Date | datetime | Date of the holiday |
| Description | varchar(50) | Description of the holiday |
| Location | varchar(10) | Location identifier for the holiday (India) |
| Source_type | varchar(50) | Source type of the holiday data |
| load_timestamp | datetime | Timestamp when record was loaded into Bronze layer |
| update_timestamp | datetime | Timestamp when record was last updated in Bronze layer |
| source_system | varchar(100) | Source system name from which data originated |

---

## 3. AUDIT TABLE DESIGN

### Table: Bz_Audit_Log
**Description:** Bronze layer audit table tracking all data loading and processing activities for compliance and troubleshooting purposes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| record_id | BIGINT | Unique identifier for each audit log entry, auto-incrementing |
| source_table | VARCHAR(200) | Name of the source table being processed |
| load_timestamp | DATETIME | Timestamp when the data load process started |
| processed_by | VARCHAR(100) | Username or service account that executed the data load |
| processing_time | DECIMAL(10,2) | Time taken to process the data load in seconds |
| status | VARCHAR(50) | Status of the data load (Success, Failed, Partial, In Progress) |
| records_processed | BIGINT | Number of records processed in the load |
| records_inserted | BIGINT | Number of records successfully inserted |
| records_updated | BIGINT | Number of records updated |
| records_failed | BIGINT | Number of records that failed to load |
| error_message | VARCHAR(MAX) | Error message if the load failed |
| source_file_path | VARCHAR(500) | Path to the source file or connection string |
| target_table | VARCHAR(200) | Name of the target Bronze layer table |
| load_type | VARCHAR(50) | Type of load (Full, Incremental, Delta) |
| batch_id | VARCHAR(100) | Batch identifier for grouping related loads |
| start_timestamp | DATETIME | Start timestamp of the process |
| end_timestamp | DATETIME | End timestamp of the process |
| row_count_source | BIGINT | Row count from source before processing |
| row_count_target | BIGINT | Row count in target after processing |
| data_quality_score | DECIMAL(5,2) | Data quality score percentage |
| validation_status | VARCHAR(50) | Validation status (Passed, Failed, Warning) |
| created_date | DATETIME | Date when audit record was created |
| modified_date | DATETIME | Date when audit record was last modified |

---

## 4. CONCEPTUAL DATA MODEL RELATIONSHIPS

### Table Relationships Overview

| Source Table | Related Table | Relationship Type | Key Field | Description |
|--------------|---------------|-------------------|-----------|-------------|
| Bz_New_Monthly_HC_Report | Bz_SchTask | One-to-Many | gci_id = GCI_ID | Links monthly HC report to scheduled tasks for the same employee |
| Bz_New_Monthly_HC_Report | Bz_Hiring_Initiator_Project_Info | One-to-One | gci_id = Worker_Entity_ID | Links monthly HC report to hiring and project information |
| Bz_New_Monthly_HC_Report | Bz_Timesheet_New | One-to-Many | gci_id = gci_id | Links monthly HC report to timesheet entries for the employee |
| Bz_New_Monthly_HC_Report | Bz_report_392_all | One-to-One | gci_id = gci_id | Links monthly HC report to comprehensive report data |
| Bz_New_Monthly_HC_Report | Bz_vw_billing_timesheet_daywise_ne | One-to-Many | gci_id = GCI_ID | Links monthly HC report to billing timesheet daywise data |
| Bz_New_Monthly_HC_Report | Bz_vw_consultant_timesheet_daywise | One-to-Many | gci_id = GCI_ID | Links monthly HC report to consultant timesheet daywise data |
| Bz_New_Monthly_HC_Report | Bz_DimDate | Many-to-One | start_date = Date | Links monthly HC report start date to date dimension |
| Bz_New_Monthly_HC_Report | Bz_DimDate | Many-to-One | termdate = Date | Links monthly HC report termination date to date dimension |
| Bz_SchTask | Bz_Hiring_Initiator_Project_Info | One-to-One | GCI_ID = Worker_Entity_ID | Links scheduled task to hiring and project information |
| Bz_SchTask | Bz_report_392_all | One-to-One | GCI_ID = gci_id | Links scheduled task to comprehensive report data |
| Bz_Hiring_Initiator_Project_Info | Bz_report_392_all | One-to-One | Worker_Entity_ID = gci_id | Links hiring project info to comprehensive report data |
| Bz_Hiring_Initiator_Project_Info | Bz_Timesheet_New | One-to-Many | Worker_Entity_ID = gci_id | Links hiring project info to timesheet entries |
| Bz_Timesheet_New | Bz_vw_billing_timesheet_daywise_ne | One-to-One | gci_id = GCI_ID AND pe_date = PE_DATE | Links timesheet to billing timesheet daywise view |
| Bz_Timesheet_New | Bz_vw_consultant_timesheet_daywise | One-to-One | gci_id = GCI_ID AND pe_date = PE_DATE | Links timesheet to consultant timesheet daywise view |
| Bz_Timesheet_New | Bz_DimDate | Many-to-One | pe_date = Date | Links timesheet period end date to date dimension |
| Bz_report_392_all | Bz_vw_billing_timesheet_daywise_ne | One-to-Many | gci_id = GCI_ID | Links comprehensive report to billing timesheet daywise data |
| Bz_report_392_all | Bz_vw_consultant_timesheet_daywise | One-to-Many | gci_id = GCI_ID | Links comprehensive report to consultant timesheet daywise data |
| Bz_report_392_all | Bz_DimDate | Many-to-One | start_date = Date | Links report start date to date dimension |
| Bz_report_392_all | Bz_DimDate | Many-to-One | end_date = Date | Links report end date to date dimension |
| Bz_vw_billing_timesheet_daywise_ne | Bz_DimDate | Many-to-One | PE_DATE = Date | Links billing timesheet period end date to date dimension |
| Bz_vw_billing_timesheet_daywise_ne | Bz_DimDate | Many-to-One | WEEK_DATE = Date | Links billing timesheet week date to date dimension |
| Bz_vw_consultant_timesheet_daywise | Bz_DimDate | Many-to-One | PE_DATE = Date | Links consultant timesheet period end date to date dimension |
| Bz_vw_consultant_timesheet_daywise | Bz_DimDate | Many-to-One | WEEK_DATE = Date | Links consultant timesheet week date to date dimension |
| Bz_New_Monthly_HC_Report | Bz_holidays | Many-to-Many | start_date to termdate range overlaps with Holiday_Date | Links employee work periods to applicable holidays |
| Bz_New_Monthly_HC_Report | Bz_holidays_Mexico | Many-to-Many | start_date to termdate range overlaps with Holiday_Date | Links employee work periods to Mexico holidays when location matches |
| Bz_New_Monthly_HC_Report | Bz_holidays_Canada | Many-to-Many | start_date to termdate range overlaps with Holiday_Date | Links employee work periods to Canada holidays when location matches |
| Bz_New_Monthly_HC_Report | Bz_holidays_India | Many-to-Many | start_date to termdate range overlaps with Holiday_Date | Links employee work periods to India holidays when location matches |
| Bz_Timesheet_New | Bz_holidays | Many-to-Many | pe_date = Holiday_Date | Links timesheet entries to holidays for holiday hour calculations |
| Bz_Timesheet_New | Bz_holidays_Mexico | Many-to-Many | pe_date = Holiday_Date | Links timesheet entries to Mexico holidays |
| Bz_Timesheet_New | Bz_holidays_Canada | Many-to-Many | pe_date = Holiday_Date | Links timesheet entries to Canada holidays |
| Bz_Timesheet_New | Bz_holidays_India | Many-to-Many | pe_date = Holiday_Date | Links timesheet entries to India holidays |
| Bz_Audit_Log | All Bronze Tables | One-to-Many | source_table = Table Name | Audit log tracks all operations on Bronze layer tables |

---

## 5. DESIGN DECISIONS AND ASSUMPTIONS

### Design Decisions:

1. **Naming Convention**: All Bronze layer tables are prefixed with 'Bz_' to clearly identify them as part of the Bronze layer in the Medallion architecture. This provides immediate visual identification and prevents naming conflicts.

2. **Metadata Columns**: Three standard metadata columns are added to all Bronze tables:
   - load_timestamp: Captures when data was first loaded into Bronze layer
   - update_timestamp: Captures when data was last updated
   - source_system: Identifies the originating system for data lineage

3. **Data Type Preservation**: All data types from the source system are preserved exactly as-is in the Bronze layer to maintain data fidelity and enable accurate historical analysis.

4. **Primary and Foreign Keys Exclusion**: As per requirements, primary key and foreign key fields (ID fields with IDENTITY or PRIMARY KEY constraints) are excluded from the Bronze layer logical model, focusing on business data attributes.

5. **Audit Table Design**: A comprehensive audit table is designed to track all data loading activities, including success/failure status, processing times, record counts, and error messages for complete operational visibility.

6. **PII Classification**: PII fields are identified based on GDPR, CCPA, and other regulatory frameworks, marking fields containing personal identifiers, contact information, employment data, and protected characteristics.

### Assumptions:

1. **Source System Stability**: It is assumed that the source system schema is relatively stable, and any schema changes will be managed through a formal change control process.

2. **Data Volume**: The design assumes moderate to high data volumes that require efficient loading and processing mechanisms in the Bronze layer.

3. **Data Refresh Frequency**: It is assumed that data will be loaded into the Bronze layer on a regular schedule (daily, hourly, or real-time) based on business requirements.

4. **Data Quality**: The Bronze layer is designed to accept data as-is from the source without transformation, with data quality checks and cleansing to be performed in Silver layer.

5. **Retention Policy**: It is assumed that Bronze layer data will be retained for a defined period (e.g., 7 years) to support historical analysis and regulatory compliance.

6. **Access Control**: It is assumed that appropriate access controls will be implemented to protect PII data, with role-based access control (RBAC) and data masking for sensitive fields.

7. **Relationship Inference**: Table relationships are inferred based on common field names and business logic, as explicit foreign key constraints were not defined in the source DDL.

8. **Holiday Tables**: Holiday tables are assumed to be reference data that is maintained separately and used for calculating working days and holiday hours.

9. **Date Dimension**: The DimDate table is assumed to be a pre-populated reference table covering a sufficient date range for all business operations.

10. **Audit Requirements**: It is assumed that audit logging is required for compliance purposes and will be actively monitored for data quality and operational issues.

11. **Source System Identifier**: The source_system metadata column will be populated with a consistent identifier (e.g., 'SQL_Server_Source') to support multi-source data integration in future.

12. **Timestamp Precision**: All timestamp fields use datetime data type with precision sufficient for operational tracking and debugging.

---

## 6. API COST

**apiCost**: 0.00 USD

Note: This logical data model was created using GitHub File Reader and Writer tools which do not incur API costs for the data modeling process itself. The cost represents the computational resources used for reading the source DDL file and writing the output documentation.

---

## DOCUMENT CONTROL

**Version**: 1.0
**Status**: Draft
**Last Updated**: Current Date
**Approved By**: Pending
**Next Review Date**: Pending

---

END OF DOCUMENT