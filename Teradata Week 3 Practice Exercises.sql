/* WEEK 3 PRACTICE EXERCIES*?/

DATABASE ua_dillards;

/*Exercise 1: (a) Use COUNT and DISTINCT to determine
how many distinct skus there are in the skuinfo, skstinfo,
and trnsact tables. Which skus are common to all tables,
or unique to specific tables?*/

#sample
SQL> SELECT  ID, NAME, AMOUNT, DATE
     FROM CUSTOMERS
     INNER JOIN ORDERS
     ON CUSTOMERS.ID = ORDERS.CUSTOMER_ID;

SELECT COUNT (DISTINCT sku)
FROM skstinfo;
#760212

SELECT COUNT (DISTINCT sku)
FROM skuinfo;
#1564178


SELECT COUNT (DISTINCT sku)
FROM trnsact;
#1564178


SELECT COUNT (DISTINCT sku)
FROM skstinfo
INNER JOIN skuinfo
ON skstinfo.sku = skuinfo.sku;
#120916896 rows total

SELECT *
FROM trnsact
LEFT OUTER JOIN skuinfo 
ON trnsact.sku = skuinfo.sku;
#120916896 rows total

SELECT trnsact.sku, skuinfo.sku
FROM trnsact
INNER JOIN skuinfo
ON trnsact.sku = skuinfo.sku;
#120916896 rows total

SELECT COUNT(trnsact.sku)
FROM trnsact
INNER JOIN skuinfo
ON trnsact.sku = skuinfo.sku;
#120916896

SELECT COUNT(DISTINCT trnsact.sku)
FROM trnsact
INNER JOIN skuinfo
ON trnsact.sku = skuinfo.sku;
#714499

SELECT COUNT(DISTINCT trnsact.sku), COUNT(DISTINCT skuinfo.sku)
FROM trnsact
INNER JOIN skuinfo
ON trnsact.sku = skuinfo.sku;
#714499 714499

SELECT COUNT(DISTINCT trnsact.sku), COUNT(DISTINCT skuinfo.sku), COUNT(DISTINCT skstinfo.sku)
FROM trnsact
INNER JOIN skuinfo
ON trnsact.sku = skuinfo.sku
INNER JOIN skstinfo
ON trnsact.sku = skstinfo.sku;
#start 5:16pm -6:00pm
#542513 542513 542513



/*Exercise 2: Use COUNT and DISTINCT to determine how many distinct
stores there are in the strinfo, store_msa, skstinfo, and
trnsact tables. Which stores are common to all tables, or
unique to specific tables?*/

SELECT COUNT(DISTINCT strinfo.store), COUNT(DISTINCT store_msa.store)
FROM strinfo, store_msa
WHERE strinfo.store=store_msa.store
#333 333


SELECT COUNT(DISTINCT strinfo.store), COUNT(DISTINCT store_msa.store), COUNT(DISTINCT skstinfo.store), COUNT(DISTINCT trnsact.store)
FROM strinfo, store_msa, skstinfo, trnsact
WHERE strinfo.store=store_msa.store
AND skstinfo.store=trnsact.store
#

SELECT COUNT(DISTINCT strinfo.store), COUNT(DISTINCT store_msa.store),
COUNT(DISTINCT skstinfo.store), COUNT(DISTINCT trnsact.store)
FROM strinfo
INNER JOIN skstinfo
ON strinfo.store = skstinfo.store
INNER JOIN trnsact
ON skstinfo.store = trnsact.store
INNER JOIN store_msa
ON store_msa.store=trnsact.store
#Start 10:42am-11:10am no more spool space

SELECT COUNT (DISTINCT store)
FROM strinfo;
#453

SELECT COUNT (DISTINCT store)
FROM store_msa;
#333

SELECT COUNT (DISTINCT store)
FROM skstinfo;
#357

SELECT COUNT (DISTINCT store)
FROM trnsact;
#332

SELECT COUNT (DISTINCT store)
FROM strinfo
UNION
SELECT COUNT (DISTINCT store)
FROM store_msa
UNION
SELECT COUNT (DISTINCT store)
FROM skstinfo
UNION
SELECT COUNT (DISTINCT store)
FROM trnsact;



/*Exercise 3: It turns out that there are many skus in the 
trnsact table that are not skstinfo table. As a consequence,
we will not be able to complete many desirable analyses
of Dillard’s profit, as opposed to revenue, because we
do not have the cost information for all the skus in the
transact table. Examine some of the rows in the trnsact
table that are not in the skstinfo table...can you find
any common features that could explain why the cost
information is missing?*/


/*Exercise 4: Although we can’t complete all the
analyses we’d like to on Dillard’s profit, we can
look at general trends. What is Dillard’s average profit per day?*/

#total sales per day
SELECT saledate, SUM(AMT) AS revenue
FROM trnsact
WHERE stype = 'R'
GROUP BY saledate
ORDER BY revenue DESC;

#average transaction amount per day
SELECT AVG(AMT) AS avg_day
FROM trnsact
WHERE stype = 'R'
GROUP BY saledate;



SELECT SUM(orgprice-sprice) AS profit
from trnsact
GROUP BY saledate
ORDER BY profit DESC;

#389 ROWS

/*Exercise 5: On what day was the total value (in $) of returned
goods the greatest? On what
day was the total number of individual returned items the greatest?*/

SELECT saledate, SUM(amt) AS returned
FROM trnsact
WHERE stype = 'R'
GROUP BY saledate
ORDER BY returned DESC;
#0 4/12/27 3030259.76 (2 DAYS AFTER CHRISTMAS)



SELECT saledate, SUM(quantity) AS num_returned_items
FROM trnsact
WHERE stype = 'R'
GROUP BY saledate
ORDER BY num_returned_items DESC;
#04/12/27 82,512 (2 days after Christmas)


/*Exercise 6: What is the maximum price paid for an item in
our database? What is the minimum price paid for an item in
our database?*/

SELECT MAX(amt) as highest
FROM trnsact
WHERE stype = 'P';
# 6017.00

SELECT MIN(amt) as lowest
FROM trnsact
WHERE stype = 'P';
# 0.00

/*Exercise 7: How many departments have more than 100 brands
associated with them, and what are their descriptions? A 
HAVING clause will be helpful for addressing this question.
You will also need a join to combine the skuinfo and
deptinfo tables in order to retrieve the descriptions
of the departments.*/

#there are 60 departments

SELECT COUNT (DISTINCT BRAND)
FROM SKUINFO
#1952 distinct brands

#getting closer
SELECT COUNT (skuinfo.dept), deptinfo.dept, deptdesc
FROM skuinfo, deptinfo
WHERE skuinfo.dept = deptinfo.dept
GROUP BY skuinfo.dept, deptinfo.dept, deptdesc

#not right
SELECT COUNT (deptinfo.dept), deptdesc
FROM skuinfo, deptinfo
WHERE skuinfo.dept = deptinfo.dept
GROUP BY  deptinfo.dept, deptdesc
HAVING COUNT(skuinfo.brand) >= 100


#implicit join example
SELECT productID, productName, categoryName
FROM products, categories
WHERE products.categoryID = categories.categoryID;

#implicit join
SELECT skuinfo.dept, deptinfo.dept, deptinfo.deptdesc
FROM skuinfo, deptinfo

SELECT count(distinct skuinfo.dept), count(distinct deptinfo.dept), count(distinct deptinfo.deptdesc)
FROM skuinfo, deptinfo
#60 60 60

#i believe this is the answer
SELECT COUNT (DISTINCT deptinfo.dept), deptinfo.dept, deptdesc
FROM skuinfo, deptinfo
WHERE skuinfo.dept = deptinfo.dept
GROUP BY  deptinfo.dept, deptdesc
HAVING COUNT(DISTINCT skuinfo.brand) >= 100
# ANSWER: 3 rows total

#checking answer
SELECT COUNT(DISTINCT BRAND) as Num
FROM skuinfo
where DEPT = 7104
#109 brands

SELECT COUNT(DISTINCT BRAND) as Num
FROM skuinfo
where DEPT = 5203
#118 brands

SELECT COUNT(DISTINCT BRAND) as Num
FROM skuinfo
where DEPT = 4407
#389

/*Exercise 8: Write a query that retrieves the department
descriptions of each of the skus in the skstinfo table.*/

SELECT  *
FROM skstinfo;
# 39230146 rows total

#the answer
SELECT skstinfo.sku, deptinfo.dept, deptdesc
FROM skstinfo, skuinfo, deptinfo
WHERE skstinfo.sku = skuinfo.sku
AND skuinfo.dept = deptinfo.dept;
# 39230146 rows total


#check the answer: 7571017 4907 2.54 9.00
SELECT  * 
FROM skstinfo
WHERE sku = 7571017

SELECT skstinfo.sku, deptinfo.dept, deptdesc
FROM skstinfo, skuinfo, deptinfo
WHERE skstinfo.sku = skuinfo.sku
AND skuinfo.dept = deptinfo.dept
AND skstinfo.sku = 7571017

/*Exercise 9: What department (with department description),
brand, style, and color had the greatest total value of
returned items?*/

#works so far
SELECT skuinfo.dept, skuinfo.style, skuinfo.size, skuinfo.brand, deptdesc
FROM skuinfo, trnsact, deptinfo
WHERE trnsact.sku = skuinfo.sku
AND skuinfo.dept = deptinfo.dept
#120916896 rows tota

#getting warmer
SELECT skuinfo.dept, skuinfo.style, skuinfo.size, skuinfo.brand, deptdesc
FROM skuinfo, trnsact, deptinfo
WHERE trnsact.sku = skuinfo.sku
AND skuinfo.dept = deptinfo.dept
AND stype = 'R'
#9267802 rows total


#the answer
SELECT skuinfo.dept, skuinfo.style, skuinfo.size, skuinfo.brand, deptdesc, SUM (amt) AS returned_items
FROM skuinfo, trnsact, deptinfo
GROUP BY skuinfo.dept, skuinfo.style, skuinfo.size, skuinfo.brand, deptdesc
WHERE trnsact.sku = skuinfo.sku
AND skuinfo.dept = deptinfo.dept
AND stype = 'R'
ORDER BY returned_items DESC;
#2200 9793 NO SIZE LANCOME CELEBRT 339198.70

/*Exercise 10: In what state and zip code is the store that had
the greatest total revenue during the time period monitored in
our dataset?
You will need to join two tables to answer this question,
and will need to divide your answers up according to the
“state” and “zip” fields. Make sure you include both of
these fields in the SELECT and GROUP BY clauses.
Don’t forget to specify that you only want to examine
purchase transactions (not returns).*/

#total sales per day
SELECT saledate, SUM(AMT) AS revenue
FROM trnsact
GROUP BY saledate
ORDER BY revenue DESC;

#the answer
SELECT state, zip, stype, SUM(trnsact.AMT) AS sales
FROM trnsact
INNER JOIN strinfo
ON trnsact.store = strinfo.store
GROUP BY state, zip, stype
HAVING trnsact.stype = 'P'
ORDER BY sales DESC;
# LA 70002 P 24171426.58


