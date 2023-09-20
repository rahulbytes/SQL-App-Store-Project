--Create table "Apple_store":
CREATE TABLE Apple_Store (
	App_Id varchar Primary Key,
    App_name varchar,
    size_bytes bigint,
    price numeric,
    rating_count_tot integer,
    rating_count_ver integer,
    user_rating numeric,
    user_rating_ver numeric,
    cont_rating varchar,
    prime_genre varchar
);

--Inserting Data into the Table:
COPY Apple_Store FROM 'D:\EXCEL FILES\Apple_Store.csv' DELIMITER ',' CSV HEADER;

--Create table "AppleStore_description":
Create table appleStore_description(
	app_id varchar primary key,
	app_name varchar,
	size_bytes bigint,
	app_desc varchar
);

--Inserting Data into "AppleStore_description":
COPY AppleStore_description FROM 'D:\EXCEL FILES\appleStore_description1.csv' DELIMITER ',' CSV HEADER;

--View the TABLES:
Select *from Apple_store;

Select *from AppleStore_description;

--Number of Rows present in the "apple_store" table:
Select count(*) as No_of_rows from apple_store;

Select count(*) as No_of_rows from appleStore_description;

--Check for any Null or missing values in the table:
Select count(*) as Missing_values from Apple_store
where app_id is Null;

Select count(*) as Missing_values from appleStore_Description
where app_id is Null;

--Number of apps per genre in descending order:
select prime_genre, count(*) as No_of_apps from Apple_store
group by prime_genre
order by No_of_apps desc;

--Ratings:
select min(user_rating) as Minimum_ratings,
max(user_rating) as Maximum_ratings,
round(avg(user_rating),2) as Average_ratings
from apple_store;

--Ratings as per Genre:
select Prime_genre,
max(user_rating) as Maximum_Rating,
Round(Avg(user_rating),2) as Average_Rating,
min(user_rating) as Minimum_Rating
from apple_store
group by prime_genre
order by Average_Rating desc;

--Number of Apps Paid and Free:
select 
count(app_id) Filter(where price>0) as Number_of_Paid,
count(app_id) Filter(where price=0) as Number_of_Free,
count(app_id) as Total_Number_of_apps
from apple_store;

--Apps genre with the Highest ratings:
select prime_genre, user_rating from apple_store 
group by prime_genre, user_rating
order by user_rating desc;

--Highest Rated App details:
select * from apple_store
where user_rating = 5
order by rating_count_tot desc;

--Lowest Rated App details:
select * from apple_store
where user_rating <=1
order by rating_count_tot;

--Most expensive apps:
select app_name, price, user_rating from Apple_store
order by price desc
limit 5;

--Least expensive apps:
select app_name, price, user_rating from Apple_store
where price >0
order by price
limit 5;

--Determine whether the Paid or Free have the higher ratings:
Select 
	case
	when Price > 0 then 'Paid'
	else 'Free'
	end as App_Price_category,
	avg(user_rating) as Average_Ratings
	from Apple_store
	group by App_Price_category;

--Apps Genre with the Highest average app sizes:
SELECT prime_genre,
       Round(AVG(size_bytes)) AS average_app_size
FROM apple_store
GROUP BY prime_genre
ORDER BY average_app_size DESC

--Check whether there is a correlation between App size and user ratings:
Select 
	case
	when size_bytes>2147483648 then 'More the 2GB'
	when size_bytes between 1073741824 and 2147483648 then 'Between 1-2GB'
	when size_bytes <1073741824 then 'Less then 1GB'
	end as Size_category,
	round(Avg(user_rating),2)as Average_rating
from apple_store 
group by Size_category

--What is the Average Size of an app in particular genre:
Select prime_genre, round(avg(size_bytes)) as average_size from Apple_store
group by prime_genre
order by average_size desc;

--Check if there is a correlation between length of the app description and the user rating:
Select 
	case
	when length(b.app_desc)<500 then 'Short'
	when length(b.app_desc) between 500 and 1000 then 'Medium'
	else 'Long'
	end as Desc_Length,
round(avg(a.User_rating),2) as Average_Rating
from apple_store as a
join applestore_description as b on b.app_id = a.app_id
group by Desc_Length
order by Average_rating desc;

--Check the Top Rated Apps for each genre:
SELECT prime_genre, app_name, user_rating
FROM (
    SELECT prime_genre, app_name, user_rating,
           RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
    FROM apple_store
) AS ranked_apps
WHERE rank = 1;



	
	
	





















