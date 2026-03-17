/* =====================================================
   02_team_analysis.sql
   Team performance analysis
   ===================================================== */

/* -----------------------------------------------------
   Завдання 1
   Порахувати кількість матчів для кожної команди
   (врахувати і домашні, і виїзні матчі).

   Результат:
   team_name
   total_matches
----------------------------------------------------- */
WITH team_in_match as(
	SELECT 
		m.away_team_api_id AS team_id
	FROM "match" m 
	
	UNION ALL
	
	SELECT 
		m.home_team_api_id AS team_id
	FROM "match" m
)
SELECT 
	t.team_long_name 
	, count(*) AS total_matches
FROM team_in_match tm
JOIN team t 
	ON tm.team_id = t.team_api_id  
GROUP BY t.team_long_name 
	
/* -----------------------------------------------------
   Завдання 2
   Порахувати загальну кількість голів, забитих
   кожною командою (врахувати і домашні, і виїзні матчі).

   Результат:
   team_name
   total_goals_scored
----------------------------------------------------- */
WITH team_in_match as(
	SELECT 
		m.away_team_api_id AS team_id
		, m.away_team_goal AS team_goals
	FROM "match" m 
	
	UNION ALL
	
	SELECT 
		m.home_team_api_id AS team_id
		, m.home_team_goal AS team_goals
	FROM "match" m
)
SELECT 
	t.team_long_name 
	, sum(tm.team_goals) AS total_goals
FROM team_in_match tm
JOIN team t 
	ON tm.team_id = t.team_api_id  
GROUP BY t.team_long_name 

/* -----------------------------------------------------
   Завдання 3
   Порахувати середню кількість голів,
   які команда забиває за матч.

   Результат:
   team_name
   avg_goals_per_match

   Відсортувати від найбільш результативних команд.
----------------------------------------------------- */
WITH team_in_match as(
	SELECT 
		m.away_team_api_id AS team_id
		, m.away_team_goal AS team_goals
	FROM "match" m 
	
	UNION ALL
	
	SELECT 
		m.home_team_api_id AS team_id
		, m.home_team_goal AS team_goals
	FROM "match" m
)
SELECT 
	t.team_long_name 
	, round(AVG(tm.team_goals), 2) AS avg_goals_per_match
FROM team_in_match tm
JOIN team t 
	ON tm.team_id = t.team_api_id  
GROUP BY t.team_long_name 
ORDER BY avg_goals_per_match DESC 

/* -----------------------------------------------------
   Завдання 4
   Порахувати кількість пропущених голів
   для кожної команди.

   Результат:
   team_name
   total_goals_conceded
----------------------------------------------------- */
WITH team_in_match as(
	SELECT 
		m.away_team_api_id AS team_id
		, m.home_team_goal AS team_conceded_goals
	FROM "match" m 
	
	UNION ALL
	
	SELECT 
		m.home_team_api_id AS team_id
		, m.away_team_goal AS team_conceded_goals
	FROM "match" m
)
SELECT 
	t.team_long_name 
	, sum(tm.team_conceded_goals) AS total_goals_conceded
FROM team_in_match tm
JOIN team t 
	ON tm.team_id = t.team_api_id  
GROUP BY t.team_long_name 
ORDER BY total_goals_conceded DESC 

/* -----------------------------------------------------
   Завдання 5
   Порахувати різницю голів для кожної команди.

   Формула:
   goals_scored - goals_conceded

   Результат:
   team_name
   goal_difference
----------------------------------------------------- */
WITH team_in_match as(
	SELECT 
		m.away_team_api_id AS team_id
		, m.away_team_goal AS scored_goals
		, m.home_team_goal AS conceded_goals
	FROM "match" m 
	
	UNION ALL
	
	SELECT 
		m.home_team_api_id AS team_id
		, m.home_team_goal AS scored_goals
		, m.away_team_goal AS conceded_goals
	FROM "match" m
)
SELECT 
	t.team_long_name 
	, (sum(tm.scored_goals) - sum(tm.conceded_goals)) AS  goal_difference
FROM team_in_match tm
JOIN team t 
	ON tm.team_id = t.team_api_id  
GROUP BY t.team_long_name 
ORDER BY goal_difference DESC 

/* -----------------------------------------------------
   Завдання 6
   Порахувати кількість перемог для кожної команди
   (врахувати домашні і виїзні перемоги).

   Результат:
   team_name
   total_wins
----------------------------------------------------- */
WITH team_in_match as(
	SELECT 
		m.away_team_api_id AS team_id
		, CASE WHEN m.away_team_goal > m.home_team_goal THEN 1 END AS win
	FROM "match" m 
	
	UNION ALL
	
	SELECT 
		m.home_team_api_id AS team_id
		, CASE WHEN m.away_team_goal < m.home_team_goal THEN 1 END AS win
	FROM "match" m
)
SELECT 
	t.team_long_name 
	, sum(tm.win) AS total_wins
FROM team_in_match tm
JOIN team t 
	ON tm.team_id = t.team_api_id  
GROUP BY t.team_long_name 
ORDER BY total_wins DESC 

/* -----------------------------------------------------
   Завдання 7
   Порахувати кількість поразок для кожної команди.

   Результат:
   team_name
   total_losses
----------------------------------------------------- */
WITH team_in_match as(
	SELECT 
		m.away_team_api_id AS team_id
		, CASE WHEN m.away_team_goal < m.home_team_goal THEN 1 END AS loss
	FROM "match" m 
	
	UNION ALL
	
	SELECT 
		m.home_team_api_id AS team_id
		, CASE WHEN m.away_team_goal > m.home_team_goal THEN 1 END AS loss
	FROM "match" m
)
SELECT 
	t.team_long_name 
	, sum(tm.loss) AS total_losses
FROM team_in_match tm
JOIN team t 
	ON tm.team_id = t.team_api_id  
GROUP BY t.team_long_name 
ORDER BY total_losses DESC 

/* -----------------------------------------------------
   Завдання 8
   Порахувати кількість нічиїх для кожної команди.

   Результат:
   team_name
   total_draws
----------------------------------------------------- */
WITH team_in_match as(
	SELECT 
		m.away_team_api_id AS team_id
		, m.away_team_goal AS scored_goals
		, m.home_team_goal AS conceded_goals
	FROM "match" m 
	
	UNION ALL
	
	SELECT 
		m.home_team_api_id AS team_id
		, m.home_team_goal AS scored_goals
		, m.away_team_goal AS conceded_goals
	FROM "match" m
)
SELECT 
	t.team_long_name 
	, SUM(CASE WHEN tm.scored_goals = tm.conceded_goals THEN 1 END) AS total_draws 
FROM team_in_match tm
JOIN team t 
	ON tm.team_id = t.team_api_id  
GROUP BY t.team_long_name 
ORDER BY total_draws DESC 

/* -----------------------------------------------------
   Завдання 9
   Порахувати відсоток перемог для кожної команди.

   Формула:
   wins / total_matches * 100

   Результат:
   team_name
   win_percentage
----------------------------------------------------- */
WITH team_in_match as(
	SELECT 
		m.away_team_api_id AS team_id
		, CASE WHEN m.away_team_goal > m.home_team_goal THEN 1 END AS win
	FROM "match" m 
	
	UNION ALL
	
	SELECT 
		m.home_team_api_id AS team_id
		, CASE WHEN m.away_team_goal < m.home_team_goal THEN 1 END AS win
	FROM "match" m
)
SELECT 
	t.team_long_name 
	, round(sum(tm.win) * 100.0 / count(*), 2) AS win_percentage
FROM team_in_match tm
JOIN team t 
	ON tm.team_id = t.team_api_id  
GROUP BY t.team_long_name 
ORDER BY win_percentage DESC 

/* -----------------------------------------------------
   Завдання 10
   Знайти топ-10 команд за середньою кількістю
   забитих голів за матч.

   Результат:
   team_name
   avg_goals_per_match
----------------------------------------------------- */
WITH team_in_match as(
	SELECT 
		m.away_team_api_id AS team_id
		, m.away_team_goal AS team_goals
	FROM "match" m 
	
	UNION ALL
	
	SELECT 
		m.home_team_api_id AS team_id
		, m.home_team_goal AS team_goals
	FROM "match" m
)
SELECT 
	t.team_long_name 
	, round(AVG(tm.team_goals), 2) AS avg_goals_per_match
FROM team_in_match tm
JOIN team t 
	ON tm.team_id = t.team_api_id  
GROUP BY t.team_long_name 
ORDER BY avg_goals_per_match DESC 
LIMIT 10