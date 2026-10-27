-- Airspace closures analysis


-- ===========================================
-- Avg airspace closure
-- ===========================================

SELECT
	country,
	AVG(
		DATEDIFF(
			DAY,
			closure_start_date,
			closure_end_date
		)
	) AS Avg_closure_days
FROM airspace_closures
GROUP BY 
	country
ORDER BY Avg_closure_days DESC;

-- ===========================================
-- Using CTE
-- Countries where average airspace closure was more than 3 days
-- ===========================================

WITH airspace_closure_days AS (
	SELECT
		country,
		AVG(
			DATEDIFF(
				DAY,
				closure_start_date,
				Closure_end_date
			)
		) AS avg_closure_days
	FROM airspace_closures
	GROUP BY
		country
)
SELECT 
	country,
	avg_closure_days
FROM airspace_closure_days
WHERE 
	avg_closure_days > 3
ORDER BY
	avg_closure_days DESC;

-- ===========================================
-- Top 5 countries by airspace closure
-- ===========================================

SELECT TOP 5
	country,
	AVG(
		DATEDIFF(
			DAY,
			closure_start_date,
			closure_end_date
		)
	) AS avg_closure_days,
	RANK () OVER (ORDER BY (AVG(DATEDIFF(DAY, closure_start_date,closure_end_date))) DESC) AS closure_rank
FROM airspace_closures
GROUP BY
	country
ORDER BY
	avg_closure_days DESC;

-- ===========================================
-- What were the reason of flights affected
-- ===========================================

SELECT
	country,
	reason,
	SUM(flights_affected) AS flights_count
FROM airspace_closures
GROUP BY
	country,
	reason
HAVING SUM(flights_affected) > 1000
ORDER BY
	flights_count DESC;