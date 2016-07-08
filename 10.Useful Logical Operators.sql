MySQL Exercise 10: Useful Logical Operators

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


Example
%%sql
SELECT created_at, IF(created_at<'2014-06-01','early_user','late_user') AS user_type
FROM users


/*Question 1: Write a query that will output distinct user_guids and
 their associated country of residence from the users table,
 excluding any user_guids that have NULL values.
 You should get 16,261 rows in your result.*/


%%sql
SELECT DISTINCT user_guid, country
FROM users
WHERE user_guid IS NOT NULL AND country IS NOT NULL
#16261 rows affected.

/*Question 2: Use an IF expression and the query you wrote
in Question 1 as a subquery to determine the number
of unique user_guids who reside in the United States
(abbreviated "US") and outside of the US.*/

%%sql
SELECT DISTINCT user_guid, IF(country='US', 'inside USA', 'outside USA') AS residence
FROM users
WHERE user_guid IS NOT NULL AND country IS NOT NULL
#16261 rows affected.

/*Single IF expressions can only result in one of two specified outputs, but multiple IF expressions can be nested to result in more than two possible outputs. When you nest IF expressions, it is important to encase each IF expression--as well as the entire IF expression put together--in parentheses.
For example, if you examine the entries contained in the non-US countries category, you will see that many users are associated with a country called "N/A." "N/A" is an abbreviation for "Not Applicable"; it is not a real country name. We should separate these entries from the "Outside of the US" category we made earlier. We could use a nested query to say whenever "country" does not equal "US", use the results of a second IF expression to determine whether the outputed value should be "Not Applicable" or "Outside US." The IF expression would look like this:
IF(cleaned_users.country='US','In US', IF(cleaned_users.country='N/A','Not Applicable','Outside US'))
Since the second IF expression is in the position within the IF expression where you specify "value outputted if conditions are not met," its two possible outputs will only be considered if cleaned_users.country='US' is evaluated as false.*/

#example
%%sql
SELECT IF(cleaned_users.country='US','In US', 
          IF(cleaned_users.country='N/A','Not Applicable','Outside US')) AS US_user, 
      count(cleaned_users.user_guid)   
FROM (SELECT DISTINCT user_guid, country 
      FROM users
      WHERE country IS NOT NULL) AS cleaned_users
GROUP BY US_user
#answer
US_user	count(cleaned_users.user_guid)
In US	9356
Not Applicable	5642
Outside US	1263

/*
2. CASE expressions
The main purpose of CASE expressions is to return a singular value based on one
or more conditional tests. You can think of CASE expressions as an efficient way
 to write a set of IF and ELSEIF statements. There are two viable syntaxes
  for CASE expressions. If you need to manipulate values in a current column
   of your data, you would use this syntax:*/

%%sql
SELECT CASE WHEN cleaned_users.country="US" THEN "In US"
            WHEN cleaned_users.country="N/A" THEN "Not Applicable"
            ELSE "Outside US"
            END AS US_user, 
      count(cleaned_users.user_guid)   
FROM (SELECT DISTINCT user_guid, country 
      FROM users
      WHERE country IS NOT NULL) AS cleaned_users
GROUP BY US_user

#answer
US_user	count(cleaned_users.user_guid)
In US	9356
Not Applicable	5642
Outside US	1263


/*There are a couple of things to know about CASE expressions:
Make sure to include the word END at the end of the expression
CASE expressions do not require parentheses
ELSE expressions are optional
If an ELSE expression is omitted, NULL values will be outputted for
 all rows that do not meet any of the conditions stated explicitly in the expression
CASE expressions can be used anywhere in a SQL statement, including in GROUP BY, HAVING, and ORDER BY clauses or the SELECT column list.
You will find that CASE statements are useful in many contexts. For example, they can be used to rename or revise values in a column.*/

CASE V0
WHEN V1 THEN E1 WHEN V2 THEN E2 ...
WHEN VN THEN EN [ELSE ED]
END

%%sql
SELECT CASE WHEN cleaned_users.country="US" THEN "In US"
            WHEN cleaned_users.country="N/A" THEN "Not Applicable"
            ELSE "Outside US"
            END AS US_user, 
      count(cleaned_users.user_guid)   
FROM (SELECT DISTINCT user_guid, country 
      FROM users
      WHERE country IS NOT NULL) AS cleaned_users
GROUP BY US_user

/*Question 3: Write a query using a CASE statement that outputs
3 columns: dog_guid, dog_fixed, and a third column that
reads "neutered" every time there is a 1 in the "dog_fixed"
column of dogs, "not neutered" every time there is a value
of 0 in the "dog_fixed" column of dogs, and "NULL" every time
there is a value of anything else in the "dog_fixed" column.
Limit your results for troubleshooting purposes.*/

%%sql
SELECT dog_guid, dog_fixed,
	CASE 
	WHEN dog_fixed = 1 THEN 'neutered'
	WHEN dog_guid = 0 THEN 'not neutered'
	ELSE 'Null'
	END AS 'animal_status'
FROM(SELECT DISTINCT dog_guid, dog_fixed
	FROM dogs) AS dogID
LIMIT 25;


#model query
%%sql
SELECT dog_guid, dog_fixed,
CASE dog_fixed
WHEN "1" THEN "neutered" WHEN "0" THEN "not neutered"
END AS neutered FROM dogs
LIMIT 200;

/*
You can also use CASE statements to standardize or combine 
several values into one.

Question 4: We learned that NULL values should be treated
the same as "0" values in the exclude columns of the dogs
and users tables. Write a query using a CASE statement
that outputs 3 columns: dog_guid, exclude, and a third column 
that reads "exclude" every time there is a 1 in the "exclude"
column of dogs and "keep" every time there is any other value
in the exclude column. Limit your results for troubleshooting
purposes.*/


%%sql
SELECT dog_guid, exclude,
	CASE 
	WHEN exclude = 1 THEN 'exclude'
	ELSE 'keep'
	END AS 'status'
FROM(SELECT DISTINCT dog_guid, exclude
	FROM dogs) AS dogID
LIMIT 25;

#model query
%%sql
SELECT dog_guid, exclude,
CASE exclude
WHEN "1" THEN "exclude" ELSE "keep"
END AS exclude_cleaned FROM dogs
LIMIT 200;


/*Question 5: Re-write your query from Question 4 using an 
IF statement instead of a CASE statement.*/

#answer
SELECT DISTINCT dog_guid, exclude, IF(exclude='1', 'exclude', 'keep') AS exclude_group 
FROM dogs 
LIMIT 25;

#model query
%%sql
SELECT dog_guid, exclude, IF(exclude="1","exclude","keep") AS exclude_cleaned FROM dogs
LIMIT 200;


/*Case expressions are also useful for breaking values in a column up
into multiple groups that meet specific criteria or that have specific ranges of values.

Question 6: Write a query that uses a CASE expression to output
3 columns: dog_guid, weight, and a third column that reads...
"very small" when a dog's weight is 1-10 pounds
"small" when a dog's weight is greater than 10 pounds to 30 pounds
"medium" when a dog's weight is greater than 30 pounds to 50 pounds
"large" when a dog's weight is greater than 50 pounds to 85 pounds
"very large" when a dog's weight is greater than 85 pounds
Limit your results for troubleshooting purposes.*/


%%sql
SELECT dog_guid, weight,
	CASE 
	WHEN weight  >1 AND  weight<=10 THEN 'very small'
	WHEN weight  >10 AND weight<=30 THEN 'small'
	WHEN weight  >30 AND weight<=50 THEN 'medium'
	WHEN weight >50 AND weight<=85 THEN 'large'
	WHEN weight >85 THEN 'very large'
	ELSE 'Null'
	END AS 'dog_size'
FROM(SELECT DISTINCT dog_guid, weight
	FROM dogs) AS dogID
LIMIT 5;


%%sql
SELECT dog_guid, weight,
	CASE 
	WHEN weight >=85 THEN 'very large'
	WHEN weight >=50 THEN 'large'
	WHEN weight >=30 THEN 'medium'
	WHEN weight >=10 THEN 'small'
	WHEN weight >=1 THEN 'small'
	ELSE 'Null'
	END AS 'dog_size'
FROM(SELECT DISTINCT dog_guid, weight
	FROM dogs) AS dogID
LIMIT 50;


#model query
%%sql 
SELECT dog_guid, weight,
CASE
WHEN weight<=10 THEN "very small"
WHEN weight>10 AND weight<=30 THEN "small" WHEN weight>30 AND weight<=50 THEN "medium" WHEN weight>50 AND weight<=85 THEN "large" WHEN weight>85 THEN "very large"
END AS weight_grouped FROM dogs
LIMIT 200;


/*Question 7: How many distinct dog_guids are found in group 1 using this query?*/

%%sql
SELECT COUNT(DISTINCT dog_guid), 
CASE WHEN breed_group='Sporting' OR breed_group='Herding' AND exclude!='1' THEN "group 1"
     ELSE "everything else"
     END AS groups
FROM dogs
GROUP BY groups

#answer
COUNT(DISTINCT dog_guid)	groups
30179	everything else
4871	group 1


/*Question 8: How many distinct dog_guids are found in group 1 using this query?*/

%%sql
SELECT COUNT(DISTINCT dog_guid), 
CASE WHEN exclude!='1' AND breed_group='Sporting' OR breed_group='Herding' THEN "group 1"
     ELSE "everything else"
     END AS group_name
FROM dogs
GROUP BY group_name;

#answer
COUNT(DISTINCT dog_guid)	group_name
31589	everything else
3461	group 1

/*Question 9: How many distinct dog_guids are found in group 1 using this query?*/

%%sql
SELECT COUNT(DISTINCT dog_guid), 
CASE WHEN exclude!='1' AND (breed_group='Sporting' OR breed_group='Herding') THEN "group 1"
     ELSE "everything else"
     END AS group_name
FROM dogs
GROUP BY group_name;

#answer
COUNT(DISTINCT dog_guid)	group_name
35004	everything else
46	group 1

/*Question 10: For each dog_guid, output its dog_guid, breed_type,
number of completed tests, and use an IF statement to include 
an extra column that reads "Pure_Breed" whenever breed_type equals
'Pure Breed" and "Not_Pure_Breed" whenever breed_type equals anything
else. LIMIT your output to 50 rows for troubleshooting.
HINT: you will need to use a join to complete this query.*/


#my answer
%%sql
SELECT DISTINCT dog_guid, breed_type, total_tests_completed, IF(breed_type='Pure Breed', 'Pure_Breed', 'Not_Pure_Breed') AS Breed
FROM dogs
LIMIT 50;


#the correct answer
%%sql
SELECT d.dog_guid AS dogID, d.breed_type AS breed_type, count(c.created_at) AS numtests,
IF(d.breed_type='Pure Breed','pure_breed', 'not_pure_breed') AS pure_breed FROM dogs d, complete_tests c
WHERE d.dog_guid=c.dog_guid
GROUP BY dogID
LIMIT 50;

/*Question 11: Write a query that uses a CASE statement to report the 
number of unique user_guids associated with customers who live in the United
States and who are in the following groups of states:
Group 1: New York (abbreviated "NY") or New Jersey (abbreviated "NJ")
Group 2: North Carolina (abbreviated "NC") or South Carolina (abbreviated "SC")
Group 3: California (abbreviated "CA")
Group 4: All other states with non-null values
You should find 898 unique user_guids in Group1.*/

%%sql
SELECT COUNT(DISTINCT user_guid) AS UserID, country,
	CASE 
	WHEN country='US' AND (state='NY' OR state='NJ') THEN 'group1'
	WHEN country='US' AND (state='NC' OR state='SC') THEN 'group2'
	WHEN country='US' AND state='CA' THEN 'group3'
	ELSE 'non-null values'
	END AS state_group
FROM users
GROUP BY state_group;

#results
UserID	country	state_group
898	US	group1
653	US	group2
1417	US	group3
30225	US	non-null values

#alternate query
%%sql
SELECT COUNT(DISTINCT user_guid) AS Num_UserID,
	CASE 
	WHEN state='NY' OR state='NJ' THEN 'group1'
	WHEN state='NC' OR state='SC' THEN 'group2'
	WHEN state='CA' THEN 'group3'
	ELSE 'non-null values'
	END AS state_group
FROM users
WHERE country='US'
GROUP BY state_group;

#results
Num_UserID	state_group
898	group1
653	group2
1417	group3
6388	non-null values


#model query
%%sql
SELECT COUNT(DISTINCT user_guid),
CASE
WHEN (state="NY" OR state="NJ") THEN "Group 1-NY/NJ" WHEN (state="NC" OR state="SC") THEN "Group 2-NC/SC" WHEN state="CA" THEN "Group 3-CA"
ELSE "Group 4-Other"
END AS state_group FROM users
WHERE country="US" AND state IS NOT NULL GROUP BY state_group;

#results
COUNT(DISTINCT user_guid)	state_group
898	Group 1-NY/NJ
653	Group 2-NC/SC
1417	Group 3-CA
6388	Group 4-Other

/*
Question 12: Write a query that allows you to determine how
many unique dog_guids are associated with dogs who are DNA
tested and have either stargazer or socialite personality dimensions.
Your answer should be 70.*/


#this is for all dog id's---35050 rows affected
%%sql
SELECT dog_guid, dna_tested,
	CASE 
	WHEN dna_tested='1' AND (dimension='stargazer' OR dimension='socialite') THEN 'group1'
	ELSE 'all others'
	END AS personality_tested
FROM(SELECT DISTINCT dog_guid, dna_tested, dimension
	FROM dogs) AS dogID;

%%sql
SELECT COUNT(DISTINCT dog_guid), dna_tested,
	CASE 
	WHEN dna_tested='1' AND (dimension='stargazer' OR dimension='socialite') THEN 'group1'
	ELSE 'all others'
	END AS personality_tested
FROM dogs
GROUP BY personality_tested;



Field	Type	Null	Key	Default	Extra
gender	varchar(255)	YES		None	
birthday	varchar(255)	YES		None	
breed	varchar(255)	YES		None	
weight	int(11)	YES		None	
dog_fixed	tinyint(1)	YES		None	
dna_tested	tinyint(1)	YES		None	
created_at	datetime	NO		None	
updated_at	datetime	NO		None	
dimension	varchar(255)	YES		None	
exclude	tinyint(1)	YES		None	
breed_type	varchar(255)	YES		None	
breed_group	varchar(255)	YES		None	
dog_guid	varchar(60)	YES	MUL	None	
user_guid	varchar(60)	YES	MUL	None	
total_tests_completed	varchar(255)	YES		None	
mean_iti_days	varchar(255)	YES		None	
mean_iti_minutes	varchar(255)	YES		None	
median_iti_days	varchar(255)	YES		None	
median_iti_minutes	varchar(255)	YES		None	
time_diff_between_first_and_last_game_days	varchar(255)	YES		None	
time_diff_between_first_and_last_game_minutes	varchar(255)	YES		None	