create database netflix_db;
use netflix_db;
CREATE TABLE netflix_titles (
  show_id TEXT,
  type TEXT,
  title TEXT,
  director TEXT,
  cast TEXT,
  country TEXT,
  date_added TEXT,
  release_year TEXT,
  rating TEXT,
  duration TEXT,
  listed_in TEXT,
  description TEXT
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/netflix_titles.csv'
INTO TABLE netflix_titles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM netflix_titles;
-- Bussiness Problems
-- 1. Count the number of movies vs TV shows
select 
	type,
    count(*) as total_content
from netflix_titles
group by type;

-- 2.find the most common rating for moives and TV shows
select
	type,
    rating
from
(select 
	type,
    rating,
    count(*),
    rank() over(partition by type order by count(*) desc) as ranking
from netflix_titles
group by 1,2
) as t1
where 
	ranking = 1;

-- 3.list all the movies relesed in a specific year
select * from netflix_titles
where 
	type = 'Movie'
	and
    release_year = 2020;

-- 4.find the top 5 countries with the most content on netflix

WITH RECURSIVE split_country AS (
    SELECT 
        show_id,
        TRIM(SUBSTRING_INDEX(country, ',', 1)) AS country,
        TRIM(SUBSTRING(country, LENGTH(SUBSTRING_INDEX(country, ',', 1)) + 2)) AS rest
    FROM netflix_titles
    WHERE country IS NOT NULL AND country <> ''

    UNION ALL

    SELECT 
        show_id,
        TRIM(SUBSTRING_INDEX(rest, ',', 1)),
        TRIM(SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2))
    FROM split_country
    WHERE rest IS NOT NULL AND rest <> ''
)
SELECT country, COUNT(*) AS total_titles
FROM split_country
GROUP BY country
ORDER BY total_titles DESC;

-- 5. identify the longest movie
SELECT title, duration
FROM netflix_titles
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 10;

-- 6.find content added in the last 5 year
SELECT title, type, date_added
FROM netflix_titles
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

-- 7.find all the movies/TV shows by director 'Rajiv Chilaka'
select title, director
from netflix_titles
where director like '%Rajiv Chilaka%';

-- 8. list all the tv shows with more than 5 seasons
select title, type, duration
from netflix_titles
where 
	type = 'TV Show'
    and
	duration > '5 Seasons';

-- 9.Count the number of content items in each genre
WITH RECURSIVE split_genre AS (
    SELECT 
        show_id,
        TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS genre,
        TRIM(SUBSTRING(listed_in, LENGTH(SUBSTRING_INDEX(listed_in, ',', 1)) + 2)) AS rest
    FROM netflix_titles
    WHERE listed_in IS NOT NULL AND listed_in <> ''

    UNION ALL

    SELECT 
        show_id,
        TRIM(SUBSTRING_INDEX(rest, ',', 1)),
        TRIM(SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2))
    FROM split_genre
    WHERE rest IS NOT NULL AND rest <> ''
)
SELECT genre, COUNT(*) AS total_titles
FROM split_genre
GROUP BY genre
ORDER BY total_titles DESC;

-- 10. find each year and the average number of content release by india on netflix,
-- return top 5 year with highest avg content relesae.
SELECT
    YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS year,
    COUNT(*) AS total_titles,
    COUNT(*) * 100.0 / (
        SELECT COUNT(*) 
        FROM netflix_titles 
        WHERE country LIKE '%India%'
    ) AS avg_content
FROM netflix_titles
WHERE country LIKE '%India%'
  AND date_added IS NOT NULL
GROUP BY year
ORDER BY avg_content DESC
LIMIT 5;

-- 11. list all movies that are documentires
SELECT title, country, release_year, duration, listed_in
FROM netflix_titles
WHERE type = 'Movie'
  AND listed_in LIKE '%Documentaries%';

-- 12.find all the content without director
SELECT *
FROM netflix_titles
WHERE director IS NULL
   OR director = '';

-- 13. find how many movies actor salman khan appeared in last 10 years
SELECT COUNT(*) AS salman_khan_movies_last_10_years
FROM netflix_titles
WHERE type = 'Movie'
  AND cast LIKE '%Salman Khan%'
  AND release_year >= YEAR(CURDATE()) - 10;
  
-- 14.find the top 10 actors who have appeared in the highest number of movies produces in india
SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', numbers.n), ',', -1)) AS actor,
    COUNT(*) AS movie_count
FROM netflix_titles
JOIN (
    SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL 
    SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL 
    SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
) numbers
  ON CHAR_LENGTH(cast) - CHAR_LENGTH(REPLACE(cast, ',', '')) >= numbers.n - 1
WHERE type = 'Movie'
  AND country LIKE '%India%'
  AND cast IS NOT NULL
GROUP BY actor
ORDER BY movie_count DESC
LIMIT 10;

-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
-- Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
SELECT
    CASE
        WHEN description LIKE '%kill%' 
          OR description LIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS content_category,
    COUNT(*) AS total_count
FROM netflix_titles
WHERE description IS NOT NULL
GROUP BY content_category;