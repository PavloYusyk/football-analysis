SELECT 
	m.match_api_id AS match_id
	, m.season AS season
	, to_date(m.date, 'YYYY-MM-DD') AS match_date
	, l.id AS league_id
	, l."name" AS league_name
	, m.home_team_api_id AS home_team_id
	, th.team_long_name AS home_team_name	
	, m.home_team_goal AS home_goals
	, m.away_team_api_id AS away_team_id
	, ta.team_long_name AS away_team_name
	, m.away_team_goal AS away_goals
	, (m.home_team_goal + m.away_team_goal) AS total_goals
	, CASE 
		WHEN m.home_team_goal > m.away_team_goal THEN 'home_win'
		WHEN m.home_team_goal < m.away_team_goal THEN 'away_win'
		ELSE 'draw'
	END AS result
FROM "match" m 
JOIN league l 
	ON m.league_id = l.id
JOIN team th 
	ON th.team_api_id = m.home_team_api_id 		
JOIN team ta 
	ON ta.team_api_id = m.away_team_api_id 	
