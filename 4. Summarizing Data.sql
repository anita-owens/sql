/*MySQL Exercise 4: Summarizing your Data
You will use COUNT and SUM very frequently.
COUNT is the only aggregate function that can work on any type of variable. The other four aggregate functions are only appropriate for numerical data.
All aggregate functions require you to enter either a column name or a "*" in the parentheses after the function word.
Let's begin by exploring the COUNT function.
*/

%load_ext sql
%sql mysql://studentuser:studentpw@mysqlserver/dognitiondb

/*To make this the default database for our queries, 
run this "USE" command:*/
%sql USE dognitiondb


%sql SHOW tables

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
  
  
  /*Question 1: Try combining this query with a WHERE clause to find
how many individual dogs completed tests after March 1, 2014 
(the answer should be 13,289):*/
  
%%sql
SELECT COUNT(DISTINCT dog_guid)
FROM complete_tests
WHERE created_at > '2014-03-01'

/*Question 2: To observe the second difference yourself first, count the number of rows in the dogs table using COUNT(*):*/

%%sql
SELECT COUNT(*)
FROM dogs;

/*Question 3: Now count the number of rows in the exclude column of the dogs table:*/

%%sql
SHOW columns
FROM dogs

%%sql
SELECT COUNT(exclude)
FROM dogs

/*When a column is included in a count function, null values are ignored in the count. When an asterisk is included in a count function, nulls are included in the count.*/

/*Question 4: How many distinct dogs have an exclude flag in the dogs
table (value will be "1")? (the answer should be 853)*/

%%sql
SELECT COUNT(DISTINCT dog_guid)
FROM dogs
WHERE exclude=1;

/*Conveniently, we can combine the SUM function with ISNULL to count exactly how many NULL values there are. Look up "ISNULL" at this link to MySQL functions I included in an earlier lesson:
http://www.w3resource.com/mysql/mysql-functions-and-operators.php
You will see that ISNULL is a logical function that returns a 1 for every row that
has a NULL value in the specified column, and a 0 for everything else. If we
sum up the number of 1s outputted by ISNULL(exclude), then, we should
get the total number of NULL values in the column. Here's what that query
would look like:*/

%%sql
SELECT SUM(ISNULL(exclude))
FROM dogs

/*
The output should return a value of 34,025. When you add that number
 to the 1025 entries that have an exclude flag, you get a total of 35,050,
which is the number of rows reported by SELECT COUNT(*) from dogs.
3. The AVG, MIN, and MAX Functions
AVG, MIN, and MAX all work very similarly to SUM.
During the Dognition test, customers were asked the question: "How surprising were [your dog’s name]’s choices?” after completing a test. Users could choose any number between 1 (not surprising) to 9 (very surprising). We could retrieve the average, minimum, and maximum rating customers gave to this question after completing the "Eye Contact Game" with the following query:
*/
%%sql
SELECT test_name, 
AVG(rating) AS AVG_Rating, 
MIN(rating) AS MIN_Rating, 
MAX(rating) AS MAX_Rating
FROM reviews
WHERE test_name="Eye Contact Game";


/*Question 5: What is the average, minimum, and maximum ratings given
 to "Memory versus Pointing" game? (Your answer should be 3.5584, 0, 
and 9, respectively)*/

%%sql
SELECT test_name, 
AVG(rating) AS AVG_Rating, 
MIN(rating) AS MIN_Rating, 
MAX(rating) AS MAX_Rating
FROM reviews
WHERE test_name="Memory versus Pointing";

/*Question 6: How would you query how much time it took to complete
each test provided in the exam_answers table, in minutes? Title the column
that represents this data "Duration." Note that the exam_answers table has 
over 2 million rows, so if you don't limit your output, it will take longer than 
usual to run this query. (HINT: use the TIMESTAMPDIFF function
described at: 
http://www.w3resource.com/mysql/date-and-time-functions/date-and-time-functions.php. 
It might seem unkind of me to keep suggesting you look up and use new 
functions I haven't demonstrated for you, but I really want you to become 
confident that you know how to look up and use new functions when you need
13 them! It will give you a very competative edge in the business world.)*/

%%sql
SHOW columns
FROM exam_answers

%%sql
SELECT dog_guid, 
TIMESTAMPDIFF(minute start_time,end_time) AS duration
FROM exam_answers;

/*Question 7: Include a column for Dog_Guid, start_time, and
end_time in your query, and examine the output. Do you notice
anything strange?*/

%%sql
SELECT dog_guid, start_time, end_time,
TIMESTAMPDIFF(minute, start_time,end_time) AS duration
FROM exam_answers

%%sql  
SELECT dog_guid, start_time, end_time, 
TIMESTAMPDIFF(minute,start_time,end_time)  AS    Duration 
FROM exam_answers
LIMIT 2000

/*Question 8: What is the average amount of time it took customers to
complete all of the tests in the exam_answers table, if you do not exclude any data (the answer will be approximately 587 minutes)?*/

%%sql
SELECT AVG(TIMESTAMPDIFF(minute, start_time, end_time)) AS duration
FROM exam_answers;

/*Question 9: What is the average amount of time it took customers to complete the "Treat Warm-Up" test, according to the exam_answers table (about 165 minutes, if no data is excluded)?*/
%%sql
SELECT AVG(TIMESTAMPDIFF(minute, start_time, end_time)) AS warmup
FROM exam_answers
WHERE test_name = 'Treat Warm-Up';

/*Question 10: How many possible test names are there in the exam_answers table?*/
%%sql
SELECT COUNT(DISTINCT test_name)
FROM exam_answers;

/*Question 11: What is the minimum and maximum value in the Duration
 column of your query that included the data from the entire table?*/

%%sql
SELECT MIN(TIMESTAMPDIFF(minute, start_time, end_time)) AS Min_duration
FROM exam_answers;


%%sql
SELECT dog_guid,
MIN(TIMESTAMPDIFF(minute, start_time, end_time)) AS Min_duration,
MAX(TIMESTAMPDIFF(minute, start_time, end_time)) AS Max_duration
FROM exam_answers;

%%sql
SELECT
MIN(TIMESTAMPDIFF(minute, start_time, end_time)) AS Min_duration,
MAX(TIMESTAMPDIFF(minute, start_time, end_time)) AS Max_duration
FROM exam_answers;

/*Question 12: How many of these negative Duration entries are there? (the answer should be 620)*/
%%sql
SELECT
COUNT(TIMESTAMPDIFF(minute, start_time, end_time)) AS duration
FROM exam_answers
WHERE TIMESTAMPDIFF(minute, start_time, end_time) < 0;

/*
Question 13: How would you query all the columns of all the rows
that have negative durations so that you could examine whether
 they share any features that might give you clues about what 
caused the entry mistake?*/

%%sql
SELECT *
FROM exam_answers
WHERE TIMESTAMPDIFF(minute, start_time, end_time) < 0;


/*Question 14: What is the average amount of time it took customers 
to complete all of the tests in the exam_answers table when the negative
durations are excluded from your calculation (you should get 11233 
minutes)?*/

%%sql
SELECT AVG(TIMESTAMPDIFF(minute, start_time, end_time)) AS avg_time
FROM exam_answers
WHERE TIMESTAMPDIFF(minute, start_time, end_time) > 0;