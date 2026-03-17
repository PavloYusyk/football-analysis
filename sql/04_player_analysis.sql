/* =====================================================
   04_player_analysis.sql
   Player performance analysis
   ===================================================== */
SELECT *
FROM player p 
LIMIT 5

/* -----------------------------------------------------
   Завдання 1
   Порахувати загальну кількість гравців
   у датасеті.

   Результат:
   total_players
----------------------------------------------------- */
SELECT 
	count(*) AS total_players
FROM player p 

/* -----------------------------------------------------
   Завдання 2
   Визначити мінімальний, максимальний
   та середній зріст гравців.

   Результат:
   min_height
   max_height
   avg_height
----------------------------------------------------- */
SELECT 
	MIN(p.height ) AS min_height
	, MAX(p.height ) AS max_height
	, AVG(p.height ) AS avg_height
FROM player p 

/* -----------------------------------------------------
   Завдання 3
   Визначити мінімальну, максимальну
   та середню вагу гравців.

   Результат:
   min_weight
   max_weight
   avg_weight
----------------------------------------------------- */	
SELECT 
	MIN(p.weight ) AS min_weight
	, MAX(p.weight ) AS max_weight
	, AVG(p.weight ) AS avg_weight
FROM player p 

/* -----------------------------------------------------
   Завдання 4
   Порахувати кількість гравців
   для кожної домінуючої ноги.

   Колонка:
   preferred_foot

   Результат:
   preferred_foot
   total_players
----------------------------------------------------- */
SELECT
    preferred_foot,
    COUNT(DISTINCT player_api_id) AS total_players
FROM player_attributes
GROUP BY preferred_foot;

/* -----------------------------------------------------
   Завдання 5
   Визначити середній рейтинг гравців.

   Колонка:
   overall_rating

   Результат:
   avg_player_rating
----------------------------------------------------- */
WITH avg_player AS (
	SELECT 
		pa.player_api_id 
		, AVG(pa.overall_rating) AS avg_per_player
	FROM player_attributes pa
	GROUP BY pa.player_api_id 
)
SELECT 
	AVG(avg_per_player) AS avg_player_rating
FROM avg_player

/* -----------------------------------------------------
   Завдання 6
   Знайти топ-10 гравців
   за максимальним overall_rating.

   Таблиці:
   player
   player_attributes

   Результат:
   player_name
   max_rating
----------------------------------------------------- */
WITH max_rating_per_player AS (
	SELECT 
	    p.player_name 
		, MAX(pa.overall_rating) AS max_rating
	FROM player p 
	JOIN player_attributes pa 
		ON p.player_api_id = pa.player_api_id 
	GROUP BY p.player_name
)
SELECT 
	player_name
	, max_rating
FROM max_rating_per_player
order BY max_rating DESC, player_name
LIMIT 10	

/* -----------------------------------------------------
   Завдання 7
   Визначити середній рейтинг гравців
   залежно від домінуючої ноги.

   Результат:
   preferred_foot
   avg_rating
----------------------------------------------------- */
WITH foot_and_avg_player AS (
	SELECT 
		pa.player_api_id 
		, pa.preferred_foot 
		, AVG(pa.overall_rating ) AS avg_per_player
	FROM player_attributes pa 
	GROUP BY pa.player_api_id, pa.preferred_foot 
)
SELECT 
	preferred_foot
	, AVG(avg_per_player) AS avg_rating
FROM foot_and_avg_player
WHERE preferred_foot IS NOT null
GROUP BY preferred_foot 

/* -----------------------------------------------------
   Завдання 8
   Порахувати кількість гравців
   у різних діапазонах зросту.

   Діапазони:
   - до 170
   - 170–180
   - 180–190
   - понад 190

   Результат:
   height_range
   total_players
----------------------------------------------------- */
WITH sort_hight AS (
	SELECT 
		p.player_api_id 
		, CASE 
			WHEN p.height < 170 THEN '170 lower'
			WHEN p.height BETWEEN 170 AND 180 THEN '170 to 180'
			WHEN p.height BETWEEN 180 AND 190 THEN '180 to 190'
			ELSE '190 more'
		END AS category_height
	FROM player p 
)
SELECT 
	category_height AS height_range
	, count(*) AS  total_players
FROM sort_hight 
GROUP BY category_height
ORDER BY height_range 

/* -----------------------------------------------------
   Завдання 9
   Знайти гравців,
   у яких максимальна швидкість sprint_speed
   більша за 90.

   Результат:
   player_name
   max_sprint_speed
----------------------------------------------------- */

SELECT 
	p.player_name 
	, max(pa.sprint_speed) AS max_sprint_speed
FROM player_attributes pa
JOIN player p 
	ON p.player_api_id = pa.player_api_id
GROUP BY p.player_name
HAVING max(pa.sprint_speed) > 90
ORDER BY max_sprint_speed DESC 

/* -----------------------------------------------------
   Завдання 10
   Знайти топ-10 гравців
   з найкращим показником finishing.

   Результат:
   player_name
   max_finishing
----------------------------------------------------- */
SELECT 
	p.player_name 
	, max(pa.finishing) AS max_finishing
FROM player_attributes pa
JOIN player p 
	ON p.player_api_id = pa.player_api_id
GROUP BY p.player_name
ORDER BY max_finishing DESC 
LIMIT 10



