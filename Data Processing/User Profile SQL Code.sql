select * from `workspace`.`default`.`user_profiles` limit 10;

-------------------------------------------------------------------------

--User Profile Data

SELECT UserID,
       Name,
       Surname,
       Age,
       Gender,
       Race,
       Province
FROM workspace.default.user_profiles_;

---------------------------------------------------------------------------------------

--cleaned_user_profile

SELECT UserID,
nullif(trim(Name), 'None') AS Name,
nullif(trim(Surname), 'None') AS Surname,
CASE WHEN Age = 0 THEN NULL ELSE Age END AS Age,
nullif(trim(Gender), 'None') AS Gender,
nullif(trim(Race), 'None') AS Race,
nullif(trim(Province), 'None') AS Province,
nullif(trim(`Social Media Handle`), 'None') AS Social_Media_Handle

FROM workspace.default.user_profiles_;

------------------------------------------------------------------------------------

---Age Demographic Distribution (Identifying the 25-45 target bracket) 

SELECT 

CASE 

WHEN Age < 18 THEN 'Under 18'

WHEN Age BETWEEN 18 AND 24 THEN '18-24'

WHEN	Age BETWEEN 25 AND 34 THEN '25-34'

WHEN	Age BETWEEN 35 AND 44 THEN '35-44'

WHEN	Age BETWEEN 45 AND 54 THEN '45-54'

ELSE '55+'

END AS Age_Group,

COUNT(*) AS UserCount

FROM workspace.default.user_profiles_
WHERE Age IS NOT NULL

GROUP BY Age_Group

ORDER BY UserCount DESC;

----------------------------------------------------------------------------

---Top provinces by subscriber count

SELECT Province, COUNT(UserID) AS Total_Subscribers
FROM workspace.default.user_profiles_
WHERE Province IS NOT NULL
GROUP BY Province
ORDER BY Total_Subscribers DESC
LIMIT 10;
----------------------------------------------------------------------------------


---Generational Grouping
SELECT
  CASE 
        WHEN Age >= 56 THEN 'Boomers (56+)'
        WHEN Age BETWEEN 41 AND 55 THEN 'Gen X (41-55)'
        WHEN Age BETWEEN 25 AND 40 THEN 'Millennials (25-40)'
        WHEN Age < 25 THEN 'Gen Z (under 25)'
        ELSE 'Unknown'
END AS Age_Groups,
COUNT(UserID) AS Subscriber_Count

FROM workspace.default.user_profiles_
WHERE Age IS NOT NULL AND Age > 0
GROUP BY Age_Groups
ORDER BY Age_Groups;

------------------------------------------------------------------------------------

---Diversity Breakdown (Gender and Race Distribution trends) 

SELECT Race, Gender, COUNT(*) AS UserCount

FROM (SELECT UserID,
nullif(trim(Name), 'None') AS Name,
nullif(trim(Surname), 'None') AS Surname,
CASE WHEN Age = 0 THEN NULL ELSE Age END AS Age,
nullif(trim(Gender), 'None') AS Gender,
nullif(trim(Race), 'None') AS Race,
nullif(trim(Province), 'None') AS Province,
nullif(trim(`Social Media Handle`), 'None') AS Social_Media_Handle

FROM workspace.default.user_profiles_) AS cleaned_profiles

WHERE Gender IS NOT NULL AND Race IS NOT NULL
GROUP BY Race, Gender
ORDER BY UserCount DESC;

---------------------------------------------------------------------------------

---Quantifying Incomplete Profile (Supporting the Profile Completion Initiative)

SELECT 
    COUNT(*) as TotalUsers,
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) as IncompleteProfiles,
    ROUND((SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) as IncompletePercentage

FROM (SELECT UserID,
nullif(trim(Name), 'None') AS Name,
nullif(trim(Surname), 'None') AS Surname,
CASE WHEN Age = 0 THEN NULL ELSE Age END AS Age,
nullif(trim(Gender), 'None') AS Gender,
nullif(trim(Race), 'None') AS Race,
nullif(trim(Province), 'None') AS Province,
nullif(trim(`Social Media Handle`), 'None') AS Social_Media_Handle

FROM workspace.default.user_profiles_) AS cleaned_profiles;

---------------------------------------------------------------------------------

--Social Media Reach

SELECT 
    COUNT(*) as TotalUsers,
    SUM(CASE WHEN Social_Media_Handle IS NOT NULL THEN 1 ELSE 0 END) as UsersWithSocialMedia,
    ROUND((SUM(CASE WHEN Social_Media_Handle IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) as Social_Media_Rate

FROM (SELECT UserID,
nullif(trim(Name), 'None') AS Name,
nullif(trim(Surname), 'None') AS Surname,
CASE WHEN Age = 0 THEN NULL ELSE Age END AS Age,
nullif(trim(Gender), 'None') AS Gender,
nullif(trim(Race), 'None') AS Race,
nullif(trim(Province), 'None') AS Province,
nullif(trim(`Social Media Handle`), 'None') AS Social_Media_Handle

FROM workspace.default.user_profiles_) AS cleaned_profiles;

--------------------------------------------------------------------------------------

----Identifacation of Outlier Data (Profile needing verification)

SELECT UserID, Name, Age, Province
FROM (SELECT UserID,
nullif(trim(Name), 'None') AS Name,
nullif(trim(Surname), 'None') AS Surname,
CASE WHEN Age = 0 THEN NULL ELSE Age END AS Age,
nullif(trim(Gender), 'None') AS Gender,
nullif(trim(Race), 'None') AS Race,
nullif(trim(Province), 'None') AS Province,
nullif(trim(`Social Media Handle`), 'None') AS Social_Media_Handle
FROM workspace.default.user_profiles_
WHERE Age > 100
ORDER BY Age DESC) AS outlier_profiles;

--------------------------------------------------------------------------------

---Cross-Sectional Analysis: Age vs Location
SELECT
  CASE 
        WHEN Age >= 56 THEN 'Boomers (56+)'
        WHEN Age BETWEEN 41 AND 55 THEN 'Gen X (41-55)'
        WHEN Age BETWEEN 25 AND 40 THEN 'Millennials (25-40)'
        WHEN Age < 25 THEN 'Gen Z (under 25)'
        ELSE 'Unknown'
END AS Age_Groups, Province, COUNT(*) AS Subscriber_Count

FROM workspace.default.user_profiles_
WHERE Age IS NOT NULL AND Age > 0
GROUP BY Age_Groups, Province
ORDER BY Age_Groups, Subscriber_Count DESC;

------------------------------------------------------------------------------------
