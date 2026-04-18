drop database jobs_market;
create database jobs_market;
drop table jobs;
use jobs_market;
CREATE TABLE job_market_dataset (
    job_id INT PRIMARY KEY,
    title VARCHAR(100),
    company VARCHAR(100),
    location VARCHAR(100),
    salary FLOAT,
    experience INT,
    skills TEXT,
    posted_date DATE
);

select * from job_market_dataset;
drop table jobs;
RENAME TABLE job_market_dataset to jobs;

SET SQL_SAFE_UPDATES = 0;

## Data Cleaning
## Remove null salaries
DELETE FROM jobs where salary IS NULL;

##  Check Duplicates
SELECT job_id, COUNT(*)
FROM jobs
GROUP BY job_id
HAVING COUNT(*) > 1;

### Exploratory data Analysis(EDA)
# Total Jobs
select count(*) AS total_jobs 
from jobs;

# Top job Roles
select title,count(*) AS total_jobs
from  jobs
group by title
order by total_jobs desc;

# Jobs by Location
select location,count(*) AS job_count
from jobs
group by location
order by job_count desc;

# Top Hirin Companies
select company,count(*) as jobs
from jobs
group by company
order by jobs desc
LIMIT 10;

#  Average salary pr role
select title,ROUND(AVG(salary),2) AS avg_salary
from jobs
group by title
order by avg_salary desc;

 ## Experience vs Salary
 select experience,ROUND(AVG(salary),2) as avg_salary
 from jobs
 group by experience
 order by experience;
 
 ##  highest paying Jobs
 select title,company,salary
 from jobs
 order by salary desc
LIMIT 10;

## Role based Analysis
SELECT 
CASE 
    WHEN title LIKE '%Data%' THEN 'Data Roles'
    ELSE 'Development Roles'
END AS role_type,
COUNT(*) AS total_jobs
FROM jobs
GROUP BY role_type;

## Window Functions
SELECT 
title,
salary,
RANK() OVER (PARTITION BY title ORDER BY salary DESC) AS rank_in_role
FROM jobs;

## CTE(Common table Expression)
WITH avg_salary_cte AS (
    SELECT title, AVG(salary) AS avg_salary
    FROM jobs
    GROUP BY title
)
SELECT *
FROM avg_salary_cte
WHERE avg_salary > 10;

## Salary distribution by location
select location,
min(salary) AS min_salary,
max(salary) AS max_salary,
ROUND(AVG(salary),2) AS avg_salary
from jobs
group by location 
order by avg_salary desc;

## Experience level distribution
select experience,count(*) AS job_count
from jobs
group by experience
order by experience;

## Entry-Level vs Experience -level
SELECT 
CASE 
    WHEN experience <= 2 THEN 'Entry Level'
    WHEN experience <= 5 THEN 'Mid Level'
    ELSE 'Senior Level'
END AS experience_level,
COUNT(*) AS total_jobs
FROM jobs
GROUP BY experience_level;

##  Salary Range Bucketing
SELECT 
CASE 
    WHEN salary < 5 THEN 'Low Salary'
    WHEN salary BETWEEN 5 AND 10 THEN 'Medium Salary'
    ELSE 'High Salary'
END AS salary_range,
COUNT(*) AS job_count
FROM jobs
GROUP BY salary_range;

## Top roles in each location
SELECT location, title, COUNT(*) AS job_count
FROM jobs
GROUP BY location, title
ORDER BY location, job_count DESC;

## High Paying Roles(Above Average)
SELECT title, AVG(salary) AS avg_salary
FROM jobs
GROUP BY title
HAVING avg_salary > (SELECT AVG(salary) FROM jobs);

## Job Concentration (Top 3 Cities)
SELECT location, COUNT(*) AS job_count
FROM jobs
GROUP BY location
ORDER BY job_count DESC
LIMIT 3;

## Company wise ole Distribution
SELECT company, title, COUNT(*) AS count
FROM jobs
GROUP BY company, title
ORDER BY company;

