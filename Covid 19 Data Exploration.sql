select*from
PortfolioProject..CovidDeaths
order by 3,4;
--select*from
--PortfolioProject..CovidVaccinations
--order by 3,4;

--select the data that we are using

SELECT location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths order by 1,2;

--totalcases vs total deaths
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from PortfolioProject..CovidDeaths
where location like '%India%'
order by 1,2;

--looking at tota cases vs population
--shows what percentage of population got covid

SELECT location,date,population,total_cases,(total_cases/population)*100 as PercentPopultaionInfection
from PortfolioProject..CovidDeaths
---where location like '%India%'
order by 1,2;


--looking at countries with highest infection rate

SELECT location,population,max(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as PercentPopulationInfection
from PortfolioProject..CovidDeaths
---where location like '%India%'
Group by location,population
order by PercentPopulationInfection desc;

--showing countries with highest death count

SELECT location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
---where location like '%India%'
where continent is not null
Group by location
order by TotalDeathCount desc;

--SHOWING CONTINENTS WITH HIGHEST DEATH COUNT PER POPULATION

SELECT continent,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
---where location like '%India%'
where continent is not null
Group by continent
order by TotalDeathCount desc;

--GLOBAL NUMBERS

SELECT date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null
order by 1,2;

--TOTAL NEW CASES VS TOTAL NEW DEATHS

SELECT SUM(new_cases) as TotalNewCases,SUM(CAST(new_deaths as int)) as TotalNewDeaths,
(SUM(CAST(new_deaths as int)))/SUM(new_cases)*100 as death_percentage
from PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null
--group by date
order by 1,2;

--LOOKING AT TOTAL POPULATION VS VACCINATIONS


WITH PopvsVac(Continent,location,date,population,New_vaccinations,RollingPeopleVaccinated)
as 
(Select dea.continent ,dea.location ,dea.date ,dea.population,vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) 
over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
on dea.location=vac.location and dea.date=vac.date
and dea.date=vac.date where dea.continent is not null )
Select*,(RollingPeopleVaccinated/population)*100
From PopvsVac;


--Creating view to store data for later visulizations

Create View PercentPopulationVaccinated as
Select dea.continent ,dea.location ,dea.date ,dea.population,vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) 
over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
on dea.location=vac.location and dea.date=vac.date
and dea.date=vac.date where dea.continent is not null 

Select*From PercentPopulationVaccinated;