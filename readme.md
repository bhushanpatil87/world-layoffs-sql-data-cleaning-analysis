🌍 World Layoffs Data Cleaning & Transformation (SQL Project) 📌 Project Overview

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

Why?

Prevent accidental data loss
Allow reversible transformations
Follow production-safe workflow

2️⃣ Duplicate Detection & Removal
🔎 Identifying Duplicates

🗑 Removing Duplicates
Since MySQL has CTE delete limitations, a JOIN method was used to delete rows where row_number > 1.

This ensures: Only exact duplicate records were removed, No legitimate records were deleted

3️⃣ Data Standardization
✂ Removing Extra Spaces
UPDATE layoffs_staging2
SET company = TRIM(company);

🌎 Fixing Inconsistent Country Names

Example: United States. → United States

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country = 'United States.';

🪙 Standardizing Industry Naming

Example: crypto, CryptoCurrency, etc.

Standardized to: Crypto Currency

UPDATE layoffs_staging2
SET industry = 'Crypto Currency'
WHERE industry LIKE 'crypto%';

4️⃣ Date Format Conversion

The date column was stored as TEXT and converted into proper DATE format.
'%m/%d/%Y'

Why This Matters

Enables time-series analysis
Allows grouping by month/year
Improves performance
Makes BI reporting possible

5️⃣ Handling Null & Missing Values
🔄 Converting Blank Values to NULL

🔗 Filling Missing Industry Using Self Join

🗑 Removing Irrelevant Records

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

📈 Why This Project Matters
In real-world analytics, data cleaning consumes 70–80% of the workflow.

This project demonstrates:
Analytical thinking
Structured cleaning methodology
Production mindset
Understanding of data integrity
SQL proficiency beyond basic SELECT queries

🔮 Future Enhancements
Exploratory Data Analysis (EDA)
Layoffs trend by year/month
Industry-wise layoff trends
Country comparison analysis
Power BI Dashboard Integration
Data Visualization layer

📌 How to Run This Project
Clone the repository
Import the raw dataset into MySQL
Run database_setup.sql
Execute 1-cleaning.sql
Query the cleaned table layoffs_staging2

👨‍💻 Author

Bhushan Patil
Aspiring Data Analyst
Skilled in SQL, Power BI, Data Cleaning & Reporting