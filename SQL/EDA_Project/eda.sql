-- Exploratory Data Analysis

use world_layoffs;

SELECT *
FROM layoffs_staging2;

SELECT max(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER by funds_raised_millions DESC;

-- using group by, i can see company, industry, country etc with the highest total laid off

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by company
ORDER by 2 desc;

SELECT MIN(date),MAx(date)
FROM layoffs_staging2; -- in order to understand the time in wich this happened

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by industry
ORDER by 2 desc;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by country
ORDER by 2 desc;

SELECT date, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by date
ORDER by 2 desc; -- with this query we see the total laid off day by day

-- let's see by year

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP by YEAR(date)
ORDER by 2 desc;

-- in different company stage

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by stage
ORDER by 2 desc;

-- pullout the month from the date

SELECT SUBSTRING(`date`,6,2) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
group by `MONTH`;
-- but now we have month for all the years, so let's try to take month and year with no null cells

SELECT SUBSTRING(`date`,1,7) AS MonthYear, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) is NOT NULL
group by MonthYear
order by 1 ASC;


WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS MonthYear, SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) is NOT NULL
group by MonthYear
order by 1 ASC
)
SELECT monthyear, total_off
, SUM(total_off) OVER (order by monthyear) AS rolling_totale
FROM rolling_total;

-- with this tool i can see that in March 2020 there was 9628 laid off and in March 2021 (with only 47 laid offs) the total was 88726 in 1 year and so on...

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
group by company, YEAR(`date`)
ORDER BY 3 DESC;

-- add a cte

WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
group by company, YEAR(`date`)
)
SELECT *
FROM company_year;

-- but who fired most people per year? (dense rank)

WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
group by company, YEAR(`date`)
), company_year_rank AS
(SELECT *, DENSE_RANK() OVER (partition by years order by total_laid_off DESC) as ranking
FROM company_year
WHERE years is not null
)
SELECT *
FROM company_year_rank
WHERE ranking <=5;


SELECT *
FROM layoffs_staging2;


SELECT location, SUM(total_laid_off)
FROM layoffs_staging2
group by location
ORDER BY 2 DESC;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
group by industry
ORDER BY 2 DESC;


SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
group by industry, YEAR(`date`)
ORDER BY 3 DESC;

WITH industry_year (industry, years, total_laid_off) AS
(
SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
group by industry, YEAR(`date`)
)
SELECT *
FROM industry_year;


WITH industry_year (industry, years, total_laid_off) AS
(
SELECT industry, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
group by industry, YEAR(`date`)
), industry_year_rank AS
(SELECT *, DENSE_RANK() OVER (partition by years order by total_laid_off DESC) as ranking
FROM industry_year
WHERE years is not null
)
SELECT *
FROM industry_year_rank
WHERE ranking <=5;
