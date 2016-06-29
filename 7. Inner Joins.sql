MySQL Exercise 7: Inner Joins
(Lesson 3: Joining Tables & Lesson 4: Practicing Inner Joins)



%load_ext sql
%sql mysql://studentuser:studentpw@mysqlserver/dognitiondb
%sql USE dognitiondb

%sql SHOW tables

Tables_in_dognitiondb:
complete_tests
dogs
exam_answers
reviews
site_activities
users

%sql SHOW columns FROM (enter table name here)

#SQL INNER JOIN – querying data from three tables
SELECT 
    productID,
    productName,
    categoryName,
    companyName AS supplier
FROM
    products
INNER JOIN
    categories ON categories.categoryID = products.categoryID
INNER JOIN
    suppliers ON suppliers.supplierID = products.supplierID

%%sql
SELECT d.dog_guid AS DogID, d.user_guid AS UserID, AVG(r.rating) AS AvgRating, 
       COUNT(r.rating) AS NumRatings, d.breed, d.breed_group, d.breed_type
FROM dogs d, reviews r
WHERE d.dog_guid=r.dog_guid AND d.user_guid=r.user_guid
GROUP BY d.user_guid
HAVING NumRatings >= 10
ORDER BY AvgRating DESC
LIMIT 200


/*Questions 1-4: How many unique dog_guids and user_guids
are there in the reviews and dogs table independently?*/

%%sql
SELECT *
FROM reviews
LIMIT 5;

%%sql
SELECT COUNT(DISTINCT dog_guid)
FROM reviews

%%sql
SELECT COUNT(DISTINCT user_guid)
FROM reviews

%%sql
SELECT COUNT(DISTINCT dog_guid)
FROM dogs

%%sql
SELECT COUNT(DISTINCT user_guid)
FROM dogs


/*Try the inner join query once with just the dog_guid or
once with just the user_guid clause in the WHERE statement:*/

#implicit join
%%sql
SELECT *
FROM dogs, reviews
WHERE dogs.dog_guid = reviews.dog_guid
LIMIT 5
#1522 rows of data
 

#implicit join
%%sql
SELECT *
FROM dogs, reviews
WHERE dogs.user_guid = reviews.user_guid
LIMIT 5
#36926 rows affected

/*Question 5: How would you extract the user_guid, dog_guid,
breed, breed_type, and breed_group for all animals who completed 
the "Yawn Warm-up" game (you should get 20,845 rows if you
join on dog_guid only)?*/

%sql SHOW columns FROM complete_tests
#user_guid 	dog_guid 	test_name	


%sql SHOW columns FROM dogs
#user_guid 	dog_guid 	breed 	breed_type		breed_group

%%sql
SELECT dogs.user_guid, dogs.dog_guid, dogs.breed, dogs.breed_type, dogs.breed_group
FROM dogs
INNER JOIN complete_tests ON dogs.dog_guid=complete_tests.dog_guid
#193079 rows affected


#implicit join
%%sql
SELECT *
FROM dogs, complete_tests
WHERE dogs.dog_guid = complete_tests.dog_guid
#193079


#implicit join/same number of rows as sample query
%%sql
SELECT *
FROM dogs, complete_tests
WHERE dogs.dog_guid = complete_tests.dog_guid
AND test_name="Yawn Warm-up"
#20845

#my answer
%%sql
SELECT dogs.user_guid AS UserID, dogs.dog_guid AS DogID, dogs.breed, dogs.breed_type, dogs.breed_group
FROM dogs, complete_tests
WHERE dogs.dog_guid=complete_tests.dog_guid
AND complete_tests.test_name = 'Yawn Warm-up'
#20845

#the model answer
%%sql
SELECT d.user_guid AS UserID, d.dog_guid AS DogID, d.breed,
d.breed_type, d.breed_group 
FROM dogs d, complete_tests c
WHERE d.dog_guid=c.dog_guid
AND test_name='Yawn Warm-up';
#20845

/*Question 6: How would you extract the user_guid, membership_type,
and dog_guid of all the golden retrievers who completed at
least 1 Dognition test (you should get 711 rows)?*/

%sql SHOW tables

%sql SHOW columns FROM complete_tests
#created_at		updated_at	user_guid 	dog_guid 	test_name	subcategory_name

%sql SHOW columns FROM dogs
#breed dog_guid user_guid	total_tests_completed

%sql SHOW columns FROM users
#membership_type  user_guid

%%sql
SELECT DISTINCT dogs.user_guid AS UserID, dogs.dog_guid AS DogID, dogs.breed, users.membership_type
FROM dogs, users, complete_tests
WHERE dogs.user_guid=users.user_guid
AND dogs.dog_guid=complete_tests.dog_guid
AND dogs.breed = 'Golden Retriever'
AND dogs.total_tests_completed >= 1;
#711 rows affected.

%%sql
SELECT DISTINCT users.user_guid AS UserID, users.membership_type AS member, dogs.breed
FROM users, dogs, complete_tests
WHERE users.user_guid=dogs.user_guid
AND dogs.dog_guid=complete_tests.dog_guid
AND dogs.breed = 'Golden Retriever'
AND dogs.total_tests_completed >= 1;
#wrong 668 rows affected./joined the wrong column

/*Question 7: How many unique Golden Retrievers who live in North Carolina
are there in the Dognition database (you should get 30)?*/

%sql SHOW columns FROM users
#user_guid  	state

%sql SHOW columns FROM dogs
#breed user_guid

%%sql
SELECT COUNT(DISTINCT dogs.dog_guid)
FROM dogs, users
WHERE dogs.user_guid=users.user_guid
AND dogs.breed = 'Golden Retriever'
AND users.state='NC'
#30

#alternate
%%sql
SELECT u.state AS state, d.breed AS breed, COUNT(DISTINCT d.dog_guid) FROM users u, dogs d
WHERE d.user_guid=u.user_guid AND breed="Golden Retriever"
GROUP BY state
HAVING state="NC";

/*Question 8: How many unique customers within each membership
type provided reviews (there should be 3208 in the membership
type with the greatest number of customers, and 18 in the membership
type with the fewest number of customers)?*/

%sql SHOW columns FROM users
#membership_type  user_guid

%sql SHOW columns FROM reviews
#rating user_guid

#my answer
%%sql
SELECT users.membership_type, COUNT(DISTINCT reviews.user_guid)
FROM  users, reviews
WHERE users.user_guid=reviews.user_guid
GROUP BY users.membership_type

%%sql
SELECT users.membership_type, COUNT(DISTINCT users.user_guid)
FROM reviews, users
WHERE reviews.user_guid=users.user_guid
GROUP BY users.membership_type

#alternate query/model answer
%%sql
SELECT u.membership_type AS Membership, COUNT(DISTINCT r.user_guid) 
FROM users u, reviews r
WHERE u.user_guid=r.user_guid
GROUP BY membership_type;

/*Question 9: For which 3 dog breeds do we have the greatest
amount of site_activity data, (as defined by non-NULL values
in script_detail_id)(your answers should be "Mixed", "Labrador
Retriever", and "Labrador Retriever-Golden Retriever Mix"?*/

#the answer
%%sql
SELECT dogs.breed, COUNT(dogs.breed)
FROM dogs, site_activities
WHERE dogs.dog_guid=site_activities.dog_guid
AND script_detail_id IS NOT NULL
GROUP BY breed
ORDER BY COUNT(dogs.breed) DESC;

Mixed	93415
Labrador Retriever	38804
Labrador Retriever-Golden Retriever Mix	27498


#alternate query
%%sql
SELECT d.breed, COUNT(s.script_detail_id) AS activity
FROM dogs d, site_activities s
WHERE d.dog_guid=s.dog_guid AND s.script_detail_id IS NOT NULL
GROUP BY breed
ORDER BY activity DESC
LIMIT 3;

