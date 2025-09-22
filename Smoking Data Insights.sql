-- Top Customers Smoking Insights
-- 1)Top 10 countries by total smokers
SELECT country, ROUND(AVG(daily_cigg), 2) as avg_daily_cigg
FROM smoking
GROUP BY country
ORDER BY avg_daily_cigg desc
LIMIT 10;

-- 2)Smoking trends by year/Country
WITH calculation (country, year, avg_smokers, prev_avg_smokers) as(
SELECT country, year, AVG(smokers_total),
LAG(AVG(smokers_total)) OVER(partition by country ORDER BY year)
FROM smoking
GROUP BY country, year
),
trend (country, year, growth) as(
SELECT country, year,
ROUND(((avg_smokers - prev_avg_smokers) * 100)/prev_avg_smokers, 2)
FROM calculation
GROUP BY country, year
)
SELECT *
FROM trend
WHERE year BETWEEN 2005 AND 2015;

-- 3)Gender breakdown of smoking
SELECT country, year,
ROUND((smokers_female * 100)/smokers_total, 2) as female_smokers,
ROUND((smokers_male * 100)/smokers_total, 2) as male_smokers
FROM smoking
WHERE country in ('Bahamas','India','Cameroon') AND
year BETWEEN 2004 AND 2006
GROUP BY country, year, female_smokers, male_smokers;

-- 4)Country wise contribution to global smokers
SELECT country, SUM(daily_cigg) as total_contribution
FROM smoking
GROUP BY country
ORDER BY total_contribution desc;

SELECT * FROM smoking;