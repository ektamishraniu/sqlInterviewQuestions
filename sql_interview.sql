Q1 - The experiment_users table has the following schema:
·  experiment_name
·  experiment_group
·  userid
·  dt

Assume that the triplet (experiment_name, experiment_group, userid) is already deduped.
Find the top 10 (experiment_name, experiment_group) combinations that have the biggest number of users on a given date.

A1 - 
select ex_name,ex_group,count(userid) from ex_users group by ex_name,ex_group order by count(userid) desc fetch first 10 rows only;
---------------------------------------------

Q2 - The user_actions table has the following schema:
·  userid
·  action_type (the type of action, e.g., click, like, etc...)
·  platform (iPhone, Android, etc...)
·  count (number of actions for corresponding action_type)
·  dt

Use experiment_users and user_actions tables to compute
(1) number of users, and
(2) number of actions, per experiment_name, experiment_group, platform, action_type, on a given date.

The possible output schema can look like this:
·  experiment_name
·  experiment_group
·  platform
·  action_type
·  num_users
·  num_actions

A2 -
select t."name",t."group", t."plat", t."action",count(t."user"),sum(t."countof") from (
  (select t1.ex_name "name",t1.ex_group "group",t2.platform "plat",t2.action_type 
  "action",t2.userid "user",t2.count_of "countof"
from ex_users t1, user_actions t2 
where t1.userid = t2.userid) t
) group by t."name",t."group", t."plat", t."action" order by count(t."user") desc;
--------------------------------------------


Q3 - The spam_users table contains spammers and on which date they are spammers:
·  userid
·  spam_date
Use the spam_users table to exclude spammers in the computation in Q2.

A 3 -

select t."name",t."group", t."plat", t."action",count(t."user"),sum(t."countof") from (
  (select t1.ex_name "name",t1.ex_group "group",t2.platform "plat",t2.action_type 
  "action",t2.userid "user",t2.count_of "countof"
from ex_users t1, user_actions t2, spam_users t3 
where t1.userid = t2.userid
and t3.userid <> t1.userid
and t3.userid <> t2.userid) t
) group by t."name",t."group", t."plat", t."action" order by count(t."user") desc;
------------------------------------------------------

Q4 - calculate the cumulative salary of employees from the salary table
A salary table is given and we need to write a single query which prints the cumulative salary of employees. For Example:
Emp  Sal
A    10
B    15
C    20
D    5
OutPut:
Emp  Sal   Cum_Sal
A    10      10
B    15      25
C    20      45
D    5       50

A4 - 
1. via possible use window of function:
select Emp, Sal, sum(Sal) over(order by Emp) as Cum_Sal from employees

2. use self-join

select  e1.Emp, e1.Sal, sum(e2.Sal) as Cum_Sal from employees e1
        inner join employees e2 on e2.Emp <= e1.Emp
group by e1.Emp, e1.Sal
------------------------------------------------------

Q5 - SQL query to find second highest salary?
A5 - https://www.geeksforgeeks.org/sql-query-to-find-second-largest-salary/
SELECT name, MAX(salary) as salary FROM employee 
SELECT name, MAX(salary) AS salary FROM employee WHERE salary < ( SELECT MAX(salary) FROM employee ); 
SELECT *                           FROM employee WHERE salary = ( SELECT DISTINCT(salary) FROM employee ORDER BY salary LIMIT n-1,1);