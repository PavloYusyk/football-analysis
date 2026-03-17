/* =====================================================
   01_exploration.sql
   Basic exploration of the European Soccer dataset
   ===================================================== */

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

/* -----------------------------------------------------
   Завдання 1
   Порахувати кількість рядків у основних таблицях:
   - match
   - league
   - team
   - player
   - player_attributes
   - team_attributes
----------------------------------------------------- */
SELECT count(*) AS total_matches FROM "match" m; 
SELECT count(*) AS total_leagues FROM league l;
SELECT count(*) AS total_teams FROM team t;
SELECT count(*) AS total_players FROM player p;
SELECT count(*) AS total_player_attributes FROM player_attributes pa;
SELECT count(*) AS total_team_attributes FROM team_attributes ta;

/* -----------------------------------------------------
   Завдання 2
   Вивести всі унікальні сезони з таблиці "match".
   Результат відсортувати від старих до нових.
----------------------------------------------------- */
SELECT 
	DISTINCT m.season 
FROM "match" m 
ORDER BY m.season;

/* -----------------------------------------------------
   Завдання 3
   Визначити часовий діапазон дат у датасеті:
   - найраніша дата матчу
   - найпізніша дата матчу
----------------------------------------------------- */
SELECT
	MIN(m."date") AS first_match
	, MAX(m."date") AS last_match
FROM "match" m 

/* -----------------------------------------------------
   Завдання 4
   Порахувати середню кількість голів за матч
   у всьому датасеті.

   Формула:
   home_team_goal + away_team_goal
----------------------------------------------------- */
SELECT 
	round(AVG(m.away_team_goal + m.home_team_goal), 2) AS avg_goals
FROM "match" m 

/* -----------------------------------------------------
   Завдання 5
   Порахувати розподіл результатів матчів:
   - home_wins
   - away_wins
   - draws
----------------------------------------------------- */
SELECT 
	SUM(CASE WHEN m.away_team_goal > m.home_team_goal THEN 1 END) AS away_wins
	, SUM(CASE WHEN m.away_team_goal < m.home_team_goal THEN 1 END) AS home_wins
	, SUM(CASE WHEN m.away_team_goal = m.home_team_goal THEN 1 END) AS draws
FROM "match" m 

/* -----------------------------------------------------
   Завдання 6
   Порахувати відсоток результатів матчів:
   - home_wins_pct
   - away_wins_pct
   - draws_pct
----------------------------------------------------- */
SELECT 
	round((SUM(CASE WHEN m.away_team_goal > m.home_team_goal THEN 1 END) * 100.0 / count(*)), 2) AS away_wins_pct
	, round((SUM(CASE WHEN m.away_team_goal < m.home_team_goal THEN 1 END) * 100.0 / count(*)), 2) AS home_wins_pct
	, round((SUM(CASE WHEN m.away_team_goal = m.home_team_goal THEN 1 END) * 100.0 / count(*)), 2) AS draws_pct
FROM "match" m 

/* -----------------------------------------------------
   Завдання 7
   Визначити кількість матчів у кожній лізі.

   Потрібно використати JOIN таблиць:
   match + league

   Результат:
   league_name
   total_matches

   Відсортувати від найбільшої кількості матчів.
----------------------------------------------------- */
SELECT 
	l."name" AS league_name
	, count(m.match_api_id) AS total_matches 
FROM "match" m 
JOIN  league l 
	ON l.id = m.league_id 
GROUP BY l."name" 
ORDER BY total_matches DESC 

/* -----------------------------------------------------
   Завдання 8
   Визначити середню результативність у кожній лізі.

   Формула:
   AVG(home_team_goal + away_team_goal)

   Результат:
   league_name
   avg_goals_per_match
----------------------------------------------------- */
SELECT 
	l."name" AS league_name
	, round(AVG(m.away_team_goal + m.home_team_goal),2) AS avg_goal_per_match
FROM "match" m 
JOIN  league l 
	ON l.id = m.league_id 
GROUP BY l."name" 
ORDER BY avg_goal_per_match DESC 

/* -----------------------------------------------------
   Завдання 9
   Порахувати результативність по сезонах.

   Результат:
   season
   total_matches
   avg_goals_per_match
----------------------------------------------------- */
SELECT 
	m.season 
	, count(m.match_api_id ) AS total_matches
	, round(AVG(m.away_team_goal + m.home_team_goal),2) AS avg_goal_per_match
FROM "match" m 
GROUP BY m.season
ORDER BY m.season 



/* -----------------------------------------------------
   Завдання 10
   Перевірити наявність NULL значень у ключових полях
   таблиці "match":
   - season
   - date
   - league_id
   - home_team_api_id
   - away_team_api_id
   - home_team_goal
   - away_team_goal
----------------------------------------------------- */
SELECT count(*) FROM "match" m WHERE m.season IS NULL;
SELECT count(*) FROM "match" m WHERE m."date" IS NULL;
SELECT count(*) FROM "match" m WHERE m.league_id IS NULL;
SELECT count(*) FROM "match" m WHERE m.home_team_api_id IS NULL;
SELECT count(*) FROM "match" m WHERE m.away_team_api_id IS NULL;
SELECT count(*) FROM "match" m WHERE m.home_team_goal IS NULL;
SELECT count(*) FROM "match" m WHERE m.away_team_goal IS NULL;





