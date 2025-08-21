Layoffs Data Cleaning Project
Project Overview
This project focuses on cleaning and preparing a dataset on company layoffs. The main goal is to ensure the data is accurate, consistent, and ready for analysis by performing standard data cleaning steps.

Dataset
Source: Provided by Alex the Analyst

Original Table: layoffs

Working Tables: layoffs_staging, layoffs_staging2

Data Cleaning Steps
1. Create Staging Table
Created a copy of the original table to preserve raw data:

sql
CREATE TABLE layoffs_staging LIKE layoffs;
INSERT INTO layoffs_staging SELECT * FROM layoffs;
2. Remove Duplicates
Identified and removed duplicate records using window functions:

sql
WITH duplicate_cte AS (
  SELECT *, 
    ROW_NUMBER() OVER(
      PARTITION BY company, location, industry, total_laid_off, 
      percentage_laid_off, date, stage, funds_raised_millions
    ) AS row_num
  FROM layoffs_staging
)
DELETE FROM layoffs_staging2 WHERE row_num > 1;
3. Standardize Data
Performed data standardization including trimming whitespace, standardizing values, and formatting:

sql
UPDATE layoffs_staging2 SET company = TRIM(company);
UPDATE layoffs_staging2 SET industry = 'Crypto' WHERE industry LIKE 'crypto%';
UPDATE layoffs_staging2 SET country = TRIM(TRAILING '.' FROM country) 
WHERE country LIKE 'United States%';
ALTER TABLE layoffs_staging2 MODIFY COLUMN date DATE;
4. Handle Null and Blank Values
Addressed missing data through imputation and removal:

sql
UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

DELETE FROM layoffs_staging2 
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
5. Final Cleanup
Performed final table modifications:

sql
ALTER TABLE layoffs_staging2 DROP COLUMN row_num;
ALTER TABLE layoffs_staging2 CHANGE `date` dates DATE;
Exploratory Data Analysis
Initial Data Exploration
sql
SELECT * FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;
Companies with Complete Layoffs
sql
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
Layoffs by Company
sql
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
Date Range Analysis
sql
SELECT MIN(dates), MAX(dates)
FROM layoffs_staging2;
Industry Analysis
sql
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
Country Analysis
sql
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT country, YEAR(dates), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country, YEAR(dates)
ORDER BY 3 DESC;
Monthly Trends
sql
SELECT SUBSTRING(dates, 1, 7) AS months, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(dates, 1, 7) IS NOT NULL
GROUP BY months
ORDER BY months DESC;
Rolling Total Calculation
sql
WITH rolling_totalt AS (
  SELECT SUBSTRING(dates, 1, 7) AS months, SUM(total_laid_off) AS total_off
  FROM layoffs_staging2
  WHERE SUBSTRING(dates, 1, 7) IS NOT NULL
  GROUP BY months
  ORDER BY months
)
SELECT months, total_off,
  SUM(total_off) OVER(ORDER BY months) AS rolling_total
FROM rolling_totalt;
Yearly Company Analysis
sql
SELECT company, YEAR(dates) AS years, total_laid_off
FROM layoffs_staging2
ORDER BY company, YEAR(dates);
Top 5 Companies by Layoffs Each Year
sql
WITH company_yearly_layoffs AS (
  SELECT company, YEAR(dates) AS years, total_laid_off
  FROM layoffs_staging2
  ORDER BY company, YEAR(dates)
), company_year_rank AS (
  SELECT *, RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM company_yearly_layoffs
  WHERE years IS NOT NULL
)
SELECT * 
FROM company_year_rank
WHERE ranking <= 5
ORDER BY ranking, years;
Final Output
Cleaned Table: layoffs_staging2

Status: Data is clean, consistent, and ready for analysis

Features: No duplicates, standardized values, proper data types, and handled missing values
