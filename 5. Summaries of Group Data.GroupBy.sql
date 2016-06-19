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

/*
You can form groups using derived values as well as
original columns. To illustrate this, let's address another
question: how many tests were completed during each
month of the year?

MONTH() will return a number representing the
month of a date entry. To get the total number
of tests completed each month, you could put
the MONTH function into the GROUP BY clause, 
in this case through an alias:*/

SELECT test_name, MONTH(created_at) AS Month, COUNT(created_at) AS Num_Completed_Tests
FROM complete_tests
GROUP BY Month;


/*
You can also group by multiple columns or derived
 fields. If we wanted to determine the total number 
of each type of test completed each month, you could
 include both "test_name" and the derived "Month" field 
in the GROUP BY clause, separated by a comma.*/

SELECT test_name, MONTH(created_at) AS Month, COUNT(created_at) AS Num_Completed_Tests
FROM complete_tests
GROUP BY test_name, Month;


/*MySQL allows you to use aliases in a GROUP BY
 clause, but some database systems do not. If you are
 using a database system that does NOT accept aliases
 in GROUP BY clauses, you can still group by derived
 fields, but you have to duplicate the calculation for the
 derived field in the GROUP BY clause in addition to 
including the derived field in the SELECT clause:*/

SELECT test_name, MONTH(created_at) AS Month, COUNT(created_at) AS Num_Completed_Tests
FROM complete_tests
GROUP BY test_name, MONTH(created_at);