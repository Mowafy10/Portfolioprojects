select*
from [Portfolio Project ]..CovidDeaths$
Where continent is not null
order by 3,4


--select*
--from [Portfolio Project ]..CovidVaccinations$
--order by 3,4

--select data that we are going to use

select Location,date,total_cases,new_cases,total_deaths,population
from [Portfolio Project ]..CovidDeaths$ 
order by 1,2

--Looking at Total Cases vs Totsl Deaths 

select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project ]..CovidDeaths$ 
Where location like '%Egypt%'
order by 1,2

--Looking at Total Cases vs population
select Location,date,population,total_cases,(total_cases/population)*100 as CasesPercentage
from [Portfolio Project ]..CovidDeaths$ 
--Where location like '%States%'
order by 1,2

--Looking at Heighest infection rate compared to population
select Location,population,Max(total_cases)as Heighestinfectioncount ,Max((total_cases/population))*100 as percentpopulationinfected
from [Portfolio Project ]..CovidDeaths$ 
Group by  Location,population
--Where location like '%States%'
order by 4 desc

-- Showing countries with heighest Death count per population
select location,Max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project ]..CovidDeaths$ 
Where continent is not null
Group by  location
--Where location like '%States%'
order by TotalDeathCount desc


--Lets Break Things Down with Continent
select location,Max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project ]..CovidDeaths$ 
Where continent is null
Group by location
--Where location like '%States%'
order by TotalDeathCount desc

select continent,Max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project ]..CovidDeaths$ 
Where continent is not null
Group by continent
--Where location like '%States%'
order by TotalDeathCount desc


--Global Numbers 

select date,Sum(new_cases) as Total_Cases ,sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/Sum(new_cases)*100 as Deathpercentage
from [Portfolio Project ]..CovidDeaths$ 
--Where location like '%Egypt%'
where continent is not null 
Group By date
order by 1,2


select Sum(new_cases) as Total_Cases ,sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/Sum(new_cases)*100 as Deathpercentage
from [Portfolio Project ]..CovidDeaths$ 
--Where location like '%Egypt%'
where continent is not null 
--Group By date
order by 1,2



-- Looking at total population vs Vaccination
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as SumofVaccinatedpeople 
from [Portfolio Project ]..CovidDeaths$ dea 
join [Portfolio Project ]..CovidVaccinations$ vac 
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3





--CTE

with popvsvac (continent,location,date,population,new_vaccinations,Sumofvaccinatedpeople)
as
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as SumofVaccinatedpeople
--,(Sumofvaccinatedpeople/population)*100
from [Portfolio Project ]..CovidDeaths$ dea 
join [Portfolio Project ]..CovidVaccinations$ vac 
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select*,(Sumofvaccinatedpeople/population)*100 as percentofvaccinatedpeople
from popvsvac


--Temp Table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
Sumofvaccinatedpeople numeric
)

insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as SumofVaccinatedpeople
--,(Sumofvaccinatedpeople/population)*100
from [Portfolio Project ]..CovidDeaths$ dea 
join [Portfolio Project ]..CovidVaccinations$ vac 
on dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not null
--order by 2,3
select*,(Sumofvaccinatedpeople/population)*100 as percentofvaccinatedpeople
from #PercentPopulationVaccinated



create view PercentPopulationVaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as SumofVaccinatedpeople
--,(Sumofvaccinatedpeople/population)*100
from [Portfolio Project ]..CovidDeaths$ dea 
join [Portfolio Project ]..CovidVaccinations$ vac 
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select*
from #PercentPopulationVaccinated