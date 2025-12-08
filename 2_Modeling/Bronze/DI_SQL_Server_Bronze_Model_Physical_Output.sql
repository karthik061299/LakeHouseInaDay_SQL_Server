====================================================
Author:        AAVA
Date:          
Description:   Bronze Layer Physical Data Model - SQL Server DDL Scripts for Medallion Architecture
====================================================

/*
================================================================================
BRONZE LAYER PHYSICAL DATA MODEL - SQL SERVER DDL SCRIPTS
================================================================================

Purpose: This script creates the Bronze layer tables for the Medallion architecture
         on SQL Server. Bronze layer stores raw data as-is from source systems with
         metadata fields for tracking and lineage.

Design Principles:
- No primary keys, foreign keys, unique constraints, or indexes
- No identity columns
- HEAP table structure for raw data ingestion
- All source columns preserved exactly as-is
- Metadata columns added for tracking
- Schema: Bronze
- Table prefix: bz_

Storage Notes:
- All tables created as HEAP tables (no clustered index) for optimal raw data ingestion
- Consider partitioning for large tables based on load_timestamp
- Implement appropriate backup and retention policies

================================================================================
*/

-- Create Bronze schema if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Bronze')
BEGIN
    EXEC('CREATE SCHEMA Bronze')
END

/*
================================================================================
TABLE 1: Bronze.bz_New_Monthly_HC_Report
================================================================================
Description: Bronze layer table capturing raw monthly headcount report data from 
             source system, maintaining exact structure for audit and lineage purposes.
Source: source_layer.New_Monthly_HC_Report
================================================================================
*/

IF OBJECT_ID('Bronze.bz_New_Monthly_HC_Report', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_New_Monthly_HC_Report (
        [id] NUMERIC(18,0) NULL,
        [gci id] VARCHAR(50) NULL,
        [first name] VARCHAR(50) NULL,
        [last name] VARCHAR(50) NULL,
        [job title] VARCHAR(50) NULL,
        [hr_business_type] VARCHAR(50) NULL,
        [client code] VARCHAR(50) NULL,
        [start date] DATETIME NULL,
        [termdate] DATETIME NULL,
        [Final_End_date] DATETIME NULL,
        [NBR] MONEY NULL,
        [Merged Name] VARCHAR(100) NULL,
        [Super Merged Name] VARCHAR(100) NULL,
        [market] VARCHAR(50) NULL,
        [defined_New_VAS] VARCHAR(8) NULL,
        [IS_SOW] VARCHAR(7) NULL,
        [GP] MONEY NULL,
        [NextValue] DATETIME NULL,
        [termination_reason] VARCHAR(100) NULL,
        [FirstDay] DATETIME NULL,
        [Emp_Status] VARCHAR(25) NULL,
        [employee_category] VARCHAR(50) NULL,
        [LastDay] DATETIME NULL,
        [ee_wf_reason] VARCHAR(50) NULL,
        [old_Begin] NUMERIC(2,1) NULL,
        [Begin HC] NUMERIC(38,36) NULL,
        [Starts - New Project] NUMERIC(38,36) NULL,
        [Starts- Internal movements] NUMERIC(38,36) NULL,
        [Terms] NUMERIC(38,36) NULL,
        [Other project Ends] NUMERIC(38,36) NULL,
        [OffBoard] NUMERIC(38,36) NULL,
        [End HC] NUMERIC(38,36) NULL,
        [Vol_term] NUMERIC(38,36) NULL,
        [adj] NUMERIC(38,36) NULL,
        [YYMM] INT NULL,
        [tower1] VARCHAR(60) NULL,
        [req type] VARCHAR(50) NULL,
        [ITSSProjectName] VARCHAR(200) NULL,
        [IS_Offshore] VARCHAR(20) NULL,
        [Subtier] VARCHAR(50) NULL,
        [New_Visa_type] VARCHAR(50) NULL,
        [Practice_type] VARCHAR(50) NULL,
        [vertical] VARCHAR(50) NULL,
        [CL_Group] VARCHAR(32) NULL,
        [salesrep] VARCHAR(50) NULL,
        [recruiter] VARCHAR(50) NULL,
        [PO_End] DATETIME NULL,
        [PO_End_Count] NUMERIC(38,36) NULL,
        [Derived_Rev] REAL NULL,
        [Derived_GP] REAL NULL,
        [Backlog_Rev] REAL NULL,
        [Backlog_GP] REAL NULL,
        [Expected_Hrs] REAL NULL,
        [Expected_Total_Hrs] REAL NULL,
        [ITSS] VARCHAR(100) NULL,
        [client_entity] VARCHAR(50) NULL,
        [newtermdate] DATETIME NULL,
        [Newoffboardingdate] DATETIME NULL,
        [HWF_Process_name] VARCHAR(100) NULL,
        [Derived_System_End_date] DATETIME NULL,
        [Cons_Ageing] INT NULL,
        [CP_Name] NVARCHAR(50) NULL,
        [bill st units] VARCHAR(50) NULL,
        [project city] VARCHAR(50) NULL,
        [project state] VARCHAR(50) NULL,
        [OpportunityID] VARCHAR(50) NULL,
        [OpportunityName] VARCHAR(200) NULL,
        [Bus_days] REAL NULL,
        [circle] VARCHAR(100) NULL,
        [community_new] VARCHAR(100) NULL,
        [ALT] NVARCHAR(50) NULL,
        [Market_Leader] VARCHAR(MAX) NULL,
        [Acct_Owner] NVARCHAR(50) NULL,
        [st_yymm] INT NULL,
        [PortfolioLeader] VARCHAR(MAX) NULL,
        [ClientPartner] VARCHAR(MAX) NULL,
        [FP_Proj_ID] VARCHAR(10) NULL,
        [FP_Proj_Name] VARCHAR(MAX) NULL,
        [FP_TM] VARCHAR(2) NULL,
        [project_type] VARCHAR(500) NULL,
        [FP_Proj_Planned] VARCHAR(10) NULL,
        [Standard Job Title Horizon] NVARCHAR(2000) NULL,
        [Experience Level Title] VARCHAR(200) NULL,
        [User_Name] VARCHAR(50) NULL,
        [Status] VARCHAR(50) NULL,
        [asstatus] VARCHAR(50) NULL,
        [system_runtime] DATETIME NULL,
        [BR_Start_date] DATETIME NULL,
        [Bill_ST] FLOAT NULL,
        [Prev_BR] FLOAT NULL,
        [ProjType] VARCHAR(2) NULL,
        [Mons_in_Same_Rate] INT NULL,
        [Rate_Time_Gr] VARCHAR(20) NULL,
        [Rate_Change_Type] VARCHAR(20) NULL,
        [Net_Addition] NUMERIC(38,36) NULL,
        [load_timestamp] DATETIME2 NULL,
        [update_timestamp] DATETIME2 NULL,
        [source_system] VARCHAR(100) NULL
    )
END

/*
================================================================================
TABLE 2: Bronze.bz_SchTask
================================================================================
Description: Bronze layer table capturing raw scheduled task data from source 
             system, tracking workflow processes and task assignments.
Source: source_layer.SchTask
================================================================================
*/

IF OBJECT_ID('Bronze.bz_SchTask', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_SchTask (
        [SSN] VARCHAR(50) NULL,
        [GCI_ID] VARCHAR(50) NULL,
        [FName] VARCHAR(50) NULL,
        [LName] VARCHAR(50) NULL,
        [Process_ID] NUMERIC(18,0) NULL,
        [Level_ID] INT NULL,
        [Last_Level] INT NULL,
        [Initiator] VARCHAR(50) NULL,
        [Initiator_Mail] VARCHAR(50) NULL,
        [Status] VARCHAR(50) NULL,
        [Comments] VARCHAR(8000) NULL,
        [DateCreated] DATETIME NULL,
        [TrackID] VARCHAR(50) NULL,
        [DateCompleted] DATETIME NULL,
        [Existing_Resource] VARCHAR(3) NULL,
        [Term_ID] NUMERIC(18,0) NULL,
        [legal_entity] VARCHAR(50) NULL,
        [load_timestamp] DATETIME2 NULL,
        [update_timestamp] DATETIME2 NULL,
        [source_system] VARCHAR(100) NULL
    )
END

/*
================================================================================
TABLE 3: Bronze.bz_Hiring_Initiator_Project_Info
================================================================================
Description: Bronze layer table capturing raw hiring and project information data,
             containing comprehensive candidate and project details.
Source: source_layer.Hiring_Initiator_Project_Info
================================================================================
*/

IF OBJECT_ID('Bronze.bz_Hiring_Initiator_Project_Info', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_Hiring_Initiator_Project_Info (
        [Candidate_LName] VARCHAR(50) NULL,
        [Candidate_MI] VARCHAR(50) NULL,
        [Candidate_FName] VARCHAR(50) NULL,
        [Candidate_SSN] VARCHAR(50) NULL,
        [HR_Candidate_JobTitle] VARCHAR(50) NULL,
        [HR_Candidate_JobDescription] VARCHAR(100) NULL,
        [HR_Candidate_DOB] VARCHAR(50) NULL,
        [HR_Candidate_Employee_Type] VARCHAR(50) NULL,
        [HR_Project_Referred_By] VARCHAR(50) NULL,
        [HR_Project_Referral_Fees] VARCHAR(50) NULL,
        [HR_Project_Referral_Units] VARCHAR(50) NULL,
        [HR_Relocation_Request] VARCHAR(50) NULL,
        [HR_Relocation_departure_city] VARCHAR(50) NULL,
        [HR_Relocation_departure_state] VARCHAR(50) NULL,
        [HR_Relocation_departure_airport] VARCHAR(50) NULL,
        [HR_Relocation_departure_date] VARCHAR(50) NULL,
        [HR_Relocation_departure_time] VARCHAR(50) NULL,
        [HR_Relocation_arrival_city] VARCHAR(50) NULL,
        [HR_Relocation_arrival_state] VARCHAR(50) NULL,
        [HR_Relocation_arrival_airport] VARCHAR(50) NULL,
        [HR_Relocation_arrival_date] VARCHAR(50) NULL,
        [HR_Relocation_arrival_time] VARCHAR(50) NULL,
        [HR_Relocation_AccomodationStartDate] VARCHAR(50) NULL,
        [HR_Relocation_AccomodationEndDate] VARCHAR(50) NULL,
        [HR_Relocation_AccomodationStartTime] VARCHAR(50) NULL,
        [HR_Relocation_AccomodationEndTime] VARCHAR(50) NULL,
        [HR_Relocation_CarPickup_Place] VARCHAR(50) NULL,
        [HR_Relocation_CarPickup_AddressLine1] VARCHAR(50) NULL,
        [HR_Relocation_CarPickup_AddressLine2] VARCHAR(50) NULL,
        [HR_Relocation_CarPickup_City] VARCHAR(50) NULL,
        [HR_Relocation_CarPickup_State] VARCHAR(50) NULL,
        [HR_Relocation_CarPickup_Zip] VARCHAR(50) NULL,
        [HR_Relocation_CarReturn_City] VARCHAR(50) NULL,
        [HR_Relocation_CarReturn_State] VARCHAR(50) NULL,
        [HR_Relocation_CarReturn_Place] VARCHAR(50) NULL,
        [HR_Relocation_CarReturn_AddressLine1] VARCHAR(50) NULL,
        [HR_Relocation_CarReturn_AddressLine2] VARCHAR(50) NULL,
        [HR_Relocation_CarReturn_Zip] VARCHAR(50) NULL,
        [HR_Relocation_RentalCarStartDate] VARCHAR(50) NULL,
        [HR_Relocation_RentalCarEndDate] VARCHAR(50) NULL,
        [HR_Relocation_RentalCarStartTime] VARCHAR(50) NULL,
        [HR_Relocation_RentalCarEndTime] VARCHAR(50) NULL,
        [HR_Relocation_MaxClientInvoice] VARCHAR(50) NULL,
        [HR_Relocation_approving_manager] VARCHAR(50) NULL,
        [HR_Relocation_Notes] VARCHAR(5000) NULL,
        [HR_Recruiting_Manager] VARCHAR(50) NULL,
        [HR_Recruiting_AccountExecutive] VARCHAR(50) NULL,
        [HR_Recruiting_Recruiter] VARCHAR(50) NULL,
        [HR_Recruiting_ResourceManager] VARCHAR(50) NULL,
        [HR_Recruiting_Office] VARCHAR(50) NULL,
        [HR_Recruiting_ReqNo] VARCHAR(100) NULL,
        [HR_Recruiting_Direct] VARCHAR(50) NULL,
        [HR_Recruiting_Replacement_For_GCIID] VARCHAR(50) NULL,
        [HR_Recruiting_Replacement_For] VARCHAR(50) NULL,
        [HR_Recruiting_Replacement_Reason] VARCHAR(50) NULL,
        [HR_ClientInfo_ID] VARCHAR(50) NULL,
        [HR_ClientInfo_Name] VARCHAR(60) NULL,
        [HR_ClientInfo_DNB] VARCHAR(50) NULL,
        [HR_ClientInfo_Sector] VARCHAR(50) NULL,
        [HR_ClientInfo_Manager_ID] VARCHAR(50) NULL,
        [HR_ClientInfo_Manager] VARCHAR(50) NULL,
        [HR_ClientInfo_Phone] VARCHAR(50) NULL,
        [HR_ClientInfo_Phone_Extn] VARCHAR(50) NULL,
        [HR_ClientInfo_Email] VARCHAR(50) NULL,
        [HR_ClientInfo_Fax] VARCHAR(50) NULL,
        [HR_ClientInfo_Cell] VARCHAR(50) NULL,
        [HR_ClientInfo_Pager] VARCHAR(50) NULL,
        [HR_ClientInfo_Pager_Pin] VARCHAR(50) NULL,
        [HR_ClientAgreements_SendTo] VARCHAR(50) NULL,
        [HR_ClientAgreements_Phone] VARCHAR(50) NULL,
        [HR_ClientAgreements_Phone_Extn] VARCHAR(50) NULL,
        [HR_ClientAgreements_Email] VARCHAR(50) NULL,
        [HR_ClientAgreements_Fax] VARCHAR(50) NULL,
        [HR_ClientAgreements_Cell] VARCHAR(50) NULL,
        [HR_ClientAgreements_Pager] VARCHAR(50) NULL,
        [HR_ClientAgreements_Pager_Pin] VARCHAR(50) NULL,
        [HR_Project_SendInvoicesTo] VARCHAR(100) NULL,
        [HR_Project_AddressToSend1] VARCHAR(150) NULL,
        [HR_Project_AddressToSend2] VARCHAR(150) NULL,
        [HR_Project_City] VARCHAR(50) NULL,
        [HR_Project_State] VARCHAR(50) NULL,
        [HR_Project_Zip] VARCHAR(50) NULL,
        [HR_Project_Phone] VARCHAR(50) NULL,
        [HR_Project_Phone_Extn] VARCHAR(50) NULL,
        [HR_Project_Email] VARCHAR(50) NULL,
        [HR_Project_Fax] VARCHAR(50) NULL,
        [HR_Project_Cell] VARCHAR(50) NULL,
        [HR_Project_Pager] VARCHAR(50) NULL,
        [HR_Project_Pager_Pin] VARCHAR(50) NULL,
        [HR_Project_ST] VARCHAR(50) NULL,
        [HR_Project_OT] VARCHAR(50) NULL,
        [HR_Project_ST_Off] VARCHAR(50) NULL,
        [HR_Project_OT_Off] VARCHAR(50) NULL,
        [HR_Project_ST_Units] VARCHAR(50) NULL,
        [HR_Project_OT_Units] VARCHAR(50) NULL,
        [HR_Project_ST_Off_Units] VARCHAR(50) NULL,
        [HR_Project_OT_Off_Units] VARCHAR(50) NULL,
        [HR_Project_StartDate] VARCHAR(50) NULL,
        [HR_Project_EndDate] VARCHAR(50) NULL,
        [HR_Project_Location_AddressLine1] VARCHAR(50) NULL,
        [HR_Project_Location_AddressLine2] VARCHAR(50) NULL,
        [HR_Project_Location_City] VARCHAR(50) NULL,
        [HR_Project_Location_State] VARCHAR(50) NULL,
        [HR_Project_Location_Zip] VARCHAR(50) NULL,
        [HR_Project_InvoicingTerms] VARCHAR(50) NULL,
        [HR_Project_PaymentTerms] VARCHAR(50) NULL,
        [HR_Project_EndClient_ID] VARCHAR(50) NULL,
        [HR_Project_EndClient_Name] VARCHAR(60) NULL,
        [HR_Project_EndClient_Sector] VARCHAR(50) NULL,
        [HR_Accounts_Person] VARCHAR(50) NULL,
        [HR_Accounts_PhoneNo] VARCHAR(50) NULL,
        [HR_Accounts_PhoneNo_Extn] VARCHAR(50) NULL,
        [HR_Accounts_Email] VARCHAR(50) NULL,
        [HR_Accounts_FaxNo] VARCHAR(50) NULL,
        [HR_Accounts_Cell] VARCHAR(50) NULL,
        [HR_Accounts_Pager] VARCHAR(50) NULL,
        [HR_Accounts_Pager_Pin] VARCHAR(50) NULL,
        [HR_Project_Referrer_ID] VARCHAR(50) NULL,
        [UserCreated] VARCHAR(50) NULL,
        [DateCreated] VARCHAR(50) NULL,
        [HR_Week_Cycle] INT NULL,
        [Project_Name] VARCHAR(255) NULL,
        [transition] VARCHAR(50) NULL,
        [Is_OT_Allowed] VARCHAR(50) NULL,
        [HR_Business_Type] VARCHAR(50) NULL,
        [WebXl_EndClient_ID] VARCHAR(50) NULL,
        [WebXl_EndClient_Name] VARCHAR(60) NULL,
        [Client_Offer_Acceptance_Date] VARCHAR(50) NULL,
        [Project_Type] VARCHAR(50) NULL,
        [req_division] VARCHAR(200) NULL,
        [Client_Compliance_Checks_Reqd] VARCHAR(50) NULL,
        [HSU] VARCHAR(50) NULL,
        [HSUDM] VARCHAR(50) NULL,
        [Payroll_Location] VARCHAR(50) NULL,
        [Is_DT_Allowed] VARCHAR(50) NULL,
        [SBU] VARCHAR(2) NULL,
        [BU] VARCHAR(50) NULL,
        [Dept] VARCHAR(2) NULL,
        [HCU] VARCHAR(50) NULL,
        [Project_Category] VARCHAR(50) NULL,
        [Delivery_Model] VARCHAR(50) NULL,
        [BPOS_Project] VARCHAR(3) NULL,
        [ER_Person] VARCHAR(50) NULL,
        [Print_Invoice_Address1] VARCHAR(100) NULL,
        [Print_Invoice_Address2] VARCHAR(100) NULL,
        [Print_Invoice_City] VARCHAR(50) NULL,
        [Print_Invoice_State] VARCHAR(50) NULL,
        [Print_Invoice_Zip] VARCHAR(50) NULL,
        [Mail_Invoice_Address1] VARCHAR(100) NULL,
        [Mail_Invoice_Address2] VARCHAR(100) NULL,
        [Mail_Invoice_City] VARCHAR(50) NULL,
        [Mail_Invoice_State] VARCHAR(50) NULL,
        [Mail_Invoice_Zip] VARCHAR(50) NULL,
        [Project_Zone] VARCHAR(50) NULL,
        [Emp_Identifier] VARCHAR(50) NULL,
        [CRE_Person] VARCHAR(50) NULL,
        [HR_Project_Location_Country] VARCHAR(50) NULL,
        [Agency] VARCHAR(50) NULL,
        [pwd] VARCHAR(50) NULL,
        [PES_Doc_Sent] VARCHAR(50) NULL,
        [PES_Confirm_Doc_Rcpt] VARCHAR(50) NULL,
        [PES_Clearance_Rcvd] VARCHAR(50) NULL,
        [PES_Doc_Sent_Date] VARCHAR(50) NULL,
        [PES_Confirm_Doc_Rcpt_Date] VARCHAR(50) NULL,
        [PES_Clearance_Rcvd_Date] VARCHAR(50) NULL,
        [Inv_Pay_Terms_Notes] VARCHAR(MAX) NULL,
        [CBC_Notes] VARCHAR(MAX) NULL,
        [Benefits_Plan] VARCHAR(50) NULL,
        [BillingCompany] VARCHAR(50) NULL,
        [SPINOFF_CPNY] VARCHAR(50) NULL,
        [Position_Type] VARCHAR(50) NULL,
        [I9_Approver] VARCHAR(50) NULL,
        [FP_BILL_Rate] VARCHAR(50) NULL,
        [TSLead] VARCHAR(50) NULL,
        [Inside_Sales] VARCHAR(50) NULL,
        [Markup] VARCHAR(50) NULL,
        [Maximum_Allowed_Markup] VARCHAR(50) NULL,
        [Actual_Markup] VARCHAR(50) NULL,
        [SCA_Hourly_Bill_Rate] VARCHAR(50) NULL,
        [HR_Project_StartDate_Change_Reason] VARCHAR(100) NULL,
        [source] VARCHAR(50) NULL,
        [HR_Recruiting_VMO] VARCHAR(50) NULL,
        [HR_Recruiting_Inside_Sales] VARCHAR(50) NULL,
        [HR_Recruiting_TL] VARCHAR(50) NULL,
        [HR_Recruiting_NAM] VARCHAR(50) NULL,
        [HR_Recruiting_ARM] VARCHAR(50) NULL,
        [HR_Recruiting_RM] VARCHAR(50) NULL,
        [HR_Recruiting_ReqID] VARCHAR(50) NULL,
        [HR_Recruiting_TAG] VARCHAR(50) NULL,
        [DateUpdated] VARCHAR(50) NULL,
        [UserUpdated] VARCHAR(50) NULL,
        [Is_Swing_Shift_Associated_With_It] VARCHAR(50) NULL,
        [FP_Bill_Rate_OT] VARCHAR(50) NULL,
        [Not_To_Exceed_YESNO] VARCHAR(10) NULL,
        [Exceed_YESNO] VARCHAR(10) NULL,
        [Is_OT_Billable] VARCHAR(5) NULL,
        [Is_premium_project_Associated_With_It] VARCHAR(50) NULL,
        [ITSS_Business_Development_Manager] VARCHAR(50) NULL,
        [Practice_type] VARCHAR(50) NULL,
        [Project_billing_type] VARCHAR(50) NULL,
        [Resource_billing_type] VARCHAR(50) NULL,
        [Type_Consultant_category] VARCHAR(50) NULL,
        [Unique_identification_ID_Doc] VARCHAR(100) NULL,
        [Region1] VARCHAR(100) NULL,
        [Region2] VARCHAR(100) NULL,
        [Region1_percentage] VARCHAR(10) NULL,
        [Region2_percentage] VARCHAR(10) NULL,
        [Soc_Code] VARCHAR(300) NULL,
        [Soc_Desc] VARCHAR(300) NULL,
        [req_duration] INT NULL,
        [Non_Billing_Type] VARCHAR(50) NULL,
        [Worker_Entity_ID] VARCHAR(30) NULL,
        [OraclePersonID] VARCHAR(30) NULL,
        [Collabera_Email_ID] VARCHAR(100) NULL,
        [Onsite_Consultant_Relationship_Manager] VARCHAR(50) NULL,
        [HR_project_county] VARCHAR(100) NULL,
        [EE_WF_Reasons] VARCHAR(50) NULL,
        [GradeName] VARCHAR(50) NULL,
        [ROLEFAMILY] VARCHAR(50) NULL,
        [SUBDEPARTMENT] VARCHAR(100) NULL,
        [MSProjectType] VARCHAR(50) NULL,
        [NetsuiteProjectId] VARCHAR(50) NULL,
        [NetsuiteCreatedDate] VARCHAR(50) NULL,
        [NetsuiteModifiedDate] VARCHAR(50) NULL,
        [StandardJobTitle] VARCHAR(100) NULL,
        [community] VARCHAR(100) NULL,
        [parent_Account_name] VARCHAR(100) NULL,
        [Timesheet_Manager] VARCHAR(255) NULL,
        [TimeSheetManagerType] VARCHAR(255) NULL,
        [Timesheet_Manager_Phone] VARCHAR(255) NULL,
        [Timesheet_Manager_Email] VARCHAR(255) NULL,
        [HR_Project_Major_Group] VARCHAR(255) NULL,
        [HR_Project_Minor_Group] VARCHAR(255) NULL,
        [HR_Project_Broad_Group] VARCHAR(255) NULL,
        [HR_Project_Detail_Group] VARCHAR(255) NULL,
        [9Hours_Allowed] VARCHAR(3) NULL,
        [9Hours_Effective_Date] VARCHAR(50) NULL,
        [load_timestamp] DATETIME2 NULL,
        [update_timestamp] DATETIME2 NULL,
        [source_system] VARCHAR(100) NULL
    )
END

/*
================================================================================
TABLE 4: Bronze.bz_Timesheet_New
================================================================================
Description: Bronze layer table capturing raw timesheet data from source system,
             tracking employee time entries across various categories.
Source: source_layer.Timesheet_New
================================================================================
*/

IF OBJECT_ID('Bronze.bz_Timesheet_New', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_Timesheet_New (
        [gci_id] INT NULL,
        [pe_date] DATETIME NULL,
        [task_id] NUMERIC(18,9) NULL,
        [c_date] DATETIME NULL,
        [ST] FLOAT NULL,
        [OT] FLOAT NULL,
        [TIME_OFF] FLOAT NULL,
        [HO] FLOAT NULL,
        [DT] FLOAT NULL,
        [NON_ST] FLOAT NULL,
        [NON_OT] FLOAT NULL,
        [Sick_Time] FLOAT NULL,
        [NON_Sick_Time] FLOAT NULL,
        [NON_DT] FLOAT NULL,
        [load_timestamp] DATETIME2 NULL,
        [update_timestamp] DATETIME2 NULL,
        [source_system] VARCHAR(100) NULL
    )
END

/*
================================================================================
TABLE 5: Bronze.bz_report_392_all
================================================================================
Description: Bronze layer table capturing raw comprehensive report data from 
             source system, containing detailed employee, project, and financial information.
Source: source_layer.report_392_all
================================================================================
*/

IF OBJECT_ID('Bronze.bz_report_392_all', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_report_392_all (
        [id] NUMERIC(18,9) NULL,
        [gci id] VARCHAR(50) NULL,
        [first name] VARCHAR(50) NULL,
        [last name] VARCHAR(50) NULL,
        [employee type] VARCHAR(8000) NULL,
        [recruiting manager] VARCHAR(50) NULL,
        [resource manager] VARCHAR(50) NULL,
        [salesrep] VARCHAR(50) NULL,
        [inside_sales] VARCHAR(50) NULL,
        [recruiter] VARCHAR(50) NULL,
        [req type] VARCHAR(50) NULL,
        [ms_type] VARCHAR(28) NULL,
        [client code] VARCHAR(50) NULL,
        [client name] VARCHAR(60) NULL,
        [client_type] VARCHAR(50) NULL,
        [job title] VARCHAR(50) NULL,
        [bill st] VARCHAR(50) NULL,
        [visa type] VARCHAR(50) NULL,
        [bill st units] VARCHAR(50) NULL,
        [salary] MONEY NULL,
        [salary units] VARCHAR(50) NULL,
        [pay st] FLOAT NULL,
        [pay st units] VARCHAR(50) NULL,
        [start date] DATETIME NULL,
        [end date] DATETIME NULL,
        [po start date] VARCHAR(50) NULL,
        [po end date] VARCHAR(50) NULL,
        [project city] VARCHAR(50) NULL,
        [project state] VARCHAR(50) NULL,
        [no of free hours] VARCHAR(50) NULL,
        [hr_business_type] VARCHAR(50) NULL,
        [ee_wf_reason] VARCHAR(50) NULL,
        [singleman company] VARCHAR(50) NULL,
        [status] VARCHAR(50) NULL,
        [termination_reason] VARCHAR(100) NULL,
        [wf created on] DATETIME NULL,
        [hcu] VARCHAR(50) NULL,
        [hsu] VARCHAR(50) NULL,
        [project zip] VARCHAR(50) NULL,
        [cre_person] VARCHAR(50) NULL,
        [assigned_hsu] VARCHAR(10) NULL,
        [req_category] VARCHAR(50) NULL,
        [gpm] MONEY NULL,
        [gp] MONEY NULL,
        [aca_cost] REAL NULL,
        [aca_classification] VARCHAR(50) NULL,
        [markup] VARCHAR(3) NULL,
        [actual_markup] VARCHAR(50) NULL,
        [maximum_allowed_markup] VARCHAR(50) NULL,
        [submitted_bill_rate] MONEY NULL,
        [req_division] VARCHAR(200) NULL,
        [pay rate to consultant] VARCHAR(50) NULL,
        [location] VARCHAR(50) NULL,
        [rec_region] VARCHAR(50) NULL,
        [client_region] VARCHAR(50) NULL,
        [dm] VARCHAR(50) NULL,
        [delivery_director] VARCHAR(50) NULL,
        [bu] VARCHAR(50) NULL,
        [es] VARCHAR(50) NULL,
        [nam] VARCHAR(50) NULL,
        [client_sector] VARCHAR(50) NULL,
        [skills] VARCHAR(2500) NULL,
        [pskills] VARCHAR(4000) NULL,
        [business_manager] NVARCHAR(MAX) NULL,
        [vmo] VARCHAR(50) NULL,
        [rec_name] VARCHAR(500) NULL,
        [Req_ID] NUMERIC(18,9) NULL,
        [received] DATETIME NULL,
        [Submitted] DATETIME NULL,
        [responsetime] VARCHAR(53) NULL,
        [Inhouse] VARCHAR(3) NULL,
        [Net_Bill_Rate] MONEY NULL,
        [Loaded_Pay_Rate] MONEY NULL,
        [NSO] VARCHAR(100) NULL,
        [ESG_Vertical] VARCHAR(100) NULL,
        [ESG_Industry] VARCHAR(100) NULL,
        [ESG_DNA] VARCHAR(100) NULL,
        [ESG_NAM1] VARCHAR(100) NULL,
        [ESG_NAM2] VARCHAR(100) NULL,
        [ESG_NAM3] VARCHAR(100) NULL,
        [ESG_SAM] VARCHAR(100) NULL,
        [ESG_ES] VARCHAR(100) NULL,
        [ESG_BU] VARCHAR(100) NULL,
        [SUB_GPM] MONEY NULL,
        [manager_id] NUMERIC(18,9) NULL,
        [Submitted_By] VARCHAR(50) NULL,
        [HWF_Process_name] VARCHAR(100) NULL,
        [Transition] VARCHAR(100) NULL,
        [ITSS] VARCHAR(100) NULL,
        [GP2020] MONEY NULL,
        [GPM2020] MONEY NULL,
        [isbulk] BIT NULL,
        [jump] BIT NULL,
        [client_class] VARCHAR(20) NULL,
        [MSP] VARCHAR(50) NULL,
        [DTCUChoice1] VARCHAR(60) NULL,
        [SubCat] VARCHAR(60) NULL,
        [IsClassInitiative] BIT NULL,
        [division] VARCHAR(50) NULL,
        [divstart_date] DATETIME NULL,
        [divend_date] DATETIME NULL,
        [tl] VARCHAR(50) NULL,
        [resource_manager] VARCHAR(50) NULL,
        [recruiting_manager] VARCHAR(50) NULL,
        [VAS_Type] VARCHAR(100) NULL,
        [BUCKET] VARCHAR(50) NULL,
        [RTR_DM] VARCHAR(50) NULL,
        [ITSSProjectName] VARCHAR(200) NULL,
        [RegionGroup] VARCHAR(50) NULL,
        [client_Markup] VARCHAR(20) NULL,
        [Subtier] VARCHAR(50) NULL,
        [Subtier_Address1] VARCHAR(50) NULL,
        [Subtier_Address2] VARCHAR(50) NULL,
        [Subtier_City] VARCHAR(50) NULL,
        [Subtier_State] VARCHAR(50) NULL,
        [Hiresource] VARCHAR(100) NULL,
        [is_Hotbook_Hire] INT NULL,
        [Client_RM] VARCHAR(50) NULL,
        [Job_Description] VARCHAR(100) NULL,
        [Client_Manager] VARCHAR(50) NULL,
        [end_date_at_client] DATETIME NULL,
        [term_date] DATETIME NULL,
        [employee_status] VARCHAR(50) NULL,
        [Level_ID] INT NULL,
        [OpsGrp] VARCHAR(50) NULL,
        [Level_Name] VARCHAR(50) NULL,
        [Min_levelDatetime] DATETIME NULL,
        [Max_levelDatetime] DATETIME NULL,
        [First_Interview_date] DATETIME NULL,
        [Is REC CES?] VARCHAR(5) NULL,
        [Is CES Initiative?] VARCHAR(5) NULL,
        [VMO_Access] VARCHAR(50) NULL,
        [Billing_Type] VARCHAR(50) NULL,
        [VASSOW] VARCHAR(3) NULL,
        [Worker_Entity_ID] VARCHAR(30) NULL,
        [Circle] VARCHAR(50) NULL,
        [VMO_Access1] VARCHAR(50) NULL,
        [VMO_Access2] VARCHAR(50) NULL,
        [VMO_Access3] VARCHAR(50) NULL,
        [VMO_Access4] VARCHAR(50) NULL,
        [Inside_Sales_Person] VARCHAR(50) NULL,
        [admin_1701] VARCHAR(50) NULL,
        [corrected_staffadmin_1701] VARCHAR(50) NULL,
        [HR_Billing_Placement_Net_Fee] MONEY NULL,
        [New_Visa_type] VARCHAR(50) NULL,
        [newenddate] DATETIME NULL,
        [Newoffboardingdate] DATETIME NULL,
        [NewTermdate] DATETIME NULL,
        [newhrisenddate] DATETIME NULL,
        [rtr_location] VARCHAR(50) NULL,
        [HR_Recruiting_TL] VARCHAR(100) NULL,
        [client_entity] VARCHAR(50) NULL,
        [client_consent] BIT NULL,
        [Ascendion_MetalReqID] NUMERIC(18,9) NULL,
        [eeo] VARCHAR(200) NULL,
        [veteran] VARCHAR(150) NULL,
        [Gender] VARCHAR(50) NULL,
        [Er_person] VARCHAR(50) NULL,
        [wfmetaljobdescription] NVARCHAR(MAX) NULL,
        [HR_Candidate_Salary] MONEY NULL,
        [Interview_CreatedDate] DATETIME NULL,
        [Interview_on_Date] DATETIME NULL,
        [IS_SOW] VARCHAR(7) NULL,
        [IS_Offshore] VARCHAR(20) NULL,
        [New_VAS] VARCHAR(4) NULL,
        [VerticalName] NVARCHAR(510) NULL,
        [Client_Group1] VARCHAR(19) NULL,
        [Billig_Type] VARCHAR(8) NULL,
        [Super Merged Name] VARCHAR(200) NULL,
        [New_Category] VARCHAR(11) NULL,
        [New_business_type] VARCHAR(100) NULL,
        [OpportunityID] VARCHAR(50) NULL,
        [OpportunityName] VARCHAR(200) NULL,
        [Ms_ProjectId] INT NULL,
        [MS_ProjectName] VARCHAR(200) NULL,
        [ORC_ID] VARCHAR(30) NULL,
        [Market_Leader] NVARCHAR(MAX) NULL,
        [Circle_Metal] VARCHAR(100) NULL,
        [Community_New_Metal] VARCHAR(100) NULL,
        [Employee_Category] VARCHAR(50) NULL,
        [IsBillRateSkip] BIT NULL,
        [BillRate] DECIMAL(18,9) NULL,
        [RoleFamily] VARCHAR(300) NULL,
        [SubRoleFamily] VARCHAR(300) NULL,
        [Standard JobTitle] VARCHAR(500) NULL,
        [ClientInterviewRequired] INT NULL,
        [Redeploymenthire] INT NULL,
        [HRBrandLevelId] INT NULL,
        [HRBandTitle] VARCHAR(300) NULL,
        [latest_termination_reason] VARCHAR(200) NULL,
        [latest_termination_date] DATETIME NULL,
        [Community] VARCHAR(100) NULL,
        [ReqFulfillmentReason] VARCHAR(200) NULL,
        [EngagementType] VARCHAR(500) NULL,
        [RedepLedBy] VARCHAR(200) NULL,
        [Can_ExperienceLevelTitle] VARCHAR(200) NULL,
        [Can_StandardJobTitleHorizon] NVARCHAR(4000) NULL,
        [CandidateEmail] VARCHAR(100) NULL,
        [Offboarding_Reason] VARCHAR(100) NULL,
        [Offboarding_Initiated] DATETIME NULL,
        [Offboarding_Status] VARCHAR(100) NULL,
        [replcament_GCIID] INT NULL,
        [replcament_EmployeeName] VARCHAR(500) NULL,
        [Senior Manager] VARCHAR(50) NULL,
        [Associate Manager] VARCHAR(50) NULL,
        [Director - Talent Engine] VARCHAR(50) NULL,
        [Manager] VARCHAR(50) NULL,
        [Rec_ExperienceLevelTitle] VARCHAR(200) NULL,
        [Rec_StandardJobTitleHorizon] NVARCHAR(4000) NULL,
        [Task_Id] INT NULL,
        [proj_ID] VARCHAR(50) NULL,
        [Projdesc] CHAR(60) NULL,
        [Client_Group] VARCHAR(19) NULL,
        [billST_New] FLOAT NULL,
        [Candidate city] VARCHAR(50) NULL,
        [Candidate State] VARCHAR(50) NULL,
        [C2C_W2_FTE] VARCHAR(13) NULL,
        [FP_TM] VARCHAR(2) NULL,
        [load_timestamp] DATETIME2 NULL,
        [update_timestamp] DATETIME2 NULL,
        [source_system] VARCHAR(100) NULL
    )
END

/*
================================================================================
TABLE 6: Bronze.bz_vw_billing_timesheet_daywise_ne
================================================================================
Description: Bronze layer table capturing raw billing timesheet daywise data from
             source system, tracking approved hours by category.
Source: source_layer.vw_billing_timesheet_daywise_ne
================================================================================
*/

IF OBJECT_ID('Bronze.bz_vw_billing_timesheet_daywise_ne', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_vw_billing_timesheet_daywise_ne (
        [ID] NUMERIC(18,9) NULL,
        [GCI_ID] INT NULL,
        [PE_DATE] DATETIME NULL,
        [WEEK_DATE] DATETIME NULL,
        [BILLABLE] VARCHAR(3) NULL,
        [Approved_hours(ST)] FLOAT NULL,
        [Approved_hours(Non_ST)] FLOAT NULL,
        [Approved_hours(OT)] FLOAT NULL,
        [Approved_hours(Non_OT)] FLOAT NULL,
        [Approved_hours(DT)] FLOAT NULL,
        [Approved_hours(Non_DT)] FLOAT NULL,
        [Approved_hours(Sick_Time)] FLOAT NULL,
        [Approved_hours(Non_Sick_Time)] FLOAT NULL,
        [load_timestamp] DATETIME2 NULL,
        [update_timestamp] DATETIME2 NULL,
        [source_system] VARCHAR(100) NULL
    )
END

/*
================================================================================
TABLE 7: Bronze.bz_vw_consultant_timesheet_daywise
================================================================================
Description: Bronze layer table capturing raw consultant timesheet daywise data
             from source system, tracking consultant-submitted hours.
Source: source_layer.vw_consultant_timesheet_daywise
================================================================================
*/

IF OBJECT_ID('Bronze.bz_vw_consultant_timesheet_daywise', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_vw_consultant_timesheet_daywise (
        [ID] NUMERIC(18,9) NULL,
        [GCI_ID] INT NULL,
        [PE_DATE] DATETIME NULL,
        [WEEK_DATE] DATETIME NULL,
        [BILLABLE] VARCHAR(3) NULL,
        [Consultant_hours(ST)] FLOAT NULL,
        [Consultant_hours(OT)] FLOAT NULL,
        [Consultant_hours(DT)] FLOAT NULL,
        [load_timestamp] DATETIME2 NULL,
        [update_timestamp] DATETIME2 NULL,
        [source_system] VARCHAR(100) NULL
    )
END

/*
================================================================================
TABLE 8: Bronze.bz_DimDate
================================================================================
Description: Bronze layer table capturing raw date dimension data from source system,
             providing comprehensive date attributes for time-based analysis.
Source: source_layer.DimDate
================================================================================
*/

IF OBJECT_ID('Bronze.bz_DimDate', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_DimDate (
        [Date] DATETIME NULL,
        [DayOfMonth] VARCHAR(2) NULL,
        [DayName] VARCHAR(9) NULL,
        [WeekOfYear] VARCHAR(2) NULL,
        [Month] VARCHAR(2) NULL,
        [MonthName] VARCHAR(9) NULL,
        [MonthOfQuarter] VARCHAR(2) NULL,
        [Quarter] CHAR(1) NULL,
        [QuarterName] VARCHAR(9) NULL,
        [Year] CHAR(4) NULL,
        [YearName] CHAR(7) NULL,
        [MonthYear] CHAR(10) NULL,
        [MMYYYY] CHAR(6) NULL,
        [DaysInMonth] INT NULL,
        [MM-YYYY] VARCHAR(10) NULL,
        [YYYYMM] VARCHAR(10) NULL,
        [load_timestamp] DATETIME2 NULL,
        [update_timestamp] DATETIME2 NULL,
        [source_system] VARCHAR(100) NULL
    )
END

/*
================================================================================
TABLE 9: Bronze.bz_holidays_Mexico
================================================================================
Description: Bronze layer table capturing raw Mexico holiday data from source system,
             containing holiday dates and descriptions for Mexico location.
Source: source_layer.holidays_Mexico
================================================================================
*/

IF OBJECT_ID('Bronze.bz_holidays_Mexico', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_holidays_Mexico (
        [Holiday_Date] DATETIME NULL,
        [Description] VARCHAR(50) NULL,
        [Location] VARCHAR(10) NULL,
        [Source_type] VARCHAR(50) NULL,
        [load_timestamp] DATETIME2 NULL,
        [update_timestamp] DATETIME2 NULL,
        [source_system] VARCHAR(100) NULL
    )
END

/*
================================================================================
TABLE 10: Bronze.bz_holidays_Canada
================================================================================
Description: Bronze layer table capturing raw Canada holiday data from source system,
             containing holiday dates and descriptions for Canada location.
Source: source_layer.holidays_Canada
================================================================================
*/

IF OBJECT_ID('Bronze.bz_holidays_Canada', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_holidays_Canada (
        [Holiday_Date] DATETIME NULL,
        [Description] VARCHAR(100) NULL,
        [Location] VARCHAR(10) NULL,
        [Source_type] VARCHAR(50) NULL,
        [load_timestamp] DATETIME2 NULL,
        [update_timestamp] DATETIME2 NULL,
        [source_system] VARCHAR(100) NULL
    )
END

/*
================================================================================
TABLE 11: Bronze.bz_holidays
================================================================================
Description: Bronze layer table capturing raw holiday data from source system,
             containing general holiday dates and descriptions.
Source: source_layer.holidays
================================================================================
*/

IF OBJECT_ID('Bronze.bz_holidays', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_holidays (
        [Holiday_Date] DATETIME NULL,
        [Description] VARCHAR(50) NULL,
        [Location] VARCHAR(10) NULL,
        [Source_type] VARCHAR(50) NULL,
        [load_timestamp] DATETIME2 NULL,
        [update_timestamp] DATETIME2 NULL,
        [source_system] VARCHAR(100) NULL
    )
END

/*
================================================================================
TABLE 12: Bronze.bz_holidays_India
================================================================================
Description: Bronze layer table capturing raw India holiday data from source system,
             containing holiday dates and descriptions for India location.
Source: source_layer.holidays_India
================================================================================
*/

IF OBJECT_ID('Bronze.bz_holidays_India', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_holidays_India (
        [Holiday_Date] DATETIME NULL,
        [Description] VARCHAR(50) NULL,
        [Location] VARCHAR(10) NULL,
        [Source_type] VARCHAR(50) NULL,
        [load_timestamp] DATETIME2 NULL,
        [update_timestamp] DATETIME2 NULL,
        [source_system] VARCHAR(100) NULL
    )
END

/*
================================================================================
AUDIT TABLE: Bronze.bz_Audit_Log
================================================================================
Description: Bronze layer audit table tracking all data loading and processing 
             activities for compliance, monitoring, and troubleshooting purposes.
================================================================================
*/

IF OBJECT_ID('Bronze.bz_Audit_Log', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_Audit_Log (
        [record_id] BIGINT NULL,
        [source_table] VARCHAR(100) NULL,
        [load_timestamp] DATETIME2 NULL,
        [processed_by] VARCHAR(100) NULL,
        [processing_time] FLOAT NULL,
        [status] VARCHAR(50) NULL,
        [records_processed] BIGINT NULL,
        [records_inserted] BIGINT NULL,
        [records_updated] BIGINT NULL,
        [records_failed] BIGINT NULL,
        [error_message] VARCHAR(MAX) NULL,
        [source_file_path] VARCHAR(500) NULL,
        [target_table] VARCHAR(200) NULL,
        [load_type] VARCHAR(50) NULL,
        [batch_id] VARCHAR(100) NULL,
        [start_timestamp] DATETIME2 NULL,
        [end_timestamp] DATETIME2 NULL,
        [row_count_source] BIGINT NULL,
        [row_count_target] BIGINT NULL,
        [data_quality_score] DECIMAL(5,2) NULL,
        [validation_status] VARCHAR(50) NULL,
        [created_date] DATETIME2 NULL,
        [modified_date] DATETIME2 NULL
    )
END

/*
================================================================================
CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORMAT)
================================================================================

This section documents the relationships between Bronze layer tables based on
common key fields and business logic.

--------------------------------------------------------------------------------
RELATIONSHIP MATRIX
--------------------------------------------------------------------------------

| Source Table                           | Target Table                           | Relationship Key Field                    | Relationship Type |
|----------------------------------------|----------------------------------------|-------------------------------------------|-------------------|
| bz_New_Monthly_HC_Report               | bz_SchTask                             | gci_id = GCI_ID                           | One-to-Many       |
| bz_New_Monthly_HC_Report               | bz_Hiring_Initiator_Project_Info       | gci_id = Worker_Entity_ID                 | One-to-One        |
| bz_New_Monthly_HC_Report               | bz_Timesheet_New                       | gci_id = gci_id                           | One-to-Many       |
| bz_New_Monthly_HC_Report               | bz_report_392_all                      | gci_id = gci_id                           | One-to-One        |
| bz_New_Monthly_HC_Report               | bz_vw_billing_timesheet_daywise_ne     | gci_id = GCI_ID                           | One-to-Many       |
| bz_New_Monthly_HC_Report               | bz_vw_consultant_timesheet_daywise     | gci_id = GCI_ID                           | One-to-Many       |
| bz_New_Monthly_HC_Report               | bz_DimDate                             | start_date = Date                         | Many-to-One       |
| bz_New_Monthly_HC_Report               | bz_DimDate                             | termdate = Date                           | Many-to-One       |
| bz_New_Monthly_HC_Report               | bz_holidays                            | date range overlap with Holiday_Date      | Many-to-Many      |
| bz_New_Monthly_HC_Report               | bz_holidays_Mexico                     | date range overlap with Holiday_Date      | Many-to-Many      |
| bz_New_Monthly_HC_Report               | bz_holidays_Canada                     | date range overlap with Holiday_Date      | Many-to-Many      |
| bz_New_Monthly_HC_Report               | bz_holidays_India                      | date range overlap with Holiday_Date      | Many-to-Many      |
| bz_SchTask                             | bz_Hiring_Initiator_Project_Info       | GCI_ID = Worker_Entity_ID                 | One-to-One        |
| bz_SchTask                             | bz_report_392_all                      | GCI_ID = gci_id                           | One-to-One        |
| bz_Hiring_Initiator_Project_Info       | bz_report_392_all                      | Worker_Entity_ID = gci_id                 | One-to-One        |
| bz_Hiring_Initiator_Project_Info       | bz_Timesheet_New                       | Worker_Entity_ID = gci_id                 | One-to-Many       |
| bz_Timesheet_New                       | bz_vw_billing_timesheet_daywise_ne     | gci_id = GCI_ID AND pe_date = PE_DATE     | One-to-One        |
| bz_Timesheet_New                       | bz_vw_consultant_timesheet_daywise     | gci_id = GCI_ID AND pe_date = PE_DATE     | One-to-One        |
| bz_Timesheet_New                       | bz_DimDate                             | pe_date = Date                            | Many-to-One       |
| bz_Timesheet_New                       | bz_holidays                            | pe_date = Holiday_Date                    | Many-to-Many      |
| bz_Timesheet_New                       | bz_holidays_Mexico                     | pe_date = Holiday_Date                    | Many-to-Many      |
| bz_Timesheet_New                       | bz_holidays_Canada                     | pe_date = Holiday_Date                    | Many-to-Many      |
| bz_Timesheet_New                       | bz_holidays_India                      | pe_date = Holiday_Date                    | Many-to-Many      |
| bz_report_392_all                      | bz_vw_billing_timesheet_daywise_ne     | gci_id = GCI_ID                           | One-to-Many       |
| bz_report_392_all                      | bz_vw_consultant_timesheet_daywise     | gci_id = GCI_ID                           | One-to-Many       |
| bz_report_392_all                      | bz_DimDate                             | start_date = Date                         | Many-to-One       |
| bz_report_392_all                      | bz_DimDate                             | end_date = Date                           | Many-to-One       |
| bz_vw_billing_timesheet_daywise_ne     | bz_DimDate                             | PE_DATE = Date                            | Many-to-One       |
| bz_vw_billing_timesheet_daywise_ne     | bz_DimDate                             | WEEK_DATE = Date                          | Many-to-One       |
| bz_vw_consultant_timesheet_daywise     | bz_DimDate                             | PE_DATE = Date                            | Many-to-One       |
| bz_vw_consultant_timesheet_daywise     | bz_DimDate                             | WEEK_DATE = Date                          | Many-to-One       |
| bz_Audit_Log                           | All Bronze Tables                      | source_table = Table Name                 | One-to-Many       |

--------------------------------------------------------------------------------
KEY FIELD DESCRIPTIONS
--------------------------------------------------------------------------------

1. gci_id / GCI_ID / Worker_Entity_ID: Global Consultant Identifier - Primary employee identifier
2. pe_date / PE_DATE: Period End Date - Timesheet period ending date
3. Date / Holiday_Date: Calendar date for date dimension and holiday tracking
4. start_date / end_date / termdate: Employment and project date ranges

================================================================================
*/

/*
================================================================================
END OF BRONZE LAYER PHYSICAL DATA MODEL
================================================================================

SUMMARY:
- Total Tables Created: 13 (12 Business Tables + 1 Audit Table)
- Total Columns: 683 (644 Business Columns + 39 Metadata Columns)
- Schema: Bronze
- Table Naming Convention: bz_<tablename>
- Storage Type: HEAP (No Clustered Index)
- Constraints: None (Raw data ingestion layer)
- Relationships: 31 documented relationships

NEXT STEPS:
1. Execute this script in SQL Server environment
2. Verify all tables are created successfully
3. Implement data loading processes
4. Configure monitoring and alerting on bz_Audit_Log
5. Proceed with Silver layer design

================================================================================
*/