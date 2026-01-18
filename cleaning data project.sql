select * from PortfolioProject..NashvilleHousing

--mengstandarkan format tanggal
select SaleDate, CONVERT(Date, SaleDate) from PortfolioProject..NashvilleHousing

update NashvilleHousing set SaleDate=CONVERT(date, SaleDate) --kalo lgsung gini gabisa

alter table NashvilleHousing
add SaleDateCOnverted Date ;
update NashvilleHousing set SaleDateConverted=CONVERT(date, SaleDate)

select SaleDateConverted, CONVERT(Date, SaleDate) from PortfolioProject..NashvilleHousing

--populate property address data
select * from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress) -- jika a kosong / null di isi b
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a set PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]

update a set PropertyAddress = ISNULL (a.PropertyAddress, 'no address') --opsi jika tidak ada jawaban
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]

--breaking out address into  individual column (adddress, city, state)
select PropertyAddress 
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
-- by ParcelID

select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as Address  --minus 1 menghilangkan koma nya
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, len(PropertyAddress)) as Address --len untuk penghentianya akan 
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255) ;
update NashvilleHousing set PropertySplitAddress=SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity Nvarchar(255) ;
update NashvilleHousing set PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, len(PropertyAddress))

select *
from PortfolioProject..NashvilleHousing


select OwnerAddress
from PortfolioProject..NashvilleHousing

select 
PARSENAME(replace(OwnerAddress, ',','.'),3),
PARSENAME(replace(OwnerAddress, ',','.'),2),
PARSENAME(replace(OwnerAddress, ',','.'),1)
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255) ;
update NashvilleHousing set OwnerSplitAddress=PARSENAME(replace(OwnerAddress, ',','.'),3)

alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255) ;
update NashvilleHousing set OwnerSplitCity=PARSENAME(replace(OwnerAddress, ',','.'),2)

alter table NashvilleHousing
add OwnerSplitState Nvarchar(255) ;
update NashvilleHousing set OwnerSplitState=PARSENAME(replace(OwnerAddress, ',','.'),1)

--change Y and N in no  in sold in vacant

select distinct(SoldAsVacant), count(soldasvacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,case when soldasvacant ='Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when soldasvacant ='Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from PortfolioProject..NashvilleHousing


--remove duplicates

with rownumcte as(
select *, 
	ROW_NUMBER() over (
	partition by parcelID, propertyaddress, saleprice, saledate, legalreference
	order by uniqueid) row_num
from PortfolioProject..NashvilleHousing
--order by ParcelID
) 
select * from rownumcte --jika mau menghapus select * diganti delete
where row_num>1
order by propertyaddress





--delete unused column
select*
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column Owneraddress, taxdistrict, propertyaddress

alter table PortfolioProject..NashvilleHousing
drop column saledate