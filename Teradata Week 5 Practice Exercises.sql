/* WEEK 5 TERADATA PRACTICE EXERCISES*/

DATABASE ua_dillards;

SELECT COUNT(*)
FROM trnsact;

/*Exercise 1. How many distinct dates are there in the saledate
column of the transaction table for each month/year combination 
in the database?

EXTRACT is a Teradata function that allows you extract date parts
out of a date: http://www.info.teradata.com/htmlpubs/DB_TTU_14_00/index.html#page/SQL_Reference/B03 5_1145_111A/ch07.077.147.html#ww18265377
The syntax to retrieve the month out of a date (as a number;
there is no function in Teradata that will return the name of the month)
is:
     EXTRACT(MONTH from [fill in column name here])

The syntax to retrieve the year out of a date is:

     EXTRACT(YEAR from [fill in column here])

Use these functions to answer the question in Exercise 1. 
Don’t forget that you can’t use SQL keywords like “month” or “year”
as aliases. 

Instead of writing:*/
EXTRACT(MONTH from [fill in column name here]) AS month

/*Write something like:*/
EXTRACT(MONTH from [fill in column name here]) AS month_num*/

SELECT EXTRACT(YEAR from saledate) AS year_num,
EXTRACT(MONTH from saledate) AS month_num,
EXTRACT(DAY from saledate) AS day_num
FROM trnsact
ORDER BY year_num, month_num, day_num #takes a long time to run

AND EXTRACT(MONTH from saledate)>=6 AND EXTRACT(MONTH from saledate)<=8

#	THIS DOES WORK BUT NOT the distinct function
SELECT COUNT (*)
FROM
(SELECT EXTRACT(YEAR from saledate) AS year_num,
EXTRACT(MONTH from saledate) AS month_num,
EXTRACT(DAY from saledate) AS day_num
FROM trnsact)
myNewTable;


SELECT COUNT (DISTINCT saledate)
FROM trnsact
#389 rows


SELECT Txn_Date, SUM(Sales)
FROM Store_Information
GROUP BY Txn_Date;

#the answer
SELECT EXTRACT(YEAR from saledate) AS year_num, EXTRACT(MONTH from saledate) AS month_year,
COUNT (*) saledate
FROM trnsact
GROUP BY EXTRACT(YEAR from saledate), EXTRACT(MONTH from saledate);
#13

/*Exercise 2. Use a CASE statement within an aggregate function
to determine which sku had the greatest total sales during
the combined summer months of June, July, and August.*/

#SYNTAX
SELECT column1,
CASE column2
WHEN value1 THEN result1
WHEN value2 THEN result2
END
FROM table

#an earlier example
SELECT saledate, SUM(amt) AS returned
FROM trnsact
WHERE stype = 'R'
GROUP BY saledate
ORDER BY returned DESC;

#highest sku with the total number of sales for all dates
SELECT sku, SUM(AMT) AS total_sales
FROM trnsact
WHERE stype = 'P'
GROUP BY sku
ORDER BY total_sales DESC;

#extracting month only
SELECT *
FROM trnsact
WHERE stype = 'P' 
AND EXTRACT(MONTH from saledate)=6

SELECT sku, SUM(AMT) AS total_sales
FROM trnsact
WHERE stype = 'P'
AND saledate >= '2004-06-01' AND saledate <= '2004-08-31' 
GROUP BY sku
ORDER BY total_sales DESC;

SELECT sku, saledate, SUM(AMT) AS total_sales
FROM trnsact
WHERE stype = 'P'
AND saledate >= '2004-06-01' AND saledate <= '2004-08-31' 
GROUP BY sku, saledate
ORDER BY total_sales DESC;

SELECT sku, saledate, SUM(AMT) AS total_sales
FROM trnsact
WHERE stype = 'P'
AND EXTRACT(MONTH from saledate)>=6 AND EXTRACT(MONTH from saledate)<=8
GROUP BY sku, saledate
ORDER BY total_sales DESC;

SELECT sku, SUM(AMT) AS total_sales
FROM trnsact
WHERE stype = 'P'
GROUP BY sku
ORDER BY total_sales DESC

#answer
SELECT sku, SUM(AMT) AS total_sales
FROM trnsact
WHERE stype = 'P'
AND EXTRACT(MONTH from saledate)>=6 AND EXTRACT(MONTH from saledate)<=8
GROUP BY sku
ORDER BY total_sales DESC
#589615 rows total
#4108011 $1,646,017.38

SELECT column1,
CASE column2
WHEN value1 THEN result1
WHEN value2 THEN result2
END
FROM table

#example
SELECT state,
CASE city
WHEN 'Louisville' THEN 'Kentucky'
END
FROM store_msa


#this actually works but it is only part of the solution. how to to total sales for those 3 moths
SELECT sku,
CASE 
WHEN EXTRACT(MONTH from saledate)=6 THEN 'june'
WHEN EXTRACT(MONTH from saledate)=7 THEN 'july'
WHEN EXTRACT(MONTH from saledate)=8 THEN 'august'
END
FROM trnsact


/*Exercise 3. How many distinct dates are there in the
 saledate column of the transaction table for each
 month/year/store combination in the database?
 Sort your results by the number of days per
 combination in ascending order.*/


 #by year only
SELECT EXTRACT(YEAR from saledate) AS year_num,
COUNT (*) saledate
FROM trnsact
GROUP BY EXTRACT(YEAR from saledate)


SELECT store, EXTRACT(YEAR from saledate) AS year_num, EXTRACT(MONTH from saledate) AS month_year,
COUNT (*) saledate
FROM trnsact
GROUP BY store, EXTRACT(YEAR from saledate), EXTRACT(MONTH from saledate);



/*Exercise 4. What is the average daily revenue for
each store/month/year
combination in the database?
Calculate this by dividing the total revenue for a group
by the number of sales days available in the transaction 
table for that group.*/


/*Exercise 5. What is the average daily revenue brought in by 
Dillard’s stores in areas of high, medium, or low levels of
high school education?*/


/*Exercise 6. Compare the average daily revenues of the stores
with the highest median msa_income and the lowest median msa_income. In what city and state were these stores, and which store had a higher average daily revenue?
*/


/*Exercise 7: What is the brand of the sku with the greatest standard deviation in sprice? Only examine skus that have been part of over 100 transactions.*/

