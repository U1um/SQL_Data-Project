select * from ab_nyc_2019;
# we must analyze this data to help people chose air bnb recomendation
# big factor in here is price
# we must analyze price of the air bnb and make recomendation over this data

#first we analyze total airbnb and average price of each neighbourhood in NYC
select neighbourhood_group, count(neighbourhood_group) as total_airbnb, round(avg(price),2) as average_price
from ab_nyc_2019
group by neighbourhood_group
order by 3;
#from this query we know that is the most airbnb is in manhattan and brooklyn with over 100 airbnb
#and also the most expensive air bnb by average is in manhattan, and the most cheap is in staten island 

#next we want to know where is neighbourhood with most cheap price
select neighbourhood_group, neighbourhood,count(neighbourhood) as total_airbnb, round(avg(price),2) as average_price 
from ab_nyc_2019
group by neighbourhood_group,neighbourhood
order by 4;
#from that query we know that in staten island spesifically in tompkinsville is the lowest average price with 36.5
#and the highest average price is in Brokklyn Heights with 800

#now we analyze price by room type
select room_type,count(room_type), avg(price)
from ab_nyc_2019
group by room_type
order by 3 asc;
#average price of shared room is the most low with 72.5, followed by private room with 88.0,
#and the most highest is entire home/apt

#next we want to analyze price by minimum nights
with cte2 as (
select *,
case
when minimum_nights <8 then 'short term'
when minimum_nights <29 then 'mid term'
else 'long term'
end as timedesc
from ab_nyc_2019)
select timedesc, count(minimum_nights), round(avg(price),2) as average_price
from cte2
group by timedesc
order by 2;
#in here we classified 1-7 days is short term, then 8-28 days is mid term, and 28 + is long term
#from classification above we knew that mid term is the lowest avg price, and long term is highest avg price

#now we analyze average price by calculated host listing count
select distinct calculated_host_listings_count,count(calculated_host_listings_count) as total_airbnb, 
round(avg(price),1) as average_price
from ab_nyc_2019
group by calculated_host_listings_count
order by 3;
#from query above we know that air bnb with calculated host listing count 6 people is most cheap with 83.8
#and calculated host listing count 1 people is most expensive with 152.7

#looking for top 3 lowest and highest price of air bnb in every neighbourhood group in nyc
select *
from(
select `name`, host_id, neighbourhood_group, room_type, calculated_host_listings_count, availability_365, price, 
row_number() over(partition by neighbourhood_group order by price) as ranking
from ab_nyc_2019) as tablee2
where ranking <4
order by neighbourhood_group;

select *
from(
select `name`, host_id, neighbourhood_group, room_type, calculated_host_listings_count, availability_365, price, 
row_number() over(partition by neighbourhood_group order by price desc) as ranking
from ab_nyc_2019) as tablee2
where ranking <4
order by neighbourhood_group;

#now we looking for top 3 lowest and highest price of airbnb by room type in nyc
with cte as(
select `name`, host_id, neighbourhood_group, room_type, calculated_host_listings_count, availability_365, price, 
row_number() over(partition by room_type order by price) as ranking
from ab_nyc_2019
where availability_365 != 0)
select *
from cte
where ranking < 4
order by room_type;

with cte as(
select `name`, host_id, neighbourhood_group, room_type, calculated_host_listings_count, availability_365, price, 
row_number() over(partition by room_type order by price desc) as ranking
from ab_nyc_2019
where availability_365 != 0)
select *
from cte
where ranking < 4
order by room_type;

#CASE 1
#lets say our friends need help, for looking air bnb in  brooklyn, for 2 person, and it will be use for 1 weeks
#also it must be already trusted, and available all the year, and its okay to expensive.
select `name`,neighbourhood_group,neighbourhood,room_type,number_of_reviews,calculated_host_listings_count,price
from ab_nyc_2019
where neighbourhood_group like '%Brooklyn%'
and calculated_host_listings_count > 1 and calculated_host_listings_count <4
and minimum_nights < 8
and number_of_reviews >100
and availability_365 >300
order by price desc
limit 3;

# CASE 2
# adi want to holiday, before going adi want to know best acomodation because the busget is limited
# he want to make list top 3 cheapest air bnb in brooklyn manhattan and staten island for just in case 
# write query that show list of most cheap airbnb in brooklyn,manhattan, and staten island  
select *
from
(select `name`, host_id,host_name,neighbourhood_group,neighbourhood,room_type,price,minimum_nights,
calculated_host_listings_count,availability_365,
row_number() over(partition by neighbourhood_group order by price) as rownum
from ab_nyc_2019
where neighbourhood_group ='Manhattan' or neighbourhood_group ='Brooklyn' or neighbourhood_group = 'Staten Island') as rownumm
where rownum < 4;