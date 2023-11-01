-- COVID-19 Data Exploration in SQL Server

-- Death Percentage for COVID in the Philippines

SELECT
location, date, population, CAST(total_cases AS int), CAST(total_deaths AS int),
ROUND(CAST(total_deaths AS float(2)) / CAST(total_cases AS float(2))*100,2) AS death_percentage
FROM CovidDeaths2023
WHERE location = 'Philippines'
ORDER BY date


-- Infection rate by population in Philippines
SELECT
location, date, population, 
CAST(total_cases AS int) AS total_cases,
ROUND(CAST(total_cases AS numeric) / population * 100, 2) AS infection_rate
FROM CovidDeaths2023
WHERE location = 'Philippines'
ORDER BY date


-- Top countries with highest infection rates by population
SELECT
location, population, 
MAX(CAST(total_cases AS int)) AS highest_total_cases,
MAX(CAST(total_cases AS numeric)) / population * 100 AS infection_rate
FROM CovidDeaths2023
GROUP BY location, population
ORDER BY MAX(CAST(total_cases AS numeric) / population * 100) DESC


-- Highest Deaths per Country
SELECT
location, MAX(CAST(total_deaths AS int)) AS total_death_toll
FROM CovidDeaths2023
WHERE location NOT IN('World', 'High income', 'Lower middle income', 'Low Income', 'European Union', 'Upper middle income',
'Europe', 'Asia', 'Africa', 'North America', 'South America', 'Oceania')
AND CAST(total_deaths AS int) IS NOT NULL
GROUP BY location
ORDER BY MAX(CAST(total_deaths AS int)) DESC


-- Death Count Ranking by Continent
SELECT
continent, MAX(CAST(total_deaths AS int)) AS total_death_toll
FROM CovidDeaths2023
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY MAX(CAST(total_deaths AS int)) DESC


-- Global Numbers/Totals
SELECT
SUM(CAST(new_cases AS int)) AS total_cases, 
SUM(CAST(new_deaths as int)) AS total_deaths,
CASE
WHEN SUM(new_cases) > 0
THEN ROUND(SUM(new_deaths) / SUM(new_cases) * 100,2)
ELSE 0
END AS death_rate
FROM CovidDeaths2023
WHERE continent IS NOT NULL


-- Merging the COVID Deaths and Vacciniations Tables

SELECT * FROM CovidDeaths2023 d

JOIN CovidVaccinations2023 v
ON d.location = v.location AND d.date = v.date


-- Total Population v.s Total Vaccinated
SELECT
d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CAST(v.new_vaccinations as int)) OVER (PARTITION BY d.location ORDER BY d.location, d.date)
FROM CovidDeaths2023 d
JOIN CovidVaccinations2023 v
ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY d.location, d.date