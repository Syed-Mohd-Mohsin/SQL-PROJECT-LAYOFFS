-- Exploratory Data Analysis (EDA) of Project Layoffs

-- Here we are jsut going to explore the data and find trends or patterns or anything interesting like outliers

-- Let us now examine the companies that have implemented layoffs 100%, where percentage_laid_off is 1
SELECT *
FROM layoffs
WHERE  percentage_laid_off IS NOT NULL AND percentage_laid_off = 1 ;  -- 166 COMPANIES might be these are mostly startups it looks like who all went out of business during this time


-- Let us now examine the companies that have implemented layoffs exceeding 50%, where percentage_laid_off exceeding 0.5
SELECT *
FROM layoffs
WHERE  percentage_laid_off IS NOT NULL AND percentage_laid_off >= .5 ;  -- 221 COMPANIES might be about to closed



-- The top five companies that have implemented the highest number of layoffs reflect significant workforce reductions within their sectors.
SELECT company,industry,total_laid_off
FROM layoffs
ORDER BY 2 DESC
LIMIT 5;  
-- Google, Meta, Amazon, Microsoft, and Ericsson have all implemented significant workforce reductions. 



-- Let us now analyze which company did the highest number of layoffs.
SELECT company,SUM(total_laid_off)
FROM layoffs
GROUP BY company
ORDER BY 2 DESC
LIMIT 3;
-- Amazon, Google, and Meta have been among the companies with the highest levels of layoffs. These organizations have faced substantial workforce reductions, driven by 
-- various factors including economic conditions, restructuring efforts, and shifts in business strategies.



-- Let us now analyze which country experienced the highest number of layoffs. This examination will offer valuable 
-- insights into the geographic distribution of workforce reductions and help identify regions most affected by such trends.
SELECT country,SUM(total_laid_off)
FROM layoffs
GROUP BY country
ORDER BY 2 DESC
LIMIT 5;
-- The United States and India have emerged as the leading countries with the highest number of layoffs.



-- Let us now examine which year experienced the highest number of layoffs
SELECT DISTINCT SUBSTRING(`date`,1,7) AS `YEAR_MONTH`
FROM layoffs
WHERE  SUBSTRING(`date`,1,7) IS NOT NULL
ORDER BY 1;


SELECT YEAR(`date`),SUM(total_laid_off)
FROM layoffs
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY 1 DESC ;
-- As observed, the timeline of layoffs spans from April 2020 to March 2023. Notably, the year 2023 witnessed a significant surge in layoffs within a three-month period,
-- with figures surpassing those of other years during the same timeframe. This trend highlights an unusual concentration of workforce reductions in 2023 compared
-- to previous years




-- Let us now review the top five industries that have experienced the highest number of layoffs
SELECT industry,SUM(total_laid_off) AS sum_total_lail_off
FROM layoffs
WHERE YEAR(`date`) IS NOT NULL
GROUP BY industry
ORDER BY 2 DESC
LIMIT 5 ;



-- Let us now analyze the top three companies that have incurred the highest number of layoffs on an annual basis.
-- This examination will provide a clear understanding of the organizations most significantly impacted by workforce reductions, highlighting the underlying factors contributing to these trends.
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;



-- Let us now examine the top three industries that have experienced the largest number of layoffs on an annual basis.
WITH Company_Year AS 
(
  SELECT industry, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs
  GROUP BY industry, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT industry, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT industry, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;



-- The cumulative total of total_laid_off, denoted as 'rolling_total_layoffs' , represents the aggregate number of workforce reductions over a specified period
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY dates
ORDER BY dates ASC
)
SELECT *, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;

















































































