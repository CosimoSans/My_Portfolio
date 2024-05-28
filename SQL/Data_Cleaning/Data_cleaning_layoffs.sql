-- DATA CLEANING

use world_layoffs

SELECT *
FROM layoffs

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. NULL or blank values
-- 4. Remove unnecessary columns

-- create a new table
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

-- assegnare un numero a tutte le righe uniche

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- creare una CTE per identificare quelli che hanno valore 2 o maggiore

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- facciamo un controllo a campione veloce, per vedere se effettivamente ha funzionato, e sono effettivamente duplicati

SELECT *
FROM layoffs_staging
WHERE company = 'Oda'

-- abbiamo notato che non era del tutto un duplicato quindi tocca cambiare la partition. Mettiamo ogni singola colonna.
-- ora basterebbe aggiugnere alla CTE DELETE per cancellare quelli con 2, ma su mYSQL non è possibile farlo per le CTE's

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;

-- da errore
-- quindi per poter rimuovere questi dati devo creare una nuova tabella e cancellarli da li

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

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

-- STANDARDIZING DATA

SELECT company, TRIM(company)
FROM layoffs_staging2

UPDATE layoffs_staging2
SET company = TRIM(company)
 
SELECT *
FROM layoffs_staging2;

SELECT Distinct industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry like 'Crypto%'

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'

-- update country
SELECT DISTINCT country
FROM layoffs_staging2
Order by 1

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
Order by 1

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'

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
WHERE total_laid_off is NULL
and percentage_laid_off is NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off is NULL
and percentage_laid_off is NULL; -- nel caso in cui volessi cancellarlo

-- non abbiamo modo di inserire dei dati in queste colonne, proviamo in altre colonne

SELECT *
FROM layoffs_staging2
where industry is NULL
OR industry ='';

-- ad esempio in industry abbiamo 3 vuoti e un NULL, vediamo se le aziende che non hanno una industry, ce l'hanno in altre righe (si)

SELECT *
FROM layoffs_staging2
WHERE company = 'airbnb';

-- si, quindi per airbnb in industry dobbiamo mettere travel ecc. per farlo, però, dobbiamo prima sostituire tutti i blank con NULL altrimenti da errore

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- adesso sono tutti NULL. adesso creaiamo due tabelle, una in cui l'industry è null e una in cui è uguale a quello che dovrebbe essere

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
WHERE (t1.industry is null OR t1.industry = '')
AND t2.industry is NOT null;

-- mettiamo a confronto le due industry

SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
	AND t1.location = t2.location
WHERE t1.industry is null
AND t2.industry is NOT null;

-- ora sostituiamo i NULL con l'industry corretta

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry is NULL
AND t2.industry is NOT NULL;
 

-- eliminare la colonna usata per le righe e che non ci serve piu row_num

SELECT *
FROM layoffs_staging2;

ALTER table layoffs_staging2
DROP column row_num;

-- CLEAN

Select *
FROM layoffs_staging2
where stage is NULL;


Select *
from layoffs_staging2
where company = 'Spreetail'











