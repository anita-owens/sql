
MySQL Exercise 8: Joining Tables with Outer Joins

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


/*Left and Right Joins
Left and right joins use a different sytax than we used in the lesson about inner joins. The method I showed you to execute inner joins tells the database how to relate tables in a WHERE clause like this:
WHERE d.dog_guid=r.dog_guid
I find this syntax -- called the "equijoin" syntax -- to be very intuitive, so I thought it would be a good idea to start with it. However, we can re-write the inner joins in the same syntax used by outer joins. To use this more traditional syntax, you have to tell the database how to connect the tables using an ON clause that comes right after the FROM clause. Make sure to specify the word "JOIN" explicitly. This traditional version of the syntax frees up the WHERE clause for other things you might want to include in your query. Here's what one of our queries from the inner join lesson would look like using the traditional syntax:
*/

SELECT d.dog_guid AS DogID, d.user_guid AS UserID, AVG(r.rating) AS AvgRating, COUNT(r.rating) AS NumRatings, d.breed, d.breed_group, d.breed_type
FROM dogs d JOIN reviews r
  ON d.dog_guid=r.dog_guid AND d.user_guid=r.user_guid
GROUP BY d.user_guid
HAVING NumRatings > 9
ORDER BY AvgRating DESC
LIMIT 200

/*You could also write "INNER JOIN" instead of "JOIN" but the default in MySQL is that JOIN will mean inner join, so including the word "INNER" is optional.
If you need a WHERE clause in the query above, it would go after the ON clause and before the GROUP BY clause.
Here's an example of a different query we used in the last lesson that employed the equijoin syntax:*/

SELECT d.user_guid AS UserID, d.dog_guid AS DogID, 
       d.breed, d.breed_type, d.breed_group
FROM dogs d, complete_tests c
WHERE d.dog_guid=c.dog_guid AND test_name='Yawn Warm-up';


/*Question 1: How would you re-write this query
using the traditional join syntax?*/

%%sql
SELECT dogs.user_guid AS UserID, dogs.dog_guid AS DogID, dogs.breed, dogs.breed_type, dogs.breed_group
FROM dogs
INNER JOIN complete_tests
ON dogs.dog_guid=complete_tests.dog_guid
WHERE complete_tests.test_name = 'Yawn Warm-up'


/*Let's start by using a left outer join to get the list we want. 
When we use the traditional join syntax to write inner joins,
the order you enter the tables in your query doesn't matter.
In outer joins, however, the order matters a lot.
A left outer join will include all of the rows of the table
to the left of the ON clause. A right outer join will include 
all of the rows of the table to the right of the ON clause.
So in order to retrieve a full list of dogs who completed at
least 10 tests in the reviews table, and include as much 
breed information as possible, we could query:*/

SELECT r.dog_guid AS rDogID, d.dog_guid AS dDogID, r.user_guid AS rUserID, d.user_guid AS dUserID, AVG(r.rating) AS AvgRating, COUNT(r.rating) AS NumRatings, d.breed, d.breed_group, d.breed_type
FROM reviews r LEFT JOIN dogs d
  ON r.dog_guid=d.dog_guid AND r.user_guid=d.user_guid
WHERE r.dog_guid IS NOT NULL
GROUP BY r.dog_guid
HAVING NumRatings >= 10
ORDER BY AvgRating DESC;

/*Question 2: How could you retrieve this same information using a RIGHT JOIN?*/
