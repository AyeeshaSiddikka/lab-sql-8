

/*Lab | SQL Join (Part II)(lab-sql-8)*.../
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

