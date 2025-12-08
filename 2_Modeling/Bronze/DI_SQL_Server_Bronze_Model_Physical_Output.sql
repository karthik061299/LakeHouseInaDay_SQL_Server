====================================================
Author:        AAVA
Date:          
Description:   Physical Data Model DDL Scripts for Bronze Layer - SQL Server Implementation
====================================================

/*
================================================================================
BRONZE LAYER PHYSICAL DATA MODEL - SQL SERVER DDL SCRIPTS
================================================================================

Purpose: This script contains complete SQL Server DDL statements for creating
         all Bronze layer tables in the Medallion architecture.

Layer: Bronze (Raw Data Layer)
Database: SQL Server
Schema: Bronze

Design Principles:
- Raw data storage without constraints
- HEAP tables for fast ingestion
- No primary keys, foreign keys, or indexes
- Metadata columns for tracking
- Idempotent CREATE TABLE statements

Usage: Execute this script in the target SQL Server database to create
       all Bronze layer tables.

================================================================================
*/

-- Create Bronze schema if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Bronze')
BEGIN
    EXEC('CREATE SCHEMA Bronze');
END
GO

/*
================================================================================
TABLE 1: Bronze.bz_New_Monthly_HC_Report
================================================================================
Description: Bronze layer table capturing monthly headcount report data from 
             source system. Contains employee assignment, project, financial, 
             and operational metrics.
Source: source_layer.New_Monthly_HC_Report
Storage: HEAP table for raw data ingestion
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
        load_timestamp DATETIME2 NULL,
        update_timestamp DATETIME2 NULL,
        source_system VARCHAR(100) NULL
    );
    -- Storage note: HEAP table for raw Bronze ingestion
END
GO

/*
================================================================================
TABLE 2: Bronze.bz_SchTask
================================================================================
Description: Bronze layer table capturing scheduled task and workflow information.
             Contains employee workflow processes, task assignments, and status tracking.
Source: source_layer.SchTask
Storage: HEAP table for raw data ingestion
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
        load_timestamp DATETIME2 NULL,
        update_timestamp DATETIME2 NULL,
        source_system VARCHAR(100) NULL
    );
    -- Storage note: HEAP table for raw Bronze ingestion
END
GO

/*
================================================================================
TABLE 3: Bronze.bz_Hiring_Initiator_Project_Info
================================================================================
Description: Bronze layer table capturing comprehensive hiring, candidate, project,
             and client information. Contains detailed information about candidates,
             projects, client agreements, billing rates, and relocation details.
Source: source_layer.Hiring_Initiator_Project_Info
Storage: HEAP table for raw data ingestion
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
        [Inv_Pay_Terms_Notes] TEXT NULL,
        [CBC_Notes] TEXT NULL,
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
        load_timestamp DATETIME2 NULL,
        update_timestamp DATETIME2 NULL,
        source_system VARCHAR(100) NULL
    );
    -- Storage note: HEAP table for raw Bronze ingestion
END
GO

/*
================================================================================
TABLE 4: Bronze.bz_Timesheet_New
================================================================================
Description: Bronze layer table capturing daily timesheet entries. Contains
             employee time tracking information including regular hours, overtime,
             time off, and various other time categories.
Source: source_layer.Timesheet_New
Storage: HEAP table for raw data ingestion
================================================================================
*/

IF OBJECT_ID('Bronze.bz_Timesheet_New', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_Timesheet_New (
        gci_id INT NULL,
        pe_date DATETIME NULL,
        task_id NUMERIC(18,9) NULL,
        c_date DATETIME NULL,
        ST FLOAT NULL,
        OT FLOAT NULL,
        TIME_OFF FLOAT NULL,
        HO FLOAT NULL,
        DT FLOAT NULL,
        NON_ST FLOAT NULL,
        NON_OT FLOAT NULL,
        Sick_Time FLOAT NULL,
        NON_Sick_Time FLOAT NULL,
        NON_DT FLOAT NULL,
        load_timestamp DATETIME2 NULL,
        update_timestamp DATETIME2 NULL,
        source_system VARCHAR(100) NULL
    );
    -- Storage note: HEAP table for raw Bronze ingestion
END
GO

/*
================================================================================
TABLE 5: Bronze.bz_report_392_all
================================================================================
Description: Bronze layer table capturing comprehensive employee and project
             reporting data. Contains detailed information about employees,
             assignments, clients, financial metrics, and recruiting details.
Source: source_layer.report_392_all
Storage: HEAP table for raw data ingestion
================================================================================
*/

IF OBJECT_ID('Bronze.bz_report_392_all', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_report_392_all (
        id NUMERIC(18,9) NULL,
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
        salary MONEY NULL,
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
        status VARCHAR(50) NULL,
        termination_reason VARCHAR(100) NULL,
        [wf created on] DATETIME NULL,
        hcu VARCHAR(50) NULL,
        hsu VARCHAR(50) NULL,
        [project zip] VARCHAR(50) NULL,
        cre_person VARCHAR(50) NULL,
        assigned_hsu VARCHAR(10) NULL,
        req_category VARCHAR(50) NULL,
        gpm MONEY NULL,
        gp MONEY NULL,
        aca_cost REAL NULL,
        aca_classification VARCHAR(50) NULL,
        markup VARCHAR(3) NULL,
        actual_markup VARCHAR(50) NULL,
        maximum_allowed_markup VARCHAR(50) NULL,
        submitted_bill_rate MONEY NULL,
        req_division VARCHAR(200) NULL,
        [pay rate to consultant] VARCHAR(50) NULL,
        location VARCHAR(50) NULL,
        rec_region VARCHAR(50) NULL,
        client_region VARCHAR(50) NULL,
        dm VARCHAR(50) NULL,
        delivery_director VARCHAR(50) NULL,
        bu VARCHAR(50) NULL,
        es VARCHAR(50) NULL,
        nam VARCHAR(50) NULL,
        client_sector VARCHAR(50) NULL,
        skills VARCHAR(2500) NULL,
        pskills VARCHAR(4000) NULL,
        business_manager NVARCHAR(MAX) NULL,
        vmo VARCHAR(50) NULL,
        rec_name VARCHAR(500) NULL,
        Req_ID NUMERIC(18,9) NULL,
        received DATETIME NULL,
        Submitted DATETIME NULL,
        responsetime VARCHAR(53) NULL,
        Inhouse VARCHAR(3) NULL,
        Net_Bill_Rate MONEY NULL,
        Loaded_Pay_Rate MONEY NULL,
        NSO VARCHAR(100) NULL,
        ESG_Vertical VARCHAR(100) NULL,
        ESG_Industry VARCHAR(100) NULL,
        ESG_DNA VARCHAR(100) NULL,
        ESG_NAM1 VARCHAR(100) NULL,
        ESG_NAM2 VARCHAR(100) NULL,
        ESG_NAM3 VARCHAR(100) NULL,
        ESG_SAM VARCHAR(100) NULL,
        ESG_ES VARCHAR(100) NULL,
        ESG_BU VARCHAR(100) NULL,
        SUB_GPM MONEY NULL,
        manager_id NUMERIC(18,9) NULL,
        Submitted_By VARCHAR(50) NULL,
        HWF_Process_name VARCHAR(100) NULL,
        Transition VARCHAR(100) NULL,
        ITSS VARCHAR(100) NULL,
        GP2020 MONEY NULL,
        GPM2020 MONEY NULL,
        isbulk BIT NULL,
        jump BIT NULL,
        client_class VARCHAR(20) NULL,
        MSP VARCHAR(50) NULL,
        DTCUChoice1 VARCHAR(60) NULL,
        SubCat VARCHAR(60) NULL,
        IsClassInitiative BIT NULL,
        division VARCHAR(50) NULL,
        divstart_date DATETIME NULL,
        divend_date DATETIME NULL,
        tl VARCHAR(50) NULL,
        resource_manager VARCHAR(50) NULL,
        recruiting_manager VARCHAR(50) NULL,
        VAS_Type VARCHAR(100) NULL,
        BUCKET VARCHAR(50) NULL,
        RTR_DM VARCHAR(50) NULL,
        ITSSProjectName VARCHAR(200) NULL,
        RegionGroup VARCHAR(50) NULL,
        client_Markup VARCHAR(20) NULL,
        Subtier VARCHAR(50) NULL,
        Subtier_Address1 VARCHAR(50) NULL,
        Subtier_Address2 VARCHAR(50) NULL,
        Subtier_City VARCHAR(50) NULL,
        Subtier_State VARCHAR(50) NULL,
        Hiresource VARCHAR(100) NULL,
        is_Hotbook_Hire INT NULL,
        Client_RM VARCHAR(50) NULL,
        Job_Description VARCHAR(100) NULL,
        Client_Manager VARCHAR(50) NULL,
        end_date_at_client DATETIME NULL,
        term_date DATETIME NULL,
        employee_status VARCHAR(50) NULL,
        Level_ID INT NULL,
        OpsGrp VARCHAR(50) NULL,
        Level_Name VARCHAR(50) NULL,
        Min_levelDatetime DATETIME NULL,
        Max_levelDatetime DATETIME NULL,
        First_Interview_date DATETIME NULL,
        [Is REC CES?] VARCHAR(5) NULL,
        [Is CES Initiative?] VARCHAR(5) NULL,
        VMO_Access VARCHAR(50) NULL,
        Billing_Type VARCHAR(50) NULL,
        VASSOW VARCHAR(3) NULL,
        Worker_Entity_ID VARCHAR(30) NULL,
        Circle VARCHAR(50) NULL,
        VMO_Access1 VARCHAR(50) NULL,
        VMO_Access2 VARCHAR(50) NULL,
        VMO_Access3 VARCHAR(50) NULL,
        VMO_Access4 VARCHAR(50) NULL,
        Inside_Sales_Person VARCHAR(50) NULL,
        admin_1701 VARCHAR(50) NULL,
        corrected_staffadmin_1701 VARCHAR(50) NULL,
        HR_Billing_Placement_Net_Fee MONEY NULL,
        New_Visa_type VARCHAR(50) NULL,
        newenddate DATETIME NULL,
        Newoffboardingdate DATETIME NULL,
        NewTermdate DATETIME NULL,
        newhrisenddate DATETIME NULL,
        rtr_location VARCHAR(50) NULL,
        HR_Recruiting_TL VARCHAR(100) NULL,
        client_entity VARCHAR(50) NULL,
        client_consent BIT NULL,
        Ascendion_MetalReqID NUMERIC(18,9) NULL,
        eeo VARCHAR(200) NULL,
        veteran VARCHAR(150) NULL,
        Gender VARCHAR(50) NULL,
        Er_person VARCHAR(50) NULL,
        wfmetaljobdescription NVARCHAR(MAX) NULL,
        HR_Candidate_Salary MONEY NULL,
        Interview_CreatedDate DATETIME NULL,
        Interview_on_Date DATETIME NULL,
        IS_SOW VARCHAR(7) NULL,
        IS_Offshore VARCHAR(20) NULL,
        New_VAS VARCHAR(4) NULL,
        VerticalName NVARCHAR(510) NULL,
        Client_Group1 VARCHAR(19) NULL,
        Billig_Type VARCHAR(8) NULL,
        [Super Merged Name] VARCHAR(200) NULL,
        New_Category VARCHAR(11) NULL,
        New_business_type VARCHAR(100) NULL,
        OpportunityID VARCHAR(50) NULL,
        OpportunityName VARCHAR(200) NULL,
        Ms_ProjectId INT NULL,
        MS_ProjectName VARCHAR(200) NULL,
        ORC_ID VARCHAR(30) NULL,
        Market_Leader NVARCHAR(MAX) NULL,
        Circle_Metal VARCHAR(100) NULL,
        Community_New_Metal VARCHAR(100) NULL,
        Employee_Category VARCHAR(50) NULL,
        IsBillRateSkip BIT NULL,
        BillRate DECIMAL(18,9) NULL,
        RoleFamily VARCHAR(300) NULL,
        SubRoleFamily VARCHAR(300) NULL,
        [Standard JobTitle] VARCHAR(500) NULL,
        ClientInterviewRequired INT NULL,
        Redeploymenthire INT NULL,
        HRBrandLevelId INT NULL,
        HRBandTitle VARCHAR(300) NULL,
        latest_termination_reason VARCHAR(200) NULL,
        latest_termination_date DATETIME NULL,
        Community VARCHAR(100) NULL,
        ReqFulfillmentReason VARCHAR(200) NULL,
        EngagementType VARCHAR(500) NULL,
        RedepLedBy VARCHAR(200) NULL,
        Can_ExperienceLevelTitle VARCHAR(200) NULL,
        Can_StandardJobTitleHorizon NVARCHAR(4000) NULL,
        CandidateEmail VARCHAR(100) NULL,
        Offboarding_Reason VARCHAR(100) NULL,
        Offboarding_Initiated DATETIME NULL,
        Offboarding_Status VARCHAR(100) NULL,
        replcament_GCIID INT NULL,
        replcament_EmployeeName VARCHAR(500) NULL,
        [Senior Manager] VARCHAR(50) NULL,
        [Associate Manager] VARCHAR(50) NULL,
        [Director - Talent Engine] VARCHAR(50) NULL,
        Manager VARCHAR(50) NULL,
        Rec_ExperienceLevelTitle VARCHAR(200) NULL,
        Rec_StandardJobTitleHorizon NVARCHAR(4000) NULL,
        Task_Id INT NULL,
        proj_ID VARCHAR(50) NULL,
        Projdesc CHAR(60) NULL,
        Client_Group VARCHAR(19) NULL,
        billST_New FLOAT NULL,
        [Candidate city] VARCHAR(50) NULL,
        [Candidate State] VARCHAR(50) NULL,
        C2C_W2_FTE VARCHAR(13) NULL,
        FP_TM VARCHAR(2) NULL,
        load_timestamp DATETIME2 NULL,
        update_timestamp DATETIME2 NULL,
        source_system VARCHAR(100) NULL
    );
    -- Storage note: HEAP table for raw Bronze ingestion
END
GO

/*
================================================================================
TABLE 6: Bronze.bz_vw_billing_timesheet_daywise_ne
================================================================================
Description: Bronze layer table capturing billing timesheet data on a daily basis.
             Contains approved billable and non-billable hours by day.
Source: source_layer.vw_billing_timesheet_daywise_ne
Storage: HEAP table for raw data ingestion
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
        load_timestamp DATETIME2 NULL,
        update_timestamp DATETIME2 NULL,
        source_system VARCHAR(100) NULL
    );
    -- Storage note: HEAP table for raw Bronze ingestion
END
GO

/*
================================================================================
TABLE 7: Bronze.bz_vw_consultant_timesheet_daywise
================================================================================
Description: Bronze layer table capturing consultant timesheet data on a daily basis.
             Contains consultant-submitted hours by day.
Source: source_layer.vw_consultant_timesheet_daywise
Storage: HEAP table for raw data ingestion
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
        load_timestamp DATETIME2 NULL,
        update_timestamp DATETIME2 NULL,
        source_system VARCHAR(100) NULL
    );
    -- Storage note: HEAP table for raw Bronze ingestion
END
GO

/*
================================================================================
TABLE 8: Bronze.bz_DimDate
================================================================================
Description: Bronze layer dimension table containing date attributes.
             Provides comprehensive date-related attributes for time-based analysis.
Source: source_layer.DimDate
Storage: HEAP table for raw data ingestion
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
        load_timestamp DATETIME2 NULL,
        update_timestamp DATETIME2 NULL,
        source_system VARCHAR(100) NULL
    );
    -- Storage note: HEAP table for raw Bronze ingestion
END
GO

/*
================================================================================
TABLE 9: Bronze.bz_holidays_Mexico
================================================================================
Description: Bronze layer reference table containing Mexico holiday information.
             Stores holiday dates and descriptions specific to Mexico.
Source: source_layer.holidays_Mexico
Storage: HEAP table for raw data ingestion
================================================================================
*/

IF OBJECT_ID('Bronze.bz_holidays_Mexico', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_holidays_Mexico (
        [Holiday_Date] DATETIME NULL,
        [Description] VARCHAR(50) NULL,
        [Location] VARCHAR(10) NULL,
        [Source_type] VARCHAR(50) NULL,
        load_timestamp DATETIME2 NULL,
        update_timestamp DATETIME2 NULL,
        source_system VARCHAR(100) NULL
    );
    -- Storage note: HEAP table for raw Bronze ingestion
END
GO

/*
================================================================================
TABLE 10: Bronze.bz_holidays_Canada
================================================================================
Description: Bronze layer reference table containing Canada holiday information.
             Stores holiday dates and descriptions specific to Canada.
Source: source_layer.holidays_Canada
Storage: HEAP table for raw data ingestion
================================================================================
*/

IF OBJECT_ID('Bronze.bz_holidays_Canada', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_holidays_Canada (
        [Holiday_Date] DATETIME NULL,
        [Description] VARCHAR(100) NULL,
        [Location] VARCHAR(10) NULL,
        [Source_type] VARCHAR(50) NULL,
        load_timestamp DATETIME2 NULL,
        update_timestamp DATETIME2 NULL,
        source_system VARCHAR(100) NULL
    );
    -- Storage note: HEAP table for raw Bronze ingestion
END
GO

/*
================================================================================
TABLE 11: Bronze.bz_holidays
================================================================================
Description: Bronze layer reference table containing general holiday information.
             Stores holiday dates and descriptions for various locations.
Source: source_layer.holidays
Storage: HEAP table for raw data ingestion
================================================================================
*/

IF OBJECT_ID('Bronze.bz_holidays', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_holidays (
        [Holiday_Date] DATETIME NULL,
        [Description] VARCHAR(50) NULL,
        [Location] VARCHAR(10) NULL,
        [Source_type] VARCHAR(50) NULL,
        load_timestamp DATETIME2 NULL,
        update_timestamp DATETIME2 NULL,
        source_system VARCHAR(100) NULL
    );
    -- Storage note: HEAP table for raw Bronze ingestion
END
GO

/*
================================================================================
TABLE 12: Bronze.bz_holidays_India
================================================================================
Description: Bronze layer reference table containing India holiday information.
             Stores holiday dates and descriptions specific to India.
Source: source_layer.holidays_India
Storage: HEAP table for raw data ingestion
================================================================================
*/

IF OBJECT_ID('Bronze.bz_holidays_India', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_holidays_India (
        [Holiday_Date] DATETIME NULL,
        [Description] VARCHAR(50) NULL,
        [Location] VARCHAR(10) NULL,
        [Source_type] VARCHAR(50) NULL,
        load_timestamp DATETIME2 NULL,
        update_timestamp DATETIME2 NULL,
        source_system VARCHAR(100) NULL
    );
    -- Storage note: HEAP table for raw Bronze ingestion
END
GO

/*
================================================================================
TABLE 13: Bronze.bz_Audit_Log
================================================================================
Description: Audit table for tracking all data loading and processing activities
             in the Bronze layer. Maintains comprehensive log of all ETL operations,
             data quality checks, and processing metrics.
Source: N/A (System-generated audit table)
Storage: HEAP table for audit log ingestion
================================================================================
*/

IF OBJECT_ID('Bronze.bz_Audit_Log', 'U') IS NULL
BEGIN
    CREATE TABLE Bronze.bz_Audit_Log (
        record_id BIGINT NULL,
        source_table VARCHAR(100) NULL,
        load_timestamp DATETIME2 NULL,
        processed_by VARCHAR(100) NULL,
        processing_time FLOAT NULL,
        status VARCHAR(50) NULL,
        records_read BIGINT NULL,
        records_inserted BIGINT NULL,
        records_updated BIGINT NULL,
        records_failed BIGINT NULL,
        error_message VARCHAR(MAX) NULL,
        source_system VARCHAR(100) NULL,
        batch_id VARCHAR(100) NULL,
        load_type VARCHAR(50) NULL,
        start_datetime DATETIME2 NULL,
        end_datetime DATETIME2 NULL,
        data_quality_score DECIMAL(5,2) NULL,
        validation_status VARCHAR(50) NULL,
        file_name VARCHAR(500) NULL,
        file_size_mb DECIMAL(18,2) NULL,
        checksum VARCHAR(100) NULL,
        created_by VARCHAR(100) NULL,
        created_timestamp DATETIME2 NULL
    );
    -- Storage note: HEAP table for audit log storage
END
GO

/*
================================================================================
CONCEPTUAL DATA MODEL DIAGRAM (TABULAR FORMAT)
================================================================================

This section documents the relationships between Bronze layer tables.

--------------------------------------------------------------------------------
CORE EMPLOYEE AND ASSIGNMENT RELATIONSHIPS
--------------------------------------------------------------------------------

Source Table                          | Target Table                              | Relationship Key Field              | Description
------------------------------------- | ----------------------------------------- | ----------------------------------- | --------------------------------------------
Bronze.bz_New_Monthly_HC_Report       | Bronze.bz_SchTask                         | [gci id] = [GCI_ID]                 | Links employee headcount to workflow tasks
Bronze.bz_New_Monthly_HC_Report       | Bronze.bz_Hiring_Initiator_Project_Info   | [gci id] matches candidate info     | Links employee to hiring record
Bronze.bz_New_Monthly_HC_Report       | Bronze.bz_Timesheet_New                   | [gci id] = gci_id                   | Links employee to timesheet entries
Bronze.bz_New_Monthly_HC_Report       | Bronze.bz_report_392_all                  | [gci id] = [gci id]                 | Links employee to comprehensive report
Bronze.bz_New_Monthly_HC_Report       | Bronze.bz_DimDate                         | [start date] = [Date]               | Links start dates to date dimension
Bronze.bz_New_Monthly_HC_Report       | Bronze.bz_DimDate                         | [termdate] = [Date]                 | Links termination dates to date dimension
Bronze.bz_New_Monthly_HC_Report       | Bronze.bz_DimDate                         | [YYMM] = [YYYYMM]                   | Links reporting period to date dimension

--------------------------------------------------------------------------------
TIMESHEET RELATIONSHIPS
--------------------------------------------------------------------------------

Source Table                          | Target Table                              | Relationship Key Field              | Description
------------------------------------- | ----------------------------------------- | ----------------------------------- | --------------------------------------------
Bronze.bz_Timesheet_New               | Bronze.bz_vw_billing_timesheet_daywise_ne | gci_id, pe_date = [GCI_ID], [PE_DATE] | Links raw timesheet to billing timesheet
Bronze.bz_Timesheet_New               | Bronze.bz_vw_consultant_timesheet_daywise | gci_id, pe_date = [GCI_ID], [PE_DATE] | Links raw timesheet to consultant timesheet
Bronze.bz_Timesheet_New               | Bronze.bz_report_392_all                  | gci_id = [gci id]                   | Links timesheet to employee report
Bronze.bz_Timesheet_New               | Bronze.bz_DimDate                         | pe_date = [Date]                    | Links timesheet dates to date dimension

--------------------------------------------------------------------------------
WORKFLOW AND HIRING RELATIONSHIPS
--------------------------------------------------------------------------------

Source Table                          | Target Table                              | Relationship Key Field              | Description
------------------------------------- | ----------------------------------------- | ----------------------------------- | --------------------------------------------
Bronze.bz_SchTask                     | Bronze.bz_Hiring_Initiator_Project_Info   | [GCI_ID] matches candidate info     | Links workflow tasks to hiring information
Bronze.bz_report_392_all              | Bronze.bz_Hiring_Initiator_Project_Info   | [gci id] matches candidate info     | Links comprehensive report to hiring details
Bronze.bz_report_392_all              | Bronze.bz_DimDate                         | [start date] = [Date]               | Links assignment start dates to date dimension
Bronze.bz_report_392_all              | Bronze.bz_DimDate                         | [end date] = [Date]                 | Links assignment end dates to date dimension

--------------------------------------------------------------------------------
TIMESHEET VIEW RELATIONSHIPS
--------------------------------------------------------------------------------

Source Table                          | Target Table                              | Relationship Key Field              | Description
------------------------------------- | ----------------------------------------- | ----------------------------------- | --------------------------------------------
Bronze.bz_vw_billing_timesheet_daywise_ne | Bronze.bz_DimDate                     | [PE_DATE] = [Date]                  | Links billing timesheet to date dimension
Bronze.bz_vw_billing_timesheet_daywise_ne | Bronze.bz_DimDate                     | [WEEK_DATE] = [Date]                | Links billing week dates to date dimension
Bronze.bz_vw_consultant_timesheet_daywise | Bronze.bz_DimDate                     | [PE_DATE] = [Date]                  | Links consultant timesheet to date dimension
Bronze.bz_vw_consultant_timesheet_daywise | Bronze.bz_DimDate                     | [WEEK_DATE] = [Date]                | Links consultant week dates to date dimension

--------------------------------------------------------------------------------
HOLIDAY REFERENCE RELATIONSHIPS
--------------------------------------------------------------------------------

Source Table                          | Target Table                              | Relationship Key Field              | Description
------------------------------------- | ----------------------------------------- | ----------------------------------- | --------------------------------------------
Bronze.bz_holidays                    | Bronze.bz_DimDate                         | [Holiday_Date] = [Date]             | Links general holidays to date dimension
Bronze.bz_holidays_Mexico             | Bronze.bz_DimDate                         | [Holiday_Date] = [Date]             | Links Mexico holidays to date dimension
Bronze.bz_holidays_Canada             | Bronze.bz_DimDate                         | [Holiday_Date] = [Date]             | Links Canada holidays to date dimension
Bronze.bz_holidays_India              | Bronze.bz_DimDate                         | [Holiday_Date] = [Date]             | Links India holidays to date dimension

--------------------------------------------------------------------------------
AUDIT RELATIONSHIPS
--------------------------------------------------------------------------------

Source Table                          | Target Table                              | Relationship Key Field              | Description
------------------------------------- | ----------------------------------------- | ----------------------------------- | --------------------------------------------
Bronze.bz_Audit_Log                   | All Bronze Layer Tables                   | source_table = Table Name           | Tracks audit information for all Bronze tables

================================================================================
HIERARCHICAL RELATIONSHIP VIEW
================================================================================

Bronze.bz_New_Monthly_HC_Report (Central Fact Table)
    ├── Bronze.bz_SchTask
    │   └── Via: [gci id] = [GCI_ID]
    │   └── Cardinality: 1:M (One employee can have many workflow tasks)
    │
    ├── Bronze.bz_Hiring_Initiator_Project_Info
    │   └── Via: [gci id] matches candidate information
    │   └── Cardinality: 1:1 (One employee has one hiring record)
    │
    ├── Bronze.bz_Timesheet_New
    │   └── Via: [gci id] = gci_id
    │   └── Cardinality: 1:M (One employee has many timesheet entries)
    │
    ├── Bronze.bz_report_392_all
    │   └── Via: [gci id] = [gci id]
    │   └── Cardinality: 1:1 (One employee has one comprehensive report record)
    │
    └── Bronze.bz_DimDate
        └── Via: [start date], [termdate], [YYMM] = [Date], [YYYYMM]
        └── Cardinality: M:1 (Many employees can have same dates)

Bronze.bz_Timesheet_New (Timesheet Fact Table)
    ├── Bronze.bz_vw_billing_timesheet_daywise_ne
    │   └── Via: gci_id, pe_date = [GCI_ID], [PE_DATE]
    │   └── Cardinality: 1:1 (One raw timesheet maps to one billing timesheet)
    │
    ├── Bronze.bz_vw_consultant_timesheet_daywise
    │   └── Via: gci_id, pe_date = [GCI_ID], [PE_DATE]
    │   └── Cardinality: 1:1 (One raw timesheet maps to one consultant timesheet)
    │
    ├── Bronze.bz_report_392_all
    │   └── Via: gci_id = [gci id]
    │   └── Cardinality: M:1 (Many timesheets for one employee)
    │
    └── Bronze.bz_DimDate
        └── Via: pe_date = [Date]
        └── Cardinality: M:1 (Many timesheets for one date)

Bronze.bz_holidays (General Holidays)
    └── Bronze.bz_DimDate
        └── Via: [Holiday_Date] = [Date]
        └── Cardinality: M:1 (Multiple holidays can fall on same date)

Bronze.bz_holidays_Mexico (Mexico Holidays)
    └── Bronze.bz_DimDate
        └── Via: [Holiday_Date] = [Date]
        └── Cardinality: M:1 (Multiple holidays can fall on same date)

Bronze.bz_holidays_Canada (Canada Holidays)
    └── Bronze.bz_DimDate
        └── Via: [Holiday_Date] = [Date]
        └── Cardinality: M:1 (Multiple holidays can fall on same date)

Bronze.bz_holidays_India (India Holidays)
    └── Bronze.bz_DimDate
        └── Via: [Holiday_Date] = [Date]
        └── Cardinality: M:1 (Multiple holidays can fall on same date)

Bronze.bz_Audit_Log (Audit Tracking)
    └── All Bronze Layer Tables
        └── Via: source_table = Table Name
        └── Cardinality: 1:M (One table can have many audit entries)
        └── Tracks: Load operations, data quality, processing metrics

================================================================================
*/

/*
================================================================================
IMPLEMENTATION NOTES
================================================================================

1. STORAGE DESIGN:
   - All tables are created as HEAP tables (no clustered index)
   - This design optimizes for fast data ingestion in the Bronze layer
   - No constraints, indexes, or keys are defined per Bronze layer requirements

2. METADATA COLUMNS:
   - load_timestamp: Populated when record is first inserted
   - update_timestamp: Updated on every record modification
   - source_system: Identifies the source system (e.g., 'SQL_Server_Source')

3. DATA TYPES:
   - All data types preserved exactly from source DDL
   - DATETIME2 used for metadata timestamps for higher precision
   - VARCHAR(MAX) used where source has VARCHAR(MAX) or TEXT

4. IDEMPOTENCY:
   - All CREATE TABLE statements use IF OBJECT_ID check
   - Scripts can be run multiple times without errors
   - Existing tables are not modified or dropped

5. NAMING CONVENTION:
   - Schema: Bronze
   - Table prefix: bz_
   - Column names: Preserved exactly from source (including spaces and special characters)

6. AUDIT TABLE:
   - Bronze.bz_Audit_Log tracks all ETL operations
   - Includes performance metrics, data quality scores, and error tracking
   - Should be populated by ETL processes for each table load

7. NEXT STEPS:
   - Create ETL processes to populate Bronze tables from source
   - Implement data quality validation and logging
   - Design Silver layer transformations
   - Set up monitoring and alerting for Bronze layer loads

================================================================================
END OF BRONZE LAYER PHYSICAL DDL SCRIPT
================================================================================
*/

/*
================================================================================
API COST ESTIMATION
================================================================================
apiCost: 0.000000

Note: This physical data model was created through direct DDL generation from
      source files without consuming external API resources.
================================================================================
*/