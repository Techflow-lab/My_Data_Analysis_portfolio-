#                                       STRING FUNCTION
SELECT city, city_id, 'foreign' AS label
FROM city
WHERE country_id <> 6
UNION 
SELECT city, city_id, 'local' AS label 
FROM city
WHERE country_id = 6
ORDER BY label DESC;

SELECT city, LENGTH(city)
FROM city
ORDER BY 2;

DESCRIBE city;

SELECT city, 
LENGTH(city), 
LEFT(city, 3), 
RIGHT(city, 3),
SUBSTRING(city, 2, 3) AS Truncation
FROM city
ORDER BY 2;

SELECT first_name, last_name, LOCATE('S',first_name)
FROM actor
ORDER BY 3;

SELECT customer_id, first_name, last_name, active,
CASE 
	WHEN active = 1 THEN 'it is active'
    WHEN active = 0 THEN 'it is not active'
END
FROM customer;

SELECT first_name, REPLACE(first_name, 'A', '__')
FROM customer;

SELECT first_name, last_name, LOCATE('A', first_name)
FROM customer;

SELECT first_name, last_name, CONCAT(first_name, last_name)
FROM customer;

#                                       DATE AND TIME FUNCTION
SELECT NOW(), CURDATE(), CURTIME();

SELECT YEAR(NOW()),
       MONTH(NOW()),
       DAY(NOW());

SELECT create_date,
    last_update, 
    DAYNAME(last_update), 
    MONTHNAME(last_update), 
    DATE_FORMAT(last_update, '%m-%d-%Y')
FROM customer;

#                                       CASE STATEMENT 
SELECT staff_id, 
CASE
    WHEN staff_id = 1 THEN amount*100
    WHEN staff_id = 2 THEN amount*10
END AS payment_change
FROM payment;

#                                       CAST AND CONVERT FUNCTION (DATATYPE CONVERTION)
SELECT CONVERT(last_update, TIME)
FROM payment;

#                                       GROUP BY
SELECT staff_id, AVG(amount)
FROM payment 
GROUP BY staff_id WITH ROLLUP

# JOIN
#1. INNER JOIN
#2. LEFT/RIGHT JOIN
#3. FULL JOIN(BUT NOT IN MySQL)
#4. NATURAL JOIN(NOT USED ACTUALLY)
#5. CROSS JOIN(TOO BIG VOLUME TO EXCUTE)

# SUBQUERY:
#不同数据集的相互作用，一定记住 WHERE 在 FROM 和 SELECT 前

#                                       WINDOWS FUNCTION(强制逐行显示结果(复合型数据集操作但是不原地写该数据集))
-- ROW_NUMBER()	    每行唯一序号，无并列	   排名
-- RANK()	            并列时相同名次，后续跳号	排名
-- DENSE_RANK()	    并列时相同名次，后续不跳号	排名
-- NTILE(n)	        将结果集分成 n 个桶	       排名
-- PERCENT_RANK()	    百分比排名 (0~1)	      排名
-- CUME_DIST()	        累积分布比例	          排名
-- LAG(col, n)	        取前 n 行的值	          偏移
-- LEAD(col, n)	    取后 n 行的值	          偏移
-- FIRST_VALUE(col)	窗口内第一行的值	       偏移
-- LAST_VALUE(col)	    窗口内最后一行的值	       偏移
-- NTH_VALUE(col, n)	窗口内第 n 行的值	       偏移
-- SUM / AVG / COUNT	累积或窗口内聚合	       聚合
-- MIN / MAX	        窗口内最小/最大值	       聚合
-- SELECT staff_id, lm - amount AS difference,
-- CASE 
--     WHEN lm - amount THEN 'notify'
--     ELSE 'stay the same'
-- END
-- FROM (
--     SELECT staff_id, amount, LEAD(amount) OVER (PARTITION BY staff_id) AS lm
--     FROM payment
--     ORDER BY staff_id) AS table1

#                                       REGULAR EXPRESSION
SELECT first_name, REGEXP_REPLACE(first_name, 'a', 'b')
FROM customer;

SELECT first_name, REGEXP_LIKE(first_name, 'a')
FROM customer;

SELECT first_name, REGEXP_INSTR(first_name, 'a')
FROM customer;

REGEXP_SUBSTR(col1, '^(\\d{2}){3}$'),


SELECT *
FROM customer
WHERE first_name REGEXP '[a-z]';

SELECT *
FROM customer
WHERE first_name REGEXP '[0-9]';

SELECT *
FROM customer
WHERE first_name REGEXP 'jhfykrjjmyh';
WHERE first_name REGEXP '6.' -- 字符串里寻找6和一个任意字符的组合
WHERE first_name REGEXP 'k...n' -- k 加上三个任意位加 n
WHERE first_name REGEXP '^k' -- k 开头的字符串
WHERE first_name REGEXP '$n' -- end with 'n'
WHERE first_name REGEXP 'obi.*' -- obi with any character with 0 or unlimited occurences 
WHERE first_name REGEXP 'obi.+' -- at least once or more occurences
WHERE first_name REGEXP 'obi.?' -- 0 or 1 time occurence
WHERE first_name REGEXP 'kev|for' -- OR logic sign 
ALTER TABLE customer_sweepstakes
RENAME COLUMN 锘縮weepstake_id TO sweepstake_id;

#                                       DATA CLEANING 
    #REMOVE DUBLICATES

DELETE FROM customer_sweepstakes
WHERE sweepstake_id IN ( 
    SELECT sweepstake_id
    FROM (
        SELECT sweepstake_id, 
        ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY customer_id) AS row_num
        FROM customer_sweepstakes) AS good_table
    WHERE row_num > 1
);

SELECT customer_id, COUNT(*)
FROM customer_sweepstakes
GROUP BY customer_id;

    #CLEAN PHONE NUMBER
SELECT phone, REGEXP_REPLACE(phone, '[^0-9]', '')
FROM customer_sweepstakes;
    #REMOVE ALL non-numeric string
UPDATE customer_sweepstakes
SET phone = REGEXP_REPLACE(phone, '[^0-9]', '');

SELECT phone FROM customer_sweepstakes;

    # TRUNCATE the pure number then concatenate everthing WITH dash
SELECT phone, CONCAT(SUBSTRING(phone,1,3), '-', SUBSTRING(phone,4,3), '-', SUBSTRING(phone,7,4))
FROM customer_sweepstakes;

UPDATE customer_sweepstakes
SET phone = CONCAT(SUBSTRING(phone,1,3), '-', SUBSTRING(phone,4,3), '-', SUBSTRING(phone,7,4))

SELECT phone FROM customer_sweepstakes;

    # STR _TO _DATE AND update birth_day
SELECT birth_date, 
IF(STR_TO_DATE(birth_date, '%m/%d/%Y') IS NOT NULL, 
STR_TO_DATE(birth_date, '%m/%d/%Y'), 
STR_TO_DATE(birth_date, '%Y/%d/%m'))
FROM customer_sweepstakes;

UPDATE customer_sweepstakes
SET birth_date = 
    CASE
        WHEN birth_date REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
            THEN DATE_FORMAT(STR_TO_DATE(birth_date, '%m/%d/%Y'), '%Y-%m-%d')
        WHEN birth_date REGEXP '^[0-9]{4}/[0-9]{1,2}/[0-9]{2}$'
            THEN DATE_FORMAT(STR_TO_DATE(birth_date, '%Y/%d/%m'), '%Y-%m-%d')
        ELSE NULL
    END;


SELECT *
FROM customer_sweepstakes

    # TEXT CHANGE TO SHORT SIMPLIFICATION
UPDATE customer_sweepstakes
SET `Are you over 18?` = 
CASE
    WHEN `Are you over 18?` = 'YES' THEN 'Y'
    WHEN `Are you over 18?` = 'NO' THEN 'N'
    ELSE `Are you over 18?`
END;

SELECT `Are you over 18?`
FROM customer_sweepstakes;

    # BREAK OUT STRING IN THE COLUMN
SELECT address, 
    SUBSTRING_INDEX(address, ',', 1) AS street, 
    SUBSTRING_INDEX(SUBSTRING_INDEX(address, ',', 2), ',', -1) AS city, 
    SUBSTRING_INDEX(address, ',', -1) AS state
FROM customer_sweepstakes;

ALTER TABLE customer_sweepstakes
ADD COLUMN street VARCHAR(50) AFTER address,
ADD COLUMN city VARCHAR(50) AFTER street,
ADD COLUMN state VARCHAR(50) AFTER city;

UPDATE customer_sweepstakes 
SET street = SUBSTRING_INDEX(address, ',', 1),
    city = SUBSTRING_INDEX(SUBSTRING_INDEX(address, ',', 2), ',', -1),
    `state` = SUBSTRING_INDEX(address, ',', -1);

UPDATE customer_sweepstakes
SET `state` = UPPER(state);

UPDATE customer_sweepstakes
SET city = TRIM(city),
    state = TRIM(state);


SELECT * 
FROM customer_sweepstakes;

#                                       Null and incorrect values
UPDATE customer_sweepstakes
SET phone = NULL
WHERE phone = '--';

SELECT *
FROM customer_sweepstakes;

SELECT AVG(income), COUNT(income)
FROM customer_sweepstakes
WHERE income IS NOT NULL;

SELECT AVG(income)
FROM customer_sweepstakes;

SELECT birth_date, `Are you over 18?`
FROM customer_sweepstakes;

UPDATE customer_sweepstakes
SET `Are you over 18?` = 'N'
WHERE (YEAR(NOW()) - birth_date) < 18;





