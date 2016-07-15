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

%%sql
SELECT DISTINCT state, city
FROM users;

%%sql
SELECT COUNT(*)
FROM
(SELECT DISTINCT state, city
FROM users)
myNewTable;



/*If you wanted the breeds of dogs in the dog table sorted in
alphabetical order, you could query:*/

%%sql
SELECT DISTINCT breed
FROM dogs 
ORDER BY breed

/*Question 2: How would you list all the possible combinations 
of test names and subcategory names in complete_tests table?
 (If you do not limit your output, you should retrieve 45 possible
  combinations)*/
  
%%sql
SHOW columns FROM complete_tests;
  
%%sql
SELECT DISTINCT test_name, subcategory_name
FROM complete_tests;
  
%%sql
SELECT COUNT(*)
FROM
(SELECT DISTINCT test_name, subcategory_name
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
SHOW columns FROM users

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


/*Once your variable is created, using the above command tell Jupyter to format the variable as a csv file using the following syntax:
the_output_name_you_want.csv('the_output_name_you_want.csv')*/

breed_list.csv('breed_list.csv')

/*You should see a link in the output line that says "CSV results." You can click on this link to see the text file in a tab in your browser or to download the file to your computer (exactly how this works will differ depending on your browser and settings, but your options will be the same as if you were trying to open or download a file from any other website.)
You can also open the file directly from the home page of your Jupyter account. Behind the scenes, your csv file was written to your directory on the Jupyter server, so you should now see this file listed in your Jupyter account landing page along with the list of your notebooks. Just like a notebook, you can copy it, rename it, or delete it from your directory by clicking on the check box next to the file and clicking the "duplicate," "rename," or trash can buttons at the top of the page.*/


/*The following description of a function called REPLACE is included in that resource:
"REPLACE(str,from_str,to_str)
Returns the string str with all occurrences of the string from_str replaced by the string to_str. REPLACE() performs a case-sensitive match when searching for from_str."
One thing we could try is using this function to replace any dashes included in the breed names with no character:*/

SELECT DISTINCT breed,
REPLACE(breed,'-','') AS breed_fixed
FROM dogs
ORDER BY breed_fixed


/*
That was helpful, but you'll still notice some issues with the output.
First, the leading dashes are indeed removed in the breed_fixed column, but now the dashes used to separate breeds in entries like 'French Bulldog-Boston Terrier Mix' are missing as well. So REPLACE isn't the right choice to selectively remove leading dashes.
Perhaps we could try using the TRIM function:*/

%%sql
SELECT DISTINCT breed, TRIM(LEADING '-' FROM breed) AS breed_fixed
FROM dogs
ORDER BY breed_fixed

/*
Now it's time to practice using AS, DISTINCT, and ORDER BY in your own queries.*/


/*Question 4: How would you get a list of all the subcategories of Dognition tests,
 in alphabetical order, with no test listed more than once (if you do not limit your
output, you should retrieve 16 rows)?*/
%%sql
SELECT DISTINCT subcategory_name
FROM complete_tests
ORDER BY subcategory_name ASC

/*Question 5: How would you create a text file with a list of all the non-United States 
countries of Dognition customers with no country listed more than once?*/
%%sql

nonUS=%sql SELECT DISTINCT country FROM users ORDER BY country;

nonUS.csv('nonUS.csv')

/*Question 6: How would you find the User ID, Dog ID, and test name of the first 
10 tests to ever be completed in the Dognition database?*/

%sql DESCRIBE complete_tests

%%sql
SELECT user_guid, dog_guid, test_name
FROM complete_tests
LIMIT 10;


/*
Question 7: How would create a text file with a list of all the customers with yearly
 memberships who live in the state of North Carolina (USA) and joined Dognition
after March 1, 2014, sorted so that the most recent member is at the top of the list?*/

%sql DESCRIBE users

%%sql
SHOW COLUMNS FROM users

%%sql
SELECT * 
FROM users
LIMIT 10;


NC_user=%sql SELECT user_guid, created_at, state, subscribed FROM users WHERE state="NC"  AND membership_type=2 AND created_at > '2014-03-01' ORDER BY created_at ASC
NC_user.csv('NC_user.csv')

/*Question 8: See if you can find an SQL function from the list provided at:
http://www.w3resource.com/mysql/mysql-functions-and-operators.php
that would allow you to output all of the distinct breed names in UPPER case.
Create a query that would output a list of these names in upper case, sorted 
in alphabetical order.*/

%%sql
SHOW COLUMNS FROM dogs

%%sql
SELECT UCASE (breed_type)
FROM dogs;

https://duke.box.com/shared/static/l9v2khefe7er98pj1k6oyhmku4tz5wpf.jpg