/* =====================================================
   03_league_analysis.sql
   League performance analysis
   ===================================================== */


/* -----------------------------------------------------
   Завдання 1
   Порахувати загальну кількість матчів у кожній лізі.

   Результат:
   league_name
   total_matches

   Відсортувати від найбільшої кількості матчів.
----------------------------------------------------- */
SELECT 
	l."name" AS league_name
	, count(*) AS total_matches
FROM "match" m
JOIN league l 
	ON m.league_id = l.id 
GROUP BY l."name" 
ORDER BY total_matches DESC, league_name  

/* -----------------------------------------------------
   Завдання 2
   Порахувати середню кількість голів за матч
   у кожній лізі.

   Формула:
   AVG(home_team_goal + away_team_goal)

   Результат:
   league_name
   avg_goals_per_match

   Відсортувати від найбільш результативної ліги.
----------------------------------------------------- */
SELECT 
	l."name" AS league_name
	, round(AVG(m.home_team_goal + m.away_team_goal), 2) AS avg_goals_per_match
FROM "match" m 
JOIN league l 
	ON  m.league_id = l.id 
GROUP BY l."name" 
ORDER BY avg_goals_per_match DESC, league_name 

/* -----------------------------------------------------
   Завдання 3
   Порахувати загальну кількість голів
   у кожній лізі.

   Формула:
   SUM(home_team_goal + away_team_goal)

   Результат:
   league_name
   total_goals
----------------------------------------------------- */
SELECT 
	l."name" AS league_name
	, SUM(m.home_team_goal + m.away_team_goal) AS total_goals
FROM "match" m 
JOIN league l 
	ON  m.league_id = l.id 
GROUP BY l."name" 
ORDER BY total_goals DESC, league_name 

/* -----------------------------------------------------
   Завдання 4
   Порахувати середню кількість домашніх голів
   у кожній лізі.

   Результат:
   league_name
   avg_home_goals
----------------------------------------------------- */
SELECT 
	l."name" AS league_name
	, round(AVG(m.home_team_goal), 2) AS avg_home_goals
FROM "match" m 
JOIN league l 
	ON  m.league_id = l.id 
GROUP BY l."name" 
ORDER BY avg_home_goals DESC, league_name 

/* -----------------------------------------------------
   Завдання 5
   Порахувати середню кількість виїзних голів
   у кожній лізі.

   Результат:
   league_name
   avg_away_goals
----------------------------------------------------- */
SELECT 
	l."name" AS league_name
	, round(AVG(m.away_team_goal), 2) AS avg_away_goals
FROM "match" m 
JOIN league l 
	ON  m.league_id = l.id 
GROUP BY l."name" 
ORDER BY avg_away_goals DESC, league_name 


/* -----------------------------------------------------
   Завдання 6
   Порахувати розподіл результатів матчів
   у кожній лізі:
   - home_wins
   - away_wins
   - draws

   Результат:
   league_name
   home_wins
   away_wins
   draws
----------------------------------------------------- */
SELECT 
	l."name" AS league_name
	, count(*) total_matches
	, SUM(CASE WHEN m.home_team_goal > m.away_team_goal THEN 1 END) AS home_wins
	, SUM(CASE WHEN m.home_team_goal < m.away_team_goal THEN 1 END) AS away_wins
	, SUM(CASE WHEN m.home_team_goal = m.away_team_goal THEN 1 END) AS draws
FROM "match" m 
JOIN league l 
	ON  m.league_id = l.id 
GROUP BY l."name" 
ORDER BY league_name 

/* -----------------------------------------------------
   Завдання 7
   Порахувати відсоток домашніх перемог,
   виїзних перемог і нічиїх у кожній лізі.

   Результат:
   league_name
   home_win_pct
   away_win_pct
   draw_pct
----------------------------------------------------- */
SELECT 
	l."name" AS league_name
	, count(*) total_matches
	, round(SUM(CASE WHEN m.home_team_goal > m.away_team_goal THEN 1 END) * 100.0 / count(*), 2) AS home_wins_pct
	, round(SUM(CASE WHEN m.home_team_goal < m.away_team_goal THEN 1 END) * 100.0 / count(*), 2) AS away_wins_pct
	, round(SUM(CASE WHEN m.home_team_goal = m.away_team_goal THEN 1 END) * 100.0 / count(*), 2) AS draws_pct
FROM "match" m 
JOIN league l 
	ON  m.league_id = l.id 
GROUP BY l."name" 
ORDER BY league_name 

/* -----------------------------------------------------
   Завдання 8
   Порахувати результативність по сезонах
   у розрізі ліг.

   Результат:
   league_name
   season
   total_matches
   avg_goals_per_match
----------------------------------------------------- */
SELECT 
	l."name" AS league_name
	, m.season 
	, count(*) total_matches
	, round(AVG(m.home_team_goal + m.away_team_goal), 2) AS avg_goals_per_match
FROM "match" m 
JOIN league l 
	ON  m.league_id = l.id 
GROUP BY
	l."name" 
	, m.season 
ORDER BY league_name, m.season 

/* -----------------------------------------------------
   Завдання 9
   Знайти найрезультативніший сезон
   для кожної ліги.

   Результат:
   league_name
   season
   avg_goals_per_match
----------------------------------------------------- */
WITH avg_pre_season AS (
	SELECT 
		l."name" AS league_name
		, m.season AS season 
		, round(AVG(m.home_team_goal + m.away_team_goal), 2) AS avg_goals_per_match
	FROM "match" m 
	JOIN league l 
		ON  m.league_id = l.id 
	GROUP BY
		l."name" 
		, m.season 
), top_one AS (
	SELECT 
		league_name
		, season
		, avg_goals_per_match 
		, row_number() OVER (PARTITION BY league_name ORDER BY avg_goals_per_match DESC) AS rn
	FROM avg_pre_season 
)
SELECT 
	league_name 
	, season 
	, avg_goals_per_match 
FROM top_one 
WHERE rn = 1
ORDER BY season, avg_goals_per_match DESC 


/* -----------------------------------------------------
   Завдання 10
   Визначити ліги з найбільшою перевагою
   домашнього поля.

   Метрика:
   home_win_pct

   Результат:
   league_name
   home_win_pct

   Відсортувати від найбільшого значення.
----------------------------------------------------- */
WITH home_wins AS (
	SELECT 
		l."name" AS league_name
		, round(SUM(CASE WHEN m.home_team_goal > m.away_team_goal THEN 1 END) * 100.0 / count(*), 2) AS home_wins_pct
	FROM "match" m 
	JOIN league l 
		ON  m.league_id = l.id 
	GROUP BY l."name" 
)
SELECT 
	row_number() OVER (ORDER BY home_wins_pct DESC) AS rating
	, league_name 
	, home_wins_pct
FROM home_wins