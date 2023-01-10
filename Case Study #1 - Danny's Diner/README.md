## Case Study #1: Danny's Diner 
<img src="https://user-images.githubusercontent.com/81607668/127727503-9d9e7a25-93cb-4f95-8bd0-20b87cb4b459.png" alt="Image" width="500" height="520">

View the [**case study**](https://8weeksqlchallenge.com/case-study-1/) and my [**solution**](https://github.com/YogeshOlla/8-Weeks-SQL-Challenge/blob/main/Case%20Study%201%20-%20Danny's%20Diner/SQL%20Code/Case%20Study%201%20-%20Danny's%20Diner.sql) 

### Introduction
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

### Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:

* sales
* menu
* members
You can inspect the entity relationship diagram and example data below.

![image](https://user-images.githubusercontent.com/81607668/127271130-dca9aedd-4ca9-4ed8-b6ec-1e1920dca4a8.png)

**Table 1: sales** 

The sales table captures all *customer_id* level purchases with an corresponding *order_date* and *product_id* information for when and what menu items were ordered.

**Table 2: menu**

The menu table maps the *product_id* to the actual *product_name* and *price* of each menu item.

**Table 3: members**

The final members table captures the *join_date* when a *customer_id* joined the beta version of the Danny’s Diner loyalty program.


### Case Study Questions:

1.  What is the total amount each customer spent at the restaurant?
2.  How many days has each customer visited the restaurant?
3.  What was the first item from the menu purchased by each customer?
4.  What is the most purchased item on the menu and how many times was it purchased by all customers?
5.  Which item was the most popular for each customer?
6.  Which item was purchased first by the customer after they became a member?
7.  Which item was purchased just before the customer became a member?
8.  What is the total items and amount spent for each member before they became a member?
9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
    not just sushi - how many points do customer A and B have at the end of January?

### Bonus Questions:
**Join All The Things**

The following questions are related creating basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL.

![Join](https://user-images.githubusercontent.com/76781033/211604820-aa1559b5-61b7-4435-87e1-9ebb01793437.png)

**Rank All The Things**

Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.

![Rank](https://user-images.githubusercontent.com/76781033/211605054-b9e503b8-5b26-4a7c-8ddd-511872d47035.png)


