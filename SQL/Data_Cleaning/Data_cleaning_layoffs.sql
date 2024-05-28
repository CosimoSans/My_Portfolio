-- DATA CLEANING

use world_layoffs

SELECT *
FROM layoffs

-- Case Studi objectives:
	
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. NULL or blank values
-- 4. Remove unnecessary columns

-- SQL skills involved: string functions, joins, CTE's, date manipulation, views, aggregate functions, string manipulation

-- first of all: let's create a new table in order to modify and clean the data without changing the original table

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Identify duplicates

SELECT *
FROM layoffs;

-- a method i use to remove duplicates is to assign a number to unique rows, so if any row is duplicated, it will have a different number

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Now i want to search for all rows that have 'row_num' >= 2. To do this, i need to use a CTE.

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- let's do a spot check to see if they are indeed duplicates
-- now i should delete them, but in mysql i can't delete from CTE

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;

-- error
-- so i need to create another table and delete from there, using the create table menu in wich i manually insert the new table staging2

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2

-- insert data again in staging2
	
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- delete duplicates

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

-- Duplicates removed
-- STANDARDIZING DATA

-- Remove unnecessary spaces and update the tables
SELECT company, TRIM(company)
FROM layoffs_staging2

UPDATE layoffs_staging2
SET company = TRIM(company)
 
SELECT *
FROM layoffs_staging2;


-- then we need to standardize the 'industry' column

SELECT Distinct industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry like 'Crypto%'

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'

-- update country (i found a '.' after 'United States')
	
SELECT DISTINCT country
FROM layoffs_staging2
Order by 1

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
Order by 1

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'

-- standardize date

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')

SELECT `date`
FROM layoffs_staging2

Alter table layoffs_staging2
Modify Column `date` DATE;

-- blank and NULL

SELECT *
FROM layoffs_staging2
where industry is NULL
OR industry ='';

-- let's compare the companies that have 'blank' or NULL in industry with the industry of the same company but on another row

SELECT *
FROM layoffs_staging2
WHERE company = 'airbnb';

-- i found that airbnb has 'travel' in industry, so yeah, i can replace every blank cell with the industry of another row (for the same company)
-- but for doing that, i have to replace every blank cell with NULL

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- now i have only NULL. let's create two tables: one with industry = Null and one with the right industry

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
WHERE (t1.industry is null OR t1.industry = '')
AND t2.industry is NOT null;


SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
WHERE t1.industry is null
AND t2.industry is NOT null;

-- now i can replace the NULL with the industry

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry is NULL
AND t2.industry is NOT NULL;
 

-- Delete unnecessary columns

SELECT *
FROM layoffs_staging2;

ALTER table layoffs_staging2
DROP column row_num;

-- CLEAN












