- Create KPI card for Total FTE using Timesheet_New[Submitted Hours] and DimDate[Working Days]; calculation: Submitted Hours / (Working Days × Location Hrs); format: 2 decimals; title: Total FTE.
\
- Add KPI card for Billed FTE using Timesheet_New[Approved Hours] and DimDate[Working Days]; calculation: Approved Hours / (Working Days × Location Hrs); format: 2 decimals; title: Billed FTE.
\
- Add KPI card for Utilization % using Timesheet_New[Billed Hours] and Timesheet_New[Available Hours]; calculation: Billed Hours / Available Hours; format: percentage; title: Utilization %.
\
- Add multi-row card for Billable/Non-Billable Count using report_392_all[Billing Type]; calculation: count by Billing Type; format: whole number; title: Billable/Non-Billable Count.
\
- Add multi-row card for Bench/SGA/AVA Count using report_392_all[Category]; calculation: count where Category = Bench, SGA, AVA; format: whole number; title: Bench/SGA/AVA Count.
\
- Add KPI card for Compliance % using Timesheet_New[Submitted Hours] and Timesheet_New[Expected Hours]; calculation: Submitted Hours / Expected Hours; format: percentage; title: Compliance %.
\
- Add line chart for Utilization trend over time using DimDate[Date] and Timesheet_New[Utilization %]; x-axis: Date (Month); y-axis: Utilization %; line color: #2A72D4; title: Utilization Trend.
\
- Add line chart for FTE trend over time using DimDate[Date] and Timesheet_New[FTE]; x-axis: Date (Month); y-axis: FTE; line color: #4CAF50; title: FTE Trend.
\
- Add line chart for Billing trend over time using DimDate[Date] and Timesheet_New[Billed FTE]; x-axis: Date (Month); y-axis: Billed FTE; line color: #F9B233; title: Billing Trend.
\
- Add clustered column chart for breakdown by Region using New_Monthly_HC_Report[Region] and Timesheet_New[Utilization %]; x-axis: Region; y-axis: Utilization %; region color; title: Utilization by Region.
\
- Add donut chart for breakdown by Category using report_392_all[Category] and Timesheet_New[Utilization %]; legend: Category; values: Utilization %; category colors; title: Utilization by Category.
\
- Add treemap for breakdown by Status using report_392_all[Status] and Timesheet_New[Utilization %]; group: Status; values: Utilization %; status colors; title: Utilization by Status.
\
- Add stacked bar chart for Utilization by Project using DimProject[Project Name] and Timesheet_New[Utilization %]; x-axis: Project Name; y-axis: Utilization %; stacked by Category; title: Utilization by Project.
\
- Add histogram for distribution of Utilization % using Timesheet_New[Utilization %]; bins: 10; color: #2A72D4; title: Utilization Distribution.
\
- Add table for top/bottom performers using DimResource[Resource Name] and Timesheet_New[Utilization %]; sort by Utilization %; show top 10 and bottom 10; title: Top/Bottom Performers.
\
- Add matrix for drill-down by Resource, Project, Month using DimResource[Resource Name], DimProject[Project Name], DimDate[Month]; values: Timesheet_New[Utilization %]; title: Resource-Project-Month Matrix.
\
- Add table for timesheet compliance details using Timesheet_New[Resource Name], Timesheet_New[Submitted Hours], Timesheet_New[Expected Hours]; calculation: Compliance % per resource; highlight <90% in red; title: Timesheet Compliance Details.
\
- Add Q&A visual for natural language queries using all fact and dimension tables; enable synonyms for resource, project, billing, FTE, utilization; title: Ask a Question.
\
- Add Key Influencers visual with target: Timesheet_New[Utilization %]; explain by: DimResource[Resource Name], DimProject[Project Name], report_392_all[Category]; title: Key Influencers.
\
- Add Decomposition Tree for FTE analysis using Timesheet_New[FTE]; explain by: DimDate[Month], DimProject[Project Name], report_392_all[Status]; title: FTE Decomposition Tree.
\
- Add anomaly detection line chart for Utilization % over time using DimDate[Date], Timesheet_New[Utilization %]; enable anomaly detection; title: Utilization Anomaly Detection.
\
- Add What-If analysis visual using parameter slider for Timesheet_New[Submitted Hours]; show impact on Timesheet_New[FTE] and Timesheet_New[Utilization %]; title: What-If Analysis.
\
- Add slicers for Date, Location, Project, Category, Status using respective dimension tables; format: dropdown; align left; title: Filters.
\
- Format all visuals with titles, axis labels, data labels, colors, and legends as per design system.
\
- Maintain consistent formatting: font, color palette, spacing, border radius, shadow, and legend placement.
\
- Ensure all calculations and fields match requirements and data model schema.
\
- Suggest interactivity: slicers, filters, drill-through, bookmarks, smart narratives, anomaly detection, What-If parameters, Q&A.
\
- Use only visuals available in Power BI (see available visuals list).
\
- Avoid paragraphs; keep prompts short, direct, and bullet-pointed.