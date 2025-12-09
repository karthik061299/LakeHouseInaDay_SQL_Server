# Power BI Copilot Prompt Output: Resource Utilization & Workforce Management Dashboard

## Index/Landing Page

Create a dashboard landing page with a large title text box ("Resource Utilization & Workforce Management Dashboard"), logo image, and a card visual showing the last refresh date using the [End_Time] field from Gold.Go_Process_Audit. Add navigation buttons to each major report section using Button visuals with rounded corners and hover color #E3E7EF. Include an info icon with a tooltip explaining the dashboard and a contact info text box at the bottom. Set the background color to #F8F9FB and use Segoe UI for all text.

---

## Executive Summary Page

Create 6 KPI Card visuals at the top to display Total Utilization %, Total FTE, Billed FTE, Available Hours, Actual Hours, and Project Utilization %. Use the following fields from Gold.Go_Agg_Resource_Utilization: [Total_Hours], [Submitted_Hours], [Approved_Hours], [Total_FTE], [Billed_FTE], [Available_Hours], [Actual_Hours], [Project_Utilization]. For Utilization %, use the DAX: DIVIDE([Actual_Hours], [Available_Hours], 0). Format numbers as 48pt with conditional formatting: green (#28A745) above target, yellow (#F6A800) at target, red (#E74C3C) below target.

Add a line chart showing Utilization % over time by [Calendar_Date] from Gold.Go_Dim_Date, using [Project_Utilization] as the value. Add an area chart for FTE trend over time using [Total_FTE]. Add a donut chart for resource split by [Category] from Gold.Go_Dim_Project and a clustered column chart for Utilization by [Market] or [Business_Area] from Gold.Go_Dim_Resource. Add a treemap for resource count by [Project_Name] from Gold.Go_Dim_Project. Place global slicers for Date range ([Calendar_Date]), Geography ([Market]), Project ([Project_Name]), Category ([Category]), and Status ([Status]) as dropdowns. Use the color palette: #005EB8 (primary), #F6A800 (accent), #28A745 (success), #E74C3C (error).

---

## Utilization Detail Page

Create KPI cards for Utilization %, Total Hours, Submitted Hours, and Approved Hours using fields from Gold.Go_Agg_Resource_Utilization. Add a line & clustered column chart (dual axis) with Utilization % ([Project_Utilization]) and FTE ([Total_FTE]) over time ([Calendar_Date]). Add a stacked bar chart for Utilization by [Project_Name] and a waterfall chart for variance analysis: Actual vs. Target ([Actual_Hours] vs. [Available_Hours]). Add a map visual showing Utilization by [Market] or [Business_Area]. At the bottom, add a table with columns: [Resource_Code], [Project_Name], [Calendar_Date], [Project_Utilization], [Total_FTE], [Submitted_Hours], [Approved_Hours]. Apply conditional formatting to highlight top/bottom performers.

---

## FTE & Billed FTE Detail Page

Create KPI cards for Total FTE, Billed FTE, and FTE/Consultant split using [Total_FTE], [Billed_FTE], and [Business_Type] from Gold.Go_Agg_Resource_Utilization and Gold.Go_Dim_Resource. Add a line chart for FTE trend ([Total_FTE] over [Calendar_Date]), a clustered column chart for FTE by [Market] or [Project_Name], a donut chart for FTE by [Category], and a box plot for FTE distribution by [Project_Name] or [Resource_Code]. Add a table with [Resource_Code], [Project_Name], [Total_FTE], [Billed_FTE], [Category].

---

## Timesheet Submission & Approval Detail Page

Create KPI cards for Submission Rate, Approval Rate, and Average Approval Time. Use [Submitted_Hours] from Gold.Go_Agg_Resource_Utilization and [Approved_Standard_Hours], [Total_Approved_Hours] from Gold.Go_Fact_Timesheet_Approval. Submission Rate = DIVIDE([Submitted_Hours], [Total_Hours], 0); Approval Rate = DIVIDE([Approved_Hours], [Submitted_Hours], 0). Add a line chart for submission/approval trend over [Calendar_Date]. Add a stacked bar chart for submission/approval by [Project_Name] or [Delivery_Leader]. Add a table listing pending/rejected timesheets with [Resource_Code], [Project_Name], [Timesheet_Date], [approval_status].

---

## Category/Status Breakdown Page

Create a donut chart showing resource count by [Category] from Gold.Go_Dim_Project. Add a clustered column chart for Utilization by [Status] from Gold.Go_Dim_Project and Gold.Go_Agg_Resource_Utilization. Add a table with [Resource_Code], [Project_Name], [Category], [Status], [Total_FTE], [Billed_FTE].

---

## SGA/Bench/AVA Analysis Page

Create KPI cards for SGA, Bench, and AVA resource counts. Use [Category] from Gold.Go_Dim_Project and filter for SGA, Bench, and AVA. Add a treemap visual with resource count by [Category] (SGA/Bench/AVA) and a table with [Resource_Code], [Project_Name], [Category], [Status], [Total_FTE], [Billed_FTE].

---

## Q&A Page

Create a Q&A visual centered on the page, trained with synonyms for "utilization", "FTE", "bench", etc. Add a text box with example questions and buttons for featured queries: "Show utilization by project for last month", "Top 10 resources by FTE", "Utilization trend for India", "Bench count by month". Use large font for the Q&A input and clear instructions.

---

## AI Insights Page

Create a split layout with a Key Influencers visual on the left (target: [Project_Utilization] or [Billed_FTE], explain by [Market], [Project_Name], [Category], [Status]) and a Decomposition Tree visual on the right (analyze [Project_Utilization], drill by [Market], [Category], [Project_Name]). Add a text box at the top explaining the AI insights.

---

## Anomaly Detection Page

Create a line chart with anomaly detection enabled for [Project_Utilization] over [Calendar_Date] from Gold.Go_Agg_Resource_Utilization and Gold.Go_Dim_Date. Add a card visual for total anomalies and a table with [Calendar_Date], [Project_Utilization], [Expected Value], [Deviation].

---

## General Formatting & Best Practices

- Use Segoe UI font throughout (titles: 32pt bold, headers: 24pt semibold, visuals: 16pt bold, data labels: 12pt bold).
- Apply color palette: #005EB8 (primary), #F6A800 (accent), #28A745 (success), #E74C3C (error), #6C757D (neutral).
- Set page background to #F8F9FB, visual background to #FFFFFF, border #E3E7EF.
- Use border radius 8px, subtle shadow for cards/buttons, and 15px visual padding.
- Configure alt text for all visuals and ensure accessibility (WCAG 2.1 AA contrast, keyboard navigation, tab order).
- Enable drill-through from KPIs to detail pages, sync global slicers, and provide a "Reset Filters" button using bookmarks.
