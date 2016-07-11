MySQL Exercise 11: Queries that Test Relationships Between Test Completion and Dog Characteristics

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



/*Question 1: To get a feeling for what kind of values exist in the
Dognition personality dimension column, write a query that will output
all of the distinct values in the dimension column. Use your relational
schema or the course materials to determine what table the dimension
column is in. Your output should have 11 rows.
*/


%%sql
SELECT DISTINCT dimension
FROM dogs

#results
dimension
charmer
protodog
None
einstein
stargazer
maverick
socialite
ace
expert
renaissance-dog

%%sql
SELECT dimension,COUNT(dimension)
FROM dogs
GROUP BY dimension


/*Question 2: Use the equijoin syntax (described in MySQL Exercise 8)
to write a query that will output the Dognition personality dimension
and total number of tests completed by each unique DogID. This query
will be used as an inner subquery in the next question. LIMIT your
output to 100 rows for troubleshooting purposes.*/

#just using the dogs table
%%sql
SELECT DISTINCT dog_guid, dimension, total_tests_completed
FROM dogs
LIMIT 100;

#gets the number of tests per dog in complete_tests table
%%sql
SELECT dog_guid, COUNT(dog_guid) AS num_of_tests
FROM complete_tests
GROUP BY dog_guid
LIMIT 100;

#answer using an equijoin syntax
%%sql
SELECT complete_tests.dog_guid, COUNT(complete_tests.dog_guid) AS num_of_tests, dogs.dimension
FROM dogs, complete_tests
WHERE dogs.dog_guid=complete_tests.dog_guid
GROUP BY dog_guid
LIMIT 100;

#model query
%%sql
SELECT d.dog_guid AS dogID, d.dimension AS dimension, count(c.created_at) AS numtests
FROM dogs d, complete_tests c
WHERE d.dog_guid=c.dog_guid
GROUP BY dogID
LIMIT 100;

/*Question 3: Re-write the query in Question 2 using
traditional join syntax (described in MySQL Exercise 8).*/

%%sql
SELECT complete_tests.dog_guid, COUNT(complete_tests.dog_guid) AS num_of_tests, dogs.dimension
FROM complete_tests
INNER JOIN dogs
ON dogs.dog_guid=complete_tests.dog_guid
GROUP BY dog_guid
LIMIT 100;

/*Question 4: To start, write a query that will output the
average number of tests completed by unique dogs
in each Dognition personality dimension. Choose either
the query in Question 2 or 3 to serve as an inner query
in your main query. If you have trouble, make sure you 
use the appropriate aliases in your GROUP BY and SELECT
statements.   You should retrieve an output of 11 rows
with one of the dimensions labeled "None" and another
labeled "" (nothing is between the quotation marks).
*/

#wrong
%%sql
SELECT dimension, AVG(num_of_tests_completed.num_of_tests)
FROM (SELECT complete_tests.dog_guid, COUNT(complete_tests.dog_guid) AS num_of_tests, dogs.dimension
FROM complete_tests
INNER JOIN dogs
ON dogs.dog_guid=complete_tests.dog_guid
GROUP BY dog_guid) AS num_of_tests_completed


#model query
%%sql
SELECT dimension, AVG(numtests_per_dog.numtests) AS avg_tests_completed
FROM( SELECT d.dog_guid AS dogID, d.dimension AS dimension, count(c.created_at) AS numtests
FROM dogs d, complete_tests c
WHERE d.dog_guid=c.dog_guid
GROUP BY dogID) AS numtests_per_dog
GROUP BY numtests_per_dog.dimension;


/*Question 5: How many unique DogIDs are summarized in
the Dognition dimensions labeled "None" or ""?
(You should retrieve values of 13,705 and 71)*/

#35050 distinct dog_guid's in dogs table
#30746 where dimension is null
#4304 where dimension is not null
#92 WHERE DIMENSION=' '
#17986 distinct dog_guid in complete_tests table

%%sql
SELECT dogs.dimension, COUNT(DISTINCT complete_tests.dog_guid) AS num_of_tests
FROM dogs, complete_tests
WHERE dogs.dog_guid=complete_tests.dog_guid
AND dimension="None" OR dimension=" "
GROUP BY dimension;


#MODEL QUERY
%%sql
SELECT dimension, COUNT(DISTINCT dogID) AS num_dogs FROM( SELECT d.dog_guid AS dogID, d.dimension AS dimension
FROM dogs d JOIN complete_tests c ON d.dog_guid=c.dog_guid
WHERE d.dimension IS NULL OR d.dimension='' GROUP BY dogID) AS dogs_in_complete_tests GROUP BY dimension;

#join
%%sql
SELECT complete_tests.dog_guid, COUNT(complete_tests.dog_guid) AS num_of_tests, dogs.dimension
FROM dogs, complete_tests
WHERE dogs.dog_guid=complete_tests.dog_guid
GROUP BY dog_guid
LIMIT 100;

/*Question 6: To determine whether there are any features
that are common to all dogs that have non-NULL empty
strings in the dimension column, write a query that outputs
the breed, weight, value in the "exclude" column, first or
minimum time stamp in the complete_tests table, last or
maximum time stamp in the complete_tests table, and total
number of tests completed by each unique DogID that has a
non-NULL empty string in the dimension column.*/

/*Question 7: Rewrite the query in Question 4 to exclude DogIDs with (1) non-NULL empty strings in the dimension column, (2) NULL values in the dimension column, and (3) values of "1" in the exclude column. NOTES AND HINTS: You cannot use a clause that says d.exclude does not equal 1 to remove rows that have exclude flags, because Dognition clarified that both NULL values and 0 values in the "exclude" column are valid data. A clause that says you should only include values that are not equal to 1 would remove the rows that have NULL values in the exclude column, because NULL values are never included in equals statements (as we learned in the join lessons). In addition, although it should not matter for this query, practice including parentheses with your OR and AND statements that accurately reflect the logic you intend. Your results should return 402 DogIDs in the ace dimension and 626 dogs in the charmer dimension.*/


/*Questions 8: Write a query that will output all of the distinct values in the breed_group field.*/


/*Question 9: Write a query that outputs the breed, weight, value in the "exclude" column, first or minimum time stamp in the complete_tests table, last or maximum time stamp in the complete_tests table, and total number of tests completed by each unique DogID that has a NULL value in the breed_group column.*/


 /*Question 10: Adapt the query in Question 7 to examine the relationship between breed_group and number of tests completed. Exclude DogIDs with values of "1" in the exclude column. Your results should return 1774 DogIDs in the Herding breed group.*/


 /*Question 11: Adapt the query in Question 10 to only report results for Sporting, Hound, Herding, and Working breed_groups using an IN clause.*/
 
