
/*lab-intro-sql */

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

select distinct(name) as language from language;


-- 5.1 Find out how many stores does the company have?
select count(distinct store_id) from store;
   
    
    -- 5.2 Find out how many employees staff does the company have?
    
select count(distinct staff_id) from staff;
    
    -- 5.3 Return a list of employee first names only?

select first_name from staff;

   
    
/*Lab | SQL Queries - Lesson 2.5 (dataV3_lesson_2.5_lab) */

use sakila;
-- 1.Select all the actors with the first name ‘Scarlett’.

 select first_name from actor
where first_name = "Scarlett";
 
 -- 2.How many films (movies) are available for rent and how many films have been rented?

SELECT COUNT(*) FROM rental;
SELECT COUNT(*) FROM film;

 -- 3.What are the shortest and longest movie duration? Name the values max_duration and min_duration.

select min(length) as min_duration,max(length) as max_duration from film;


-- 4.What's the average movie duration expressed in format (hours, minutes)?
-- SELECT avg(length) as avg_movie_duration from sakila.film; 
SELECT SEC_TO_TIME(AVG(length)*60) as 'hours and min'
FROM film;
      
-- 5.How many distinct (different) actors' last names are there?

select count(distinct last_name) from actor;


-- 6.Since how many days has the company been operating (check DATEDIFF() function)?
SELECT DATEDIFF(MAX(rental_date), MIN(rental_date)) as 'days_operating'
FROM sakila.rental;


-- 8.Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.

-- SELECT * ,DAYNAME(return_date) as day_type from rental;
SELECT DATE_FORMAT(rental_date,'%M') AS 'month', DATE_FORMAT(rental_date,'%a') AS 'day'
FROM rental
LIMIT 20;

select rental_date,
CASE
WHEN DATE_FORMAT(rental_date,'%a') = 'Sat' then 'weekend'
WHEN DATE_FORMAT(rental_date,'%a') = 'Sun' then 'weekend'
ELSE 'weekday'
END AS column_day_type
FROM rental;

-- 9.Get release years.

SELECT title, release_year as 'release years' FROM sakila.film;



-- 10.Get all films with ARMAGEDDON in the title.

select * from film where title like '%ARMAGEDDON%';


-- 11.Get all films which title ends with APOLLO.
select film_id,title from film where title like '%APOLLO';

-- 12.Get 10 the longest films.
SELECT title, length FROM sakila.film
ORDER BY length DESC
LIMIT 10;

-- 13.How many films include Behind the Scenes content?

 select count(special_features) as 'Behind_the_Scenes_content' from film where special_features like '%Behind the scenes%';
 
 /*Lab | SQL Queries - Lesson 2.6 (dataV3_Lesson_2.6_lab)*/
 
 
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

 SELECT COUNT(rental_id), staff_id
FROM rental
GROUP BY staff_id;
 
 
 
 -- 4.Using the film table, find out how many films were released each year.
 

 select count(film_id), release_year from film 
 group by (release_year);
 
 -- 5.Using the film table, find out for each rating how many films were there.

SELECT COUNT(film_id), rating
FROM film
GROUP BY rating;


 
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
 
 
 
 SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
 
 /* Lab | SQL Join (Part I)(dataV3_Lesson_2.7_lab) */
 
USE sakila;
-- 1. How many films are there for each of the categories in the category table. Use appropriate join to write this query.
SELECT * FROM category;
SELECT * FROM film_category;
SELECT count(film_id) AS 'Films', name AS 'Category'
FROM sakila.category a
JOIN sakila.film_category b
ON a.category_id = b.category_id
GROUP BY name;

-- 2. Display the total amount rung up (payment) by each staff member in August of 2005.
SELECT * FROM sakila.rental;
SELECT * FROM sakila.staff;
SELECT * FROM sakila.payment;
SELECT SUM(amount) AS 'August 2005', first_name AS 'First Name', last_name AS 'Last Name'
FROM sakila.payment a
JOIN sakila.staff b
ON a.staff_id = b.staff_id
WHERE payment_date > '2005-08-01 00:00:01' AND payment_date < '2005-08-30 23:59:59'
GROUP BY first_name;
SELECT SUM(amount) AS 'August 2005', first_name AS 'First Name', last_name AS 'Last Name'
FROM sakila.payment a
JOIN sakila.staff b
ON a.staff_id = b.staff_id
WHERE payment_date > '2005-08-01 00:00:01' AND payment_date < '2005-08-30 23:59:59'
GROUP BY first_name;

-- 3. Which actor has appeared in the most films?
SELECT * FROM sakila.film_actor;
SELECT * FROM sakila.actor;
SELECT count(film_id) AS 'Film appearances', last_name, first_name
FROM sakila.actor a
JOIN sakila.film_actor b
ON a.actor_id = b.actor_id
GROUP BY a.actor_id
ORDER BY count(film_id) DESC;

-- 4. Most active customer (the customer that has rented the most number of films)
SELECT count(rental_id) AS 'Films rented', first_name, last_name
FROM sakila.customer c
JOIN sakila.rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY count(rental_id) DESC;

-- 5. Display the first and last names, as well as the address, of each staff member.
SELECT * FROM sakila.staff;
SELECT first_name AS 'First Name', last_name AS 'Last Name', address AS 'Address1', address2 AS 'Address2', district AS 'District', city_id AS 'City'
FROM sakila.staff s
JOIN sakila.address a
ON s.address_id = a.address_id;

-- 6. List each film and the number of actors who are listed for that film.
SELECT * FROM sakila.film;
SELECT * FROM sakila.film_actor;
SELECT title AS 'Title', count(actor_id) AS 'Number of actors'
FROM sakila.film f
JOIN sakila.film_actor fa USING (film_id)
GROUP BY title;

-- 7. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.
SELECT * FROM sakila.customer;
SELECT * FROM sakila.payment;
SELECT last_name AS 'Last name', first_name AS 'First name', sum(amount) AS 'Total amount paid'
FROM sakila.customer c
JOIN sakila.payment p USING (customer_id)
GROUP BY last_name
ORDER BY last_name ASC;

-- 8. List number of films per category. (identical to first question, ignore)




/*Lab | SQL Join (Part II)(lab-sql-8)*/
use sakila;
-- 1. Write a query to display for each store its store ID, city, and country.
select s.store_id, c.city, ct.country
from store s
join address using(address_id)
join city c using (city_id)
join country ct using (country_id);
-- 2. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(p.amount) as business_value
from payment p
join rental r using (rental_id)
join staff s
where s.staff_id = p.staff_id
group by s.store_id;
-- 3. Which film categories are longest?
select c.name, avg(f.length)
from film f
join film_category fc using (film_id)
join category c using (category_id)
group by c.name
order by avg(length) desc;
-- 4. Display the most frequently rented movies in descending order.
select title
from rental
join inventory using (inventory_id)
join film using (film_id)
group by title
order by count(rental_id) desc;
-- 5. List the top five genres in gross revenue in descending order.
select c.name as genre, sum(p.amount) as 'gross revenue'
from category c
join film_category f using (category_id)
join inventory i using (film_id)
join rental r using (inventory_id)
join payment p using (rental_id)
group by f.category_id
order by sum(p.amount) desc
Limit 5;
-- 6. Is "Academy Dinosaur" available for rent from Store 1?
select
case
when count(i.film_id)>0 then 'Available'
else 'Unavailabe'
end as 'Store availability', count(i.film_id) as 'Quantity'
from film f
join inventory i using(film_id)
join store s using (store_id)
where f.title = "Academy Dinosaur" and s.store_id=1
group by i.film_id;
-- 7. Get all pairs of actors that worked together.
SELECT a1.actor_id as 'Actor 1' , a2.actor_id as 'Actor 2'
FROM film_actor a1
JOIN film_actor a2
ON (a1.film_id = a2.film_id) AND (a1.actor_id <> a2.actor_id);























