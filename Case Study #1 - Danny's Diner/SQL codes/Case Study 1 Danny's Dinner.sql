--------------------------------
--CASE STUDY #1: DANNY'S DINER--
--------------------------------

--Author: Emma Nguyen
--Date: 10/01/2023

CREATE SCHEMA dannys_diner;


CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
SELECT * FROM dbo.sales;

-- 1. What is the total amount each customer spent at the restaurant?
SELECT s.customer_id, SUM(price) AS total_sales
FROM sales AS s
JOIN menu AS m
  ON s.product_id = m.product_id
GROUP BY customer_id;
-- 2. How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT(order_date)) AS visit_day
FROM sales
GROUP BY customer_id;
-- 3. What was the first item from the menu purchased by each customer?
WITH ordered_sale_cte AS
(
  SELECT customer_id, order_date, product_name,
  DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank
  FROM sales as s
  JOIN menu as m 
    ON s.product_id=m.product_id
)
SELECT customer_id, product_name
FROM ordered_sale_cte 
WHERE rank=1
GROUP BY customer_id, product_name;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT TOP 1 m.product_name, COUNT(s.product_id) AS fre_product
FROM sales AS s
JOIN menu AS m
 ON s.product_id=m.product_id
GROUP BY m.product_name
ORDER BY fre_product DESC

-- 5. Which item was the most popular for each customer?
WITH purchased_item_cte AS
(
  SELECT s.customer_ID ,
       m.product_name, 
       COUNT(s.product_id) as Count,
       DENSE_RANK()  OVER (PARTITION BY s.customer_id order by COUNT(s.product_id) DESC ) as rank
  FROM menu AS m
  JOIN sales AS s
  ON m.product_id = s.product_id
  GROUP BY s.customer_id,s.product_id,m.product_name
)
SELECT customer_id,product_name,Count
FROM purchased_item_cte
WHERE rank = 1

-- 6. Which item was purchased first by the customer after they became a member?
WITH after_member_cte AS
(
  SELECT s.customer_id, me.join_date, s.order_date, m.product_name,
  DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank
  FROM sales s
  JOIN menu m
   ON s.product_id = m.product_id
  JOIN members me
   ON s.customer_id = me.customer_id
   WHERE s.order_date >= me.join_date
)
SELECT customer_id, product_name 
FROM after_member_cte
WHERE rank=1;

-- 7. Which item was purchased just before the customer became a member?
WITH before_member_cte AS
(
  SELECT s.customer_id, me.join_date, s.order_date, m.product_name,
  DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank
  FROM sales s
  JOIN menu m
   ON s.product_id = m.product_id
  JOIN members me
   ON s.customer_id = me.customer_id
   WHERE s.order_date < me.join_date
)
SELECT customer_id, product_name 
FROM before_member_cte
WHERE rank=1;

-- 8. What is the total items and amount spent for each member before they became a member?
  SELECT s.customer_id, COUNT(s.product_id) AS quatity, SUM(m.price) AS total_price
  FROM sales s
  JOIN menu m
   ON s.product_id = m.product_id
  JOIN members me
   ON s.customer_id = me.customer_id
   WHERE s.order_date < me.join_date
   GROUP BY s.customer_id;


-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
WITH price_points_cte AS
(
   SELECT *, 
      CASE
         WHEN product_id = 1 THEN price * 20
         ELSE price * 10
      END AS points
   FROM menu
)

SELECT s.customer_id, SUM(p.points) AS total_points
FROM price_points_cte AS p
JOIN sales AS s
   ON p.product_id = s.product_id
GROUP BY s.customer_id
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
--not just sushi - how many points do customer A and B have at the end of January?
WITH dates AS
(
	SELECT *, DATEADD(DAY, 6, join_date) AS valid_date,
		EOMONTH('2021-01-31') AS last_date FROM members
)
SELECT s.customer_id, SUM
	(CASE WHEN m.product_id=1 THEN m.price*20
		  WHEN s.order_date BETWEEN d.join_date AND d.valid_date THEN m.price*20
		  ELSE m.price*10 END)
		  AS points
FROM dates d
JOIN sales s
ON d.customer_id = s.customer_id
JOIN menu m
ON s.product_id = m.product_id
WHERE s.order_date < d.last_date
GROUP BY s.customer_id;
-- Bonus: Join All The Things - Recreate the table with: customer_id, order_date, product_name, price, member (Y/N)

SELECT s.customer_id, s.order_date, m.product_name, m.price,
	CASE WHEN s.order_date >= me.join_date THEN 'Y'
		WHEN s.order_date < me.join_date THEN 'N'
		ELSE 'N'
		END AS member
FROM sales s
LEFT JOIN menu m
ON s.product_id = m.product_id
LEFT JOIN members me
ON s.customer_id = me.customer_id;

-- Bonus: Rank All The Things - Danny also requires further information about the ranking of customer products, 
--but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records 
--when customers are not yet part of the loyalty program.
WITH summary_cte AS 
(
SELECT s.customer_id, s.order_date, m.product_name, m.price,
	CASE WHEN s.order_date >= me.join_date THEN 'Y'
		WHEN s.order_date < me.join_date THEN 'N'
		ELSE 'N'
		END AS member
FROM sales s
LEFT JOIN menu m
ON s.product_id = m.product_id
LEFT JOIN members me
ON s.customer_id = me.customer_id
)

SELECT *, CASE
   WHEN member = 'N' then NULL
   ELSE
      RANK () OVER(PARTITION BY customer_id, member
      ORDER BY order_date) END AS ranking
FROM summary_cte;



