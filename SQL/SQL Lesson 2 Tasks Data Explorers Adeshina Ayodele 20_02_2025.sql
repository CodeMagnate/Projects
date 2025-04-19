-- customer sales data
-- To create the schema for the table. 
-- Ensure that every column title and its data type is captured 
CREATE TABLE customer_sales_data (
    index SERIAL PRIMARY KEY,
    date DATE,
    year INT,
    month VARCHAR(10),
    customer_age INT,
    customer_gender TEXT,
    country TEXT,
    state TEXT,
    product_category TEXT,
    sub_category TEXT,
    quantity INT,
    unit_cost NUMERIC,
    unit_price NUMERIC,
    cost NUMERIC,
    revenue NUMERIC
);

-- To Delete the table 
DROP TABLE Customer_sales_data;

-- To copy the file into the table created above.
-- Encounted error in the format for date hence I used a modifier 

SET datestyle = 'ISO, MDY'; -- Set date format to MM/DD/YY
COPY customer_sales_data (
    index, date, year, month, customer_age, customer_gender, country, state, 
    product_category, sub_category, quantity, unit_cost, unit_price, cost, revenue
)
FROM '/Users/Public/Customer_sales_data.csv' 
WITH CSV HEADER;

-- To see the entire table 
select* FROM customer_sales_data ;

-- US Accident 1
create table US_Accident_1(
	Airport_Code char(4),
	Amenity	BOOLEAN,
	Astronomical_Twilight TEXT CHECK (Astronomical_Twilight IN ('Day', 'Night')),
	Bump BOOLEAN,
	Calculation1 TEXT,
	City TEXT,
	Civil_Twilight TEXT CHECK (Astronomical_Twilight IN ('Day', 'Night')),
	count_of_Bump INT,	
	Count_of_Crossing INT,	
	count_Traffic_Signal INT,	
	Country	TEXT,
	County TEXT	,
	Crossing BOOLEAN,	
	Description TEXT,
	End_Lat NUMERIC ,
	End_Lng	NUMERIC ,
	End_Time TIMESTAMP,	
	Give_Way BOOLEAN,	
	ID VARCHAR (10) PRIMARY KEY,
	Junction BOOLEAN,	
	Nautical_Twilight TEXT CHECK (Astronomical_Twilight IN ('Day', 'Night')),	
	No_Exit	BOOLEAN,
	Number INT,	
	Railway BOOLEAN,
	Roundabout BOOLEAN,	
	Severity INT,	
	Side TEXT,	
	Source VARCHAR(15),	
	Start_Time TIMESTAMP,	
	State CHAR(2),	
	Station BOOLEAN,
	Stop BOOLEAN,	
	Street TEXT,	
	Sunrise_Sunset TEXT,	
	Temperature_F NUMERIC(10,1),	
	Timezone TEXT,	
	Traffic_Calming BOOLEAN,
	Traffic_Signal BOOLEAN,	
	Turning_Loop BOOLEAN,	
	Visibility_mi NUMERIC,	
	Weather_Condition TEXT
);


-- To Delete the table 
DROP TABLE US_Accident_1;

-- To copy the file into the table created above.

SET datestyle = 'ISO, MDY'; -- Set date format to MM/DD/YY
COPY  US_Accident_1(Airport_Code,Amenity,Astronomical_Twilight,Bump,Calculation1,City,Civil_Twilight,count_of_Bump,Count_of_Crossing,count_Traffic_Signal,Country,County,Crossing,Description,End_Lat,End_Lng,End_Time,Give_Way,ID,Junction,Nautical_Twilight,No_Exit,Number,Railway,Roundabout,Severity,Side,Source,Start_Time,State,Station,Stop,Street,Sunrise_Sunset,Temperature_f,Timezone,Traffic_Calming,Traffic_Signal,Turning_Loop, Visibility_mi,Weather_Condition)
FROM '/Users/Public/US_Accident_1.csv' 
WITH  ENCODING 'ISO-8859-1'
CSV HEADER;

-- To see the entire table 
select* FROM US_Accident_1 LIMIT (10);

-- US Accident 2

CREATE TABLE US_Accident_2 (
    Airport_Code VARCHAR(10),
    Amenity BOOLEAN,
    Astronomical_Twilight TEXT CHECK (Astronomical_Twilight IN ('Day', 'Night')),
    Bump BOOLEAN,
    Calculation1 TEXT,
    City TEXT,
    Civil_Twilight TEXT CHECK (Civil_Twilight IN ('Day', 'Night')),
    Count_of_Bump INT,
    Count_of_Crossing INT,
    Count_Traffic_Signal INT,
    Country TEXT,
    County TEXT,
    Crossing BOOLEAN,
    Description TEXT,
    End_Lat NUMERIC,
    End_Lng NUMERIC,
    End_Time TIMESTAMP,
    Give_Way BOOLEAN,
    ID TEXT PRIMARY KEY,
    Junction BOOLEAN,
    Nautical_Twilight TEXT CHECK (Nautical_Twilight IN ('Day', 'Night')),
    No_Exit BOOLEAN,
    Number INT,
    Weather_Timestamp TIMESTAMP,
    Wind_Direction TEXT,
    Zipcode TEXT,
    Count_of_accidents INT,
    Count_of_county INT,
    Distance_mi NUMERIC,
    Humidity_percent NUMERIC,
    Number_of_Records INT,
    Precipitation_in NUMERIC,
    Pressure_in NUMERIC,
    Records INT,
    Start_Lat NUMERIC,
    Start_Lng NUMERIC,
    TMC INT,
    Wind_Chill_F NUMERIC,
    Wind_Speed_mph NUMERIC
);
-- To Delete the table 
DROP TABLE US_Accident_2;


-- To copy the file into the table created above.

SET datestyle = 'ISO, MDY'; -- Set date format to MM/DD/YY
COPY  US_Accident_2
FROM '/Users/Public/US_Accident_2.csv' 
WITH  ENCODING 'ISO-8859-1'
CSV HEADER;

-- To see the entire table 
select* FROM US_Accident_2 LIMIT (10);

--Using the MOVIES and BoxOffice Tables
--1.Find the movie with a row id of 6
select *
From movies
WHERE movie_id = 6;

--2.Find the movies released in the years between 2000 and 2010
SELECT *
FROM MOVIES
WHERE YEAR  BETWEEN '2000'AND'2010';

--3. List all movies and their combined sales in millions of dollars

SELECT title, 
	ROUND((boxoffice.domestic_sales + boxoffice.international_sales)/1000000, 2)AS Combined_Sales
FROM MOVIES
JOIN BOXOFFICE
ON MOVIES.movie_id = BOXOFFICE.movie_id;

--4 List all movies and their ratings in percent
SELECT  title,
	ROUND(boxoffice.rating*10, 2)AS Rating_Percentage
FROM MOVIES
JOIN BOXOFFICE
ON MOVIES.movie_id = BOXOFFICE.movie_id;

-- 5. Find all the Toy Story movies

SELECT *
FROM MOVIES
WHERE title like'Toy Story%';
--OR
SELECT *
FROM MOVIES
JOIN BOXOFFICE
ON MOVIES.movie_id = BOXOFFICE.movie_id
WHERE title like'Toy Story%';

--6. Find all the movies directed by John Lasseter

SELECT *
FROM MOVIES
WHERE director = 'John Lasseter';
--OR
SELECT *
FROM MOVIES
JOIN BOXOFFICE
ON MOVIES.movie_id = BOXOFFICE.movie_id
WHERE director = 'John Lasseter';

--7. Find all the movies (and director) not directed by John Lasseter

SELECT title,director
FROM MOVIES
WHERE director != 'John Lasseter';

--OR
SELECT title,director
FROM MOVIES
JOIN BOXOFFICE
ON MOVIES.movie_id = BOXOFFICE.movie_id
WHERE director != 'John Lasseter';

--8. Find the domestic and international sales for each movie

SELECT title, domestic_sales,international_sales
FROM MOVIES
JOIN BOXOFFICE
ON MOVIES.movie_id = BOXOFFICE.movie_id;

--9. Show the sales numbers for each movie that did better
-- internationally rather than domestically

SELECT title,international_sales, domestic_sales
FROM MOVIES
JOIN BOXOFFICE
ON MOVIES.movie_id = BOXOFFICE.movie_id
WHERE BOXOFFICE.international_sales > BOXOFFICE.domestic_sales;

-- 10. List all the movies by their ratings in descending order

SELECT title,rating
FROM MOVIES
JOIN BOXOFFICE
ON MOVIES.movie_id = BOXOFFICE.movie_id
ORDER BY BOXOFFICE.rating;

--11. Find the number of movies each director has directed

SELECT director,COUNT(*) AS number_of_movies
FROM MOVIES
GROUP BY MOVIES.director;

--12. Toy Story 4 has been released to critical acclaim! It had a rating of
--8.7, and made 340 million domestically and 270 million internationally.
--Add the record to the BoxOffice table.

-- At this point i believe it is better to have a table created to hold
-- the combined or joined tables (movies and boxoffice). This is to simplify subsequent queries.
CREATE VIEW Combined_Table AS 
SELECT 
	MOVIES.movie_id AS movie_id,
	MOVIES.title,
	MOVIES.director,
	MOVIES.year,
	MOVIES.length_minutes,
	BOXOFFICE.rating,
	BOXOFFICE.domestic_sales,
	BOXOFFICE.international_sales
	
FROM MOVIES
JOIN BOXOFFICE
ON MOVIES.movie_id = BOXOFFICE.movie_id;

-- Now to add new values. 


INSERT INTO BOXOFFICE (movie_id, rating, domestic_sales, international_sales)
VALUES (15,8.7,340000000,270000000);

--To check 

SELECT *
FROM BOXOFFICE

--13. The director for A Bug's Life is incorrect, it was actually directed by
--John Lasseter

UPDATE MOVIES
SET director='John Lasseter'
WHERE title = 'A Bugs Life';

--To verify 

SELECT *
FROM MOVIES 
WHERE title = 'A Bugs Life';

--14. The year that Toy Story 2 was released is incorrect, it was actually
--released in 1999. You should update it.

-- There MUST have been an error in this question because the year of release is already 1999 in the table
-- So I modified the question to change it to 1914.

UPDATE MOVIES
SET year = 1914
WHERE title = 'Toy Story 2';

--To verify 

SELECT *
FROM MOVIES 
WHERE title = 'Toy Story 2';
-- And then back to what it was.
UPDATE MOVIES
SET year = 1999
WHERE title = 'Toy Story 2';


--15. This database is getting too big, lets remove all movies that were
--released before 2005.
-- Before Delecting it is good practice to check first
SELECT * 
FROM Combined_Table
WHERE year < 2005;

DELETE 
FROM Combined_Table
WHERE year < 2005;

-- On excuting the script above, I learnt that ...
--Views that do not select from a single table or view are not automatically updatable.
-- So I went to the actually table has the year column.

SELECT * 
FROM MOVIES
WHERE year < 2005;

DELETE 
FROM MOVIES
WHERE year < 2005;

-- To verify the resulting table.

SELECT *
FROM MOVIES

