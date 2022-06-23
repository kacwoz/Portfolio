--Cleaning Data in SQL

select * from Portfolio..Nashville

--Standardize Date Format
select SaleDate, CONVERT(date,saledate) from Portfolio..Nashville

alter table Portfolio..Nashville		
add SaleDateConverted date;
update Portfolio..Nashville
set SaleDateConverted = CONVERT(date,saledate)

--Property Address
select PropertyAddress from Portfolio..Nashville
where PropertyAddress is null 

select * from Portfolio..Nashville
where PropertyAddress is null 

select t1.ParcelID, t1.PropertyAddress, t2.ParcelID, t2.PropertyAddress, ISNULL(t1.PropertyAddress, t2.PropertyAddress)
from Portfolio..Nashville as t1
join Portfolio..Nashville as t2
on t1.ParcelID = t2.ParcelID
and t1.[UniqueID ] <> t2.[UniqueID ]
where t1.PropertyAddress is null

update t1
set PropertyAddress = ISNULL(t1.PropertyAddress, t2.PropertyAddress)
from Portfolio..Nashville as t1
join Portfolio..Nashville as t2
on t1.ParcelID = t2.ParcelID
and t1.[UniqueID ] <> t2.[UniqueID ]
where t1.PropertyAddress is null

--Split PropertyAddress
select PropertyAddress from Portfolio..Nashville

select propertyaddress,
SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress)+1, LEN(propertyaddress)) as Town
from Portfolio..Nashville

alter table Portfolio..Nashville		
add PropertyAddres_Address nvarchar(255);
update Portfolio..Nashville
set PropertyAddres_Address = SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1)

alter table Portfolio..Nashville		
add PropertyAddres_City nvarchar(255);
update Portfolio..Nashville
set PropertyAddres_City = SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress)+1, LEN(propertyaddress))


--Split OwnerAddress
select OwnerAddress,
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from Portfolio..Nashville

alter table Portfolio..Nashville		
add OwnerAddress_Address nvarchar(255);
update Portfolio..Nashville
set OwnerAddress_Address = PARSENAME(replace(OwnerAddress,',','.'),3)


alter table Portfolio..Nashville		
add OwnerAddress_City nvarchar(255);
update Portfolio..Nashville
set OwnerAddress_City = PARSENAME(replace(OwnerAddress,',','.'),2)


alter table Portfolio..Nashville		
add OwnerAddress_State nvarchar(255);
update Portfolio..Nashville
set OwnerAddress_State = PARSENAME(replace(OwnerAddress,',','.'),1)


--Change Y/N to Yes/No
select SoldAsVacant, COUNT(*) from Portfolio..Nashville
group by  SoldAsVacant

select SoldAsVacant, 
		case when SoldAsVacant = 'Y' then 'Yes'
			 when SoldAsVacant = 'N' then 'No'
			 else SoldAsVacant	
			 END		
from Portfolio..Nashville

update Portfolio..Nashville	
set SoldAsVacant =  case  when SoldAsVacant = 'Y' then 'Yes'
						when SoldAsVacant = 'N' then 'No'
						else SoldAsVacant	
				  END
				from Portfolio..Nashville


--Remove duplicate
WITH CTE as 
(
select ROW_NUMBER() over (partition by ParcelID, SaleDate, SalePrice, PropertyAddress, OwnerAddress, LegalReference 
						  order by parcelid) row_num 
from Portfolio..Nashville
)

delete from CTE
where ROW_NUM = 2

--Delete unused colums
select * from Portfolio..Nashville

alter table Portfolio..Nashville
drop column  PropertyAddress, OwnerAddress, TaxDistrict, SaleDate

