Use nashville;


-- date

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

-- dividere property address in address, city, state


SELECT DISTINCT SoldAsVacant
FROM nashville_staging;

-- notiamo che ci sono anche N e Y

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
    
--

-- duplicates

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

/* ora se fosse sql normale, basterebbe:
DELETE
FROM duplicate_cte
WHERE row_num > 1;
ma non si può in mySQL, quindi devo modificare a mano la tabella iniziale*/

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

-- blank propertyaddress

SELECT *
FROM nashville_staging2
WHERE propertyaddress = '';

UPDATE nashville_staging2
SET Propertyaddress = owneraddress
where Propertyaddress = '';


-- dividere property address in indirizzo, stato e paese

-- aggiungere nuove colonne
ALTER table nashville_staging2
Add column address varchar(255),
add column city varchar (100),
add column state varchar (50);

-- aggiornare le nuove colonne con i dati estratti
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

SElect city as originalcity,
TRIM(substring_index(city,',',1))
AS extractedcity
FROM nashville_staging2;

UPDATE nashville_staging2
SET city = TRIM(substring_index(city,',',1));



-- rimuovere colonne superflue

SELECT *
FROM nashville_staging2;


ALTER TABLE nashville_staging2
DROP COLUMN propertyaddress;

-- spostamento colonne create da in coda alla tabella all'inizio

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
