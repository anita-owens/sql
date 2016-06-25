/*MySQL Exercise 6: Common Pitfalls of GROUP BY
Segmenting Your Data Using GROUP BY*/

/*There are two main reasons grouped queries can cause problems, especially in MySQL:
1) MySQL gives the user the benefit of the doubt, and assumes we don't make (at least some kinds of) mistakes. Unfortunately, we do make those mistakes.
2) We commonly think about data as spreadsheets that allow you make calculations across rows and columns, and that allow you to keep both raw and aggregated data in the same spreadsheet. Relational databases don't work that way.*/

http://weblogs.sqlteam.com/jeffs/archive/2007/07/20/but-why-must-that-column-be-contained-in-an-aggregate.aspx



%load_ext sql
%sql mysql://studentuser:studentpw@mysqlserver/dognitiondb

/*To make this the default database for our queries, 
run this "USE" command:*/
%sql USE dognitiondb

%sql SHOW tables

Tables_in_dognitiondb:
complete_tests
dogs
exam_answers
reviews
site_activities
users

%sql SHOW columns FROM (enter table name here)