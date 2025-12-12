____________________________________________
## Author : AAVA
## Created on :   
## Description :   Power BI dashboard design recommendations for UTL Logic, FTE, and Timesheet analytics, based on requirements and available visuals.
_____________________________________________

### 1. REQUIREMENTS & DATA MODEL ANALYSIS SUMMARY

**Key Findings from Requirements Document:**
- Business focus: Resource utilization, FTE calculation, timesheet tracking, billing categorization, and project/bench/SGA/AVA matrices.
- Key metrics: Total Hours, Submitted Hours, Approved Hours, Total FTE, Billed FTE, Project UTL, Category, Status, Onsite/Offsite Hours, Delivery Leader, Portfolio Lead.
- Dimensions: Resource, Project, Location, Date, Billing Type, Category, Status, SOW, Vertical, Business Area, Region, Type (Onsite/Offshore), HR Company, Process Name.
- Granularity: Day-wise timesheet entries, monthly/weekly/periodic summaries.
- Filters: Date, Location, Project, Category, Status, Business Area, Portfolio Lead, SOW, Vertical, Region, Onsite/Offshore, HR Company.
- Compliance: Exclude weekends/holidays per location, adjust for multiple allocations, handle missing/approved hours.
- Data sources: Timesheet tables, holiday tables per region, mapping sheets, workflow tables.
- Frequency: Likely monthly/weekly refresh (timesheet cadence), but daily/real-time not explicitly required.
- Decision context: Operational and executive reporting for resource management, billing, and project tracking.

**Data Model Structure Overview:**
- Fact tables: Timesheet_New, vw_billing_timesheet_daywise_ne, vw_consultant_timesheet_daywise, report_392_all, New_Monthly_HC_Report, SchTask.
- Dimension tables: DimDate, holidays_*, mapping sheets (for leaders, SGA, ELT, etc.), Workflow, Project, Resource, Category, Status.
- Relationships: Resource ↔ Timesheet, Project ↔ Timesheet, Date ↔ Timesheet, Location ↔ Resource/Project, Category/Status ↔ Project/Resource.
- Hierarchies: Date (Year > Month > Day), Project (Portfolio > Project), Location (Region > Country > City), Business Area.
- Measures: Calculated columns for FTE, Billed FTE, Project UTL, Category, Status, Onsite/Offsite, Expected/Available/Billed Hours.
- Data quality: Logic for handling missing/approved hours, multiple allocations, and proportional adjustments.

**Identified Gaps or Constraints:**
- DataModelSchema files not accessible for full technical validation; recommendations are based on requirements and table/column logic.
- Recommend validating relationships, cardinality, and DAX feasibility once schema is available.

**Recommended Data Model Enhancements:**
- Ensure star schema: FactTimesheet, FactResourceAllocation, DimResource, DimProject, DimDate, DimLocation, DimCategory, DimStatus, DimPortfolio, DimLeader.
- Use surrogate keys for joins, avoid many-to-many.
- Add calculated columns/measures for all business logic in requirements.
- Implement incremental refresh for large fact tables.
- Ensure all slicer fields are in dimensions, not facts.

---

### 2. DASHBOARD OVERVIEW

**Purpose and Objectives:**
- Enable leadership and managers to monitor resource utilization, FTE, billing status, and project/bench/SGA/AVA allocations.
- Provide analysts with drill-down capability for timesheet, resource, and project-level investigation.
- Support operational users in tracking timesheet submissions, approvals, and compliance.

**Target Audience(s):**
- Executives (quick KPIs, trends)
- Resource/Project Managers (allocation, billing, bench/SGA/AVA status)
- Analysts (detailed breakdowns, root cause analysis)
- Operational users (timesheet/approval compliance)

**Key Business Questions Addressed:**
- What is the current utilization and FTE status across projects, locations, and time?
- How are resources allocated and billed (by category, status, region, etc.)?
- Where are the bottlenecks in timesheet submission/approval?
- What is the distribution between billable, non-billable, bench, SGA, and AVA resources?
- Who are the top/bottom performers by utilization, billing, or project?
- What are the trends and anomalies in resource allocation and billing?

**Page Structure Summary:**
- Index/Landing Page
- Executive Summary Page
- Detail Pages (Utilization/FTE, Billing, Bench/SGA/AVA, Timesheet Compliance, Resource/Project Analytics)
- Q&A Page
- AI Insights Page (Key Influencers, Decomposition Tree)
- Anomaly Detection Page
- What-If Analysis Page

---

### 3. PAGE-BY-PAGE DETAILED SPECIFICATIONS

#### 3.1 Index/Landing Page
- **Purpose:** Navigation, context, orientation.
- **Layout:**
  - Dashboard title/branding
  - Last refresh timestamp
  - Navigation buttons (Executive Summary, Detail Pages, Q&A, AI Insights, Anomaly, What-If)
  - Quick reference guide/legend
  - Contact/data ownership info
  - Optional: Recent highlights/alerts
- **Visuals:**
  - Title text box, logo
  - Button visuals with icons and actions
  - Info icon with tooltip
- **Design:**
  - Background: #F5F7FA
  - Buttons: Rounded (8px), shadow, hover effect
  - Typography: Header 32pt bold, body 16pt
  - Layout: Centered grid
- **Power BI Features:**
  - Page navigation buttons, bookmarks, tooltips

#### 3.2 Executive Summary Page
- **Purpose:** High-level KPIs and trends for leadership
- **Layout:**
  - Top: 4-6 KPI cards (Total FTE, Billed FTE, Utilization %, Billable/Non-Billable Count, Bench/SGA/AVA Count, Compliance %)
  - Middle: 2-3 trend visuals (Utilization, FTE, Billing over time)
  - Bottom: Key breakdowns (by region, category, status)
  - Left/Top-right: Global filters (Date, Location, Project, Category, Status)
- **Visuals:**
  - KPI Card, Multi-row Card, KPI visual
  - Line/Area chart for trends
  - Clustered column, Donut, Treemap for breakdowns
- **Interactivity:**
  - Drill-through to detail pages
  - Sync slicers
  - Bookmarks, reset filters
- **Design:**
  - Color palette: Primary #2A72D4, Accent #F9B233, Success #4CAF50, Error #E53935
  - Card: 48-60pt numbers, 14-16pt labels
  - Spacing: 15px between visuals
  - White space for clarity
- **Power BI Features:**
  - Smart narratives, anomaly detection, mobile layout

#### 3.3 Detail Page 1: Utilization & FTE
- **Purpose:** Deep-dive into resource utilization and FTE
- **Layout:**
  - Header: Title, back button, breadcrumbs
  - Top: Detailed KPIs (Utilization %, Total/Submitted/Approved Hours, FTE, Billed FTE)
  - Middle: Trends (line/area), breakdowns (stacked bar), distribution (histogram/box), top/bottom performers (table/matrix)
  - Bottom: Data table (drill-down, export)
  - Side: Filters (Resource, Project, Location, Date)
- **Visuals:**
  - Card/KPI, Line chart, Stacked bar, Histogram/Box, Table/Matrix
- **Interactivity:**
  - Drill-through, drill-down, cross-filtering, bookmarks
- **Design:**
  - Consistent with summary, clear headers, grid alignment
- **Data:**
  - FactTimesheet, DimResource, DimProject, DimDate, DimLocation
  - Measures: Utilization %, FTE, Billed FTE, Hours

#### 3.4 Detail Page 2: Billing & Category
- **Purpose:** Billing status, category analysis
- **Layout:**
  - KPIs: Billable/Non-Billable, Unbilled, SGA/Bench/AVA counts
  - Trends: Billing over time
  - Breakdown: By Category, Status, Region
  - Top/Bottom: Projects/resources by billing
  - Table: Billing details
- **Visuals:**
  - KPI, Line/Area, Clustered/Stacked bar, Treemap, Table
- **Data:**
  - FactBilling, DimCategory, DimStatus, DimProject, DimDate
  - Measures: Billable FTE, Category/Status counts

#### 3.5 Detail Page 3: Bench/SGA/AVA
- **Purpose:** Track bench, SGA, AVA allocations
- **Layout:**
  - KPIs: Bench/SGA/AVA counts
  - Trends: Over time
  - Breakdown: By region, project, leader
  - Table: Resource/project status
- **Visuals:**
  - KPI, Line, Stacked bar, Table
- **Data:**
  - FactBench, DimResource, DimProject, DimDate

#### 3.6 Detail Page 4: Timesheet Compliance
- **Purpose:** Track timesheet submission/approval
- **Layout:**
  - KPIs: Compliance %, missing/late submissions
  - Trends: Compliance over time
  - Breakdown: By resource, project, location
  - Table: Non-compliant entries
- **Visuals:**
  - KPI, Line, Stacked bar, Table
- **Data:**
  - FactTimesheet, DimResource, DimProject, DimDate

#### 3.7 Detail Page 5: Resource/Project Analytics
- **Purpose:** Ad hoc analysis by resource/project
- **Layout:**
  - Slicers: Resource, Project, Date, Location
  - Visuals: All available for flexible analysis
- **Visuals:**
  - All standard visuals
- **Data:**
  - All fact/dim tables

#### 3.X Q&A Page
- **Purpose:** Natural language query
- **Layout:**
  - Q&A visual (centered, large)
  - Suggested questions, help text
- **Visuals:**
  - Q&A, sample questions, info box
- **Power BI Features:**
  - Q&A, synonyms, featured questions

#### 3.Y AI Insights Page
- **Purpose:** Key Influencers, Decomposition Tree
- **Layout:**
  - Split: Key Influencers (left), Decomposition Tree (right)
  - Context explanation
- **Visuals:**
  - Key Influencers, Decomposition Tree
- **Power BI Features:**
  - AI splits, smart narratives

#### 3.Z Additional Feature Pages
- **Anomaly Detection:** Line charts with anomaly detection, summary cards, anomaly table
- **What-If Analysis:** Parameter sliders, scenario cards, comparison charts

---

### 4. DESIGN SYSTEM DOCUMENTATION

**Color Palette:**
- Primary: #2A72D4 (blue)
- Secondary: #F5F7FA (light gray)
- Accent: #F9B233 (orange)
- Success: #4CAF50 (green)
- Warning: #FFB300 (amber)
- Error: #E53935 (red)
- Neutral: #757575 (gray)
- Background: #FFFFFF (white)
- Visual background: #F5F7FA
- Border: #E0E0E0
- Text primary: #212121
- Text secondary: #757575
- Sequential: [#E3F2FD, #90CAF9, #42A5F5, #1976D2, #0D47A1]
- Categorical: [#2A72D4, #F9B233, #4CAF50, #E53935, #FFB300, #7E57C2, #26A69A, #EC407A]
- Diverging: [#E53935, #FFB300, #4CAF50, #1976D2, #757575, #F9B233, #2A72D4]

**Typography:**
- Dashboard title: Segoe UI, 32pt, Bold
- Page headers: Segoe UI, 24pt, SemiBold
- Visual titles: Segoe UI, 16pt, Bold
- Body: Segoe UI, 14pt, Regular
- Data labels: Segoe UI, 12pt, SemiBold

**Spacing & Layout:**
- Canvas: 1920x1080 (large)
- Grid: 20px
- Margin: 20px
- Padding: 15px
- Section spacing: 30px

**Visual Standards:**
- Border radius: 8px
- Shadow: 2px #E0E0E0
- Border: 1px #E0E0E0
- Title: Left aligned
- Legend: Top or right
- Data label: 12pt, auto-format (K/M)

**Accessibility:**
- Alt text for all visuals
- Contrast: WCAG 2.1 AA
- Keyboard navigation
- Screen reader compatibility

---

### 5. INTERACTION & NAVIGATION DESIGN

**Navigation Flow:**
- Index → Executive Summary → Detail Pages
- Breadcrumbs on each page
- Home/back buttons
- Bookmarks for saved views
- Drill-through from summary to details
- Cross-page filter sync
- Buttons for Q&A, AI, Anomaly, What-If

**Drill-Through Matrix:**
- Executive KPIs → Detail pages
- Detail visuals → More granular detail
- Pass filters: Date, resource, project, location
- Back button always present

**Filter Strategy:**
- Sync slicers: Date, location, project, category, status
- Page filters: Domain-specific
- Visual filters: Only as needed
- Filters pane: Hidden by default, accessible via icon

**Bookmark Plan:**
- Default/reset
- Key analysis views
- Bookmark navigator for storytelling

**Tooltip Strategy:**
- Default tooltips for all visuals
- Report page tooltips for detail
- Specify tooltip pages

---

### 6. DATA MODEL INTEGRATION

**Table/Measure Mapping:**
- Timesheet_New: Submitted/Approved Hours, FTE, Billed FTE, Project UTL, Onsite/Offsite
- vw_billing_timesheet_daywise_ne, vw_consultant_timesheet_daywise: Day-wise hours
- report_392_all: Billing Type, Category, Status
- New_Monthly_HC_Report: Business area, SOW, Vertical, Region
- SchTask: Resource, GCI_ID, Type
- DimDate: Date hierarchy, working days
- holidays_*: Exclude holidays
- Mapping sheets: Portfolio/Delivery Lead, SGA, ELT

**Required DAX Measures:**
- Total Hours = SUMX(WorkingDays, [Days]*[HoursPerDay])
- FTE = DIVIDE([Submitted Hours], [Total Hours])
- Billed FTE = DIVIDE([Approved Hours], [Total Hours])
- Utilization % = DIVIDE([Billed Hours], [Available Hours])
- Compliance % = DIVIDE([Submitted Hours], [Expected Hours])
- Bench/SGA/AVA counts = CALCULATE(COUNTROWS(...), [Category] = ...)

**Performance Optimization:**
- Aggregations for large fact tables
- Incremental refresh
- Import mode for facts, DirectQuery for large/slow sources
- Limit visuals per page (max 12)

**Security:**
- Row-level security by region, project, or leader
- Data freshness indicator (last refresh timestamp)
- Data lineage documentation

---

### 7. POWER BI FEATURE UTILIZATION

**Modern Features Leveraged:**
- Q&A: Natural language interface, synonyms, featured questions
- Smart Narratives: Automated text summaries
- Key Influencers: AI-driven factor analysis
- Decomposition Tree: Hierarchical root cause
- Anomaly Detection: Outlier identification
- What-If Parameters: Scenario modeling
- Field Parameters: Dynamic metric selection
- Mobile Layout: Optimized phone/tablet views
- Accessibility: Alt text, contrast, keyboard nav
- Bookmarks: Storytelling, reset views
- Paginated Reports: Exportable detail
- Power Automate: Alerts, distribution
- On-Object Interaction: Modern buttons, hover

**Configuration Details:**
- Q&A: Train with synonyms, featured questions
- Smart Narratives: Place below key visuals
- Key Influencers: Target = Utilization/FTE, Explain by = Resource/Project/Category
- Decomposition Tree: Analyze FTE/Billing, Explain by = Region/Project/Status
- Anomaly: Enable on all time series
- What-If: Parameters for hours, allocation, rates
- Field Parameters: Slicer for metric switching
- Mobile: Create phone view for each page
- Accessibility: Alt text, tab order, high contrast

**Benefits & Use Cases:**
- Fast executive insights, deep analyst drill-down, operational compliance tracking, AI-driven root cause, scenario planning, mobile access, and inclusive design.

---

**Note:**
- DataModelSchema files not accessible; validate technical feasibility and relationships before implementation.
- All recommendations align with provided requirements, Power BI best practices, and available visuals.
- For any schema or DAX gaps, consult with data modeler before build.