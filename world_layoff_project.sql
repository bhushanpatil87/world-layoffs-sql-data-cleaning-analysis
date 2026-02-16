create database world_layoffs;
use world_layoffs;

select * from layoffs;

create table layoffs_staging select *from layoffs;
select * from layoffs_staging;

-- 1.finding duplicates

with dupl as(
	select *,
	row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off,`date`,stage, country,funds_raised_millions) as rn_count 
	from layoffs_staging
)
select * from dupl
where rn_count >1 ;

-- checking exactly that is it a duplicate or not 'company = Akerna'
select * from layoffs_staging  -- there are difference they r no duplicates 
where company = 'Akerna' or company = 'Better.com'; -- so we need to partition by all column for exact duplicate
 
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

select count(*) from layoffs_staging; -- 2353 count

-- OR other method
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
    
select count(*) from layoffs_staging2; -- 2356
SET SQL_SAFE_UPDATES = 0;

-- 2.standardizing data

-- checking distinct n blanck space
select trim(company)
from layoffs_staging2;
-- let's now update this trim
update layoffs_staging2
set company = trim(company);

select trim(company)
from layoffs_staging2;

select country,count(country) from layoffs_staging2
group by country
order by count(country) asc;

select distinct(industry)
from layoffs_staging2
order by industry asc;

select industry,count(industry)
from layoffs_staging2
group by industry;

-- changing /replacing industry name
update layoffs_staging2
set industry = 'Crypto Currency'
where  industry like 'crypto%';

select distinct(location) -- all clear
from layoffs_staging2
order by location asc;

select distinct(country) -- 1 issue found 
from layoffs_staging2
order by country asc;

update layoffs_staging2
set country = 'United States'
where country = 'United States.';

select * from layoffs_staging2
where country = 'United States';

-- changing dt of date
select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

select `date`
from layoffs_staging2;

update layoffs_staging2
set date = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;

-- 3.handling with null
select * from layoffs_staging2
where 
-- date is null AND 
funds_raised_millions is null
AND Stage is null;

select * from layoffs_staging2
where industry is null
OR industry = '';

select * from layoffs_staging2
where company = 'Carvana';

update layoffs_staging2
set industry = null
where industry = '';


-- join

select t1.industry , t2.industry from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
	AND t1.location = t2.location
where (t1.industry is null or t1.industry = '') 
AND t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry= t2.industry
where (t1.industry is null or t1.industry = '') 
AND t2.industry is not null;

-- 4.deleting column, row
delete from layoffs_staging2
where total_laid_off is null
AND percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;

select * from layoffs_staging2;