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

-- Create a table for managing all the updation and deletion of employee table 
 CREATE TABLE employee_invoices(
	invoice_id SERIAL PRIMARY KEY,
	e_id INT NOT NULL,
	e_name VARCHAR(30),
	role VARCHAR(30),
	permissions VARCHAR(30)
); 

-- Create a table for managing all the updation and deletion of product table 
CREATE TABLE product_invoices(
	invoice_id SERIAL PRIMARY KEY,
	p_id INT NOT NULL,
	p_name VARCHAR(30),
	category VARCHAR(30)
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

-- VIEWS
-- Create a View for showing the Category of products using the order id
CREATE OR REPLACE VIEW category_details
AS 
select product.p_name,product.category 
from product
INNER JOIN orders 
ON product.p_id = orders.product_order_id

-- Using the view
select * from category_details

-- TRIGGERS
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

-- Trigger function for updation and deletion of the employee table records
CREATE OR REPLACE FUNCTION fn_employee_invoices()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
	$$
		BEGIN
			IF (TG_OP = 'UPDATE') THEN
				IF NEW.e_name <> OLD.e_name OR 
				   NEW.role <> OLD.role OR 
				   NEW.permissions <> OLD.permissions THEN
					
					INSERT INTO employee_invoices(e_id,e_name,role,permissions)
					VALUES(OLD.e_id,OLD.e_name,OLD.role,OLD.permissions);
				
				END IF;
				RETURN NEW;
			ELSEIF (TG_OP = 'DELETE') THEN
				INSERT INTO employee_invoices(e_id,e_name,role,permissions)
				VALUES(OLD.e_id,OLD.e_name,OLD.role,OLD.permissions);
				RETURN OLD;
			END IF;
		END;
	$$

CREATE TRIGGER trigger_employee_invoices
BEFORE UPDATE OR DELETE 
ON employee
FOR EACH ROW
EXECUTE PROCEDURE fn_employee_invoices();

-- Use the trigger by updating or deleting any row
update employee set role = 'Co-Host' where e_id = 2
delete from employee where e_id = 3

-- Trigger function for updation and deletion of the product table records
CREATE OR REPLACE FUNCTION fn_product_invoices()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
	$$
		BEGIN
			IF (TG_OP = 'UPDATE') THEN
				IF NEW.p_name <> OLD.p_name OR 
				   NEW.category <> OLD.category THEN
				   
					INSERT INTO product_invoices(p_id,p_name,category)
					VALUES(OLD.p_id,OLD.p_name,OLD.category);
					
				END IF;
				RETURN NEW;
			ELSEIF (TG_OP = 'DELETE') THEN
				INSERT INTO product_invoices(p_id,p_name,category)
					VALUES(OLD.p_id,OLD.p_name,OLD.category);
				RETURN OLD;
			END IF;
		END;
	$$

CREATE TRIGGER trigger_product_invoices
BEFORE UPDATE OR DELETE 
ON product
FOR EACH ROW
EXECUTE PROCEDURE fn_product_invoices();

-- Use the trigger by updating or deleting any row
update product set category = 'Jewellery' where p_id = 3
delete from product where p_id = 5

-- To see all the rows of the tables
select * from employee
select * from product
select * from orders
select * from order_invoices
select * from employee_invoices
select * from product_invoices
