							# BUSSINESS PROBLEMS
# highest rated movie
SELECT
    m.movie_id,
    m.title,
    m.release_year,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(r.rating) AS rating_count
FROM movies AS m
JOIN ratings AS r
    ON m.movie_id = r.movie_id
GROUP BY
    m.movie_id,
    m.title,
    m.release_year
ORDER BY
    average_rating DESC,
    rating_count DESC
LIMIT 10;

#highest rated movies with at least 50 ratings
SELECT
    m.movie_id,
    m.title,
    m.release_year,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(r.rating) AS rating_count
FROM movies AS m
JOIN ratings AS r
    ON m.movie_id = r.movie_id
GROUP BY
    m.movie_id,
    m.title,
    m.release_year
HAVING COUNT(r.rating) >= 50
ORDER BY
    average_rating DESC,
    rating_count DESC
LIMIT 10;

# most popular movies

select 
	m.movie_id,
    m.title,
    m.release_year,
    count(r.rating) as rating_count,
    round(avg(r.rating), 2) as average_rating
from movies as m
join ratings as r
	on m.movie_id = r.movie_id
group by
	m.movie_id,
    m.title,
    m.release_year
order by
	rating_count desc
limit 10;

# highest rated genres

SELECT
    g.genre_name,
    COUNT(r.rating) AS rating_count,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM genre AS g
JOIN movie_genre AS mg
    ON g.genre_id = mg.genre_id
JOIN ratings AS r
    ON mg.movie_id = r.movie_id
GROUP BY
    g.genre_id,
    g.genre_name
ORDER BY
    average_rating DESC;


SELECT
    g.genre_name,
    COUNT(r.rating) AS rating_count,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM genre AS g
JOIN movie_genre AS mg
    ON g.genre_id = mg.genre_id
JOIN ratings AS r
    ON mg.movie_id = r.movie_id
GROUP BY
    g.genre_id,
    g.genre_name
HAVING COUNT(r.rating) >= 5000
ORDER BY
    average_rating DESC;

# analyze average ratings by releasse year
SELECT
    m.release_year,
    COUNT(r.rating) AS rating_count,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM movies AS m
JOIN ratings AS r
    ON m.movie_id = r.movie_id
WHERE m.release_year IS NOT NULL
GROUP BY m.release_year
HAVING COUNT(r.rating) >= 100
ORDER BY average_rating DESC;

# most active users
SELECT
    u.user_id,
    COUNT(r.rating) AS ratings_submitted,
    ROUND(AVG(r.rating), 2) AS average_rating_given
FROM users AS u
JOIN ratings AS r
    ON u.user_id = r.user_id
GROUP BY u.user_id
ORDER BY ratings_submitted DESC
LIMIT 10;


# user rating behaviour

SELECT
    ROUND(AVG(rating), 2) AS overall_average_rating,
    COUNT(*) AS total_ratings
FROM ratings;


# which movies are reliably highly rated (at leat 100 ratings consideration)
/* the highest rating is not necessarily the most relaible ranking. movies with fewer ratings can move to the top more 
more easily*/

SELECT
    m.movie_id,
    m.title,
    m.release_year,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(r.rating) AS rating_count
FROM movies AS m
JOIN ratings AS r
    ON m.movie_id = r.movie_id
GROUP BY
    m.movie_id,
    m.title,
    m.release_year
HAVING COUNT(r.rating) >= 100
ORDER BY
    average_rating DESC,
    rating_count DESC
LIMIT 10;

# calculating weighted movie rating

SELECT
    m.movie_id,
    m.title,
    m.release_year,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(r.rating) AS rating_count,
    ROUND(
        (COUNT(r.rating) / (COUNT(r.rating) + 100.0))
        * AVG(r.rating)
        +
        (100.0 / (COUNT(r.rating) + 100.0))
        * 3.53,
        2
    ) AS weighted_rating
FROM movies AS m
JOIN ratings AS r
    ON m.movie_id = r.movie_id
GROUP BY
    m.movie_id,
    m.title,
    m.release_year
HAVING COUNT(r.rating) >= 100
ORDER BY
    weighted_rating DESC,
    rating_count DESC
LIMIT 10;


# genres with strongest audience engagement

SELECT
    g.genre_name,
    COUNT(r.rating) AS rating_count,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(DISTINCT m.movie_id) AS movie_count
FROM genre AS g
JOIN movie_genre AS mg
    ON g.genre_id = mg.genre_id
JOIN movies AS m
    ON mg.movie_id = m.movie_id
JOIN ratings AS r
    ON m.movie_id = r.movie_id
GROUP BY
    g.genre_id,
    g.genre_name
ORDER BY
    rating_count DESC;
