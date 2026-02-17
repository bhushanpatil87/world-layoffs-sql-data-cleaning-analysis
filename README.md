📊 World Layoffs – SQL Data Cleaning & Transformation Project
📌 Project Overview

This project focuses on cleaning and transforming a real-world layoffs dataset using MySQL.

The goal of this project is to:

Prepare raw data for analysis

Remove duplicate records

Standardize inconsistent values

Handle missing data

Convert data types properly

Deliver a clean and analysis-ready dataset

This project simulates a real-world data cleaning workflow used by Data Analysts.

🛠 Tools & Environment

Database: MySQL

Editor: VS Code

Version Control: Git & GitHub

📂 Project Structure
world-layoffs-sql-data-cleaning-analysis/
│
├── database_setup.sql
├── 1-cleaning.sql
└── README.md

🗄️ Step 1: Database Setup

File: database_setup.sql

This file:

Creates the database world_layoffs

Selects the database

Loads the original layoffs table

CREATE DATABASE world_layoffs;
USE world_layoffs;

SELECT * FROM layoffs;


Purpose:
To ensure the working environment is properly initialized before performing transformations.

🧹 Step 2: Data Cleaning & Transformation

File: 1-cleaning.sql

This file performs all data cleaning operations in a structured way.

1️⃣ Creating a Staging Table

A copy of the original dataset is created to protect the raw data.

CREATE TABLE layoffs_staging AS
SELECT * FROM layoffs;


Why?
To avoid modifying the original dataset during cleaning.

2️⃣ Removing Duplicate Records

Duplicates are identified using the ROW_NUMBER() window function:

ROW_NUMBER() OVER (
    PARTITION BY company, location, industry,
                 total_laid_off, percentage_laid_off,
                 date, stage, country,
                 funds_raised_millions
)


Duplicate rows (row number > 1) are deleted using a JOIN-based deletion approach.

Alternative method:

Create a second staging table

Insert data with row numbers

Delete rows where row_num > 1

Purpose:
To ensure data integrity and avoid double-counting during analysis.

3️⃣ Standardizing Data
✔ Removing Extra Spaces
UPDATE layoffs_staging2
SET company = TRIM(company);


Removes unwanted leading and trailing spaces.

✔ Fixing Country Name Inconsistencies

Example:

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country = 'United States.';


Ensures consistent country naming for accurate grouping.

✔ Standardizing Industry Values
UPDATE layoffs_staging2
SET industry = 'Crypto Currency'
WHERE industry LIKE 'crypto%';


Unifies different variations of the same industry.

✔ Converting Date Format

The original date column was stored as text.
It was converted into proper DATE format:

UPDATE layoffs_staging2
SET date = STR_TO_DATE(date, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;


Purpose:
To enable time-based analysis like yearly or monthly trends.

4️⃣ Handling Missing Values
✔ Converting Blank Values to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


Blank values are not the same as NULL, so they were standardized.

✔ Filling Missing Industry Values

Used self-join to fill missing industry values from other rows of the same company:

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
     ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;


Purpose:
To improve completeness of the dataset.

5️⃣ Removing Unnecessary Rows

Rows where both layoff metrics were missing were removed:

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


Purpose:
Such rows do not contribute to meaningful analysis.

6️⃣ Final Cleanup

The temporary helper column row_num was dropped:

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


The final table layoffs_staging2 is now:

✔ Clean
✔ Deduplicated
✔ Standardized
✔ Properly formatted
✔ Ready for analysis

📈 Outcome

After cleaning:

Duplicate records were removed

Inconsistent naming was fixed

Dates were standardized

Missing values were handled

Unnecessary rows were removed

The dataset is now ready for:

Exploratory Data Analysis (EDA)

Trend Analysis

Visualization (Power BI / Tableau)

Business Insights generation

🎯 Key Learning Outcomes

This project demonstrates:

Practical use of window functions (ROW_NUMBER())

CTE usage

Data standardization techniques

Handling missing values

Data transformation best practices

Safe cleaning using staging tables

Real-world SQL workflow

🚀 Future Improvements

Add exploratory analysis queries

Create a Power BI dashboard

Build trend visualizations

Publish insights report

If you want, next I can:

Make this README more advanced (Data Analyst portfolio level)

Add an EDA section

Add business insights summary

Help you write LinkedIn post for this project 🚀

Make this README more advanced (Data Analyst portfolio level)

Here’s a Data Analyst portfolio–level README for your project. You can copy this directly into your README.md file on GitHub.

🌍 World Layoffs Data Cleaning & Transformation (SQL Project)
📌 Project Overview

This project focuses on cleaning and transforming a real-world layoffs dataset using MySQL.

The objective was to convert raw, inconsistent data into a structured, reliable dataset suitable for analysis and reporting.

The project demonstrates:

Data cleaning using SQL

Duplicate detection & removal

Data standardization

Null value handling

Data type conversion

Safe staging workflow

Best practices for production-ready datasets

🛠 Tools & Environment

Database: MySQL

Query Tool: MySQL Workbench

Editor: VS Code

Version Control: Git & GitHub

🗂 Project Structure
world-layoffs-sql-data-cleaning-analysis/
│
├── database_setup.sql       # Database creation & initial setup
├── 1-cleaning.sql           # Complete data cleaning process
└── README.md                # Project documentation

🗄 Dataset Description

The dataset contains information about global employee layoffs including:

Company

Location

Industry

Total Laid Off

Percentage Laid Off

Date

Company Stage

Country

Funds Raised (Millions)

The raw dataset contained:

Duplicate records

Inconsistent naming

Improper date formats

Null and blank values

Formatting inconsistencies

🔍 Data Cleaning Process

The cleaning process was structured into 5 major stages to ensure data integrity and reproducibility.

1️⃣ Creating a Staging Table (Best Practice)

To protect the original dataset, a staging table was created:

CREATE TABLE layoffs_staging AS
SELECT * FROM layoffs;

Why?

Prevent accidental data loss

Allow reversible transformations

Follow production-safe workflow

2️⃣ Duplicate Detection & Removal
🔎 Identifying Duplicates

Used ROW_NUMBER() window function with PARTITION BY all relevant columns to detect exact duplicates:

ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off,
date, stage, country, funds_raised_millions
)

🗑 Removing Duplicates

Since MySQL has CTE delete limitations, a JOIN method was used to delete rows where row_number > 1.

This ensures:

Only exact duplicate records were removed

No legitimate records were deleted

3️⃣ Data Standardization
✂ Removing Extra Spaces
UPDATE layoffs_staging2
SET company = TRIM(company);

🌎 Fixing Inconsistent Country Names

Example:

United States. → United States

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country = 'United States.';

🪙 Standardizing Industry Naming

Example:

crypto, CryptoCurrency, etc.

Standardized to: Crypto Currency

UPDATE layoffs_staging2
SET industry = 'Crypto Currency'
WHERE industry LIKE 'crypto%';

4️⃣ Date Format Conversion

The date column was stored as TEXT and converted into proper DATE format.

UPDATE layoffs_staging2
SET date = STR_TO_DATE(date, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;

Why This Matters

Enables time-series analysis

Allows grouping by month/year

Improves performance

Makes BI reporting possible

5️⃣ Handling Null & Missing Values
🔄 Converting Blank Values to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

🔗 Filling Missing Industry Using Self Join
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

🗑 Removing Irrelevant Records

Rows where both total_laid_off and percentage_laid_off were NULL were removed:

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

🧹 Final Cleanup

Removed temporary helper column:

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


Final cleaned table:

layoffs_staging2

📊 Data Quality Improvements Achieved

✔ Removed exact duplicate records
✔ Standardized categorical values
✔ Fixed inconsistent country naming
✔ Converted date to proper DATE format
✔ Handled missing industry values intelligently
✔ Removed unusable rows
✔ Preserved raw data integrity

🚀 Key SQL Skills Demonstrated

Window Functions (ROW_NUMBER)

CTEs
Self Joins
Data Standardization Techniques
Date Formatting & Conversion
Data Integrity Practices
Conditional Updates
Production-safe staging workflows

👨‍💻 Author
Bhushan Patil
Aspiring Data Analyst
Skilled in SQL, Power BI, Data Cleaning & Reporting
