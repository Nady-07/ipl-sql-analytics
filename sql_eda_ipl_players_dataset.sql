--Q1 Find the total spending on players for each team:

--output: team, total_spending
--method: SUM(price), GROUP BY(team)

SELECT
    Team,
    SUM(price_in_cr) AS 'Total_Spending'
FROM
    IPLPlayers
GROUP BY
    Team;


--Q2 Find the top 3 highest-paid 'All-rounders' across all teams:

--output: player, team, price
--method: WHERE, ORDER BY(price), TOP3

SELECT TOP 3
    Player,
    Team,
    Price_in_cr
FROM
    IPLPlayers
WHERE
    Role = 'All-rounder'
ORDER BY
    Price_in_cr DESC;


--Q3 Find the highest-priced player in each team:

--output: team, player, highest_price
--method: CTE[MAX(price), GROUP BY(team)], join()

WITH CTE_highest_price AS(
	SELECT
        Team,
        Max(Price_in_cr) as highest_price
	FROM
        IPLPlayers
	GROUP BY
        Team
)
SELECT
    i.Team,
    i.Player,
    c.highest_price
FROM
    IPLPlayers AS i
JOIN CTE_highest_price c 
    ON i.Team = c.Team
WHERE
    i.Price_in_cr = c.highest_price

--Q4 Rank players by their price within each team and list the top 2 for every team:

--output: Player, team, price, Rank
--tables: iplplayers
--method: CTE(GROUP BY (Player, Team, Rank))
WITH cte_highest_price AS(
    SELECT
        Player,
        Team,
        MAX(Price_in_cr) AS highest_price
    FROM
        IPLPlayers
    GROUP BY
        Player,
        Team
),
cte_rank AS (
    SELECT
        Player,
        Team,
        highest_price,
        ROW_NUMBER() OVER(PARTITION BY Team ORDER BY highest_price DESC) AS Ranking
    FROM
        cte_highest_price
)
SELECT
    *
FROM
    cte_rank
WHERE
    Ranking <= 2;



--Q5 Find the most expensive player from each team, along with the second-most expensive player's name and price:

--output: player, team, 



WITH RankedPlayers AS (
	SELECT Player, Team, Price_in_cr,
	ROW_NUMBER() OVER (PARTITION BY Team ORDER BY Price_in_cr DESC) AS RankWithinTeam
	FROM IPLPlayers
)
SELECT Team,
	MIN(CASE WHEN RankWithinTeam = 1 THEN Player END) AS MostExpensivePlayer,
	MIN(CASE WHEN RankWithinTeam = 1 THEN Price_in_cr END) AS HighestPrice,
	MIN(CASE WHEN RankWithinTeam = 2 THEN Player END) AS SecondMostExpensivePlayer,
	MIN(CASE WHEN RankWithinTeam = 2 THEN Price_in_cr END) AS SecondHighestPrice
FROM RankedPlayers
GROUP BY Team;



--Q6 Calculate the percentage contribution of each player's price to their team's total spending

--output: player, pctof the total of the team
--method: CTE[GROUP BY (Team)]

WITH CTE_total_spending AS(
    SELECT
        Team,
        SUM(Price_in_cr) AS total_spending
    FROM
        IPLPlayers
    GROUP BY
        Team
)
SELECT
    i.Player,
    CAST(ROUND((1.0 * i.Price_in_cr / c.total_spending) * 100, 2) AS DECIMAL(10, 2)) as pct
FROM
    IPLPlayers AS i
LEFT JOIN CTE_total_spending as c
    ON i.Team = c.Team;




--Q7 Classify players as 'High', 'Medium', or 'Low' priced based on the following rules:
--High: Price > ₹15 crore
--Medium: Price between ₹5 crore and ₹15 crore
--Low: Price < ₹5 crore
--and find out the number of players in each bracket

--output: team, price_class, total in each class
--method: CTE[Case], GROUP BY(Team, player class), COUNT(*)

WITH cte_price_class AS (
    SELECT
        Team,
        CASE
            WHEN Price_in_cr > 15 THEN 'High'
            WHEN Price_in_cr BETWEEN 5 AND 15 THEN 'Medium'
            ELSE 'Low'
        END AS price_class
    FROM
        IPLPlayers
)
SELECT
    Team,
    price_class,
    COUNT(price_class) AS total_count
FROM
    cte_price_class
GROUP BY
    Team,
    price_class
ORDER BY
    Team,
    total_count DESC;

--Q8 Find the average price of Indian players and compare it with overseas players:

--output: players, avg(price), player_overseas, avg(price)
--method: ROUND(AVG(price), 2), Unionall
SELECT
    'indian' AS player_country,
    CAST(ROUND(AVG(Price_in_cr), 2) AS DECIMAL(10, 2)) AS average_overseas_price
FROM
    IPLPlayers
WHERE
    [Type] LIKE 'India%'

UNION ALL

SELECT
    'overseas' AS player_country,
    CAST(ROUND(AVG(Price_in_cr), 2) AS DECIMAL(10, 2)) AS average_overseas_price
FROM
    IPLPlayers
WHERE
    [Type] LIKE 'Overseas%';


--Q9 Identify players who earn more than the average price of their team:

--output: players, team, price
--method: CTE[AVG(price), GROUP BY(team, players)], WHERE price > AVG_price

WITH cte_avg_price AS(
    SELECT
        Team,
        CAST(ROUND(AVG(Price_in_cr), 2) AS DECIMAL(10, 2)) AS avarege_price
    FROM
        IPLPlayers
    GROUP BY
        Team
)
SELECT
    i.Player,
    i.Team,
    i.Price_in_cr
FROM
    IPLPlayers AS i
INNER JOIN cte_avg_price as c
    ON i.Team = c.Team
WHERE
    i.Price_in_cr > c.avarege_price;

--Q10 For each role, find the most expensive player and their price

--output: team, role, player, price,
--method: CTE[MAX(price), GROUP BY(role)], INNER JOIN 
WITH cte_max_price AS (
    SELECT
        Role,
        MAX(Price_in_cr) AS most_expensive
    FROM
        IPLPlayers
    GROUP BY
        Role
)
SELECT
    i.Team,
    i.Player,
    i.Role,
    c.most_expensive
FROM
    IPLPlayers AS i
INNER JOIN cte_max_price AS c
    ON i.Role = c.Role AND i.Price_in_cr = c.most_expensive

