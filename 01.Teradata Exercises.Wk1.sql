/*Teradata Database Exercises


I suggest that you execute this command at the beginning of every Teradata session. 
To establish ua_dillards as the default database so you will not have to qualify
(prefix) queries and table names with ua_dillards, enter the following SQL
statement in the SQL Scratchpad query panel (top left panel)*/

DATABASE ua_dillards;

Select count(*) from trnsact;

DATABASE ua_dillards;
SELECT TOP 5*
FROM TRNSACT;

SELECT TOP 100 sku, color, size, brand
FROM skuinfo
WHERE brand like '%cal%'
ORDER BY sku ASC;


/*By default, only one SQL statement can be executed at a time.
However, note the Run button has a drop-down menu with one
option being "Run Selected Query". This allows you
to select multiple queries at once and run them all.
For example, run the following two SQL statements by
entering them into the query panel, selecting them with
your mouse, and then selecting “Run Selected Query” from
the Run drop-down:

/*Get to know your data in Teradata
Instead of using SHOW or DESCRIBE to get a list of columns in a table,
use:*/

HELP TABLE [name of table goes here]

HELP TABLE strinfo


/*To get information about a single column in a table, you could write:*/
HELP COLUMN [name of column goes here]


 /* The output of these commands will be a table with several columns. The important columns for
 you to notice are “Column Name”, which tells you the name of the column, and “Nullable”,
 which will have a “Y” if null values are permitted in that column and an “N” if null values are
 not permitted.
 
 One thing that is missing from the information outputted by HELP is whether or not a column is
 a primary or foreign key. In order to get that information, use a SHOW command:*/

SHOW table [insert name of table here];

/*Teradata uses SHOW to give you the actual code that was written to create the table.*/

/* Exercise 1. Use HELP and SHOW to confirm that the relational schema provided to us for
the Dillard’s dataset shows the correct column names and primary keys for each table.*/

SHOW table strinfo;
HELP TABLE strinfo


SHOW table store_msa;
HELP TABLE store_msa

SHOW table skstinfo;
HELP TABLE skstinfo

SELECT *
FROM skstinfo

SHOW table trnsact;
HELP TABLE trnsact


SHOW table skuinfo;
HELP TABLE skuinfo


SHOW table deptinfo;
HELP TABLE deptinfo

/*Look at your raw data

Terdata uses a TOP operator instead of a LIMIT operator to restrict the length of a query output.
Whereas LIMIT comes at the end of a MySQL query, TOP comes immediately after SELECT in a Teradata query. The following statement would select
the first 10 rows of the strinfo table as they are stored in the native database:*/

SELECT TOP 10 *
FROM strinfo

 /* The following statement would select the first 10 rows of the strinfo table, ordered in ascending
 alphabetical order by the city name (you would retrieve names that start with “a”):*/


 SELECT TOP 10 *
 FROM strinfo
 ORDER BY city ASC


 /* The following statement would select the first 10 rows of the strinfo table, ordered in descending
 alphabetical order by the city name (you would retrieve names that start with “w” and “y”):*/

 SELECT TOP 10 *
 FROM strinfo
 ORDER BY city DESC

 /*The documentation for the TOP function can be found here:
http://www.info.teradata.com/htmlpubs/db_ttu_13_10/index.html#page/SQL_Reference/B035_1 146_109A/ch01.3.095.html*/


/*In addition, there is a function available in Teradata (but not MySQL) called SAMPLE that allows
you to select a random sampling of the data in a table:

http://www.teradatawiki.net/2013/10/Teradata-SAMPLE-Function.html

The following query would retrieve 10 random rows from the strinfo table:*/
SELECT *
FROM strinfo
SAMPLE 10

/*The following query would retrieve a random 10% of the rows from the strinfo table:*/
SELECT *
FROM strinfo
SAMPLE .10


/*Exercise 3. Examine lists of distinct values in each of the tables.*/


SELECT distinct store
FROM strinfo

SELECT distinct msa_name
FROM store_msa
#165 rows of values

SELECT distinct retail
FROM skstinfo
#5240 rows of values

SELECT distinct amt
FROM trnsact
#10703 rows of values

/*Exercise 4. Examine instances of transaction table where “amt” is different than “sprice”. 
What did you learn about how the values in “amt”, “quantity”, and “sprice” relate to
one another?
*/

SELECT amt
FROM trnsact
WHERE amt NOT IN sprice;
#Results
10.66
10.50
32.80
9.03
21.60
16.30
23.60

/*Exercise 5: Even though the Dillard’s dataset had primary keys declared and there were not many 
NULL values, there are still many strange entries that likely reflect entry errors.
To see some examples of these likely errors, examine:
(a) rows in the trsnact table that have “0” in their orgprice
column (how could the original price be 0?),
(b) rows in the skstinfo table where both the cost and
retail price are listed as 0.00, and
(c) rows in the skstinfo table where the cost is greater
than the retail price (although occasionally retailers will sell an item at a loss for strategic reasons, it is very unlikely that a manufacturer would provide a suggested retail price that is lower than the cost of the item).
*/

SELECT orgprice
FROM trnsact
WHERE orgprice = 0;

SELECT *
FROM skstinfo
WHERE cost = 0
AND retail=0;

SELECT *
FROM skstinfo
WHERE cost > retailprice;


/*Exercise 6. Write your own queries that retrieve multiple columns in a precise order from a table,
and that restrict the rows retrieved from those columns using “BETWEEN”, “IN”, and 
references to text strings.*/

SELECT *
FROM skstinfo
WHERE cost BETWEEN 10 and 20;

SELECT *
FROM skstinfo
WHERE cost NOT BETWEEN 10 and 20;


SELECT *
FROM 
WHERE

SELECT TOP 10 *
FROM trnsact;

SELECT *
FROM trnsact
WHERE saledate BETWEEN 05/05/11 and 06/05/11
ORDER BY orgprice;
#no data available

SELECT TOP 10 *
FROM strinfo

SELECT *
FROM strinfo
WHERE city ='Jacksonville'
ORDER BY zip;
#RESULTS: 3102JACKSONVILLE FL 32225
#3002 JACKSONVILLE FL 32246
#3302 JACKSONVILLE FL 32256

SELECT city AS allCities
FROM strinfo;


SELECT *
FROM strinfo
WHERE City IN 'Jacksonville';

SELECT COUNT(*)
FROM strinfo;
#Results: 453

SELECT COUNT(DISTINCT city)
FROM strinfo;
#Results 299

SELECT AVG(orgprice)
FROM trnsact;
#Result: 36.78

/*We will not be exporting data from the Dillard’s dataset, so once you feel
- retrieve multiple columns in a precise order from a table
- select distinct rows from a table
- rename columns in a query output
- restrict the data you retrieve to meet certain criteria
- sort your output
- reference parts of text “strings”
- use “BETWEEN” and “IN” in your query statements*/

DATABASE ua_dillards;

