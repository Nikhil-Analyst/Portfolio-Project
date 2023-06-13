select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject.dbo.coviddata
order by 3, 4

--looking FOR total cases vs total deaths

select location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as Deathpercentage
from PortfolioProject.dbo.coviddata
where location like '%India%'
order by 1, 2

--looking at total cases vs population
select location, date, population, total_cases, (total_cases/population)*100 as casespercentage
from PortfolioProject.dbo.coviddata
where location like '%India%'
order by 1, 2

looking at countries with hieghest infection rate compared to population

select location, population, MAX(total_cases) as highestInfectionCount, MAX((total_cases/population))*100 as percentPOPULATIONInfected
from PortfolioProject.dbo.coviddata
--where location like '%India%'
group by location, population
order by percentPOPULATIONInfected desc

--showing countries with highest deathj count on population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.coviddata
--where location like '%India%'
group by location, population
order by TotalDeathCount desc



select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.coviddata
--where location like '%India%'
where continent is not null
group by continent
order by TotalDeathCount desc

--Showing the continent with highest death count

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.coviddata
--where location like '%India%'
where continent is not null
group by continent
order by TotalDeathCount desc

-- Looking at total population vs vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from PortfolioProject..coviddata dea
join
PortfolioProject..Covidvaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

USE CTE

with popvsvac (continent, location, date, population, new_vaccinations, peoplevaccinated)
as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from PortfolioProject..coviddata dea
join
PortfolioProject..Covidvaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select*, (peoplevaccinated/population)*100
from popvsvac

--temp table
drop table if exists #percentpopulationvaccinated
create Table #percentpopulationvaccinated
(continent nvarchar(225),
location nvarchar (225),
date datetime,
population numeric,
New_vaccination numeric,
peoplevaccinated numeric)

insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from PortfolioProject..coviddata dea
join
PortfolioProject..Covidvaccination vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select*, (peoplevaccinated/population)*100
from #percentpopulationvaccinated

--creating views to store data for visualization
create view populationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
from PortfolioProject..coviddata dea
join
PortfolioProject..Covidvaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3