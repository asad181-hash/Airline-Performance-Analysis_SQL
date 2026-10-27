-- ==============================
--      Stored Procedures
-- ==============================

/* Stored procedure, airline loss report taking airline as a parameter, returning 
airline, country and estimated loss from airline losses.*/

SELECT *
FROM airline_losses;

DROP PROCEDURE IF EXISTS airline_losses_report;
Go

CREATE PROCEDURE airline_losses_report 
	@airline VARCHAR(100)
AS
BEGIN
	SELECT
		airline,
		country,
		SUM(estimated_loss_usd) AS estimated_loss,
		SUM(cancellations_count) AS cancelled_flights,
		SUM(reroutes_count) AS rerouted_flights,
		AVG(revenue_loss_pct) AS revenue_loss_pct
	FROM airline_losses
	WHERE airline = @airline
	GROUP BY
		airline,
		country
	ORDER BY
		estimated_loss DESC,
		revenue_loss_pct DESC
END

EXEC airline_losses_report @airline = 'Gulf Air';

/* /disruption severity report: taking two parameters disruption type and severity count,
returning airport_name, severity level and count from airport_disruption*/

SELECT *
FROM airport_disruptions;

DROP PROCEDURE IF EXISTS severity_disruption_report;
Go

CREATE PROCEDURE severity_disruption_report
	@disruption_type VARCHAR(100),
	@min_severity_count INT 
AS
BEGIN
	SELECT
		airport_name,
		severity_level,
		COUNT(*) AS severity_count,
		SUM(flights_affected) AS affected_flights,
		ROUND(AVG(duration_hours / 24.0), 2) AS avg_duration_days
	FROM airport_disruptions
	WHERE
		disruption_type = @disruption_type
	GROUP BY
		airport_name,
		severity_level
	HAVING
		COUNT(*) > @min_severity_count
	ORDER BY
		severity_count DESC,
		affected_flights DESC,
		avg_duration_days DESC
END;

EXEC severity_disruption_report @disruption_type = 'Full Closure',
@min_severity_count = 1; 


/* 3.
SP: Reroute Cost Check: that takes one parameter airline name, calculates that airline's extra fuel cost, into a variable
total_cost. If total_cost > 50000, returns 'high_cost_airline' else normal*/

SELECT *
FROM flight_reroutes;

DROP PROCEDURE IF EXISTS reroute_cost_check;
Go

CREATE PROCEDURE reroute_cost_check
	@airline_name VARCHAR(100) AS
BEGIN
	DECLARE @total_cost DECIMAL(10,2)

	SELECT
		@total_cost = SUM(extra_fuel_cost_usd)
	FROM flight_reroutes
	WHERE 
		airline = @airline_name

	IF @total_cost > 100000
	BEGIN
		SELECT
			@airline_name AS airline,
			@total_cost AS total_cost,
			'High Cost Airline' AS Status
	END
	ELSE
	BEGIN
		SELECT
			@airline_name AS airline,
			@total_cost AS total_cost,
			'Normal airline' AS status
	END		
END;

EXEC reroute_cost_check @airline_name = 'Gulf Air';

EXEC reroute_cost_check 'Gulf Air';


/* 4.
SP top_disruption_airports: parameter @top_n, 
1. temp_table #airport_totals inside the procedure returning airport name, total_fights affected from airport_disruptions
2. Returns Top_n rows from #airport_totals.*/

SELECT *
FROM airport_disruptions;

DROP PROCEDURE IF EXISTS top_disruption_airports;
Go

CREATE PROCEDURE top_disruption_airports
	@top_n INT AS
BEGIN
	SELECT
		airport_name,
		country,
		SUM(flights_affected) AS total_affected_flights
	INTO #airport_totals
	FROM airport_disruptions
	GROUP BY
		airport_name,
		country

	SELECT TOP (@top_n)
		airport_name,
		country,
		total_affected_flights
	FROM #airport_totals
	ORDER BY
		total_affected_flights DESC
END

EXEC top_disruption_airports @top_n = 5;


/* 5.
Stored Procedure: Airlinerank by delay, taking paramter min_reroutes
1. CTE: to compute per airline total_routes, avg_delay_hours from Flight_reroutes
2. In the final: Rank airlines by avg_delay_hours using RANK Where total_reoutes > min_reroutes*/

SELECT *
FROM flight_reroutes;

DROP PROCEDURE IF EXISTS airline_rank_by_delay;
GO


CREATE PROCEDURE airline_rank_by_delay @min_reroutes INT AS
BEGIN
	WITH airline_summary AS (
		SELECT
			airline,
			COUNT(*) AS flight_reroutes_count,
			ROUND(AVG(delay_hours), 2) AS avg_delay_hours
		FROM flight_reroutes
		GROUP BY
			airline
	)
	SELECT
		airline,
		flight_reroutes_count,
		avg_delay_hours,
		DENSE_RANK() OVER (ORDER BY avg_delay_hours DESC) AS flight_delay_rank
	FROM airline_summary
	WHERE
		flight_reroutes_count > @min_reroutes
	ORDER BY
		avg_delay_hours DESC
END;

EXEC airline_rank_by_delay @min_reroutes = 20;