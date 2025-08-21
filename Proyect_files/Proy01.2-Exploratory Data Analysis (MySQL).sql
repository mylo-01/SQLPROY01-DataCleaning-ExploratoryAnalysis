-- Explotaroty Data Analysis :)
select  * from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2
;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc
;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select min(dates), max(dates)
from layoffs_staging2;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select country, year(dates), sum(total_laid_off)
from layoffs_staging2
group by country, year(dates)
order by 3 desc;

-- Rolling sum // Exploring 
select substring(dates, 1, 7) as months, sum(total_laid_off)
from layoffs_staging2
where substring(dates, 1, 7) is not null
group by months
order by months desc;

## Este tiene lo suyo, hay que seguir revisándolo
with rolling_totalt as(
select substring(dates, 1, 7) as months, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(dates, 1, 7) is not null
group by months
order by months
)
select months, total_off,
 sum(total_off) over(order by months) as rolling_total
from rolling_totalt;

select company, year(dates) as years, total_laid_off
from layoffs_staging2
order by company, year(dates)
;

## Este es el más complicado, hay que poder hacerlo sin ayuda.
with company_yearly_layoffs as (
select company, year(dates) as years, total_laid_off
from layoffs_staging2
order by company, year(dates)
), company_year_rank as 
(select *, rank() over(partition by years order by total_laid_off desc) as ranking
from company_yearly_layoffs
where years is not null
)
select * 
from company_year_rank
where ranking <= 5
order by ranking, years;