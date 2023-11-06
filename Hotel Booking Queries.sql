-- All hotel data from 2018-2020

SELECT * FROM dbo.[2018]
UNION
SELECT * FROM dbo.[2019]
UNION
SELECT * FROM dbo.[2020]


-- Total Revenue per year

WITH hotels AS (
SELECT * FROM dbo.[2018]
UNION
SELECT * FROM dbo.[2019]
UNION
SELECT * FROM dbo.[2020]
)

SELECT 
arrival_date_year,
SUM((stays_in_week_nights + stays_in_weekend_nights) * adr) AS revenue_per_year
FROM hotels
GROUP BY arrival_date_year


-- Merging combined hotels table with market segment and meal cost tables

WITH hotels AS (
SELECT * FROM dbo.[2018]
UNION
SELECT * FROM dbo.[2019]
UNION
SELECT * FROM dbo.[2020]
)

SELECT * FROM hotels
LEFT JOIN dbo.market_segment
ON hotels.market_segment = market_segment.market_segment
LEFT JOIN dbo.meal_cost
ON hotels.meal = meal_cost.meal
