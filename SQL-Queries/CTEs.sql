-- ===============================
--			  CTEs
-- ==============================

-- 1.
/* Total estimated loss per airline, overall average of airline, 
finally selecting airlines where estimated loss is greater than overall average of airline. */ 
WITH AirlineEstimatedLoss AS (
	SELECT
		airline,
		SUM(estimated_loss_usd) AS est_loss_usd
	FROM airline_losses
	GROUP BY
		airline
),
AirlineOverallAvg AS (
	SELECT
		ROUND(AVG(est_loss_usd), 2) AS overall_average
	FROM AirlineEstimatedLoss
	
)
SELECT
	ae.airline,
	overall_average,
	est_loss_usd,
	ROUND((est_loss_usd - overall_average), 2) AS difference
FROM AirlineEstimatedLoss ae
CROSS JOIN AirlineOverallAvg ao
WHERE 
	ae.est_loss_usd > ao.overall_average
ORDER BY
	ao.overall_average DESC,
	ae.est_loss_usd DESC;


-- 2.
/* Airline whose average delay hour is greater than the double of overall average duration hours*/

WITH AirlineAvgDelay AS (
	SELECT
		airline,
		ROUND(AVG(delay_hours), 2) AS airline_avg_delay_hour
	FROM flight_reroutes
	GROUP BY
		airline
),
OverallAverage AS (
	SELECT
		ROUND(AVG(delay_hours), 2) AS overall_avg_delay
	FROM flight_reroutes
)
SELECT
	aad.airline,
	aad.airline_avg_delay_hour,
	oa.overall_avg_delay
FROM AirlineAvgDelay aad
CROSS JOIN OverallAverage oa
WHERE 
	aad.airline_avg_delay_hour > ( 1.2 * oa.overall_avg_delay)
ORDER BY
	airline_avg_delay_hour DESC,
	overall_avg_delay DESC;


-- 3.
/* Disruption type, total_flights_affected, avg duration in days, then selecting top 3 */

WITH DisruptionRanked AS (
	SELECT 
		disruption_type,
		SUM(flights_affected) AS total_flights_affected,
		ROUND(AVG(duration_hours / 24.0), 2) AS avg_duration_days,
		RANK() OVER (ORDER BY (SUM(flights_affected)) DESC) AS flight_rank
	FROM airport_disruptions
	GROUP BY 
		disruption_type
)
SELECT
	TOP 3
	disruption_type,
	total_flights_affected,
	avg_duration_days,
	flight_rank
FROM DisruptionRanked
ORDER BY
	total_flights_affected DESC,
	avg_duration_days DESC;


-- 4.
/* Airline, reason, passengers affected by airline + reason, ranking them.
Finally selecting from 2nd CTE top reason only */

WITH PassengersAffected AS (
	SELECT
		airline,
		reason,
		SUM(passengers_affected) AS total_passengers_affected
	FROM flight_cancellations
	GROUP BY
		airline,
		reason
),
PassengersRanking AS (
	SELECT
		airline,
		reason,
		total_passengers_affected,
		ROW_NUMBER () OVER (PARTITION BY airline ORDER BY total_passengers_affected DESC) AS passenger_rank
	FROM PassengersAffected
)
SELECT
	airline,
	reason,
	passenger_rank
FROM PassengersRanking
WHERE 
	passenger_rank = 1
ORDER BY 
	total_passengers_affected DESC;