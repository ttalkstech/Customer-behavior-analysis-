SELECT * 
FROM dbo.customer_data;


-- Q1: Which gender contributes the most to total revenue?
SELECT 
    gender AS Gender,
    SUM(purchase_amount) AS TotalRevenue
FROM dbo.customer_data
GROUP BY gender;


-- Q2: Which customers made above-average purchases while using discounts?
SELECT 
    customer_id,
    purchase_amount
FROM dbo.customer_data
WHERE discount_applied = 'Yes' 
  AND purchase_amount >= (
        SELECT AVG(purchase_amount) 
        FROM dbo.customer_data
  )
ORDER BY purchase_amount DESC;


-- Q3: What are the top 5 highest-rated products based on customer reviews?
SELECT TOP 5
    item_purchased,
    AVG(review_rating) AS avg_review_rating 
FROM dbo.customer_data
GROUP BY item_purchased
ORDER BY avg_review_rating DESC;


-- Q4: How does purchase amount differ between Express and Standard shipping methods?
SELECT 
    shipping_type,
    AVG(purchase_amount) AS avg_purchase_amount
FROM dbo.customer_data
WHERE shipping_type IN ('Express','Standard') 
GROUP BY shipping_type;


-- Q5: How do subscribed vs non-subscribed customers differ in count, average spending, and total revenue?
SELECT 
    subscription_status,
    COUNT(customer_id) AS total_customers,
    AVG(purchase_amount) AS avg_purchase_amount,
    SUM(purchase_amount) AS total_purchase_amount  
FROM dbo.customer_data
GROUP BY subscription_status;


-- Q6: Which products have the highest discount usage rate?
SELECT TOP 5
    item_purchased,
    ROUND(
        100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) 
        / COUNT(*), 
    2) AS discount_rate_percentage
FROM dbo.customer_data    
GROUP BY item_purchased
ORDER BY discount_rate_percentage DESC;


-- Q7: How can customers be segmented into New, Returning, and Loyal groups?
WITH customer_type AS (
    SELECT 
        customer_id,
        previous_purchases,
        CASE 
            WHEN previous_purchases = 0 THEN 'New'
            WHEN previous_purchases BETWEEN 1 AND 10 THEN 'Returning'
            WHEN previous_purchases > 10 THEN 'Loyal'
        END AS customer_segmentation
    FROM dbo.customer_data
)
SELECT 
    customer_segmentation,
    COUNT(*) AS total_customers
FROM customer_type
GROUP BY customer_segmentation;


-- Q8: What are the top 3 most popular items in each product category?
WITH item_counts AS (
    SELECT 
        category,
        item_purchased,
        COUNT(customer_id) AS total_customers,
        ROW_NUMBER() OVER(
            PARTITION BY category 
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM dbo.customer_data
    GROUP BY category, item_purchased
)
SELECT 
    category,
    item_purchased,
    total_customers,
    item_rank
FROM item_counts
WHERE item_rank <= 3;


-- Q9: How many repeat buyers exist in each subscription group?
SELECT 
    subscription_status,
    COUNT(customer_id) AS repeat_buyers
FROM dbo.customer_data
WHERE previous_purchases > 5
GROUP BY subscription_status;


-- Q10: Which age group contributes the most to overall revenue?
SELECT 
    age_group,
    SUM(purchase_amount) AS revenue_contribution
FROM dbo.customer_data
GROUP BY age_group
ORDER BY revenue_contribution DESC;