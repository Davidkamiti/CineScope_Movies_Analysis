use movies_db;

-- create a new table inside the movies_db database called ( ***movies***).
create table movies (
	movie_id int primary key,
    title varchar(255) not null,
    release_year smallint
    );
    
  ---- # shows the table exits  
show tables;

---# confirms the internal structure of the design table
describe movies;

---# create 2nd table on ***genres***


create table genre(
genre_id int primary key,
genre_name varchar(100) not null unique
);

---# dsisplays the column, data types, whether null values is allowed
describe genre;


---# dispalys the actual SQL defintion  mysql saved.

show create table genre;

--- # creation of **** movie_genre **** table
/*
 movies_genre created as joining table(many-to-many relationship)
each movie can belong to multiple genre and each genre can apply to many movies 
*/

create table movie_genre(
movie_id int not null,
genre_id int not null,

primary key(movie_id,genre_id),

foreign key(movie_id) references movies(movie_id),
foreign key(genre_id) references genre(genre_id)
);

describe movie_genre;

show create table movie_genre;

show tables;

---# creating User_id table for **** users **** who are rating
/* only one column is required in our user table **user_id** as we do not require the personal information
when it comes to recommendation of the movies at the moment*/

create table users(
	user_id int primary key
    );
    
    describe users;
    
--- # creating the **** rating **** tables 
    
create table ratings(
user_id int not null,
movie_id int not null,
rating decimal (2,1) not null,
rating_timestamp bigint,

primary key ( user_id, movie_id),

foreign key (user_id) references users (user_id),
foreign key (movie_id) references movies (movie_id)
);
    
describe ratings;


use movies_db;
show tables;

select
	table_name,
	constraint_name,
	constraint_type
from information_schema.table_constraints
where table_schema = 'movies_db'
order by table_name, constraint_type;


    
    
    
    
    
    
    
    
