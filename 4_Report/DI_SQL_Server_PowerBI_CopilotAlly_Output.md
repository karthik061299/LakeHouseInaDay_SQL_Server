# Power BI Copilot Prompts for UTL Resource Utilization Dashboard

## Index/Landing Page
- Create a Card visual showing the latest 'gold Go_Agg_Resource_Utilization[update_date]' as Last Refresh Date.
- Add Button visuals for navigation to each report page with rounded corners and icons.
- Add a Text box for dashboard title and description with 32pt bold font.
- Add a Legend panel using a Table visual listing key KPIs and color codes.
- Add a Text box for contact/data owner info.

## Executive Summary Page
- Create KPI Card visuals for Total Utilization %, Total FTE, Billed FTE, Available Hours, Actual Hours, and Project Utilization using 'gold Go_Agg_Resource_Utilization' measures.
- Add a Line Chart showing Utilization % over time using 'Calendar_Date' and 'Project_Utilization'.
- Add an Area Chart for Billed vs. Unbilled trend using 'Calendar_Date', 'Billed_FTE', and calculated Unbilled FTE.
- Add a Clustered Column Chart for Utilization by Region using 'gold Go_Dim_Resource[Business_Area]' and 'Project_Utilization'.
- Add a Donut Chart for FTE by Category using 'gold Go_Dim_Project[Category]' and 'Total_FTE'.
- Add a Treemap for Hours by Project/Client using 'gold Go_Dim_Project[Project_Name]', 'Client_Name', and 'Actual_Hours'.
- Add Slicers for Date range, Region, Category, and Status.

## Utilization Detail Page
- Create KPI Cards for Utilization %, FTE, Billed FTE, and Project Utilization using 'gold Go_Agg_Resource_Utilization'.
- Add a Line and Clustered Column Chart for Utilization % and FTE over time using 'Calendar_Date', 'Project_Utilization', and 'Total_FTE'.
- Add a Stacked Bar Chart for Utilization by Category/Status using 'gold Go_Dim_Project[Category]', 'Status', and 'Project_Utilization'.
- Add a Histogram for Utilization % distribution using 'Project_Utilization'.
- Add a Filled Map for Utilization by Region using 'gold Go_Dim_Resource[Business_Area]' and 'Project_Utilization'.
- Add a Table for Top 10/Bottom 10 Projects by Utilization using 'Project_Name' and 'Project_Utilization'.
- Add a Matrix for Resource, Project, Utilization %, FTE, Hours, Category, Status with drill-down enabled.
- Add Slicers for Region, Project, Category, and Status.

## FTE/Allocation Detail Page
- Create KPI Cards for Total FTE, Weighted FTE (DAX: SUMX(VALUES([Resource_Code]), DIVIDE([Submitted_Hours],[Total_Hours]))), and Allocation Ratio.
- Add a Waterfall Chart for FTE allocation changes over time using 'Calendar_Date' and 'Total_FTE'.
- Add a Clustered Bar Chart for FTE by Project/Resource using 'Project_Name', 'Resource_Code', and 'Total_FTE'.
- Add a Matrix for Resource allocation across projects using 'Resource_Code', 'Project_Name', and Weighted FTE.
- Add a Scatter Chart for Allocation Ratio vs. Utilization using Allocation Ratio and 'Project_Utilization'.
- Add Slicers for Project, Resource, and Category.

## Billing/Category Detail Page
- Create KPI Cards for Billed Hours, Unbilled Hours, and % Billable using 'Approved_Hours', calculated Unbilled, and % Billable.
- Add an Area Chart for Billed vs. Unbilled over time using 'Calendar_Date', 'Approved_Hours', and calculated Unbilled.
- Add a Donut Chart for Hours by Category using 'gold Go_Dim_Project[Category]' and 'Actual_Hours'.
- Add a Treemap for Hours by Status using 'gold Go_Dim_Project[Status]' and 'Actual_Hours'.
- Add a Table for Project/Resource, Billed/Unbilled, Category, Status.
- Add Slicers for Category, Status, and Project.

## Resource/Project Detail Page
- Create KPI Cards for Resource Count, Project Count, and Onsite/Offsite Hours using 'Resource_Code', 'Project_Name', 'Onsite_Hours', and 'Offsite_Hours'.
- Add a Clustered Bar Chart for Resources by Project using 'Project_Name' and Resource count.
- Add a Stacked Column Chart for Onsite vs. Offsite by Region using 'Business_Area', 'Onsite_Hours', and 'Offsite_Hours'.
- Add a Matrix for Resource/Project, Hours, FTE, Category, Status.
- Add Slicers for Resource, Project, and Region.

## Q&A Page
- Create a Q&A visual using all available fields and measures from 'gold Go_Agg_Resource_Utilization', 'gold Go_Dim_Resource', and 'gold Go_Dim_Project'.
- Add a Text box with sample questions: "Show utilization by region for last month", "Top 10 projects by billed hours", "Compare FTE this year vs last year", "Show unbilled hours by region".
- Add Buttons for pre-built questions.
- Train Q&A with synonyms: utilization, FTE, hours, billing, project, resource.

## AI Insights Page
- Create a Key Influencers visual to analyze drivers for 'Project_Utilization' and 'Billed_FTE'.
- Add a Decomposition Tree visual to break down 'Project_Utilization' by Region, Category, Project, and Status.

## Anomaly Detection Page
- Create a Line Chart for Utilization % over time with anomaly detection enabled using 'Calendar_Date' and 'Project_Utilization'.
- Add a Card for total anomalies detected.
- Add a Table for Date, Metric, Actual, Expected, Deviation %.
