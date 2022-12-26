

SELECT *
FROM Portfolio.dbo.Deaths
ORDER BY 3,4

-- Selecting new data
--SELECT *
--FROM Portfolio.dbo.Vaccinations
--ORDER BY 3,4

-- Selecting data we will use

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio.dbo.Deaths
ORDER BY 1,2

-- Shows likelihood of dying if you contract covid in your country, in this case, it is INDIA
SELECT Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio.dbo.Deaths
WHERE location = 'India'
AND total_deaths is not NULL
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid.

SELECT Location, date, population, total_cases, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio.dbo.Deaths
WHERE location = 'India'
AND total_deaths is not NULL
ORDER BY 1,2

-- Looking at countries with highest infection rate compared to population

SELECT Location, Population, Max(total_cases) AS HighestInfectionRate, Max(total_cases/population)*100 as PercentPopulationInfected
FROM Portfolio.dbo.Deaths
--WHERE location = 'India'
GROUP BY Location,Population
ORDER BY HighestInfectionRate DESC

-- Showing countries with highest death count per population

SELECT Location, Max(Cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio.dbo.Deaths
--WHERE location = 'India'
Where Continent is not NUll
GROUP BY Location
ORDER BY TotalDeathCount DESC

-- Breaking down by Continent

SELECT location, Max(Cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio.dbo.Deaths
--WHERE location = 'India'
Where Continent is  NUll
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Showing Continents with the highest death count per population

SELECT Continent, Max(Cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio.dbo.Deaths
--WHERE location = 'India'
Where Continent is not Null
GROUP BY Continent 
ORDER BY TotalDeathCount DESC


-- Global Numbers

SELECT  Sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/Sum(new_cases) *100 as DeathPercentage 
FROM Portfolio.dbo.Deaths
-- Where Location = "India"
WHERE continent is not null
--GROUP BY date
order by 1,2

-- Looking at Total Population vs Vaccinations


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations )) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population) *100
FROM Portfolio.dbo.Deaths AS dea
Join Portfolio.dbo.Vaccinations AS vac ON
dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not Null
ORDER BY 1,2

-- USE CTE

With PopvsVac (continent, location, date, population, New_vaccinations,RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations )) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population) *100
FROM Portfolio.dbo.Deaths AS dea
Join Portfolio.dbo.Vaccinations AS vac 
ON dea.location = vac.location
And dea.date = vac.date
where dea.continent is not Null
And new_vaccinations is not Null
--ORDER BY 2,3
)

Select*, (RollingPeopleVaccinated/Population) * 100
From PopvsVac

-- TEMP TABLE


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations )) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population) *100
FROM Portfolio.dbo.Deaths AS dea
Join Portfolio.dbo.Vaccinations AS vac 
ON dea.location = vac.location
And dea.date = vac.date
where dea.continent is not Null
--ORDER BY 2,3

Select*, (RollingPeopleVaccinated/Population) * 100
From #PercentPopulationVaccinated


-- Creating view to store data for later visualisations

Create View PercentPopulationVaccinated 
AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations )) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population) *100
FROM Portfolio.dbo.Deaths AS dea
Join Portfolio.dbo.Vaccinations AS vac 
ON dea.location = vac.location
And dea.date = vac.date
where dea.continent is not Null
--ORDER BY 2,3

SELECT*
FROM PercentPopulationVaccinated