# Power BI Copilot Prompt Review and Refinement Output

## 1. Create a clustered column chart showing Total FTE by Project Name and Calendar Month
Create a clustered column chart titled 'Monthly FTE by Project' to visualize Total FTE by Project Name and Calendar Month. Use 'Project_Name' and 'Calendar_Date' from Gold.Go_Agg_Resource_Utilization as the axis fields, and aggregate 'Total_FTE' by month as the value. Format the chart with distinct colors for each project, axis labels ('Project Name', 'Month'), data labels, and a descriptive title. Ensure the legend is visible and colors are consistent across the dashboard. Add a filter for Active Projects using the 'Status' field from Gold.Go_Dim_Project for enhanced usability.

## 2. Add a card visual to display the overall Utilization Rate
Add a card visual titled 'Overall Utilization Rate' to display the overall utilization percentage. Calculate Utilization Rate as the sum of 'Actual_Hours' divided by the sum of 'Available_Hours' from Gold.Go_Agg_Resource_Utilization. Format the card to show the value as a percentage with one decimal place. Ensure the title is clear and the card uses consistent font and color formatting.

## 3. Add a stacked bar chart showing Billed FTE vs Total FTE by Business Area
Add a stacked bar chart titled 'Billed vs Total FTE by Business Area'. Use 'Business_Area' from Gold.Go_Dim_Resource for the axis, and stack 'Billed_FTE' and 'Total_FTE' from Gold.Go_Agg_Resource_Utilization as values. Use contrasting colors for Billed FTE and Total FTE, include a visible legend, and format axis labels ('Business Area', 'FTE'). Consider using a clustered column chart if the business areas are few for better comparison. Add a filter for Active Resources using 'Status' from Gold.Go_Dim_Resource.

## 4. Add a matrix visual to break down Submitted Hours and Approved Hours by Resource and Project
Add a matrix visual titled 'Submitted vs Approved Hours by Resource and Project'. Use 'First_Name' and 'Last_Name' from Gold.Go_Dim_Resource as rows, 'Project_Name' from Gold.Go_Agg_Resource_Utilization as columns, and 'Submitted_Hours' and 'Approved_Hours' from Gold.Go_Agg_Resource_Utilization as values. Format the matrix with row and column subtotals, data labels, and ensure clear separation between resources and projects. Consider adding conditional formatting to highlight discrepancies between submitted and approved hours.

## 5. Add a pie chart to show the distribution of resources by Employee Category
Add a pie chart titled 'Resource Distribution by Category'. Use 'Employee_Category' from Gold.Go_Dim_Resource as the category field and count of 'Resource_Code' as the value. Format the pie chart with distinct colors for each category, data labels showing percentage and count, and a clear legend. Ensure the chart title and formatting are consistent with other visuals. Consider a treemap if there are many categories for improved readability.

## 6. Add a line chart to visualize trends in Actual Hours over time
Add a line chart titled 'Actual Hours Trend'. Use 'Calendar_Date' from Gold.Go_Agg_Resource_Utilization as the axis, aggregated by month, and sum of 'Actual_Hours' as the value. Format the line chart with a time axis, markers for each month, axis labels ('Month', 'Actual Hours'), and a clear legend. Use consistent colors and add data labels for improved readability.

## 7. Add a slicer for filtering visuals by Portfolio Leader
Add a slicer titled 'Filter by Portfolio Leader' using 'Portfolio_Leader' from Gold.Go_Dim_Resource. Format the slicer for easy selection, ensure the label is clear, and position it at the top of the dashboard for accessibility. Consider adding additional slicers for 'Project_Name', 'Business_Area', and 'Calendar_Date' if further interactivity is required.

## 8. Add a decomposition tree for root cause analysis of Utilization Rate by Resource, Project, and Business Area
Add a decomposition tree visual titled 'Utilization Rate Analysis' to enable users to drill down Utilization Rate by Resource, Project, and Business Area. Use 'Utilization Rate' (calculated as sum of 'Actual_Hours' / sum of 'Available_Hours'), and allow users to break down by 'Resource_Code' (Gold.Go_Dim_Resource), 'Project_Name' (Gold.Go_Agg_Resource_Utilization), and 'Business_Area' (Gold.Go_Dim_Resource). Format the tree for clarity and ensure consistent colors.

## 9. Add a KPI visual for tracking Monthly Change in Total FTE
Add a KPI visual titled 'Monthly Change in Total FTE' to track the difference in Total FTE between the current and previous month. Use 'Total_FTE' aggregated by 'Calendar_Date' (Gold.Go_Agg_Resource_Utilization). Format the KPI to show the current value, previous value, and percentage change. Ensure the title and formatting are consistent with other visuals.

## 10. Dashboard Formatting and Best Practices
- Ensure all visuals have descriptive titles, axis labels, legends, and data labels where applicable.
- Use a consistent color palette across all visuals.
- Group related visuals together for a logical dashboard flow.
- Add narrative text boxes to explain key insights and trends.
- Ensure all calculations and aggregations use fields present in the Gold Physical data model.
- Apply filters and slicers for enhanced interactivity.
- Use bookmarks for switching between summary and detailed views if needed.

## 11. Final Approval Checklist
- All prompts start with "Create" for the first visual and "Add" for subsequent visuals.
- Visual types are validated against the recommended Power BI visuals list.
- Data fields and calculations are aligned with the Gold Physical data model and reporting requirements.
- Formatting, structure, and terminology are consistent across all prompts.
- Dashboard provides at least 2–3 additional visuals beyond the original selection for richer insights.
- Interactivity features and narrative elements are included for usability and storytelling.

---

**This refined prompt set is ready for Power BI Copilot and aligns with all reporting requirements, recommended visuals, data model fields, and best practices.**
