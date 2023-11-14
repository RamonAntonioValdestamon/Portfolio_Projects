-- Viewing Tables

SELECT * FROM accident
SELECT * FROM vehicle

-- How many accident occured in urban v.s. rural areas?

SELECT Area, COUNT(*) AS TotalAccidents FROM accident
GROUP BY Area


-- Which day of the week has the highest number of accidents?

SELECT Day, COUNT(*) AS TotalAccidents from accident
GROUP BY Day
ORDER BY COUNT(*) DESC

--Majority of accidents occur on Fridays.


-- What is the average age of vehicles involved in accidents based on their type?

SELECT VehicleType, COUNT(AccidentIndex) AS TotalAccidents,AVG(AgeVehicle) AS AverageVehicleAge FROM vehicle
WHERE AgeVehicle IS NOT NULL AND VehicleType IS NOT NULL
GROUP BY VehicleType
ORDER BY COUNT(AccidentIndex) DESC


-- Can we identify any trends in accidents based on the age of vehicles involved?
SELECT 
AgeGroup,
COUNT(AccidentIndex) AS TotalAccidents,
AVG(AgeVehicle) AS AverageVehicleAge
FROM(
	SELECT
	AccidentIndex, AgeVehicle,
	CASE
	WHEN AgeVehicle BETWEEN 0 AND 5 THEN 'Relatively New'
	WHEN AgeVehicle Between 6 AND 10 THEN 'Moderate'
	WHEN AgeVehicle > 10 THEN 'Old'
	ELSE 'Unknown'
	END AS AgeGroup
	FROM vehicle
	
) AS Subquery
WHERE AgeGroup != 'Unknown'
GROUP BY AgeGroup

-- Most Accidents occur in relatively new or moderately aged cars, between 0 and 10 years old.


-- Are there any specific weather conditions that contribute to severe accidents?
DECLARE @Severity varchar(100)
SET @Severity = 'Serious'

SELECT WeatherConditions, COUNT(AccidentIndex) AS TotalAccidents
FROM accident
WHERE Severity = @Severity
GROUP BY WeatherConditions
ORDER BY COUNT(AccidentIndex) DESC

-- Majority of accidents occur in fine weather conditions, no high winds, regardless of severity


-- Do accidents often involve impacts on the left hand side?

SELECT LeftHand, COUNT(AccidentIndex) AS TotalAccidents
from vehicle
WHERE LeftHand IS NOT NULL
GROUP BY LeftHand

-- No, in fact, the opposite is true. Most accidents occur on the right hand side.


-- Are there any relationships between journey purposes and severity of accidents?

SELECT v.JourneyPurpose, COUNT(a.AccidentIndex) AS TotalAccidents,
CASE
	WHEN COUNT(a.AccidentIndex) BETWEEN 0 AND 1000 THEN 'Low'
	WHEN COUNT(a.AccidentIndex) BETWEEN 1001 AND 3000 THEN 'Moderate'
	WHEN COUNT(a.AccidentIndex) > 3000 THEN 'High'
	ELSE 'Unknown'
END AS Level
FROM vehicle v
JOIN accident a
ON v.AccidentIndex = a.AccidentIndex
GROUP BY v.JourneyPurpose
ORDER BY COUNT(a.AccidentIndex) DESC


-- Calculate the average age of vehicles involved in accidents, considering daylight and point of impact

SELECT a.LightConditions, v.PointImpact, AVG(v.AgeVehicle) AS AverageVehicleAge
FROM accident a
JOIN vehicle v
ON v.AccidentIndex = a.AccidentIndex
GROUP BY a.LightConditions, v.PointImpact
ORDER BY AVG(v.AgeVehicle) DESC

-- Most accidents involve the point of impact being at the front, regardless of daylight or darkness
