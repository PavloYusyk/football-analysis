WITH match_info AS (
	SELECT 
		t.team_api_id AS team_id
		, m.match_api_id AS match_id
		, m.away_team_goal AS scored_goals
		, m.home_team_goal AS conceded_goals 
	FROM team t 
	JOIN "match" m 
		ON t.team_api_id = m.away_team_api_id 
	
	UNION ALL 
		
	SELECT 
		t.team_api_id AS team_id
		, m.match_api_id AS match_id
		, m.home_team_goal AS scored_goals
		, m.away_team_goal AS conceded_goals 
	FROM team t 
	JOIN "match" m 
		ON t.team_api_id = m.home_team_api_id 
) SELECT 
	t.team_api_id AS team_id
	, t.team_long_name AS team_name
	, count(DISTINCT mi.match_id) AS total_matches
	, SUM(CASE WHEN mi.scored_goals  > mi.conceded_goals  THEN 1 END ) AS wins
	, SUM(CASE WHEN mi.scored_goals  < mi.conceded_goals  THEN 1 END ) AS losses
	, SUM(CASE WHEN mi.scored_goals  = mi.conceded_goals  THEN 1 END ) AS draws
	, SUM(mi.scored_goals ) AS goals_scored
	, SUM(mi.conceded_goals ) AS goals_conceded
	, SUM(mi.scored_goals ) - SUM(mi.conceded_goals ) AS goal_difference
	, round(SUM(CASE WHEN mi.scored_goals  > mi.conceded_goals  THEN 1 END) * 100.0 / count(DISTINCT mi.match_id), 2) AS win_percentage
FROM team t 
JOIN match_info mi
	ON t.team_api_id  = mi.team_id
GROUP BY t.team_api_id, t.team_long_name