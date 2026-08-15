-- 								Automated Data Cleaning Project 

-- Check out the table
SELECT *
FROM ushouseholdincome;

DELIMITER $$
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
  KEY `idx_area_code1` (`State_Name`(3),`ALand`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--  CLean data


END $$





