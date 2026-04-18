# Bright-TV-Case Study
BrightTV Subscriber Value Management (CVM) Analysis
Project Objective
The primary objective of this analysis is to assist the CVM team in meeting the CEO's goal of growing BrightTV’s subscription base for the current financial year. By analyzing user profile data, we identify demographic trends, geographic clusters, and data integrity issues that influence viewership.
Dataset Overview
The analysis is based on a "User Profiles" dataset containing the following fields:
•	UserID, Name, Surname, Email
•	Gender, Race, Age
•	Province
•	Social Media Handle
•	UserID: Unique identifier for each subscriber.
•	Channel: The specific channel being viewed (e.g., Supersport Live Events, Cartoon Network, Trace TV).
•	RecordDate: The date and time of the viewing session (originally provided in UTC).
•	Duration: The length of the session in HH:MM:SS format.
Data Integrity Challenges
Source data revealed significant records (e.g., User IDs 1497 through 3413) where demographics and names were listed as "None" and the Age was recorded as "0". Some records also contained empty spaces instead of text.
Data Cleaning & Transformation
To ensure accurate reporting, a Temporary View was created in Databricks to:
1.	Trim whitespace and convert string "None" to NULL.
2.	Convert Age 0 to NULL to avoid skewing averages.
3.	Standardize geographic data to identify the top viewership hubs: Gauteng, Western Cape, and KwaZulu-Natal.
-- Cleaning logic used to standardize User Profiles
CREATE OR REPLACE TEMPORARY VIEW cleaned_user_profiles AS
SELECT 
    UserID,
    NULLIF(TRIM(Name), 'None') AS Name,
    CASE WHEN Age = 0 THEN NULL ELSE Age END AS Age,
    NULLIF(NULLIF(TRIM(Province), 'None'), '') AS Province,
    NULLIF(TRIM(`Social Media Handle`), 'None') AS SocialMediaHandle
FROM user_profiles_csv
WHERE Name != 'None' AND Age > 0;
Key Implementation: SQL on Databricks
To process the data, SQL logic was applied to convert UTC timestamps to South African Standard Time (UTC+2) and transform the duration strings into numerical seconds for aggregation.
-- Transformation logic for Databricks
SELECT
    UserID,
    Channel2 AS Channel,
    -- Convert UTC to South African Time
    from_utc_timestamp(to_timestamp(RecordDate2, 'dd/MM/yyyy HH:mm'), 'Africa/Johannesburg') AS RecordDate_SA,
    -- Extract Hour and Day for trend analysis
    hour(from_utc_timestamp(...)) AS HourOfDay,
    -- Duration conversion to seconds
    (cast(split(`Duration 2`, ':') as int) * 3600) +
    (cast(split(`Duration 2`, ':') as int) * 60) +
    cast(split(`Duration 2`, ':') as int) AS Duration_Seconds
FROM viewership_csv;

Key Insights for the Presentation
•	Generational Breakdown: The dataset shows a heavy concentration in the Millennial (25-40) and Gen X (41-55) brackets, with outliers reaching ages 113 and 114.
•	Geographic Concentration: Viewership is strongest in Gauteng, followed by the Western Cape and KwaZulu-Natal.
•	Social Media Reach: A large portion of active users possess social media handles, making them ideal targets for referral-based growth initiatives.
•	Duration Leaders: High-impact sporting events, such as the ICC Cricket World Cup 2011, drive the longest individual viewing sessions, sometimes exceeding 5 to 11 hours.
•	High Frequency "Snacking": Music and lifestyle channels like Trace TV and Channel O have high session counts but generally shorter durations, indicating frequent "tune-in" behavior.
•	Genre Clusters: Viewership is dominated by Live Sports, Kids' Programming (Cartoon Network, Boomerang), and News (CNN).
Factors Influencing Consumption
•	Event-Driven Spikes: Live sports are the primary driver of high-duration viewing.
•	Technical Reliability: The dataset records multiple instances of "Break in transmission," which serves as a negative factor likely causing session abandonment.
•	Demographic Cycles: Viewership patterns follow family routines, with kids' content appearing heavily in morning and afternoon slots.
Growth Recommendations
1.	Profile Completion Campaign: Target the large volume of "None" profiles with incentives to provide demographic data for better ad-targeting.
2.	Generational Programming: Develop content specifically for the Millennial base, who represent the core of current consumption.
3.	Regional Content: Increase localized content for top-performing provinces like Gauteng and KwaZulu-Natal to drive session frequency.
4.	Tiered Sports Packages: Develop "Sports Light" tiers to capture price-sensitive fans who primarily use BrightTV for events like the Cricket World Cup.
5.	Technical Optimization: Prioritize resolving the "Break in transmission" issues identified in the logs to improve retention.
6.	Personalized CVM: Use session data to trigger automated recommendations—for example, targeting Cartoon Network viewers with family-oriented movie premieres.
7.	Content Strategy for Low-Consumption Days
•	Binge-Worthy Marathons: Schedule back-to-back blocks of local favorites like Africa Magic or kykNET to bridge gaps between live sporting events.
•	Interactive Programming: Leverage high-frequency music channels to run interactive, viewer-voted countdowns on traditionally quiet days.

Tools Used
•	Databricks (Spark SQL & PySpark)
•	GitHub (Version Control)
•	Miro
•	Powerpoint
•	Excel
•	Canva
•	Word










