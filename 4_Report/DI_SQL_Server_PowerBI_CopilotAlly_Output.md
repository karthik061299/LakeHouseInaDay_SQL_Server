# Power BI Copilot Prompts for Resource Utilization & Workforce Management Dashboard

## Index/Landing Page
Create a landing page with a large title text box ("Resource Utilization & Workforce Management Dashboard"), company logo image, and a card visual showing the last refresh date from Gold.Go_Process_Audit[End_Time]. Add button visuals with rounded corners and icons for navigation to each report section (Executive Summary, Utilization Details, Billing Details, Bench/AVA, Q&A, AI Insights, Data Quality). Use background color #F5F7FA and button hover color #E0E7EF. Add an info icon with tooltip explaining dashboard usage, and a text box for contact/data owner info.

## Executive Summary Page
Create KPI card visuals for Total FTE (SUM of Gold.Go_Agg_Resource_Utilization[Total_FTE]), Billed FTE (SUM of [Billed_FTE]), Utilization % (DIVIDE(SUM([Submitted_Hours]), SUM([Available_Hours]))), Available Hours (SUM([Available_Hours])), Bench Count (COUNTROWS where Gold.Go_Dim_Resource[Employee_Category] = 'Bench'), and Data Quality Score (AVG(Gold.Go_Dim_Resource[data_quality_score])). Format cards with conditional formatting: #00A859 for positive, #E94F37 for negative. Add a line chart showing Utilization % over time (Gold.Go_Agg_Resource_Utilization[Calendar_Date], [Utilization %]), and an area chart for Billed FTE trend. Add a clustered column chart for Utilization by Region (Gold.Go_Dim_Resource[Business_Area]), a donut chart for Status (Gold.Go_Dim_Resource[Status]), and a treemap for Category (Gold.Go_Dim_Project[Category]). Add slicers for Date (Gold.Go_Dim_Date[Calendar_Date]), Region, Status, and Category. Place smart narrative below KPIs.

## Utilization Detail Page
Add KPI cards for Total FTE, Utilization %, Available Hours, and Onsite/Offsite split (SUM of Gold.Go_Agg_Resource_Utilization[Onsite_Hours], [Offsite_Hours]). Add a line and clustered column chart with Utilization % and FTE by month (Gold.Go_Dim_Date[Month_Year]), a stacked bar chart for Utilization by Business Area (Gold.Go_Dim_Resource[Business_Area]), a waterfall chart for variance to target utilization (Utilization % - Target Utilization %), and a scatter chart for Utilization vs. Billed FTE by Project (Gold.Go_Dim_Project[Project_Name]). Add a table or matrix with Resource, Project, Utilization %, Billed FTE, and Status, using conditional formatting for outliers. Enable drill-down by Year > Quarter > Month, and add filters for Date, Region, Business Area, Status, and Project.

## Billing & FTE Detail Page
Add KPI cards for Billed FTE (SUM([Billed_FTE])), Approved Hours (SUM(Gold.Go_Fact_Timesheet_Approval[Total_Approved_Hours])), Submitted Hours (SUM([Submitted_Hours])), and Billing Rate (AVG(Gold.Go_Dim_Project[Bill_Rate])). Add a line chart for Billed FTE trend over time (Gold.Go_Dim_Date[Calendar_Date]), a clustered column chart for Billed FTE by Project or Client (Gold.Go_Dim_Project[Project_Name], [Billed_FTE]), a donut chart for Billing Type (Gold.Go_Dim_Project[Billing_Type]), and a matrix for Billed FTE by Resource/Project. Add a table for Approval variance and error flags (Gold.Go_Fact_Timesheet_Approval[Hours_Variance], Gold.Go_Fact_Timesheet_Approval[approval_status]). Use diverging color scale for variance, and enable export to Excel. Add filters for Date, Project, Client, and Billing Type.

## Bench/AVA/ELT Analysis Page
Add KPI cards for Bench Count, AVA Count, and ELT Count (COUNTROWS where Gold.Go_Dim_Resource[Employee_Category] = 'Bench'/'AVA'/'ELT'). Add a stacked bar chart for Bench/AVA by Business Area (Gold.Go_Dim_Resource[Business_Area]), a treemap for Bench/AVA/ELT by Category (Gold.Go_Dim_Project[Category]), and a line chart for Bench/AVA trend over time (Gold.Go_Dim_Date[Calendar_Date]). Add a table with Resource, Status, Category, and Portfolio Leader. Use semantic colors: Bench #FFC107, AVA #17A2B8, ELT #6F42C1. Add filters for Date, Business Area, and Category.

## Project/Resource Detail Page
Add KPI cards for Project Utilization (Gold.Go_Agg_Resource_Utilization[Project_Utilization]), Actual Hours (SUM([Actual_Hours])), and Available Hours (SUM([Available_Hours])). Add a matrix with Resource/Project, Utilization %, Billed FTE, and Status. Add a table for timesheet entries, approval status, and error flags (from Gold.Go_Fact_Timesheet_Entry, Gold.Go_Fact_Timesheet_Approval, Gold.Go_Error_Data). Enable drill-down and export to Excel. Add filters for Date, Resource, and Project.

## Q&A Page
Create a Q&A visual using Gold.Go_Agg_Resource_Utilization, Gold.Go_Dim_Resource, and Gold.Go_Dim_Project. Add a text box with sample questions such as "Show utilization by business area for last month", "Top 10 projects by billed FTE", and "Bench count by region". Add buttons with pre-built queries. Train synonyms for FTE, Utilization, Bench, etc. Format with a large input box and clear instructions.

## AI Insights Page
Add a Key Influencers visual with Utilization % as the target, explained by Region, Project, Category, and Status (fields from Gold.Go_Agg_Resource_Utilization, Gold.Go_Dim_Resource, Gold.Go_Dim_Project). Add a Decomposition Tree visual analyzing Utilization % by Business Area, Project, Resource, and Status. Place a context explanation at the top.

## Anomaly Detection Page
Add a line chart for Utilization % and Billed FTE over time (Gold.Go_Agg_Resource_Utilization[Calendar_Date]), enable anomaly detection, and highlight anomalies in red/orange. Add a card showing the total anomalies detected, and a table with anomaly details (date, metric, actual, expected, deviation). Use conditional formatting for anomalies.

## Data Quality & Audit Page
Add KPI cards for Data Quality Score (AVG(Gold.Go_Dim_Resource[data_quality_score])) and Error Count (COUNT(Gold.Go_Error_Data[Error_ID])). Add a table with error details (Gold.Go_Error_Data), a line chart for error trend over time (Gold.Go_Error_Data[Error_Date]), and a table for audit logs (Gold.Go_Process_Audit). Enable drill-through to error details and export to Excel.
