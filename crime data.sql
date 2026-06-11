CREATE DATABASE nyc_crime;
USE nyc_crime;

SELECT COUNT(*)
FROM nyc_crime_cleaned;
SELECT *
FROM nyc_crime_cleaned
LIMIT 10;

#Crimes by borough
SELECT boro_nm, COUNT(*) AS total_crimes
FROM nyc_crime_cleaned
GROUP BY boro_nm
ORDER BY total_crimes DESC;

#Top 10 crime types
SELECT ofns_desc, COUNT(*) AS crime_count
FROM nyc_crime_cleaned
GROUP BY ofns_desc
ORDER BY crime_count DESC
LIMIT 10;

#Crime severity
SELECT law_cat_cd, COUNT(*) AS total_crimes
FROM nyc_crime_cleaned
GROUP BY law_cat_cd
ORDER BY total_crimes DESC;

#Crimes by year
SELECT year, COUNT(*) AS total_crimes
FROM nyc_crime_cleaned
GROUP BY year
ORDER BY year;

#Crimes by month
SELECT month, COUNT(*) AS total_crimes
FROM nyc_crime_cleaned
GROUP BY month
ORDER BY total_crimes DESC;
#Crimes by day
SELECT day_of_week, COUNT(*) AS total_crimes
FROM nyc_crime_cleaned
GROUP BY day_of_week
ORDER BY total_crimes DESC;
#Peak crime hours
SELECT hour, COUNT(*) AS total_crimes
FROM nyc_crime_cleaned
GROUP BY hour
ORDER BY total_crimes DESC;
#Which borough has the highest number of serious crimes?
SELECT boro_nm, COUNT(*) AS felony_count
FROM nyc_crime_cleaned
WHERE law_cat_cd = 'FELONY'
GROUP BY boro_nm
ORDER BY felony_count DESC;
#What percentage of crimes are Felonies, Misdemeanors, and Violations?
SELECT 
    law_cat_cd,
    COUNT(*) AS total_crimes,
    ROUND(COUNT(*) * 100.0 / (SELECT 
                    COUNT(*)
                FROM
                    nyc_crime_cleaned),
            2) AS percentage
FROM
    nyc_crime_cleaned
GROUP BY law_cat_cd;
#Which age groups are most affected by crime?
SELECT vic_age_group,
       COUNT(*) AS victim_count
FROM nyc_crime_cleaned
GROUP BY vic_age_group
ORDER BY victim_count DESC;
#Which gender is most frequently victimized?
SELECT vic_sex,
       COUNT(*) AS victim_count
FROM nyc_crime_cleaned
GROUP BY vic_sex
ORDER BY victim_count DESC;
#Does each borough have different crime patterns?
SELECT boro_nm,
       ofns_desc,
       COUNT(*) AS crime_count
FROM nyc_crime_cleaned
GROUP BY boro_nm, ofns_desc
ORDER BY boro_nm, crime_count DESC;
#Where do crimes occur most often?
SELECT prem_typ_desc,
       COUNT(*) AS crime_count
FROM nyc_crime_cleaned
GROUP BY prem_typ_desc
ORDER BY crime_count DESC
LIMIT 10;
#Borough Severity Index 
SELECT
    boro_nm,
    COUNT(*) AS total_crimes,
    SUM(CASE 
            WHEN law_cat_cd = 'FELONY' THEN 3
            WHEN law_cat_cd = 'MISDEMEANOR' THEN 2
            WHEN law_cat_cd = 'VIOLATION' THEN 1 
        END) AS severity_score,
    ROUND(SUM(CASE 
                  WHEN law_cat_cd = 'FELONY' THEN 3
                  WHEN law_cat_cd = 'MISDEMEANOR' THEN 2
                  WHEN law_cat_cd = 'VIOLATION' THEN 1 
              END) * 1.0 / COUNT(*), 2) AS avg_severity_per_crime,
    ROUND(SUM(CASE WHEN law_cat_cd = 'FELONY' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS felony_pct
FROM nyc_crime_cleaned
GROUP BY boro_nm
ORDER BY avg_severity_per_crime DESC;
#Crime DNA by Time Slot (window function)
SELECT
    ofns_desc,
    CASE 
        WHEN hour BETWEEN 6 AND 11 THEN '1_Morning (6am-12pm)'
        WHEN hour BETWEEN 12 AND 17 THEN '2_Afternoon (12pm-6pm)'
        WHEN hour BETWEEN 18 AND 21 THEN '3_Evening (6pm-10pm)'
        ELSE '4_Late Night (10pm-6am)' 
    END AS time_slot,
    COUNT(*) AS crime_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY ofns_desc), 1) AS pct_of_this_crime_type
FROM nyc_crime_cleaned
WHERE ofns_desc IN ('ROBBERY', 'PETIT LARCENY', 'FELONY ASSAULT', 'DANGEROUS DRUGS', 'BURGLARY')
GROUP BY ofns_desc, time_slot
ORDER BY ofns_desc, time_slot;

#Day-of-Week × Crime Type analysis 

SELECT
    ofns_desc,
    CASE 
        WHEN day_of_week IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS crime_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY ofns_desc), 1) AS pct_of_crime_type
FROM nyc_crime_cleaned
WHERE ofns_desc IN ('ROBBERY', 'PETIT LARCENY', 'FELONY ASSAULT', 'DANGEROUS DRUGS', 'HARRASSMENT 2')
GROUP BY ofns_desc, day_type
HAVING COUNT(*) > 200
ORDER BY ofns_desc, day_type;

#Premise Risk Profile per Crime Type
SELECT
    ofns_desc,
    prem_typ_desc,
    crime_count,
    premise_rank
FROM (
    SELECT
        ofns_desc,
        prem_typ_desc,
        crime_count,
        RANK() OVER (PARTITION BY ofns_desc ORDER BY crime_count DESC) AS premise_rank
    FROM (
        SELECT
            ofns_desc,
            prem_typ_desc,
            COUNT(*) AS crime_count
        FROM nyc_crime_cleaned
        GROUP BY ofns_desc, prem_typ_desc
        HAVING COUNT(*) > 30
    ) inner_query
) outer_query
WHERE premise_rank <= 3
AND ofns_desc IN ('ROBBERY', 'BURGLARY', 'FELONY ASSAULT', 'DANGEROUS DRUGS', 'PETIT LARCENY')
ORDER BY ofns_desc, premise_rank;