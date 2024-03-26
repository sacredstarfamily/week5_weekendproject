CREATE TABLE sales_person (
    associate_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    num_sales INT
);
CREATE TABLE customer (
	customer_id SERIAL PRIMARY KEY,
	first_name varchar,
	last_name varchar,
	email varchar 
);
CREATE TABLE vehicle(
	vin_number varchar PRIMARY KEY,
	vehicle_make varchar,
	vehicle_model varchar,
	vehicle_year integer,
	last_service_date timestamp,
	vehicle_owner integer
);
CREATE TABLE sale (
	sale_id SERIAL PRIMARY KEY,
	customer_id integer,
	associate_id integer,
	vin_number varchar,
	sale_date timestamp,
	price integer,
	FOREIGN KEY (associate_id) REFERENCES sales_person(associate_id),
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
	FOREIGN KEY (vin_number) REFERENCES vehicle(vin_number)
);
CREATE TABLE mechanic(
	mechanic_id serial PRIMARY KEY,
	first_name varchar,
	last_name varchar,
	phone varchar
);
CREATE TABLE service_history(
	service_id serial PRIMARY KEY,
	mechanic_id integer,
	vin_number varchar,
	service_date timestamp,
	FOREIGN KEY (vin_number)REFERENCES vehicle(vin_number),
	FOREIGN KEY (mechanic_id) REFERENCES mechanic(mechanic_id)
);

CREATE OR REPLACE PROCEDURE vehicle_sale(
    p_customer_id INTEGER,
    p_associate_id INTEGER,
    p_vin_number VARCHAR,
    p_price INTEGER
) 
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO sale (customer_id, associate_id, vin_number, sale_date, price)
    VALUES (p_customer_id, p_associate_id, p_vin_number, current_timestamp, p_price);
    UPDATE sales_person
    SET num_sales = num_sales + 1
    WHERE associate_id = p_associate_id;
   	UPDATE vehicle 
   	SET vehicle_owner = p_customer_id
   	WHERE vin_number = p_vin_number;
END;
$$;

CREATE OR REPLACE PROCEDURE service_vehicle(
    p_vin_number VARCHAR,
    p_mechanic_id integer
) 
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO service_history (mechanic_id, vin_number, service_date)
    VALUES (p_mechanic_id, p_vin_number,current_timestamp);
    UPDATE vehicle 
    SET last_service_date = current_timestamp 
    WHERE vin_number = p_vin_number;
END;
$$;
CALL vehicle_sale(1, 1, '234234234bng234', 2); 
CALL service_vehicle(:p_vin_number, :p_mechanic_id);


