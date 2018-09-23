USE sakila;

#1a
SELECT * from actor;

#1b
SELECT UPPER(first_name) from actor;
SELECT UPPER(last_name) from actor;

SELECT CONCAT(first_name,' ', last_name) As 'Actor Name' FROM actor;

#2a
SELECT * from actor where first_name = 'Joe';

#2b
SELECT * from actor where last_name LIKE '%GEN%';

#2c
SELECT last_name,first_name from actor where last_name LIKE '%LI%';

#2d
SELECT country_id,country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a
ALTER TABLE actor
ADD column middle_name VARCHAR(30) AFTER first_name;

#3b
ALTER TABLE actor
MODIFY COLUMN middle_name blob;

#3c
ALTER TABLE actor
DROP COLUMN middle_name;

#4a
SELECT last_name, count(*)
FROM actor
group by last_name;

#4b
SELECT last_name, count(*) 
FROM actor 
group by last_name
HAVING count(*) >= 2;

#4c
SET SQL_SAFE_UPDATES = 0; 
UPDATE actor SET first_name='HARPO' WHERE first_name='GROUCHO' AND last_name='WILLIAMS';
SET SQL_SAFE_UPDATES = 1; 
SELECT * from actor where first_name = 'HARPO';

#4d
SET SQL_SAFE_UPDATES = 0; 
UPDATE actor SET first_name='MUCHO GROUCHO' WHERE first_name='HARPO' AND last_name='WILLIAMS';
SET SQL_SAFE_UPDATES = 1; 
SELECT * from actor where last_name = 'WILLIAMS';

#5a
SHOW CREATE TABLE address;

#6a
SELECT address.address, staff.first_name, staff.last_name
from address 
RIGHT JOIN staff 
ON address.address_id = staff.address_id;

#6b
SELECT sum(payment.amount), staff.first_name, staff.last_name,staff.staff_id
from payment
INNER JOIN staff 
ON payment.staff_id = staff.staff_id
WHERE payment.payment_date LIKE '2005-08-%'
group by staff_id;

#6c
SELECT count(film_actor.actor_id), film.title, film.film_id
from film_actor
INNER JOIN film
ON film.film_id = film_actor.film_id
group by film_id;

#6d
SELECT count(inventory.inventory_id), film.title
from inventory
inner join film
on inventory.film_id = film.film_id
where title = 'Hunchback Impossible';

#6e
SELECT customer.first_name, customer.last_name, sum(payment.amount) as 'Total amount paid'
from payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id
group by payment.customer_id
order by last_name;

#7a
SELECT film.title, language.name
from film
inner join language
on film.language_id=language.language_id
where title like '%K' or '%Q' and 
name = 'english';

#7b
SELECT first_name, last_name
from actor 
where actor_id IN
(SELECT actor_id from film_actor
where film_id IN
(SELECT film_id from film
where title = 'Alone Trip'));

#7c
SELECT customer.first_name, customer.last_name
from customer
inner join address
on address.address_id = customer.address_id
inner join city
on city.city_id= address.city_id
inner join country
on country.country_id=city.country_id
where country = 'canada'

#7d
select title 
from film
where film_id IN
(select film_id 
from film_category
where category_id IN
(select category_id 
from category
where name = 'Family'));

#7e
SELECT inventory.film_id, film_text.title, COUNT(rental.inventory_id)
FROM inventory 
INNER JOIN rental 
ON inventory.inventory_id = rental.inventory_id
INNER JOIN film_text 
ON inventory.film_id = film_text.film_id
GROUP BY rental.inventory_id
ORDER BY COUNT(rental.inventory_id) DESC;

#7f
SELECT store.store_id, SUM(payment.amount)
FROM store
INNER JOIN staff
ON store.store_id = staff.store_id
INNER JOIN payment 
ON payment.staff_id = staff.staff_id
GROUP BY store.store_id
ORDER BY SUM(amount);

#7g
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN customer 
ON store.store_id = customer.store_id
INNER JOIN staff
ON store.store_id = staff.store_id
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id;

#7h
SELECT category.name, SUM(payment.amount)
FROM category
INNER JOIN film_category
ON  category.category_id = film_category.category_id
INNER JOIN inventory 
ON inventory.film_id = film_category.film_id
INNER JOIN rental
ON rental.inventory_id = inventory.inventory_id
INNER JOIN payment
ON payment.customer_id=rental.customer_id
GROUP BY category.name
LIMIT 5;

#8a
CREATE VIEW top_five_grossing_genres AS
SELECT category.name, SUM(payment.amount)
FROM category
INNER JOIN film_category
ON  category.category_id = film_category.category_id
INNER JOIN inventory 
ON inventory.film_id = film_category.film_id
INNER JOIN rental
ON rental.inventory_id = inventory.inventory_id
INNER JOIN payment
ON payment.customer_id=rental.customer_id
GROUP BY category.name
LIMIT 5;

#8b
SELECT * FROM top_five_grossing_genres;

#8c
DROP VIEW top_five_grossing_genres;
