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
