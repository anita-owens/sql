/*Begin by loading the SQL library into Jupyter, connecting to the Dognition database, and setting Dognition as the default database.
%load_ext sql
%sql mysql://studentuser:studentpw@mysqlserver/dognitiondb
%sql USE dognitiondb*/

/*Question 1: How would you change the title of the "start_time" 
field in the exam_answers table to "exam start time" in a query
output? Try it below:*/

%%sql
SHOW columns FROM exam_answers

/*
#OUTPUT
Field	Type	Null	Key	Default	Extra
script_detail_id	int(11)	YES		None	
subcategory_name	varchar(255)	YES		None	
test_name	varchar(255)	YES		None	
step_type	varchar(255)	YES		None	
start_time	datetime	YES		None	
end_time	datetime	YES		None	
loop_number	int(11)	YES		None	
dog_guid	varchar(60)	YES		None	
*/

/*Use DISTINCT to remove duplicate rows*/
SELECT DISTINCT breed
FROM dogs;

/*When the DISTINCT clause is used with multiple columns in a 
SELECT statement, the combination of all the columns together
 is used to determine the uniqueness of a row in a result set.
For example, if you wanted to know all the possible combinations 
of states and cities in the users table, you could query:*/

SELECT DISTINCT state, city
FROM users;

/*Question 2: How would you list all the possible combinations 
of test names and subcategory names in complete_tests table?
 (If you do not limit your output, you should retrieve 45 possible
  combinations)*/
  SELECT DISTINCT test_names, subcategory_names
  FROM complete_tests;
  
  
  SELECT COUNT(*)
  FROM
  (SELECT DISTINCT test_names, subcategory_names
  FROM complete_tests)
  myNewTable;
  
  
  /*Use ORDER BY to sort the output of your query. Your 
  ORDER BY clause will come after everything else in the
main part of your query, but before a LIMIT clause.*/

%%sql
SELECT DISTINCT breed
FROM dogs 
ORDER BY breed
  
  
/*The default is to sort the output in ascending order. 
However, you can tell SQL to sort the output in descending 
order as well:*/

%%sql
SELECT DISTINCT breed
FROM dogs 
ORDER BY breed DESC

/*Combining ORDER BY with LIMIT gives you an easy way to
select the "top 10" and "last 10" in a list or column. For example, 
you could select the User IDs and Dog IDs of the 5 customer-dog
pairs who spent the least median amount of time between their
Dognition tests:*/

%%sql
SELECT DISTINCT user_guid, median_ITI_minutes
FROM dogs 
ORDER BY median_ITI_minutes
LIMIT 5

/*or the greatest median amount of time between their Dognition tests:*/
%%sql
SELECT DISTINCT user_guid, median_ITI_minutes
FROM dogs 
ORDER BY median_ITI_minutes DESC
LIMIT 5

/*If you wanted to select all the distinct User IDs of customers in 
the United States (abbreviated "US") and sort them according
 to the states they live in in alphabetical order first, and
membership type second, you could query:*/
%%sql
SELECT DISTINCT user_guid, state, membership_type
FROM users
WHERE country="US"
ORDER BY state ASC, membership_type ASC

/*Question 3: Below, try executing a query that would sort
 the same output as described above by membership_type first
in descending order, and state second in ascending order:*/
%%sql
SELECT DISTINCT user_guid, state, membership_type
FROM users
WHERE country="US"
ORDER BY membership_type ASC, state ASC

/*Export your query results to a text file.
There are two ways to export your query results using our Jupyter interface.
1.You can select and copy the output you see in an output window, and paste
it into another program. Although this strategy is very simple, it only works if 
your output is very limited in size (since you can only paste 1000 rows at a time).
2. You can tell MySQL to put the results of a query into a variable (for our purposes 
consider a variable to be a temporary holding place), and then use Python code to
 format the data in the variable as a CSV file (comma separated value file, a .CSV file)
that can be downloaded. When you use this strategy, all of the results of a query will
be saved into the variable, not just the first 1000 rows as displayed in Jupyter, even if
we have set up Jupyter to only display 1000 rows of the output.*/

variable_name_of_your_choice = %sql [your full query goes here];

breed_list = %sql SELECT DISTINCT breed FROM dogs ORDER BY breed;


/*Question 4: How would you get a list of all the subcategories of Dognition tests,
 in alphabetical order, with no test listed more than once (if you do not limit your
output, you should retrieve 16 rows)?*/
%%sql


/*Question 5: How would you create a text file with a list of all the non-United States 
countries of Dognition customers with no country listed more than once?*/
%%sql

/*Question 6: How would you find the User ID, Dog ID, and test name of the first 
10 tests to ever be completed in the Dognition database?*/
%%sql

/*
Question 7: How would create a text file with a list of all the customers with yearly
 memberships who live in the state of North Carolina (USA) and joined Dognition
after March 1, 2014, sorted so that the most recent member is at the top of the list?*/
%%sql

/*Question 8: See if you can find an SQL function from the list provided at:
http://www.w3resource.com/mysql/mysql-functions-and-operators.php
that would allow you to output all of the distinct breed names in UPPER case.
Create a query that would output a list of these names in upper case, sorted 
in alphabetical order.*/
%%sql


https://duke.box.com/shared/static/l9v2khefe7er98pj1k6oyhmku4tz5wpf.jpg