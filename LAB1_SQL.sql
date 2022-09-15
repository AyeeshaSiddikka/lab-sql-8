

-- 1.Use sakila database.
USE sakila;

-- 2.Get all the data from tables actor, film and customer.
SELECT 
    *
FROM
    actor;
SELECT 
    *
FROM
    film;
SELECT 
    *
FROM
    customer;
-- 3.Get film titles.    

SELECT title
FROM
    film;
    
-- 4.Get unique list of film languages under the alias language. 
-- Note that we are not asking you to obtain the language per each film
-- but this is a good time to think about how you might get that information in the future.

SELECT distinct language_id from film;


-- 5.1 Find out how many stores does the company have?
SELECT count(store_id) from store;
   
    
    -- 5.2 Find out how many employees staff does the company have?
    
    SELECT COUNT(staff_id)
FROM staff;
    
    -- 5.3 Return a list of employee first names only?

SELECT staff_id,
FROM staff
    where in first_name ;

   
    
/*Lab | SQL Queries - Lesson 2.5 */

use sakila;
-- 1.Select all the actors with the first name ‘Scarlett’.

 select * from actor where first_name = 'Scarlett';
 
 -- 2.How many films (movies) are available for rent and how many films have been rented?
SELECT COUNT(title) FROM sakila.film; 
 

 -- 3.What are the shortest and longest movie duration? Name the values max_duration and min_duration.

SELECT MAX(length) as max_duration ,MIN(length) as min_duration from sakila.film;


-- 4.What's the average movie duration expressed in format (hours, minutes)?
-- SELECT avg(length) as avg_movie_duration from sakila.film; 
SELECT concat(floor((AVG(length))/60),":",round((AVG(length))%60,0)) AS "average_length" FROM sakila.film;
      
-- 5.How many distinct (different) actors' last names are there?

select count(distinct last_name) from actor;


-- 6.Since how many days has the company been operating (check DATEDIFF() function)?
SELECT DATEDIFF(MAX(last_update), MIN(rental_date))
FROM sakila.rental;


-- 8.Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.

-- SELECT * ,DAYNAME(return_date) as day_type from rental;

SELECT *,
CASE
WHEN DAYNAME(rental_date) = 'Monday' then 'Workday'
WHEN DAYNAME(rental_date) = 'Tuesday' then 'Workday'
WHEN DAYNAME(rental_date) = 'Wednesday' then 'Workday'
WHEN DAYNAME(rental_date) = 'Thursday' then 'Workday'
WHEN DAYNAME(rental_date) = 'Friday' then 'Workday'
WHEN DAYNAME(rental_date) = 'Saturday' then 'Weekend'
WHEN DAYNAME(rental_date) = 'Sunday' then 'Weekend'
ELSE 'No info'
END AS 'day_type', DAYNAME(rental_date) AS 'weekday'
FROM sakila.rental;
-- 9.Get release years.

SELECT title, release_year as 'release years' FROM sakila.film;



-- 10.Get all films with ARMAGEDDON in the title.

select film_id,title from film where title like '%ARMAGEDDON%';


-- 11.Get all films which title ends with APOLLO.
select film_id,title from film where title like '%APOLLO';

-- 12.Get 10 the longest films.
SELECT title, length FROM sakila.film
ORDER BY length DESC
LIMIT 10;
​

-- 13.How many films include Behind the Scenes content?

 select film_id,special_features from film where special_features like '%Behind the scenes%';
 
 /*Lab | SQL Queries - Lesson 2.6*/
 -- 1.In the table actor, which are the actors whose last names are not repeated?
  -- For example if you would sort the data in the table actor by last_name,
 -- you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. 
 -- These three actors have the same last name. So we do not want to include this last name in our output. 
 -- Last name "Astaire" is present only one time with actor "Angelina Astaire", hence we would want this in our output list.
 
 select last_name from actor group by last_name having count(last_name) = 1;
 
 
 -- 2.Which last names appear more than once? We would use the same logic as in the previous question 
 -- but this time we want to include the last names of the actors 
 -- where the last name was present more than once
 
 select last_name from actor group by last_name having count(last_name) > 1;
 
 -- 3.Using the rental table, find out how many rentals were processed by each employee.
 

 
 
 select staff_id from rental group by staff_id having count(rental_id);
 
 -- 4.Using the film table, find out how many films were released each year.
 


 select film_id,count(release_year) from film  group by (release_year);
 
 -- 5.Using the film table, find out for each rating how many films were there.


SELECT rating, COUNT(rating) AS 'number' FROM film GROUP BY rating;

 
 -- 6.What is the mean length of the film for each rating type. Round off the average lengths to two decimal places
 
 select rating, round(avg(length),2)as Average_length
from film 
group by rating;



 -- 7.Which kind of movies (rating) have a mean duration of more than two hours?
 
SELECT rating, AVG(length) FROM sakila.film
GROUP BY rating
HAVING AVG(length) > 120
ORDER BY rating ASC;


 
 -- 8.Rank films by length (filter out the rows that have nulls or 0s in length column).
 
 -- In your output, only select the columns title, length, and the rank.
 
SELECT title, length, RANK() OVER (ORDER BY length DESC) length_rank FROM sakila.film
WHERE length <> ' ' OR length <> '0';
 
 
 
 
 
 /*Lab | SQL Join (Part I)*/
 use sakila;
 -- 1.How many films are there for each of the categories in the category table. Use appropriate join to write this query.
 
 -- 2.Display the total amount rung up by each staff member in August of 2005.
select first_name, last_name, sum(p.amount) as total_amount
from payment p
join staff s
where p.staff_id = s.staff_id and year(payment_date) = 2005 and month(payment_date) = 8
group by first_name;

    


