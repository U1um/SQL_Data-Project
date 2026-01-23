select * from studentsperformance;

#first of all we create new column that contain average score of each lesson

select *,(`math score` + `reading score` +`writing score`)/3 as average_score
from studentsperformance;

alter table studentsperformance
add average_score float;

update studentsperformance
set `average_score` = round((`math score` + `reading score` +`writing score`)/3, 2);

# then we look student performance by gender
select gender,  avg(`math score`) as avg_math,avg(`reading score`) as avg_reading,
avg(`writing score`)as avg_writing,avg(`average_score`) as avg_total
from studentsperformance
group by gender
order by 2 desc;
#in here we know that female have higher average score in each lesson than male

#next we look for wich gender and race/ethnicity have passed test, we use average score for benchmark
select gender, `race/ethnicity`, avg(`math score`) as avg_math,avg(`reading score`) as avg_reading,
avg(`writing score`)as avg_writing,avg(`average_score`) as avg_total,
(select avg(`average_score`) from studentsperformance) as average,
case 
when avg(`average_score`) >= (select avg(`average_score`) from studentsperformance) then 'pass'
when avg(`average_score`) < (select avg(`average_score`) from studentsperformance) then 'remedial'
end as `description`
from studentsperformance
group by gender, `race/ethnicity`
order by 6 desc;
#from that we recognize that only female from group C,D,E and male from group E that pass the test

#now we look is parental level of education has impact on students performance
select `parental level of education`, avg(`math score`) as avg_math, avg(`reading score`) as avg_reading, 
avg(`writing score`) as avg_writing,avg(`average_score`) as avg_total
from studentsperformance
group by `parental level of education`
order by 5 desc;
#from result that we have we can make conclusion parental level of education has impact in student performance.

#after that we look is lunch has impact on student performance
select lunch, avg(`math score`) as avg_math, avg(`reading score`) as avg_reading, 
avg(`writing score`) as avg_writing,avg(`average_score`) as avg_total
from studentsperformance
group by lunch
order by 5 desc;
#from result above we acknowledge that luch have impact on students performance in every lesson.

#lastly we look for test preparation course impact on students performance
with cte1 
as(
select count(`test preparation course`) as total_student,`test preparation course`, 
avg(average_score) as average_score, (select count(gender) from studentsperformance) as total_all_student
from studentsperformance
group by `test preparation course`
order by 3 desc
)
select total_student,`test preparation course`,average_score, (total_student/total_all_student)*100 as percentage 
from cte1;
#now we know that test preparation course have big impact on students performance, 
#but only 35,8% already take the preparation course

