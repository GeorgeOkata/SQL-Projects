#1. Creating a Database and Use
#creating a Database
create database HR_Attrition;

#Instructing SQL to Execute all queries from the seelcted Database
use HR_Attrition;

#2. Renaming the Table Name

#Renamed the default table name
rename table`wa_fn-usec_-hr-employee-attrition` to hr_attrition_data;

#3. Making a Copy of my Original Raw Data 

#created a copy of my Table as a Backup for my Analysis
create table hr_attrition_data_cleaned as
select * from hr_attrition_data;

#4. To View my Table and Understand my Dataset

#Query to view my new backup(cleaned) table  to enable me undertsand my data
select *
from hr_attrition_data_cleaned
limit 10;

#5. Cleaning my Dataset 

#To clean up the column names 
alter table hr_attrition_data_cleaned
rename column ï»¿Age to Age;

#To check for null values by column
select *
from hr_attrition_data_cleaned
where age is null;

# To check for Duplicates values in my table
select EmployeeNumber, count(*)
from hr_attrition_data_cleaned
group by EmployeeNumber
having count(*) > 1;

select  EducationField
from hr_attrition_data_cleaned
group by EducationField;

#To rename Other to Data Analyst from the EducationField Column
# First we have to turn off the sql safe update

set sql_safe_updates = 0;

update hr_attrition_data_cleaned
set EducationField = 'Data Analyst'
where EducationField ='Other';

#6. To include Calculated Columns from my Data

#A.add a new column to the table and then give it a datatype
alter table hr_attrition_data_cleaned
add column IsAttributed int;

#Next, I gave it a command using a conditional case statemmet 
update hr_attrition_data_cleaned
set IsAttributed = 
case 
when attrition = 'yes' then 1 else 0
end;

#B.Next, I dded another calculated column and converted the Overtime column  from yes to 1 No and 0
# it Makes it easy to calculate attrition rate 
#First add a new column and give it a datatype

alter table hr_attrition_data_cleaned
add column IsOverTime int;

#Next, I wrote a conditional statemnet to convert Yes to 1 and No to 0
#To Help me analyze if overtime is linked to attrition, performance, or dissatisfaction.
update hr_attrition_data_cleaned
set IsOverTime =
case
	when OverTime = 'yes' then 1 else 0
end;

#C.Next, I needed to know Employees who are stuck without a promotion which may affect morale or attrition
#First add a new column and give it a datatype 

alter table hr_attrition_data_cleaned
add column YearsNotPromoted int;

#Next, I did a basic substraction to get the number of years employees havent been promoted 
update hr_attrition_data_cleaned
set YearsNotPromoted = YearsAtCompany -YearsSinceLastPromotion;

#D. Next i wrote another calculated column to Help management identify who needs support before they leave and reduce Attrition and burnout
#First I added a new column and give it a datatype 
alter table hr_attrition_data_cleaned
add column WorkLifeFeedback varchar(50);

#Next, I used a case condition statemnet to categorize the feedback for better analysis 
update hr_attrition_data_cleaned
set WorkLifeFeedback =
case
when WorkLifeBalance = 1 then 'Poor'
when WorkLifeBalance = 2 then 'Average'
when WorkLifeBalance = 3 then 'Good'
else 'Excellent'
end;

select *
from hr_attrition_data_cleaned;

/* Business Questions to Answers from the HR_Attrition Data

What is the overall attrition rate?

Is there a correlation between job role and attrition?

What department has the highest average monthly income?

Do people who work overtime have a higher attrition rate?

What’s the average years at the company by job level?

Is job satisfaction linked with attrition?

Which gender has higher attrition in managerial roles?

*/

select *
from hr_attrition_data_cleaned;

# Q1. What is the overall attrition rate?
select 
round(avg(case when attrition = 'Yes' then 1 else 0 end) * 100, 2) as Attrition_Percentage
from hr_attrition_data_cleaned;

#Q2. Is there a correlation between job role and attrition?
select JobRole, 
round(avg(case when attrition = 'Yes' then 1 else 0 end) *100, 2)as Attrition_Percentage
from hr_attrition_data_cleaned
group by JobRole
order by Attrition_Percentage desc
limit 5;


#Q3. What department has the highest average monthly income?

select Department, round(avg(MonthlyIncome),2) as avg_salary
from hr_attrition_data_cleaned
group by Department
order by avg_salary desc;

#Q4. Do people who work overtime have a higher attrition rate?
select OverTime,
avg(case when Attrition = 'Yes' then 1 else 0 end * 100) as Percentage_rate_of_Attrition_by_Overtime
from hr_attrition_data_cleaned
group by Overtime;

#Q5.What’s the average years at the company by job level?
Select joblevel, round(avg(YearsAtCompany),'') as Years_spent
from hr_attrition_data_cleaned
group by joblevel
order by Years_spent desc;


#Q6. Is job satisfaction linked with attrition?
select JobSatisfaction,
round(avg(case when attrition = 'Yes' then 1 else 0 end) * 100, 2) as percentage_atttritiononJobSatisfaction
from hr_attrition_data_cleaned
group by JobSatisfaction
order by percentage_atttritiononJobSatisfaction desc;

#Q7. Which gender has higher attrition in managerial roles?
select Gender,
round(avg(case when attrition = 'Yes' then 1 else 0 end) *100,2) as Percentage_Attrition_in_Managers
from hr_attrition_data_cleaned
where JobRole = 'Manager'
group by Gender
order by Percentage_Attrition_in_Managers desc;



select *
from hr_attrition_data;






