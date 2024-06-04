-- DATA CLEANING

Use Nashville

SELECT *
FROM Nashville_housing

-- first of all: let's create a new table in order to modify and clean the data without changing the original table

CREATE TABLE nashville_staging
LIKE Nashville_housing;

SELECT *
FROM nashville_staging

INSERT nashville_staging
SELECT *
FROM Nashville_housing;
-------------------------------------------------------------------------------------------------------------------------------------
-- Study Case objectives:
	
-- 1. Change the date Format
-- 2. Standardize the Data accross columns
-- 3. Remove Duplicates
-- 4. Manage blank cells
-- 5. Split the address into street, city and state 
-- 6. Remove unnecessary columns

-- SQL skills involved: string functions, Set-Case, CTE's, date manipulation, aggregate functions, string manipulation

-- 1. Date Format

SELECT SaleDate
FROM nashville_staging;

Alter table nashville_staging
ADD Column new_date DATE;

UPDATE nashville_staging
SET new_date = str_to_date(saledate, '%M %d, %Y');

Alter table nashville_staging
DROP column saledate;

Alter table nashville_staging
Change column new_date saledate DATE;

SELECT *
FROM nashville_staging;

-- we went from 'Semptember 3,2020' to '2020-09-03'

-------------------------------------------------------------------------------------------------------------------------------------
-- 2. Standardize the Data accross columns

SELECT SoldAsVacant
, CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes' 
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM nashville_staging;

UPDATE nashville_staging
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes' 
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END;
    
-------------------------------------------------------------------------------------------------------------------------------------

-- 3. Remove Duplicates

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY PropertyAddress, SalePrice, OwnerName, OwnerAddress, Landvalue, YearBuilt, saledate) as row_num
FROM nashville_staging;

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY PropertyAddress, SalePrice, OwnerName, OwnerAddress, Landvalue, YearBuilt, saledate) as row_num
FROM nashville_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- now i should delete them, but in mysql i can't delete from CTE 
-- i need to create another table and delete from there, using the create table menu in wich i manually insert the new table staging2

CREATE TABLE `nashville_staging2` (
  `UniqueID` int DEFAULT NULL,
  `ParcelID` text,
  `LandUse` text,
  `PropertyAddress` text,
  `SalePrice` int DEFAULT NULL,
  `LegalReference` text,
  `SoldAsVacant` text,
  `OwnerName` text,
  `OwnerAddress` text,
  `Acreage` double DEFAULT NULL,
  `TaxDistrict` text,
  `LandValue` int DEFAULT NULL,
  `BuildingValue` int DEFAULT NULL,
  `TotalValue` int DEFAULT NULL,
  `YearBuilt` int DEFAULT NULL,
  `Bedrooms` int DEFAULT NULL,
  `FullBath` int DEFAULT NULL,
  `HalfBath` int DEFAULT NULL,
  `saledate` date DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO nashville_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY PropertyAddress, SalePrice, OwnerName, OwnerAddress, Landvalue, YearBuilt, saledate) as row_num
FROM nashville_staging;

DELETE
FROM nashville_staging2
WHERE row_num > 1;

SELECT *
FROM nashville_staging2
WHERE row_num > 1;

SELECT *
FROM nashville_staging2;

-------------------------------------------------------------------------------------------------------------------------------------
-- 4. Manage blank cells
-- i set the blank cells equal to the address of the owner of that house

SELECT *
FROM nashville_staging2
WHERE propertyaddress = '';

UPDATE nashville_staging2
SET Propertyaddress = owneraddress
where Propertyaddress = '';

-------------------------------------------------------------------------------------------------------------------------------------
-- 5. Split the address into street, city and state 

-- add some columns
ALTER table nashville_staging2
Add column address varchar(255),
add column city varchar (100),
add column state varchar (50);

--'Locate' because it's on mysql

SELECT
SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) +1) as City
FROM nashville_staging2;

ALTER TABLE nashville_staging2
ADD Address varchar(255);

Update nashville_staging2
SET Address = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1);

ALTER TABLE nashville_staging2
ADD City varchar(255);
-- Add a column for the split city.
UPDATE nashville_staging2
SET City = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) +1);
-- Input the data for the split city column.

SElECT city as originalcity,
TRIM(substring_index(city,',',1))
AS extractedcity
FROM nashville_staging2;

UPDATE nashville_staging2
SET city = TRIM(substring_index(city,',',1));


-------------------------------------------------------------------------------------------------------------------------------------
-- 6. Remove unnecessary columns

SELECT *
FROM nashville_staging2;


ALTER TABLE nashville_staging2
DROP COLUMN propertyaddress;

-- Lastly, i decided to move the last 3 columns i created to the beginning of the table. In order to have a more organized table.

ALTER table nashville_staging2
ADD column PropertyAddress varchar(100) After LandUse;

Update nashville_staging2
SET PropertyAddress = Address;

ALTER table nashville_staging2
ADD column PropertyCity varchar(100) After PropertyAddress;

Update nashville_staging2
SET PropertyCity = City;

ALTER table nashville_staging2
ADD column Salesdate varchar(100) After SalePrice;

Update nashville_staging2
SET Salesdate = Saledate;

ALTER TABLE nashville_staging2
DROP COLUMN saledate;

Alter table nashville_staging2
rename column PropertyAddress to Address;

Alter table nashville_staging2
rename column Propertycity to City;

Alter table nashville_staging2
rename column Salesdate to Saledate
