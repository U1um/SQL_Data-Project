Select *
from PortfolioCleaningData..NashvilleHousing
order by 3,4

--Standarize date format
select SaleDateConverted, CONVERT(date, SaleDate), SaleDate
from PortfolioCleaningData..NashvilleHousing

Update NashvilleHousing
set SaleDate = CAST(SaleDate as date)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
set SaleDateConverted = CONVERT(date, SaleDate)

--Populate Property Address data 
select *
from PortfolioCleaningData..NashvilleHousing
where PropertyAddress is null

select a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioCleaningData..NashvilleHousing a
join PortfolioCleaningData..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioCleaningData..NashvilleHousing a
join PortfolioCleaningData..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--breaking address into different column (address, city, state)
select PropertyAddress
from PortfolioCleaningData..NashvilleHousing

--substring(colom_yang_mau_dipisah,awal index yang mau dipisah,sampai index mana)
select
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Adress,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as Adress
from PortfolioCleaningData..NashvilleHousing

--Masukkan kedalam kolom baru
Alter Table PortfolioCleaningData..NashvilleHousing
Add Property_Adress NVARCHAR(255);

Update PortfolioCleaningData..NashvilleHousing
set Property_Adress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

Alter Table PortfolioCleaningData..NashvilleHousing
Add Property_City NVARCHAR(255);

Update PortfolioCleaningData..NashvilleHousing
set Property_City = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))

--split owner address
select OwnerAddress
from PortfolioCleaningData..NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from PortfolioCleaningData..NashvilleHousing

Alter Table PortfolioCleaningData..NashvilleHousing
Add Owner_Adress NVARCHAR(255);

Update PortfolioCleaningData..NashvilleHousing
set Owner_Adress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter Table PortfolioCleaningData..NashvilleHousing
Add Owner_city NVARCHAR(255);

Update PortfolioCleaningData..NashvilleHousing
set Owner_city = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter Table PortfolioCleaningData..NashvilleHousing
Add Owner_state NVARCHAR(255);

Update PortfolioCleaningData..NashvilleHousing
set Owner_state = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select *
from PortfolioCleaningData..NashvilleHousing

--Change Y n N to 'SoldAsVacant' column
select distinct (SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioCleaningData..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from PortfolioCleaningData..NashvilleHousing

update PortfolioCleaningData..NashvilleHousing
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end


--Remove Duplicate
select * 
from PortfolioCleaningData..NashvilleHousing


with RowNUM_CTE AS(
select *, ROW_NUMBER() Over(
partition by ParcelID, PropertyAddress, SalePrice, SaleDate,LegalReference order by uniqueID) row_num
from PortfolioCleaningData..NashvilleHousing
)
DELETE from RowNUM_CTE
where row_num>1


--Delete Unused Column
select *
from PortfolioCleaningData..NashvilleHousing

alter table PortfolioCleaningData..NashvilleHousing
drop column PropertyAddress, OwnerAddress

alter table PortfolioCleaningData..NashvilleHousing
drop column SaleDate, TaxDistrict