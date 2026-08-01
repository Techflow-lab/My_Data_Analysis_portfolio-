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



