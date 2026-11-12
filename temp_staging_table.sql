					---# IMPORTATION OF DATA FROM DATA SOURCE

---# genre table
/* the source data structure is different from the database table structure thus create a 
temporary table	** staging table ** to import the data their first before transferring it 
database table ** genre **  
*/

use movies_db;

create table genre_staging(
genre_name varchar(100),
genre_id int
);

show tables;
describe genre_staging;

---# checking if local file loading is enable
---# if off it restricts loading data from local file through " load data local infile "

show variables like 'local_infile';

---# checking genre_staging is empty (no rowss)
select count(*) as staging_rows
from genre_staging;

---# import all the data from the source into genre_staging table

INSERT INTO genre_staging (genre_name, genre_id)
VALUES
('unknown', 0),
('Action', 1),
('Adventure', 2),
('Animation', 3),
('Children''s', 4),
('Comedy', 5),
('Crime', 6),
('Documentary', 7),
('Drama', 8),
('Fantasy', 9),
('Film-Noir', 10),
('Horror', 11),
('Musical', 12),
('Mystery', 13),
('Romance', 14),
('Sci-Fi', 15),
('Thriller', 16),
('War', 17),
('Western', 18);

---# view the table structure.
select *
from genre_staging 
order by genre_id;

---# validating the new staging data
select 
	count(*) as total_rows,
    count(distinct genre_id) as unique_ids,
    count(distinct genre_name) as unique_names,
    sum(genre_id is null) as missing_ids,
    sum(genre_name is null or genre_name = '') as missing_names,
    min(genre_id) as lowest_id,
    max(genre_id) as highest_id
from genre_staging;

SELECT
    genre_id,
    genre_name,
    COUNT(*) AS occurrences
FROM genre_staging
GROUP BY genre_id, genre_name
HAVING COUNT(*) > 1
ORDER BY genre_id;

---# removes all rows in the table
truncate table genre_staging;

select*
from genre_staging;


INSERT INTO genre_staging (genre_name, genre_id)
VALUES
('unknown', 0),
('Action', 1),
('Adventure', 2),
('Animation', 3),
('Children''s', 4),
('Comedy', 5),
('Crime', 6),
('Documentary', 7),
('Drama', 8),
('Fantasy', 9),
('Film-Noir', 10),
('Horror', 11),
('Musical', 12),
('Mystery', 13),
('Romance', 14),
('Sci-Fi', 15),
('Thriller', 16),
('War', 17),
('Western', 18);

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT genre_id) AS unique_ids,
    COUNT(DISTINCT genre_name) AS unique_names
FROM genre_staging;

# check genre table content
select count(*) as genre_rows
from genre;

---# insert data from genre_staging into the genre table after cleaning
insert into genre(genre_id, genre_name)
select genre_id, genre_name
from genre_staging;


select* from genre
order by genre_id;

select count(*) from genre;
# checks quality of the data and range of the data in genre table
SELECT
    COUNT(*) AS total_genres,
    COUNT(DISTINCT genre_id) AS unique_ids,
    COUNT(DISTINCT genre_name) AS unique_names,
    MIN(genre_id) AS lowest_id,
    MAX(genre_id) AS highest_id
FROM genre;

describe genre;
select*
from genre;
















