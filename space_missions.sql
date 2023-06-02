--- How many rocket launches occurred between 1957 - 2020

SELECT COUNT(id)
FROM rocket_data;

--- During which years did the most launches occur?

SELECT year,
	COUNT(*) as mission_count
FROM rocket_data
GROUP BY year
ORDER BY mission_count DESC;

--- How many rockets were launched from each country?

SELECT country, COUNT(*) as rockets_per_country
FROM rocket_data
GROUP BY country
ORDER BY rockets_per_country desc

--- How many successful, failed, partial failure, and prelaunch failures does each company have recorded?

SELECT
        company_name,
		COUNT(*) as launch_count,
        SUM(CASE WHEN status_mission = 'Success' THEN 1 ELSE 0 END) AS successful_launches,
        SUM(CASE WHEN status_mission = 'Failure' THEN 1 ELSE 0 END) AS failed_launches,
		SUM(CASE WHEN status_mission = 'Partial Failure' THEN 1 ELSE 0 END) AS partial_failure,
        SUM(CASE WHEN status_mission = 'Prelaunch Failure' THEN 1 ELSE 0 END) AS prelaunch_failure
    FROM
        rocket_data
    GROUP BY
		company_name
	ORDER BY 
		launch_count DESC
    
--- What are the top 10 companies with the most successful launches? What are their success rates?

SELECT
    company_name,
		string_agg(DISTINCT country, ', ') AS countries_launched_from,
    COUNT(*) AS total_launches,
    COUNT(CASE WHEN status_mission = 'Success' THEN 1 END) AS successful_launches,
    (COUNT(CASE WHEN status_mission = 'Success' THEN 1 END) * 100) / COUNT(*) AS success_rate
FROM
    rocket_data
GROUP BY
    company_name
ORDER BY
    successful_launches DESC
LIMIT 10;

--- What day of the week has the highest success rate? 

WITH launch_stats AS (
    SELECT 
        day_of_week,
        COUNT(*) as total_launches,
        COUNT(CASE WHEN status_mission = 'Success' THEN 1 END) as successful_launches,
        (COUNT(CASE WHEN status_mission = 'Success' THEN 1 END) * 100) / COUNT(*) AS success_rate
    FROM rocket_data
    GROUP BY day_of_week
)
SELECT 
    day_of_week,
    total_launches,
    successful_launches,
    success_rate
FROM launch_stats
ORDER BY 
  CASE 
    WHEN day_of_week = 'Sun' THEN 1
    WHEN day_of_week = 'Mon' THEN 2
    WHEN day_of_week = 'Tue' THEN 3
    WHEN day_of_week = 'Wed' THEN 4
    WHEN day_of_week = 'Thu' THEN 5
    WHEN day_of_week = 'Fri' THEN 6
    WHEN day_of_week = 'Sat' THEN 7
  END;

--- What day of the month has the highest success rate?

SELECT 
       day_of_month,
        COUNT(*) as total_launches,
        COUNT(CASE WHEN status_mission = 'Success' THEN 1 END) as successful_launches,
        (COUNT(CASE WHEN status_mission = 'Success' THEN 1 END) * 100) / COUNT(*) AS success_rate
FROM rocket_data
GROUP BY day_of_month
ORDER by day_of_month asc;

--- What are the top 10 companies with the most active rockets? 

WITH current_status AS (
SELECT
    company_name,
    SUM(CASE WHEN rocket_status = 'Active' THEN 1 ELSE 0 END) AS active_rockets,
    SUM(CASE WHEN rocket_status = 'Retired' THEN 1 ELSE 0 END) AS retired_rockets,
	COUNT(*) as rockets_launched
FROM
    rocket_data
GROUP BY
    company_name
ORDER BY active_rockets DESC
LIMIT 10)

SELECT company_name,
	active_rockets,
	retired_rockets,
	rockets_launched,
	(active_rockets*100)/rockets_launched as active_rocket_percentage
FROM current_status
ORDER BY active_rocket_percentage DESC;


