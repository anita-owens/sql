/*GOOGLE BIG QUERY*/

#girl names in Florida

SELECT name, number, year
FROM [bigquery-public-data:usa_names.usa_1910_2013]
WHERE state='FL' AND gender='F'
GROUP BY name, number, year
ORDER BY number DESC
LIMIT 10;


