# Power BI Copilot Ally Unit Testing Output

---

## API Cost Consumed: 0.03 USD

---

## 1. Test Case List

### Index/Landing Page

**Test ID:** IDX-01
**Test Description:** Validate that the last refresh date card displays the latest [End_Time] from Gold.Go_Process_Audit.
**Expected Output:** Card shows the most recent End_Time value.

**Test ID:** IDX-02
**Test Description:** Validate that navigation buttons link to all major dashboard sections.
**Expected Output:** Each button navigates to the correct page.

**Test ID:** IDX-03
**Test Description:** Validate input for info icon tooltip and contact info text box (not null, correct format).
**Expected Output:** Info icon and contact box are present and populated.

---

### Executive Summary Page

**Test ID:** EXE-01
**Test Description:** Validate KPI Card for Total Utilization % ([Actual_Hours]/[Available_Hours]).
**Expected Output:** Card displays correct Utilization % (0-100%).

**Test ID:** EXE-02
**Test Description:** Validate KPI Card for Total FTE ([Total_FTE]).
**Expected Output:** Card displays sum of Total_FTE.

**Test ID:** EXE-03
**Test Description:** Validate KPI Card for Billed FTE ([Billed_FTE]).
**Expected Output:** Card displays sum of Billed_FTE.

**Test ID:** EXE-04
**Test Description:** Validate KPI Card for Available Hours ([Available_Hours]).
**Expected Output:** Card displays sum of Available_Hours.

**Test ID:** EXE-05
**Test Description:** Validate KPI Card for Actual Hours ([Actual_Hours]).
**Expected Output:** Card displays sum of Actual_Hours.

**Test ID:** EXE-06
**Test Description:** Validate KPI Card for Project Utilization % ([Project_Utilization]).
**Expected Output:** Card displays correct Project Utilization %.

**Test ID:** EXE-07
**Test Description:** Validate line chart for Utilization % over time ([Calendar_Date]).
**Expected Output:** Line chart shows Utilization % trend by date.

**Test ID:** EXE-08
**Test Description:** Validate area chart for FTE trend over time ([Total_FTE], [Calendar_Date]).
**Expected Output:** Area chart shows FTE trend by date.

**Test ID:** EXE-09
**Test Description:** Validate donut chart for resource split by [Category].
**Expected Output:** Donut chart shows count by Category.

**Test ID:** EXE-10
**Test Description:** Validate clustered column chart for Utilization by [Market] or [Business_Area].
**Expected Output:** Chart shows Utilization by Market/Business_Area.

**Test ID:** EXE-11
**Test Description:** Validate treemap for resource count by [Project_Name].
**Expected Output:** Treemap shows count by Project_Name.

---

### Utilization Detail Page

**Test ID:** UTL-01
**Test Description:** Validate KPI cards for Utilization %, Total Hours, Submitted Hours, Approved Hours.
**Expected Output:** Cards display correct values.

**Test ID:** UTL-02
**Test Description:** Validate dual axis chart for Utilization % and FTE over time.
**Expected Output:** Chart shows both metrics by date.

**Test ID:** UTL-03
**Test Description:** Validate stacked bar chart for Utilization by Project.
**Expected Output:** Chart shows Utilization by Project_Name.

**Test ID:** UTL-04
**Test Description:** Validate waterfall chart for Actual vs. Target Hours.
**Expected Output:** Chart shows variance ([Actual_Hours] vs. [Available_Hours]).

**Test ID:** UTL-05
**Test Description:** Validate map visual for Utilization by Market/Business_Area.
**Expected Output:** Map shows correct values by location.

**Test ID:** UTL-06
**Test Description:** Validate table for resource/project/date utilization details.
**Expected Output:** Table shows correct values for all columns.

---

### FTE & Billed FTE Detail Page

**Test ID:** FTE-01
**Test Description:** Validate KPI cards for Total FTE, Billed FTE, FTE/Consultant split.
**Expected Output:** Cards display correct values.

**Test ID:** FTE-02
**Test Description:** Validate line chart for FTE trend.
**Expected Output:** Chart shows FTE trend by date.

**Test ID:** FTE-03
**Test Description:** Validate clustered column chart for FTE by Market/Project.
**Expected Output:** Chart shows FTE by Market or Project_Name.

**Test ID:** FTE-04
**Test Description:** Validate donut chart for FTE by Category.
**Expected Output:** Donut chart shows FTE by Category.

**Test ID:** FTE-05
**Test Description:** Validate box plot for FTE distribution by Project/Resource.
**Expected Output:** Box plot shows FTE distribution.

**Test ID:** FTE-06
**Test Description:** Validate table for resource/project/FTE details.
**Expected Output:** Table shows correct values.

---

### Timesheet Submission & Approval Detail Page

**Test ID:** TSA-01
**Test Description:** Validate KPI cards for Submission Rate, Approval Rate, Avg Approval Time.
**Expected Output:** Cards display correct rates and average time.

**Test ID:** TSA-02
**Test Description:** Validate line chart for submission/approval trend.
**Expected Output:** Chart shows trend by date.

**Test ID:** TSA-03
**Test Description:** Validate stacked bar chart for submission/approval by Project/Manager.
**Expected Output:** Chart shows correct values by Project/Manager.

**Test ID:** TSA-04
**Test Description:** Validate table for pending/rejected timesheets.
**Expected Output:** Table shows correct details for pending/rejected timesheets.

---

### Category/Status Breakdown Page

**Test ID:** CAT-01
**Test Description:** Validate donut chart for resource count by Category.
**Expected Output:** Donut chart shows count by Category.

**Test ID:** CAT-02
**Test Description:** Validate clustered column chart for Utilization by Status.
**Expected Output:** Chart shows Utilization by Status.

**Test ID:** CAT-03
**Test Description:** Validate table for resource/project/category/status details.
**Expected Output:** Table shows correct values.

---

### SGA/Bench/AVA Analysis Page

**Test ID:** SBA-01
**Test Description:** Validate KPI cards for SGA, Bench, AVA resource counts.
**Expected Output:** Cards show correct counts.

**Test ID:** SBA-02
**Test Description:** Validate treemap for resource count by SGA/Bench/AVA category.
**Expected Output:** Treemap shows correct counts.

**Test ID:** SBA-03
**Test Description:** Validate table for SGA/Bench/AVA resource details.
**Expected Output:** Table shows correct values.

---

### Q&A Page

**Test ID:** QNA-01
**Test Description:** Validate Q&A visual responds to synonyms and featured questions.
**Expected Output:** Q&A returns correct results for sample queries.

---

### AI Insights Page

**Test ID:** AI-01
**Test Description:** Validate Key Influencers visual for drivers of Utilization % or Billed FTE.
**Expected Output:** Visual correctly identifies top drivers.

**Test ID:** AI-02
**Test Description:** Validate Decomposition Tree for Utilization % by Market, Category, Project.
**Expected Output:** Tree drills down correctly by dimension.

---

### Anomaly Detection Page

**Test ID:** ANM-01
**Test Description:** Validate line chart anomaly detection for Utilization % over time.
**Expected Output:** Chart highlights anomalies.

**Test ID:** ANM-02
**Test Description:** Validate table for anomaly details (date, metric, expected, deviation).
**Expected Output:** Table shows correct anomaly details.

---

## 2. SQL Queries to Validate Each Test Case

### IDX-01
```sql
SELECT TOP 1 [End_Time] FROM Gold.Go_Process_Audit ORDER BY [End_Time] DESC;
```

### EXE-01
```sql
SELECT SUM([Actual_Hours]) AS Actual, SUM([Available_Hours]) AS Available, 
       CASE WHEN SUM([Available_Hours]) > 0 THEN SUM([Actual_Hours]) / SUM([Available_Hours]) ELSE 0 END AS Utilization_Percent
FROM Gold.Go_Agg_Resource_Utilization;
```

### EXE-02
```sql
SELECT SUM([Total_FTE]) AS Total_FTE FROM Gold.Go_Agg_Resource_Utilization;
```

### EXE-03
```sql
SELECT SUM([Billed_FTE]) AS Billed_FTE FROM Gold.Go_Agg_Resource_Utilization;
```

### EXE-04
```sql
SELECT SUM([Available_Hours]) AS Available_Hours FROM Gold.Go_Agg_Resource_Utilization;
```

### EXE-05
```sql
SELECT SUM([Actual_Hours]) AS Actual_Hours FROM Gold.Go_Agg_Resource_Utilization;
```

### EXE-06
```sql
SELECT AVG([Project_Utilization]) AS Project_Utilization_Percent FROM Gold.Go_Agg_Resource_Utilization;
```

### EXE-07
```sql
SELECT [Calendar_Date], AVG([Project_Utilization]) AS Utilization_Percent
FROM Gold.Go_Agg_Resource_Utilization
GROUP BY [Calendar_Date]
ORDER BY [Calendar_Date];
```

### EXE-08
```sql
SELECT [Calendar_Date], SUM([Total_FTE]) AS FTE
FROM Gold.Go_Agg_Resource_Utilization
GROUP BY [Calendar_Date]
ORDER BY [Calendar_Date];
```

### EXE-09
```sql
SELECT [Category], COUNT(*) AS Resource_Count
FROM Gold.Go_Dim_Project
GROUP BY [Category];
```

### EXE-10
```sql
SELECT r.[Market], AVG(a.[Project_Utilization]) AS Utilization
FROM Gold.Go_Agg_Resource_Utilization a
JOIN Gold.Go_Dim_Resource r ON a.[Resource_Code] = r.[Resource_Code]
GROUP BY r.[Market];
```

### EXE-11
```sql
SELECT [Project_Name], COUNT(*) AS Resource_Count
FROM Gold.Go_Agg_Resource_Utilization
GROUP BY [Project_Name];
```

### UTL-01
```sql
SELECT AVG([Project_Utilization]) AS Utilization_Percent,
       SUM([Total_Hours]) AS Total_Hours,
       SUM([Submitted_Hours]) AS Submitted_Hours,
       SUM([Approved_Hours]) AS Approved_Hours
FROM Gold.Go_Agg_Resource_Utilization;
```

### UTL-02
```sql
SELECT [Calendar_Date], AVG([Project_Utilization]) AS Utilization_Percent, SUM([Total_FTE]) AS FTE
FROM Gold.Go_Agg_Resource_Utilization
GROUP BY [Calendar_Date]
ORDER BY [Calendar_Date];
```

### UTL-03
```sql
SELECT [Project_Name], AVG([Project_Utilization]) AS Utilization
FROM Gold.Go_Agg_Resource_Utilization
GROUP BY [Project_Name];
```

### UTL-04
```sql
SELECT SUM([Actual_Hours]) AS Actual, SUM([Available_Hours]) AS Target, SUM([Actual_Hours]) - SUM([Available_Hours]) AS Variance
FROM Gold.Go_Agg_Resource_Utilization;
```

### UTL-05
```sql
SELECT r.[Market], AVG(a.[Project_Utilization]) AS Utilization
FROM Gold.Go_Agg_Resource_Utilization a
JOIN Gold.Go_Dim_Resource r ON a.[Resource_Code] = r.[Resource_Code]
GROUP BY r.[Market];
```

### UTL-06
```sql
SELECT a.[Resource_Code], a.[Project_Name], a.[Calendar_Date], a.[Project_Utilization], a.[Total_FTE], a.[Submitted_Hours], a.[Approved_Hours]
FROM Gold.Go_Agg_Resource_Utilization a;
```

### FTE-01
```sql
SELECT SUM([Total_FTE]) AS Total_FTE, SUM([Billed_FTE]) AS Billed_FTE, r.[Business_Type], COUNT(*) AS Count
FROM Gold.Go_Agg_Resource_Utilization a
JOIN Gold.Go_Dim_Resource r ON a.[Resource_Code] = r.[Resource_Code]
GROUP BY r.[Business_Type];
```

### FTE-02
```sql
SELECT [Calendar_Date], SUM([Total_FTE]) AS FTE
FROM Gold.Go_Agg_Resource_Utilization
GROUP BY [Calendar_Date]
ORDER BY [Calendar_Date];
```

### FTE-03
```sql
SELECT r.[Market], SUM(a.[Total_FTE]) AS FTE
FROM Gold.Go_Agg_Resource_Utilization a
JOIN Gold.Go_Dim_Resource r ON a.[Resource_Code] = r.[Resource_Code]
GROUP BY r.[Market];
```

### FTE-04
```sql
SELECT p.[Category], SUM(a.[Total_FTE]) AS FTE
FROM Gold.Go_Agg_Resource_Utilization a
JOIN Gold.Go_Dim_Project p ON a.[Project_Name] = p.[Project_Name]
GROUP BY p.[Category];
```

### FTE-05
```sql
SELECT a.[Project_Name], a.[Resource_Code], a.[Total_FTE]
FROM Gold.Go_Agg_Resource_Utilization a;
```

### FTE-06
```sql
SELECT a.[Resource_Code], a.[Project_Name], a.[Total_FTE], a.[Billed_FTE], p.[Category]
FROM Gold.Go_Agg_Resource_Utilization a
JOIN Gold.Go_Dim_Project p ON a.[Project_Name] = p.[Project_Name];
```

### TSA-01
```sql
SELECT SUM([Submitted_Hours]) AS Submitted, SUM([Total_Hours]) AS Total, SUM([Approved_Hours]) AS Approved,
       CASE WHEN SUM([Total_Hours]) > 0 THEN SUM([Submitted_Hours]) / SUM([Total_Hours]) ELSE 0 END AS Submission_Rate,
       CASE WHEN SUM([Submitted_Hours]) > 0 THEN SUM([Approved_Hours]) / SUM([Submitted_Hours]) ELSE 0 END AS Approval_Rate
FROM Gold.Go_Agg_Resource_Utilization;
```

### TSA-02
```sql
SELECT [Calendar_Date], SUM([Submitted_Hours]) AS Submitted, SUM([Approved_Hours]) AS Approved
FROM Gold.Go_Agg_Resource_Utilization
GROUP BY [Calendar_Date]
ORDER BY [Calendar_Date];
```

### TSA-03
```sql
SELECT a.[Project_Name], SUM(a.[Submitted_Hours]) AS Submitted, SUM(a.[Approved_Hours]) AS Approved
FROM Gold.Go_Agg_Resource_Utilization a
GROUP BY a.[Project_Name];
```

### TSA-04
```sql
SELECT t.[Resource_Code], t.[Project_Task_Reference], t.[Timesheet_Date], a.[approval_status]
FROM Gold.Go_Fact_Timesheet_Entry t
LEFT JOIN Gold.Go_Fact_Timesheet_Approval a ON t.[Resource_Code] = a.[Resource_Code] AND t.[Timesheet_Date] = a.[Timesheet_Date]
WHERE a.[approval_status] IN ('Pending', 'Rejected');
```

### CAT-01
```sql
SELECT [Category], COUNT(*) AS Resource_Count
FROM Gold.Go_Dim_Project
GROUP BY [Category];
```

### CAT-02
```sql
SELECT p.[Status], AVG(a.[Project_Utilization]) AS Utilization
FROM Gold.Go_Agg_Resource_Utilization a
JOIN Gold.Go_Dim_Project p ON a.[Project_Name] = p.[Project_Name]
GROUP BY p.[Status];
```

### CAT-03
```sql
SELECT a.[Resource_Code], a.[Project_Name], p.[Category], p.[Status], a.[Total_FTE], a.[Billed_FTE]
FROM Gold.Go_Agg_Resource_Utilization a
JOIN Gold.Go_Dim_Project p ON a.[Project_Name] = p.[Project_Name];
```

### SBA-01
```sql
SELECT p.[Category], COUNT(*) AS Resource_Count
FROM Gold.Go_Dim_Project p
WHERE p.[Category] IN ('SGA', 'Bench', 'AVA')
GROUP BY p.[Category];
```

### SBA-02
```sql
SELECT p.[Category], COUNT(*) AS Resource_Count
FROM Gold.Go_Dim_Project p
WHERE p.[Category] IN ('SGA', 'Bench', 'AVA')
GROUP BY p.[Category];
```

### SBA-03
```sql
SELECT a.[Resource_Code], a.[Project_Name], p.[Category], p.[Status], a.[Total_FTE], a.[Billed_FTE]
FROM Gold.Go_Agg_Resource_Utilization a
JOIN Gold.Go_Dim_Project p ON a.[Project_Name] = p.[Project_Name]
WHERE p.[Category] IN ('SGA', 'Bench', 'AVA');
```

### QNA-01
```sql
-- Example: Top 10 resources by FTE
SELECT TOP 10 a.[Resource_Code], SUM(a.[Total_FTE]) AS FTE
FROM Gold.Go_Agg_Resource_Utilization a
GROUP BY a.[Resource_Code]
ORDER BY FTE DESC;
```

### AI-01
```sql
-- Key Influencers: What drives Utilization %
SELECT a.[Project_Utilization], r.[Market], p.[Category], p.[Status], a.[Project_Name]
FROM Gold.Go_Agg_Resource_Utilization a
JOIN Gold.Go_Dim_Resource r ON a.[Resource_Code] = r.[Resource_Code]
JOIN Gold.Go_Dim_Project p ON a.[Project_Name] = p.[Project_Name];
```

### AI-02
```sql
-- Decomposition Tree: Utilization % by Market, Category, Project
SELECT r.[Market], p.[Category], a.[Project_Name], AVG(a.[Project_Utilization]) AS Utilization
FROM Gold.Go_Agg_Resource_Utilization a
JOIN Gold.Go_Dim_Resource r ON a.[Resource_Code] = r.[Resource_Code]
JOIN Gold.Go_Dim_Project p ON a.[Project_Name] = p.[Project_Name]
GROUP BY r.[Market], p.[Category], a.[Project_Name];
```

### ANM-01
```sql
-- Anomaly detection: Utilization % time series
SELECT [Calendar_Date], AVG([Project_Utilization]) AS Utilization_Percent
FROM Gold.Go_Agg_Resource_Utilization
GROUP BY [Calendar_Date]
ORDER BY [Calendar_Date];
-- (Anomaly detection logic to be applied in Power BI or external analytics)
```

### ANM-02
```sql
-- Example anomaly details table
-- (Requires anomaly detection logic)
-- Placeholder for expected/actual/deviation
SELECT [Calendar_Date], AVG([Project_Utilization]) AS Actual_Utilization, NULL AS Expected_Value, NULL AS Deviation
FROM Gold.Go_Agg_Resource_Utilization
GROUP BY [Calendar_Date]
ORDER BY [Calendar_Date];
```
