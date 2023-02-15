

--Cleaning data so it's possible to convert from VARCHAR to INT
UPDATE covid_vaccines SET new_vaccinations=NULL WHERE covid_vaccines.new_vaccinations=''
UPDATE covid_vaccines SET total_tests=NULL WHERE covid_vaccines.total_tests=''
UPDATE covid_vaccines SET new_tests=NULL WHERE covid_vaccines.new_tests=''
UPDATE covid_vaccines SET total_tests_per_thousand=NULL WHERE covid_vaccines.total_tests_per_thousand=''
UPDATE covid_vaccines SET new_tests_per_thousand=NULL WHERE covid_vaccines.new_tests_per_thousand=''
UPDATE covid_vaccines SET new_tests_smoothed=NULL WHERE covid_vaccines.new_tests_smoothed=''
UPDATE covid_vaccines SET new_tests_smoothed_per_thousand=NULL WHERE covid_vaccines.new_tests_smoothed_per_thousand=''
UPDATE covid_vaccines SET positive_rate=NULL WHERE covid_vaccines.positive_rate=''
UPDATE covid_vaccines SET tests_per_case=NULL WHERE covid_vaccines.tests_per_case=''
UPDATE covid_vaccines SET tests_units=NULL WHERE covid_vaccines.tests_units=''
UPDATE covid_vaccines SET total_vaccinations=NULL WHERE covid_vaccines.total_vaccinations=''
UPDATE covid_vaccines SET people_vaccinated=NULL WHERE covid_vaccines.people_vaccinated=''
UPDATE covid_vaccines SET people_fully_vaccinated=NULL WHERE covid_vaccines.people_fully_vaccinated=''
UPDATE covid_vaccines SET total_boosters=NULL WHERE covid_vaccines.total_boosters=''
UPDATE covid_vaccines SET new_vaccinations_smoothed=NULL WHERE covid_vaccines.new_vaccinations_smoothed=''
UPDATE covid_vaccines SET total_vaccinations_per_hundred=NULL WHERE covid_vaccines.total_vaccinations_per_hundred=''
UPDATE covid_vaccines SET people_vaccinated_per_hundred=NULL WHERE covid_vaccines.people_vaccinated_per_hundred=''
UPDATE covid_vaccines SET people_fully_vaccinated_per_hundred=NULL WHERE covid_vaccines.people_fully_vaccinated_per_hundred=''
UPDATE covid_vaccines SET total_boosters_per_hundred=NULL WHERE covid_vaccines.total_boosters_per_hundred=''
UPDATE covid_vaccines SET new_vaccinations_smoothed_per_million=NULL WHERE covid_vaccines.new_vaccinations_smoothed_per_million=''
UPDATE covid_vaccines SET new_people_vaccinated_smoothed=NULL WHERE covid_vaccines.new_people_vaccinated_smoothed=''
UPDATE covid_vaccines SET new_people_vaccinated_smoothed_per_hundred=NULL WHERE covid_vaccines.new_people_vaccinated_smoothed_per_hundred=''
UPDATE covid_vaccines SET extreme_poverty=NULL WHERE covid_vaccines.extreme_poverty=''
UPDATE covid_vaccines SET female_smokers=NULL WHERE covid_vaccines.female_smokers=''
UPDATE covid_vaccines SET male_smokers=NULL WHERE covid_vaccines.male_smokers=''
UPDATE covid_vaccines SET excess_mortality_cumulative_absolute=NULL WHERE covid_vaccines.excess_mortality_cumulative_absolute=''
UPDATE covid_vaccines SET excess_mortality_cumulative=NULL WHERE covid_vaccines.excess_mortality_cumulative=''
UPDATE covid_vaccines SET excess_mortality=NULL WHERE covid_vaccines.excess_mortality=''
UPDATE covid_vaccines SET excess_mortality_cumulative_per_million=NULL WHERE covid_vaccines.excess_mortality_cumulative_per_million=''


--Converting data from VARCHAR to appropriate datatype (bigint,float4)


ALTER TABLE covid_vaccines
	ALTER COLUMN new_vaccinations TYPE bigint USING new_vaccinations::bigint,
	ALTER COLUMN total_tests TYPE bigint USING total_tests::bigint,
	ALTER COLUMN new_tests TYPE bigint USING new_tests::bigint,
	ALTER COLUMN total_tests_per_thousand TYPE float4 USING total_tests_per_thousand::float4,
	ALTER COLUMN new_tests_per_thousand TYPE float4 USING new_tests_per_thousand::float4,
	ALTER COLUMN new_tests_smoothed TYPE bigint USING new_tests_smoothed::bigint,
	ALTER COLUMN new_tests_smoothed_per_thousand TYPE float4 USING new_tests_smoothed_per_thousand::float4,
	ALTER COLUMN positive_rate TYPE float4 USING positive_rate::float4,
	ALTER COLUMN tests_per_case TYPE float4 USING tests_per_case::float4,
	ALTER COLUMN total_vaccinations TYPE bigint USING total_vaccinations::bigint,
	ALTER COLUMN people_vaccinated TYPE bigint USING people_vaccinated::bigint,
	ALTER COLUMN people_fully_vaccinated TYPE bigint USING people_fully_vaccinated::bigint,
	ALTER COLUMN total_boosters TYPE bigint USING total_boosters::bigint,
	ALTER COLUMN new_vaccinations_smoothed TYPE bigint USING new_vaccinations_smoothed::bigint,
	ALTER COLUMN total_vaccinations_per_hundred TYPE float4 USING total_vaccinations_per_hundred::float4,
	ALTER COLUMN people_vaccinated_per_hundred TYPE float4 USING people_vaccinated_per_hundred::float4,
	ALTER COLUMN people_fully_vaccinated_per_hundred TYPE float4 USING people_fully_vaccinated_per_hundred::float4,
	ALTER COLUMN total_boosters_per_hundred TYPE float4 USING total_boosters_per_hundred::float4,
	ALTER COLUMN new_vaccinations_smoothed_per_million TYPE bigint USING new_vaccinations_smoothed_per_million::bigint,
	ALTER COLUMN new_people_vaccinated_smoothed TYPE bigint USING new_people_vaccinated_smoothed::bigint,
	ALTER COLUMN new_people_vaccinated_smoothed_per_hundred TYPE float4 USING new_people_vaccinated_smoothed_per_hundred::float4,
	ALTER COLUMN extreme_poverty TYPE float4 USING extreme_poverty::float4,
	ALTER COLUMN female_smokers TYPE float4 USING female_smokers::float4,
	ALTER COLUMN male_smokers TYPE float4 USING male_smokers::float4,
	ALTER COLUMN excess_mortality_cumulative_absolute TYPE float4 USING excess_mortality_cumulative_absolute::float4,
	ALTER COLUMN excess_mortality_cumulative TYPE float4 USING excess_mortality_cumulative::float4,
	ALTER COLUMN excess_mortality TYPE float4 USING excess_mortality::float4,
	ALTER COLUMN excess_mortality_cumulative_per_million TYPE float4 USING excess_mortality_cumulative_per_million::float4;
	
	



--confimation data was injected properly

SELECT *
FROM covid_deaths
ORDER BY 3,4;

--SELECT *
--FROM covid_vaccines
--ORDER BY 3,4;

-- Select Data that we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
ORDER BY 1,2;


-- Looking at Total Cases vs Total Deaths
-- Shows what percentage died of covid when contracting the disease
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases::NUMERIC)*100 AS death_percentage
FROM covid_deaths
--WHERE location LIKE '%States'
ORDER BY 1,2;


--Looking at countries with highest infection rates compared to population
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population::NUMERIC)*100) AS percent_of_population_infected
FROM covid_deaths
GROUP BY location, population
ORDER BY percent_of_population_infected DESC;


--Showing Countries with the highest death count per population
SELECT location, MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE continent <> ''
AND total_deaths IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;


--Highest death count in one day USA
SELECT LOCATION,Max(new_deaths) AS deaths_in_single_day
FROM covid_deaths
WHERE LOCATION LIKE '%States'
GROUP BY LOCATION;

--Highest death count in one day Canada
SELECT LOCATION,Max(new_deaths) AS deaths_in_single_day
FROM covid_deaths
WHERE LOCATION LIKE '%Canada'
GROUP BY LOCATION;


--deaths recorded by China on dates descending
SELECT LOCATION,date,MAX(new_deaths) AS deaths_recorded_on_date
FROM covid_deaths
WHERE LOCATION = 'China'
AND new_deaths IS NOT NULL
GROUP BY LOCATION, date
ORDER BY MAX(new_deaths) DESC;


--Stats based on continent
SELECT location, MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE total_deaths IS NOT NULL
AND continent = ''
AND location NOT LIKE '%income'
GROUP BY location
ORDER BY total_death_count DESC;

--GLOBAL NUMBERS (World)
SELECT location, population, total_cases,new_cases, total_deaths, new_deaths
FROM covid_deaths
WHERE location = 'World';



--Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS rolling_vaccinations
, (rolling_vaccinations/population)*100
FROM covid_deaths AS dea	
JOIN covid_vaccines AS vac	
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent <> ''
ORDER BY 2,3;





--USE CTE

WITH popvsvac (continent, location, date, population, new_vaccinations, rolling_vaccinations)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS rolling_vaccinations
FROM covid_deaths AS dea	
JOIN covid_vaccines AS vac	
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent <> ''
AND dea.location = 'Canada'
)
SELECT*, (rolling_vaccinations/population)*100
FROM popvsvac



--TEMP TABLE

DROP TABLE IF EXISTS percent_population_vaccinated
CREATE TABLE percent_population_vaccinated
(
continent varchar(255),
location varchar(255),
date date,
population NUMERIC,
new_vaccinations NUMERIC,
rolling_people_vaccinated NUMERIC
)


INSERT INTO percent_population_vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS rolling_people_vaccinated
FROM covid_deaths AS dea	
JOIN covid_vaccines AS vac	
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent <> ''

SELECT*, (rolling_people_vaccinated/population)*100
FROM percent_population_vaccinated



--Creating view to store data for later visualizations

DROP VIEW IF EXISTS percent_population_vaccinated
CREATE VIEW percent_population_vaccinated AS
SELECT dea.continent, dea.LOCATION, dea.date, dea.population, vac.new_vaccinations
,SUM(new_vaccinations) OVER (PARTITION BY dea.LOCATION ORDER BY dea.LOCATION,
dea.date) AS rolling_vaccinations
FROM covid_deaths AS dea	
JOIN covid_vaccines AS vac	
	ON dea.LOCATION = vac.LOCATION
	AND dea.date = vac.date
WHERE dea.continent <> '';


SELECT *
FROM percent_population_vaccinated
