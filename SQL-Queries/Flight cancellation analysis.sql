-- ===========================================
--       Flight Cancellation Analysis
--		 Effects of flight cancellations
-- ===========================================

-- Passenegers affected by region

SELECT
	region,
	SUM(passengers_affected) AS total_passengers_affected
FROM (
	SELECT
		origin_region AS region,
		passengers_affected
	FROM flight_cancellations

	UNION ALL

	SELECT 
		destination_region AS region,
		passengers_affected
	FROM flight_cancellations
) AS r
GROUP BY
	region
ORDER BY
	total_passengers_affected DESC;

-- Passengers affected by airline

SELECT
	airline,
	SUM(passengers_affected) AS total_passenegrs_affected
FROM flight_cancellations
GROUP BY
	airline
ORDER BY
	total_passenegrs_affected DESC;


-- Why flights cancelled - Complete analysis
WITH cancellation_countries AS (
    SELECT
        airline,
        reason,
        passengers_affected,
        origin_country AS country
    FROM flight_cancellations

    UNION

    SELECT
        airline,
        reason,
        passengers_affected,
        destination_country AS country
    FROM flight_cancellations
),
airspace AS (
    SELECT DISTINCT
        country,
        reason
    FROM airspace_closures
)
SELECT
    c.airline,
    c.reason AS flight_cancellation_reason,
    ac.reason AS air_space_closure_reason,
    SUM(c.passengers_affected) AS passengers_affected,
    COUNT(*) AS total_flights
FROM cancellation_countries c
INNER JOIN airspace ac
    ON c.country = ac.country
GROUP BY
    c.airline,
    c.reason,
    ac.reason
ORDER BY
    passengers_affected DESC,
    total_flights DESC;

-- Flights cancelled by date

SELECT
	date,
	COUNT(*) AS total_cancelled
from flight_cancellations
GROUP BY
	date
ORDER BY total_cancelled DESC;