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
