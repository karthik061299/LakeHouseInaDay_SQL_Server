------------------------------------------------------------------------
Author:        AAVA       
Date:          
Description:   Conceptual Data Model for UTL (Utilization) Reporting System
------------------------------------------------------------------------

# Conceptual Data Model Analysis for UTL Reporting System

## 1. Domain Overview

The primary business domain covered by the reports is **Human Resource Management and Project Utilization Tracking**. This domain encompasses:

1. **Resource Utilization Management** - Tracking employee time allocation across projects
2. **Project Management** - Managing project assignments and billing
3. **Time and Attendance Management** - Recording and approving work hours
4. **Financial Management** - Billing rates, costs, and revenue tracking
5. **HR Operations** - Employee lifecycle, hiring, and workforce planning
6. **Client Relationship Management** - Client project assignments and billing

## 2. List of Entity Names with Descriptions

1. **Employee** - Represents individual resources/consultants working on projects
2. **Project** - Represents client projects or internal initiatives where resources are allocated
3. **Client** - Represents client organizations that engage services
4. **Timesheet** - Represents time entries submitted by employees for work performed
5. **WorkflowTask** - Represents hiring and onboarding workflow processes
6. **ProjectAssignment** - Represents the assignment of employees to specific projects
7. **Calendar** - Represents date dimensions including working days and holidays
8. **Holiday** - Represents holiday information by location
9. **Location** - Represents geographical locations where work is performed
10. **BillingRate** - Represents billing and pay rate information
11. **ApprovalRecord** - Represents timesheet approval records by managers

## 3. List of Attributes for Each Entity with Descriptions

### Employee Entity
1. **Employee Code** - Unique identifier for the employee (GCI_ID)
2. **First Name** - Employee's first name
3. **Last Name** - Employee's last name
4. **Job Title** - Current job position title
5. **Employee Type** - Classification as FTE or Consultant
6. **Start Date** - Date when employee started
7. **Termination Date** - Date when employee was terminated
8. **Employee Status** - Current status of the employee
9. **Visa Type** - Type of work authorization
10. **Location Type** - Onsite or Offshore classification
11. **Payroll Location** - Location for payroll processing
12. **Experience Level** - Professional experience level
13. **Standard Job Title** - Standardized job title classification
14. **Community** - Business community or practice area
15. **Circle** - Organizational circle assignment

### Project Entity
1. **Project Name** - Name of the project
2. **Project Code** - Unique project identifier
3. **Project Type** - Type of project engagement
4. **Start Date** - Project start date
5. **End Date** - Project end date
6. **Project Status** - Current status of the project
7. **Billing Type** - Billable or Non-Billable classification
8. **Project Category** - Category classification of the project
9. **Project City** - City where project is located
10. **Project State** - State where project is located
11. **Project Country** - Country where project is located
12. **Delivery Model** - Model of service delivery
13. **Practice Type** - Type of practice area
14. **Opportunity Name** - Sales opportunity name
15. **Portfolio Leader** - Leader responsible for the portfolio

### Client Entity
1. **Client Code** - Unique client identifier
2. **Client Name** - Name of the client organization
3. **Client Type** - Type of client engagement
4. **Client Sector** - Industry sector of the client
5. **Super Merged Name** - Parent client organization name
6. **Market** - Market segment classification
7. **Vertical Name** - Industry vertical classification
8. **Business Area** - Geographic business area
9. **SOW Status** - Statement of Work status
10. **Client Entity** - Legal entity information
11. **End Client Name** - Ultimate end client name
12. **Client Manager** - Primary client contact manager
13. **Account Owner** - Account management owner
14. **Market Leader** - Market leadership contact
15. **Client Partner** - Partnership contact

### Timesheet Entity
1. **Period End Date** - End date of the timesheet period
2. **Calendar Date** - Specific date of work performed
3. **Standard Time Hours** - Regular working hours submitted
4. **Overtime Hours** - Overtime hours submitted
5. **Double Time Hours** - Double time hours submitted
6. **Time Off Hours** - Time off hours recorded
7. **Holiday Hours** - Holiday hours recorded
8. **Sick Time Hours** - Sick time hours recorded
9. **Submission Status** - Status of timesheet submission
10. **Week Date** - Week ending date
11. **Billable Status** - Whether hours are billable
12. **Year Month** - Year and month combination

### WorkflowTask Entity
1. **Task Name** - Name of the workflow task
2. **Process Name** - Name of the workflow process
3. **Task Status** - Current status of the task
4. **Date Created** - Date when task was created
5. **Date Completed** - Date when task was completed
6. **Initiator** - Person who initiated the workflow
7. **Comments** - Comments or notes on the task
8. **Level Name** - Current level in the workflow
9. **Track Number** - Tracking identifier
10. **Legal Entity** - Legal entity associated with the task

### ProjectAssignment Entity
1. **Assignment Start Date** - Date when assignment started
2. **Assignment End Date** - Date when assignment ended
3. **Net Bill Rate** - Net billing rate for the assignment
4. **Pay Rate** - Pay rate for the resource
5. **Gross Profit** - Gross profit amount
6. **Gross Profit Margin** - Gross profit margin percentage
7. **Assignment Status** - Status of the assignment
8. **FTE Percentage** - Full-time equivalent percentage
9. **Allocation Percentage** - Percentage allocation to project
10. **Business Type** - Type of business engagement

### Calendar Entity
1. **Calendar Date** - Specific calendar date
2. **Day of Month** - Day number in the month
3. **Day Name** - Name of the day
4. **Week of Year** - Week number in the year
5. **Month Number** - Month number
6. **Month Name** - Name of the month
7. **Quarter** - Quarter number
8. **Quarter Name** - Name of the quarter
9. **Year** - Year value
10. **Month Year** - Month and year combination
11. **Days in Month** - Total days in the month
12. **Working Day Flag** - Indicator if it's a working day

### Holiday Entity
1. **Holiday Date** - Date of the holiday
2. **Holiday Description** - Description of the holiday
3. **Holiday Location** - Location where holiday applies
4. **Source Type** - Source of holiday information

### Location Entity
1. **Location Name** - Name of the location
2. **Location Type** - Type of location (Onsite/Offshore)
3. **Country** - Country name
4. **State** - State or province name
5. **City** - City name
6. **Time Zone** - Time zone information
7. **Standard Hours** - Standard working hours per day
8. **Region** - Regional classification

### BillingRate Entity
1. **Standard Rate** - Standard billing rate
2. **Overtime Rate** - Overtime billing rate
3. **Double Time Rate** - Double time billing rate
4. **Rate Units** - Units for the rate (hourly, daily)
5. **Effective Date** - Date when rate becomes effective
6. **Rate Type** - Type of rate (billing, pay)
7. **Currency** - Currency for the rate

### ApprovalRecord Entity
1. **Approved Standard Hours** - Approved standard time hours
2. **Approved Overtime Hours** - Approved overtime hours
3. **Approved Double Time Hours** - Approved double time hours
4. **Approved Sick Time Hours** - Approved sick time hours
5. **Approval Date** - Date of approval
6. **Approver Name** - Name of the approver
7. **Approval Status** - Status of the approval
8. **Approval Comments** - Comments from approver

## 4. Key Performance Indicators (KPIs)

1. **Total FTE** - Submitted Hours / Total Hours
2. **Billed FTE** - Approved TS hours / Total Hours
3. **Project Utilization** - (Billed Hours / Available Hours) * 100
4. **Total Available Hours** - Number of Working Days × Location Hours
5. **Total Billed Hours** - Sum of all approved billable hours
6. **Onsite Hours** - Total hours worked onsite
7. **Offshore Hours** - Total hours worked offshore
8. **Gross Profit Margin** - (Gross Profit / Revenue) * 100
9. **Net Bill Rate** - Effective billing rate after adjustments
10. **Resource Allocation Percentage** - Percentage of resource allocated to projects
11. **Bench Time** - Time when resources are not allocated to billable projects
12. **Monthly Utilization Rate** - Monthly utilization percentage
13. **Client Billing Efficiency** - Ratio of billed to submitted hours
14. **Revenue per Resource** - Total revenue divided by number of resources
15. **Cost per Resource** - Total cost divided by number of resources

## 5. Conceptual Data Model Diagram (Tabular Relationships)

| Parent Table | Child Table | Relationship Key Field | Relationship Type |
|--------------|-------------|----------------------|-------------------|
| Employee | Timesheet | GCI_ID | One-to-Many |
| Employee | ProjectAssignment | GCI_ID | One-to-Many |
| Employee | WorkflowTask | GCI_ID | One-to-Many |
| Project | ProjectAssignment | Project_ID | One-to-Many |
| Project | Timesheet | Task_ID | One-to-Many |
| Client | Project | Client_Code | One-to-Many |
| ProjectAssignment | Timesheet | Task_ID | One-to-Many |
| ProjectAssignment | BillingRate | Assignment_ID | One-to-Many |
| Calendar | Timesheet | Calendar_Date | One-to-Many |
| Calendar | Holiday | Holiday_Date | One-to-Many |
| Location | Holiday | Location | One-to-Many |
| Location | Employee | Location | One-to-Many |
| Timesheet | ApprovalRecord | Timesheet_ID | One-to-One |
| Employee | ApprovalRecord | GCI_ID | One-to-Many |
| WorkflowTask | ProjectAssignment | Task_ID | One-to-One |
| Client | ProjectAssignment | Client_Code | One-to-Many |

## 6. Common Data Elements in Report Requirements

The following data elements are referenced across multiple reports within the given requirements:

1. **GCI_ID** - Employee identifier used across all employee-related reports
2. **Client_Code** - Client identifier used in project and billing reports
3. **Project_Name/ITSSProjectName** - Project identifier used in utilization and billing reports
4. **Calendar_Date/PE_Date** - Date fields used across timesheet and utilization reports
5. **Hours (ST, OT, DT)** - Various hour types used in timesheet and utilization calculations
6. **Billing_Type** - Classification used in billing and utilization reports
7. **Location** - Geographic information used in holiday and resource reports
8. **Employee_Type** - FTE/Consultant classification used across HR reports
9. **Start_Date/End_Date** - Date ranges used in project and employee lifecycle reports
10. **Status** - Various status fields used across workflow and project reports
11. **Bill_Rate** - Billing rate information used in financial and utilization reports
12. **Approved_Hours** - Approved time used in utilization and billing calculations
13. **YYMM** - Year-month combination used for time-based reporting
14. **Category** - Classification used in billing and project categorization
15. **FTE_Percentage** - Utilization percentage used in resource planning reports

## 7. Model Validation Against Requirements

The conceptual data model has been validated against the original UTL Logic requirements and covers:

✓ **Total Hours Calculation** - Supported through Calendar, Location, and Holiday entities
✓ **Submitted Hours Tracking** - Covered by Timesheet entity with various hour types
✓ **Approved Hours Management** - Handled by ApprovalRecord entity
✓ **FTE Calculations** - Supported through ProjectAssignment and Timesheet relationships
✓ **Billing Type Classification** - Covered by Project and ProjectAssignment entities
✓ **India Billing Matrix** - Supported through Client and Project categorization
✓ **Client Project Matrix** - Handled by Client-Project-Employee relationships
✓ **SGA and Bench Management** - Covered by Project categorization and Employee status
✓ **Multi-location Support** - Handled by Location and Holiday entities
✓ **Workflow Management** - Covered by WorkflowTask entity
✓ **Time Tracking** - Comprehensive coverage through Timesheet and Calendar entities

## 8. API Cost Calculation

**Cost for this Call: $0.00**

*Note: This analysis was performed using the GitHub File Reader and Writer tools which do not incur additional API costs beyond the standard GitHub API usage. The conceptual data modeling was completed through systematic analysis of the provided requirements and DDL scripts without requiring external API calls.*