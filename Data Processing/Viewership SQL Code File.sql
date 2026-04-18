select * from `workspace`.`default`.`viewership` limit 10;

---------------------------------------------------------------------------------

---Convert UTC --> SA Time

SELECT DISTINCT from_utc_timestamp(v.`RecordDate2`, 'Africa/Johannesburg') AS Sa_Time

FROM workspace.default.viewership AS v;

------------------------------------------------------------------------------------

----Extract Time Features
SELECT 
  date(from_utc_timestamp(v.RecordDate2, 'Africa/Johannesburg')) AS Date_SA,
  date_format(from_utc_timestamp(v.RecordDate2, 'Africa/Johannesburg'), 'HH:mm') AS Hour_SA,
  date_format(from_utc_timestamp(v.RecordDate2, 'Africa/Johannesburg'), 'EEEE') AS day_of_week_SA
FROM workspace.default.viewership AS v;

---------------------------------------------------------------------------------

----Daily Usage Trend 

SELECT 
  date(from_utc_timestamp(v.RecordDate2, 'Africa/Johannesburg')) AS Date_SA, 
  COUNT(*) AS Total_sessions,
  date_format(from_utc_timestamp(v.RecordDate2, 'Africa/Johannesburg'), 'EEEE') AS day_of_week_SA
FROM workspace.default.viewership AS v
GROUP BY Date_SA, day_of_week_SA
ORDER BY Date_SA;

--------------------------------------------------------------------------------------

---Peak Hours by Duration   
SELECT 
  date(from_utc_timestamp(v.RecordDate2, 'Africa/Johannesburg')) AS Date_SA, 
  COUNT(*) AS Total_sessions,
  SUM(ABS(HOUR(v.`Duration 2`) * 3600 + MINUTE(v.`Duration 2`) * 60 + SECOND(v.`Duration 2`))) AS Total_Duration,
  date_format(from_utc_timestamp(v.RecordDate2, 'Africa/Johannesburg'), 'HH:mm') AS Hour_SA
FROM workspace.default.viewership AS v
GROUP BY Date_SA, Hour_SA
ORDER BY Total_Duration DESC;

----------------------------------------------------------------------------------------

----Content Performance

SELECT Channel2, COUNT(*) AS Session_Count,
       ROUND(SUM(ABS(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`))) / 3600, 2) AS Total_Hours_Watched
FROM workspace.default.viewership
GROUP BY Channel2
ORDER BY Total_Hours_Watched DESC;

----------------------------------------------------------------------------------------
