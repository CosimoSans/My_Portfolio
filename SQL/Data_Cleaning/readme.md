
## Data Cleaning Project - Nashville Housing Dataset

This project focuses on cleaning and preparing a real estate dataset using SQL, with the goal of transforming raw and inconsistent data into a structured and analysis-ready format.

The work was carried out on a copy of the original dataset in order to preserve data integrity, following a typical data cleaning workflow used in real-world scenarios.

### Objectives

The main objectives of the project were:

- Standardize and reformat inconsistent data
- Handle missing and blank values
- Identify and remove duplicate records
- Restructure columns to improve usability
- Split and reorganize address-related information
- Remove unnecessary or redundant fields

### Approach

The project follows a step-by-step cleaning process:

- Created a staging table to avoid modifying the original dataset
- Converted date formats into a standardized SQL DATE format
- Standardized categorical values (e.g. transforming Y/N into Yes/No)
- Identified duplicates using window functions and removed them
- Managed missing values by leveraging related fields
- Split address fields into structured components (street and city)
- Dropped unused columns and reorganized the table structure

The implementation required the use of SQL features such as:

- Window functions (ROW_NUMBER)
- CTEs
- String manipulation functions
- Conditional logic (CASE statements)
- Aggregation and filtering

### Results & Key Takeaways

After the cleaning process, the dataset became more consistent, readable and suitable for further analysis.

Key improvements include:

- Standardized date and categorical fields
- Removal of duplicate records
- Better handling of missing values
- Improved data structure with clearly separated fields
- Enhanced overall data quality and usability

This project reflects a typical data cleaning workflow, highlighting how raw data can be transformed into a reliable dataset ready for analytical use.

It also demonstrates the importance of structuring queries logically and working step-by-step when dealing with complex data transformations.
