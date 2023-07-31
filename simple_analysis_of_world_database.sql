# select database
use world;

# Retrieve all columns for all rows from the "city" table.select count(*) from city;
SELECT count(*) as No_of_Column
 FROM information_schema. columns 
WHERE table_name ='city' ;

# Retrieve the country names and their corresponding continents from the "country" table.
select name,continent from country;
select count(distinct name,continent ) from country;

# Retrieve the languages spoken in each country from the "countrylanguage" table.
select country.Name , countrylanguage.Language
from country 
join countrylanguage on country.Code = countrylanguage.CountryCode;

# Retrieve the names and populations of all cities in a specific district.
select Name as District, District as state,Population
 from city;

#Unique names and count 
select count(distinct Name)  from city;
select count(distinct Region) from country;
select count(distinct Language) from countrylanguage;

#Using Aggregation function
#check null elements in region before performing aggregate function
select LifeExpectancy,Region from country where LifeExpectancy is null;
select avg(LifeExpectancy) as average_LifeExpectancy_of_world 
from country;
select stddev(LifeExpectancy) as standard_deviation_of_LifeExpectancy 
from country; 

#Calculate the total population of a specific country by summing the population of its cities.
SELECT country.name AS country_name, 
       SUM(city.population) AS total_population
FROM country
JOIN city ON country.Code = city.countrycode
GROUP BY country.name;

# Find the average surface area of countries in a particular continent.
select continent,
	avg(SurfaceArea) as avg_surface_area
    from country
    where continent = "Asia"
    group by continent;
    
# Find the average surface area of countries in all continent.
SELECT continent,
       AVG(surfacearea) AS avg_surface_area
FROM country
GROUP BY continent;

# Calculate the total percentage of official languages spoken in a specific country
select c.name,
	sum(percentage) as total_percentage
	from countrylanguage as cl
    join country as c on 
    c.Code = cl.CountryCode
    where c.name = "India"
    group by c.name;
    
# Retrieve the countries with the most diverse languages spoken:
SELECT c.name AS country_name, COUNT(DISTINCT cl.language) AS num_languages
FROM country c
JOIN countrylanguage cl ON c.code = cl.countrycode
GROUP BY c.name
ORDER BY num_languages DESC;

# Retrieve the countries that share the same official languages without duplicates:
SELECT c1.name AS country1, c2.name AS country2,
 cl.language AS official_language
FROM country c1
JOIN countrylanguage cl ON c1.code = cl.countrycode
JOIN country c2 ON c1.code <> c2.code
               AND c2.code = cl.countrycode
               AND cl.isofficial = 'T'
GROUP BY c1.name, c2.name, cl.language
ORDER BY c1.name, c2.name;

# Retrieve the countries with the highest GNP and the highest population in each continent:
SELECT c1.name AS country_name, c1.continent, c1.gnp, c1.population
FROM country c1
WHERE (c1.gnp, c1.population) IN (
    SELECT MAX(gnp), MAX(population)
    FROM country c2
    WHERE c2.continent = c1.continent
    GROUP BY c2.continent
)
UNION
SELECT c3.name AS country_name, c3.continent, c3.gnp, c3.population
FROM country c3
WHERE (c3.gnp, c3.population) IN (
    SELECT MAX(gnp), MAX(population)
    FROM country c4
    WHERE c4.continent = c3.continent
    GROUP BY c4.continent
)
ORDER BY continent, gnp DESC, population DESC;

    
# Retrieve the names and populations of the top 10 most populous cities.
select name,population 
from city 
order by population desc limit 10;

# Find the countries with a surface area greater than a certain value, ordered by surface area in descending order.
select name,SurfaceArea
from country
where surfacearea >= 100000
order by surfacearea desc;

# Retrieve the languages spoken in a specific country where the percentage of speakers is above a given threshold.
select c.name,cl.language,cl.percentage
from country c
join countrylanguage cl
on c.code = cl.countrycode
where percentage > 50;

#Retrieve the names and populations of all cities in a specific country along with their corresponding districts.
select ci.name as city_name,ci.district,ci.population,
	c.name as country_name from country c
    join city ci 
    on ci.countrycode = c.code
    group by ci.name,ci.district,ci.population,c.name;
    
# Find the official languages spoken in each country along with the percentage of speakers.
select c.name as country_name,cl.language,cl.percentage
from country c
join countrylanguage cl 
on c.code = cl.countrycode;

# Calculate the total population of each country and display the results along with the country names.
SELECT name AS country_name,
       SUM(population) AS total_population
FROM country
GROUP BY name;

# Find the average GNP (Gross National Product) of countries in a specific region.
select name  as countrt_name ,
	avg(GNP) as Gross_National_Product 
	from country
	where name = "India"
	group by name;
   
# Find the countries where the head of state has a specific title:
SELECT name AS country_name
FROM country
WHERE code IN (
    SELECT code
    FROM country
    WHERE headofstate = 'Elisabeth II'
);

# Find the country/countries with the highest GNP (Gross National Product):
SELECT name AS country_name, gnp
FROM country
WHERE gnp = (
    SELECT MAX(gnp)
    FROM country
);


# Find the countries that have at least two official languages, and their total population is greater than the average population of cities in a specific country.
SELECT c.name AS country_name, 
SUM(ci.population) AS total_population
FROM country c
JOIN city ci ON c.code = ci.countrycode
WHERE c.code IN (
    SELECT cl.countrycode
    FROM countrylanguage cl
    WHERE cl.isofficial = 'T'
    GROUP BY cl.countrycode
    HAVING COUNT(cl.language) >= 2
)
GROUP BY c.name
HAVING SUM(ci.population) > (
    SELECT AVG(population)
    FROM city
    WHERE countrycode = 'nld'
);

