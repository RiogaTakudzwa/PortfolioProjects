SELECT *
FROM HousingData..HousingDataset


--		format date by removing timestamp
Select SaleDate, CONVERT(date, SaleDate)
from HousingData..HousingDataset

alter table HousingDataset
add SaleDateConverted Date;

UPDATE HousingDataset
set SaleDateConverted = convert(date, SaleDate)

Select SaleDate
from HousingData..HousingDataset


--		infering property address from other sales of the same address by parcelID
Select table1.ParcelID, table1.PropertyAddress, table2.ParcelID, table2.PropertyAddress, ISNULL(table1.PropertyAddress, table2.PropertyAddress)
from HousingData..HousingDataset table1
join HousingData..HousingDataset table2
	on table1.parcelID = table2.parcelID
	and table1.[UniqueID ] <> table2.[UniqueID ]
where table1.PropertyAddress is null

update table1
set PropertyAddress = ISNULL(table1.PropertyAddress, table2.PropertyAddress)
from HousingData..HousingDataset table1
join HousingData..HousingDataset table2
	on table1.parcelID = table2.parcelID
	and table1.[UniqueID ] <> table2.[UniqueID ]
where table1.PropertyAddress is null

select * 
from HousingDataset
where PropertyAddress is null 


--		breaking the address columns into address columns and town column
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Town
from HousingDataset

alter table HousingDataset
drop column PropertTown;

alter table HousingDataset
add PropertTown Nvarchar(255);

alter table HousingDataset
add PropertPhysicalAddress Nvarchar(255);

UPDATE HousingDataset
set PropertPhysicalAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

UPDATE HousingDataset
set PropertTown = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 

select PropertPhysicalAddress, PropertTown
from HousingDataset


--		seperate owner address information into columns of address, city and state
select PARSENAME(replace(OwnerAddress, ',', '.'), 3)
, PARSENAME(replace(OwnerAddress, ',', '.'), 2)
, PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from HousingDataset

alter table HousingDataset
add OwnerPhysicalAddress Nvarchar(255);

alter table HousingDataset
add OwnerTown Nvarchar(255);

alter table HousingDataset
add OwnerState Nvarchar(255);

UPDATE HousingDataset
set OwnerPhysicalAddress = PARSENAME(replace(OwnerAddress, ',', '.'), 3)

UPDATE HousingDataset
set OwnerTown = PARSENAME(replace(OwnerAddress, ',', '.'), 2)

UPDATE HousingDataset
set OwnerState = PARSENAME(replace(OwnerAddress, ',', '.'), 1)

select OwnerPhysicalAddress, OwnerTown, OwnerState
from HousingDataset

--		delete OwnerAddress and propertyAddress Columns as we do not need it anymore
alter table HousingDataset
Drop Column OwnerAddress, PropertyAddress



--		set all the soldasvacant values from Y/N to Yes and No 	
select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from  HousingDataset
group by SoldAsVacant
order by 2

select SoldAsVacant
, case	when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from  HousingDataset



UPDATE HousingDataset
set SoldAsVacant = case	when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end


--			CTE looks for all duplicates
WITH Row_NumCTE as (
SELECT *,
ROW_NUMBER() over (
	partition by	ParcelID, 
					SaleDate, 
					LegalReference,
					SalePrice,
					PropertyAddress
					ORDER BY UniqueID
					) row_num
FROM HousingDataset
)
Select *
from Row_NumCTE
where row_num > 1
order by PropertyAddress

--			CTE deletes all duplicates
WITH Row_NumCTE as (
SELECT *,
ROW_NUMBER() over (
	partition by	ParcelID, 
					SaleDate, 
					LegalReference,
					SalePrice,
					PropertyAddress
					ORDER BY UniqueID
					) row_num
FROM HousingDataset
)
Delete
from Row_NumCTE
where row_num > 1


