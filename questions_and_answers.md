# Space Missions 1957-2020
## Questions and answers

**Author**: Yadira Ocampo

**Email** yadira.ocampo33@gmail.com


#### How many rocket launches occurred between 1957 - 2020

````sql
SELECT COUNT(id) as launch_count
FROM rocket_data;
````

**Results:**

launch_count |
-------------|
4324 |

#### How many rockets were launched from each country?

*note: this is where the rockets have been launched from, but the companies that are conducting these launches may be from other countries ex. USSR being Russian owned, but launching in Kazakhstan, or Arianespace being a French company launching in Kazakhstan as well (due to company collaborations).* 

```sql
SELECT country, COUNT(*) as rockets_launched
FROM rocket_data
GROUP BY country
ORDER BY rockets_launched desc;
```

--  Results:

country 	  | rockets_launched |
------------|------------------|
Russia		  |             1398 |
USA		      |             1385 |
Kazakhstan 	|              701 |
France		  |              303 |
China		    |              269 |
Japan		    |              126 |
India	    	|               76 |
Iran		    |               14 |
New Zealand	|               13 |
Israel		  |               11 |
Kenya		    |                9 |
Australia	  |                6 |
North Korea	|                5 | 
South Korea	|                3 | 
Brazil		  |                3 |
Spain		    |                2 | 

