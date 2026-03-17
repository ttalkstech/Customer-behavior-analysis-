SELECT * 
FROM dbo.customer_data


ALTER TABLE dbo.customer_data
DROP COLUMN column20

-- 1
SELECT 
	gender AS Gender,
	SUM(purchase_amount) AS TotalRevenue
FROM dbo.customer_data
GROUP BY gender

-- 2
SELECT 
	customer_id,
	purchase_amount
FROM dbo.customer_data
WHERE discount_applied = 'Yes' AND purchase_amount >= (SELECT AVG(purchase_amount) FROM dbo.customer_data)
ORDER BY purchase_amount DESC

--3
SELECT TOP 5
	item_purchased,
	AVG(review_rating) AS avg_review_rating 
FROM dbo.customer_data
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC

--4

SELECT 
	shipping_type,
	AVG(purchase_amount) 
FROM dbo.customer_data
WHERE shipping_type IN ('Express','Standard') 
GROUP BY shipping_type


--5

SELECT 
	subscription_status,
	COUNT(customer_id) AS customers,
	AVG(purchase_amount) AS avg_purchase_amount,
	SUM(purchase_amount) AS total_purchase_amount  
FROM dbo.customer_data
GROUP BY subscription_status


--6
SELECT TOP 5
	item_purchased,
	ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS discount_rate
FROM dbo.customer_data	
GROUP BY item_purchased
ORDER BY discount_rate DESC	


--7

WITH customer_type AS (
	
	SELECT 
	customer_id,
	previous_purchases,
	CASE 
		WHEN previous_purchases <= 1 THEN 'New'
		WHEN previous_purchases BETWEEN 1 AND 10 THEN 'Returning'
		WHEN previous_purchases > 1 THEN 'Loyal'
	END AS customerSegmentation
	FROM dbo.customer_data
)

SELECT 
	customerSegmentation,
	COUNT(*)
FROM customer_type
GROUP BY customerSegmentation


--7

WITH item_counts AS (
	SELECT 
		category,
		item_purchased,
		COUNT(customer_id) as total_customers,
		ROW_NUMBER() OVER(PARTITION BY category ORDER BY COUNT(customer_id)) AS item_rank
	FROM dbo.customer_data
	GROUP BY category,item_purchased
)

SELECT 
	item_rank,
	category,
	total_customers
FROM item_counts
WHERE item_rank <= 3




SELECT * 
FROM dbo.customer_data



--8

SELECT 
	subscription_status,
	COUNT(customer_id) AS RepeatBuyers
FROM dbo.customer_data
WHERE previous_purchases > 5
GROUP BY subscription_status




--9
SELECT 
	age_group,
	SUM(purchase_amount) AS revenue_contribution
FROM dbo.customer_data
GROUP BY age_group
ORDER BY revenue_contribution DESC

