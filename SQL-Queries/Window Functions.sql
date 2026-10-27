-- ==================================
--         Window Functions
-- ==================================

-- 1.
-- For each airline: order by date, no. of cancelled fligths on that date and previous date

WITH CancelledFlights AS (
	SELECT
		airline,
		date,
		COUNT(*) AS cancelled_flights
	FROM flight_cancellations
	GROUP BY
		airline,
		date
),
RankedCancelledFlights AS (
	SELECT
		airline,
		date,
		cancelled_flights,
		LAG(cancelled_flights) OVER (PARTITION BY airline ORDER BY date ASC) AS previous_day_cancelled
	FROM CancelledFlights
)
SELECT
	airline,
	date,
	cancelled_flights,
	previous_day_cancelled,
	cancelled_flights - previous_day_cancelled AS difference
FROM RankedCancelledFlights
ORDER BY
	airline,
	date;


/* 2.
for each country, ordered by closure start date, the current closure's start date alongside the next closure's start date */

WITH CountriesDate AS (
	SELECT
		country,
		closure_start_date,
		reason
	FROM airspace_closures
),
NextEvent AS (
	SELECT
		country,
		closure_start_date,
		reason,
		LEAD(closure_start_date) OVER (PARTITION BY country ORDER BY closure_start_date) AS next_closure_start
	FROM CountriesDate
)
SELECT
	country,
	reason,
	closure_start_date,
	next_closure_start,
	DATEDIFF(
	DAY,
	closure_start_date,
	next_closure_start
	) AS days_until_next_closure
FROM NextEvent
ORDER BY
	country,
	closure_start_date;


/* 3.
Write a query that flags whether each reroute's delay was an improvement or a 
worsening compared to that same airline's previous reroute.*/

	WITH DelayDetails AS (
		SELECT
			airline,
			date,
			delay_hours,
			LAG(delay_hours) OVER (PARTITION BY airline ORDER BY date) AS previous_day_delay
		FROM flight_reroutes
	)
	SELECT
		airline,
		date,
		delay_hours,
		(
			CASE
				WHEN previous_day_delay IS NULL THEN 'No DATA'
				WHEN delay_hours < previous_day_delay THEN 'Improved'
				WHEN delay_hours > previous_day_delay THEN 'Worsened'
				WHEN delay_hours = previous_day_delay THEN 'Same'
			END
		) AS delay_status
	FROM DelayDetails
	ORDER BY
		airline,
		date;


/* 4.
For each airport, the running comparison of severity level against both the previous and next disruption*/

WITH RunningSeverity AS (
	SELECT
		airport_name,
		date,
		severity_level,
		LAG(severity_level) OVER (PARTITION BY airport_name ORDER BY date) AS previous_severity,
		LEAD(severity_level) OVER (PARTITION BY airport_name ORDER BY date) AS next_severity
	FROM airport_disruptions
)
SELECT
	airport_name,
	date,
	severity_level,
	previous_severity,
	next_severity
FROM RunningSeverity
ORDER BY
	airport_name,
	date;