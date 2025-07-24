# 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(inventory_id)
FROM inventory
WHERE film_id = (SELECT film_id
				FROM film
                WHERE title = "Hunchback Impossible");

# 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT *
FROM film
WHERE length > (SELECT AVG(length)
				FROM film);
                
# 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT *
FROM actor
WHERE actor_id IN (SELECT actor_id
					FROM film_actor
                    WHERE film_id = (SELECT film_id
									 FROM film
                                     WHERE title = "Alone Trip"));

# BONUS:
# 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films. 
SELECT title, description
FROM film
WHERE film_id IN (SELECT film_id
				  FROM film_category
                  WHERE category_id = (SELECT category_id
									   FROM category
                                       WHERE name = "family"));

# 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
# To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (SELECT address_id
					FROM address
                    INNER JOIN city USING(city_id)
                    INNER JOIN country USING(country_id)
                    WHERE country = "canada");

# 6. Determine which films were starred by the most prolific actor in the Sakila database. 
# A prolific actor is defined as the actor who has acted in the most number of films. 
# First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT title
FROM film
WHERE film_id IN (SELECT film_id
				  FROM film_actor
                  WHERE actor_id IN (SELECT actor_id
									  FROM film_actor
									  GROUP BY actor_id
									  HAVING COUNT(film_id) > (SELECT AVG(a.film_count)
															  FROM (SELECT COUNT(film_id) AS film_count, actor_id
																	FROM film_actor
																	GROUP BY actor_id) AS a)));
                  


                                    

# 7. Find the films rented by the most profitable customer in the Sakila database. 
# You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_ID = (SELECT a.customer_id
					 FROM (SELECT customer_id, SUM(amount) as total_paid
						   FROM payment
						   GROUP BY customer_id
						   ORDER BY total_paid DESC
						   LIMIT 1) AS a);

# 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
# You can use subqueries to accomplish this.
SELECT customer_id, SUM(amount) AS total_amout_spend
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (SELECT AVG(a.total_amount)
					 FROM (SELECT SUM(amount) AS total_amount
						  FROM payment
						  GROUP BY customer_id) AS a);