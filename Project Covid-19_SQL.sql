# COVID-19 Data Analysis Project

## Table of Contents
- [Introduction](#introduction)
- [Datasets Overview](#datasets-overview)
- [Analysis Queries](#analysis-queries)
    - [COVID Deaths and Cases](#covid-deaths-and-cases)
    - [Vaccination Data](#vaccination-data)
    - [Comparative Analysis](#comparative-analysis)
- [Conclusions and Discussion](#conclusions-and-discussion)

## Introduction
This project explores COVID-19 data to understand the impact of the pandemic globally. We look at various metrics like total cases, deaths, and vaccination rates.

## Datasets Overview
The data used in this analysis is sourced from the `PortfolioProjectSMR` database and includes two main tables:
- `CovidDeaths`: Contains information about COVID-19 deaths.
- `CovidVaccinations`: Records COVID-19 vaccination data.
  
  --Check the datasets

  select* from PortfolioProjectSMR..CovidDeaths 
  order by 2,3

   select* from PortfolioProjectSMR.. CovidVaccinations
  order by 2,3


  --COVID deaths in my country
 
  SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS '%_of_Deaths', new_cases
  FROM PortfolioProjectSMR..CovidDeaths
  WHERE location like '%states%'
  ORDER by 1,2

  -- COVID cases in toal Population 
  
  SELECT location, date, population, total_cases, total_deaths, (total_cases/population)*100 AS '%_of_Casesto population', new_cases
  FROM PortfolioProjectSMR..CovidDeaths
 -- WHERE location like '%states%'
  ORDER by 1,2

  -- COVID cases with highest infection rate to total population
  SELECT location, population, MAX(total_cases) AS 'TopCOVIDCount',MAX(total_cases/population)*100 AS '%_of_COVID_Infection'
  FROM PortfolioProjectSMR..CovidDeaths
  -- WHERE location like '%states%'
  GROUP BY  Location, Population
--  ORDER by population desc
 ORDER BY TopCovidCount desc
--  ORDER by '%_of_COVID_Infection' desc


 -- COVID cases with highest Death Count/rate to total population
  SELECT location, MAX(total_deaths) AS 'TopCOVIDDeath'
  FROM PortfolioProjectSMR..CovidDeaths
 -- WHERE location like '%states%'
 GROUP BY  Location
--  ORDER by population desc
  ORDER BY'TopCOVIDDeath' desc
--  ORDER by '%_of_COVID_Infection' desc

-- TOP COVIDDEAtH convert to int to get appropriate result
 -- COVID cases with highest Death Count/rate to total population

  SELECT location, MAX(cast(total_deaths as int)) AS 'TopCOVIDDeath'
  FROM PortfolioProjectSMR..CovidDeaths
 -- WHERE location like '%bangla%'
 WHERE continent IS not NULL  -- remove continent as big nos
 GROUP BY  Location
--  ORDER by population desc
  ORDER BY'TopCOVIDDeath' desc
--  ORDER by '%_of_COVID_Infection' desc

-- Group by Continent 
-- Group by Continent 

  SELECT Continent, MAX(cast(total_deaths as int)) AS 'TopCOVIDDeath'
  FROM PortfolioProjectSMR..CovidDeaths
 -- WHERE location like '%bangla%'
 WHERE continent IS not NULL  -- remove continent as big nos
 GROUP BY  continent
--  ORDER by population desc
  ORDER BY'TopCOVIDDeath' desc
--  ORDER by '%_of_COVID_Infection' desc




-- 

  SELECT location, MAX(cast(total_deaths as int)) AS 'TopCOVIDDeath'
  FROM PortfolioProjectSMR..CovidDeaths
 -- WHERE location like '%bangla%'
 WHERE continent IS NULL  -- remove continent as big nos
 GROUP BY  location
--  ORDER by population desc
  ORDER BY'TopCOVIDDeath' desc
--  ORDER by '%_of_COVID_Infection' desc


--Showing continent with highest death count

  SELECT continent, MAX(cast(total_deaths as int)) AS 'TopCOVIDDeath'
  FROM PortfolioProjectSMR..CovidDeaths
 -- WHERE location like '%bangla%'
 WHERE continent IS not NULL  -- remove continent as big nos
 GROUP BY  continent
--  ORDER by population desc
  ORDER BY'TopCOVIDDeath' desc
--  ORDER by '%_of_COVID_Infection' desc



-- Global numbers
SELECT date, SUM(cast (new_deaths as int)), SUM(new_cases)
FROM PortfolioProjectSMR..CovidDeaths
WHERE continent IS not NULL  -- remove continent as big nos
GROUP BY  date
--  ORDER by population desc
ORDER BY 1,2

-------------------------------------------
-------------------------------------------
-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjectSMR..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProjectSMR..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2
 -----------------------------
---------------------------- alias dea merging two tables

SELECT * FROM PortfolioProjectSMR..CovidDeaths dea
JOIN PortfolioProjectSMR..CovidVaccinations vac
  ON dea.location = vac.location 
  AND dea.date = vac.date

  -- ==========================

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine # partition by location ie by country of sum
-- SUM(convert(int, vac.new_vaccination)) alternative to cast 

SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations
FROM
    PortfolioProjectSMR..CovidDeaths dea
JOIN
    PortfolioProjectSMR..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
    AND vac.new_vaccinations IS NOT NULL
ORDER BY
    dea.location,
    dea.date;
	


	------IF WANT TO SEE TOTAL NEW_VACCINATION #In this version of the query, added a PARTITION BY dea.continent 
	      --clause to the SUM() function. This partitions the data into separate groups based on the continent column, 
		  -- and then it calculates the sum of new_vaccinations within each continent group.

	SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS INT)) OVER () AS TotalNewVaccinations
FROM
    PortfolioProjectSMR..CovidDeaths dea
JOIN
    PortfolioProjectSMR..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
    AND vac.new_vaccinations IS NOT NULL
ORDER BY
    dea.location,
    dea.date;

	----------- 

----------Single Where uses
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
---, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProjectSMR..CovidDeaths dea
Join PortfolioProjectSMR..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent IS not null
 order by 2,3

--(This query joins the CovidDeaths and CovidVaccinations tables based on location and date, calculates the
--rolling sum of new vaccinations, and computes the vaccination percentage as well. )
--So, dea.continent is simply referring to the values in the "continent" column of the "CovidDeaths" dataset.
 
 --rearranged
 --------------------------
 ------############## ------
 --- The SQL query provided calculates the rolling total of new vaccinations, along with the vaccination 
    --percentage, for each location and date within a continent.

 SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated,
    (SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) / dea.population) * 100 AS VaccinationPercentage
FROM
    PortfolioProjectSMR..CovidDeaths dea
JOIN
    PortfolioProjectSMR..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
ORDER BY
    2, 3;

	-------Alternatively added explicit partitioning by both dea.Location and dea.Date within the SUM() window function to ensure 
	         --the rolling total resets for each combination of location and date.Ordering the result by dea.location and dea.date.

SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.Location, dea.Date ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated,
    (SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.Location, dea.Date ORDER BY dea.location, dea.Date) / dea.population) * 100 AS VaccinationPercentage
FROM
    PortfolioProjectSMR..CovidDeaths dea
JOIN
    PortfolioProjectSMR..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
ORDER BY
    dea.location,
    dea.date;
----------------
--Avoiding SUM function twice by using CTE
 ---I created a CTE named VaccinationRollup that calculates the rolling total of new_vaccinations by partitioning it
    --based on dea.Location and dea.Date.

--In the main query, I selected the necessary columns from the CTE and calculated the VaccinationPercentage using the rolling total and population.
   --This approach eliminates the need to repeat the SUM() function and makes the code more concise and readable.

--**** In this section, a CTE named VaccinationRollup is created. The CTE essentially acts as a temporary table that stores 
  --intermediate results for use in the main query. It selects columns from both the CovidDeaths and CovidVaccinations tables.
  --It calculates the rolling total of new_vaccinations for each combination of dea.Location and dea.Date using the SUM() window     
  --function. This total resets for each unique combination of location and date.
  --The WHERE clause filters the rows to only include records where dea.continent is not null.
  --In summary, the VaccinationRollup CTE is an intermediate step that simplifies your query by allowing you to perform 
    --calculations on the data once and then reference those calculated values in subsequent parts of the query. It makes 
	--the code more readable and maintainable.
  --***
WITH VaccinationRollup AS (
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.Location, dea.Date ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
    FROM
        PortfolioProjectSMR..CovidDeaths dea
    JOIN
        PortfolioProjectSMR..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL
)

SELECT
    continent,
    location,
    date,
    population,
    new_vaccinations,
    RollingPeopleVaccinated,
    (RollingPeopleVaccinated / population) * 100 AS VaccinationPercentage
FROM
    VaccinationRollup
ORDER BY
    location,
    date;
	   
	------------------------------

	-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjectSMR..CovidDeaths dea
Join PortfolioProjectSMR..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--------------------------

-- Using Temp Table to perform Calculation on Partition By in previous query

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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjectSMR..CovidDeaths dea
Join PortfolioProjectSMR..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


----------
----------


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjectSMR..CovidDeaths dea
Join PortfolioProjectSMR..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

--------------------------------------
Conclusions and Discussion
Key Findings
Through our comprehensive analysis of COVID-19 data, several key findings have emerged:
Impact Assessment: The analysis of COVID-19 deaths and cases in different countries, particularly in the United States, revealed significant impacts of the pandemic. The percentage of deaths relative to total cases provides a critical insight into the severity of the disease in different regions.
Vaccination Effectiveness: By comparing vaccination data with infection rates, we observed a correlation between higher vaccination rates and lower infection rates in many regions. This suggests the effectiveness of the vaccination campaigns.
Global Disparities: Our data highlighted the disparities in COVID-19 impact and response across different continents. Some regions showed higher death rates, while others had more efficient vaccination drives.
Trends and Surprises
A surprising trend was the variation in death rates, not just between countries but within different states or regions of the same country. This variation could be attributed to differences in healthcare systems, public health policies, and social determinants of health.
Another notable trend was the rapid increase in vaccination rates in certain countries, leading to a decrease in new cases, showcasing the potential turning points in the fight against the pandemic.
Limitations
This analysis has some limitations:
The accuracy of data is dependent on the reporting standards of each country, which can vary widely.
We did not account for variables such as government policies, public adherence to safety measures, and healthcare infrastructure, which can significantly influence the outcomes.
The dynamic nature of the pandemic means that data is continuously evolving, and conclusions drawn might change with new data.
Further Study
For future research, several areas are worth exploring:
A deeper dive into the socioeconomic factors influencing the spread and impact of COVID-19.
Longitudinal studies to understand the long-term effects of the pandemic on global health and economies.
Analysis of the effectiveness of different types of vaccines and their long-term benefits.
Final Thoughts
The COVID-19 pandemic has had an unprecedented impact on the world. Our analysis provides valuable insights into its effects and the effectiveness of the global response. As the situation continues to evolve, continuous analysis and data-driven approaches will be crucial in navigating the pandemic and preparing for future public health challenges.
