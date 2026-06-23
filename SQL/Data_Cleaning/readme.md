
# SQL Data Cleaning Projects

This section contains SQL projects focused on data cleaning and data preparation using real-world style datasets.

The goal of these projects is to simulate a typical data analyst workflow, where raw and inconsistent data must be transformed into clean, structured, and analysis-ready datasets.

---

## What These Projects Show

These projects demonstrate how SQL can be used to:

- clean and transform raw datasets  
- improve data quality and consistency  
- prepare data for further analysis  
- apply structured logic to real-world data problems  

They reflect a practical workflow commonly used in data analysis:

1. inspect raw data  
2. create staging tables  
3. clean and standardize the dataset  
4. remove inconsistencies and duplicates  
5. produce a final cleaned dataset ready for analysis  

---

## Projects Included

### 1. Nashville Housing Data Cleaning
A data cleaning project on housing transaction data.

Focus areas:
- date standardization  
- data normalization (Yes/No values)  
- duplicate detection and removal  
- handling missing values  
- splitting address fields into structured columns  
- reshaping the dataset into a cleaner format  

---

### 2. World Layoffs Data Cleaning
A data cleaning project based on layoffs data across companies and countries.

Focus areas:
- duplicate removal using window functions  
- standardization of company, industry, and country values  
- date formatting and conversion  
- handling NULL and blank values  
- data consistency checks across records  

---

## Techniques Used

Across the projects, the following SQL techniques are applied:

- `ROW_NUMBER()` for duplicate detection  
- `CTE` (Common Table Expressions)  
- `JOIN` operations for data correction  
- `CASE WHEN` for standardization  
- string functions (`TRIM`, `SUBSTRING`, `LOCATE`)  
- date functions (`STR_TO_DATE`)  
- use of staging tables  
- data transformation and restructuring  

---

## Why Data Cleaning Matters

Data cleaning is a critical step in any data analysis process.

Raw datasets are often:
- incomplete  
- inconsistent  
- duplicated  
- poorly formatted  

These projects show how SQL can be used to solve these issues and turn raw data into reliable datasets that can support business analysis and decision-making.

---

## Tools Used

- MySQL  
- SQL (Data Cleaning & Transformation)  
