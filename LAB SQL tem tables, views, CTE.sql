USE sakila;

-- creating a view summarizes rental information for each customer.
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_info_customer AS 
SELECT c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.rental_id) AS rental_count
FROM sakila.customer c
JOIN sakila.rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;


-- Step 2: Create a Temporary Table calculating the total amount paid by each customer (total_paid).
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE temporary table total_paid AS
SELECT rif.*, SUM(p.amount) AS "total_amount_paid" 
FROM rental_info_customer rif
JOIN payment p ON rif.customer_id = p.customer_id
GROUP BY rif.customer_id;

SELECT * FROM total_paid;
SELECT * FROM rental_info_customer;

-- Step 3: Create a CTE and the Customer Summary Report that joins the rental summary View with the customer payment summary Temporary Table created in Step 2.
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
-- Next, using the CTE, create the query to generate the final customer summary report, which should include:
	-- customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.
    
WITH cte AS (
	SELECT rif.first_name, rif.last_name, rif.email, rif.rental_count, tp.total_amount_paid
	FROm rental_info_customer rif
	JOIN total_paid tp ON tp.customer_id = rif.customer_id
)
SELECT *, ROUND(total_amount_paid/ NULLIF(rental_count,0),2) AS average_payment_per_rental
FROM cte;
