Select *
from Portfolio1..CovidDeaths
order by 3,4

--Select data that we are going using
select location, date, total_cases, new_cases, total_deaths, population
from Portfolio1..CovidDeaths
order by 1,2

--looking at total cases vs total death
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from Portfolio1..CovidDeaths
where location like '%indo%'
order by 1,2

--looking at total cases vs population
--show what percentage population got covid
select location, date, total_cases, population, (total_cases/population)*100 as Cases_Percentage
from Portfolio1..CovidDeaths
where location like '%indo%'
order by 1,2

--Looking at country with highest infection rate vs population
select location,MAX(total_cases) as highest_infection_count, population, MAX((total_cases/population))*100 as percent_population_infected
from Portfolio1..CovidDeaths
--where location like '%indo%'
group by population, location
order by percent_population_infected desc

--Showing country with highest death count vs population
select location,MAX(cast(total_deaths as int)) as total_death_count
from Portfolio1..CovidDeaths
--where location like '%indo%'
where continent is not null
group by location
order by total_death_count desc

--lets breaking down by continent
select location,MAX(cast(total_deaths as int)) as total_death_count
from Portfolio1..CovidDeaths
--where location like '%indo%'
where continent is null
group by location
order by total_death_count desc

--showing continent with the highest death count
select continent,MAX(cast(total_deaths as int)) as total_death_count
from Portfolio1..CovidDeaths
--where location like '%indo%'
where continent is not null
group by continent
order by total_death_count desc

--global numbers
select SUM(new_cases), sum(cast(new_deaths as int)), (sum(cast(new_deaths as int))/SUM(new_cases))*100 as Death_Percentage
from Portfolio1..CovidDeaths
where continent is not null
order by 1,2

--looking total vaccination vs population
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
from Portfolio1..CovidVaccinations vac
join Portfolio1..CovidDeaths dea
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE
with popvsvac(continent,location,date,population,new_vaccinations,rolling_people_vaccinated)
as(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
from Portfolio1..CovidVaccinations vac
join Portfolio1..CovidDeaths dea
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)
select *,(rolling_people_vaccinated/population)*100
from popvsvac

--TEMP TABLE
drop table if exists #Percent_population_vaccinated
Create Table #Percent_population_vaccinated
(
continent nvarchar(255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)
insert into #Percent_population_vaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
from Portfolio1..CovidVaccinations vac
join Portfolio1..CovidDeaths dea
	on dea.location = vac.location and dea.date = vac.date
--where dea.continent is not null

select *,(rolling_people_vaccinated/population)*100
from #Percent_population_vaccinated
