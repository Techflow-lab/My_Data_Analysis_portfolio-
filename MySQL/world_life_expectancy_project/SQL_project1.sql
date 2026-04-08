USE world_life_expectancy;
SELECT country, year, CONCAT(country, year), COUNT(CONCAT(country, year))
FROM world_life_expectancy
GROUP BY country, year, CONCAT(country, year)
HAVING COUNT(CONCAT(country, year)) > 1;

#          REMOVE THE DUPLICATES
DELETE FROM	world_life_expectancy
WHERE ROW_ID IN (	
        SELECT ROW_ID
	FROM(
	SELECT 
		ROW_ID,
		CONCAT(country, year),
		ROW_NUMBER() OVER( PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) AS row_num
	FROM world_life_expectancy
	) AS table_check
	WHERE row_num > 1
);

#          FILL THE NULL OR BLANKS FOR status and Life expectancy

	#status part
UPDATE world_life_expectancy t1
	JOIN world_life_expectancy t2
    ON t1.country = t2.country
SET t1.status =  'Developed'
WHERE t1.status = ''
AND t2.status = 'Developed';

UPDATE world_life_expectancy t1
	JOIN world_life_expectancy t2
    ON t1.country = t2.country
SET t1.status =  'Developing'
WHERE t1.status = ''
AND t2.status = 'Developing';

		#CHECK status filling result
SELECT DISTINCT(count)
FROM (SELECT Row_ID, COUNT(*) AS count
FROM world_life_expectancy
GROUP BY Row_ID) AS tablegood;	

	#Life expectancy part
UPDATE world_life_expectancy t1
	JOIN world_life_expectancy t2
    ON t1.country = t2.country
    AND t2.year = t1.year + 1
    JOIN world_life_expectancy t3
    ON t1.country = t3.country
    AND t3.year = t1.year - 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2, 1)
WHERE t1.`Life expectancy` = '';

		#CHECK Life expectancy filling result
SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` <> '';

# World life expectancy exploratory data analysis

SELECT country, 
ROUND(AVG(`Life expectancy`), 1) AS life_expectancy, 
ROUND(AVG(GDP), 1) AS GDP
FROM world_life_expectancy
GROUP BY country
Having Life_expectancy > 0
	AND GDP > 0
ORDER BY  life_expectancy ASC;

SELECT
    SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS High_GDP_Count,
    AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` END) AS High_GDP_Life_Expectancy,
    SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS Low_GDP_Count,
    AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` END) AS Low_GDP_Life_Expectancy
FROM world_life_expectancy;

SELECT 
    Status, 
    COUNT(DISTINCT Country) AS country_count,
    ROUND(AVG(`Life expectancy`), 1) AS avg_life_expectancy
FROM world_life_expectancy
GROUP BY Status;

SELECT country, 
ROUND(AVG(`Life expectancy`), 1) AS life_expectancy_average, 
ROUND(AVG(BMI), 1) AS BMI_average
FROM world_life_expectancy
GROUP BY country
Having Life_expectancy_average > 0
	AND BMI_average > 0
ORDER BY  life_expectancy_average ASC;
