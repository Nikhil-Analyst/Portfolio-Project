--cleaning data
select*
from PortfolioProject.dbo.houseprices

--Standardize date format

select saledate, CONVERT(date, saledate) as SaleDAte
from PortfolioProject.dbo.houseprices

Update PortfolioProject.dbo.houseprices
Set SaleDate = CONVERT(date, SaleDate)

Alter Table PortfolioProject.dbo.houseprices
add SaleDate Date;

Update PortfolioProject.dbo.houseprices
Set SaleDate = CONVERT(date, SaleDate)



--property address data
select A.parcelID, A.propertyAddress, B.parcelID, B.propertyAddress
from PortfolioProject.dbo.houseprices A
join PortfolioProject.dbo.houseprices B
on A.parcelID = B.ParcelID
and A.[parcelID] <> B.[ParcelID]	
where A.propertyAddress is Null

--breakind wdown address in different coloumns(address, city,state)
 
 Select
Substring(PropertyAddress,1, charindex (',',PropertyAddress) -1) as Address
 ,Substring(PropertyAddress, charindex (',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
 from PortfolioProject.dbo.houseprices

 Alter table PortfolioProject.dbo.houseprices
 add PropertySplitAddress Nvarchar(255);

 update PortfolioProject.dbo.houseprices
 set PropertySplitAddress = Substring(PropertyAddress,1, charindex (',',PropertyAddress) -1)

  Alter table PortfolioProject.dbo.houseprices
 add PropertySplitCity Nvarchar(255);

 update PortfolioProject.dbo.houseprices
 set PropertySplitCity = Substring(PropertyAddress, charindex (',',PropertyAddress) +1, LEN(PropertyAddress))

 select 
 parsename (replace(OwnerAddress,',', '.'),3),
 parsename (replace(OwnerAddress,',', '.'),2),
 parsename (replace(OwnerAddress,',', '.'),1)
 from PortfolioProject.dbo.houseprices


 Alter table PortfolioProject.dbo.houseprices
 add OwnerSplitpAddress Nvarchar(255);

 update PortfolioProject.dbo.houseprices
 set OwnerSplitpAddress = parsename (replace(OwnerAddress,',', '.'),3)

  Alter table PortfolioProject.dbo.houseprices
 add OwnerSplitCity Nvarchar(255);

 update PortfolioProject.dbo.houseprices
 set OwnerSplitCity = parsename (replace(OwnerAddress,',', '.'),2)

 Alter table PortfolioProject.dbo.houseprices
 add OwnerSplitState Nvarchar(255);

 update PortfolioProject.dbo.houseprices
 set OwnerSplitState = parsename (replace(OwnerAddress,',', '.'),1)

 Select*
 from PortfolioProject.dbo.houseprices

 Select distinct SoldAsVacant, Count(SoldAsVacant)
from PortfolioProject.dbo.houseprices
group by SoldAsVacant
order by 2

Select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'    
     when SoldAsVacant = 'N' then 'NO'
	 else SoldAsVacant	 
	 end
from PortfolioProject.dbo.houseprices

update houseprices
Set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'    
     when SoldAsVacant = 'N' then 'NO'
	 else SoldAsVacant	 
	 end
from PortfolioProject.dbo.houseprices

Select*
from PortfolioProject.dbo.houseprices

--Remove Duplicate

with RowNumCTE as (
select*,
	Row_Number() over 
	(partition by
	parcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	order by UniqueID) row_num
from PortfolioProject.dbo.houseprices)
Select* 
from RowNumCTE
where row_num > 1 
order by propertyAddress

Select*
from PortfolioProject.dbo.houseprices

--Remove Duplicate

Select*
from PortfolioProject.dbo.houseprices

alter table PortfolioProject.dbo.houseprices
Drop Column
propertyAdDress, OwnerAdDress, taxDistrict, SaleDate

