-- 								Automated Data Cleaning Project 

-- Check out the table
SELECT *
FROM ushouseholdincome;

DELIMITER $$
DROP PROCEDURE IF EXISTS Copy_and_clean_data;
CREATE PROCEDURE Copy_and_clean_data()
BEGIN

CREATE TABLE IF NOT EXISTS`ushouseholdincome_cleaned` (
  `row_id` int DEFAULT NULL,
  `id` int DEFAULT NULL,
  `State_Code` int DEFAULT NULL,
  `State_Name` text,
  `State_ab` text,
  `County` text,
  `City` text,
  `Place` text,
  `Type` text,
  `Primary` text,
  `Zip_Code` int DEFAULT NULL,
  `Area_Code` int DEFAULT NULL,
  `ALand` int DEFAULT NULL,
  `AWater` int DEFAULT NULL,
  `Lat` double DEFAULT NULL,
  `Lon` double DEFAULT NULL,
  `Timestamp` TIMESTAMP DEFAULT NULL
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--  Insert data
INSERT INTO ushouseholdincome_cleaned
SELECT *, CURRENT_TIMESTAMP
FROM ushouseholdincome;

-- Clean data 
	# REMOVE ALL DUPLICATES
	DELETE FROM ushouseholdincome_cleaned
	WHERE row_id in (
		(SELECT row_id
		FROM
			(SELECT row_id,
				ROW_NUMBER() OVER(PARTITION BY row_id ORDER by row_id) AS row_num
			FROM ushouseholdincome_cleaned) AS duplicates
			WHERE row_num > 1)
	);

	# CHECK THE RESULT 
	SELECT DISTINCT(count) AS result
	FROM (
	SELECT row_id, COUNT(*) AS count
	FROM ushouseholdincome_cleaned
	GROUP BY row_id) AS table_CHECK
	;

	SELECT DISTINCT place
	FROM ushouseholdincome_cleaned;
	 
	UPDATE ushouseholdincome
	SET state_name = 'Georgia'
	WHERE state_name = 'georia';

	UPDATE ushouseholdincome_cleaned
	SET state_name = 'Alabama'
	WHERE state_name = 'alabama';

	SELECT *
	FROM ushouseholdincome_cleaned
	WHERE place IS NULL;

	UPDATE ushouseholdincome_cleaned
	SET place = 'Autaugaville'
	WHERE place IS NULL;

	SELECT Type, COUNT(Type)
	FROM ushouseholdincome_cleaned
	GROUP BY Type
	ORDER BY 1;

	UPDATE ushouseholdincome_cleaned
	SET Type = 'Borough'
	WHERE Type = 'Boroughs';

END $$

DELIMITER ;

CALL Copy_and_clean_data();

SELECT row_id, id
FROM
(SELECT row_id, id,
ROW_NUMBER() OVER(PARTITION BY row_id ORDER by row_id) AS row_num
FROM ushouseholdincome) AS duplicates
WHERE row_num > 1;


SELECT COUNT(row_id)
FROM ushouseholdincome;



-- CREATE EVENT
CREATE EVENT run_data_cleaning 
ON SCHEDULE EVERY 2 minute
DO CALL Copy_and_clean_data();


-- CREATE TRIGGER
DELIMITER $$
CREATE TRIGGER Transfer_clean_data
AFTER INSERT ON ushouseholdincome
for each row
BEGIN
	CALL Copy_and_clean_data();
END $$
DELIMITER ;