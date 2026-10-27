-- ===========================================
--		 Airport Disruptions Analysis
-- ===========================================

SELECT *
FROM airport_disruptions;


SELECT
	airport_name,
	SUM(flights_affected) AS affected_flights
FROM airport_disruptions
GROUP BY
	airport_name
ORDER BY affected_flights DESC;

-- ===========================================
-- Only airports where affected flights are greater than 5.
-- ===========================================

SELECT
	airport_name,
	SUM(flights_affected) AS affected_flights
FROM airport_disruptions
GROUP BY
	airport_name
HAVING SUM(flights_affected) > 1000
ORDER BY affected_flights DESC;

-- ===========================================
-- Which disruption type most affected the airports
-- ===========================================

SELECT
	disruption_type,
	COUNT(DISTINCT airport_name) AS total_airports
FROM airport_disruptions
GROUP BY 
	disruption_type
ORDER BY
	total_airports DESC;

-- ===========================================
-- What disruption occoured at airports, why disruption occoured, flights affected
-- and disruption_count (How many times that disruption occoured)
-- ===========================================

SELECT
    ad.airport_name,
    ad.disruption_type,
	ac.reason,
	SUM(ac.flights_affected) AS flights_affected,
    COUNT(*) AS disruption_count
FROM airport_disruptions ad
INNER JOIN airspace_closures ac
	ON ad.country = ac.country
GROUP BY
    ad.airport_name,
    ad.disruption_type,
	ac.reason
ORDER BY
	flights_affected DESC,
    disruption_count DESC;

-- ===========================================
-- What were the reasons of disruption
-- ===========================================

SELECT
	ad.disruption_type,
	ac.reason,
	COUNT(*) AS disruption_count
FROM airport_disruptions ad
LEFT JOIN airspace_closures ac
	ON ad.country = ac.country
GROUP BY
	ad.disruption_type,
	ac.reason
ORDER BY disruption_count DESC;

-- ===========================================
-- What was severity level of disruption
-- ===========================================

SELECT
	disruption_type,
	severity_level,
	COUNT(*) AS severity_count
FROM airport_disruptions
GROUP BY 
	disruption_type,
	severity_level
ORDER BY
	severity_count DESC;

-- ===========================================
-- Average duration of disruption
-- ===========================================

SELECT
	disruption_type,
	CAST(AVG(duration_hours) / 24 AS DECIMAL(10,2)) AS avg_duration_days
FROM airport_disruptions
GROUP BY
	disruption_type
ORDER BY
	avg_duration_days DESC;

-- ===========================================
-- disruption type, reason of disruption, severity_level and avg_severity_duration
-- ===========================================

SELECT
	ad.disruption_type,
	ac.reason,
	ad.severity_level,
	CAST(AVG(ad.duration_hours / 24.0) AS DECIMAL(10,2)) AS avg_severity_duration_days
FROM airport_disruptions ad
INNER JOIN airspace_closures ac
	ON ad.country = ac.country
	AND ad.region = ac.region
GROUP BY 
	ad.disruption_type,
	ac.reason,
	ad.severity_level
ORDER BY
	avg_severity_duration_days DESC;