/* WEEK 3 QUIZ*/

DATABASE ua_dillards;

SELECT COUNT(*)
FROM trnsact;

/*1. Given Table A (first table to be entered in the query)
and Table B (second table to be entered in the query)
the query result shown below is a result of what kind of join?*/
#Answer: full outer join

/*2. 
On what day was Dillard’s income based
on total sum of purchases the greatest*/


#total sales per day
SELECT saledate, SUM(AMT) AS revenue
FROM trnsact
WHERE stype = 'P'
GROUP BY saledate
ORDER BY revenue DESC;
#Answer 04/12/18    $19,813,655.17

#ALTERNATE QUERY
SELECT TOP 10 saledate, SUM(amt) AS tot_sales

FROM trnsact

WHERE stype='P'

GROUP BY saledate

ORDER BY tot_sales DESC


/*3. 
What is the deptdesc of the departments that have the top
3 greatest numbers of skus from the skuinfo table
associated with them?*/

#dept numbers from skuinfo table
SELECT dept, COUNT(DISTINCT sku)
FROM skuinfo
GROUP BY dept
ORDER BY COUNT(SKU) DESC;
6006 150815
4505 142108
7106 131106

#answer
SELECT skuinfo.dept, deptdesc, COUNT(DISTINCT sku)
FROM skuinfo
WHERE skuinfo.dept = deptinfo.dept
GROUP BY skuinfo.dept, deptdesc
ORDER BY COUNT(SKU) DESC;

6006 INVEST 150815
4505 POLOMEN 142108
7106 BRIOSO 131106

#MODEL QUERY
SELECT TOP 3 s.dept, d.deptdesc, COUNT(DISTINCT s.sku) AS numskus
FROM skuinfo s 
JOIN deptinfo d
ON s.dept=d.dept
GROUP BY s.dept, d.deptdesc
ORDER BY numskus DESC


/*. 
4. Which table contains the most distinct sku numbers?*/
SELECT COUNT(DISTINCT sku)
FROM skstinfo;

SELECT COUNT(DISTINCT sku)
FROM trnsact;

SELECT COUNT(DISTINCT sku)
FROM skuinfo;


SELECT COUNT(DISTINCT sku) AS skst_table
FROM skstinfo
UNION

SELECT COUNT(DISTINCT sku) AS trnsact_table
FROM trnsact

UNION
SELECT COUNT(DISTINCT sku) AS skuinfo_table
FROM skuinfo;
#Answer:  skuinfotable
714499
760212
1564178


/*5. How many skus are in the skstinfo table, but NOT in the skuinfo table?*/
WRONG-You will need to use a special kind of join to answer this question. Refer to MySQL Exercise 8 “Joining Tables with Outer Joins.”
skst=760212
skuinfo=1564178

SELECT COUNT(DISTINCT SKSTINFO.SKU)
FROM skstinfo, skuinfo
WHERE skstinfo.sku = skuinfo.sku
#760212

SELECT COUNT (DISTINCT skstinfo.sku)
FROM skstinfo
INNER JOIN skuinfo
ON skstinfo.sku = skuinfo.sku;
#760212

/*6. 
What is the average amount of profit Dillard’s made per day?*/

#ANSWER
SELECT SUM(amt-(cost*quantity))/ COUNT(DISTINCT saledate) AS avg_sales
FROM trnsact t JOIN skstinfo si
ON t.sku=si.sku AND t.store=si.store
WHERE stype='P';
# $1,527,903


/*7. 
The store_msa table provides population statistics
about the geographic location around a store.
 Using one query to retrieve your answer, how many MSAs
  are there within the state of North Carolina (abbreviated “NC”),
   and within these MSAs, what is the lowest population level 
   (msa_pop) and highest income level (msa_income)?*/


#answer
SELECT COUNT(store), MIN(msa_pop), MAX(msa_income)
FROM store_msa
WHERE state IN 'NC'
16     339511    36151


/*8. 
What department (with department description), brand, style,
and color brought in the greatest total amount of sales?*/

SELECT skuinfo.dept, deptdesc, skuinfo.brand, skuinfo.style, skuinfo.color, SUM (amt) AS total_sales
FROM skuinfo, trnsact, deptinfo
GROUP BY skuinfo.dept, deptdesc, skuinfo.brand, skuinfo.style, skuinfo.color
WHERE trnsact.sku = skuinfo.sku
AND skuinfo.dept = deptinfo.dept
AND stype = 'P'
ORDER BY total_sales DESC;
#800 CLINIQUE CLINIQUE 6142 DDML 6350866.72

#Model Query
SELECT TOP 20 d.deptdesc, s.dept, s.brand, s.style, s.color, SUM(t.AMT) AS tot_sales

FROM trnsact t, skuinfo s, deptinfo d

WHERE t.sku=s.sku AND s.dept=d.dept AND t.stype='P'

GROUP BY d.deptdesc, s.dept, s.brand, s.style, s.color

ORDER BY tot_sales DESC

/*9. 
How many stores have more than 180,000 distinct skus
associated with them in the skstinfo table?*/

#all the stores and their distinct sku numbers
SELECT store, COUNT(DISTINCT sku)
FROM skstinfo
GROUP BY store
ORDER BY COUNT(DISTINCT SKU) DESC;

#ANSWER
SELECT store, COUNT(DISTINCT sku)
FROM skstinfo
GROUP BY store
HAVING COUNT(DISTINCT sku) > 180000
ORDER BY COUNT(DISTINCT SKU) DESC;
#12 rows total

#MODEL QUERY
SELECT COUNT(DISTINCT sku) AS numskus

FROM skstinfo

GROUP BY store

HAVING numskus > 180000;


/*10. 
What feature(s) differs among all the distinct skus in the 
“cop” department with the “federal” brand and a “rinse wash”
color? Choose all that apply. Note that you will need more
than a single correct selection to answer the question correctly.*/

#inner join
SELECT *
FROM skuinfo
INNER JOIN deptinfo
ON skuinfo.dept=deptinfo.dept
WHERE deptinfo.deptdesc='cop' AND skuinfo.brand='federal' AND skuinfo.color='rinse wash';
#answer: style and size

#gives same 9 rows as above
SELECT skuinfo.dept, deptdesc, skuinfo.sku, skuinfo.brand, skuinfo.color
FROM skuinfo, deptinfo
WHERE skuinfo.dept=deptinfo.dept
HAVING brand='federal' AND color='rinse wash'

#MODEL QUERY
SELECT DISTINCT s.sku, s.dept, s.style, s.color, s.size, s.vendor, s.brand, s.packsize, d.deptdesc, st.retail, st.cost

FROM skuinfo s JOIN deptinfo d

ON s.dept= d.dept JOIN skstinfo st

ON s.sku=st.sku

WHERE d.deptdesc='cop' AND s.brand='federal' AND s.color='rinse wash';

/*11. 
How many skus are in the skuinfo table, but NOT in the skstinfo table?*/
skuinfo=1564178
skstinfo=760212


#ANSWER
SELECT COUNT(DISTINCT sku) AS skuinfo_table
FROM skuinfo
UNION
SELECT COUNT(DISTINCT sku) AS skst_table
FROM skstinfo;
760212
1564178
#DIFFERENCE 803,966

#or
SELECT COUNT(DISTINCT skuinfo.sku)
FROM skstinfo
RIGHT JOIN skuinfo
ON skstinfo.sku=skuinfo.sku
WHERE skstinfo.sku IS NULL;


#model queries
SELECT COUNT(DISTINCT si.sku)
FROM skstinfo st RIGHT JOIN skuinfo si
ON st.sku=si.sku
WHERE st.sku IS NULL;

SELECT COUNT(DISTINCT si.sku)
FROM skuinfo si LEFT JOIN skstinfo st
ON si.sku=st.sku
WHERE st.sku IS NULL;



/*12. 
In what city and state is the store that had the greatest total sum of sales?*/


SELECT state, city, stype, SUM(trnsact.AMT) AS sales
FROM trnsact
INNER JOIN strinfo
ON trnsact.store = strinfo.store
GROUP BY trnsact.store, state, city, stype
HAVING trnsact.stype = 'P'
ORDER BY sales DESC;
#LA METAIRIE P 24171426.58

SELECT top 10 trnsact.store, state, city, SUM(trnsact.AMT) AS sales
FROM trnsact
INNER JOIN strinfo
ON trnsact.store = strinfo.store
WHERE trnsact.stype = 'P'
GROUP BY trnsact.store, state, city
ORDER BY sales DESC;


#model query

SELECT TOP 10 t.store, s.city, s.state, SUM(amt) AS tot_sales

FROM trnsact t JOIN strinfo s

ON t.store=s.store

WHERE stype='P'

GROUP BY t.store, s.state, s.city

ORDER BY tot_sales DESC

/*13.Given Table A (first table to be entered in the query)
and Table B (second table to be entered in the query)
the query result shown below is a result of what kind of join?*/
#left join

/*14.How many states have more than 10 Dillards stores in them?*/
There are 453 rows in table/453 stores

#Total number of stores grouped by states
SELECT state, count(store)
FROM strinfo
GROUP BY state
#31 states total

#answer
SELECT state, count(store)
FROM strinfo
GROUP BY state
ORDER BY COUNT(store) DESC
HAVING COUNT(store)>10;
#15 rows total

#model query
SELECT COUNT(*) AS numstores

FROM strinfo

GROUP BY state

HAVING numstores>10

/*15.What is the suggested retail price of all the skus in
 the “reebok” department with the “skechers” brand
 and a “wht/saphire” color?*/

#join works
SELECT skstinfo.sku, skstinfo.retail, deptdesc, skuinfo.brand, skuinfo.color
FROM skstinfo, skuinfo, deptinfo
WHERE skstinfo.sku=skuinfo.sku
AND skuinfo.dept=deptinfo.dept
AND skuinfo.brand='skechers' AND deptdesc='reebok' AND skuinfo.color='wht/saphire'

#using inner join
SELECT skstinfo.sku, skstinfo.retail, deptdesc, skuinfo.brand, skuinfo.color
FROM skstinfo
INNER JOIN skuinfo
ON skstinfo.sku=skuinfo.sku
INNER JOIN deptinfo
ON skuinfo.dept=deptinfo.dept
WHERE skuinfo.brand='skechers' AND deptdesc='reebok' AND skuinfo.color='wht/saphire'
GROUP BY skstinfo.sku, skstinfo.retail, deptdesc, skuinfo.brand, skuinfo.color
#answer: 29.00

#MODEL QUERY
SELECT DISTINCT s.sku, s.dept, s.color, d.deptdesc, st.retail

FROM skuinfo s JOIN deptinfo d

ON s.dept= d.dept JOIN skstinfo st

ON s.sku=st.sku

WHERE d.deptdesc='reebok' AND s.brand='skechers' AND s.color='wht/saphire';

