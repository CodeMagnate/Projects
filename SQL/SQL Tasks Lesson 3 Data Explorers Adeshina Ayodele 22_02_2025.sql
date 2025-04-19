-- Tasks
--Create a new database with the name: National_Accident 
--Create two tables in the database by importing the 2 US_accident files

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
	Sunrise_Sunset TEXT CHECK (Astronomical_Twilight IN ('Day', 'Night')),
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
CSV HEADER
DELIMITER',';

-- To see the first 10 rows of the table 
select* FROM US_Accident_1 LIMIT (10);


-- US Accident 2

CREATE TABLE US_Accident_2 (
    Airport_Code VARCHAR(4),
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
    ID VARCHAR (10) PRIMARY KEY,
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

-- Encounted error in the format for date hence I used a modifier 

SET datestyle = 'ISO, MDY'; -- Set date format to MM/DD/YY
COPY  US_Accident_2
FROM '/Users/Public/US_Accident_2.csv' 
WITH  ENCODING 'ISO-8859-1'
CSV HEADER
DELIMITER',';

-- To see the first 10 rows of the table 
select* FROM US_Accident_2 LIMIT (10);

--1.  Using full join combine the 2 US_accident  files together 
-- with their unique identifiers as  “Total_US_Accident".
 
CREATE TABLE Total_US_Accident AS
SELECT 
    -- Common columns (from one table only to avoid duplication)
    t1.airport_code,
    t1.amenity,
    t1.astronomical_twilight,
    t1.bump,
    t1.calculation1,
    t1.city,
    t1.civil_twilight,
    t1.count_of_bump,
    t1.count_of_crossing,
    t1.count_traffic_signal,
    t1.country,
    t1.county,
    t1.crossing,
    t1.description,
    t1.end_lat,
    t1.end_lng,
    t1.end_time,
    t1.give_way,
    t1.id,
    t1.junction,
    t1.nautical_twilight,
    t1.no_exit,
    t1.number,

    -- Unique columns from US_Accident_1
    t1.severity,
    t1.side,
    t1.source,
    t1.start_time,
    t1.state,
    t1.station,
    t1.stop,
    t1.street,
    t1.sunrise_sunset,
    t1.temperature_f,
    t1.timezone,
    t1.traffic_calming,
    t1.traffic_signal,
    t1.turning_loop,
    t1.visibility_mi,
    t1.weather_condition,

    -- Unique columns from US_Accident_2
    t2.count_of_accidents,
    t2.count_of_county,
    t2.distance_mi,
    t2.humidity_percent,
    t2.number_of_records,
    t2.precipitation_in,
    t2.pressure_in,
    t2.records,
    t2.start_lat,
    t2.start_lng,
    t2.tmc,
    t2.weather_timestamp,
    t2.wind_chill_f,
    t2.wind_direction,
    t2.wind_speed_mph,
    t2.zipcode
FROM 
    US_Accident_1 t1
FULL JOIN 
    US_Accident_2 t2 
ON 
    t1.id = t2.id;

SELECT * from Total_US_Accident limit(5);

Drop table Total_US_Accident;
	

-- 2. What is the total COUNT of accidents that happened during the day?
------Answer is 702,866.

SELECT 
	COUNT(*) AS total_rows_with_day
FROM 
    Total_US_Accident
WHERE 
    Astronomical_Twilight = 'Day'
    OR Civil_Twilight = 'Day'
    OR Nautical_Twilight = 'Day'
    OR Sunrise_Sunset = 'Day';

-- 3.Find the total number of accident that happened in KARA and KFWD during the period 2016 -2021
----- ANSWER 1220

SELECT 
    COUNT(*) AS total_number_accident
FROM 
    Total_US_Accident
WHERE 
    Airport_Code IN ('KARA', 'KFWD')
    AND Start_Time >= '2016-01-01'
    AND Start_Time <= '2021-12-31';
-- OR 

SELECT 
    COUNT(*) AS total_number_accident
FROM 
     Total_US_Accident
WHERE 
    Airport_Code IN ('KARA', 'KFWD')
    AND Start_Time BETWEEN '2016-01-01' AND '2021-12-31';

--- This was used to check the number of rows on each table
 
SELECT COUNT(*) AS total_accidents
FROM Total_US_Accident;

SELECT COUNT(*) AS total_accidents
FROM US_Accident_1;

SELECT COUNT(*) AS total_accidents
FROM US_Accident_2;

-- 4. Find the sum of accidents that occurred Tarrant County
--- Answer=  5610
SELECT 
    COUNT(*) AS total_accidents_tarrant
FROM 
    Total_US_Accident
WHERE 
    County = 'Tarrant';


SELECT *
FROM Total_US_Accident limit (10);

--5.Find all the accident where the city name start with “T”

SELECT *
FROM 
    Total_US_Accident
WHERE 
    City LIKE  'T%';

--6.Show the  accident numbers for each county

SELECT County,
	 COUNT(*) AS accident_numbers_county
FROM 
    Total_US_Accident
GROUP BY county;

--7.Show the  accident numbers  where the severity level is more than 1 
.--- and the weather condition is Mostly cloudy

SELECT County,
	 COUNT(*) AS accident_numbers_Severity
FROM 
    Total_US_Accident
WHERE severity > 1
GROUP BY county;


