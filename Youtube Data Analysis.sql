-- TOP YOUTUBE CHANNEL DATASET ANALYSIS

-- Queries
-- 1
SELECT category, COUNT(subscribers) as total_subscribers
FROM youtube
GROUP BY category;

-- 2
SELECT country, AVG(subscribers) as average_subscribers
FROM youtube
GROUP BY country
ORDER BY average_subscribers DESC;

-- 3
SELECT *,
RANK() OVER(ORDER BY subscribers DESC) as rnk
FROM youtube;

-- 4
SELECT Name, subscribers, category, 
PERCENT_RANK() OVER(ORDER BY subscribers DESC)* 100 as contribution
FROM youtube;

-- 5
WITH  rank_channels as(
SELECT Name, subscribers, category,
RANK() OVER(partition by category ORDER BY subscribers DESC) as rnk
FROM youtube
)
SELECT *
FROM rank_channels
WHERE rnk <= 3;

-- 6
WITH brandsubs as(
SELECT brand_channel, SUM(subscribers) as total_subscribers
FROM youtube
GROUP BY brand_channel
)
SELECT * FROM brandsubs;

-- 7
SELECT Name, subscribers, category,
SUM(subscribers) OVER(ORDER BY subscribers DESC) as rnk
FROM youtube;

-- 8
SELECT Name, subscribers, category, country,
NTILE(4) OVER(partition by category ORDER BY subscribers DESC) as buckets
FROM youtube;


SELECT * FROM youtube;
