/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
      ,[SaleDateConverted]
      ,[PropertySplitAddress]
      ,[PropertySplitcity]
      ,[OwnerSplitAddress]
      ,[OwnerSplitCity]
      ,[OwnerSplitState]
  FROM [Portfolio Project].[dbo].[NashvilleHousing]


  
  SELECT*
  FROM NashvilleHousing

  ----------------------------Look at Sale Date
SELECT SaleDate
FROM NashvilleHousing
---------------------------------------------

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM NashvilleHousing
--------------------------------------------------------------------------------
                                     
                                  SELECT SaleDateConverted, Convert(Date,SaleDate)
                                  FROM NashvilleHousing


UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)
----------------

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;
---------------------------------
UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-------------------------------------------------------------------------------------------

-------------POPULATE PROPERTY ADDRESS DATA-----------------------

SELECT PROPERTYADDRESS
FROM NashvilleHousing

----------------------------
SELECT PROPERTYADDRESS
FROM NashvilleHousing
WHERE PropertyAddress IS NULL
------------
SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL

--------- Look at all the Data

SELECT*
FROM NashvilleHousing
----WHERE PropertyAddress IS NULL
ORDER BY ParcelID
---------------------

-----------LOOK AT LINE 44 & 45 SAME PARCEL ID, GIVE US CLUE ABOUT ADDRESS,
-----------percel id is same, unique id is unique to each item

SELECT*
FROM NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
---------------- Some of the property address is not populated ie Null

SELECT*
FROM NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]

------ rewrite this

SELECT a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress
FROM NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is NULL

-----What we want to check if it is NULL

UPDATE a 
SET PropertyAddress = ISNULL(a.Propertyaddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is NULL

----------UPDATE REWRITE this

----SELECT a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.Propertyaddress,b.PropertyAddress)
----FROM NashvilleHousing a
----JOIN NashvilleHousing b
----on a.ParcelID = b.ParcelID
----AND a.[UniqueID ]<>b.[UniqueID ]
-----WHERE a.PropertyAddress is NULL


---------------------------------------------------------------------------------------------
-----BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (address,city,state)

SELECT PropertyAddress
FROM NashvilleHousing
--WHERE PropertyAddress IS NULL
----ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)) as address 
FROM NashvilleHousing


------------you will notice a comma, to remove it, use -1

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1) as Address
FROM NashvilleHousing

----- I am going to add length of property address LEN

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address

FROM NashvilleHousing

------------- we going create 2 new columns, call it property split address

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD PropertySplitcity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitcity = CONVERT(Date,SaleDate)

------ take it one at a table, adding everything by inserting the address

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitcity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

------

SELECT*
FROM NashvilleHousing

-------------

-----------------------OWNERS ADDRESS

SELECT OwnerAddress
FROM NashvilleHousing

----------use parsename for delimited values

SELECT
PARSENAME(OwnerAddress,1)
FROM NashvilleHousing

----NOTHING changes with commas, lets replace commas with periods

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
FROM NashvilleHousing

------- lets add other elements

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
From NashvilleHousing

------ its seperated backwards, lets change the order and run
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousing

-----add the colums and values to table

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT*
FROM NashvilleHousing
------------------------------------------------------------------------------------

-------------------------LETS LOOK AT COLUMN SOLD AS VACANT

SELECT DISTINCT(SoldAsVacant)
FROM NashvilleHousing

------------ Do a count
SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER by 2

-----------CHANGE Y AND N TO YES AND NO IN 'SOLD AS VACANT' FIELD using case statement

SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM NashvilleHousing

------------------------ LETS update Nashville housing PUTTING CASE STATEMENT

UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM NashvilleHousing

-----check
------------------------------------------------------------------------------------------
SELECT*
FROM NashvilleHousing

-----------------------------------------------------------------------------------------


----------------REMOVE DUPLICATES, EMPLOY cte and win functions


-------------------------We do a CTE

WITH RowNumCTE AS(
SELECT*,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY
	        UniqueID
			  ) row_num

FROM NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE


WHERE Row_Num >1
ORDER BY PropertyAddress

------104 duplicates

WITH RowNumCTE AS(
SELECT*,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY
	        UniqueID
			  ) row_num

FROM NashvilleHousing
--ORDER BY ParcelID
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1
-----ORDER BY PropertyAddress

---------------lets check

WITH RowNumCTE AS(
SELECT*,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY
	        UniqueID
			  ) row_num

FROM NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE


WHERE Row_Num >1
ORDER BY PropertyAddress
----------------------------------------

SELECT*
FROM NashvilleHousing

------------------ DELETE SOME UNUSED COLUMNS -- NOT RECOMMENDED

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress,Taxdistrict, propertyaddress

------------ drop sale date

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate




