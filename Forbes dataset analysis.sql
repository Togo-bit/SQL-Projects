-- Forbes Dataset Analysis
-- A)Data cleaning queries
-- 1)Converintg net_worth from strings to queries
ALTER TABLE forbes
ADD COLUMN net_worth_num decimal(20,2);

UPDATE forbes
SET net_worth_num =
CASE WHEN RIGHT(net_worth, 1) = 'B'
	THEN CAST(REPLACE(REPLACE(net_worth, '$', ''), 'B', '') AS DECIMAL) * 1000000000
	WHEN RIGHT(net_worth, 1) = 'M'
    THEN CAST(REPLACE(REPLACE(net_worth, '$', ''), 'M', '') AS DECIMAL) * 1000000
    ELSE NULL
END;

-- 2)Extracting numericals from change and percentage_change
SELECT REPLACE(percentage_change, '%', '') as per_chan_num,
CASE WHEN RIGHT('change', 1) = 'B'
	THEN CAST(REPLACE(REPLACE('change', '$', ''), 'B', '') AS DECIMAL)
    WHEN RIGHT('change', 1) = 'M'
    THEN CAST(REPLACE(REPLACE('change', '$', ''), 'M', '') AS DECIMAL)
    ELSE NULL
END AS change_num
FROM forbes;

-- B)Basic Analysis
-- 1)Top 10 richest persons globally
SELECT Name, net_worth, country, net_worth_num
FROM forbes
ORDER BY net_worth_num desc
LIMIT 10;

-- 2)Billionairs per country
SELECT country, COUNT(*) as total
FROM forbes
GROUP BY country;

-- 3)Average age of billionairs in each country
SELECT country, AVG(Age) as average_age
FROM forbes
GROUP BY country
ORDER BY average_age desc;

-- C)Intermediate analysis
-- 1)Use CTEs to find billionaires above the average net worth globally.
WITH averages (avg_net_worth) as(
SELECT AVG(net_worth_num)
FROM forbes
)
SELECT Name, net_worth, country
FROM forbes
WHERE net_worth_num > (SELECT avg_net_worth
FROM averages);

-- 2)Find countries where average net worth > global average.
WITH country_average (country, average_net_worth) as(
SELECT country, AVG(net_worth_num)
FROM forbes
GROUP BY country
),
global_average (average_glo_worth) as(
SELECT AVG(net_worth_num)
FROM forbes
)
SELECT *
FROM country_average
WHERE average_net_worth > (SELECT average_glo_worth
FROM global_average);

-- 3)Rank billionaires within their country by wealth using RANK().
SELECT *,
RANK() OVER(partition by country ORDER BY net_worth_num desc) as rnk
FROM forbes;

-- D)Advanced analysis
-- 1)Billionairs who are richest in their countries
SELECT Name, net_worth, country
FROM forbes f1
WHERE net_worth_num = (SELECT MAX(net_worth_num)
FROM forbes f2
WHERE f1.country = f2.country);

-- 2)Find billionaires from the same country & industry
SELECT f1.Name, f2.Name, f1.country, f2.Source
FROM forbes f1 JOIN
forbes f2 ON f1.country = f2.country
WHERE f1.country = f2.country
AND f1.Source = f2.Source
AND f1.Name != f2.Name;

-- 3)Rank countries by total billionaire wealth.
SELECT Name, net_worth, country,
DENSE_RANK() OVER(partition by country ORDER BY net_worth_num desc) as rnk
FROM forbes;

SELECT * FROM forbes;

