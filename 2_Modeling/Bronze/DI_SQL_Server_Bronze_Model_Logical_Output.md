====================================================
Author:        AAVA
Date:          
Description:   Logical data model for Medallion Bronze Layer - mirrors source layer, classifies PII, includes audit, metadata, and relationships
====================================================

1. PII Classification
---------------------
Table: New_Monthly_HC_Report
| Column Name   | Reason for PII Classification |
|---------------|------------------------------|
| gci id        | Unique employee identifier (directly identifies an individual) |
| first name    | Direct identifier (GDPR/PII) |
| last name     | Direct identifier (GDPR/PII) |

Table: SchTask
| Column Name   | Reason for PII Classification |
|---------------|------------------------------|
| SSN           | Social Security Number (highly sensitive, direct identifier) |
| GCI_ID        | Unique employee identifier (directly identifies an individual) |
| FName         | Direct identifier (GDPR/PII) |
| LName         | Direct identifier (GDPR/PII) |
| Initiator_Mail| Email address (contact information, PII) |

Table: Hiring_Initiator_Project_Info
| Column Name             | Reason for PII Classification |
|------------------------|------------------------------|
| Candidate_LName        | Direct identifier (GDPR/PII) |
| Candidate_MI           | Direct identifier (GDPR/PII) |
| Candidate_FName        | Direct identifier (GDPR/PII) |
| Candidate_SSN          | Social Security Number (highly sensitive, direct identifier) |
| HR_Candidate_DOB       | Date of birth (personal identifier) |
| HR_ClientInfo_Phone    | Phone number (contact information, PII) |
| HR_ClientInfo_Email    | Email address (contact information, PII) |
| HR_ClientInfo_Fax      | Fax number (contact information, PII) |
| HR_ClientInfo_Cell     | Cell number (contact information, PII) |
| HR_ClientInfo_Pager    | Pager number (contact information, PII) |
| HR_ClientInfo_Pager_Pin| Pager pin (contact information, PII) |
| HR_ClientAgreements_Phone | Phone number (contact information, PII) |
| HR_ClientAgreements_Email | Email address (contact information, PII) |
| HR_ClientAgreements_Fax   | Fax number (contact information, PII) |
| HR_ClientAgreements_Cell  | Cell number (contact information, PII) |
| HR_ClientAgreements_Pager | Pager number (contact information, PII) |
| HR_ClientAgreements_Pager_Pin | Pager pin (contact information, PII) |
| HR_Project_AddressToSend1 | Address (location/contact, PII) |
| HR_Project_AddressToSend2 | Address (location/contact, PII) |
| HR_Project_City           | City (location, PII) |
| HR_Project_State          | State (location, PII) |
| HR_Project_Zip            | Zip code (location, PII) |
| HR_Project_Phone          | Phone number (contact information, PII) |
| HR_Project_Email          | Email address (contact information, PII) |
| HR_Project_Fax            | Fax number (contact information, PII) |
| HR_Project_Cell           | Cell number (contact information, PII) |
| HR_Project_Pager          | Pager number (contact information, PII) |
| HR_Project_Pager_Pin      | Pager pin (contact information, PII) |
| Print_Invoice_Address1    | Address (location/contact, PII) |
| Print_Invoice_Address2    | Address (location/contact, PII) |
| Print_Invoice_City        | City (location, PII) |
| Print_Invoice_State       | State (location, PII) |
| Print_Invoice_Zip         | Zip code (location, PII) |
| Mail_Invoice_Address1     | Address (location/contact, PII) |
| Mail_Invoice_Address2     | Address (location/contact, PII) |
| Mail_Invoice_City         | City (location, PII) |
| Mail_Invoice_State        | State (location, PII) |
| Mail_Invoice_Zip          | Zip code (location, PII) |
| Collabera_Email_ID        | Email address (contact information, PII) |

Table: report_392_all
| Column Name   | Reason for PII Classification |
|---------------|------------------------------|
| gci id        | Unique employee identifier (directly identifies an individual) |
| first name    | Direct identifier (GDPR/PII) |
| last name     | Direct identifier (GDPR/PII) |
| CandidateEmail| Email address (contact information, PII) |

Table: Timesheet_New
| Column Name   | Reason for PII Classification |
|---------------|------------------------------|
| gci_id        | Unique employee identifier (directly identifies an individual) |

Table: vw_billing_timesheet_daywise_ne
| Column Name   | Reason for PII Classification |
|---------------|------------------------------|
| GCI_ID        | Unique employee identifier (directly identifies an individual) |

Table: vw_consultant_timesheet_daywise
| Column Name   | Reason for PII Classification |
|---------------|------------------------------|
| GCI_ID        | Unique employee identifier (directly identifies an individual) |


2. Bronze Layer Logical Model
-----------------------------

Table: Bz_New_Monthly_HC_Report
Description: Contains monthly headcount report details for employees, mirroring source data except key fields, with added metadata columns.
| Column Name              | Data Type         | Description |
|--------------------------|-------------------|-------------|
| gci id                   | varchar(50)       | Unique employee identifier (PII) |
| first name               | varchar(50)       | Employee first name (PII) |
| last name                | varchar(50)       | Employee last name (PII) |
| job title                | varchar(50)       | Job title of employee |
| hr_business_type         | varchar(50)       | HR business type |
| client code              | varchar(50)       | Client code for assignment |
| start date               | datetime          | Employee start date |
| termdate                 | datetime          | Employee termination date |
| Final_End_date           | datetime          | Final end date of employment |
| NBR                      | money             | Net bill rate |
| Merged Name              | varchar(100)      | Merged name field |
| Super Merged Name        | varchar(100)      | Super merged name field |
| market                   | varchar(50)       | Market segment |
| defined_New_VAS          | varchar(8)        | New VAS definition |
| IS_SOW                   | varchar(7)        | Statement of Work indicator |
| GP                       | money             | Gross profit |
| NextValue                | datetime          | Next value date |
| termination_reason       | varchar(100)      | Reason for termination |
| FirstDay                 | datetime          | First day of employment |
| Emp_Status               | varchar(25)       | Employee status |
| employee_category        | varchar(50)       | Category of employee |
| LastDay                  | datetime          | Last day of employment |
| ee_wf_reason             | varchar(50)       | Workflow reason |
| old_Begin                | numeric(2,1)      | Old begin value |
| Begin HC                 | numeric(38,36)    | Begin headcount |
| Starts - New Project     | numeric(38,36)    | Starts for new project |
| Starts- Internal movements| numeric(38,36)   | Starts for internal movements |
| Terms                    | numeric(38,36)    | Terms count |
| Other project Ends       | numeric(38,36)    | Other project end count |
| OffBoard                 | numeric(38,36)    | Offboarding count |
| End HC                   | numeric(38,36)    | End headcount |
| Vol_term                 | numeric(38,36)    | Voluntary termination count |
| adj                      | numeric(38,36)    | Adjustment value |
| YYMM                     | int               | Year and month |
| tower1                   | varchar(60)       | Tower 1 name |
| req type                 | varchar(50)       | Request type |
| ITSSProjectName          | varchar(200)      | ITSS project name |
| IS_Offshore              | varchar(20)       | Offshore indicator |
| Subtier                  | varchar(50)       | Subtier value |
| New_Visa_type            | varchar(50)       | New visa type |
| Practice_type            | varchar(50)       | Practice type |
| vertical                 | varchar(50)       | Vertical name |
| CL_Group                 | varchar(32)       | Client group |
| salesrep                 | varchar(50)       | Sales representative |
| recruiter                | varchar(50)       | Recruiter name |
| PO_End                   | datetime          | Purchase order end date |
| PO_End_Count             | numeric(38,36)    | Purchase order end count |
| Derived_Rev              | real              | Derived revenue |
| Derived_GP               | real              | Derived gross profit |
| Backlog_Rev              | real              | Backlog revenue |
| Backlog_GP               | real              | Backlog gross profit |
| Expected_Hrs             | real              | Expected hours |
| Expected_Total_Hrs       | real              | Expected total hours |
| ITSS                     | varchar(100)      | ITSS field |
| client_entity            | varchar(50)       | Client entity |
| newtermdate              | datetime          | New termination date |
| Newoffboardingdate       | datetime          | New offboarding date |
| HWF_Process_name         | varchar(100)      | HWF process name |
| Derived_System_End_date  | datetime          | Derived system end date |
| Cons_Ageing              | int               | Consultant ageing |
| CP_Name                  | nvarchar(50)      | CP name |
| bill st units            | varchar(50)       | Bill statement units |
| project city             | varchar(50)       | Project city |
| project state            | varchar(50)       | Project state |
| OpportunityID            | varchar(50)       | Opportunity ID |
| OpportunityName          | varchar(200)      | Opportunity name |
| Bus_days                 | real              | Business days |
| circle                   | varchar(100)      | Circle name |
| community_new            | varchar(100)      | Community new |
| ALT                      | nvarchar(50)      | ALT field |
| Market_Leader            | varchar(max)      | Market leader |
| Acct_Owner               | nvarchar(50)      | Account owner |
| st_yymm                  | int               | Start year and month |
| PortfolioLeader          | varchar(max)      | Portfolio leader |
| ClientPartner            | varchar(max)      | Client partner |
| FP_Proj_ID               | varchar(10)       | FP project ID |
| FP_Proj_Name             | varchar(max)      | FP project name |
| FP_TM                    | varchar(2)        | FP TM field |
| project_type             | varchar(500)      | Project type |
| FP_Proj_Planned          | varchar(10)       | FP project planned |
| Standard Job Title Horizon| nvarchar(2000)   | Standard job title horizon |
| Experience Level Title   | varchar(200)      | Experience level title |
| User_Name                | varchar(50)       | User name |
| Status                   | varchar(50)       | Status field |
| asstatus                 | varchar(50)       | As status |
| system_runtime           | datetime          | System runtime |
| BR_Start_date            | datetime          | BR start date |
| Bill_ST                  | float             | Bill ST value |
| Prev_BR                  | float             | Previous BR value |
| ProjType                 | varchar(2)        | Project type |
| Mons_in_Same_Rate        | int               | Months in same rate |
| Rate_Time_Gr             | varchar(20)       | Rate time group |
| Rate_Change_Type         | varchar(20)       | Rate change type |
| Net_Addition             | numeric(38,36)    | Net addition |
| load_timestamp           | datetime          | Data load timestamp |
| update_timestamp         | datetime          | Data update timestamp |
| source_system            | varchar(100)      | Source system identifier |

Table: Bz_SchTask
Description: Tracks scheduled tasks and workflow for HR processes.
| Column Name         | Data Type         | Description |
|---------------------|------------------|-------------|
| SSN                 | varchar(50)      | Social Security Number (PII) |
| GCI_ID              | varchar(50)      | Unique employee identifier (PII) |
| FName               | varchar(50)      | Employee first name (PII) |
| LName               | varchar(50)      | Employee last name (PII) |
| Level_ID            | int              | Level ID |
| Last_Level          | int              | Last level reached |
| Initiator           | varchar(50)      | Task initiator |
| Initiator_Mail      | varchar(50)      | Initiator email (PII) |
| Status              | varchar(50)      | Task status |
| Comments            | varchar(8000)    | Task comments |
| DateCreated         | datetime         | Task creation date |
| TrackID             | varchar(50)      | Tracking ID |
| DateCompleted       | datetime         | Task completion date |
| Existing_Resource   | varchar(3)       | Existing resource indicator |
| Term_ID             | numeric(18,0)    | Termination ID |
| legal_entity        | varchar(50)      | Legal entity |
| load_timestamp      | datetime         | Data load timestamp |
| update_timestamp    | datetime         | Data update timestamp |
| source_system       | varchar(100)     | Source system identifier |

Table: Bz_Hiring_Initiator_Project_Info
Description: Contains detailed hiring and project information for candidates and HR processes.
| Column Name                        | Data Type         | Description |
|------------------------------------|-------------------|-------------|
| Candidate_LName                    | varchar(50)       | Candidate last name (PII) |
| Candidate_MI                       | varchar(50)       | Candidate middle initial (PII) |
| Candidate_FName                    | varchar(50)       | Candidate first name (PII) |
| Candidate_SSN                      | varchar(50)       | Candidate SSN (PII) |
| HR_Candidate_JobTitle              | varchar(50)       | Candidate job title |
| HR_Candidate_JobDescription        | varchar(100)      | Candidate job description |
| HR_Candidate_DOB                   | varchar(50)       | Candidate date of birth (PII) |
| HR_Candidate_Employee_Type         | varchar(50)       | Candidate employee type |
| HR_Project_Referred_By             | varchar(50)       | Referral source |
| HR_Project_Referral_Fees           | varchar(50)       | Referral fees |
| HR_Project_Referral_Units          | varchar(50)       | Referral units |
| HR_Relocation_Request              | varchar(50)       | Relocation request |
| HR_Relocation_departure_city       | varchar(50)       | Departure city |
| HR_Relocation_departure_state      | varchar(50)       | Departure state |
| HR_Relocation_departure_airport    | varchar(50)       | Departure airport |
| HR_Relocation_departure_date       | varchar(50)       | Departure date |
| HR_Relocation_departure_time       | varchar(50)       | Departure time |
| HR_Relocation_arrival_city         | varchar(50)       | Arrival city |
| HR_Relocation_arrival_state        | varchar(50)       | Arrival state |
| HR_Relocation_arrival_airport      | varchar(50)       | Arrival airport |
| HR_Relocation_arrival_date         | varchar(50)       | Arrival date |
| HR_Relocation_arrival_time         | varchar(50)       | Arrival time |
| HR_Relocation_AccomodationStartDate| varchar(50)       | Accommodation start date |
| HR_Relocation_AccomodationEndDate  | varchar(50)       | Accommodation end date |
| HR_Relocation_AccomodationStartTime| varchar(50)       | Accommodation start time |
| HR_Relocation_AccomodationEndTime  | varchar(50)       | Accommodation end time |
| HR_Relocation_CarPickup_Place      | varchar(50)       | Car pickup place |
| HR_Relocation_CarPickup_AddressLine1| varchar(50)      | Car pickup address line 1 |
| HR_Relocation_CarPickup_AddressLine2| varchar(50)      | Car pickup address line 2 |
| HR_Relocation_CarPickup_City       | varchar(50)       | Car pickup city |
| HR_Relocation_CarPickup_State      | varchar(50)       | Car pickup state |
| HR_Relocation_CarPickup_Zip        | varchar(50)       | Car pickup zip |
| HR_Relocation_CarReturn_City       | varchar(50)       | Car return city |
| HR_Relocation_CarReturn_State      | varchar(50)       | Car return state |
| HR_Relocation_CarReturn_Place      | varchar(50)       | Car return place |
| HR_Relocation_CarReturn_AddressLine1| varchar(50)      | Car return address line 1 |
| HR_Relocation_CarReturn_AddressLine2| varchar(50)      | Car return address line 2 |
| HR_Relocation_CarReturn_Zip        | varchar(50)       | Car return zip |
| HR_Relocation_RentalCarStartDate   | varchar(50)       | Rental car start date |
| HR_Relocation_RentalCarEndDate     | varchar(50)       | Rental car end date |
| HR_Relocation_RentalCarStartTime   | varchar(50)       | Rental car start time |
| HR_Relocation_RentalCarEndTime     | varchar(50)       | Rental car end time |
| HR_Relocation_MaxClientInvoice     | varchar(50)       | Max client invoice |
| HR_Relocation_approving_manager    | varchar(50)       | Approving manager |
| HR_Relocation_Notes                | varchar(5000)     | Relocation notes |
| HR_Recruiting_Manager              | varchar(50)       | Recruiting manager |
| HR_Recruiting_AccountExecutive     | varchar(50)       | Account executive |
| HR_Recruiting_Recruiter            | varchar(50)       | Recruiter |
| HR_Recruiting_ResourceManager      | varchar(50)       | Resource manager |
| HR_Recruiting_Office               | varchar(50)       | Recruiting office |
| HR_Recruiting_ReqNo                | varchar(100)      | Recruiting request number |
| HR_Recruiting_Direct               | varchar(50)       | Recruiting direct |
| HR_Recruiting_Replacement_For_GCIID| varchar(50)       | Replacement for GCIID |
| HR_Recruiting_Replacement_For      | varchar(50)       | Replacement for |
| HR_Recruiting_Replacement_Reason   | varchar(50)       | Replacement reason |
| HR_ClientInfo_ID                   | varchar(50)       | Client info ID |
| HR_ClientInfo_Name                 | varchar(60)       | Client info name |
| HR_ClientInfo_DNB                  | varchar(50)       | Client info DNB |
| HR_ClientInfo_Sector               | varchar(50)       | Client info sector |
| HR_ClientInfo_Manager_ID           | varchar(50)       | Client info manager ID |
| HR_ClientInfo_Manager              | varchar(50)       | Client info manager |
| HR_ClientInfo_Phone                | varchar(50)       | Client info phone (PII) |
| HR_ClientInfo_Phone_Extn           | varchar(50)       | Client info phone extension |
| HR_ClientInfo_Email                | varchar(50)       | Client info email (PII) |
| HR_ClientInfo_Fax                  | varchar(50)       | Client info fax (PII) |
| HR_ClientInfo_Cell                 | varchar(50)       | Client info cell (PII) |
| HR_ClientInfo_Pager                | varchar(50)       | Client info pager (PII) |
| HR_ClientInfo_Pager_Pin            | varchar(50)       | Client info pager pin (PII) |
| HR_ClientAgreements_SendTo         | varchar(50)       | Agreements send to |
| HR_ClientAgreements_Phone          | varchar(50)       | Agreements phone (PII) |
| HR_ClientAgreements_Phone_Extn     | varchar(50)       | Agreements phone extension |
| HR_ClientAgreements_Email          | varchar(50)       | Agreements email (PII) |
| HR_ClientAgreements_Fax            | varchar(50)       | Agreements fax (PII) |
| HR_ClientAgreements_Cell           | varchar(50)       | Agreements cell (PII) |
| HR_ClientAgreements_Pager          | varchar(50)       | Agreements pager (PII) |
| HR_ClientAgreements_Pager_Pin      | varchar(50)       | Agreements pager pin (PII) |
| HR_Project_SendInvoicesTo          | varchar(100)      | Project send invoices to |
| HR_Project_AddressToSend1          | varchar(150)      | Project address to send 1 (PII) |
| HR_Project_AddressToSend2          | varchar(150)      | Project address to send 2 (PII) |
| HR_Project_City                    | varchar(50)       | Project city (PII) |
| HR_Project_State                   | varchar(50)       | Project state (PII) |
| HR_Project_Zip                     | varchar(50)       | Project zip (PII) |
| HR_Project_Phone                   | varchar(50)       | Project phone (PII) |
| HR_Project_Phone_Extn              | varchar(50)       | Project phone extension |
| HR_Project_Email                   | varchar(50)       | Project email (PII) |
| HR_Project_Fax                     | varchar(50)       | Project fax (PII) |
| HR_Project_Cell                    | varchar(50)       | Project cell (PII) |
| HR_Project_Pager                   | varchar(50)       | Project pager (PII) |
| HR_Project_Pager_Pin               | varchar(50)       | Project pager pin (PII) |
| HR_Project_ST                      | varchar(50)       | Project ST |
| HR_Project_OT                      | varchar(50)       | Project OT |
| HR_Project_ST_Off                  | varchar(50)       | Project ST off |
| HR_Project_OT_Off                  | varchar(50)       | Project OT off |
| HR_Project_ST_Units                | varchar(50)       | Project ST units |
| HR_Project_OT_Units                | varchar(50)       | Project OT units |
| HR_Project_ST_Off_Units            | varchar(50)       | Project ST off units |
| HR_Project_OT_Off_Units            | varchar(50)       | Project OT off units |
| HR_Project_StartDate               | varchar(50)       | Project start date |
| HR_Project_EndDate                 | varchar(50)       | Project end date |
| HR_Project_Location_AddressLine1   | varchar(50)       | Project location address line 1 |
| HR_Project_Location_AddressLine2   | varchar(50)       | Project location address line 2 |
| HR_Project_Location_City           | varchar(50)       | Project location city |
| HR_Project_Location_State          | varchar(50)       | Project location state |
| HR_Project_Location_Zip            | varchar(50)       | Project location zip |
| HR_Project_InvoicingTerms          | varchar(50)       | Project invoicing terms |
| HR_Project_PaymentTerms            | varchar(50)       | Project payment terms |
| HR_Project_EndClient_ID            | varchar(50)       | Project end client ID |
| HR_Project_EndClient_Name          | varchar(60)       | Project end client name |
| HR_Project_EndClient_Sector        | varchar(50)       | Project end client sector |
| HR_Accounts_Person                 | varchar(50)       | Accounts person |
| HR_Accounts_PhoneNo                | varchar(50)       | Accounts phone number |
| HR_Accounts_PhoneNo_Extn           | varchar(50)       | Accounts phone extension |
| HR_Accounts_Email                  | varchar(50)       | Accounts email |
| HR_Accounts_FaxNo                  | varchar(50)       | Accounts fax number |
| HR_Accounts_Cell                   | varchar(50)       | Accounts cell |
| HR_Accounts_Pager                  | varchar(50)       | Accounts pager |
| HR_Accounts_Pager_Pin              | varchar(50)       | Accounts pager pin |
| HR_Project_Referrer_ID             | varchar(50)       | Project referrer ID |
| UserCreated                        | varchar(50)       | User created |
| DateCreated                        | varchar(50)       | Date created |
| HR_Week_Cycle                      | int               | HR week cycle |
| Project_Name                       | varchar(255)      | Project name |
| transition                         | varchar(50)       | Transition field |
| Is_OT_Allowed                      | varchar(50)       | Is OT allowed |
| HR_Business_Type                   | varchar(50)       | HR business type |
| WebXl_EndClient_ID                 | varchar(50)       | WebXL end client ID |
| WebXl_EndClient_Name               | varchar(60)       | WebXL end client name |
| Client_Offer_Acceptance_Date       | varchar(50)       | Client offer acceptance date |
| Project_Type                       | varchar(50)       | Project type |
| req_division                       | varchar(200)      | Request division |
| Client_Compliance_Checks_Reqd      | varchar(50)       | Compliance checks required |
| HSU                                | varchar(50)       | HSU field |
| HSUDM                              | varchar(50)       | HSUDM field |
| Payroll_Location                   | varchar(50)       | Payroll location |
| Is_DT_Allowed                      | varchar(50)       | Is DT allowed |
| SBU                                | varchar(2)        | SBU field |
| BU                                 | varchar(50)       | BU field |
| Dept                               | varchar(2)        | Department |
| HCU                                | varchar(50)       | HCU field |
| Project_Category                   | varchar(50)       | Project category |
| Delivery_Model                     | varchar(50)       | Delivery model |
| BPOS_Project                       | varchar(3)        | BPOS project |
| ER_Person                          | varchar(50)       | ER person |
| Print_Invoice_Address1             | varchar(100)      | Print invoice address 1 (PII) |
| Print_Invoice_Address2             | varchar(100)      | Print invoice address 2 (PII) |
| Print_Invoice_City                 | varchar(50)       | Print invoice city (PII) |
| Print_Invoice_State                | varchar(50)       | Print invoice state (PII) |
| Print_Invoice_Zip                  | varchar(50)       | Print invoice zip (PII) |
| Mail_Invoice_Address1              | varchar(100)      | Mail invoice address 1 (PII) |
| Mail_Invoice_Address2              | varchar(100)      | Mail invoice address 2 (PII) |
| Mail_Invoice_City                  | varchar(50)       | Mail invoice city (PII) |
| Mail_Invoice_State                 | varchar(50)       | Mail invoice state (PII) |
| Mail_Invoice_Zip                   | varchar(50)       | Mail invoice zip (PII) |
| Project_Zone                       | varchar(50)       | Project zone |
| Emp_Identifier                     | varchar(50)       | Employee identifier |
| CRE_Person                         | varchar(50)       | CRE person |
| HR_Project_Location_Country        | varchar(50)       | Project location country |
| Agency                             | varchar(50)       | Agency name |
| pwd                                | varchar(50)       | Password (sensitive) |
| PES_Doc_Sent                       | varchar(50)       | PES document sent |
| PES_Confirm_Doc_Rcpt               | varchar(50)       | PES confirm document receipt |
| PES_Clearance_Rcvd                 | varchar(50)       | PES clearance received |
| PES_Doc_Sent_Date                  | varchar(50)       | PES document sent date |
| PES_Confirm_Doc_Rcpt_Date          | varchar(50)       | PES confirm document receipt date |
| PES_Clearance_Rcvd_Date            | varchar(50)       | PES clearance received date |
| Inv_Pay_Terms_Notes                | text              | Invoice payment terms notes |
| CBC_Notes                          | text              | CBC notes |
| Benefits_Plan                      | varchar(50)       | Benefits plan |
| BillingCompany                     | varchar(50)       | Billing company |
| SPINOFF_CPNY                       | varchar(50)       | Spinoff company |
| Position_Type                      | varchar(50)       | Position type |
| I9_Approver                        | varchar(50)       | I9 approver |
| FP_BILL_Rate                       | varchar(50)       | FP bill rate |
| TSLead                             | varchar(50)       | TS lead |
| Inside_Sales                       | varchar(50)       | Inside sales |
| Markup                             | varchar(50)       | Markup value |
| Maximum_Allowed_Markup             | varchar(50)       | Maximum allowed markup |
| Actual_Markup                      | varchar(50)       | Actual markup |
| SCA_Hourly_Bill_Rate               | varchar(50)       | SCA hourly bill rate |
| HR_Project_StartDate_Change_Reason | varchar(100)      | Project start date change reason |
| source                             | varchar(50)       | Source field |
| HR_Recruiting_VMO                  | varchar(50)       | Recruiting VMO |
| HR_Recruiting_Inside_Sales         | varchar(50)       | Recruiting inside sales |
| HR_Recruiting_TL                   | varchar(50)       | Recruiting TL |
| HR_Recruiting_NAM                  | varchar(50)       | Recruiting NAM |
| HR_Recruiting_ARM                  | varchar(50)       | Recruiting ARM |
| HR_Recruiting_RM                   | varchar(50)       | Recruiting RM |
| HR_Recruiting_ReqID                | varchar(50)       | Recruiting request ID |
| HR_Recruiting_TAG                  | varchar(50)       | Recruiting tag |
| DateUpdated                        | varchar(50)       | Date updated |
| UserUpdated                        | varchar(50)       | User updated |
| Is_Swing_Shift_Associated_With_It  | varchar(50)       | Swing shift association |
| FP_Bill_Rate_OT                    | varchar(50)       | FP bill rate OT |
| Not_To_Exceed_YESNO                | varchar(10)       | Not to exceed indicator |
| Exceed_YESNO                       | varchar(10)       | Exceed indicator |
| Is_OT_Billable                     | varchar(5)        | OT billable indicator |
| Is_premium_project_Associated_With_It| varchar(50)     | Premium project association |
| ITSS_Business_Development_Manager  | varchar(50)       | ITSS business development manager |
| Practice_type                      | varchar(50)       | Practice type |
| Project_billing_type               | varchar(50)       | Project billing type |
| Resource_billing_type              | varchar(50)       | Resource billing type |
| Type_Consultant_category           | varchar(50)       | Consultant category type |
| Unique_identification_ID_Doc       | varchar(100)      | Unique identification document |
| Region1                            | varchar(100)      | Region 1 |
| Region2                            | varchar(100)      | Region 2 |
| Region1_percentage                 | varchar(10)       | Region 1 percentage |
| Region2_percentage                 | varchar(10)       | Region 2 percentage |
| Soc_Code                           | varchar(300)      | SOC code |
| Soc_Desc                           | varchar(300)      | SOC description |
| req_duration                       | int               | Request duration |
| Non_Billing_Type                   | varchar(50)       | Non-billing type |
| Worker_Entity_ID                   | varchar(30)       | Worker entity ID |
| OraclePersonID                     | varchar(30)       | Oracle person ID |
| Collabera_Email_ID                 | varchar(100)      | Collabera email (PII) |
| Onsite_Consultant_Relationship_Manager| varchar(50)    | Onsite consultant relationship manager |
| HR_project_county                  | varchar(100)      | Project county |
| EE_WF_Reasons                      | varchar(50)       | EE workflow reasons |
| GradeName                          | varchar(50)       | Grade name |
| ROLEFAMILY                         | varchar(50)       | Role family |
| SUBDEPARTMENT                      | varchar(100)      | Subdepartment |
| MSProjectType                      | varchar(50)       | MS project type |
| NetsuiteProjectId                   | varchar(50)      | Netsuite project ID |
| NetsuiteCreatedDate                 | varchar(50)      | Netsuite created date |
| NetsuiteModifiedDate                | varchar(50)      | Netsuite modified date |
| StandardJobTitle                    | varchar(100)     | Standard job title |
| community                           | varchar(100)     | Community |
| parent_Account_name                  | varchar(100)    | Parent account name |
| Timesheet_Manager                    | varchar(255)    | Timesheet manager |
| TimeSheetManagerType                  | varchar(255)   | Timesheet manager type |
| Timesheet_Manager_Phone               | varchar(255)   | Timesheet manager phone |
| Timesheet_Manager_Email               | varchar(255)   | Timesheet manager email |
| HR_Project_Major_Group                | varchar(255)   | Project major group |
| HR_Project_Minor_Group                | varchar(255)   | Project minor group |
| HR_Project_Broad_Group                | varchar(255)   | Project broad group |
| HR_Project_Detail_Group               | varchar(255)   | Project detail group |
| 9Hours_Allowed                        | varchar(3)     | 9 hours allowed indicator |
| 9Hours_Effective_Date                  | varchar(50)   | 9 hours effective date |
| load_timestamp                         | datetime      | Data load timestamp |
| update_timestamp                       | datetime      | Data update timestamp |
| source_system                          | varchar(100)  | Source system identifier |

Table: Bz_Timesheet_New
Description: Stores timesheet details for employees.
| Column Name   | Data Type        | Description |
|---------------|------------------|-------------|
| gci_id        | int              | Unique employee identifier (PII) |
| pe_date       | datetime         | Period end date |
| c_date        | datetime         | Creation date |
| ST            | float            | Standard time hours |
| OT            | float            | Overtime hours |
| TIME_OFF      | float            | Time off hours |
| HO            | float            | Holiday hours |
| DT            | float            | Double time hours |
| NON_ST        | float            | Non-standard time |
| NON_OT        | float            | Non-overtime |
| Sick_Time     | float            | Sick time hours |
| NON_Sick_Time | float            | Non-sick time |
| NON_DT        | float            | Non-double time |
| load_timestamp| datetime         | Data load timestamp |
| update_timestamp| datetime        | Data update timestamp |
| source_system | varchar(100)     | Source system identifier |

Table: Bz_report_392_all
Description: Contains comprehensive employee and project assignment details.
| Column Name   | Data Type        | Description |
|---------------|------------------|-------------|
| gci id        | varchar(50)      | Unique employee identifier (PII) |
| first name    | varchar(50)      | Employee first name (PII) |
| last name     | varchar(50)      | Employee last name (PII) |
| employee type | varchar(8000)    | Employee type |
| recruiting manager | varchar(50)  | Recruiting manager |
| resource manager | varchar(50)    | Resource manager |
| salesrep      | varchar(50)      | Sales representative |
| inside_sales  | varchar(50)      | Inside sales |
| recruiter     | varchar(50)      | Recruiter name |
| req type      | varchar(50)      | Request type |
| ms_type       | varchar(28)      | MS type |
| client code   | varchar(50)      | Client code |
| client name   | varchar(60)      | Client name |
| client_type   | varchar(50)      | Client type |
| job title     | varchar(50)      | Job title |
| bill st       | varchar(50)      | Bill statement |
| visa type     | varchar(50)      | Visa type |
| bill st units | varchar(50)      | Bill statement units |
| salary        | money            | Salary amount |
| salary units  | varchar(50)      | Salary units |
| pay st        | float            | Pay statement |
| pay st units  | varchar(50)      | Pay statement units |
| start date    | datetime         | Start date |
| end date      | datetime         | End date |
| po start date | varchar(50)      | PO start date |
| po end date   | varchar(50)      | PO end date |
| project city  | varchar(50)      | Project city |
| project state | varchar(50)      | Project state |
| no of free hours | varchar(50)    | Number of free hours |
| hr_business_type | varchar(50)    | HR business type |
| ee_wf_reason  | varchar(50)      | Workflow reason |
| singleman company | varchar(50)   | Singleman company indicator |
| status        | varchar(50)      | Status |
| termination_reason | varchar(100) | Termination reason |
| wf created on | datetime         | Workflow created on |
| hcu           | varchar(50)      | HCU field |
| hsu           | varchar(50)      | HSU field |
| project zip   | varchar(50)      | Project zip |
| cre_person    | varchar(50)      | CRE person |
| assigned_hsu  | varchar(10)      | Assigned HSU |
| req_category  | varchar(50)      | Request category |
| gpm           | money            | GPM value |
| gp            | money            | GP value |
| aca_cost      | real             | ACA cost |
| aca_classification | varchar(50)  | ACA classification |
| markup        | varchar(3)       | Markup value |
| actual_markup | varchar(50)      | Actual markup |
| maximum_allowed_markup | varchar(50)| Maximum allowed markup |
| submitted_bill_rate | money        | Submitted bill rate |
| req_division  | varchar(200)     | Request division |
| pay rate to consultant | varchar(50)| Pay rate to consultant |
| location      | varchar(50)      | Location |
| rec_region    | varchar(50)      | Recruitment region |
| client_region | varchar(50)      | Client region |
| dm            | varchar(50)      | DM field |
| delivery_director | varchar(50)   | Delivery director |
| bu            | varchar(50)      | BU field |
| es            | varchar(50)      | ES field |
| nam           | varchar(50)      | NAM field |
| client_sector | varchar(50)      | Client sector |
| skills        | varchar(2500)    | Skills |
| pskills       | varchar(4000)    | Primary skills |
| business_manager | nvarchar(max)  | Business manager |
| vmo           | varchar(50)      | VMO field |
| rec_name      | varchar(500)     | Recruiter name |
| Req_ID        | numeric(18,9)    | Request ID |
| received      | datetime         | Received date |
| Submitted     | datetime         | Submitted date |
| responsetime  | varchar(53)      | Response time |
| Inhouse       | varchar(3)       | Inhouse indicator |
| Net_Bill_Rate | money            | Net bill rate |
| Loaded_Pay_Rate | money           | Loaded pay rate |
| NSO           | varchar(100)     | NSO field |
| ESG_Vertical  | varchar(100)     | ESG vertical |
| ESG_Industry  | varchar(100)     | ESG industry |
| ESG_DNA       | varchar(100)     | ESG DNA |
| ESG_NAM1      | varchar(100)     | ESG NAM1 |
| ESG_NAM2      | varchar(100)     | ESG NAM2 |
| ESG_NAM3      | varchar(100)     | ESG NAM3 |
| ESG_SAM       | varchar(100)     | ESG SAM |
| ESG_ES        | varchar(100)     | ESG ES |
| ESG_BU        | varchar(100)     | ESG BU |
| SUB_GPM       | money            | Sub GPM |
| manager_id    | numeric(18,9)    | Manager ID |
| Submitted_By  | varchar(50)      | Submitted by |
| HWF_Process_name | varchar(100)   | HWF process name |
| Transition    | varchar(100)     | Transition field |
| ITSS          | varchar(100)     | ITSS field |
| GP2020        | money            | GP 2020 |
| GPM2020       | money            | GPM 2020 |
| isbulk        | bit              | Bulk indicator |
| jump          | bit              | Jump indicator |
| client_class  | varchar(20)      | Client class |
| MSP           | varchar(50)      | MSP field |
| DTCUChoice1   | varchar(60)      | DTCU choice 1 |
| SubCat        | varchar(60)      | Sub category |
| IsClassInitiative | bit           | Class initiative indicator |
| division      | varchar(50)      | Division |
| divstart_date | datetime         | Division start date |
| divend_date   | datetime         | Division end date |
| tl            | varchar(50)      | TL field |
| resource_manager | varchar(50)    | Resource manager |
| recruiting_manager | varchar(50)  | Recruiting manager |
| VAS_Type      | varchar(100)     | VAS type |
| BUCKET        | varchar(50)      | Bucket field |
| RTR_DM        | varchar(50)      | RTR DM field |
| ITSSProjectName | varchar(200)   | ITSS project name |
| RegionGroup   | varchar(50)      | Region group |
| client_Markup | varchar(20)      | Client markup |
| Subtier       | varchar(50)      | Subtier field |
| Subtier_Address1 | varchar(50)    | Subtier address 1 |
| Subtier_Address2 | varchar(50)    | Subtier address 2 |
| Subtier_City  | varchar(50)      | Subtier city |
| Subtier_State | varchar(50)      | Subtier state |
| Hiresource    | varchar(100)     | Hire source |
| is_Hotbook_Hire | int            | Hotbook hire indicator |
| Client_RM     | varchar(50)      | Client RM |
| Job_Description | varchar(100)   | Job description |
| Client_Manager | varchar(50)     | Client manager |
| end_date_at_client | datetime     | End date at client |
| term_date     | datetime         | Termination date |
| employee_status | varchar(50)    | Employee status |
| Level_ID      | int              | Level ID |
| OpsGrp        | varchar(50)      | Operations group |
| Level_Name    | varchar(50)      | Level name |
| Min_levelDatetime | datetime      | Minimum level datetime |
| Max_levelDatetime | datetime      | Maximum level datetime |
| First_Interview_date | datetime   | First interview date |
| Is REC CES?   | varchar(5)       | REC CES indicator |
| Is CES Initiative? | varchar(5)   | CES initiative indicator |
| VMO_Access    | varchar(50)      | VMO access |
| Billing_Type  | varchar(50)      | Billing type |
| VASSOW        | varchar(3)       | VASSOW field |
| Worker_Entity_ID | varchar(30)   | Worker entity ID |
| Circle        | varchar(50)      | Circle field |
| VMO_Access1   | varchar(50)      | VMO access 1 |
| VMO_Access2   | varchar(50)      | VMO access 2 |
| VMO_Access3   | varchar(50)      | VMO access 3 |
| VMO_Access4   | varchar(50)      | VMO access 4 |
| Inside_Sales_Person | varchar(50) | Inside sales person |
| admin_1701    | varchar(50)      | Admin 1701 |
| corrected_staffadmin_1701 | varchar(50)| Corrected staff admin 1701 |
| HR_Billing_Placement_Net_Fee | money   | HR billing placement net fee |
| New_Visa_type | varchar(50)      | New visa type |
| newenddate    | datetime         | New end date |
| Newoffboardingdate | datetime     | New offboarding date |
| NewTermdate   | datetime         | New termination date |
| newhrisenddate | datetime        | New HRIS end date |
| rtr_location  | varchar(50)      | RTR location |
| HR_Recruiting_TL | varchar(100)  | HR recruiting TL |
| client_entity | varchar(50)      | Client entity |
| client_consent | bit             | Client consent |
| Ascendion_MetalReqID | numeric(18,9)| Ascendion MetalReqID |
| eeo           | varchar(200)     | EEO field |
| veteran       | varchar(150)     | Veteran status |
| Gender        | varchar(50)      | Gender |
| Er_person     | varchar(50)      | ER person |
| wfmetaljobdescription | nvarchar(max)| WF metal job description |
| HR_Candidate_Salary | money       | HR candidate salary |
| Interview_CreatedDate | datetime   | Interview created date |
| Interview_on_Date | datetime      | Interview on date |
| IS_SOW        | varchar(7)       | IS SOW field |
| IS_Offshore   | varchar(20)      | Offshore indicator |
| New_VAS       | varchar(4)       | New VAS field |
| VerticalName  | nvarchar(510)    | Vertical name |
| Client_Group1 | varchar(19)      | Client group 1 |
| Billig_Type   | varchar(8)       | Billing type |
| Super Merged Name | varchar(200)  | Super merged name |
| New_Category  | varchar(11)      | New category |
| New_business_type | varchar(100)  | New business type |
| OpportunityID | varchar(50)      | Opportunity ID |
| OpportunityName | varchar(200)   | Opportunity name |
| Ms_ProjectId  | int              | MS project ID |
| MS_ProjectName | varchar(200)    | MS project name |
| ORC_ID        | varchar(30)      | ORC ID |
| Market_Leader | nvarchar(max)    | Market leader |
| Circle_Metal  | varchar(100)     | Circle metal |
| Community_New_Metal | varchar(100)| Community new metal |
| Employee_Category | varchar(50)   | Employee category |
| IsBillRateSkip | bit             | Bill rate skip indicator |
| BillRate      | decimal(18,9)    | Bill rate |
| RoleFamily    | varchar(300)     | Role family |
| SubRoleFamily | varchar(300)     | Sub role family |
| Standard JobTitle | varchar(500)  | Standard job title |
| ClientInterviewRequired | int      | Client interview required |
| Redeploymenthire | int           | Redeployment hire indicator |
| HRBrandLevelId | int             | HR brand level ID |
| HRBandTitle    | varchar(300)    | HR band title |
| latest_termination_reason | varchar(200)| Latest termination reason |
| latest_termination_date | datetime | Latest termination date |
| Community     | varchar(100)     | Community |
| ReqFulfillmentReason | varchar(200)| Request fulfillment reason |
| EngagementType | varchar(500)    | Engagement type |
| RedepLedBy    | varchar(200)     | Redeployment led by |
| Can_ExperienceLevelTitle | varchar(200)| Candidate experience level title |
| Can_StandardJobTitleHorizon | nvarchar(4000)| Candidate standard job title horizon |
| CandidateEmail | varchar(100)    | Candidate email (PII) |
| Offboarding_Reason | varchar(100) | Offboarding reason |
| Offboarding_Initiated | datetime  | Offboarding initiated |
| Offboarding_Status | varchar(100)| Offboarding status |
| replcament_GCIID | int           | Replacement GCIID |
| replcament_EmployeeName | varchar(500)| Replacement employee name |
| Senior Manager | varchar(50)     | Senior manager |
| Associate Manager | varchar(50)  | Associate manager |
| Director - Talent Engine | varchar(50)| Director - Talent Engine |
| Manager        | varchar(50)     | Manager |
| Rec_ExperienceLevelTitle | varchar(200)| Recruiter experience level title |
| Rec_StandardJobTitleHorizon | nvarchar(4000)| Recruiter standard job title horizon |
| Task_Id        | int             | Task ID |
| proj_ID        | varchar(50)     | Project ID |
| Projdesc       | char(60)        | Project description |
| Client_Group   | varchar(19)     | Client group |
| billST_New     | float           | Bill ST new |
| Candidate city | varchar(50)     | Candidate city |
| Candidate State| varchar(50)     | Candidate state |
| C2C_W2_FTE     | varchar(13)     | C2C/W2/FTE indicator |
| FP_TM          | varchar(2)      | FP TM field |
| load_timestamp | datetime        | Data load timestamp |
| update_timestamp| datetime       | Data update timestamp |
| source_system  | varchar(100)    | Source system identifier |

Table: Bz_vw_billing_timesheet_daywise_ne
Description: Stores day-wise billing timesheet details for employees.
| Column Name                | Data Type        | Description |
|----------------------------|------------------|-------------|
| GCI_ID                     | int              | Unique employee identifier (PII) |
| PE_DATE                    | datetime         | Period end date |
| WEEK_DATE                  | datetime         | Week date |
| BILLABLE                   | varchar(3)       | Billable indicator |
| Approved_hours(ST)         | float            | Approved standard hours |
| Approved_hours(Non_ST)     | float            | Approved non-standard hours |
| Approved_hours(OT)         | float            | Approved overtime hours |
| Approved_hours(Non_OT)     | float            | Approved non-overtime hours |
| Approved_hours(DT)         | float            | Approved double time hours |
| Approved_hours(Non_DT)     | float            | Approved non-double time hours |
| Approved_hours(Sick_Time)  | float            | Approved sick time hours |
| Approved_hours(Non_Sick_Time)| float          | Approved non-sick time hours |
| load_timestamp             | datetime         | Data load timestamp |
| update_timestamp           | datetime         | Data update timestamp |
| source_system              | varchar(100)     | Source system identifier |

Table: Bz_vw_consultant_timesheet_daywise
Description: Stores day-wise consultant timesheet details.
| Column Name                | Data Type        | Description |
|----------------------------|------------------|-------------|
| GCI_ID                     | int              | Unique employee identifier (PII) |
| PE_DATE                    | datetime         | Period end date |
| WEEK_DATE                  | datetime         | Week date |
| BILLABLE                   | varchar(3)       | Billable indicator |
| Consultant_hours(ST)       | float            | Consultant standard hours |
| Consultant_hours(OT)       | float            | Consultant overtime hours |
| Consultant_hours(DT)       | float            | Consultant double time hours |
| load_timestamp             | datetime         | Data load timestamp |
| update_timestamp           | datetime         | Data update timestamp |
| source_system              | varchar(100)     | Source system identifier |

Table: Bz_DimDate
Description: Date dimension table for time-based analysis.
| Column Name         | Data Type        | Description |
|---------------------|------------------|-------------|
| Date                | datetime         | Calendar date |
| DayOfMonth          | varchar(2)       | Day of month |
| DayName             | varchar(9)       | Day name |
| WeekOfYear          | varchar(2)       | Week of year |
| Month               | varchar(2)       | Month |
| MonthName           | varchar(9)       | Month name |
| MonthOfQuarter      | varchar(2)       | Month of quarter |
| Quarter             | char(1)          | Quarter |
| QuarterName         | varchar(9)       | Quarter name |
| Year                | char(4)          | Year |
| YearName            | char(7)          | Year name |
| MonthYear           | char(10)         | Month and year |
| MMYYYY              | char(6)          | Month and year (MMYYYY) |
| DaysInMonth         | int              | Number of days in month |
| MM-YYYY             | varchar(10)      | Month and year (MM-YYYY) |
| YYYYMM              | varchar(10)      | Year and month (YYYYMM) |
| load_timestamp      | datetime         | Data load timestamp |
| update_timestamp    | datetime         | Data update timestamp |
| source_system       | varchar(100)     | Source system identifier |

Table: Bz_holidays_Mexico
Description: List of holidays in Mexico.
| Column Name     | Data Type        | Description |
|-----------------|------------------|-------------|
| Holiday_Date    | datetime         | Holiday date |
| Description     | varchar(50)      | Holiday description |
| Location        | varchar(10)      | Location code |
| Source_type     | varchar(50)      | Source type |
| load_timestamp  | datetime         | Data load timestamp |
| update_timestamp| datetime         | Data update timestamp |
| source_system   | varchar(100)     | Source system identifier |

Table: Bz_holidays_Canada
Description: List of holidays in Canada.
| Column Name     | Data Type        | Description |
|-----------------|------------------|-------------|
| Holiday_Date    | datetime         | Holiday date |
| Description     | varchar(100)     | Holiday description |
| Location        | varchar(10)      | Location code |
| Source_type     | varchar(50)      | Source type |
| load_timestamp  | datetime         | Data load timestamp |
| update_timestamp| datetime         | Data update timestamp |
| source_system   | varchar(100)     | Source system identifier |

Table: Bz_holidays
Description: List of holidays (generic).
| Column Name     | Data Type        | Description |
|-----------------|------------------|-------------|
| Holiday_Date    | datetime         | Holiday date |
| Description     | varchar(50)      | Holiday description |
| Location        | varchar(10)      | Location code |
| Source_type     | varchar(50)      | Source type |
| load_timestamp  | datetime         | Data load timestamp |
| update_timestamp| datetime         | Data update timestamp |
| source_system   | varchar(100)     | Source system identifier |

Table: Bz_holidays_India
Description: List of holidays in India.
| Column Name     | Data Type        | Description |
|-----------------|------------------|-------------|
| Holiday_Date    | datetime         | Holiday date |
| Description     | varchar(50)      | Holiday description |
| Location        | varchar(10)      | Location code |
| Source_type     | varchar(50)      | Source type |
| load_timestamp  | datetime         | Data load timestamp |
| update_timestamp| datetime         | Data update timestamp |
| source_system   | varchar(100)     | Source system identifier |


3. Audit Table Design
---------------------
Table: Bz_Audit
Description: Tracks data load and processing events for all Bronze layer tables.
| Column Name     | Data Type        | Description |
|-----------------|------------------|-------------|
| record_id       | int              | Unique audit record identifier |
| source_table    | varchar(100)     | Name of source table processed |
| load_timestamp  | datetime         | Timestamp of data load |
| processed_by    | varchar(100)     | User or process that loaded data |
| processing_time | float            | Time taken to process (seconds) |
| status          | varchar(50)      | Status of load (success/failure) |


4. Conceptual Data Model Diagram (Tabular)
------------------------------------------
| Table 1                        | Related Table                | Relationship Field (Key) |
|---------------------------------|------------------------------|--------------------------|
| Bz_New_Monthly_HC_Report        | Bz_report_392_all            | gci id                   |
| Bz_SchTask                      | Bz_Hiring_Initiator_Project_Info | GCI_ID (employee identifier) |
| Bz_Timesheet_New                | Bz_New_Monthly_HC_Report     | gci id                   |
| Bz_vw_billing_timesheet_daywise_ne | Bz_Timesheet_New           | GCI_ID                   |
| Bz_vw_consultant_timesheet_daywise | Bz_Timesheet_New           | GCI_ID                   |
| Bz_DimDate                      | All date fields in other tables | Date, Holiday_Date, etc.|
| Bz_holidays_Mexico              | Bz_DimDate                   | Holiday_Date = Date      |
| Bz_holidays_Canada              | Bz_DimDate                   | Holiday_Date = Date      |
| Bz_holidays                     | Bz_DimDate                   | Holiday_Date = Date      |
| Bz_holidays_India               | Bz_DimDate                   | Holiday_Date = Date      |


5. Rationale and Assumptions
----------------------------
- All Bronze layer tables mirror the source structure exactly, excluding primary and foreign key fields, as per instructions.
- PII fields are classified based on GDPR and common data privacy standards.
- Metadata columns (load_timestamp, update_timestamp, source_system) are added to support data lineage, auditing, and traceability.
- Table names use the 'Bz_' prefix for consistency and clarity in the Bronze layer.
- Column descriptions are inferred from business context and naming conventions.
- Audit table is included for operational transparency and compliance.
- Relationships are documented based on common business keys and date fields.
- No GO statements or ellipses are used, and all columns are explicitly listed.

apiCost: 0.00
