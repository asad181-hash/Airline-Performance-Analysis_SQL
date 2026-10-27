-- ==========================================
--		  flight_reroutes analysis
-- ==========================================

SELECT *
FROM flight_reroutes;

-- Summary

SELECT
	COUNT(*) AS rerouted_flightes,
	SUM(additional_distance_km) AS additional_distance_km,
	ROUND(SUM(extra_fuel_cost_usd),2) AS extra_fuel_cost_usd,
	ROUND(SUM(extra_fuel_cost_usd),2) * 280 AS extra_fuel_cost_pkr,
	ROUND(AVG(delay_hours),2) AS avg_delay_hours
FROM flight_reroutes;

-- TOP 10 airlines by distance (Using RANK)

SELECT
	TOP 10
	airline,
	AVG(original_distance_km) AS orig_dist_km,
	AVG(additional_distance_km) AS avg_add_dist_km,
	ROUND(AVG(extra_fuel_cost_usd), 2)AS avg_extra_fuel_cost_usd,
	ROUND(AVG(delay_hours), 2) AS avg_delay_hours,
	RANK() OVER (ORDER BY AVG(additional_distance_km) DESC) AS distance_rank
FROM flight_reroutes
GROUP BY
	airline
ORDER BY
	avg_add_dist_km DESC,
	orig_dist_km DESC,
	avg_extra_fuel_cost_usd DESC,
	avg_delay_hours DESC;


-- TOP airlines by first 10 tiers by distance (Using DENSE_RANK)

SELECT
	TOP 10
	airline,
	AVG(original_distance_km) AS orig_dist_km,
	AVG(additional_distance_km) AS avg_add_dist_km,
	ROUND(AVG(extra_fuel_cost_usd), 2)AS avg_extra_fuel_cost_usd,
	ROUND(AVG(delay_hours), 2) AS avg_delay_hours,
	DENSE_RANK() OVER (ORDER BY AVG(additional_distance_km) DESC) AS distance_rank
FROM flight_reroutes
GROUP BY
	airline
ORDER BY
	avg_add_dist_km DESC,
	orig_dist_km DESC,
	avg_extra_fuel_cost_usd DESC,
	avg_delay_hours DESC;


-- =====================================
--      CTEs & Window Functions
-- =====================================

-- Airlines where average fuel cost is greater than overall avg fuel cost

WITH airline_avg AS (
	SELECT
		airline,
		ROUND(AVG(extra_fuel_cost_usd), 2) AS avg_add_fuel_cost
	FROM flight_reroutes
	GROUP BY
		airline
),
overall_avg AS (
	SELECT
		ROUND(AVG(extra_fuel_cost_usd), 2) AS overall_avg_fuel_cost
	FROM flight_reroutes
)
SELECT
	aa.airline,
	oa.overall_avg_fuel_cost,
	aa.avg_add_fuel_cost
FROM airline_avg aa
CROSS JOIN overall_avg oa
WHERE 
	aa.avg_add_fuel_cost > oa.overall_avg_fuel_cost
ORDER BY
	aa.avg_add_fuel_cost DESC;