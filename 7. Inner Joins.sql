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
