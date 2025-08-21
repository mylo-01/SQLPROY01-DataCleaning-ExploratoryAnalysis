-- Data Cleaning

select *
from layoffs;

-- 1. Remove Dups
-- 2. Standardize the Data
-- 3. Null Values or Blank Values (see if we can or not populate them)
-- 4. Remove Any Columns (Not always, need criteria)

#create a copy of the table
create table layoffs_staging 
like layoffs;
#Send data from layoffs to layoffs_staging
insert layoffs_staging
select * from layoffs;
-- This way you keep your data safe

select *
from layoffs_staging;

### REMOVE DUPS ###
select *, 
row_number() over(partition by company, industry, total_laid_off, percentage_laid_off, 'date') as row_num
from layoffs_staging
order by row_num desc
;

with duplicate_cte as
(select *, 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, funds_raised_millions) as row_num
from layoffs_staging
# order by row_num desc
)
select * 
from duplicate_cte
where row_num > 1;

# Create a new table with the row_num and then eliminate the rows with 2 exact entries
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
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging2;

insert into layoffs_staging2
select *, 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, funds_raised_millions) as row_num
from layoffs_staging
;

select *
from layoffs_staging2
where row_num > 1;

delete
from layoffs_staging2
where row_num > 1;


## STANDARDIZING DATA ##

SELECT distinct company, (trim(company))
FROM layoffs_staging2
;

-- REMOVES WHITE SPACE
update layoffs_staging2
set company = trim(company)
;

SELECT *
FROM layoffs_staging2
where industry like "crypto%"
;
-- CRYPTO WAS SPELLED DIFFERENTLY, JUST MADE THEM ALL THE SAME
update layoffs_staging2
set industry = "Crypto"
where industry like "crypto%"
;

-- Removes "." at the end of United States
update layoffs_staging2
set country = trim(trailing "." from country)
where country like "United States%";

-- Change string to date data type // first we need the correct format
select  `date`,
str_to_date(`date`, "%m/%d/%Y")
from layoffs_staging2;

update layoffs_staging2
set  `date` = str_to_date(`date`, "%m/%d/%Y");

alter table layoffs_staging2 #Then we change the data type
modify column `date` date;

## WORK YOUR NULL AND BLANK VALUES
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2
where industry is null or industry = "";

select *
from layoffs_staging2
where company = "Airbnb";

update layoffs_staging2
set industry = null
where industry = "";

-- we are joining itself by cheking the populated cell and populating the equivalent null or "" cell.
select t1.company, t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
    # and t1.location = t2.location
where t1.industry is null
and t2.industry is not null
;

-- Up we check if our statement works, then we update it
update layoffs_staging2 as t1
	join layoffs_staging2 as t2
    on t1.company = t2.company
set t1.industry = t2.industry
	where t1.industry is null
    and t2.industry is not null
;

## REMOVE ROWS. They are missing data and we need to clean it because we are going to be using those columns later.
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- deleated the column we created to find duplicates
alter table layoffs_staging2
drop column row_num;

-- final table
select *
from layoffs_staging2;

-- Change the date column title because it sucks working with that 
alter table layoffs_staging2
change `date` dates date;

select dates
from layoffs_staging2;


