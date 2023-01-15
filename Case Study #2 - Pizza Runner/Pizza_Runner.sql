--------------------------------
--CASE STUDY #3: PIZZA'S RUNNER--
--------------------------------

--Author: Emma Nguyen
--Date: 15/01/2023
--Tool used: MS SQL Server

CREATE DATABASE pizza_runner;
USE pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" DATETIME
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  SELECT * FROM customer_orders;
  SELECT * FROM runner_orders;

  -- Cleaning the customer_orders and runner_orders
-- Deal with null values in customer_orders

DROP TABLE IF EXISTS #customer_orders;
SELECT order_id, 
        customer_id,
        pizza_id, 
        CASE WHEN exclusions = '' OR exclusions like 'null' THEN NULL
            ELSE exclusions END AS exclusions,
        CASE WHEN extras = '' OR extras like 'null' THEN NULL
            ELSE extras END AS extras, 
        order_time
INTO #customer_orders -- create TEMP TABLE
FROM customer_orders;

-- Deal with null values and unwanted values in runner_orders

DROP TABLE IF EXISTS #runner_orders
SELECT  order_id, 
        runner_id,
        CASE 
          WHEN pickup_time LIKE 'null' THEN NULL
          ELSE pickup_time 
          END AS pickup_time,
        CASE 
          WHEN distance LIKE 'null' THEN NULL
          WHEN distance LIKE '%km' THEN TRIM('km' from distance) 
          ELSE distance END AS distance,
        CASE 
          WHEN duration LIKE 'null' THEN NULL 
          WHEN duration LIKE '%mins' THEN TRIM('mins' from duration) 
          WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)        
          WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)       
          ELSE duration END AS duration,
        CASE 
          WHEN cancellation LIKE 'null' THEN NULL
          WHEN cancellation = '' THEN NULL
          ELSE cancellation END AS cancellation
INTO #runner_orders
FROM runner_orders;
-- Normalize the Pizza_recipes table

DROP TABLE IF EXISTS #pizza_recipes;
SELECT pizza_id, 
        TRIM(topping_id.value) as topping_id
INTO #pizza_recipes
FROM pizza_recipes p
CROSS APPLY string_split(p.toppings, ',') as topping_id

-- Change the data types

ALTER TABLE #runner_orders 
ALTER COLUMN pickup_time DATETIME

ALTER TABLE #runner_orders
ALTER COLUMN distance FLOAT

ALTER TABLE #runner_orders
ALTER COLUMN duration INT;

ALTER TABLE pizza_names
ALTER COLUMN pizza_name VARCHAR(MAX);

ALTER TABLE pizza_recipes
ALTER COLUMN toppings VARCHAR(MAX);

ALTER TABLE pizza_toppings
ALTER COLUMN topping_name VARCHAR(MAX);

-- A. Pizza Metrics
--1.How many pizzas were ordered?
SELECT COUNT(order_id) AS pizza_sale 
FROM #customer_orders;

-- 2 How many unique customer orders were made?
SELECT COUNT(DISTINCT(order_id)) AS unique_pizza_order 
FROM #customer_orders;

--3 How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) AS successful_pizza_order
FROM #runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id

--4. How many of each type of pizza was delivered?
SELECT pizza_id, COUNT(pizza_id) AS number_delivered_pizza
FROM #customer_orders AS c
JOIN #runner_orders AS r
	ON c.order_id = r.order_id
WHERE cancellation IS NULL
GROUP BY pizza_id

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT c.customer_id, p.pizza_name, COUNT(c.pizza_id) AS pizza_sold 
FROM #customer_orders AS c
JOIN pizza_names AS p
ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id, p.pizza_name;

--6. What was the maximum number of pizzas delivered in a single order?
SELECT TOP 1 c.order_id, 
       COUNT(c.order_id) as number_order
FROM #customer_orders AS c 
RIGHT JOIN #runner_orders AS r 
	ON c.order_id = r.order_id
WHERE r.cancellation is NULL
GROUP BY c.order_id
ORDER BY number_order DESC;

--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

WITH changes AS
(
	SELECT *, 
	CASE
		WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 'Y'
		WHEN exclusions IS NULL AND extras IS NULL THEN 'N'
		END AS change
	FROM #customer_orders
)
SELECT ch.customer_id, ch.change, COUNT(ch.change) as count
FROM changes AS ch
RIGHT JOIN #runner_orders as r
	ON ch.order_id = r.order_id
WHERE r.cancellation is NULL
GROUP BY ch.customer_id, ch.change
ORDER BY ch.customer_id

-- 8. How many pizzas were delivered that had both exclusions and extras?
SELECT COUNT(c.order_id) as both_exclusions_extras
FROM #customer_orders c 
RIGHT JOIN #runner_orders r 
	ON c.order_id = r.order_id
WHERE exclusions is NOT NULL and extras is NOT NULL and r.cancellation is NULL

--9. What was the total volume of pizzas ordered for each hour of the day?

SELECT DATEPART(HOUR, order_time) as hour, 
       COUNT (order_id) as pizza_count
FROM #customer_orders
GROUP BY DATEPART(HOUR, order_time)

--10. What was the volume of orders for each day of the week?

SELECT DATEPART(WEEKDAY,order_time) as weekday, 
        COUNT (order_id) as pizza_count
FROM #customer_orders
GROUP BY DATEPART(WEEKDAY,order_time);
--OR
SELECT DATENAME(WEEKDAY,order_time) as weekday, 
        COUNT (order_id) as pizza_count
FROM #customer_orders
GROUP BY DATENAME(WEEKDAY,order_time);

-- B. Runner and Customer Experience
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SET DATEFIRST 1; --Set Monday is the first day of week
SELECT DATEPART(WEEK,registration_date) AS week,
COUNT(runner_id) AS num_runners
FROM runners
GROUP BY DATEPART(WEEK,registration_date);

--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

WITH avg_runner_time AS
(
	SELECT r.runner_id, c.order_time, r.pickup_time,
			CAST(DATEDIFF(minute,c.order_time, r.pickup_time) AS FLOAT) as time
	FROM #customer_orders c
	JOIN #runner_orders r
	ON c.order_id = r.order_id
	WHERE r.cancellation IS NULL
	GROUP BY r.runner_id, c.order_time, r.pickup_time
)
SELECT runner_id, 
		ROUND(AVG(time), 2) AS avg_pickup_time
FROM avg_runner_time
GROUP BY runner_id;

--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

WITH prepare_time_CTE AS 
(
	SELECT  c.order_id,
            COUNT(c.order_id) as pizza_order,
            order_time, pickup_time, 
            CAST(DATEDIFF( minute,order_time,pickup_time) AS FLOAT) as time
	FROM #customer_orders c 
	INNER JOIN #runner_orders r 
	ON C.order_id = R.order_id
	WHERE r.cancellation IS NULL 
	GROUP BY  c.order_id,order_time, pickup_time
)

SELECT pizza_order,
        ROUND(AVG(time),2) AS avg_time_per_order, 
        ROUND(AVG(time)/ pizza_order,2) AS avg_time_per_pizza
FROM prepare_time_CTE
GROUP BY pizza_order

--4. What was the average distance travelled for each customer?
SELECT c.customer_id, ROUND(AVG(r.distance), 2) AS avg_distance
FROM #customer_orders as c
JOIN #runner_orders as r
ON c.order_id = r.order_id
WHERE r.cancellation is NULL
GROUP BY c.customer_id;

--5. What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(duration)- MIN(duration) AS biggest_difference FROM #runner_orders
WHERE cancellation is NULL;

--6. What was the average speed for each runner for each delivery?
SELECT runner_id, 
        order_id, 
        ROUND(AVG(distance/duration*60),2) as avg_time
FROM #runner_orders
WHERE cancellation is NULL 
GROUP BY runner_id,order_id
ORDER BY runner_id;

--7. What is the successful delivery percentage for each runner?
WITH delivery_rate_CTE AS 
(
	SELECT runner_id, order_id,
          CASE WHEN cancellation is NULL THEN 1
          ELSE 0 END AS sucess_delivery
    FROM #runner_orders
)
SELECT runner_id, ROUND( 100*SUM(sucess_delivery)/COUNT(order_id),2) AS success_rate
FROM delivery_rate_CTE
GROUP BY runner_id

--C. Ingredient Optimisation

--1. What are the standard ingredients for each pizza?
WITH standand_ingre_CTE AS
(
	SELECT pizza_id, topping_name
	FROM #pizza_recipes r
	INNER JOIN pizza_toppings t
	ON r.topping_id = t.topping_id
	GROUP BY pizza_id, topping_name
)
SELECT pizza_id,
	   STRING_AGG(topping_name,',') as standard_ingredients
FROM standand_ingre_CTE
GROUP BY pizza_id;

-- D. Pricing and Ratings
-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
-- how much money has Pizza Runner made so far if there are no delivery fees?
WITH revenue_CTE AS 
(
	SELECT pizza_id, pizza_name,
    CASE WHEN pizza_name = 'Meatlovers' THEN 12
    ELSE 10 END AS pizza_cost
    FROM pizza_names) 

SELECT SUM(pizza_cost) as total_revenue
FROM #customer_orders c 
JOIN #runner_orders r 
	ON c.order_id = r.order_id
JOIN revenue_CTE r1 
	ON c.pizza_id = r1.pizza_id
WHERE r.cancellation is NULL;

--2. What if there was an additional $1 charge for any pizza extras? (Add cheese is $1 extra)

WITH pizza_cte AS
(
	SELECT (CASE WHEN pizza_id=1 THEN 12
            WHEN pizza_id = 2 THEN 10
            END) AS pizza_cost, 
            c.exclusions,
            c.extras
     FROM #runner_orders r
     JOIN #customer_orders c ON c.order_id = r.order_id
     WHERE r.cancellation IS  NULL
)
SELECT SUM(
		CASE WHEN extras IS NULL THEN pizza_cost
               WHEN DATALENGTH(extras) = 1 THEN pizza_cost + 1
               ELSE pizza_cost + 2
                END ) AS total_revenue
FROM pizza_cte;

-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
--how would you design an additional table for this new dataset - 
--generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
DROP TABLE IF EXISTS ratings
CREATE TABLE ratings 
 (order_id INTEGER,
    rating INTEGER);
INSERT INTO ratings
 (order_id ,rating)
VALUES 
(1,4),
(2,5),
(3,5),
(4,3),
(5,2),
(6,5),
(7,1),
(8,1),
(9,4),
(10,5); 

SELECT * 
from ratings

--4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
--customer_id, order_id, runner_id, rating, order_time, pickup_time, Time between order and pickup, Delivery duration, Average speed, Total number of pizzas
SELECT customer_id , 
       c.order_id, 
        runner_id, 
        rating, 
        order_time, 
        pickup_time, 
        DATEPART( MINUTE,pickup_time - order_time) AS order_pickup_time, 
        duration, 
        ROUND(AVG(distance/duration*60),2) AS avg_speed, 
        COUNT(pizza_id) AS nu_pizza
FROM #customer_orders c
LEFT JOIN #runner_orders r ON c.order_id = r.order_id 
LEFT JOIN ratings r2 ON c.order_id = r2.order_id
WHERE r.cancellation is NULL
GROUP BY customer_id , c.order_id, runner_id, rating, order_time, pickup_time, datepart( minute,pickup_time - order_time) , duration
ORDER BY c.customer_id;

--5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - 
--how much money does Pizza Runner have left over after these deliveries?

WITH pizza_CTE AS 
(
	SELECT c.order_id,
           SUM(CASE WHEN pizza_name = 'Meatlovers' THEN 12
               ELSE 10 END) AS pizza_cost
    FROM pizza_names p
    JOIN #customer_orders c ON p.pizza_id =c.pizza_id
    GROUP BY c.order_id
)

SELECT SUM(pizza_cost) AS total_revenue, 
       SUM(distance) *0.3 as total_cost,
       SUM(pizza_cost) - SUM(distance)*0.3 as profit
FROM #runner_orders r 
JOIN pizza_CTE p
	ON r.order_id =p.order_id
WHERE r.cancellation is NULL;
-- E.Bonus Questions
--If Danny wants to expand his range of pizzas - how would this impact the existing data design? 
--Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?
INSERT INTO pizza_names
(pizza_id, pizza_name)
values 
(3 , 'Supreme')

INSERT INTO pizza_recipes
(pizza_id, toppings)
VALUES
(3, '1,2,3,4,5,6,7,8,9,10,11,12')

SELECT * FROM pizza_names;

SELECT * FROM pizza_recipes;

	

	

