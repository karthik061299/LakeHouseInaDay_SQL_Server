# Refined Power BI Copilot Prompts for Resource Utilization Dashboard

## 1. Resource Utilization Overview
Create a clustered column chart to show monthly total FTE and billed FTE by location. Use fields from Gold.Go_Agg_Resource_Utilization: [Calendar_Date], [Total_FTE], [Billed_FTE], and join with Gold.Go_Dim_Resource for [Business_Area], [Is_Offshore], [Location]. Aggregate FTE values by month and location. Format with distinct colors for FTE types, clear axis labels ("Month", "FTE Count"), and a descriptive title "Monthly FTE vs Billed FTE by Location". Add data labels for each column. Ensure legend differentiates Total FTE vs Billed FTE. Use filters for [Business_Area] and [Is_Offshore].

## 2. Project-Level Utilization
Add a stacked bar chart to display project utilization rates for each project by month. Use [Project_Name], [Project_Utilization], [Calendar_Date] from Gold.Go_Agg_Resource_Utilization. Aggregate utilization by project and month. Format with project names on the y-axis, utilization percentage on the x-axis, color to differentiate months, and clear axis labels. Title: "Project Utilization Rate by Month". Add data labels for utilization rate. Add drill-through to project details.

## 3. Timesheet Submission and Approval Trend
Add a line chart to visualize submitted hours vs approved hours over time. Use [Calendar_Date], [Submitted_Hours], [Approved_Hours] from Gold.Go_Agg_Resource_Utilization. Aggregate by month. Format with two lines (distinct colors), legend, axis labels ("Month", "Hours"), and title "Submitted vs Approved Timesheet Hours Trend". Add slicers for [Business_Area], [Project_Name], and [Location].

## 4. Resource Availability & Allocation
Add a matrix visual to show available hours, actual hours, and allocation status by resource and project. Use [Resource_Code], [Project_Name], [Available_Hours], [Actual_Hours], [Status] from Gold.Go_Agg_Resource_Utilization and Gold.Go_Dim_Project. Rows: Resource, Columns: Project, Values: Available Hours, Actual Hours, Status. Apply conditional formatting for status (green for billed, red for unbilled, yellow for SGA/Bench/AVA). Add data bars for hours. Title: "Resource Availability & Allocation by Project".

## 5. FTE/Consultant Categorization
Add a pie chart to show the distribution of FTE vs Consultant resources. Use [Resource_Code], [Employee_Category] from Gold.Go_Dim_Resource. Count distinct resources per category. Format with percentage labels, legend, and title "Resource Distribution: FTE vs Consultant". Add color coding for categories. Add tooltip to show count.

## 6. Billing Category Breakdown
Add a donut chart to visualize the breakdown of billing categories (Billable, NBL, SGA, Bench, AVA, etc.). Use [Category] from Gold.Go_Dim_Project or Gold.Go_Agg_Resource_Utilization, sum [Actual_Hours] per category. Format with distinct colors for each category, percentage labels, legend, and title "Billing Category Breakdown". Add tooltip to show total hours per category.

## 7. Portfolio Leader Filter
Add a slicer visual for [Portfolio_Leader] from Gold.Go_Dim_Resource to enable dashboard filtering by portfolio leader. Format as a dropdown with search capability. Title: "Filter by Portfolio Leader".

## 8. Working Days & Holiday Impact
Add a line and clustered column combo chart to show working days and holiday impact by location and month. Use [Calendar_Date], [Is_Working_Day] from Gold.Go_Dim_Date and [Location] from Gold.Go_Dim_Holiday. Aggregate count of working days and holidays per location per month. Format with holidays as columns and working days as line, axis labels ("Month", "Count"), and title "Working Days vs Holidays by Location". Add legend for holidays and working days.

## 9. Trend Analysis: FTE, Utilization, and Billing Over Time
Add a line chart to show trends for [Total_FTE], [Project_Utilization], and [Billed_FTE] over time by month. Use Gold.Go_Agg_Resource_Utilization. Format with three lines (distinct colors), legend, axis labels, and title "Trend: FTE, Utilization, and Billing Over Time". Add slicers for [Business_Area], [Location], and [Portfolio_Leader].

## 10. KPI Cards
Add multi-row KPI cards to display:
- Total FTE (current month)
- Billed FTE (current month)
- Average Project Utilization (current month)
- Total Submitted Hours (current month)
- Total Approved Hours (current month)
Use Gold.Go_Agg_Resource_Utilization. Format with clear titles, numbers, and conditional formatting for high/low values.

## 11. Resource Breakdown by Location
Add a treemap to show resource distribution by [Location] and [Employee_Category]. Use Gold.Go_Dim_Resource. Size by count of [Resource_Code]. Format with color coding for categories and title "Resource Breakdown by Location & Category".

## 12. Decomposition Tree for Utilization Drivers
Add a decomposition tree visual to analyze drivers of utilization. Use [Business_Area], [Project_Name], [Location], [Portfolio_Leader], [Project_Utilization] from Gold.Go_Agg_Resource_Utilization. Root node: Project Utilization. Branch by business area, project, location, and leader. Title: "Utilization Drivers Decomposition Tree".

## 13. Dashboard Interactivity & Usability
- Add slicers for [Business_Area], [Location], [Portfolio_Leader], [Project_Name], and [Employee_Category].
- Include drill-through on visuals for project and resource details.
- Add tooltips for all charts showing relevant breakdowns.
- Maintain consistent formatting: font size, colors, axis labels, legends, and titles.
- Ensure all prompts use table and column names present in the Gold Physical Data Model.
- Apply best practices for readability and accessibility (contrasting colors, clear legends, descriptive titles).

## 14. Narrative & Storytelling
Add a narrative visual summarizing key insights:
- "This dashboard provides a comprehensive view of resource utilization, project performance, timesheet trends, and billing breakdowns across business areas and locations. Use the filters and slicers to explore drivers of utilization and resource allocation."

---

# All prompts above are aligned with the report requirements, recommended visuals, and the Gold Physical Data Model. Each prompt includes proper data field usage, formatting, and dashboard usability enhancements. Visual types are validated against available Power BI visuals. Consistency in structure, terminology, and formatting is ensured.
