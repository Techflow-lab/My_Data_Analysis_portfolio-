#                        Project 2
SELECT 

SELECT *
FROM ushouseholdincome;

# REMOVE ALL DUPLICATES
DELETE FROM ushouseholdincome
WHERE row_id in (
	(SELECT *
	FROM
		(SELECT row_id,
			ROW_NUMBER() OVER(PARTITION BY row_id ORDER by row_id) AS row_num
		FROM ushouseholdincome) AS duplicates
		WHERE row_num > 1)
);

# CHECK THE RESULT 
SELECT DISTINCT(count) AS result
FROM (
SELECT row_id, COUNT(*) AS count
FROM ushouseholdincome
GROUP BY row_id) AS table_CHECK
;

SELECT DISTINCT place
FROM ushouseholdincome;
 
UPDATE ushouseholdincome
SET state_name = 'Georgia'
WHERE state_name = 'georia';

UPDATE ushouseholdincome
SET state_name = 'Alabama'
WHERE state_name = 'alabama';

SELECT *
FROM ushouseholdincome
WHERE place IS NULL;

UPDATE ushouseholdincome
SET place = 'Autaugaville'
WHERE place IS NULL;

SELECT Type, COUNT(Type)
FROM ushouseholdincome
GROUP BY Type
ORDER BY 1;

UPDATE ushouseholdincome
SET Type = 'Borough'
WHERE Type = 'Boroughs';

SELECT State_Name,
       SUM(ALand) AS Total_Land,
       SUM(AWater) AS Total_Water
FROM ushouseholdincome
GROUP BY State_Name
ORDER BY Total_Land DESC;

SELECT 
    u.State_Name AS state,
    ROUND(AVG(us.Mean), 1) AS avg_mean_income,
    ROUND(AVG(us.Median), 1) AS avg_median_income
FROM ushouseholdincome u
JOIN ushouseholdincome_statistics us
    ON u.id = us.id
WHERE us.Mean <> 0
GROUP BY u.State_Name
ORDER BY avg_median_income DESC
LIMIT 10;

SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM ushouseholdincome u
INNER JOIN ushouseholdincome_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
LIMIT 20;

SELECT u.State_Name,
       u.City,
       ROUND(AVG(us.Mean), 1) AS Avg_Mean_Income
FROM ushouseholdincome AS u
JOIN ushouseholdincome_statistics AS us
      ON u.id = us.id
GROUP BY u.State_Name, u.City
ORDER BY Avg_Mean_Income DESC;


 