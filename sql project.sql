-- 💻 The SQL Pipeline
-- 1. Database Schema Design
-- I designed a scalable schema using appropriate data types (e.g., BIGSERIAL for primary keys, NUMERIC for financial precision) to ensure data integrity.

DROP TABLE IF EXISTS retail;

CREATE TABLE retail (
    id BIGSERIAL PRIMARY KEY,
    invoice VARCHAR(20),
    stockcode VARCHAR(20),
    description TEXT,
    quantity INTEGER,
    invoicedate TIMESTAMP WITHOUT TIME ZONE,
    price NUMERIC(10,2),
    customerid INTEGER,
    country VARCHAR(100)
);


-- 2. High-Performance Data Ingestion
-- Using the COPY command to bypass GUI limitations and handle specific encoding and date requirements.


-- Configuring the database to read the specific date format of the file
SET datestyle = 'ISO, DMY';

-- Professional ingestion handling encoding and headers
COPY retail(invoice, stockcode, description, quantity, invoicedate, price, customerid, country)
FROM '/path/to/your/online_retail_II.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'LATIN1');


-- 3. Advanced Business Intelligence Queries
-- Level 1: Sales & Product Velocity
-- Identifies top-performing products while filtering out returns and null identifiers.

WITH product_metrics AS (
    SELECT
        description,
        SUM(quantity * price) AS total_revenue,
        SUM(quantity) AS total_quantity_sold,
        COUNT(DISTINCT customerid) AS distinct_customer_count
    FROM retail
    WHERE customerid IS NOT NULL AND quantity > 0
    GROUP BY description
)
SELECT *, (total_revenue/distinct_customer_count) AS avg_revenue_per_customer
FROM product_metrics
WHERE description IS NOT NULL
ORDER BY total_revenue DESC
LIMIT 10;



-- Level 2: Time-Series Growth Analysis
-- Uses DATE_TRUNC to normalize data into monthly buckets for growth reporting.

WITH monthly_stats AS (
    SELECT
        DATE_TRUNC('month', invoicedate) AS month,
        SUM(quantity * price) AS monthly_revenue,
        COUNT(DISTINCT invoice) AS transaction_count
    FROM retail
    WHERE customerid IS NOT NULL AND quantity > 0
    GROUP BY month
)
SELECT
    month,
    monthly_revenue,
    transaction_count,
    ROUND(monthly_revenue::numeric / transaction_count, 2) AS revenue_per_invoice
FROM monthly_stats
ORDER BY month;


-- Level 3: Customer Behavioral Segmentation
-- Implements a multi-step CTE to categorize customers into value tiers.

WITH customer_spend AS (
    SELECT
        customerid,
        SUM(quantity * price) AS total_spend
    FROM retail
    WHERE customerid IS NOT NULL AND quantity > 0
    GROUP BY customerid
),
segmented_data AS (
    SELECT
        customerid,
        total_spend,
        CASE
            WHEN total_spend > 5000 THEN 'High Value'
            WHEN total_spend >= 1000 THEN 'Mid Value'
            ELSE 'Low Value'
        END AS customer_type
    FROM customer_spend
)
SELECT
    customer_type,
    COUNT(customerid) AS customer_count,
    ROUND(AVG(total_spend), 2) AS avg_segment_spend
FROM segmented_data
GROUP BY customer_type
ORDER BY avg_segment_spend DESC;





