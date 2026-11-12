# populating the User table with user-ID

#check the status of the user table
select count(*) as current_users
from users;

create table users_staging(
	user_id int,
    age int,
    gender varchar(10),
    occupation varchar(50),
    zip_code varchar(20)
    );
    
    describe users_staging;
    
    # importation of data from file explorer 
    SET GLOBAL local_infile = ON;

SHOW GLOBAL VARIABLES LIKE 'local_infile';
    
#loading the data from computer into workbench using the file path

LOAD DATA LOCAL INFILE
'C:/Users/USER/OneDrive/Documents/MovieLens Reccomendation System Project/ml-100k/u.user'
INTO TABLE users_staging
CHARACTER SET latin1
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(
    user_id,
    age,
    gender,
    occupation,
    zip_code
);

SELECT COUNT(*) AS total_staged_users
FROM users_staging;
    
#validating the user_staging table
#checking for missing and duplicated values
select
	count(*) as total_rows,
    count(distinct user_id) as unique_users,
    sum(user_id is null) as missing_ids,
    sum(age is null) as missing_age,
    sum(gender is null or gender = '') as missing_gender,
    sum(occupation is null or occupation = '') as missing_occupation,
    sum(zip_code is null or zip_code = '') as missing_zip_codes
from users_staging;


SELECT *
FROM users_staging
ORDER BY user_id
LIMIT 10;

select
	count(*) as total_rows,
    count(distinct user_id) as unique_users
from users_staging;

SELECT COUNT(*) AS current_users
FROM users;

#insert values user_id from users_staging table into users table

INSERT INTO users (user_id)
SELECT user_id
FROM users_staging;

select count(*) as total_users
from users;



    
    
    
    
    
    
    
    