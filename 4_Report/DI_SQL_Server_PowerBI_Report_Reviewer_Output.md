# Power BI Copilot Prompts Reviewer Output

## Introduction
This document provides a refined, actionable set of Power BI Copilot prompts for building a comprehensive Resource Utilization & Workforce Management dashboard. Prompts are reviewed for completeness, clarity, alignment with reporting requirements, optimal visual selection, proper data field usage, formatting, usability, and Power BI best practices. All prompts are validated against the Gold Physical Data Model and available Power BI visuals.

---

## Index/Landing Page
Create a landing page with a large title text box ("Resource Utilization & Workforce Management Dashboard"), company logo image, and a card visual showing the last refresh date from Gold.Go_Process_Audit[End_Time]. Add button visuals with rounded corners and icons for navigation to each report section (Executive Summary, Utilization Details, Billing Details, Bench/AVA, Q&A, AI Insights, Data Quality). Use background color #F5F7FA and button hover color #E0E7EF. Add an info icon with tooltip explaining dashboard usage, and a text box for contact/data owner info. Ensure accessibility features (alt text for visuals, keyboard navigation).

---

## Executive Summary Page
Add KPI card visuals for:
- Total FTE: SUM(Gold.Go_Agg_Resource_Utilization[Total_FTE])
- Billed FTE: SUM(Gold.Go_Agg_Resource_Utilization[Billed_FTE])
- Utilization %: DIVIDE(SUM(Gold.Go_Agg_Resource_Utilization[Submitted_Hours]), SUM(Gold.Go_Agg_Resource_Utilization[Available_Hours]))
- Available Hours: SUM(Gold.Go_Agg_Resource_Utilization[Available_Hours])
- Bench Count: COUNTROWS(FILTER(Gold.Go_Dim_Resource, Gold.Go_Dim_Resource[Employee_Category] = 'Bench'))
- Data Quality Score: AVERAGE(Gold.Go_Dim_Resource[data_quality_score])

Format cards with conditional formatting (#00A859 for positive, #E94F37 for negative). Add visuals:
- Line chart: Utilization % over time (Gold.Go_Agg_Resource_Utilization[Calendar_Date], [Utilization %])
- Area chart: Billed FTE trend
- Clustered column chart: Utilization by Region (Gold.Go_Dim_Resource[Business_Area])
- Donut chart: Status (Gold.Go_Dim_Resource[Status])
- Treemap: Category (Gold.Go_Dim_Project[Category])
- Slicers: Date (Gold.Go_Dim_Date[Calendar_Date]), Region, Status, Category
- Smart narrative below KPIs
- Add trend analysis (Line chart for YoY/MoM Utilization %)
- Add breakdown visuals (Treemap for Category, Clustered bar for Bench/AVA/ELT)

---

## Utilization Detail Page
Add KPI cards for:
- Total FTE
- Utilization %
- Available Hours
- Onsite/Offsite split: SUM(Gold.Go_Agg_Resource_Utilization[Onsite_Hours]), SUM(Gold.Go_Agg_Resource_Utilization[Offsite_Hours])

Visuals:
- Line and clustered column chart: Utilization % and FTE by month (Gold.Go_Dim_Date[Month_Year])
- Stacked bar chart: Utilization by Business Area (Gold.Go_Dim_Resource[Business_Area])
- Waterfall chart: Variance to target utilization (Utilization % - Target Utilization %)
- Scatter chart: Utilization % vs. Billed FTE by Project (Gold.Go_Dim_Project[Project_Name])
- Table/matrix: Resource, Project, Utilization %, Billed FTE, Status (conditional formatting for outliers)
- Add trend analysis: Line chart for Utilization % by Region
- Add breakdown: Matrix showing Utilization by Category

Interactivity:
- Drill-down (Year > Quarter > Month)
- Cross-filtering
- Drill-through to Resource/Project detail
- Slicers: Date, Region, Business Area, Status, Project
- Add slicers for Portfolio Leader and Delivery Leader for deeper filtering

---

## Billing & FTE Detail Page
Add KPI cards for:
- Billed FTE: SUM(Gold.Go_Agg_Resource_Utilization[Billed_FTE])
- Approved Hours: SUM(Gold.Go_Fact_Timesheet_Approval[Total_Approved_Hours])
- Submitted Hours: SUM(Gold.Go_Agg_Resource_Utilization[Submitted_Hours])
- Billing Rate: AVERAGE(Gold.Go_Dim_Project[Bill_Rate])

Visuals:
- Line chart: Billed FTE trend over time (Gold.Go_Dim_Date[Calendar_Date])
- Clustered column chart: Billed FTE by Project/Client (Gold.Go_Dim_Project[Project_Name], Gold.Go_Dim_Project[Client_Name])
- Donut chart: Billing Type (Gold.Go_Dim_Project[Billing_Type])
- Matrix: Billed FTE by Resource/Project
- Table: Approval variance and error flags (Gold.Go_Fact_Timesheet_Approval[Hours_Variance], Gold.Go_Fact_Timesheet_Approval[approval_status])
- Add breakdown: Clustered bar for Billed FTE by Status
- Add trend analysis: Area chart for Submitted vs. Approved Hours

Interactivity:
- Drill-through to Project/Resource detail
- Cross-filtering
- Slicers: Date, Project, Client, Billing Type
- Enable export to Excel
- Add slicers for Delivery Leader and Portfolio Leader

---

## Bench/AVA/ELT Analysis Page
Add KPI cards for:
- Bench Count: COUNTROWS(FILTER(Gold.Go_Dim_Resource, Gold.Go_Dim_Resource[Employee_Category] = 'Bench'))
- AVA Count: COUNTROWS(FILTER(Gold.Go_Dim_Resource, Gold.Go_Dim_Resource[Employee_Category] = 'AVA'))
- ELT Count: COUNTROWS(FILTER(Gold.Go_Dim_Resource, Gold.Go_Dim_Resource[Employee_Category] = 'ELT'))

Visuals:
- Stacked bar chart: Bench/AVA by Business Area (Gold.Go_Dim_Resource[Business_Area])
- Treemap: Bench/AVA/ELT by Category (Gold.Go_Dim_Project[Category])
- Line chart: Bench/AVA trend over time (Gold.Go_Dim_Date[Calendar_Date])
- Table: Resource, Status, Category, Portfolio Leader
- Add breakdown: Clustered column for Bench/AVA/ELT by Region
- Add trend analysis: Area chart for Bench/AVA/ELT over time

Interactivity:
- Drill-down by hierarchy
- Cross-filtering
- Drill-through to Resource detail
- Slicers: Date, Business Area, Category
- Add slicers for Delivery Leader

Formatting:
- Bench: #FFC107, AVA: #17A2B8, ELT: #6F42C1
- Section dividers for clarity

---

## Project/Resource Detail Page
Add KPI cards for:
- Project Utilization: Gold.Go_Agg_Resource_Utilization[Project_Utilization]
- Actual Hours: SUM(Gold.Go_Agg_Resource_Utilization[Actual_Hours])
- Available Hours: SUM(Gold.Go_Agg_Resource_Utilization[Available_Hours])

Visuals:
- Matrix: Resource/Project, Utilization %, Billed FTE, Status
- Table: Timesheet entries, approval status, error flags (Gold.Go_Fact_Timesheet_Entry, Gold.Go_Fact_Timesheet_Approval, Gold.Go_Error_Data)
- Add breakdown: Matrix for Utilization by Category and Portfolio Leader
- Add trend analysis: Line chart for Project Utilization over time

Interactivity:
- Drill-down by hierarchy
- Export to Excel
- Slicers: Date, Resource, Project, Category

Formatting:
- Accessible contrast, data bars in matrix

---

## Q&A Page
Create a Q&A visual using Gold.Go_Agg_Resource_Utilization, Gold.Go_Dim_Resource, Gold.Go_Dim_Project. Add a text box with sample questions:
- "Show utilization by business area for last month"
- "Top 10 projects by billed FTE"
- "Bench count by region"
- "Utilization trend for India"
Add buttons for pre-built queries. Train synonyms for FTE, Utilization, Bench, AVA, ELT, etc. Format with a large input box and clear instructions. Add featured questions panel and help text. Enable Q&A for all summary/agg tables.

---

## AI Insights Page
Add Key Influencers visual:
- Target: Utilization %
- Explain by: Region, Project, Category, Status (Gold.Go_Agg_Resource_Utilization, Gold.Go_Dim_Resource, Gold.Go_Dim_Project)
Add Decomposition Tree:
- Analyze: Utilization %
- Explain by: Business Area, Project, Resource, Status
Add context explanation at the top. Enable dynamic dimension selection and export insights.

---

## Anomaly Detection Page
Add line chart(s) for Utilization % and Billed FTE over time (Gold.Go_Agg_Resource_Utilization[Calendar_Date]), enable anomaly detection, highlight anomalies in red/orange. Add a card for total anomalies detected. Add a table for anomaly details (date, metric, actual, expected, deviation). Use conditional formatting for anomalies. Add breakdown: Matrix for anomalies by Region and Category.

---

## Data Quality & Audit Page
Add KPI cards for:
- Data Quality Score: AVERAGE(Gold.Go_Dim_Resource[data_quality_score])
- Error Count: COUNT(Gold.Go_Error_Data[Error_ID])
Visuals:
- Table: Error details (Gold.Go_Error_Data)
- Line chart: Error trend over time (Gold.Go_Error_Data[Error_Date])
- Table: Audit logs (Gold.Go_Process_Audit)
- Add breakdown: Matrix for error count by Category and Severity_Level
Interactivity:
- Drill-through to error details
- Export to Excel

---

## Dashboard Usability & Interactivity
- Ensure all pages have consistent formatting: titles, axis labels, data labels, colors, legend settings
- Maintain structure and terminology as per requirements
- Add slicers, filters, drill-throughs, and smart narratives where applicable
- Enable bookmarks for default views and storytelling
- Add accessibility features (alt text, keyboard navigation, contrast)
- Sync slicers for Date, Region, Status, Category across all pages

---

## Power BI Best Practices & Final Refinement
- All prompts use tables and columns from the Gold Physical Data Model
- Visual types selected from available Power BI visuals and optimized for reporting requirements
- Prompts expanded to include trend analysis, breakdowns, and interactivity for richer insights
- Aggregations, calculations, and filters are specified clearly
- Consistent formatting and structure maintained
- All prompts align with the requirements file and data model
- Ready for Copilot ingestion to generate actionable, user-friendly dashboards

---

## End of Reviewer Output
