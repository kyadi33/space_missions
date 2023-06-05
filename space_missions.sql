-- How many rocket launches occurred between 1957 - 2020

SELECT COUNT(id) as launch_count
FROM rocket_data;

--  Results:

launch_count |
-------------+
4324	     


-- During which years did the most launches occur?

SELECT year,
       COUNT(*) as mission_count
FROM rocket_data
GROUP BY year
ORDER BY mission_count DESC
LIMIT 10;

year | mission_count
---------------------+
1971 |	 119
2018 |	 117
1977 | 	 114
1976 |	 113
1975 | 	 113
2019 |   109
1970 |	 107
1967 | 	 106
1969 |   103
1973 | 	 103

-- How many rockets were launched from each country?
/*
note: this is where the rockets have been launched from, but the companies that are conducting these launches 
may be from other countries ex. USSR being Russian owned, but launching in Kazakhstan, or Arianespace 
being a French company launching in Kazakhstan as well (company collaboration). 
*/ 

SELECT country, COUNT(*) as rockets_launched
FROM rocket_data
GROUP BY country
ORDER BY rockets_launched desc;

--  Results:

country 	| rockets_launched
--------------------------------------+
Russia		| 1398			
USA		| 1385		
Kazakhstan 	| 701
France		| 303
China		| 269
Japan		| 126
India		| 76
Iran		| 14
New Zealand	| 13
Israel		| 11
Kenya		| 9
Australia	| 6
North Korea	| 5
South Korea	| 3
Brazil		| 3
Spain		| 2


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
LIMIT 10;

--  Results:

company_name		| launch_count  | successful_launches | failed_launches | partial_failure | prelaunch_failure |
----------------------------------------------------------------------------------------------------------------------+
RVSN USSR		|	   1777 | 	        1614 |		    121 |	       41 |		    1 |
Arianespace		|	    279 | 		 269 |		      7 |		3 |		    0 |	
CASC			| 	    251 | 		 231 |		     14 |		6 |		    0 | 
General Dynamics	|	    251 |		 203 | 	   	     37 |	       11 |		    0 |
NASA			|	    203 | 		 186 | 	   	     11 |		6 |		    0 |
VKS RF			| 	    201 | 		 188 |		      7 | 		6 |		    0 |
US Air Force		|	    161 | 		 129 | 	   	     30 | 		2 |		    0 |
ULA			|	    140 | 		 139 | 	   	      0 | 		1 |		    0 |
Boeing			|	    136 | 		 131 | 	   	      3 | 		2 |		    0 |
Martin Marietta		| 	    114	| 		 100 | 	   	     11 | 		3 |		    0 |
     	
    
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

--  Results:

company_name	 | countries_launched_from | total_launches | successful_launches |  success_rate |
--------------------------------------------------------------------------------------------------+
RVSN USSR   	 | 	Kazakhstan, Russia |	       1777 |		     1614 | 	       90 |
Arianespace  	 |	France, Kazakhstan |		279 |		      269 |	       96 |
CASC	     	 | 		     China |		251 |		      231 |	       92 |
General Dynamics |		       USA |		251 | 		      203 |	       80 |
VKS RF		 | 	Kazakhstan, Russia |		201 |		      188 |	       93 |
NASA		 |		       USA |		203 |		      186 |	       91 |
ULA		 | 		       USA |		140 | 		      139 |    	       99 |
Boeing		 | 		       USA | 		136 |		      131 | 	       96 |
US Air Force	 |		       USA |		161 |		      129 |	       80 |
Martin Marietta	 |		       USA | 		114 |		      100 |	       87 |


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

--  Results:

company_name | active_rockets | retired_rockets | rockets_launched | active_rocket_percentage |
----------------------------------------------------------------------------------------------+
Sea Launch   |		   36 |		     0 |		36 |			 100 |
CASC	     | 		  211 |             40 |	       251 |			  84 |
Northrop     | 		   63 |             20 |		83 |			  75 |
ISRO	     |		   50 | 	    26 |		76 | 			  65 |
ULA	     |		   87 |	            53 |	       140 | 			  62 |
Roscosmos    | 		   32 |	            23 | 		55 |			  58 |
Arianespace  | 		  114 |	           165 | 	       279 |		 	  40 |
SpaceX	     |		   38 |  	    62 |	       100 | 			  38 |
MHI	     | 		   32 |	            52 | 		84 | 			  38 |
VKS RF	     |		   27 |  	   174 |	       201 | 			  13 |


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

--  Results:

day_of_week | total_launches | successful_launches | success_rate |
------------------------------------------------------------------+
Sun	    |		 270 |		       239 | 	       88 |
Mon	    | 		 420 |		       374 |	       89 |
Tue	    |	         743 |		       670 |	       90 |
Wed	    |		 821 |		       752 |	       91 |
Thu	    | 		 808 |		       728 |           90 |
Fri	    | 		 772 |		       684 |	       88 |
Sat	    |		 490 |		       432 |	       88 |

--- What day of the month has the highest success rate?

SELECT 
       day_of_month,
        COUNT(*) as total_launches,
        COUNT(CASE WHEN status_mission = 'Success' THEN 1 END) as successful_launches,
        (COUNT(CASE WHEN status_mission = 'Success' THEN 1 END) * 100) / COUNT(*) AS success_rate
FROM rocket_data
GROUP BY day_of_month
ORDER by day_of_month asc;

--  Results:

day_of_month | total_launches | successful_launches | success_rate
-------------------------------------------------------------------+
1	     |		  100 |		         84 |		84 |
2	     | 		  119 | 		105 |		88 | 
3	     |		  125 |			114 |		91 |
4	     |		  133 |			110 |		82 | 
5	     |		  154 |			137 |		88 |
6	     |		  135 |			124 |		91 |
7	     |		  114 |			111 |		97 |
8	     |		  133 |			123 |		92 |
9	     |		  117 |			105 |		89 | 
10	     |		  129 |			117 |		90 |
11	     |		  145 |			133 |		91 |
12	     | 		  163 |			149 |	 	91 |
13	     | 		  101 |			 93 |		92 |
14	     |		  140 |			131 |		93 |
15	     |		  147 |			133 |		90 |
16	     |		  145 |			133 |		91 |
17	     |		  149 |			137 |		91 |
18	     |		  154 |			142 |		92 |
19	     |		  141 |			133 |		94 | 
20	     |		  155 |			140 |		90 |
21	     |		  167 |			145 |		86 |
22	     |		  158 |			131 |		82 | 
23	     |		  142 |			127 |		89 |
24	     |		  173 |			159 |		91 |
25	     |		  175 |			148 |		84 |
26	     |		  139 |			118 |		84 |
27	     | 		  152 |			129 |		84 |
28	     |		  187 |			168 |		89 |
29	     |		  137 |			124 | 		90 |
30	     |		  129 |			117 |		90 |
31	     |		   66 |			 59 |		89 |

