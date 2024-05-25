-- Exploratory Data Analysis
-- the dataset pertains to Tech company layoffs from COVID 2019 to present day

SELECT * FROM world_layoffs.layoffs_staging2;
describe layoffs_staging2;

alter table layoffs_staging2
modify column percentage_laid_off double;

select min(date), max(date) from layoffs_staging2;

select * from layoffs_staging2 where percentage_laid_off = 1;

select company, total_laid_off from layoffs_staging2 
order by 2 desc;

select company, sum(total_laid_off) from layoffs_staging2 
group by company order by 2 desc;

select industry, sum(total_laid_off) from layoffs_staging2 
group by industry order by 2 desc;

select country, sum(total_laid_off) from layoffs_staging2 
group by country order by 2 desc;

Select year(date), sum(total_laid_off) from layoffs_staging2
group by year(date) order by 2 desc;

select *, (total_laid_off/percentage_laid_off) as employees 
from layoffs_staging2;

-- creating rolling total of employee layoffs

with Rolling_Total as
(
select substring(date,1,7) as Month, sum(total_laid_off) as total
from layoffs_staging2
group by Month
)
select Month, total as month_total, sum(total) over(order by month) as rolling_total
from Rolling_Total;












