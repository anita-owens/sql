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
The main purpose of CASE expressions is to return a singular value based on one or more conditional tests. You can think of CASE expressions as an efficient way to write a set of IF and ELSEIF statements. There are two viable syntaxes for CASE expressions. If you need to manipulate values in a current column of your data, you would use this syntax:*/

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


/*There are a couple of things to know about CASE expressions:
Make sure to include the word END at the end of the expression
CASE expressions do not require parentheses
ELSE expressions are optional
If an ELSE expression is omitted, NULL values will be outputted for all rows that do not meet any of the conditions stated explicitly in the expression
CASE expressions can be used anywhere in a SQL statement, including in GROUP BY, HAVING, and ORDER BY clauses or the SELECT column list.
You will find that CASE statements are useful in many contexts. For example, they can be used to rename or revise values in a column.*/



/*Question 3: Write a query using a CASE statement that outputs
3 columns: dog_guid, dog_fixed, and a third column that
reads "neutered" every time there is a 1 in the "dog_fixed"
column of dogs, "not neutered" every time there is a value
of 0 in the "dog_fixed" column of dogs, and "NULL" every time
there is a value of anything else in the "dog_fixed" column.
Limit your results for troubleshooting purposes.*/
