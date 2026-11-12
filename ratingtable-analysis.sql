# the structure of ratings table
describe ratings;

#create a temporary staging table
create table ratings_staging(
	user_id int,
    movie_id int,
    rating decimal(2,1),
    rating_timestamp bigint
    );


describe ratings_staging;

#loading data into ratings_staging
LOAD DATA LOCAL INFILE
'C:/Users/USER/OneDrive/Documents/MovieLens Reccomendation System Project/ml-100k/u.data'
INTO TABLE ratings_staging
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
(
    user_id,
    movie_id,
    rating,
    rating_timestamp
);


#check number of ratings imported
SELECT COUNT(*) AS total_staged_ratings
FROM ratings_staging;

#validation of ratings_staging table
#checking for missing values and highest and lowest ratings
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT user_id, movie_id) AS unique_user_movie_pairs,
    SUM(user_id IS NULL) AS missing_user_ids,
    SUM(movie_id IS NULL) AS missing_movie_ids,
    SUM(rating IS NULL) AS missing_ratings,
    SUM(rating_timestamp IS NULL) AS missing_timestamps,
    MIN(rating) AS lowest_rating,
    MAX(rating) AS highest_rating
FROM ratings_staging;


# insert the ratings into final table
INSERT INTO ratings (
    user_id,
    movie_id,
    rating,
    rating_timestamp
)
SELECT
    user_id,
    movie_id,
    rating,
    rating_timestamp
FROM ratings_staging;

select count(*) as total_ratings
from ratings;

SELECT
    COUNT(*) AS total_ratings,
    COUNT(DISTINCT user_id) AS users_who_rated,
    COUNT(DISTINCT movie_id) AS movies_rated,
    MIN(rating) AS lowest_rating,
    MAX(rating) AS highest_rating
FROM ratings;

SELECT
    COUNT(*) AS total_ratings,
    SUM(u.user_id IS NULL) AS ratings_with_missing_users,
    SUM(m.movie_id IS NULL) AS ratings_with_missing_movies
FROM ratings AS r
LEFT JOIN users AS u
    ON r.user_id = u.user_id
LEFT JOIN movies AS m
    ON r.movie_id = m.movie_id;






























