/* =====================================================
   WORLD LAYOFFS DATA CLEANING PROJECT
   Tool: MySQL
   Environment: VS Code
   ===================================================== */

-- =====================================================
-- 1️⃣ CREATE STAGING TABLE 
-- =====================================================
-- copy from main data to another table for safer side so if anything goes wrong our main database will safe

CREATE TABLE layoffs_staging AS
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging;

-- =====================================================
-- 2️⃣.FINDING DUPLICATES
-- =====================================================
-- Using CTE, ROW_NUMBER() window function to identify exact duplicate records

with dupl as(
	select *,
	row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off,`date`,stage, country,funds_raised_millions) as rn_count 
	from layoffs_staging
)
select * from dupl
where rn_count >1 ;

-- checking exactly that is it a duplicate or not 'company = Akerna'
select * from layoffs_staging  -- there are difference so we need to partition by all column for exact duplicate
where company = 'Akerna' or company = 'Better.com'; 

-- checking again
select * from layoffs_staging  
where company = 'Casper' ; -- ya now we get exact duplicate

-- now that we have found duplicate data we can now delete it
with dupl as(
	select *,
	row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off,`date`,stage, country,funds_raised_millions) as rn_count 
	from layoffs_staging
)
select * from dupl
where rn_count >1 ; -- this is not works in mysql workbench

-- to encounter this we should use join
delete ls from layoffs_staging ls
join (
	select *,
	row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off,`date`,stage, country,funds_raised_millions) as rn_count 
	from layoffs_staging  
)lof ON ls.company = lof.company
AND ls.location = lof.location
AND ls.industry = lof.industry
AND ls.total_laid_off = lof.total_laid_off
AND ls.percentage_laid_off = lof.percentage_laid_off
AND ls.`date` = lof.`date`
AND ls.stage = lof.stage
AND ls.country = lof.country
AND ls.funds_raised_millions = lof.funds_raised_millions
where rn_count>1;

select count(*) from layoffs_staging;

-- we can also use other method to delete duplicate data
-- another method is to create another table and insert data with row number and then delete duplicate data by using row number
-- other method
CREATE TABLE `layoffs_staging2` (
  `company` text DEFAULT NULL,
  `location` text DEFAULT NULL,
  `industry` text DEFAULT NULL,
  `total_laid_off` int(11) DEFAULT NULL,
  `percentage_laid_off` text DEFAULT NULL,
  `date` text DEFAULT NULL,
  `stage` text DEFAULT NULL,
  `country` text DEFAULT NULL,
  `funds_raised_millions` int(11) DEFAULT NULL,
  `row_number` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

select * from layoffs_staging2;

insert into layoffs_staging2 
select *,
	row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off,`date`,stage, country,funds_raised_millions) as rn_count 
	from layoffs;
    
with dupl as(
	select *,
	row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off,`date`,stage, country,funds_raised_millions) as rn_count 
	from layoffs_staging2
)
select * from dupl
where rn_count >1 ;

delete from layoffs_staging2
where row_num > 1;
    
select count(*) from layoffs_staging2;

-- =====================================================
-- 3️⃣ STANDARDIZE DATA
-- =====================================================

-- checking distinct n blanck space / Remove extra spaces in company names
select trim(company)
from layoffs_staging2;

-- let's now update this company names trim
update layoffs_staging2
set company = trim(company);

select trim(company)
from layoffs_staging2; -- yes now we have standardized company names by removing blank space

-- checking distinct country names
select country,count(country) from layoffs_staging2
group by country
order by count(country) asc;

select distinct(industry)
from layoffs_staging2
order by industry asc;

select industry,count(industry)
from layoffs_staging2
group by industry;

select distinct(country) -- 1 issue found in conuntry name 'United States' and 'United States of America' we need to standardize it
from layoffs_staging2
order by country asc;

-- Fix inconsistent country names
UPDATE layoffs_staging2
SET country = 'United States'
WHERE country = 'United States.';

-- Standardize Crypto industry naming
UPDATE layoffs_staging2
SET industry = 'Crypto Currency'
WHERE industry LIKE 'crypto%';

-- DATE FORMAT CONVERSION
-- Convert text date to proper DATE format
select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

select `date`
from layoffs_staging2;

update layoffs_staging2
set date = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;

-- =====================================================
-- 4️⃣ HANDLE NULL VALUES
-- =====================================================
-- checking null values
select * from layoffs_staging2
where funds_raised_millions is null
AND Stage is null;

--checking null and blank values in industry column
select * from layoffs_staging2
where industry is null
OR industry = '';

update layoffs_staging2 -- we will do this because blank value is not null value so we will convert blank value to null value
set industry = null
where industry = '';

-- cehcking again using join
-- join

select t1.industry , t2.industry from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
	AND t1.location = t2.location
where (t1.industry is null or t1.industry = '') 
AND t2.industry is not null;

-- Fill missing industry using self join
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
     ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- =====================================================
-- 5️⃣ deleting unnecessary rows and columns
-- =====================================================
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


-- FINAL CLEANUP
alter table layoffs_staging2
drop column row_num;

select * from layoffs_staging2;