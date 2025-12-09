# Power BI Copilot Prompts for Resource Utilization Dashboard

## 1. Resource Utilization Overview
Create a clustered column chart to show total FTE and billed FTE by month and location. Use fields from Gold.Go_Agg_Resource_Utilization: [Calendar_Date], [Total_FTE], [Billed_FTE], and join with Gold.Go_Dim_Resource for [Business_Area] or [Is_Offshore]. Aggregate FTE values by month and location. Format with distinct colors for FTE types, clear axis labels, and a descriptive title "Monthly FTE vs Billed FTE by Location".

## 2. Project-Level Utilization
Add a stacked bar chart to display project utilization rates for each project. Use [Project_Name], [Project_Utilization], and [Calendar_Date] from Gold.Go_Agg_Resource_Utilization. Aggregate utilization by project and month. Format with project names on the y-axis, utilization percentage on the x-axis, and use color to differentiate months. Title: "Project Utilization Rate by Month".

## 3. Timesheet Submission and Approval Trend
Add a line chart to visualize submitted hours vs approved hours over time. Use [Calendar_Date], [Submitted_Hours], and [Approved_Hours] from Gold.Go_Agg_Resource_Utilization. Aggregate by month. Format with two lines, one for submitted and one for approved hours, with clear legend and axis labels. Title: "Submitted vs Approved Timesheet Hours Trend".

## 4. Resource Availability & Allocation
Add a matrix visual to show available hours, actual hours, and allocation status by resource and project. Use [Resource_Code], [Project_Name], [Available_Hours], [Actual_Hours], and [Status] from Gold.Go_Agg_Resource_Utilization and Gold.Go_Dim_Project. Rows: Resource, Columns: Project, Values: Available Hours, Actual Hours, Status. Format with conditional formatting for status (e.g., green for billed, red for unbilled).

## 5. FTE/Consultant Categorization
Add a pie chart to show the distribution of FTE vs Consultant resources. Use [Resource_Code] and [Employee_Category] from Gold.Go_Dim_Resource, count distinct resources per category. Format with percentage labels and legend, title "Resource Distribution: FTE vs Consultant".

## 6. Billing Category Breakdown
Add a donut chart to visualize the breakdown of billing categories (Billable, NBL, SGA, Bench, AVA, etc.). Use [Category] from Gold.Go_Dim_Project or Gold.Go_Agg_Resource_Utilization, count or sum [Actual_Hours] per category. Format with distinct colors for each category, percentage labels, and legend. Title: "Billing Category Breakdown".

## 7. Portfolio Leader Filter
Add a slicer visual for [Portfolio_Leader] from Gold.Go_Dim_Resource to enable dashboard filtering by portfolio leader. Format as a dropdown with search capability.

## 8. Working Days & Holiday Impact
Add a line and column combo chart to show working days and holiday impact by location and month. Use [Calendar_Date], [Is_Working_Day] from Gold.Go_Dim_Date and [Location] from Gold.Go_Dim_Holiday. Aggregate count of working days and holidays per location per month. Format with holidays as columns and working days as line, title "Working Days vs Holidays by Location".
