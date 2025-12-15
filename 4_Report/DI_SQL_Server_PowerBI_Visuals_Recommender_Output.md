____________________________________________
## Author : AAVA
## Created on :   
## Description :   Comprehensive Power BI dashboard design recommendations for SQL Server UTL Logic resource utilization reporting, including requirements analysis, data model mapping, page-by-page visual/UX specs, and advanced Power BI feature utilization.
_____________________________________________

# 1. REQUIREMENTS & DATA MODEL ANALYSIS SUMMARY

## Key Findings from Requirements Document

- **Business Objectives**: 
  - Track resource utilization (UTL) across multiple geographies (India, US, Canada, LATAM).
  - Calculate and display Total Hours, Submitted Hours, Approved Hours, FTE, Billed FTE, and Project Utilization.
  - Support complex allocation logic (weighted average for multi-project allocations).
  - Categorize resources/projects (India Billing, Client Project Matrix, SGA, Bench/AVA).
  - Enable analysis by multiple dimensions: location, project, client, category, status, delivery leader, etc.
  - Provide detailed breakdowns and drill-downs for operational and management reporting.

- **Target Audience**: 
  - Executives (strategic KPIs, high-level trends)
  - Managers/Leads (team/project utilization, allocation, billing)
  - Analysts (detailed breakdowns, anomaly detection)
  - Operational users (resource-level data, timesheet validation)

- **Metrics/KPIs**:
  - Total Hours (by location logic)
  - Submitted Hours, Approved Hours
  - Total FTE, Billed FTE
  - Project Utilization
  - Available Hours, Actual Hours, Onsite/Offsite Hours
  - Category, Status, Delivery Leader, Portfolio Lead

- **Business Questions**:
  - What is the overall resource utilization by region, project, and category?
  - Which resources/projects are under/over-utilized?
  - How do billed vs. unbilled hours trend over time?
  - Where are the anomalies or outliers in utilization?
  - How do allocations and FTEs distribute across projects and locations?

- **Filters/Interactivity**:
  - Date range, Region, Project, Client, Category, Status, Delivery Leader, Portfolio Lead
  - Drill-through from summary to detail
  - Sync slicers across pages
  - Exportable tables

- **Compliance/Security**:
  - Data ownership/contact info required
  - Data refresh/freshness indicators
  - Potential for RLS (row-level security) by region/manager

- **Usage Frequency**:
  - Daily/weekly for operational and management review
  - Monthly for executive summaries

## Data Model Structure Overview

- **Fact Tables**:
  - `gold Go_Agg_Resource_Utilization`: Aggregated resource utilization (Total Hours, Submitted/Approved Hours, FTEs, Utilization, etc.)
  - `gold Go_Fact_Timesheet_Entry`: Detailed timesheet entries
  - `gold Go_Fact_Timesheet_Approval`: Timesheet approvals

- **Dimension Tables**:
  - `gold Go_Dim_Date`: Date dimension (with working day/weekend logic)
  - `gold Go_Dim_Holiday`: Holiday dimension (by location)
  - `gold Go_Dim_Project`: Project metadata (Category, Status, Billing Type, etc.)
  - `gold Go_Dim_Resource`: Resource metadata (Location, Business Area, Delivery Leader, etc.)
  - `gold Go_Dim_Workflow_Task`: Workflow/process metadata

- **Relationships**:
  - Star schema with fact tables linked to dimensions by keys (Resource_Code/ID, Project_ID, Calendar_Date, etc.)
  - Date hierarchies and variations for time-based analysis
  - Some inactive relationships for advanced scenarios

- **Measures/Columns**:
  - All required fields for UTL logic are present (Total_Hours, Submitted_Hours, Approved_Hours, FTEs, Utilization, etc.)
  - Calculated columns for business logic (Category, Status, Onsite/Offsite, etc.)

## Identified Gaps or Constraints

- **Gaps**:
  - No explicit "weighted average" allocation field—must be implemented in DAX.
  - Some advanced logic (e.g., SGA, Bench/AVA categorization) may require additional calculated columns/measures.
  - Data quality and data lineage fields are present but may need surfacing in the dashboard for transparency.

- **Constraints**:
  - Large data volumes may impact performance (recommend aggregations and incremental refresh).
  - Multi-region holiday logic requires careful DAX for accurate working day calculations.
  - Security/RLS not explicitly defined—should be scoped if required.

## Recommended Data Model Enhancements

- Implement DAX measures for:
  - Weighted FTE allocation across projects
  - Accurate working day/hour calculations by region
  - Category/Status assignment logic as per requirements
- Consider summary/aggregation tables for performance
- Add calculated columns for drill-through keys if needed

---

# 2. DASHBOARD OVERVIEW

## Purpose and Objectives

- Provide a comprehensive, multi-level view of resource utilization, allocation, and billing across projects and geographies.
- Enable executives to monitor high-level KPIs and trends.
- Allow managers and analysts to drill into detailed operational data.
- Surface anomalies, outliers, and actionable insights using modern Power BI AI features.

## Target Audience(s)

- Executives (quick, high-level insights)
- Managers/Leads (team/project management)
- Analysts (detailed analysis, anomaly detection)
- Operational users (resource-level validation)

## Key Business Questions Addressed

- What is the overall and segmented resource utilization?
- How do utilization and billing metrics trend over time?
- Where are the inefficiencies or anomalies?
- How are resources allocated and categorized?
- Which projects/regions are underperforming or overperforming?

## Page Structure Summary

1. Index/Landing Page
2. Executive Summary Page
3. Detail Pages:
   - Utilization Detail
   - FTE/Allocation Detail
   - Billing/Category Detail
   - Resource/Project Detail
4. Q&A Page
5. AI Insights Page (Key Influencers, Decomposition Tree)
6. Anomaly Detection Page
7. What-If Analysis Page (optional/phase 2)

---

# 3. PAGE-BY-PAGE DETAILED SPECIFICATIONS

## 3.1 Index/Landing Page

**Purpose:** Orientation, navigation, and context

**Layout Recommendations:**
- Large dashboard title and description
- Last refresh date/time
- Navigation buttons to all major pages (Exec Summary, Details, Q&A, AI, Anomaly)
- Quick reference/legend for key terms
- Contact/data owner info
- Optional: Recent highlights/alerts

**Visual Elements:**
- Title text box with logo/branding
- Card for last refresh timestamp
- Navigation buttons (rounded, hover effect, icons)
- Info icon with tooltip for dashboard usage
- Legend panel (key KPIs, color codes)
- Contact info text box

**Design Specifications:**
- Background color: #F5F7FA
- Button style: Rounded corners (8px), subtle shadow, hover color #E0E7EF
- Typography: Header 32pt bold, body 16pt regular
- Layout: Centered grid navigation

**Power BI Features:**
- Button visuals with page navigation
- Bookmarks for default views
- Tooltips for guidance

---

## 3.2 Executive Summary Page

**Purpose:** High-level KPIs and trends for leadership

**Layout Recommendations:**
- Top: 4-6 KPI cards (Total Utilization, FTE, Billed FTE, Available Hours, etc.)
- Middle: 2-3 trend visuals (e.g., Utilization % over time, Billed vs. Unbilled trend)
- Bottom: Key breakdowns (by region, category, status)
- Global filters/slicers (date, region, category) top-right

**Visual Elements:**

*Top Section - KPI Cards:*
- Card or Multi-row Card visuals
- Metrics: 
  - Total Utilization %
  - Total FTE
  - Billed FTE
  - Available Hours
  - Actual Hours
  - Project Utilization
- Conditional formatting: Green/red for above/below target
- Data source: `gold Go_Agg_Resource_Utilization` measures

*Middle Section - Trend Analysis:*
- Line Chart: Utilization % over time (by month/quarter)
- Area Chart: Billed vs. Unbilled trend
- Drill-through enabled

*Bottom Section - Key Breakdowns:*
- Clustered Column Chart: Utilization by Region
- Donut Chart: FTE by Category
- Treemap: Hours by Project/Client

**Interactivity:**
- Drill-through from KPIs/visuals to detail pages
- Sync slicers (date, region, category)
- Bookmarks for default/filtered views
- "Reset filters" button

**Global Filters/Slicers:**
- Date range (relative/calendar)
- Region, Category, Status (dropdown/tile)

**Design Specifications:**
- Color palette: Primary #0047AB, Accent #00B386, Category #F9A825, #E53935, #3949AB
- Card format: 48pt numbers, 16pt labels
- Spacing: 15px between visuals, ample white space

**Power BI Features:**
- Smart Narratives below KPIs
- Anomaly detection on line charts
- Drill-through configuration
- Mobile layout optimization

---

## 3.3 Detail Page 1: Utilization Detail

**Purpose:** Deep dive into resource/project utilization

**Layout Recommendations:**
- Header: Page title, back button, breadcrumb
- Top: Detailed KPIs (Utilization %, FTE, Billed FTE, Project Utilization)
- Middle: Multiple visuals (trend, breakdown, distribution, map)
- Bottom: Data table/matrix for drill-down
- Side: Filters (region, project, category, status)

**Visual Elements:**

*Header Section:*
- Title, back button, breadcrumb, sync slicer panel

*KPI Section:*
- Card/KPI visuals: Utilization %, FTE, Billed FTE, Project Utilization
- Variance indicators (vs. target, YoY/MoM)

*Analysis Section:*
1. **Trend Analysis**: Line and Clustered Column Chart (Utilization % and FTE over time)
2. **Breakdown**: Stacked Bar Chart (Utilization by Category/Status)
3. **Distribution**: Histogram (Utilization % distribution)
4. **Geographic**: Filled Map (Utilization by Region/Country)
5. **Top/Bottom Performers**: Table/Matrix (Top 10/Bottom 10 Projects by Utilization)
6. **Key Influencers**: (if applicable) - see AI page

*Data Table Section:*
- Table/Matrix: Resource, Project, Utilization %, FTE, Hours, Category, Status
- Conditional formatting, drill-down, export enabled

**Interactivity:**
- Drill-through from summary
- Drill-down on visuals (date, region, project)
- Cross-filtering between visuals
- Bookmarks for saved views
- Report page tooltips

**Filters Panel:**
- Sync filters from Exec Summary
- Page-level: Project, Category, Status

**Design Specifications:**
- Consistent color scheme
- Section headers/dividers
- 10-15px visual padding
- Accessible contrast

**Power BI Features:**
- Smart Narratives
- Anomaly detection
- Drill-through/back navigation
- Field parameters for metric switching
- Mobile layout

---

## 3.4 Detail Page 2: FTE/Allocation Detail

**Purpose:** Analyze FTE allocation, weighted averages, and multi-project splits

**Layout Recommendations:**
- Header: Title, back button, breadcrumb
- Top: KPIs (Total FTE, Weighted FTE, Allocation Ratio)
- Middle: Visuals for allocation breakdowns, trends, and distributions
- Bottom: Data table of allocations

**Visual Elements:**
- KPI Cards: Total FTE, Weighted FTE, Allocation Ratio
- Waterfall Chart: FTE allocation changes over time
- Clustered Bar Chart: FTE by Project/Resource
- Matrix: Resource allocation across projects (weighted)
- Scatter Chart: Allocation ratio vs. Utilization

**Interactivity:**
- Drill-through, drill-down, cross-filtering
- Bookmarks

**Filters Panel:**
- Project, Resource, Category

**Power BI Features:**
- Field parameters for allocation metrics
- Smart Narratives
- Exportable matrix

---

## 3.5 Detail Page 3: Billing/Category Detail

**Purpose:** Analyze billed/unbilled hours, category/status breakdowns

**Layout Recommendations:**
- Header: Title, back button, breadcrumb
- Top: KPIs (Billed Hours, Unbilled Hours, % Billable)
- Middle: Visuals for billing trends, category/status breakdowns
- Bottom: Data table

**Visual Elements:**
- KPI Cards: Billed Hours, Unbilled Hours, % Billable
- Area Chart: Billed vs. Unbilled over time
- Donut Chart: Hours by Category
- Treemap: Hours by Status
- Table: Project/Resource, Billed/Unbilled, Category, Status

**Interactivity:**
- Drill-through, cross-filtering, bookmarks

**Filters Panel:**
- Category, Status, Project

**Power BI Features:**
- Anomaly detection on billing trend
- Smart Narratives

---

## 3.6 Detail Page 4: Resource/Project Detail

**Purpose:** Resource-level and project-level operational analysis

**Layout Recommendations:**
- Header: Title, back button, breadcrumb
- Top: KPIs (Resource Count, Project Count, Onsite/Offsite Split)
- Middle: Visuals for resource/project breakdowns, distributions
- Bottom: Data table

**Visual Elements:**
- KPI Cards: Resource Count, Project Count, Onsite/Offsite Hours
- Clustered Bar Chart: Resources by Project
- Stacked Column Chart: Onsite vs. Offsite by Region
- Matrix: Resource/Project, Hours, FTE, Category, Status

**Interactivity:**
- Drill-through, cross-filtering, bookmarks

**Filters Panel:**
- Resource, Project, Region

**Power BI Features:**
- Exportable matrix
- Smart Narratives

---

## 3.X Q&A Page

**Purpose:** Natural language queries for ad-hoc analysis

**Layout Recommendations:**
- Prominent Q&A visual (centered)
- Suggested questions panel
- Help text/instructions

**Visual Elements:**
- Q&A visual (full width)
- Text box: Sample questions (e.g., "Show utilization by region for last month")
- Buttons: Pre-built questions

**Configuration:**
- Train Q&A with synonyms (e.g., "utilization", "FTE", "hours")
- Featured questions: 
  - "Show utilization by category"
  - "Top 10 projects by billed hours"
  - "Compare FTE this year vs last year"
  - "Show unbilled hours by region"

**Design Specifications:**
- Large input box
- Clear instructions
- Consistent branding

**Power BI Features:**
- Q&A visual
- Featured questions
- Synonym training

---

## 3.Y AI Insights Page (Key Influencers & Decomposition Tree)

**Purpose:** AI-driven analysis of utilization drivers and breakdowns

**Layout Recommendations:**
- Split: Key Influencers (left), Decomposition Tree (right)
- Context explanation at top

**Visual Elements:**
- Key Influencers: Analyze what drives Utilization % or Billed FTE
- Decomposition Tree: Break down Utilization by Region, Category, Project, Status

**Interactivity:**
- Dynamic dimension selection
- Export insights

**Design Specifications:**
- Clean, focused layout
- Clear labels

**Power BI Features:**
- Key Influencers visual
- Decomposition Tree visual
- Smart Narratives

---

## 3.Z Anomaly Detection Page

**Purpose:** Surface outliers and unusual patterns

**Layout Recommendations:**
- Time series charts with anomaly detection
- Summary cards (anomaly count)
- Table of anomalies

**Visual Elements:**
- Line Chart: Utilization % over time with anomaly detection enabled
- Card: Total anomalies detected
- Table: Date, Metric, Actual, Expected, Deviation %

**Design Specifications:**
- Red/orange highlights for anomalies
- Explanation of detection logic

**Power BI Features:**
- Anomaly detection
- Conditional formatting
- Drill-through to detail

---

## 3.W What-If Analysis Page (Phase 2)

**Purpose:** Scenario modeling for utilization/billing

**Layout Recommendations:**
- What-if parameter sliders (e.g., FTE %, Hours, Bill Rate)
- Result cards (projected utilization, billed hours)
- Comparison charts

**Visual Elements:**
- Slicers/input boxes for parameters
- Cards: Baseline vs. scenario
- Line/Area Chart: Scenario comparison

**Power BI Features:**
- What-if parameters
- DAX scenario measures
- Bookmarks for scenarios

---

# 4. DESIGN SYSTEM DOCUMENTATION

## Color Palette

**Primary Colors:**
- Brand primary: #0047AB (headers, key actions)
- Brand secondary: #00B386 (accents, highlights)
- Brand accent: #F9A825 (alerts, CTAs)

**Data Visualization Colors:**
- Sequential: #E3F2FD, #90CAF9, #42A5F5, #1976D2, #0047AB
- Categorical: #0047AB, #00B386, #F9A825, #E53935, #3949AB, #8E24AA, #43A047, #F06292
- Diverging: #E53935, #F9A825, #00B386, #0047AB, #3949AB, #8E24AA, #43A047

**Semantic Colors:**
- Success: #43A047
- Warning: #F9A825
- Error: #E53935
- Neutral: #BDBDBD

**Background & UI:**
- Page background: #F5F7FA
- Visual background: #FFFFFF
- Border: #E0E0E0
- Text primary: #212121
- Text secondary: #757575

**Conditional Formatting Rules:**
- Above target: #43A047 (green)
- At target: #F9A825 (amber)
- Below target: #E53935 (red)

## Typography

- Dashboard title: Segoe UI, 32pt, Bold
- Page headers: Segoe UI, 24pt, SemiBold
- Visual titles: Segoe UI, 16pt, SemiBold
- Body text: Segoe UI, 14pt, Regular
- Data labels: Segoe UI, 12pt, SemiBold

## Spacing & Layout Grid

- Canvas size: 1920 x 1080
- Grid: 20px increments
- Margin: 20px from edges
- Visual padding: 15px
- Section spacing: 30px

## Visual Standards

- Border radius: 8px
- Shadow: 0 2px 8px #E0E7EF
- Visual border: 1px #E0E0E0
- Title alignment: Left
- Legend position: Top or Right
- Data label format: 1 decimal, K/M suffix for large numbers

## Accessibility Guidelines

- Alt text for all visuals
- Color contrast WCAG 2.1 AA
- Keyboard navigation
- Screen reader labels

---

# 5. INTERACTION & NAVIGATION DESIGN

## Navigation Flow Diagram (Text Description)

- Index → Executive Summary → [Utilization Detail | FTE/Allocation Detail | Billing/Category Detail | Resource/Project Detail]
- Breadcrumb on each page
- Home button on all pages
- Back button on detail pages
- Bookmarks for saved views
- Drill-through from summary to details
- Cross-page filtering (sync slicers)
- Buttons for Q&A, AI, Anomaly pages

## Drill-Through Matrix

| From Page           | To Page(s)                        | Filters Passed                |
|---------------------|-----------------------------------|-------------------------------|
| Executive Summary   | All Detail Pages                  | Date, Region, Category, Status|
| Detail Pages        | More granular detail (if needed)  | All active filters            |
| Anomaly/AI Pages    | Relevant Detail Pages             | Date, Metric, Category        |

## Filter Strategy

- Sync slicers: Date, Region, Category, Status
- Page-level filters: Project, Resource, Delivery Leader
- Visual-level filters: For specific breakdowns
- Filters pane: Hidden by default, accessible via icon

## Bookmark Plan

- Default view (reset state)
- Key analysis bookmarks (pre-filtered)
- Bookmark navigator for storytelling

## Tooltip Strategy

- Default tooltips for all visuals
- Report page tooltips for KPI cards and trend charts
- Tooltip pages for additional context

---

# 6. DATA MODEL INTEGRATION

## Table/Measure Mapping

- **Index/Landing**: Any table for refresh date; static content
- **Executive Summary**: 
  - Table: `gold Go_Agg_Resource_Utilization`
  - Measures: Total Utilization %, FTE, Billed FTE, Available Hours, Project Utilization
  - Dimensions: Date, Region, Category, Status
- **Utilization Detail**: 
  - Table: `gold Go_Agg_Resource_Utilization`
  - Measures: Utilization %, FTE, Project Utilization, etc.
  - Dimensions: Project, Resource, Region, Category, Status
- **FTE/Allocation Detail**: 
  - Table: `gold Go_Agg_Resource_Utilization`
  - Measures: Weighted FTE (DAX), Allocation Ratio
  - Dimensions: Project, Resource
- **Billing/Category Detail**: 
  - Table: `gold Go_Agg_Resource_Utilization`
  - Measures: Billed/Unbilled Hours, % Billable
  - Dimensions: Category, Status, Project
- **Resource/Project Detail**: 
  - Table: `gold Go_Agg_Resource_Utilization`, `gold Go_Dim_Resource`, `gold Go_Dim_Project`
  - Measures: Resource/Project Count, Onsite/Offsite Hours
- **Q&A/AI/Anomaly**: 
  - Table: As above, plus `gold Go_Fact_Timesheet_Entry` for granular analysis

## Required DAX Measures (Patterns)

- Weighted FTE: 
  ```
  Weighted FTE = 
    SUMX(
      VALUES([Resource_Code]),
      DIVIDE([Submitted_Hours], [Total_Hours])
    )
  ```
- Utilization %: 
  ```
  Utilization % = DIVIDE([Actual_Hours], [Available_Hours])
  ```
- Billed FTE: 
  ```
  Billed FTE = DIVIDE([Approved_Hours], [Total_Hours])
  ```

- Additional DAX for category/status assignment as per requirements logic.

## Performance Optimization Recommendations

- Use Import mode for main tables; DirectQuery only if data is too large
- Aggregation tables for summary visuals
- Incremental refresh on large fact tables
- Limit visuals per page (max 12)
- Optimize DAX with variables, SUMX, CALCULATE patterns

## Security Recommendations

- Implement RLS by Region/Manager if required
- Mask sensitive fields as needed
- Show data lineage and refresh info

---

# 7. POWER BI FEATURE UTILIZATION

## Summary of Modern Features Leveraged

- **Q&A Visual**: Natural language queries for business users
- **Smart Narratives**: Auto-generated text summaries on summary/detail pages
- **Key Influencers**: AI-driven analysis of utilization drivers
- **Decomposition Tree**: Interactive breakdowns for root cause analysis
- **Anomaly Detection**: Highlight outliers in time series
- **Field Parameters**: Allow users to switch metrics/dimensions on visuals
- **What-If Parameters**: Scenario modeling for utilization/billing
- **Bookmarks**: Storytelling and saved views
- **Mobile Layout**: Optimized for Power BI mobile app
- **Accessibility**: Alt text, color contrast, keyboard navigation
- **Paginated Reports**: Export to detailed reports if needed
- **Power Automate Integration**: Alerts for threshold breaches

## Configuration Details

- Train Q&A with synonyms and featured questions
- Configure Key Influencers for Utilization %/Billed FTE
- Enable anomaly detection on all trend charts
- Use field parameters for flexible metric switching
- Set up bookmarks for default and key analysis views
- Optimize report for mobile and accessibility

## Benefits and Use Cases

- Executive insights in seconds
- Deep-dive analysis for managers/analysts
- Self-service exploration for all users
- Automated anomaly and driver detection
- Scenario planning and what-if analysis

---

# PRIORITY RECOMMENDATIONS

- **High Priority**: Index, Executive Summary, Utilization Detail, FTE/Allocation Detail, Billing/Category Detail, Resource/Project Detail, Q&A, AI Insights, Anomaly Detection, Accessibility
- **Medium Priority**: What-If Analysis, Paginated Reports, Power Automate integration
- **Low Priority/Future**: Custom RLS, advanced scenario modeling, additional export/reporting features

---

**This document provides a complete, actionable blueprint for building a modern, performant, and user-friendly Power BI dashboard for resource utilization and UTL logic, fully aligned with business requirements and leveraging advanced Power BI features.**
