SELECT 
	p.player_api_id  AS player_id
	, p.player_name
	, p.height 
	, p.weight
	, MAX(preferred_foot) AS preferred_foot
	, MAX(pa.overall_rating) AS max_overall_rating
	, AVG(pa.overall_rating ) AS avg_overall_rating
	, MAX(pa.sprint_speed) AS max_sprint_speed
	, MAX(pa.finishing ) AS max_finishing
FROM player p 
JOIN player_attributes pa 
	ON p.player_api_id  = pa.player_api_id 
GROUP BY p.player_api_id 
	, p.player_name
	, p.height 
	, p.weight