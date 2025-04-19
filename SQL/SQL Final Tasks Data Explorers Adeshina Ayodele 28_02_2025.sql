--Preamble

CREATE DATABASE Olympics;


CREATE TABLE athlete_events (
	ID INT,
    Name VARCHAR(300),
	Sex VARCHAR(1),
	Age INT,
	Height NUMERIC,
	Weight NUMERIC,
	Team VARCHAR(100),
	NOC CHAR(3),
	Games TEXT,
	Year INT,
	Season VARCHAR(10) CHECK (Season IN ('Summer','Winter')),
	City VARCHAR(100),
	Sport VARCHAR(100),
	Event VARCHAR(100),
	Medal TEXT CHECK (Medal IN ('Gold', 'Silver','Bronze', 'NA'))
	);

CREATE TABLE noc_regions (
	NOC CHAR(3) PRIMARY KEY,
 	region VARCHAR(50),
	notes TEXT
	);

--- To copy the data into my table.
COPY  athlete_events
FROM '/Users/Public/athlete_events.csv' 
WITH  ENCODING 'ISO-8859-1'
NULL 'NA'
CSV HEADER;

COPY  noc_regions
FROM '/Users/Public/noc_regions.csv' 
WITH  ENCODING 'ISO-8859-1'
NULL 'NA'
CSV HEADER;

--- To alter the table for a serial primary key.
---- a.k.a Surrogate key.

ALTER TABLE athlete_events
ADD COLUMN Uniquie_num SERIAL PRIMARY KEY;


-- To delete the tables
DROP TABLE athlete_events;
	
DROP TABLE noc_regions;

-- 1. How many olympics games have been held?
----- Answer: The olympic games are held in summer and winter
----- Therefore we need to count the number of rows in the games column
----- Since the entries are repeated we need to use 'distinct'.


SELECT 
	COUNT (DISTINCT games ) AS olympic_games_held
FROM athlete_events;

--- 2. List down all Olympics games held so far.

SELECT DISTINCT games
FROM athlete_events
ORDER BY games;

--- 3. Mention the total no of nations who participated in each Olympics game?

CREATE TABLE Combined_Table AS
SELECT 
	ae.id,
    ae.Name,
	ae.Sex,
	ae.Age,
	ae.Height,
	ae.Weight,
	ae.Team,
	--ae.NOC,
 	nr.NOC,
	nr.region,
	nr.notes,
	ae.Games,
	ae.Year,
	ae.Season,
	ae.City,
	ae.Sport,
	ae.Event,
	ae.Medal
	
FROM athlete_events ae
FULL JOIN noc_regions nr
ON ae.noc = nr.noc;


SELECT games,
	COUNT  (DISTINCT noc) AS Comb
FROM Combined_Table 
GROUP BY games
ORDER BY games;

--- 4. Which year saw the highest and lowest no of countries participating in olympics?

CREATE TABLE Games_with_Countries AS
SELECT games, year,
	COUNT  (DISTINCT noc) AS Num_Countries
FROM Combined_Table 
WHERE games IS NOT NULL AND year IS NOT NULL 
GROUP BY games, year
ORDER BY games;

-- Answer: Highest no of countries participating in olympics
-- First step
SELECT MAX (Num_Countries)
FROM Games_with_Countries;

-- Second step
SELECT games, year, Num_Countries
FROM Games_with_Countries
WHERE Num_Countries =(SELECT MAX (Num_Countries)FROM Games_with_Countries);

-- Answer: Lowest no of countries participating in olympics
-- First step
SELECT MIN (Num_Countries)
FROM Games_with_Countries;

-- Second step
SELECT games, year, Num_Countries
FROM Games_with_Countries
WHERE Num_Countries =(SELECT MIN (Num_Countries)FROM Games_with_Countries);

--- 5. Which nation has participated in all of the olympic games?

---  To show total number of distinct games use TotalGames CTE
WITH TotalGames AS (
    SELECT COUNT(DISTINCT Games) AS total_games
    FROM Combined_Table
),

--- Each nation against number of participation use NationParticipation CTE
NationParticipation AS (
    SELECT 
        NOC, 
        COUNT(DISTINCT Games) AS games_participated
    FROM Combined_Table
    GROUP BY NOC
)

--- we then join and compare with cross join.
SELECT 
    np.NOC, 
    nr.Region, 
    np.games_participated
FROM NationParticipation np
JOIN noc_regions nr ON np.NOC = nr.NOC
CROSS JOIN TotalGames tg
WHERE np.games_participated = tg.total_games;

--- 6. Identify the sport which was played in all summer olympics.

WITH TotalSummerGames AS (
    -- Step 1: Count the total number of distinct Summer Olympic games
    SELECT COUNT(DISTINCT Games) AS total_summer_games
    FROM Combined_Table
    WHERE Games LIKE '%Summer'
),
SportParticipation AS (
    -- Step 2: Count the number of Summer games each sport was played in
    SELECT 
        Sport, 
        COUNT(DISTINCT Games) AS summer_games_played
    FROM Combined_Table
    WHERE Games LIKE '%Summer'
    GROUP BY Sport
)
-- Step 3: Compare each sport's participation count with the total number of Summer games
SELECT 
    sp.Sport, 
    sp.summer_games_played
FROM SportParticipation sp
CROSS JOIN TotalSummerGames tsg
WHERE sp.summer_games_played = tsg.total_summer_games;

--- 7. Which Sports were just played only once in the olympics?

WITH SportParticipation AS (
    -- Step 1: Count the number of Olympic games each sport was played in
    SELECT 
        Sport, 
        COUNT(DISTINCT Games) AS games_played
    FROM Combined_Table
    GROUP BY Sport
)
-- Step 2: Filter sports that were played in exactly one game
SELECT 
    Sport, 
    games_played
FROM SportParticipation
WHERE games_played = 1;

--- 8. Fetch the total no of sports played in each olympic games.

SELECT 
    Games, 
    COUNT(DISTINCT Sport) AS total_sports
FROM Combined_Table
GROUP BY Games
ORDER BY Games;

--- 9. Fetch details of the oldest athletes to win a gold medal.
WITH GoldMedalists AS (
    -- Step 1: Filter gold medalists
    SELECT *
    FROM Combined_Table
    WHERE Medal = 'Gold'
),
OldestGoldMedalistAge AS (
    -- Step 2: Find the maximum age among gold medalists
    SELECT MAX(Age) AS max_age
    FROM GoldMedalists
)
-- Step 3: Retrieve details of the oldest gold medalists
SELECT 
    gm.ID, 
    gm.Name, 
    gm.Sex, 
    gm.Age, 
    gm.Team, 
    gm.NOC, 
    gm.Games, 
    gm.Year, 
    gm.Season, 
    gm.City, 
    gm.Sport, 
    gm.Event, 
    gm.Medal
FROM GoldMedalists gm
JOIN OldestGoldMedalistAge ogma ON gm.Age = ogma.max_age;

---10. Find the Ratio of male and female athletes participated in all Olympic games.
WITH GenderCounts AS (
    -- Step 1: Count the number of male and female athletes
    SELECT 
        Sex, 
        COUNT(DISTINCT ID) AS athlete_count
    FROM Combined_Table
    GROUP BY Sex
)
-- Step 2: Calculate the ratio of male to female athletes
SELECT 
    MAX(CASE WHEN Sex = 'M' THEN athlete_count END) AS male_count,
    MAX(CASE WHEN Sex = 'F' THEN athlete_count END) AS female_count,
    ROUND(
        MAX(CASE WHEN Sex = 'M' THEN athlete_count END) * 1.0 / 
        MAX(CASE WHEN Sex = 'F' THEN athlete_count END), 
        2
    ) AS male_to_female_ratio
FROM GenderCounts;

---11. Fetch the top 5 athletes who have won the most gold medals.

WITH GoldWinners AS (
	SELECT *
	FROM Combined_Table
	WHERE medal = 'Gold'
),
Count_GoldWinners AS (
	SELECT  name,
		count (*) AS gold_medalist
	FROM Combined_Table
	WHERE medal = 'Gold'
	GROUP BY  name

)

SELECT  name, gold_medalist
FROM Count_GoldWinners 
ORDER BY gold_medalist DESC
LIMIT 5;



---12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).

-- Answer: Still using the format : 'WITH Placeholder1 AS ( argument 1), Placeholder 2 AS (argument 2)'

WITH Medalists AS (
    -- Step 1: Filter athletes who won medals (gold, silver, or bronze)
    SELECT *
    FROM Combined_Table
    WHERE Medal IN ('Gold', 'Silver', 'Bronze')
),
AthleteMedals AS (
    -- Step 2: Count the total number of medals won by each athlete
    SELECT 
        Name, 
        COUNT(*) AS total_medals
    FROM Medalists
    GROUP BY Name
)
-- Step 3: Sort and fetch the top 5 athletes
SELECT 
    Name, 
    total_medals
FROM AthleteMedals
ORDER BY total_medals DESC
LIMIT 5;

---13. Fetch the top 5 most successful countries in Olympics. Success is defined by no of medals won.
-- Answer:  Still using the format : 'WITH Placeholder1 AS ( argument 1), Placeholder 2 AS (argument 2)'

WITH Successful_Nations  AS (
	SELECT *
	FROM Combined_Table
	WHERE medal IN ('Gold', 'Silver', 'Bronze')
	-- or WHERE Medal IS NOT NULL
), 
Count_Success AS (
	SELECT region,
		COUNT (*) AS Best_Nations
	FROM Successful_Nations
	GROUP BY region
)

SELECT region, Best_Nations
FROM Count_Success 
ORDER BY Best_Nations DESC
LIMIT 5
;


---14. List down total gold, silver and bronze medals won by each country.
-- Answer:  Still using the format : 'WITH Placeholder1 AS ( argument 1), Placeholder 2 AS (argument 2)'

WITH Winner_Country AS (
	SELECT region,medal
	FROM Combined_Table
	WHERE medal IN ('Gold', 'Silver', 'Bronze')
), 
Winner_Gold AS (
	SELECT region,
		COUNT (*) AS Number_Gold
	FROM Winner_Country
	WHERE medal='Gold'
	GROUP BY region
),
Winner_Silver AS (
	SELECT region,
		COUNT (*) AS Number_Silver
	FROM Winner_Country
	WHERE medal='Silver'
	GROUP BY region
),
Winner_Bronze AS (
	SELECT region,
		COUNT (*) AS Number_Bronze
	FROM Winner_Country
	WHERE medal='Bronze'
	GROUP BY region
)

SELECT 
    COALESCE(g.region, s.region, b.region) AS region,
    COALESCE(g.Number_Gold, 0) AS Winner_Gold,
    COALESCE(s.Number_Silver, 0) AS Winner_Silver,
    COALESCE(b.Number_Bronze, 0) AS Winner_Bronze
	
FROM Winner_Gold g
FULL JOIN Winner_Silver s ON g.region = s.region
FULL JOIN Winner_Bronze b ON g.region = b.region
ORDER BY region
;

---15. List down total gold, silver and bronze medals won by each country corresponding to each Olympic games.

WITH MedalCounts AS (
    SELECT Games, NOC, Medal
    FROM Combined_Table
    --WHERE Medal IS NOT NULL
	WHERE medal IN ('Gold', 'Silver', 'Bronze')
)
SELECT 
    mc.Games,
    mc.NOC,
    nr.Region AS Country_Name,
    COUNT(CASE WHEN mc.Medal = 'Gold' THEN 1 END) AS Gold_Medals,
    COUNT(CASE WHEN mc.Medal = 'Silver' THEN 1 END) AS Silver_Medals,
    COUNT(CASE WHEN mc.Medal = 'Bronze' THEN 1 END) AS Bronze_Medals
FROM MedalCounts mc
JOIN noc_regions nr ON mc.NOC = nr.NOC
GROUP BY mc.Games, mc.NOC, nr.Region
ORDER BY mc.Games, mc.NOC;


--- WORKING SCRIPTS BELOW ---

--CREATE VIEW Total_Nation AS
Select 
FROM Total_Nation;

DROP VIEW Total_Nation;


-- To make checks ...

SELECT * 
FROM athlete_events limit (5);
	
SELECT * 
FROM  noc_regions limit (5);

SELECT * 
FROM  Combined_Table limit (5);

SELECT * 
FROM Games_with_Countries limit(5);