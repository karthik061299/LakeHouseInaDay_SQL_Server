____________________________________________
## Author : AAVA
## Created on :   
## Description :   Comprehensive Power BI dashboard design and implementation recommendations for UTL/Resource Utilization reporting using SQL Server data model.
_____________________________________________

# 1. REQUIREMENTS & DATA MODEL ANALYSIS SUMMARY

## Key Findings from Requirements Document
- **Business Objectives:**
  - Provide accurate, timely, and actionable insights on resource utilization (UTL), FTE, billed/unbilled hours, project and client billing, and workforce allocation.
  - Enable leadership, managers, and analysts to monitor utilization, identify gaps, and optimize resource deployment.
- **Target Audience:**
  - Executives (high-level KPIs)
  - Delivery Managers/Portfolio Leads (drill-down, allocation, project-level)
  - Analysts/Finance (detailed data, export, scenario analysis)
- **Key Metrics/KPIs:**
  - Total Hours (location-based logic)
  - Submitted Hours, Approved Hours
  - Total FTE, Billed FTE, Project Utilization
  - Category/Status (Billable, Non-Billable, Bench, AVA, SGA, etc.)
  - Onsite/Offshore split
  - Portfolio Lead, Delivery Leader, Circle
  - Billing Type, Category, Status, GP, GPM
- **Dimensions/Filters:**
  - Date (Month, Quarter, Year)
  - Location, Project, Client, Category, Status, Portfolio Lead, Delivery Leader, Circle, Business Area, Vertical, SOW, Employee Category
- **Business Questions:**
  - What is the overall and project-level utilization?
  - How many FTEs are billed/unbilled/bench/SGA?
  - How does utilization trend over time and by segment?
  - Where are gaps or anomalies in timesheet submission/approval?
  - How does utilization compare to targets?
- **Interactivity:**
  - Drill-through from summary to detail
  - Slicers for date, location, project, category, etc.
  - Exportable tables, scenario/what-if analysis
- **Compliance/Security:**
  - Data access by role (RLS recommended)
  - Data freshness indicator
- **Usage Frequency:**
  - Daily/Weekly for managers, Monthly for executives
- **Decision Context:**
  - Resource allocation, billing optimization, workforce planning

## Data Model Structure Overview
- **Star Schema:**
  - Fact tables: gold Go_Fact_Timesheet_Entry, gold Go_Fact_Timesheet_Approval, gold Go_Agg_Resource_Utilization
  - Dimension tables: gold Go_Dim_Date, gold Go_Dim_Resource, gold Go_Dim_Project, gold Go_Dim_Holiday, gold Go_Dim_Workflow_Task
- **Key Relationships:**
  - Date dimensions linked to fact tables via Calendar_Date, Timesheet_Date, etc.
  - Resource and Project dimensions join to fact tables via Resource_ID/Resource_Code and Project_ID/Project_Name
  - Many-to-one and one-to-one relationships, mostly clean cardinality
- **Available Measures:**
  - Total_Hours, Submitted_Hours, Approved_Hours, Total_FTE, Billed_FTE, Project_Utilization, Actual_Hours, Onsite_Hours, Offsite_Hours, GP, GPM
- **Hierarchies:**
  - Date (Year > Quarter > Month > Day)
  - Organization (Portfolio Lead, Delivery Leader, Circle)
  - Project/Client/Category
- **Data Quality/Refresh:**
  - Data quality score fields available
  - load_date, update_date for freshness
  - Data refresh via import (incremental recommended)

## Identified Gaps or Constraints
- **Complex business logic** (category/status, FTE/Consultant split) must be implemented in DAX or pre-processed in ETL.
- **Holiday/weekend logic** for total hours must be carefully modeled.
- **Some fields (e.g., SGA/Bench/AVA/ELT) require mapping sheets or external reference tables.**
- **Potential for data duplication** if multiple allocations per resource/project are not handled with weighted logic.
- **Data model is robust but may need calculated columns/measures for advanced KPIs.**

## Recommended Data Model Enhancements
- Add calculated columns/measures for:
  - Weighted FTE logic (per requirements)
  - Category/Status (as per matrix logic)
  - Utilization rates, variance to target
  - Onsite/Offshore breakdowns
- Implement incremental refresh for large fact tables
- Ensure all mapping sheets (SGA/Bench/AVA/ELT) are loaded as lookup tables
- Validate relationships for correct cross-filtering (single direction preferred except for many-to-many)

# 2. DASHBOARD OVERVIEW

## Purpose and Objectives
- Deliver a multi-page, role-based dashboard for resource utilization, billing, and workforce analytics
- Enable rapid executive insight, deep-dive analysis, and operational monitoring

## Target Audience(s)
- Executives (summary KPIs)
- Delivery/Portfolio Managers (drill-down)
- Analysts/Finance (detailed, exportable data)

## Key Business Questions Addressed
- What is the current and historical utilization?
- How are resources allocated and billed?
- Where are inefficiencies or anomalies?
- How do we optimize resource deployment?

## Page Structure Summary
- Index/Landing Page
- Executive Summary
- Detail Pages (Utilization, Billing, Bench/AVA/SGA, Timesheet Compliance, etc.)
- Q&A Page
- AI Insights (Key Influencers, Decomposition Tree)
- Anomaly Detection
- What-If Analysis

# 3. PAGE-BY-PAGE DETAILED SPECIFICATIONS

## 3.1 Index/Landing Page
- **Purpose:** Navigation, context, orientation
- **Layout:**
  - Large dashboard title, description
  - Last refresh timestamp (from load_date)
  - Navigation buttons (Executive Summary, Utilization, Billing, Bench/AVA/SGA, Timesheet Compliance, Q&A, AI Insights, Anomaly, What-If)
  - Quick reference/legend, contact info
  - Branding/logo
- **Visuals:**
  - Card (Last Refresh)
  - Button visuals (rounded, icons, hover)
  - Shapes for grouping
  - Info icon (tooltip with usage guide)
- **Design:**
  - Background: #F4F6FA
  - Button style: Rounded corners (8px), subtle shadow, hover color #D6E0F0
  - Typography: Header 32pt bold, body 16pt
  - Layout: Centered, grid-based navigation
- **Power BI Features:**
  - Button navigation, bookmarks, tooltips

## 3.2 Executive Summary Page
- **Purpose:** High-level KPIs, strategic overview
- **Layout:**
  - Top: 4-6 KPI cards (Total Utilization, Billed FTE, Bench FTE, Total Hours, Project Utilization, SGA/AVA)
  - Middle: Trend visuals (Utilization over time, Billed vs. Unbilled trend)
  - Bottom: Breakdown by Category, Location, Portfolio Lead
  - Global slicers (Date, Location, Category)
- **Visuals:**
  - Card/Multi-row Card/KPI (primary KPIs)
  - Line/Area Chart (trends)
  - Clustered Column/Donut/Treemap (breakdowns)
- **Interactivity:**
  - Drill-through from KPIs/visuals to detail pages
  - Sync slicers (date, location, category)
  - Bookmarks (default, filtered views)
  - Reset filters button
- **Design:**
  - Color palette: #1A73E8 (primary), #34A853 (success), #EA4335 (error), #FBBC05 (warning), #F4F6FA (background)
  - Card font: 48pt numbers, 16pt labels
  - Spacing: 15px between visuals, ample white space
- **Power BI Features:**
  - Smart narrative, anomaly detection, drill-through, mobile layout

## 3.3 Detail Page 1: Utilization Detail
- **Purpose:** In-depth resource/project utilization
- **Layout:**
  - Header: Page title, back button, breadcrumb
  - Top: Detailed KPIs (Total FTE, Billed FTE, Utilization Rate, Onsite/Offshore split)
  - Middle: Trend analysis (Utilization by month/quarter, by project/client)
  - Bottom: Table/matrix (resource-level detail, export enabled)
  - Side: Filters (Portfolio Lead, Delivery Leader, Category, Status)
- **Visuals:**
  - Card/KPI (detailed KPIs)
  - Line & Clustered Column Chart (trend)
  - Stacked Bar/Waterfall (breakdown)
  - Table/Matrix (detail)
- **Interactivity:**
  - Drill-down (hierarchies: Portfolio > Project > Resource)
  - Cross-filtering
  - Report page tooltips
- **Data:**
  - gold Go_Agg_Resource_Utilization, gold Go_Dim_Resource, gold Go_Dim_Project
  - Measures: Total_Hours, Submitted_Hours, Approved_Hours, Total_FTE, Billed_FTE, Project_Utilization

## 3.4 Detail Page 2: Billing & Category Detail
- **Purpose:** Billing, category, and status analysis
- **Layout:**
  - Header: Page title, back button
  - Top: KPIs (Billed FTE, Unbilled FTE, Billable Hours, NBL Hours)
  - Middle: Category/Status breakdown (matrix, stacked bar)
  - Bottom: Table (project/client/category detail)
  - Side: Filters (Billing Type, Category, Status, Client)
- **Visuals:**
  - Card/KPI (billing KPIs)
  - Stacked Bar/Waterfall (category breakdown)
  - Matrix/Table (detail)
- **Data:**
  - gold Go_Dim_Project, gold Go_Agg_Resource_Utilization
  - Measures: Billed_FTE, Billable_Hours, NBL_Hours, Category, Status

## 3.5 Detail Page 3: Bench/AVA/SGA/ELT Detail
- **Purpose:** Bench/AVA/SGA/ELT resource tracking
- **Layout:**
  - Header: Page title, back button
  - Top: KPIs (Bench FTE, AVA FTE, SGA FTE, ELT FTE)
  - Middle: Trend (Bench/AVA/SGA over time)
  - Bottom: Table (resource/project detail)
  - Side: Filters (Portfolio Lead, Category)
- **Visuals:**
  - Card/KPI (Bench/AVA/SGA/ELT)
  - Line/Stacked Area (trend)
  - Table (detail)
- **Data:**
  - gold Go_Agg_Resource_Utilization, mapping tables
  - Measures: Bench_FTE, AVA_FTE, SGA_FTE, ELT_FTE

## 3.6 Detail Page 4: Timesheet Compliance
- **Purpose:** Monitor timesheet submission/approval
- **Layout:**
  - Header: Page title, back button
  - Top: KPIs (Submission Rate, Approval Rate, Variance)
  - Middle: Trend (compliance over time)
  - Bottom: Table (resource/project compliance)
  - Side: Filters (Portfolio Lead, Project, Status)
- **Visuals:**
  - Card/KPI (compliance KPIs)
  - Line/Clustered Column (trend)
  - Table (detail)
- **Data:**
  - gold Go_Fact_Timesheet_Entry, gold Go_Fact_Timesheet_Approval
  - Measures: Submission_Rate, Approval_Rate, Variance

## 3.7 Q&A Page
- **Purpose:** Natural language query interface
- **Layout:**
  - Central Q&A visual
  - Suggested questions panel
  - Help text/examples
- **Visuals:**
  - Q&A visual (full width)
  - Text boxes (examples)
  - Buttons (pre-built queries)
- **Configuration:**
  - Train Q&A with synonyms, featured questions
  - Enable for key tables/measures

## 3.8 AI Insights Page
- **Purpose:** AI-driven analysis (Key Influencers, Decomposition Tree)
- **Layout:**
  - Split: Key Influencers (left), Decomposition Tree (right)
  - Context explanation at top
- **Visuals:**
  - Key Influencers (target: Utilization, Billed FTE)
  - Decomposition Tree (drill on Category, Portfolio, Project)
- **Configuration:**
  - Enable AI splits, smart narrative

## 3.9 Anomaly Detection Page
- **Purpose:** Highlight outliers/unusual patterns
- **Layout:**
  - Time series with anomaly detection
  - Summary card (anomaly count)
  - Table (anomaly details)
- **Visuals:**
  - Line chart (anomaly enabled)
  - Card (anomaly count)
  - Table (details)
- **Configuration:**
  - Enable anomaly detection, set sensitivity

## 3.10 What-If Analysis Page
- **Purpose:** Scenario modeling/forecasting
- **Layout:**
  - What-if parameter controls (sliders)
  - Result cards (projected metrics)
  - Comparison charts (baseline vs. scenario)
- **Visuals:**
  - Slicer (parameter)
  - Card (results)
  - Line/Column chart (comparison)
- **Configuration:**
  - Create what-if parameters, DAX scenario measures

# 4. DESIGN SYSTEM DOCUMENTATION

## Color Palette
- **Primary:** #1A73E8 (blue)
- **Secondary:** #185ABC (dark blue)
- **Accent:** #FBBC05 (yellow)
- **Sequential:** #E3F2FD, #90CAF9, #42A5F5, #1E88E5, #1565C0
- **Categorical:** #1A73E8, #34A853, #EA4335, #FBBC05, #185ABC, #F4B400, #A142F4, #F4F6FA
- **Diverging:** #EA4335 (neg), #FBBC05 (neutral), #34A853 (pos), #1A73E8, #F4B400, #A142F4, #185ABC
- **Semantic:**
  - Success: #34A853
  - Warning: #FBBC05
  - Error: #EA4335
  - Neutral: #F4F6FA
- **Background:** #F4F6FA
- **Visual Background:** #FFFFFF
- **Border:** #E0E0E0
- **Text Primary:** #202124
- **Text Secondary:** #5F6368
- **Conditional Formatting:**
  - Above target: #34A853
  - At target: #FBBC05
  - Below target: #EA4335

## Typography
- Dashboard Title: Segoe UI, 32pt, Bold
- Page Headers: Segoe UI, 24pt, SemiBold
- Visual Titles: Segoe UI, 16pt, Bold
- Body Text: Segoe UI, 14pt, Regular
- Data Labels: Segoe UI, 12pt, SemiBold

## Spacing & Layout Grid
- Canvas: 1920x1080
- Grid: 20px increments
- Margin: 20px
- Visual Padding: 15px
- Section Spacing: 30px

## Visual Standards
- Border Radius: 8px
- Shadow: 2px subtle drop
- Visual Border: 1px #E0E0E0
- Title Alignment: Left
- Legend Position: Top
- Data Label Format: 1,234.56; K/M for large numbers

## Accessibility
- Alt text for all visuals
- Contrast: WCAG 2.1 AA
- Keyboard navigation
- Screen reader compatibility

# 5. INTERACTION & NAVIGATION DESIGN

## Navigation Flow
- Index → Executive Summary → Detail Pages (Utilization, Billing, Bench/AVA/SGA, Timesheet, etc.) → Feature Pages (Q&A, AI, Anomaly, What-If)
- Breadcrumb trail, Home/Back buttons
- Bookmarks for saved views

## Drill-Through Matrix
- Executive Summary KPIs → Corresponding detail page
- Detail page visuals → More granular detail (resource/project)
- Pass filters: Date, Portfolio, Category
- Back button on drill-through targets

## Filter Strategy
- Global sync slicers: Date, Location, Category
- Page-level filters: Portfolio, Project, Status
- Visual-level filters: Advanced analysis only
- Filters pane hidden by default, accessible via icon

## Bookmark Plan
- Default view bookmark
- Key analysis bookmarks (pre-filtered)
- Bookmark navigator for guided stories

## Tooltip Strategy
- Default tooltips (aggregate details)
- Report page tooltips (detailed hover)
- Specify tooltip pages

# 6. DATA MODEL INTEGRATION

## Table/Measure Mapping
- **Index/Landing:** gold Go_Dim_Date (load_date), all tables for navigation
- **Executive Summary:** gold Go_Agg_Resource_Utilization (KPIs), gold Go_Dim_Resource, gold Go_Dim_Project
- **Utilization Detail:** gold Go_Agg_Resource_Utilization, gold Go_Dim_Resource, gold Go_Dim_Project
- **Billing/Category Detail:** gold Go_Dim_Project, gold Go_Agg_Resource_Utilization
- **Bench/AVA/SGA/ELT:** gold Go_Agg_Resource_Utilization, mapping tables
- **Timesheet Compliance:** gold Go_Fact_Timesheet_Entry, gold Go_Fact_Timesheet_Approval
- **Q&A/AI/Anomaly/What-If:** All relevant fact/dim tables

## Required DAX Measures (Patterns)
- Weighted FTE: SUMX over allocation, apply ratio logic
- Utilization Rate: DIVIDE(SUM(Submitted_Hours), SUM(Total_Hours))
- Billed FTE: DIVIDE(SUM(Approved_Hours), SUM(Total_Hours))
- Category/Status: SWITCH/CASE logic as per requirements
- Bench/AVA/SGA/ELT: LOOKUPVALUE from mapping tables
- Submission/Approval Rate: DIVIDE(SUM(Submitted/Approved), COUNTROWS(Resource))
- Variance: Actual - Target

## Performance Optimization
- Aggregations on gold Go_Agg_Resource_Utilization
- Incremental refresh on large fact tables
- Use Import mode unless real-time needed
- Minimize visuals per page (max 12)
- Avoid bidirectional relationships unless necessary

## Security Recommendations
- Implement RLS by Portfolio Lead, Delivery Leader, or Location
- Data freshness indicator (Last Refresh)

# 7. POWER BI FEATURE UTILIZATION

## Modern Features Leveraged
- Q&A (natural language)
- Smart Narratives (auto-insights)
- Key Influencers, Decomposition Tree (AI)
- Anomaly Detection (time series)
- What-If Parameters (scenario)
- Field Parameters (dynamic metric selection)
- Mobile Layouts
- Accessibility (alt text, contrast, navigation)
- Bookmarks (storytelling, saved views)
- Paginated Reports (detailed exports)
- Power Automate (alerts, distribution)
- On-object interaction (modern buttons, tooltips)

## Configuration Details
- Q&A: Train with synonyms, featured questions
- Smart Narratives: Place below key visuals, customize
- Key Influencers: Target = Utilization, explain by Category/Portfolio/Project
- Decomposition Tree: Enable AI splits, allow user-driven drill
- Anomaly: Enable on line charts, set sensitivity
- What-If: Create parameter tables, scenario DAX
- Field Parameters: Allow metric switching on detail pages
- Mobile: Design phone layouts for all pages
- Accessibility: Alt text, tab order, high contrast
- Bookmarks: Default, analysis, navigator
- Paginated: Link to detailed exports from summary/detail
- Power Automate: Alerts for threshold breaches, scheduled distribution

## Benefits/Use Cases
- Rapid executive insight
- Deep-dive analysis for managers
- Self-service exploration for analysts
- Automated alerts and distribution
- Accessible, mobile-friendly reporting

---

**End of Recommendations Document.**
