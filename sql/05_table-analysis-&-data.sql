describe movies;


# check if the movies table is empty.
select count(*) as movies_rows
from movies;


# create a staging table to  investigate the data and remove the unrelevant data for this project

use movies_db;

USE movies_db;

CREATE TABLE movies_staging (
    movie_id INT,
    title VARCHAR(255),
    release_date VARCHAR(20),
    video_release_date VARCHAR(20),
    imdb_url VARCHAR(255),
    unknown TINYINT,
    action TINYINT,
    adventure TINYINT,
    animation TINYINT,
    childrens TINYINT,
    comedy TINYINT,
    crime TINYINT,
    documentary TINYINT,
    drama TINYINT,
    fantasy TINYINT,
    film_noir TINYINT,
    horror TINYINT,
    musical TINYINT,
    mystery TINYINT,
    romance TINYINT,
    sci_fi TINYINT,
    thriller TINYINT,
    war TINYINT,
    western TINYINT
);


describe movies_staging;
select* from movies_staging;
SELECT COUNT(*) AS staging_rows
FROM movies_staging;

show variables like 'local_infile';
show variables like 'secure_file_priv';

/* make mysql serve to allow clients to request local file imports using
load data local infile. 
make the  local infile value on*/
SET GLOBAL local_infile = ON;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

USE movies_db;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

SELECT COUNT(*) AS current_rows
FROM movies_staging;


/*LOAD DATA LOCAL INFILE
'C:/Users/USER/OneDrive/Documents/MovieLens Reccomendation System Project/ml-100k/u.item'
INTO TABLE movies_staging
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(
    movie_id,
    title,
    release_date,
    video_release_date,
    imdb_url,
    unknown,
    action,
    adventure,
    animation,
    childrens,
    comedy,
    crime,
    documentary,
    drama,
    fantasy,
    film_noir,
    horror,
    musical,
    mystery,
    romance,
    sci_fi,
    thriller,
    war,
    western
);
*/

   
LOAD DATA LOCAL INFILE
'C:/Users/USER/OneDrive/Documents/MovieLens Reccomendation System Project/ml-100k/u.item'
INTO TABLE movies_staging
CHARACTER SET latin1
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(
    movie_id,
    title,
    release_date,
    video_release_date,
    imdb_url,
    unknown,
    action,
    adventure,
    animation,
    childrens,
    comedy,
    crime,
    documentary,
    drama,
    fantasy,
    film_noir,
    horror,
    musical,
    mystery,
    romance,
    sci_fi,
    thriller,
    war,
    western
);


SELECT COUNT(*) AS total_movies
FROM movies_staging;

select movie_id, title, release_date
from movies_staging
limit 20;

# check for missing movie ids or titles
select
	count(*) as total_rows,
	count(distinct movie_id) as unique_movie_id,
	sum(title is null or trim(title) = '') as missing_titles
from movies_staging;


# check the genre values  are only 0 and 1

SELECT
    COUNT(*) AS total_rows,
    SUM(
        unknown NOT IN (0, 1)
        OR action NOT IN (0, 1)
        OR adventure NOT IN (0, 1)
        OR animation NOT IN (0, 1)
        OR childrens NOT IN (0, 1)
        OR comedy NOT IN (0, 1)
        OR crime NOT IN (0, 1)
        OR documentary NOT IN (0, 1)
        OR drama NOT IN (0, 1)
        OR fantasy NOT IN (0, 1)
        OR film_noir NOT IN (0, 1)
        OR horror NOT IN (0, 1)
        OR musical NOT IN (0, 1)
        OR mystery NOT IN (0, 1)
        OR romance NOT IN (0, 1)
        OR sci_fi NOT IN (0, 1)
        OR thriller NOT IN (0, 1)
        OR war NOT IN (0, 1)
        OR western NOT IN (0, 1)
    ) AS rows_with_invalid_genres
FROM movies_staging;

# checking if there a movies not classifeid by either of the genre
SELECT COUNT(*) AS movies_without_any_genre
FROM movies_staging
WHERE
    unknown + action + adventure + animation + childrens
    + comedy + crime + documentary + drama + fantasy
    + film_noir + horror + musical + mystery + romance
    + sci_fi + thriller + war + western = 0;

#check if the original movies table has any rows
select count(*) as current_movies
from movies;

# populating the movies table with data from movies_staging table
# converting te relaese year into number
insert into movies(movie_id, title, release_year)
select
	movie_id,
    title,
    case
		when release_date is not null
			and trim(release_date) <> ''
		then year(str_to_date(release_date, '%d-%b-%Y'))
        else null
	end as release_year
from movies_staging;
    
select count(*) as total_movies
from movies;

select*
from movies 
order by movie_id
limit 10;

# populate the movie_genre table
select count(*) as current_relationship
from movie_genre;

/*
INSERT INTO movie_genre (movie_id, genre_id) specifies the two columns we are filling.
Each SELECT finds movies marked 1 for a particular genre and assigns the corresponding genre ID.
UNION ALL combines the results from all 19 genre queries while retaining every relationship.
The IDs match the values in your genre table, from 0 (Unknown) to 18 (Western).
*/

INSERT INTO movie_genre (movie_id, genre_id)
SELECT movie_id, 0 FROM movies_staging WHERE unknown = 1
UNION ALL
SELECT movie_id, 1 FROM movies_staging WHERE action = 1
UNION ALL
SELECT movie_id, 2 FROM movies_staging WHERE adventure = 1
UNION ALL
SELECT movie_id, 3 FROM movies_staging WHERE animation = 1
UNION ALL
SELECT movie_id, 4 FROM movies_staging WHERE childrens = 1
UNION ALL
SELECT movie_id, 5 FROM movies_staging WHERE comedy = 1
UNION ALL
SELECT movie_id, 6 FROM movies_staging WHERE crime = 1
UNION ALL
SELECT movie_id, 7 FROM movies_staging WHERE documentary = 1
UNION ALL
SELECT movie_id, 8 FROM movies_staging WHERE drama = 1
UNION ALL
SELECT movie_id, 9 FROM movies_staging WHERE fantasy = 1
UNION ALL
SELECT movie_id, 10 FROM movies_staging WHERE film_noir = 1
UNION ALL
SELECT movie_id, 11 FROM movies_staging WHERE horror = 1
UNION ALL
SELECT movie_id, 12 FROM movies_staging WHERE musical = 1
UNION ALL
SELECT movie_id, 13 FROM movies_staging WHERE mystery = 1
UNION ALL
SELECT movie_id, 14 FROM movies_staging WHERE romance = 1
UNION ALL
SELECT movie_id, 15 FROM movies_staging WHERE sci_fi = 1
UNION ALL
SELECT movie_id, 16 FROM movies_staging WHERE thriller = 1
UNION ALL
SELECT movie_id, 17 FROM movies_staging WHERE war = 1
UNION ALL
SELECT movie_id, 18 FROM movies_staging WHERE western = 1;


SELECT COUNT(*) AS total_relationships
FROM movie_genre;

# joins the three tables to show which genre belong to which movies.

SELECT
    m.movie_id,
    m.title,
    g.genre_name
FROM movie_genre AS mg
JOIN movies AS m
    ON mg.movie_id = m.movie_id
JOIN genre AS g
    ON mg.genre_id = g.genre_id
ORDER BY m.movie_id, g.genre_id
LIMIT 20;

# validate movie-genre relationship
select 
	count(*) as total_relationships,
	count(distinct movie_id) as movie_with_genres,
	count(distinct genre_id) as genre_used
from movie_genre;


#which movie has the most genre
SELECT
    g.genre_name,
    COUNT(*) AS movie_count
FROM movie_genre AS mg
JOIN genre AS g
    ON mg.genre_id = g.genre_id
GROUP BY g.genre_id, g.genre_name
ORDER BY movie_count DESC;














