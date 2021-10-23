SELECT * 
FROM Covid19..CovidVaccinations
ORDER BY 3,4

SELECT * 
FROM Covid19..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--		Get data for use
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid19..CovidDeaths
ORDER BY 1,2


--		total cases vs total deaths
--		shows the likelyhood of dying if you were infected
--create view casesVSdeathsZimbabwe as
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Covid19..CovidDeaths
WHERE location like '%Zimbabwe%'
ORDER BY 1,2


--		total cases vs population
--		shows the percentage of the population contracting covid 
SELECT location, date, population, total_cases,  (total_cases/population)*100 as ContractionPercentage
FROM Covid19..CovidDeaths
WHERE location like '%Zimbabwe%'
ORDER BY 1,2


--		comparing countries with highest infection rates compared to population
--create view infectionVSpopulation as
SELECT location, population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as MaxContractionPercentage
FROM Covid19..CovidDeaths
GROUP BY location, population
ORDER BY MaxContractionPercentage DESC


--		comparing countries with highest mortalitry rate vs population
SELECT location, MAX(cast(total_deaths AS int)) as TotalDeathCount
FROM Covid19..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC


--		comparing continents with highest mortalitry rate per population
--create view ContinentMortality as
SELECT continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM Covid19..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC


--		percentage deaths per new case globally each day
--create view newDeathsPerCase as
SELECT date, SUM(new_cases) as GlobalNewCases, SUM(cast(new_deaths AS int)) AS GlobalNewDeaths, (SUM(cast(new_deaths AS int))/SUM(new_cases))*100 AS PercentDeathsPerNewCase
FROM Covid19..CovidDeaths
WHERE continent is not null
group by date
order by 1,2


--		total population vs vaccintions
SELECT deaths.continent, deaths.location,  deaths.date, deaths.population, vaccination.new_vaccinations  
FROM Covid19..CovidDeaths deaths
join Covid19..CovidVaccinations vaccination
	on deaths.location = vaccination.location
	and deaths.date = vaccination.date
where deaths.continent is not null 
order by 1,2,3


--		rolling vaccination count by country
SELECT deaths.continent, deaths.location,  deaths.date, deaths.population, vaccination.new_vaccinations  
, SUM(cast(vaccination.new_vaccinations as bigint)) OVER (Partition by deaths.location order by deaths.location, deaths.date) as RollingVaccinated
FROM Covid19..CovidDeaths deaths
join Covid19..CovidVaccinations vaccination
	on deaths.location = vaccination.location
	and deaths.date = vaccination.date
where deaths.continent is not null 
order by 2,3


--		CTE (Allows us to use the RollingVaccinated column name in further calcluations
--		Calculations like Percentage vacinated vs population
WITH PopulationVSVaccination (continent, location, date, population, new_vaccinations, RollingVaccinated)
as
(
	SELECT deaths.continent, deaths.location,  deaths.date, deaths.population, vaccination.new_vaccinations  
	, SUM(cast(vaccination.new_vaccinations as bigint)) OVER (Partition by deaths.location order by deaths.location, deaths.date) as RollingVaccinated
	FROM Covid19..CovidDeaths deaths
	join Covid19..CovidVaccinations vaccination
		on deaths.location = vaccination.location
		and deaths.date = vaccination.date
	where deaths.continent is not null 
	
)

SELECT *, (RollingVaccinated/population)*100
FROM PopulationVSVaccination
order by 2,3


--		Views to store data for visualizations
Create VIEW PopulationVaccinated as
SELECT deaths.continent, deaths.location,  deaths.date, deaths.population, vaccination.new_vaccinations  
, SUM(cast(vaccination.new_vaccinations as bigint)) OVER (Partition by deaths.location order by deaths.location, deaths.date) as RollingVaccinated
FROM Covid19..CovidDeaths deaths
join Covid19..CovidVaccinations vaccination
	on deaths.location = vaccination.location
	and deaths.date = vaccination.date
where deaths.continent is not null 

