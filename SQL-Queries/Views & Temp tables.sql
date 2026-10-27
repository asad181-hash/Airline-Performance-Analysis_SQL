-- ============================
--           Views
-- ============================
USE Airlinedb;
Go

/* 1. 
airlines total losses summing total loss by airline and country*/

DROP VIEW IF EXISTS vw_airline_total_loss

Go
CREATE VIEW vw_airline_total_loss AS
	SELECT
		country,
		airline
		SUM(estimated_loss_usd) AS total_est_loss
	FROM airline_losses
	GROUP BY
		country
		airline;
		

Go

SELECT *
FROM vw_airline_total_loss
WHERE 
	total_est_loss > 1000000
ORDER BY
	total_est_loss DESC;

/* 2.
disruption summary view that gives total flights affected and duration days by airport and disruption type. */

DROP VIEW IF EXISTS vw_disruption_summary
Go

CREATE VIEW vw_disruption_summary AS
	SELECT
		airport_name,
		disruption_type,
		SUM(flights_affected) AS total_affected_flights,
		ROUND(AVG(duration_hours / 24.0), 2) AS avg_duration_days
	FROM airport_disruptions
	GROUP BY
		airport_name,
		disruption_type

Go

SELECT *
FROM vw_disruption_summary
WHERE 
	avg_duration_days > 1
ORDER BY
	total_affected_flights DESC;


/* 3.
View Cancellation closure context. Analysis of why flights cancelled, disruption type, reason, 
flights affected & passengers affected*/

DROP VIEW IF EXISTS vw_Cancellation_closure_context
Go

CREATE VIEW vw_Cancellation_closure_context AS 
WITH CancellationCountry AS (
	SELECT
		airline,
		reason,
		origin_country AS country,
		passengers_affected
	FROM flight_cancellations
	
	UNION ALL

	SELECT
		airline,
		reason,
		destination_country AS country,
		passengers_affected
	FROM flight_cancellations
),
Airspace AS (
	SELECT DISTINCT
		country,
		reason,
		flights_affected
	FROM airspace_closures
)
SELECT
	cc.airline,
	cc.reason AS flight_cancellation_reason,
	a.reason AS airspace_closure_reason,
	SUM(cc.passengers_affected) AS total_passengers_affected,
	SUM(a.flights_affected) AS total_flights_affected
FROM CancellationCountry cc
INNER JOIN Airspace a
	ON cc.country = a.country
GROUP BY
	cc.airline,
	cc.reason,
	a.reason;

Go

SELECT *
FROM vw_Cancellation_closure_context
WHERE 
	total_flights_affected > 1000
ORDER BY
	total_flights_affected DESC,
	total_passengers_affected DESC;


-- ===================================
--            Temp Tables
-- ===================================

/* 1. 
#Airline totals containing total loss by country and airline*/

DROP TABLE IF EXISTS #airline_totals
Go

SELECT
	airline,
	country,
	SUM(estimated_loss_usd) AS total_estimated_loss_usd
INTO #airline_totals
FROM airline_losses
GROUP BY
	airline,
	country


SELECT *
FROM #airline_totals
WHERE 
	total_estimated_loss_usd > (
	SELECT
		AVG(total_estimated_loss_usd) AS overall_average
	FROM #airline_totals
);


/*2.
#Reroute table containing total routes, total extra fuel cost, avg_delay hours grouped by airline */

DROP TABLE IF EXISTS #reroute_summary
Go

SELECT
	airline,
	COUNT(*) AS total_routes,
	SUM(extra_fuel_cost_usd) AS total_fuel_cost,
	ROUND(AVG(delay_hours), 2) AS avg_delay_hours
INTO #reroute_summary
FROM flight_reroutes
GROUP BY 
	airline;

-- adding a column to temp table and adding cost per reroute

ALTER TABLE #reroute_summary
ADD cost_per_reroute DECIMAL(10,2);


UPDATE #reroute_summary
SET cost_per_reroute = total_fuel_cost / total_routes;

SELECT *
FROM #reroute_summary
ORDER BY 
	cost_per_reroute DESC;