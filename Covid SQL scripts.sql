SELECT *
FROM coviddeaths
ORDER BY 3, 4;

UPDATE coviddeaths
SET continent = 'Asia'
WHERE location LIKE 'Africa';

UPDATE covidvaccinations
SET continent = 'Asia'
WHERE location LIKE 'Africa';

# Select useable data

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1, 2;


# Total cases vs Total deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM coviddeaths
WHERE location LIKE '%State%'
ORDER BY 1, 2;


# Total cases vs Population

SELECT location, date, total_cases, population, (total_cases/population)*100 AS cases_percentage
FROM coviddeaths
ORDER BY 1, 2;


# Countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS highest_infection, MAX((total_cases/population))*100 AS population_infected_percentage
FROM coviddeaths
GROUP BY 1, 2
ORDER BY population_infected_percentage DESC;


# Continent with highest death count per population

SELECT continent, SUM(new_deaths) AS Total_death_count
FROM coviddeaths
WHERE continent!=''
GROUP BY continent
ORDER BY Total_death_count DESC;


# Global number

SELECT #date, 
	SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS SIGNED)) AS total_deaths, SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases)*100 AS death_percentage
FROM coviddeaths
WHERE continent != ''
# GROUP BY date
ORDER BY 1, 2;


# Total population vs vaccination

-- Use CTE

WITH PopvsVac (continent, location, date, population, vaccinations, rolling_vaccination)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccination
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent != ''
-- ORDER BY 2, 3
)
SELECT *, (rolling_vaccination/population)*100
FROM PopvsVac;


# Temp table

DROP TEMPORARY TABLE IF EXISTS PercentagePopulationVacinated;
CREATE TEMPORARY TABLE PercentagePopulationVacinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_vaccination numeric
);

INSERT INTO PercentagePopulationVacinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccination
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent != '';
-- ORDER BY 2, 3;

SELECT *, (Rolling_vaccination/Population)*100
FROM PercentagePopulationVacinated;


# Create View to store data for visualization

CREATE VIEW PercenPopulationVacinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_vaccination
FROM coviddeaths dea
JOIN covidvaccinations vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent != '';
-- ORDER BY 2, 3;

SELECT *
FROM PercenPopulationVacinated;

