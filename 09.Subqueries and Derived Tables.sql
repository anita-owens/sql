/*MySQL Exercise 9: Subqueries and Derived Tables

The main reasons to use subqueries are:
Sometimes they are the most logical way to retrieve the information you want
They can be used to isolate each logical part of a statement, which can be helpful for troubleshooting long and complicated queries
Sometimes they run faster than joins


Subqueries must be enclosed in parentheses. Subqueries have a couple of rules that joins don't:
ORDER BY phrases cannot be used in subqueries (although ORDER BY phrases can still be used in outer queries that contain subqueries).
Subqueries in SELECT or WHERE clauses that return more than one row must be used in combination with operators that are explicitly designed to handle multiple values, such as the IN operator. Otherwise, subqueries in SELECT or WHERE statements can output no more than 1 row.*/

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


/*1) "On the fly calculations" (or, doing calculations as you need them)
One of the main uses of subqueries is to calculate values as you need them. 
This allows you to use a summary calculation in your query without having
to enter the value outputted by the calculation explicitly. 
A situation when this capability would be useful is if you wanted
to see all the records that were greater than the average value
of a subset of your data.*/


%%sql
SELECT *
FROM exam_answers 
WHERE TIMESTAMPDIFF(minute,start_time,end_time) >
    (SELECT AVG(TIMESTAMPDIFF(minute,start_time,end_time)) AS AvgDuration
     FROM exam_answers
     WHERE TIMESTAMPDIFF(minute,start_time,end_time)>0);


/*Question 1: How could you use a subquery to extract all
the data from exam_answers that had test durations
that were greater than the average duration for 
the "Yawn Warm-Up" game? Start by writing the query
 that gives you the average duration for the "Yawn Warm-Up"
  game by itself (and don't forget to exclude negative
   values; your average duration should be about 9934):*/

%sql SHOW columns FROM exam_answers

%%sql
SELECT *, TIMESTAMPDIFF(minute,start_time,end_time) AS AvgYawn
FROM exam_answers
WHERE test_name = 'Yawn Warm-Up'
LIMIT 5

%%sql
SELECT AVG(TIMESTAMPDIFF(minute,start_time,end_time)) AS AvgYawn
FROM exam_answers
WHERE test_name = 'Yawn Warm-Up'
	AND TIMESTAMPDIFF(minute,start_time,end_time) > 0;



/*Question 2: Once you've verified that your subquery is written 
correctly on its own, incorporate it into a main query to extract
all the data from exam_answers that had test durations that
were greater than the average duration for the "Yawn Warm-Up"
game (you will get 11059 rows):*/

#time stamp duration must come before the test name filter.
%%sql
SELECT *
FROM exam_answers
WHERE TIMESTAMPDIFF(minute,start_time,end_time) >
	(SELECT AVG(TIMESTAMPDIFF(minute,start_time,end_time)) AS AvgYawn
	FROM exam_answers
	WHERE TIMESTAMPDIFF(minute,start_time,end_time) > 0
	AND test_name = 'Yawn Warm-Up');


#model query
%%sql
SELECT *
FROM exam_answers
WHERE TIMESTAMPDIFF(minute,start_time,end_time) >
(SELECT AVG(TIMESTAMPDIFF(minute,start_time,end_time)) AS AvgDuration FROM exam_answers
WHERE TIMESTAMPDIFF(minute,start_time,end_time)>0 AND test_name="Yawn Warm-Up");


/*
Now double check the results you just retrieved by replacing the subquery with "9934"; you should get the same results. It is helpful to get into the habit of including these kinds of quality checks into your query-writing process.
This example shows you how subqueries allow you retrieve information dynamically, rather than having to hard code in specific numbers or names. This capability is particularly useful when you need to build the output of your queries into reports or dashboards that are supposed to display real-time information.*/


/*2) Testing membership
Subqueries can also be useful for assessing whether groups of
rows are members of other groups of rows. To use them in this
capacity, we need to know about and practice the IN, NOT IN, EXISTS,
and NOT EXISTS operators.

Recall from MySQL Exercise 2: Selecting Data Subsets Using WHERE that
the IN operator allows you to use a WHERE clause to say how you want
your results to relate to a list of multiple values.
It's basically a condensed way of writing a sequence of OR statements.
The following query would select all the users who live in the state of
North Carolina (abbreviated "NC") or New York (abbreviated "NY"):*/


SELECT * 
FROM users
WHERE state IN ('NC','NY');

#A query that would give an equivalent result would be:
SELECT * 
FROM users
WHERE state ='NC' OR state ='NY';

#A query that would select all the users who do NOT live in the state
#of North Carolina or New York would be:
SELECT * 
FROM users
WHERE state NOT IN ('NC','NY');


/*Question 3: Use an IN operator to determine how 
many entries in the exam_answers tables are from the
"Puzzles", "Numerosity", or "Bark Game" tests.
You should get a count of 163022.*/

%%sql
SELECT COUNT(*)
FROM exam_answers
WHERE subcategory_name IN ('Puzzles', 'Numerosity', 'Bark Game');

/*Question 4: Use a NOT IN operator to determine how many unique 
dogs in the dog table are NOT in the "Working", "Sporting", or
"Herding" breeding groups. You should get an answer of 7961.*/


%%sql
SELECT COUNT(DISTINCT dog_guid)
FROM dogs
WHERE breed_group NOT IN ('Working', 'Sporting', 'Herding')


/*EXISTS and NOT EXISTS perform similar functions to IN and NOT IN, but EXISTS
and NOT EXISTS can only be used in subqueries. The syntax for EXISTS and NOT
 EXISTS statements is a little different than that of IN statements because
 EXISTS is not preceded by a column name or any other expression. The most
 important difference between EXISTS/NOT EXISTS and IN/NOT IN statements,
 though, is that unlike IN/NOT IN statements, EXISTS/NOT EXISTS are
 logical statements. Rather than returning raw data, per se, EXISTS/NOT EXISTS
 statements return a value of TRUE or FALSE. As a practical consequence, 
 EXISTS statements are often written using an asterisk after the SELECT 
 clause rather than explicit column names. The asterisk is faster to write,
 and since the output is just going to be a logical true/false either way,
 it does not matter whether you use an asterisk or explicit column names.
We can use EXISTS and a subquery to compare the users who are in the users
table and dogs table, similar to what we practiced previously using joins.
If we wanted to retrieve a list of all the users in the users table who were also in the dogs table, we could write:*/

%%sql
SELECT DISTINCT u.user_guid AS uUserID
FROM users u
WHERE EXISTS (SELECT d.user_guid
              FROM dogs d 
              WHERE u.user_guid =d.user_guid);
#30967 rows

#You would get the same result if you wrote:
SELECT DISTINCT u.user_guid AS uUserID
FROM users u
WHERE EXISTS (SELECT *
              FROM dogs d 
              WHERE u.user_guid =d.user_guid);


/*Essentially, both of these queries say give me all the distinct user_guids
from the users table that have a value of "TRUE" in my EXISTS clause.
The results would be equivalent to an inner join with GROUP BY query. Now...*/

/*Question 5: How could you determine the number 
of unique users in the users table who were NOT
in the dogs table using a NOT EXISTS clause?
You should get the 2226, the same result as
you got in Question 10 of MySQL Exercise 
8: Joining Tables with Outer Joins.*/

%%sql
SELECT DISTINCT users.user_guid as UserID
FROM users
WHERE NOT EXISTS (SELECT *
					FROM dogs
					WHERE dogs.user_guid=users.user_guid);



/*Question 6: Write a query using an IN clause and equijoin
 syntax that outputs the dog_guid, breed group, state of
 the owner, and zip or the owner for each distinct dog
 in the Working, Sporting, and Herding breed groups.
 (You should get 10,254 rows; the query will be a little
  slower than some of the others we have practiced)*/

%%sql
SELECT DISTINCT dogs.dog_guid, dogs.breed_group, users.state, users.zip
FROM dogs, users
WHERE breed_group IN ('Working','Sporting','Herding')
AND dogs.user_guid=users.user_guid;


#using aliases
%%sql
SELECT DISTINCT d.dog_guid, d.breed_group, u.state, u.zip
FROM dogs d, users u
WHERE breed_group IN ('Working','Sporting','Herding')
AND d.user_guid=u.user_guid;


/*Question 7: Write the same query as in Question 6 using traditional join syntax.*/

%%sql
SELECT DISTINCT dogs.dog_guid, dogs.breed_group, users.state, users.zip
FROM dogs
INNER JOIN users
ON dogs.user_guid=users.user_guid
WHERE breed_group IN ('Working','Sporting','Herding');


/*Question 8: Earlier we examined unique users in the users table
who were NOT in the dogs table. Use a NOT EXISTS clause
to examine all the users in the dogs table that are not in
the users table (you should get 2 rows in your output).*/

#my answer
%%sql
SELECT DISTINCT dogs.user_guid as DogUserID, dogs.dog_guid AS DogDogID
FROM dogs
WHERE NOT EXISTS (SELECT DISTINCT users.user_guid
					FROM users
					WHERE dogs.user_guid=users.user_guid);


#model query
%%sql
SELECT d.user_guid AS dUserID, d.dog_guid AS dDogID FROM dogs d
WHERE NOT EXISTS (SELECT DISTINCT u.user_guid
FROM users u
WHERE d.user_guid =u.user_guid);


/*
Question 9: We saw earlier that user_guid 'ce7b75bc-7144-11e5-ba71-058fbc01cf0b'
still ends up with 1819 rows of output after a left outer join with the
dogs table. If you investigate why, you'll find out that's because there
are duplicate user_guids in the dogs table as well. How would you adapt
the query we wrote earlier (copied below) to only join unique UserIDs
from the users table with unique UserIDs from the dog table?
Join we wrote earlier:*/

SELECT DistinctUUsersID.user_guid AS uUserID, d.user_guid AS dUserID, count(*) AS numrows
FROM (SELECT DISTINCT u.user_guid 
      FROM users u) AS DistinctUUsersID 
LEFT JOIN dogs d
  ON DistinctUUsersID.user_guid=d.user_guid
GROUP BY DistinctUUsersID.user_guid
ORDER BY numrows DESC;

/*Let's build our way up to the correct query. To troubleshoot,
let's only examine the rows related to user_guid
'ce7b75bc-7144-11e5-ba71-058fbc01cf0b', since that's 
the userID that is causing most of the trouble.

Rewrite the query above to only LEFT JOIN distinct user(s)
from the user table whose user_guid='ce7b75bc-7144-11e5-ba71-058fbc01cf0b'.
The first two output columns should have matching user_guids,
and the numrows column should have one row with a value of 1819:*/


/*
Question 10: Now let's prepare and test the inner query for
the right half of the join. Give the dogs table an alias,
and write a query that would select the distinct user_guids
from the dogs table (we will use this query as a inner subquery
in subsequent questions, so you will need an alias to differentiate
the user_guid column of the dogs table from the user_guid column
of the users table).
*/
