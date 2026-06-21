-- Netflix Project

DROP TABLE IF EXISTS NETFLIX;

CREATE TABLE NETFLIX (
	SHOW_ID VARCHAR(7),
	TYPE VARCHAR(10),
	TITLE VARCHAR(150),
	DIRECTOR VARCHAR(250),
	CASTS VARCHAR(1000),
	COUNTRY VARCHAR(150),
	DATE_ADDED VARCHAR(50),
	RELEASE_YEAR INT,
	RATING VARCHAR(10),
	DURATION VARCHAR(15),
	LISTED_IN VARCHAR(100),
	DESCRIPTION VARCHAR(250)
);

SELECT *FROM NETFLIX;

-- 15 Bssiness Problems

-- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*) AS total_content 
FROM netflix
GROUP BY type;


-- 2. Find the most commom rating for movies and TV Shows

SELECT 
	type,
	rating
FROM
	(SELECT 
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS Ranking
	FROM netflix
	GROUP BY 1, 2
	ORDER BY 1, 3 DESC
) AS t1
WHERE 
	ranking = 1


-- 3. List all movies released in a specific year (e.g., 2020)

SELECT 
	type,
	release_year
FROM NETFLIX
WHERE
	type = 'Movie' AND release_year = 2020


-- 4. Find the top 5 countries with the most content on netflix

SELECT 
	UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- 5. Indentify the longest movie or TV show duration

SELECT 
	* 
FROM netflix
WHERE 
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix);

	
-- 6. Find content added in the last 5 year

SELECT 
	*
FROM netflix
WHERE
	TO_DATE(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'

SELECT 
	*
FROM netflix
WHERE
	director LIKE '%Rajiv Chilaka%';


-- 8. List all TV shows with more than 5 seasons

SELECT 
	*
FROM netflix
WHERE
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ',1)::numeric > 5;


-- 9. Count the number of content items in each genre

SELECT
	UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre,
	COUNT(show_id)
FROM netflix
GROUP BY 1;


-- 10. Find each year and the average number of content release in India on netflix, 
	-- return top 5 year with highest avg content release

SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) AS year,
	COUNT(*) AS yearly_content,
	ROUND(	
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric* 100,
	2) AS avg_content_per_year
FROM netflix
WHERE
	country = 'India'
GROUP BY 1;


-- 11. List all Movies that are documentries

SELECT 
	*
FROM netflix
WHERE 
	type = 'Movie'
	AND
	listed_in like '%Documentaries%';


-- 12. Find all content without a director

SELECT 
	*
FROM netflix
WHERE
	director IS NULL;
	
-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 year

SELECT 
	*
FROM netflix
WHERE 
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
	

-- 14. Find the top 10 actors who have appeared in the highest number of movies producted in India.

SELECT 
	UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
	COUNT(*) AS total_content
FROM netflix
WHERE 
	country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
	description field. Label content containing these keyworas 'Bad' and all other content as 'Good'
	Count how many items fall into each category.

WITH new_table
AS
(
	SELECT 
		*,
			CASE
			WHEN 
				description ILIKE '%kill%' OR
				description ILIKE '%Violence%' THEN 'Bad_Content'
				ELSE 'Good_Content'
			END category
	FROM netflix
)
SELECT 
	category,
	COUNT(*) AS total_content
FROM new_table
GROUP BY 1;

	









