Student Name : Adeshina Ayodele
Task 1 –CRUD Operations 
Exercise 1 - Create Table
CREATE TABLE courses_submit2 (
	course_id serial primary key,
   	course_name varchar(60),
  	course_author varchar(40),
	course_status varchar(10) check (course_status in('published', 'draft', 'inactive')),
	course_published_dt date 
 
);
Exercise 2 - Inserting Data
select * from courses_submit2

INSERT INTO courses_submit2 (course_name, course_author, course_status, course_published_dt)
VALUES ('Programming using Python','Bob Dillon','published','2020-09-30');

INSERT INTO courses_submit2 (course_name, course_author, course_status, course_published_dt)
VALUES 
    ('Data Engineering using Python', 'Bob Dillon', 'published', '2020-07-15'),
    ('Data Engineering using Scala', 'Elvis Presley', 'draft', NULL),
    ('Programming using Scala', 'Elvis Presley', 'published', '2020-05-12'),
    ('Programming using Java', 'Mike Jack', 'inactive', '2020-08-10'),
    ('Web Applications - Python Flask', 'Bob Dillon', 'inactive', '2020-07-20'),
    ('Web Applications - Java Spring', 'Mike Jack', 'draft', NULL),
    ('Pipeline Orchestration - Python', 'Bob Dillon', 'draft', NULL),
    ('Streaming Pipelines - Python', 'Bob Dillon', 'published', '2020-10-05'),
    ('Web Applications - Scala Play', 'Elvis Presley', 'inactive', '2020-09-30'),
    ('Web Applications - Python Django', 'Bob Dillon', 'published', '2020-06-23'),
    ('Server Automation - Ansible', 'Uncle Sam', 'published', '2020-07-05');
Exercise 3 - Updating Data
UPDATE courses_submit2
SET course_status = 'published',
         course_published_dt = CURRENT_DATE
WHERE course_status = 'draft'
AND (course_name ILIKE '%Python%' OR course_name ILIKE '%Scala%');

To check the table
select * from courses_submit2

SELECT * FROM courses_submit2 WHERE course_name ILIKE '%Python%' OR course_name ILIKE '%Scala%';

Exercise 4 - Deleting Data
DELETE FROM courses_submit2
WHERE course_status NOT IN ('draft', 'published');

SELECT course_author, COUNT(*) AS published_count
FROM courses_submit2
WHERE course_status = 'published'
GROUP BY course_author
ORDER BY published_count DESC;

Task 2
Create a new database with the name: Netflix_movies
Create database Netflix_movies;
Create a table with the name: Movies

CREATE TABLE Movies (
    movie_id SERIAL PRIMARY KEY,       
    title VARCHAR(250),       
    director VARCHAR(100),            
    year INTEGER,
    length_minutes INTEGER
	);
To check the table
select * from Movies
Create a table with the name: BoxOffice

CREATE TABLE BoxOffice (
    movie_id INTEGER PRIMARY KEY,
    rating DECIMAL(3,1), 
    domestic_sales BIGINT,
    international_sales BIGINT
);
To check the table

select * from BoxOffice 

To insert into the table Movies with data given.

INSERT INTO Movies (movie_id, title, director, year, length_minutes) 
VALUES
    (1, 'Toy Story', 'John Lasseter', 1995, 81),
    (2, 'A Bugs Life', 'John Lasseter', 1998, 95),
    (3, 'Toy Story 2', 'John Lasseter', 1999, 93),
    (4, 'Monsters, Inc.', 'Pete Docter', 2001, 92),
    (5, 'Finding Nemo', 'Andrew Stanton', 2003, 107),
    (6, 'The Incredibles', 'Brad Bird', 2004, 116),
    (7, 'Cars', 'John Lasseter', 2006, 117),
    (8, 'Ratatouille', 'Brad Bird', 2007, 115),
    (9, 'WALL-E', 'Andrew Stanton', 2008, 104),
    (10, 'Up', 'Pete Docter', 2009, 101),
    (11, 'Toy Story 3', 'Lee Unkrich', 2010, 103),
    (12, 'Cars 2', 'John Lasseter', 2011, 120),
    (13, 'Brave', 'Brenda Chapman', 2012, 102),
    (14, 'Monsters University', 'Dan Scanlon', 2013, 110);

To insert into the table BoxOffice with data given.

INSERT INTO BoxOffice (movie_id, rating, domestic_sales, international_sales)
VALUES
    (5, 8.2, 380843261, 555900000),
    (14, 7.4, 268492764, 475066843),
    (8, 8.0, 206445654, 417277164),
    (12, 6.4, 191452396, 368400000),
    (3, 7.9, 245852179, 239163000),
    (6, 8.0, 261441092, 370001000),
    (9, 8.5, 223808164, 297503696),
    (11, 8.4, 415004880, 648167031),
    (1, 8.3, 191796233, 170162503),
    (7, 7.2, 244082982, 217900167),
    (10, 8.3, 293004164, 438338580),
    (4, 8.1, 289916256, 272900000),
    (2, 7.2, 162798565, 200600000),
    (13, 7.2, 237283207, 301700000);

To check the table
select * from BoxOffice
