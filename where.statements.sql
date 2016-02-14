%%sql
SELECT user_guid, free_start_user
FROM users
WHERE free_start_user=1
LIMIT 5

/*How would you select the Dog IDs for the dogs
in the Dognition data set that were DNA tested
(these should have a 1 in the dna_tested field
of the dogs table)? Try it below (if you do not
limit your output, your query should output data
from 1433 dogs):*/
%%sql
SELECT dog_guid
FROM dogs
WHERE dna_tested=1
LIMIT 5

/*How would you query the User IDs of customers
who bought annual subscriptions, indicated by
a "2" in the membership_type field of the users
table? (If you do not limit the output of this
query, your output should contain 4919 rows.)*/

%sql SHOW columns FROM users

%%sql
SELECT user_guid
FROM users
WHERE membership_type=2
LIMIT 10

"""
/*Strings enclosed in quotation or backticks can be used with many of the same operators as numerical data. For example, imagine that you only wanted to look at data from dogs of the breed "Golden Retrievers." You could query (note that double quotation marks could have been used in this example is well):

SELECT dog_guid, breed
FROM dogs
WHERE breed='golden retriever';

The IN operator allows you to specify multiple values in a WHERE clause. Each of these values must be separated by a comma from the other values, and the entire list of values should be enclosed in parentheses. If you wanted to look at all the data from Golden Retrievers and Poodles, you could certainly use the OR operator, but the IN operator would be even more efficient (note that single quotation marks could have been used in this example, too):

SELECT dog_guid, breed
FROM dogs
WHERE breed IN ("golden retriever","poodle");

The LIKE operator allows you to specify a pattern that the textual data you query has to match. For example, if you wanted to look at all the data from breeds whose names started with "s", you could query:

SELECT dog_guid, breed
FROM dogs
WHERE breed LIKE ("s%");

In this syntax, the percent sign indicates a wild card. Wild cards represent unlimited numbers of missing letters. This is how the placement of the percent sign would affect the results of the query:
WHERE breed LIKE ("s%") = the breed must start with "s", but can have any number of letters after the "s"
WHERE breed LIKE ("%s") = the breed must end with "s", but can have any number of letters before the "s"
WHERE breed LIKE ("%s%") = the breed must contain an "s" somewhere in its name, 
but can have any number of letters before or after the "s"
*/
"""

/* How would you query all the data from customers 
located in the state of North Carolina (abbreviated "NC")
or New York (abbreviated "NY")? If you do not limit
the output of this query, your output should contain 1333 rows.
*/
