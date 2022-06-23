COVID-19 Data Exploration

Skills used: select, view, aggregate function, order by, 

create view deaths as
(
select * from CovidProject..CovidDeaths
where continent is not null 
and continent like 'eu%'
and date between '2020-01-24' and '2021-01-24'
)


--Cases in country per day between '2020-01-24' and '2021-01-24'
select location, SUM(new_cases) as total_cases, date, SUM(cast(new_deaths as int)) as total_deaths from deaths
group by location, date
order by 1, 3

--Total cases in country per day - cumulatively; between '2020-01-24' and '2021-01-24'
select location, sum(total_cases) as total_cases, SUM(cast(total_deaths as int)) as total_deaths, date from deaths
group by location, date
order by 1, 4


create view vaccainations as
(
select * from CovidProject..CovidVaccinations
where continent is not null 
and continent like 'eu%'
and date between '2020-01-24' and '2021-01-24'
)


--Vaccainations/tests in country per day between '2020-01-24' and '2021-01-24'
select location, sum(cast(new_tests as int)) as total_tests, date, sum(cast(new_vaccinations as int)) as total_vaccinations
from vaccainations
group by location,date 
order by 1,3

--Vaccainations/tests - cumulatively; between '2020-01-24' and '2021-01-24'
select location, sum(cast(total_tests as int)) as total_tests, date, sum(cast(total_vaccinations as int)) as total_vaccinations
from vaccainations
group by location,date 
order by 1,3
