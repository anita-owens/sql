/*MySQL Exercise 5: Summaries of Groups of Data
So far you've learned how to select, reformat, manipulate, order, 
and summarize data from a single table in database. In this lesson, 
you are going to learn how to summarize multiple subsets of your 
data in the same query. The method for doing this is to include a
"GROUP BY" clause in your SQL query.*/

/*The GROUP BY clause is easy to incorporate into your queries. In fact, it might 
be a little too easy to incorporate into MySQL queries, because it can be used 
incorrectly in MySQL queries even when no error message is displayed. As a
 consequence, I suggest you adopt a healthy dose of caution every time you use
 the GROUP BY clause. By the end of this lesson, you will understand why. 
When used correctly, though, GROUP BY is one of the most useful and efficient 
parts of an SQL query, and once you are comfortable using it, you will use it very
 frequently.*/

%load_ext sql
%sql mysql://studentuser:studentpw@mysqlserver/dognitiondb

/*To make this the default database for our queries, 
run this "USE" command:*/
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

%%sql
SELECT breed
FROM dogs

%%sql
SELECT COUNT(breed)
FROM dogs

/*When a column is included in the parentheses, null values are automatically ignored. */
%sql DESCRIBE complete_tests

%%sql
SELECT COUNT(DISTINCT dog_guid)
FROM complete_tests

/*
You can form groups using derived values as well as
original columns. To illustrate this, let's address another
question: how many tests were completed during each
month of the year?

MONTH() will return a number representing the
month of a date entry. To get the total number
of tests completed each month, you could put
the MONTH function into the GROUP BY clause, 
in this case through an alias:*/

SELECT test_name, MONTH(created_at) AS Month, COUNT(created_at) AS Num_Completed_Tests
FROM complete_tests
GROUP BY Month;


/*
You can also group by multiple columns or derived
 fields. If we wanted to determine the total number 
of each type of test completed each month, you could
 include both "test_name" and the derived "Month" field 
in the GROUP BY clause, separated by a comma.*/

%%sql
SELECT test_name, MONTH(created_at) AS Month, COUNT(created_at) AS Num_Completed_Tests
FROM complete_tests
GROUP BY test_name, Month;


/*MySQL allows you to use aliases in a GROUP BY
 clause, but some database systems do not. If you are
 using a database system that does NOT accept aliases
 in GROUP BY clauses, you can still group by derived
 fields, but you have to duplicate the calculation for the
 derived field in the GROUP BY clause in addition to 
including the derived field in the SELECT clause:*/

%%sql
SELECT test_name, MONTH(created_at) AS Month, COUNT(created_at) AS Num_Completed_Tests
FROM complete_tests
GROUP BY test_name, MONTH(created_at);

%sql SHOW columns FROM (enter table name here)

/*Question 1: Output a table that calculates the number of
distinct female and male dogs in each breed group of the Dogs
table, sorted by the total number of dogs in descending order
(the sex/breed_group pair with the greatest number of dogs
 should have 8466 unique Dog_Guids):*/

SELECT column_name, aggregate_function(column_name)
FROM table_name
WHERE column_name operator value
GROUP BY column_name;

%sql SHOW columns FROM dogs

%%sql
SELECT *
FROM dogs
LIMIT 5;

%%sql
SELECT DISTINCT breed_group
FROM dogs;

#answer
%%sql
SELECT gender, breed_group, COUNT(DISTINCT dog_guid) AS Num_Dogs
FROM dogs
GROUP BY gender, breed_group
ORDER BY Num_Dogs DESC;

/*Question 2: Revise the query your wrote in Question 1 so that it
uses only numbers in the GROUP BY and ORDER BY fields.*/

%%sql
SELECT gender, breed_group, COUNT(DISTINCT dog_guid) AS Num_Dogs
FROM dogs
GROUP BY 1, 2
ORDER BY 3 DESC;

/*Question 3: Revise the query your wrote in Question 2 so that
 it (1) excludes the NULL and empty string entries in the breed_group 
 field, and (2) excludes any groups that don't have at least 1,000 distinct
 Dog_Guids in them. Your result should contain 8 rows. (HINT: sometimes empty strings are registered as non-NULL values. You might want to include the following line somewhere in your query to exclude these values as well):
breed_group!=""*/

%%sql
SELECT gender, breed_group, COUNT(DISTINCT dog_guid) AS Num_Dogs
FROM dogs
GROUP BY 1, 2
HAVING 2 IS non-NULL, 3 > 1000
ORDER BY 3 DESC;

%%sql
SELECT gender, breed_group, COUNT(DISTINCT dog_guid) AS Num_Dogs
FROM dogs
GROUP BY gender, breed_group
HAVING breed_group != " " AND COUNT(DISTINCT dog_guid) >= 1000
ORDER BY Num_Dogs DESC;

/*Question 4: Write a query that outputs the average number of tests
completed and average mean inter-test-interval for every breed type,
sorted by the average number of completed tests in descending order
(popular hybrid should be the first row in your output).*/

%sql SHOW columns FROM dogs

%%sql
SELECT breed_type, AVG(total_tests_completed) AS Num_Tests, AVG(mean_iti_minutes) AS mean_minutes
FROM dogs
GROUP BY breed_type
ORDER BY Num_Tests DESC;


/*Question 5: Write a query that outputs the average
amount of time it took customers to complete each type
of test where any individual reaction times over
6000 hours are excluded and only average reaction
times that are greater than 0 are included 
(your output should end up with 58 rows).*/

%%sql

%%sql
SELECT test_name, AVG(TIMESTAMPDIFF(hour,start_time,end_time)) AS Duration FROM exam_answers
WHERE TIMESTAMPDIFF(HOUR,start_time,end_time)<6000 and TIMESTAMPDIFF(minute,start_time,end_time) > 0
GROUP BY test_name
ORDER BY Duration desc;


/*
Question 6: Write a query that outputs the total number of
unique User_Guids in each combination of State and ZIP code 
(postal code) in the United States, sorted first by state name
in ascending alphabetical order, and second by total number of
unique User_Guids in descending order (your first state should
be AE and there should be 5043 rows in total in your output).*/

#by state only-292 rows
%%sql
SELECT state, COUNT(DISTINCT user_guid)
FROM users
GROUP BY state

#answer-5043 rows
%%sql
SELECT state, zip, COUNT(DISTINCT user_guid)
FROM users
WHERE Country="US"
GROUP BY state, zip
ORDER BY state ASC, user_guid DESC;

/*Question 7: Write a query that outputs the total
number of unique User_Guids in each combination of
State and ZIP code in the United States that have
at least 5 users, sorted first by state name in
ascending alphabetical order, and second by total
number of unique User_Guids in descending order
(your first state/ZIP code combination should be AZ/86303).*/

#285 rows
%%sql
SELECT state, zip, COUNT(DISTINCT user_guid)
FROM users
WHERE Country="US"
GROUP BY state, zip
HAVING COUNT(DISTINCT user_guid) >=5

#180 rows
%%sql
SELECT state, zip, COUNT(DISTINCT user_guid)
FROM users
WHERE Country="US"
GROUP BY state, zip
HAVING COUNT(DISTINCT user_guid) > 5
ORDER BY state ASC, user_guid DESC;

#alternate code
%%sql
SELECT state, zip, COUNT(DISTINCT user_guid) AS NUM_Users FROM users
WHERE Country="US"
GROUP BY State, zip
HAVING NUM_Users>=5
ORDER BY State ASC, NUM_Users DESC;