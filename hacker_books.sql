CREATE DATABASE hbooks;

CREATE TABLE books (
	id SERIAL4 PRIMARY KEY,
	title VARCHAR(250),
	isbn VARCHAR(25),
	link VARCHAR(250),
	user_id INTEGER,
	timestamp INTEGER,
	votes INTEGER
);

CREATE TABLE comments (
	id SERIAL4 PRIMARY KEY,
	book_id INTEGER,
	user_id INTEGER,
	body VARCHAR(500),
	timestamp INTEGER
);

CREATE TABLE users (
	id SERIAL4 PRIMARY KEY,
	name VARCHAR(100),
	email VARCHAR(100),
	password_digest VARCHAR(400) NOT NULL
);

CREATE TABLE votes (
	id SERIAL4 PRIMARY KEY,
	user_id INTEGER,
	book_id INTEGER
);

CREATE TABLE ranks (
	id SERIAL4 PRIMARY KEY,
	book_id INTEGER,
	rank INTEGER
);

# to create new collumns into a  table after creation
ALTER TABLE books ADD timestamp INTEGER;

# to delete a collumns of a table after creation
ALTER TABLE books DROP isbn INTEGER;