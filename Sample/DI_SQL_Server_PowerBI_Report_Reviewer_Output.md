# Power BI Copilot Prompts Reviewer Output

## Index/Landing Page
- Create Card visual for latest 'gold Go_Agg_Resource_Utilization[update_date]' as Last Refresh Date.
- Add Button visuals for navigation to all report pages with rounded corners and icons.
- Add Text box for dashboard title and description with 32pt bold font.
- Add Table visual as legend panel for key KPIs and color codes.
- Add Text box for contact/data owner info.

## Executive Summary Page
- Create KPI Card visuals: Total Utilization %, Total FTE, Billed FTE, Available Hours, Actual Hours, Project Utilization from 'gold Go_Agg_Resource_Utilization'.
- Add Line Chart for Utilization % over time using 'Calendar_Date' and 'Project_Utilization'.
- Add Area Chart for Billed vs. Unbilled trend using 'Calendar_Date', 'Billed_FTE', and calculated Unbilled FTE.
- Add Clustered Column Chart for Utilization by Region using 'gold Go_Dim_Resource[Business_Area]' and 'Project_Utilization'.
- Add Donut Chart for FTE by Category using 'gold Go_Dim_Project[Category]' and 'Total_FTE'.
- Add Treemap for Hours by Project/Client using 'gold Go_Dim_Project[Project_Name]', 'Client_Name', and 'Actual_Hours'.
- Add Slicers for Date range, Region, Category, Status.

## Utilization Detail Page
- Create KPI Cards for Utilization %, FTE, Billed FTE, Project Utilization from 'gold Go_Agg_Resource_Utilization'.
- Add Line and Clustered Column Chart for Utilization % and FTE over time using 'Calendar_Date', 'Project_Utilization', 'Total_FTE'.
- Add Stacked Bar Chart for Utilization by Category/Status using 'gold Go_Dim_Project[Category]', 'Status', 'Project_Utilization'.
- Add Histogram for Utilization % distribution using 'Project_Utilization'.
- Add Filled Map for Utilization by Region using 'gold Go_Dim_Resource[Business_Area]' and 'Project_Utilization'.
- Add Table for Top 10/Bottom 10 Projects by Utilization using 'Project_Name', 'Project_Utilization'.
- Add Matrix for Resource, Project, Utilization %, FTE, Hours, Category, Status with drill-down.
- Add Slicers for Region, Project, Category, Status.

## FTE/Allocation Detail Page
- Create KPI Cards for Total FTE, Weighted FTE (DAX: SUMX(VALUES([Resource_Code]), DIVIDE([Submitted_Hours],[Total_Hours]))), Allocation Ratio.
- Add Waterfall Chart for FTE allocation changes over time using 'Calendar_Date', 'Total_FTE'.
- Add Clustered Bar Chart for FTE by Project/Resource using 'Project_Name', 'Resource_Code', 'Total_FTE'.
- Add Matrix for Resource allocation across projects using 'Resource_Code', 'Project_Name', Weighted FTE.
- Add Scatter Chart for Allocation Ratio vs. Utilization using Allocation Ratio, 'Project_Utilization'.
- Add Slicers for Project, Resource, Category.

## Billing/Category Detail Page
- Create KPI Cards for Billed Hours, Unbilled Hours, % Billable using 'Approved_Hours', calculated Unbilled, % Billable.
- Add Area Chart for Billed vs. Unbilled over time using 'Calendar_Date', 'Approved_Hours', calculated Unbilled.
- Add Donut Chart for Hours by Category using 'gold Go_Dim_Project[Category]', 'Actual_Hours'.
- Add Treemap for Hours by Status using 'gold Go_Dim_Project[Status]', 'Actual_Hours'.
- Add Table for Project/Resource, Billed/Unbilled, Category, Status.
- Add Slicers for Category, Status, Project.

## Resource/Project Detail Page
- Create KPI Cards for Resource Count, Project Count, Onsite/Offsite Hours using 'Resource_Code', 'Project_Name', 'Onsite_Hours', 'Offsite_Hours'.
- Add Clustered Bar Chart for Resources by Project using 'Project_Name', Resource count.
- Add Stacked Column Chart for Onsite vs. Offsite by Region using 'Business_Area', 'Onsite_Hours', 'Offsite_Hours'.
- Add Matrix for Resource/Project, Hours, FTE, Category, Status.
- Add Slicers for Resource, Project, Region.

## Q&A Page
- Create Q&A visual using all fields and measures from 'gold Go_Agg_Resource_Utilization', 'gold Go_Dim_Resource', 'gold Go_Dim_Project'.
- Add Text box with sample questions: "Show utilization by region for last month", "Top 10 projects by billed hours", "Compare FTE this year vs last year", "Show unbilled hours by region".
- Add Buttons for pre-built questions.
- Train Q&A with synonyms: utilization, FTE, hours, billing, project, resource.

## AI Insights Page
- Create Key Influencers visual to analyze drivers for 'Project_Utilization', 'Billed_FTE'.
- Add Decomposition Tree visual to break down 'Project_Utilization' by Region, Category, Project, Status.

## Anomaly Detection Page
- Create Line Chart for Utilization % over time with anomaly detection using 'Calendar_Date', 'Project_Utilization'.
- Add Card for total anomalies detected.
- Add Table for Date, Metric, Actual, Expected, Deviation %.
