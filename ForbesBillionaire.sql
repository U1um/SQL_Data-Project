select *
from Portfolio1..Forbes

alter table Portfolio1..Forbes
drop column year, month, finalWorth, Transform, numberOfSiblings

update Portfolio1..Forbes
set gender = case when gender is null then 'Family'
	when gender = 'M' then 'Male'
	else 'Female'
	end

alter table Portfolio1..Forbes
add is_self_made varchar(50);

update Portfolio1..Forbes
set is_self_made = case when cast(selfMade as varchar) = 1 then 'Yes'
	else 'No' 
	end


with cte
as(
select gender, COUNT(gender) as count_gender, (select COUNT(personName) from Portfolio1..Forbes) as total_person
from Portfolio1..Forbes
group by gender
)
select *, cast(count_gender as float)/cast(total_person as float)*100 as gender_percentage
from cte

select gender, SUM(Value) NewtWorth_Ranking
from Portfolio1..Forbes
where gender is not null
group by gender
order by NewtWorth_Ranking desc

--looking count by category
select category, COUNT(category) as count_of_category
from Portfolio1..Forbes
group by category
order by count_of_category desc

select category, SUM(Value) NewtWorth_Ranking_by_category
from Portfolio1..Forbes
group by category
order by NewtWorth_Ranking_by_category desc

-- Self Made

with ctee
as(
select is_self_made, COUNT(is_self_made) as count_self_made, (select COUNT(personName) from Portfolio1..Forbes) as total_person
from Portfolio1..Forbes
group by is_self_made
)
select *, cast(count_self_made as float) / CAST(total_person as float) * 100 as self_made_percentage
from ctee

-- Philantrophy
with cteee
as(
select count(personName) as total_person ,(select count(philanthropyScore)
from Portfolio1..Forbes
where philanthropyScore is not null) as total_philantrophy
from Portfolio1..Forbes
) 
select *, cast(total_philantrophy as float) / CAST(total_person as float) * 100 as philantropyhy_percentage
from cteee

--country
select country, count(country) as total
from Portfolio1..Forbes
group by country
order by total desc

--city
select city, count(city) as total
from Portfolio1..Forbes
group by city
order by total desc

select *
from Portfolio1..Forbes
