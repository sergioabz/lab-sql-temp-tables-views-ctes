-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_info as (SELECT COUNT(c.customer_id) as number_of_rentals, c.first_name, c.customer_id, c.last_name, c.email FROM sakila.customer as c
JOIN rental as r
ON r.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY number_of_rentals desc);

-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE total_paid as (SELECT SUM(p.amount) as total_paid, p.customer_id, ri.first_name, ri.last_name FROM sakila.payment AS p
JOIN rental_info as ri
ON ri.customer_id = p.customer_id
GROUP BY ri.customer_id);

SELECT* FROM total_paid
ORDER BY total_paid desc;

-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.
WITH summary_rentals as (SELECT total_paid, customer_id FROM total_paid )
SELECT first_name, last_name, email, number_of_rentals, total_paid, (total_paid/number_of_rentals) as average_payment FROM rental_info as ri
JOIN summary_rentals as sr 
ON sr.customer_id = ri.customer_id ;

-- does not work. SELECT * FROM summary_rentals sr JOIN rental_info as ri ON sr.customer_id = ri.customer_id;




-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

