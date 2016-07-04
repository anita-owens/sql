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

