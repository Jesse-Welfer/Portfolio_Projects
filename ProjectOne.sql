-- Data Cleaning

Select * from layoffs;

create table layoffs_staging
like layoffs;

select * from layoffs_staging;

insert into layoffs_staging 
select * from layoffs;

-- Removing duplicates
With duplicate_cte as
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised) as row_num
 from layoffs_staging
 )
 select * from duplicate_cte
 where row_num > 1;
 
create table layoffs_staging2
like layoffs_staging;

Alter table layoffs_staging2
add row_num int;


insert into layoffs_staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised) as row_num
 from layoffs_staging;

select * from layoffs_staging2;

delete from layoffs_staging2
where row_num > 1;

-- Standardizing data
select *
from layoffs_staging2;

 update layoffs_staging2
 set company = trim(company);
 
update layoffs_staging2
set industry = 'Crypto'
where industry like "%Crypto%";

select distinct country
from layoffs_staging2;

Alter table layoffs_staging2
modify column date date;

select *
from layoffs_staging2
where industry = '';

update layoffs_staging2
set percentage_laid_off = null
where percentage_laid_off= '';

select *
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company and t1.location = t2.location
where t1.industry is null 
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;

delete
from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

alter table layoffs_staging2
drop column row_num;
 