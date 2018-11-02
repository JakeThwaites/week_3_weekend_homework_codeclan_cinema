DROP TABLE tickets;
DROP TABLE customers;
DROP TABLE screenings;
DROP TABLE films;



CREATE TABLE films (
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(255),
  price INT4,
  time_showing TIME(4)
);

CREATE TABLE customers (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255),
  funds INT4
);

CREATE TABLE tickets (
  customer_id SERIAL4 REFERENCES customers(id) ON DELETE CASCADE,
  film_id SERIAL4 REFERENCES films(id) ON DELETE CASCADE,
  id SERIAL4 PRIMARY KEY
);

CREATE TABLE screenings (
  film_title VARCHAR(255) REFERENCES films(title) ON DELETE CASCADE,
  film_showing_time TIME(4) REFERENCES films(time_showing) ON DELETE CASCADE,
  id SERIAL4 PRIMARY KEY
);
