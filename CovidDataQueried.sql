Select *
From PortfolioProject..CovidDeaths
Order by 3,4


--Select Data we want to use 

SELECT Location, date, Total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
Order by 1,2

-- Looking at total cases vs total deaths 

SELECT Location, date, total_cases, total_deaths, (total_deaths/Total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE [location] like '%Canada%'
ORDER by 1,2

--Highest infection count per country compared to populations

SELECT Location, Population, MAX(total_cases) as HighestCaseCount, MAX((total_cases/population))*100 as PercentInfected
FROM PortfolioProject..CovidDeaths
--WHERE [location] like '%Canada%'
GROUP by location,population
ORDER by PercentInfected desc

--Highest death count 

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
GROUP by [location]
order by TotalDeathCount DESC

-- Death count by continent

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is  NULL
GROUP by [location]
order by TotalDeathCount DESC


--Global Day to day cases 

SELECT Date, SUM(new_cases)as NewDailyCases, SUM(Cast(New_deaths as int)) as NewDailyDeaths
FROM PortfolioProject..CovidDeaths
where continent is not NULL
Group by DATE
order BY 1,2


--Global death percentage 

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--GROUP by [date]
ORDER by 1,2


-- Total population vs Vaccinations

Select dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.LOCATION order by dea.location, dea.date) as  RollingVaccinatedCount
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    on dea.location = vac.[location] and dea.[date] = vac.[date]
WHERE dea.continent is not NULL
order by 1,2


--Temp Table

Create TABLE #PercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    LOCATION NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
)