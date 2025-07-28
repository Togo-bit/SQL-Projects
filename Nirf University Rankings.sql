-- 1)View all records
SELECT * FROM nirf;

-- 2)Get top 10 ranked universities
SELECT *
FROM nirf
ORDER BY ranking asc
LIMIT 10;

-- 3)List all distinct states represented
SELECT DISTINCT state
FROM nirf;

-- 4)Count universities per state
SELECT state, COUNT(name) as 'Total universities'
FROM nirf
GROUP BY state;

-- 5)Get average score of universities per state
SELECT state, AVG(Score) as average_score
FROM nirf
GROUP BY state
ORDER BY average_score;

-- 6)List universities in Delhi ranked under 50
SELECT * FROM nirf
WHERE state = 'Delhi' AND ranking < 50;

-- 7)State-wise top ranked university
SELECT state, name, state_wise_rank
FROM(SELECT state, ranking, name,
RANK() OVER(partition by state ORDER BY Score) as state_wise_rank
FROM nirf) x
WHERE x.state_wise_rank <= 3;

-- 8)Rank improvement/deterioration of a university
SELECT 
name,
MAX(ranking) as best_rank,
MIN(ranking) as worst_rank,
MAX(ranking) - MIN(ranking) as rank_change
FROM nirf
GROUP BY name
ORDER BY name;

-- 9)Performing inner join to obtain different columns
SELECT u.name, u.state, s.Score, s.ranking
FROM nirf u JOIN
nirf s ON u.name = s.name
ORDER BY s.Score;

SELECT * FROM nirf;

