# 🏏 IPL Players Auction: SQL Exploratory Data Analysis

An exploratory data analysis of IPL squad and auction data, written in **T-SQL (SQL Server)**. The project loads 228 players across 10 franchises into one table, then answers 10 business-style questions about team spending, player pricing, roles, and nationality.

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Skills Demonstrated](#-skills-demonstrated)
- [Dataset](#-dataset)
- [Repository Structure](#-repository-structure)
- [How to Run](#-how-to-run)
- [Questions and Key Findings](#-questions-and-key-findings)
- [Tools](#-tools)
- [Author](#-author)

---

## 🎯 Project Overview

IPL franchises spend a fixed budget every season on a mix of retained players, auction buys, and Right to Match (RTM) picks. This project treats that squad data like a business dataset and asks:

- How much did each team spend, and how is that spend distributed across players?
- Who are the most expensive players overall, by team, and by role?
- How do Indian and overseas players compare on price?
- How are players spread across high, medium, and low price brackets?

---

## 🛠 Skills Demonstrated

| Area | What is used |
|---|---|
| Aggregation | `SUM`, `AVG`, `MAX`, `COUNT`, `GROUP BY` |
| CTEs | Single and chained Common Table Expressions |
| Window functions | `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` |
| Conditional logic | `CASE WHEN` for bucketing and pivoting rows into columns |
| Joins | `INNER JOIN` and `LEFT JOIN` between a table and its own aggregates |
| Set operations | `UNION ALL` |
| Other | `TOP`, `CAST`, `ROUND`, `LIKE` pattern matching |

---

## 📂 Dataset

A single table, `IPLPlayers`, with **228 rows** covering **10 teams**.

| Column | Type | Description |
|---|---|---|
| `Player` | NVARCHAR(120) | Player name (overseas players include their country in brackets) |
| `Price_in_cr` | DECIMAL(10,2) | Price in Indian crore rupees |
| `Type` | NVARCHAR(50) | Nationality and capped/uncapped status, e.g. `Indian (capped)` |
| `Acquisition` | NVARCHAR(50) | `Retained`, `Auction`, or `RTM` |
| `Role` | NVARCHAR(50) | Batter, Bowler, All-rounder, Batter/Wicketkeeper |
| `Team` | NVARCHAR(100) | IPL franchise |

**Source:** _add the link to where you got the data here_

---

## 🗂 Repository Structure

```
.
├── IPL_InsertData.sql                  # Creates the IPLTeam database, the table, and loads all 228 rows
├── sql_eda_ipl_players_dataset.sql     # The 10 analysis questions and their queries
└── README.md
```

---

## ▶️ How to Run

1. Open **SQL Server Management Studio (SSMS)** or **Azure Data Studio** and connect to a SQL Server instance.
2. Run `IPL_InsertData.sql` to create the database and load the data.
3. Run `sql_eda_ipl_players_dataset.sql` one question at a time and review each result.

> ⚠️ `IPL_InsertData.sql` drops and recreates a database named `IPLTeam` if it already exists. Do not run it on a server where you have an `IPLTeam` database you want to keep.

---

## 📊 Questions and Key Findings

| # | Question | Technique | Finding |
|---|---|---|---|
| 1 | Total spending per team | `SUM`, `GROUP BY` | Nine of the ten teams spent between about 116 and 120 crore. Lucknow Super Giants spent the most (119.90 cr) and Kolkata Knight Riders the least (107.95 cr). |
| 2 | Top 3 highest-paid all-rounders | `TOP`, `ORDER BY` | Ravindra Jadeja (18 cr), Hardik Pandya (16.35 cr), Abhishek Sharma (14 cr). |
| 3 | Highest-priced player in each team | CTE + join | Rishabh Pant at 27 cr (Lucknow Super Giants) is the most expensive player in the dataset, followed by Shreyas Iyer at 26.75 cr (Punjab Kings). |
| 4 | Top 2 players per team by price | CTE + `ROW_NUMBER` | Ranks every squad and keeps the two highest-priced players per team. |
| 5 | Most and second-most expensive player per team, side by side | `ROW_NUMBER` + `CASE` pivot | One row per team showing both players and both prices. |
| 6 | Each player's share of team spending | CTE + join | Shows how concentrated each team's budget is in a few players. |
| 7 | High / Medium / Low price brackets per team | `CASE`, `COUNT` | High is above 15 cr, Medium is 5 to 15 cr, Low is below 5 cr. Most players in every squad fall in the Low bracket. |
| 8 | Average price: Indian vs overseas players | `UNION ALL` | Overseas players have a higher average price than Indian players. |
| 9 | Players priced above their team's average | CTE + join | Lists each team's above-average earners. |
| 10 | Most expensive player in each role | CTE + join | The top-priced player for every role. |

---

## 🧰 Tools

- Microsoft SQL Server (T-SQL)
- SQL Server Management Studio or Azure Data Studio
- Git and GitHub

---

## 👤 Author

**Mohamed Al Nady**
Data Analyst · SQL · Power BI · DAX · Python

📍 Cairo, Egypt
