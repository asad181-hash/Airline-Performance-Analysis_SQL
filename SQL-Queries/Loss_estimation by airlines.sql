-- ===================================
-- Cancelled flights by airline
-- ===================================

SELECT 
	airline,
	country,
	COUNT(cancelled_flights) AS cancelled_flights
FROM Airlinedb.dbo.airline_losses_estimate
GROUP BY
	airline,
	country
ORDER BY cancelled_flights ASC;

-- ===================================
-- Rerouted flights by airline & country
-- ===================================

SELECT
	airline,
	country,
	COUNT(rerouted_flights) AS rerouted_flights
FROM Airlinedb.dbo.airline_losses_estimate
GROUP BY 
	airline,
	country
ORDER BY
	rerouted_flights DESC;

-- ===================================
-- Total daily loss by airline
-- ===================================

SELECT 
	airline,
	country,
	SUM(estimated_daily_loss_usd + additional_fuel_cost_usd) AS Total_daily_loss
FROM airline_losses_estimate
GROUP BY
	airline,
	country
ORDER BY
	Total_daily_loss DESC;

-- ===================================
-- Total loss by airline (Entire Period)
-- ===================================
SELECT 
	airline,
	country,
	SUM(estimated_loss_usd) AS Total_loss
FROM airline_losses
GROUP BY
	airline,
	country
ORDER BY Total_loss DESC;