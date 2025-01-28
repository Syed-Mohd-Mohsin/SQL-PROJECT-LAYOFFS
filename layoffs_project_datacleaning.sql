-- layoffs Project - Datacleaning

-- source - https://www.kaggle.com/datasets/swaptr/layoffs-2022

-- first thing is to do create a database and upload raw file to in it

CREATE DATABASE PROJECT_LAYOFFS;

-- Upload raw file though right click on table and then select 'table data import wizard'.


-- data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways

-- 1 Remove Duplicate....

-- make another table with same data as working table

CREATE TABLE layoffs
SELECT * 
FROM raw_layoffs;

SELECT * 
FROM layoffs;

-- lets check duplicate data is it or not

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as row_num
FROM layoffs
;

-- more than 1 row_num shows it has duplicate entry
-- lets remove it by using TEMP TABLE

CREATE TEMPORARY TABLE DUPES
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as row_num
FROM layoffs
;

SELECT *
FROM DUPES
WHERE ROW_NUM >1;

SELECT * 
FROM dupes
WHERE company = 'casper';

-- it has 5 dupes

DELETE 
FROM DUPES
WHERE row_num =2;

ALTER TABLE DUPES
DROP COLUMN row_num;

TRUNCATE layoffs;

INSERT INTO layoffs
SELECT * 
FROM dupes;

SELECT * 
FROM layoffs;

-- now all duplicate rows removed

-- 2 Standardize Data (check all columns)

SELECT DISTINCT company ,industry
FROM layoffs;

SELECT  * 
FROM layoffs
WHERE company LIKE 'Zymergen%';

UPDATE layoffs
SET COMPANY = 'Ada Support'
WHERE COMPANY = 'Ada'; -- change its name due to same industry

UPDATE layoffs
SET COMPANY = 'Clearco'
WHERE COMPANY = 'Clearbanc'; -- Clearbanc rebranded itself Clearco

UPDATE layoffs
SET COMPANY = 'Deliveroo'
WHERE COMPANY = 'Deliveroo Australia';

UPDATE layoffs
SET COMPANY = 'Impossible Foods'
WHERE COMPANY = 'Impossible Foods copy';

UPDATE layoffs
SET COMPANY = 'Lido Learning'
WHERE COMPANY = 'Lido';

UPDATE layoffs
SET COMPANY = 'SAP'
WHERE COMPANY = 'SAP Labs';

UPDATE layoffs
SET COMPANY = 'Starship'
WHERE COMPANY = 'Starship Technologies';

UPDATE layoffs
SET COMPANY = 'Stash Financial'
WHERE COMPANY = 'Stash';

UPDATE layoffs
SET COMPANY = 'TikTok India'
WHERE COMPANY = 'TikTok';

UPDATE layoffs
SET COMPANY = 'Uala'
WHERE COMPANY = 'UalÃ¡';

-- lets rid of extra space from company column

UPDATE layoffs
SET company = TRIM(company);

-- now check location and country

SELECT DISTINCT location,country 
FROM layoffs;

UPDATE layoffs
SET location = 'Florianopolis'
WHERE location ='FlorianÃ³polis';


SELECT * 
FROM layoffs
WHERE location='SF Bay Area';

UPDATE layoffs
SET location = 'Mahe'
WHERE company ='BitMEX';

UPDATE layoffs
SET location = 'Hangzhou'
WHERE company ='WeDoctor';

UPDATE layoffs
SET location = 'Dusseldorf'
WHERE location ='DÃ¼sseldorf';

UPDATE layoffs
SET location = 'Malmo'
WHERE location ='MalmÃ¶';

UPDATE layoffs
SET location = 'San Francisco Bay Area'
WHERE location ='SF Bay Area';

UPDATE layoffs
SET country = 'United States'
WHERE location = 'San Francisco Bay Area';

SELECT distinct country
FROM layoffs
ORDER BY 1 ASC;

UPDATE layoffs
SET country = TRIM(TRAILING '.' FROM country);


-- lets check industry
SELECT DISTINCT industry
FROM layoffs;

UPDATE layoffs
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs
SET industry = NULL
WHERE industry  ='';


-- lets convert `date` column into date from text datatype becs for time line analysis

UPDATE layoffs
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT *
FROM layoffs;

ALTER TABLE layoffs
MODIFY `date` date;

-- 3 Look at null values and see anything you can do

-- lets check null industry have any record of same company

SELECT T1.company, t1.industry, t2.industry
FROM layoffs AS t1
JOIN layoffs AS t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs AS t1
JOIN layoffs AS t2
	ON t1.company = t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- 4. remove any columns and rows that are not necessary

-- lets remove that row which have both null values in total_laid_off and percentage_laid_off

DELETE 
FROM layoffs
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- -- NOW OUR LAYOFFS TABLE CLEAN AND READY FOR ANALYSIS 

































