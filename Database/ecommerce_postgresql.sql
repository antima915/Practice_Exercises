-- Create Table for Employee Details
CREATE TABLE employee(
	e_id SERIAL PRIMARY KEY,
	e_name VARCHAR(30),
	role VARCHAR(30),
	permissions VARCHAR(30)
);
-- Create Table for Product,Category information
CREATE TABLE product(
	p_id SERIAL PRIMARY KEY,
	p_name VARCHAR(30),
	category VARCHAR(30)
);
-- Create Table for all Orders information
CREATE TABLE orders(
	order_id SERIAL PRIMARY KEY,
	product_order_id INT REFERENCES product(p_id),
	order_name VARCHAR(30),
	order_created TIMESTAMP 
);

-- Create a table for managing all the updation and deletion of orders table 
 CREATE TABLE order_invoices(
 	invoice_id SERIAL PRIMARY KEY,
	order_id INT NOT NULL,
	order_name VARCHAR(30) ,
	order_change TIMESTAMP NOT NULL
 );
 
-- Insert Some random data for employee, product and orders table
INSERT INTO employee(e_name, role, permissions) VALUES('Antima Jain','Super Admin','Execute'),
 													   ('Tomas Alfredson','Admin','Write'),
													   ('Paul Anderson','Host','Write');
INSERT INTO product (p_name,category) VALUES('T-shirt','Clothing'),
											('Nike Shoes','Footware'),
											('Bracelet','Accessories'),
											('Jeans','Clothing'),
											('LipBalm','Makeup');

INSERT INTO orders(product_order_id,order_name,order_created) VALUES(2,'Nike Shoes',now()),
													                (4,'Jeans',now()),
													                (5,'LipBalm',now());

-- Create a View for showing the Category of products using the order id
CREATE OR REPLACE VIEW category_details
AS 
select product.p_name,product.category 
from product
INNER JOIN orders 
ON product.p_id = orders.product_order_id

-- Using the view
select * from category_details

-- Trigger function for updation and deletion of the orders table records
CREATE OR REPLACE FUNCTION fn_order_invoices()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS 
	$$
		BEGIN
			IF (TG_OP = 'UPDATE') THEN
				IF NEW.order_name <> OLD.order_name THEN
					INSERT INTO order_invoices(order_id,order_name,order_change)
					VALUES(OLD.order_id,OLD.order_name,OLD.order_created);
				END IF;
				RETURN NEW;
			ELSEIF (TG_OP = 'DELETE') THEN
				INSERT INTO order_invoices(order_id,order_name,order_change)
				VALUES(OLD.order_id,OLD.order_name,OLD.order_created);
				RETURN OLD;
			END IF;			
		END;
	$$

CREATE TRIGGER trigger_order_invoices
BEFORE UPDATE OR DELETE 
ON orders
FOR EACH ROW
EXECUTE PROCEDURE fn_order_invoices();

-- Use the trigger by updating or deleting any row
update orders set order_name = 'Adidas Shoes' where order_id = 1
delete from orders where order_id = 4

-- To see all the rows of the tables
select * from employee
select * from product
select * from orders
select * from order_invoices
