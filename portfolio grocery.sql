select * 
from grocery_inventory;

update grocery_inventory
set Catagory = 'Fruits & Vegetables'
where Catagory ='';

update grocery_inventory
set `Date_Received` = str_to_date(`Date_Received`,'%m/%d/%Y');

alter table grocery_inventory
modify column `Date_Received` date;

update grocery_inventory
set `Last_Order_Date` = str_to_date(`Last_Order_Date`,'%m/%d/%Y');

update grocery_inventory set
`Expiration_Date` = str_to_date(`Expiration_Date`,'%m/%d/%Y');

alter table grocery_inventory
modify column `Last_Order_Date` date;

alter table grocery_inventory
modify column `Expiration_Date` date;

select Product_Name, Catagory, Stock_Quantity, Sales_Volume, Inventory_Turnover_Rate
from grocery_inventory
order by 5 desc;

select Product_Name, count(Product_Name) 
from grocery_inventory
group by Product_Name
order by 2 asc;

select * 
from grocery_inventory;

#Looking Product & Catagory with highest sales volume
select Product_Name, Catagory, sum(Sales_Volume) as Sales_Volume
from grocery_inventory
group by Product_Name, Catagory, Sales_Volume
order by 3 desc;

#looking sales by status
select Product_Name, Catagory,`Status`, sum(Sales_Volume) as Sales_Volume, sum(Stock_Quantity) as Stock_Qty
from grocery_inventory
group by Product_Name, Catagory, Sales_Volume, `Status`
order by 4 desc;

select Product_Name, Catagory,`Status`, sum(Sales_Volume) as Sales_Volume, sum(Stock_Quantity) as Stock_Qty
from grocery_inventory
group by Product_Name, Catagory, Sales_Volume, `Status`
having `Status` like '%Dis%'
order by 4 desc;
;
select Product_Name, Catagory,`Status`, sum(Sales_Volume) as Sales_Volume, sum(Stock_Quantity) as Stock_Qty
from grocery_inventory
group by Product_Name, Catagory, Sales_Volume, `Status`
having `Status` like '%Back%'
order by 4 desc;
;

select Product_Name, Catagory,`Status`, sum(Sales_Volume) as Sales_Volume, sum(Stock_Quantity) as Stock_Qty
from grocery_inventory
group by Product_Name, Catagory, Sales_Volume, `Status`
having `Status` like '%Act%'
order by 4 desc;
;

#looking for product where have backordered status and stock fulfill the reorder level
#so we can push the supplier to supply the product as fast as posible
select Product_Name, Catagory, Supplier_Name, Supplier_ID, `Status`, Stock_Quantity, Reorder_Level, Sales_Volume
from grocery_inventory
where `Status` like 'Back%' and
Reorder_Level > Stock_Quantity
order by Sales_Volume desc, Stock_Quantity - Reorder_Level asc
;

#now we looking for active product with high sales so we can push the product marketing
select Product_Name, Catagory, Supplier_Name, Supplier_ID, `Status`, Stock_Quantity, Sales_Volume
from grocery_inventory
where `Status` like 'Act%' 
order by Sales_Volume desc
;

#look catagory who gave small sales
select Catagory, count(Catagory), avg(Sales_Volume)
from grocery_inventory
group by Catagory
order by 3 asc;

#looking supplier by product status
select Product_Name, Catagory, Supplier_Name,`Status`, count(`Status`), sum(Sales_Volume), sum(Stock_Quantity)
from grocery_inventory
group by Product_Name, Catagory, Supplier_Name,`Status`
order by count(`Status`) desc;

select *
from grocery_inventory;

#looking for alternate supplier where supplier discontinue
select g1.Product_Name, g1.Catagory, g1.Supplier_Name as Supplier_Name_1, g1.`Status`, 
g2.Supplier_Name as Supplier_Name_2, g2.`Status`, g1.Stock_Quantity, g1.Sales_Volume, g1.Reorder_Level
from grocery_inventory g1
join grocery_inventory g2
on g1.Product_Name = g2.Product_Name and g1.Catagory = g2.Catagory
where g1.`Status` like 'Disc%' and (g2.`Status` like 'Act%' or g2.`Status` like '%Back')
;


