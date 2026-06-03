## Data Cleaning Projects – SQL

This project focuses on cleaning and preparing raw datasets using SQL, transforming inconsistent and unstructured data into reliable and analysis-ready formats.

The work is based on two different real-world datasets (housing data and layoffs data), allowing the application of similar data cleaning techniques on different types of data structures and business contexts.

In both cases, the original tables were preserved by working on staging copies, following a structured and repeatable data cleaning approach.

### Objectives

The main objectives across the datasets were:

- Remove duplicate records
- Standardize inconsistent values and formats
- Handle missing or blank data
- Restructure and improve data organization
- Remove unnecessary or redundant columns

### Approach

A structured, step-by-step process was followed in both datasets:

- Creation of staging tables to avoid modifying original data
- Identification and removal of duplicates using window functions (ROW_NUMBER)
- Standardization of categorical values (e.g. Y/N → Yes/No, consistent labeling of industries)
- Cleaning of textual data (trimming spaces, correcting inconsistencies)
- Conversion of date formats into standardized SQL DATE format
- Handling missing and blank values by leveraging existing data relationships
- Splitting and reorganizing columns (e.g. breaking down address fields into structured components)
- Removal of unnecessary columns and reorganization of table structure

The implementation required the use of advanced SQL features, including:

- Window functions (ROW_NUMBER)
- CTEs
- Joins
- String manipulation functions
- Conditional logic (CASE statements)
- Date and format manipulation
- Aggregation and filtering techniques

### Results & Key Takeaways

After the cleaning process, both datasets became more consistent, structured and suitable for further analysis.

Key improvements include:

- Removal of duplicate data and inconsistencies
- Standardized formats across categorical and date fields
- Improved handling of missing values
- Better organization of data through structured columns
- Increased overall data quality and reliability

This project demonstrates how similar data cleaning methodologies can be applied across different datasets, highlighting the importance of a systematic approach when dealing with raw data.

It also reflects a typical real-world data workflow, where transforming raw data into a clean and usable format is a necessary step before any analytical activity.
