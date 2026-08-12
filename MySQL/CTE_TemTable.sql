-- 										Advanced SQL Chapter
-- CTE IS A WAY WE CAN USE TO IMPROVE READABLITY 
SELECT product_id, SUM(order_total), SUM(tip), COUNT(tip)
FROM bakery.customer_orders
WHERE tip != 0
GROUP BY product_id;

WITH CET_examples AS 
(
SELECT product_id, SUM(order_total), SUM(tip), COUNT(tip)
FROM bakery.customer_orders
WHERE tip != 0
GROUP BY product_id
)

SELECT *
FROM CET_examples
WHERE `SUM(tip)` > 3;    

SELECT product_id, ROUND(`SUM(tip)` / `COUNT(tip)`, 2)
FROM (
    SELECT product_id, SUM(order_total), SUM(tip), COUNT(tip)
    FROM bakery.customer_orders
    WHERE tip != 0
    GROUP BY product_id
) Subquery_Example
WHERE `SUM(tip)` > 3;

-- Recursive CTE
WITH RECURSIVE company_hierarchy AS 
(
SELECT employee_id, first_name, last_name, boss_id, 0 AS levels
FROM employees
WHERE boss_id IS NULL 

UNION ALL

SELECT e.employee_id, e.first_name, e.last_name, e.boss_id, levels + 1
FROM employees e, company_hierarchy ch
WHERE e.boss_id = ch.employee_id

)

SELECT *
FROM company_hierarchy;

-- Temporary table
CREATE TEMPORARY TABLE tem_table1
(
first_name VARCHAR(50),
last_name VARCHAR(50),
favoraite_movie TEXT
) ;
SELECT *
FROM tem_table1

-- Stored Procedure 
DROP PROCEDURE IF EXISTS order_total;
DELIMITER $$
CREATE PROCEDURE order_total(p_order_total INT, p_order_date DATE) 
BEGIN
	SELECT order_id, order_date, order_total
    FROM customer_orders
	WHERE order_total = IFNULL(p_order_total, 26.24)
    AND order_date = p_order_date;
END $$

DELIMITER ;

CALL order_total(NULL, '2020-01-30');

-- OUTPUT PARAMETER 
DROP PROCEDURE IF EXISTS PERCENTAGE;
DELIMITER $$
CREATE PROCEDURE PERCENTAGE(p_product_id int, OUT sum_this_order DECIMAL(9,2))
BEGIN 
DECLARE total_orders DECIMAL(9,2);
DECLARE percentage_order DECIMAL(9,2);
	SELECT SUM(order_total)
    INTO sum_this_order
    FROM customer_orders
    WHERE product_id = p_product_id;
    
    SELECT SUM(order_total)
    INTO total_orders
    FROM customer_orders; 
    
    SET percentage_order = ROUND(sum_this_order/total_orders*100,2);
    
    SELECT sum_this_order;
    SELECT total_orders;
    SELECT percentage_order;
END $$

DELIMITER ;

	CALL PERCENTAGE(1001, @sum_this_order);
	SELECT @sum_this_order;
    SELECT @total_orders;
    SELECT @percentage_order;
-- SET @sum_this_order = 0;
-- CALL PERCENTAGE(1001, @sum_this_order);
-- SELECT @sum_this_order;

-- SELECT ROUND(@sum_this_order/SUM(order_total)*100,2) AS PERCENTAGE
-- FROM customer_orders;

-- Summary: 1.local variables: declare and then assgin the value
--          2.session variables: directly use @ prefix to set a value to it






    