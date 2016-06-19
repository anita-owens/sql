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

SELECT TOP 10 *
FROM skstinfo;

SELECT *
FROM skstinfo
WHERE cost BETWEEN 10 and 20;

SELECT *
FROM skstinfo
WHERE cost NOT BETWEEN 10 and 20;

SELECT *
FROM skstinfo
WHERE cost NOT BETWEEN 10 and 20
ORDER BY cost ASC;

SELECT *
FROM skstinfo
WHERE cost NOT BETWEEN 10 and 20
ORDER BY cost ASC, store DESC;


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
/*Q4. In how many columns of the STRINFO table of
 the Dillard’s database are NULL values *permitted*?*/

SHOW table strinfo;
HELP TABLE strinfo

 #Answer: 3

/* Q5. In how many columns of the STRINFO table of the Dillard’s
database are NULL values *present*?*/

SHOW table strinfo;
HELP TABLE strinfo


SELECT *
FROM strinfo
WHERE store IS NULL;
#Result: no data available

SELECT *
FROM strinfo
WHERE city IS NULL;

SELECT *
FROM strinfo
WHERE state IS NULL;

SELECT *
FROM strinfo
WHERE zip IS NULL;


/*Q6. What was the highest original price in the Dillard’s database 
of the item with SKU 3631365?*/

SHOW table trnsact;
HELP TABLE trnsact

SELECT TOP 5 *
FROM trnsact;

SELECT *
FROM trnsact
WHERE sku = 3631365
ORDER BY orgprice DESC;

#alternate query
SELECT orgprice, sku
FROM trnsact
WHERE sku = '3631365'
ORDER BY orgprice DESC;

/* Q7.
What is the color of the Liz Claiborne brand item 
with the highest SKU # in the Dillard’s database 
(the Liz Claiborne brand is abbreviated “LIZ CLAI” 
in the Dillard’s database)?*/
SELECT TOP 10 *
FROM skuinfo

SELECT TOP 10 *
FROM skuinfo
WHERE brand = 'Liz Clai'
ORDER BY sku DESC;

#alternate query
SELECT TOP 5 sku, style, color, size, vendor, brand
FROM skuinfo
WHERE brand LIKE '%Liz Clai%'
ORDER BY sku DESC;

/*Q8. What aspect of the following query will make the query crash?*/

SELECT SKU, orgprice, sprice, amt,

FROM TRNSACT

WHERE AMT>50

/*Answer: There is a comma after "amt" in the first line of the query*/

/*Q9. What is the sku number of the item in the Dillard’s database
that had the highest original sales price?*/

SELECT TOP 10 *
FROM trnsact;

SELECT TOP 25 *
FROM trnsact
ORDER BY orgprice DESC;
#6200173

/*Q10. 
According to the strinfo table, in how many states
within the United States are Dillard’s stores located?
(HINT: the bottom of the SQL scratchpad reports the number of rows in your output)*/

SELECT TOP 10 *
FROM strinfo;

SELECT COUNT(DISTINCT state)
FROM strinfo;
#Results 31

#alternate query/output would have been 31 rows total
SELECT DISTINCT state
FROM strinfo;

/*Q11. 
How many Dillard’s departments start with the letter “e”*/

SELECT TOP 10 *
FROM deptinfo;

SELECT *
FROM deptinfo
WHERE deptdesc LIKE 'e%';
#5 rows

#using count function/same results
SELECT COUNT(deptdesc)
FROM deptinfo
WHERE deptdesc LIKE 'e%';

#alternate query
SELECT DISTINCT deptdesc
FROM deptinfo
WHERE deptdesc like 'e%'
ORDER BY deptdesc;

/*Q12. What was the date of the earliest sale in the database
where the sale price of the item did not equal the original
price of the item, and what was the largest margin (original
price minus sale price) of an item sold on that earliest date?*/

SELECT FORMAT(saledate) FROM trnsact;
#YYYY-MM-DD

#attempt 1: top 10 results only
SELECT TOP 10 *
FROM trnsact
WHERE amt <> orgprice
ORDER BY saledate ASC, orgprice DESC;

#attempt 2/takes several minutes to query
SELECT *
FROM trnsact
WHERE amt <> orgprice
ORDER BY saledate ASC;

#attempt 3/answer 04/08/01 600.00 90.0090.00699700063 671
SELECT *
FROM trnsact
WHERE amt <> orgprice
AND saledate = DATE '2004-08-01'
ORDER BY orgprice DESC;

#alternate query
SELECT TOP 100 orgprice, sprice, orgprice-sprice AS margin, saledate
FROM trnsact
WHERE orgprice<>sprice
ORDER BY saledate ASC, margin DESC

#my attempt 4
SELECT TOP 25 orgprice-sprice AS margin, saledate, orgprice
FROM trnsact
WHERE sprice <> orgprice
ORDER BY saledate ASC, margin DESC;

#does not work in Teradata
SELECT MAX(orgprice) - MIN(amt) AS profit
FROM trnsact
WHERE amt <> orgprice
ORDER BY saledate ASC, profit DESC;

/*Q.13. 
What register number made the sale with the highest
original price and highest sale price between the
dates of August 1, 2004 and August 10, 2004? Make
sure to sort by original price first and sale price second.*/

SELECT TOP 1 *
FROM trnsact
WHERE saledate BETWEEN DATE '2004-08-01' AND DATE '2004-08-10'
ORDER BY orgprice DESC, amt DESC;
#Answer: 621

SELECT TOP 100 register, saledate, orgprice, sprice

FROM trnsact

WHERE SALEDATE BETWEEN '2004-08-01' AND '2004-08-10'

ORDER BY orgprice DESC, sprice DESC

/*14. 
Which of the following brand names with
the word/letters “liz” in them exist in
the Dillard’s database? Select all that apply.
Note that you will need more than a single correct
selection to answer the question correctly.*/

SELECT *
FROM skuinfo
WHERE brand LIKE '%liz%';

SELECT COUNT(DISTINCT brand)
FROM skuinfo
WHERE brand LIKE '%Liz%';
#5

SELECT DISTINCT(brand)
FROM skuinfo
WHERE brand LIKE '%liz%';
#answers: liz clai, beliza, liz pala, civilize, elizabet

/*Q15. What is the lowest store number of all the stores in
the STORE_MSA table that are in the city of “little rock”,
”Memphis”, or “tulsa”?*/

SELECT TOP 10 *
FROM store_msa;

SELECT *
FROM store_msa
WHERE city = 'little rock' OR city = 'memphis' OR city ='tulsa'
ORDER BY store ASC;
#504

SELECT store, city
FROM store_msa
WHERE city IN('little rock','memphis','tulsa')
ORDER BY store
