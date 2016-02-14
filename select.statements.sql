#load sql
%load_ext sql

#connect to database
%sql mysql://studentuser:studentpw@mysqlserver/dognitiondb

#Once you are connected, the output cell (which reads "Out" followed by brackets) will read: "Connected:studentuser@dognitiondb". To make this the default database for our queries, run this "USE" command:
%sql USE dognitiondb


%sql SHOW tables

%sql SHOW columns FROM dogs

%sql DESCRIBE reviews

%sql DESCRIBE complete_tests

%sql DESCRIBE exam_answers

%sql DESCRIBE site_activities

%sql DESCRIBE users

"""
Using SELECT to look at your raw data
SELECT is used anytime you want to retrieve data from a table. In order to retrieve that data, you always have to provide at least two pieces of information:
(1) what you want to select, and      
(2) from where you want to select it.  

The skeleton of a SELECT statement looks like this:
SELECT
FROM

An important note for executing queries in Jupyter: in order to tell Python that you want to execute SQL language on multiple lines, you must include two percent signs in front of the SQL prefix instead of one.
%%sql


You can also select rows of data from different parts of the output table, rather than always just starting at the beginning. To do this, use the OFFSET clause after LIMIT. The number after the OFFSET clause indicates from which row the output will begin querying. Note that the offset of Row 1 of a table is actually 0. Therefore, in the following query:

SELECT breed
FROM dogs LIMIT 10 OFFSET 5;

10 rows of data will be returned, starting at Row 6.

An alternative way to write the OFFSET clause in the query is:
SELECT breed
FROM dogs LIMIT 5, 10;
In this notation, the offset is the number before the comma, and the number of rows returned is the number after the comma.
"""


%%sql
SELECT breed
FROM dogs LIMIT 5, 10;

#Using SELECT to query multiple columns
%%sql
SELECT *
FROM dogs LIMIT 5, 10;

#multiple columns
%%sql
SELECT dog_guid, subcategory_name, test_name
FROM reviews LIMIT 15