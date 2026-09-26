# SQL Subqueries & CTEs — Business Analysis Practice

## Project Overview

This project is a hands-on SQL practice exercise focused on solving **real-world business analysis problems using Subqueries, CTEs, Aggregations, CASE expressions, JOINs, and analytical comparisons**.

The objective is not simply to write SQL queries that return data.

The real objective is to learn how to take a business question such as:

> **“Which customers are spending more than average?”**

and translate it into a structured analytical process:

**Business Question → Data Preparation → Aggregation → Benchmark → Comparison → Business Insight**

This exercise uses a small e-commerce database containing customers, orders, and products to simulate the type of analytical SQL problems commonly encountered in data analyst and web analytics roles.

---

# Motivation Behind This Exercise

In real-world analytics, SQL is rarely about retrieving a few rows from a table.

Analysts are often asked questions such as:

* Which customers spend more than the average?
* Which customers have no orders?
* Who is the highest-spending customer in each city?
* Which products generate above-average sales?
* Which customers place more orders than the average customer?
* Which orders have unusually high values for their city?
* Which customers have unusually high cancellation rates?
* Which customers combine high spending with high cancellation rates?

These questions require more than basic `SELECT`, `WHERE`, and `GROUP BY`.

They require an analyst to understand **how to construct analytical benchmarks and compare entities against those benchmarks**.

This exercise was designed to strengthen exactly that skill.

---

# Database Structure

The project uses three relational tables:

```text
CUSTOMERS
    │
    │ customer_id
    ↓
ORDERS
    │
    │ product_id
    ↓
PRODUCTS
```

---

## 1. Customers

Stores customer-level information.

| ColumnDescription |                                     |
| ----------------- | ----------------------------------- |
| `customer_id`     | Unique identifier for each customer |
| `customer_name`   | Customer name                       |
| `city`            | Customer's city                     |

Example structure:

```sql
CREATE TABLE customers(
    customer_name VARCHAR(20),
    customer_id INT PRIMARY KEY,
    city VARCHAR(20)
);
```

---

## 2. Orders

Stores individual customer transactions.

| ColumnDescription |                                             |
| ----------------- | ------------------------------------------- |
| `order_id`        | Unique order identifier                     |
| `customer_id`     | Customer associated with the order          |
| `product_id`      | Product associated with the order           |
| `amount`          | Order amount                                |
| `status`          | Order status such as Completed or Cancelled |
| `order_date`      | Date of the order                           |

Example structure:

```sql
CREATE TABLE orders(
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    amount INT,
    status VARCHAR(15),
    order_date DATE
);
```

---

## 3. Products

Stores product information.

| ColumnDescription |                           |
| ----------------- | ------------------------- |
| `product_id`      | Unique product identifier |
| `product_name`    | Product name              |
| `category`        | Product category          |
| `price`           | Product price             |

Example structure:

```sql
CREATE TABLE products(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(20),
    category VARCHAR(20),
    price INT
);
```

---

# SQL Techniques Used

The nine questions in this exercise combine several important SQL concepts.

## 1. CTEs — Common Table Expressions

CTEs are used to break complex analytical queries into logical stages.

```sql
WITH customer_data AS (
    ...
)
```

Instead of attempting to solve everything in one query, the analysis can be separated into meaningful steps.

For example:

```text
Raw tables
   ↓
Customer-level metrics
   ↓
Benchmark calculation
   ↓
Final comparison
```

This improves readability, debugging, and query explanation.

---

# 2. Aggregate Functions

The exercise uses:

```sql
SUM()
AVG()
COUNT()
MAX()
```

These are used to calculate business metrics such as:

* Total customer spending
* Average customer spending
* Number of orders
* Average order value
* Maximum spending within a city
* Total product sales

---

# 3. GROUP BY

`GROUP BY` is used to move from transaction-level data to analytical levels such as:

```text
Orders → Customers
Orders → Cities
Products → Product-level sales
Customers → City-level benchmarks
```

For example:

```sql
GROUP BY city
```

creates a separate analytical group for each city.

---

# 4. CASE Expressions

`CASE` is used to convert transactional information into business metrics.

For example, cancellation rate:

```sql
SUM(
    CASE
        WHEN status = 'Cancelled' THEN 1
        ELSE 0
    END
)
```

This converts order status into a countable cancellation indicator.

---

# 5. JOINs

JOINs connect the different levels of analysis.

For example:

```sql
JOIN orders o
    ON c.customer_id = o.customer_id
```

The exercise also uses JOINs to connect calculated benchmarks back to individual records.

For example:

```sql
ON cd.city = ca.city
```

This is particularly important when comparing an individual record against a **group-specific benchmark**.

---

# 6. CROSS JOIN

`CROSS JOIN` is used when a CTE produces a **single benchmark value** that needs to be available to every row.

For example:

```text
Customer data
      ×
Overall average
```

This allows every customer to be compared against the same overall benchmark.

---

# 7. Subqueries

Subqueries are used when one query depends on the result of another query.

A key example is calculating an average of already aggregated customer-level values:

```text
Orders
   ↓
Customer total spending
   ↓
Average customer spending
```

This is an important analytical pattern because:

```sql
AVG(amount)
```

and

```sql
AVG(total_customer_spending)
```

answer completely different business questions.

---

# 8. Aggregate-of-Aggregate Analysis

One of the major concepts practiced in this exercise is **aggregation at multiple levels**.

For example:

```text
Order level
     ↓
Customer total
     ↓
Average customer total
```

This prevents a common analytical mistake: comparing a customer-level metric with a transaction-level benchmark.

---

# 9. Benchmark-Based Analysis

Several questions follow the same analytical framework:

```text
Calculate entity metric
        ↓
Calculate benchmark
        ↓
Compare entity against benchmark
```

Examples:

```text
Customer spending
        ↓
Average customer spending
        ↓
Above-average customers
```

and:

```text
Customer cancellation rate
        ↓
Average customer cancellation rate
        ↓
Customers above benchmark
```

This pattern is highly relevant to business and web analytics.

---

# Questions Covered

## Q1 — Customers Above Their City's Average Spending

Identify customers whose total spending is greater than the average spending of customers in their city.

### Concepts

* CTEs
* `SUM()`
* `AVG()`
* `GROUP BY`
* JOIN
* City-level benchmarking

### Analytical pattern

```text
Customer spending
        ↓
Average spending by city
        ↓
Compare customers against city benchmark
```

---

## Q2 — Customers Above Overall Average Spending

Identify customers whose total spending is greater than the overall average customer spending.

### Concepts

* Nested subqueries
* Aggregate-of-aggregate analysis
* `SUM()`
* `AVG()`
* `HAVING`

The key learning was understanding that the benchmark must be based on **customer totals**, not the average individual order amount.

---

## Q3 — Customers With No Orders

Identify customers who have never placed an order.

### Concepts

* `NOT EXISTS`
* Correlated subqueries
* Relationship testing between tables

Core analytical idea:

```text
Customer
   ↓
Does a matching order exist?
   ↓
NO → identify customer
```

This introduced `EXISTS` / `NOT EXISTS` as a powerful way to answer relationship-based business questions.

---

## Q4 — Highest-Spending Customer in Each City

Identify the highest-spending customer in every city while preserving ties.

### Concepts

* CTEs
* `SUM()`
* `MAX()`
* `GROUP BY`
* JOIN-back pattern
* Group-level maximum

Analytical pattern:

```text
Customer totals
      ↓
Maximum spending per city
      ↓
Join back to customers
      ↓
Identify highest spenders
```

A particularly important lesson was that the benchmark must be joined back using the **grouping key**, such as `city`.

---

## Q5 — Products Selling Above Average Total Sales

Identify products whose total sales are greater than the overall average product sales.

### Concepts

* Product-level aggregation
* `SUM()`
* `AVG()`
* CTEs
* `CROSS JOIN`
* Benchmark comparison

This reinforced the distinction between:

```text
Average sales across products
```

and:

```text
A product's own sales
```

---

## Q6 — Customers With More Orders Than Average

Identify customers who place more orders than the average number of orders per customer.

### Concepts

* `COUNT()`
* CTEs
* Aggregate-of-aggregate analysis
* Overall benchmark
* `CROSS JOIN`

Analytical pattern:

```text
Orders
   ↓
Orders per customer
   ↓
Average orders per customer
   ↓
Compare customers
```

---

## Q7 — Orders Above Their City's Average Order Value

Identify individual orders whose amount is greater than the average order amount for their customer's city.

### Concepts

* CTEs
* JOINs
* `AVG()`
* `GROUP BY`
* Group-level benchmarks
* Record-to-group comparison

Analytical pattern:

```text
Individual orders
       ↓
Attach city
       ↓
Calculate average order amount by city
       ↓
Join benchmark back to orders
       ↓
Identify above-average orders
```

This question reinforced a critical SQL principle:

> When comparing a record against a group-specific benchmark, the grouping key must be available for the benchmark-to-record JOIN.

---

## Q8 — Customers Above Average Cancellation Rate

Identify customers whose cancellation rate is higher than the overall average customer cancellation rate.

### Concepts

* `CASE`
* `COUNT()`
* Cancellation rate calculation
* CTEs
* `AVG()` of calculated metrics
* `CROSS JOIN`
* Benchmark analysis

Cancellation rate:

```text
Cancelled Orders
---------------- × 100
Total Orders
```

The exercise demonstrates how transactional data can be converted into a business KPI and then benchmarked.

---

## Q9 — Customers With Both High Spending and High Cancellation Rate

Identify customers who satisfy **both** conditions:

```text
Gross spending > average customer spending
AND
Cancellation rate > average customer cancellation rate
```

### Concepts

* Multiple CTEs
* Multiple benchmarks
* `SUM()`
* `AVG()`
* `CASE`
* `CROSS JOIN`
* Multiple business conditions
* Multi-dimensional customer analysis

This is the most business-oriented question in the exercise because it combines two independent customer metrics into a single analytical filter.

---

# What This Exercise Is Really Teaching

The deeper goal of this project is not memorizing SQL syntax.

It is learning to think like an analyst.

A business question often requires moving through several analytical levels:

```text
TRANSACTION LEVEL
        ↓
ENTITY LEVEL
        ↓
GROUP LEVEL
        ↓
BENCHMARK LEVEL
        ↓
COMPARISON
        ↓
BUSINESS INSIGHT
```

For example:

```text
Orders
  ↓
Customer spending
  ↓
Average customer spending
  ↓
Above-average customers
```

Or:

```text
Orders
  ↓
Customer cancellation rate
  ↓
Average cancellation rate
  ↓
Above-average cancellation customers
```

---

# Skills Practiced / Mastered

Through these nine problems, the exercise strengthens:

### SQL Fundamentals

* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `DISTINCT`

### Aggregation

* `SUM()`
* `AVG()`
* `COUNT()`
* `MAX()`

### Relational SQL

* `INNER JOIN`
* JOIN conditions
* Joining aggregated results back to detailed data
* Understanding Cartesian-product risks

### Advanced SQL

* CTEs
* Subqueries
* Correlated subqueries
* `EXISTS`
* `NOT EXISTS`
* `CROSS JOIN`
* Aggregate-of-aggregate calculations

### Business Analytics

* Customer spending
* Order volume
* Average order value
* Product sales
* Cancellation rate
* City-level benchmarking
* Above-average analysis
* Multi-metric customer segmentation

---

# Key Analytical Lessons

## 1. The benchmark must match the level of the metric

Comparing:

```text
Customer total spending
```

against:

```text
Average individual order amount
```

would be analytically incorrect.

The levels must match.

---

## 2. GROUP BY defines the analytical population

```sql
GROUP BY city
```

means:

> Calculate the metric separately for each city.

Whereas:

```sql
AVG(metric)
```

without grouping produces an overall benchmark.

Understanding this distinction is fundamental to analytical SQL.

---

## 3. Benchmarks often need to be joined back

A common pattern throughout the project is:

```text
Calculate benchmark
        ↓
JOIN benchmark back
        ↓
Compare individual records
```

This pattern appears frequently in real-world analytics.

---

## 4. SQL is a tool for translating business questions

The most important skill demonstrated by this project is:

> **Turning a business question into a sequence of measurable SQL operations.**

Rather than asking:

> “What SQL syntax do I remember?”

the analytical approach becomes:

> “What is the entity? What is the metric? What is the benchmark? What population should the benchmark represent? How do I compare them?”

---

# Tools & Environment

* **MySQL**
* **MySQL Workbench**
* Relational SQL
* Synthetic e-commerce dataset

---

# Suggested Repository Structure

```text
SQL-Subqueries-CTEs-Business-Analysis/
│
├── README.md
│
├── schema.sql
│
├── synthetic_data.sql
│
└── business_analysis.sql
```

---

# Learning Outcome

After completing this exercise, the analyst should be more comfortable with:

```text
Basic SQL
    ↓
Aggregation
    ↓
CTEs
    ↓
Subqueries
    ↓
Multiple-level aggregation
    ↓
Benchmark analysis
    ↓
Business-oriented SQL
```

The ultimate objective is to move from **writing queries that work** to **writing queries that answer meaningful business questions**.

---

# Author

**Shorya Dev Bisht**

Data Science | SQL | Python | Machine Learning | Analytics

### LinkedIn

https://www.linkedin.com/in/shorya-bisht-a20144349/

---

## Project Focus

**SQL is not just about retrieving data.**

**It is about structuring data so that business questions can be answered clearly, accurately, and defensibly.**
