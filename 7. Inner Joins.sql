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


/*Questions 1-4: How many unique dog_guids and user_guids
are there in the reviews and dogs table independently?*/


/*Try the inner join query once with just the dog_guid or
once with just the user_guid clause in the WHERE statement:*/

/*Question 5: How would you extract the user_guid, dog_guid,
breed, breed_type, and breed_group for all animals who completed 
the "Yawn Warm-up" game (you should get 20,845 rows if you
join on dog_guid only)?*/
