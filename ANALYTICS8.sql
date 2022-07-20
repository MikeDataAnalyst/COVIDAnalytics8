-- Seeing if the files appear
SELECT *
FROM coviddeath

SELECT *
FROM covidfact

SELECT *
FROM covidlocation

SELECT *
FROM covidvaccination

--I want to find Total Cases, Total Deaths, and Death Percentage

SELECT SUM(new_cases) AS total_cases,
SUM(CAST(new_deaths as INT)) as total_deaths, 
SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 AS death_percentages
FROM coviddeath a
JOIN covidfact b
ON a.deathid = b.deathid
JOIN covidlocation c
ON c.locationid = b.locationid
WHERE continent is NOT NULL

--All Continents and their totalcases

SELECT location, SUM(cast(new_cases as INT)) as TotalCases
FROM coviddeath a
JOIN covidfact b
ON a.deathid = b.deathid
JOIN covidlocation c
ON c.locationid = b.locationid
WHERE continent is null and location not in ('Low Income', 'High Income', 'Upper middle income', 'Lower middle income', 'World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalCases DESC

--GROUP BY COUINTRY of Infection Rates

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM coviddeath a
JOIN covidfact b
ON a.deathid = b.deathid
JOIN covidlocation c
ON c.locationid = b.locationid
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--VACCINATED PEOPLE AROUND THE WORLD

SELECT Location, population, MAX(CAST(people_fully_vaccinated AS FLOAT)) AS fully_vaccinated, MAX((CAST(people_fully_vaccinated AS FLOAT)/population))*100 as PercentPopulationVaccinated
FROM covidvaccination a
JOIN covidfact b
ON a.vaccinationid = b.vaccinationid
JOIN covidlocation c
ON c.locationid = b.locationid
GROUP BY location, population
ORDER BY PercentPopulationVaccinated DESC

--GROUP BY COUNTRY OF INFECTION RATES WITH TIME
SELECT Location, Population, date, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM coviddeath a
JOIN covidfact b
ON a.deathid = b.deathid
JOIN covidlocation c
ON c.locationid = b.locationid
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC

--GROUP BY COUNTRY OF DEATH RATES
SELECT TOP 11 Location, MAX(total_cases) as total_cases, SUM(CAST(new_deaths AS INT)) AS DEATHS , (MAX(total_deaths)/MAX(total_cases))*100 AS PercentPopulationDead
FROM coviddeath a
JOIN covidfact b
ON a.deathid = b.deathid
JOIN covidlocation c
ON c.locationid = b.locationid
GROUP BY location, population
ORDER BY PercentPopulationDead DESC

--GROUP BY COUNTRY OF BOOSTERS
SELECT TOP 10 Location, MAX(total_cases) as total_cases, SUM(CAST(new_deaths AS INT)) AS DEATHS , (MAX(total_boosters)/MAX(population))*100 AS PercentPopulationBoosted
FROM covidvaccination a
JOIN covidfact b
ON a.vaccinationid = b.vaccinationid
JOIN covidlocation c
ON c.locationid = b.locationid
JOIN coviddeath d
ON b.deathid=d.deathid
GROUP BY location, population
ORDER BY PercentPopulationBoosted DESC

SELECT MAX(total_boosters)
FROM covidvaccination