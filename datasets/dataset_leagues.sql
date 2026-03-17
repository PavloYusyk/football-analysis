
SELECT 
	l.id AS league_id
	, l."name" AS league_name
	, count(m.match_api_id) AS total_matches
	, SUM(m.away_team_goal) + SUM(m.home_team_goal) AS total_goals
	, round(AVG(m.home_team_goal + m.away_team_goal), 2) AS avg_goals_per_match
	, SUM(CASE WHEN m.home_team_goal > m.away_team_goal THEN 1 END) AS home_wins
	, SUM(CASE WHEN m.home_team_goal < m.away_team_goal THEN 1 END) AS away_wins
	, SUM(CASE WHEN m.home_team_goal = m.away_team_goal THEN 1 END) AS draws
	, round(SUM(CASE WHEN m.home_team_goal > m.away_team_goal THEN 1 END) * 100.0 / count(m.match_api_id), 2) AS home_win_pct
	, round(SUM(CASE WHEN m.home_team_goal < m.away_team_goal THEN 1 END) * 100.0 / count(m.match_api_id), 2)  AS away_win_pct
	, round(SUM(CASE WHEN m.home_team_goal = m.away_team_goal THEN 1 END) * 100.0 / count(m.match_api_id), 2)  AS draw_pct
FROM league l 
JOIN "match" m 
	ON l.id = m.league_id
GROUP BY l.id, l."name"