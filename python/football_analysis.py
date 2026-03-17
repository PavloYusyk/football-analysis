import pandas as pd
import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from pathlib import Path
import matplotlib.pyplot as plt
import seaborn as sns

load_dotenv()

user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
db_name = os.getenv("DB_NAME")

connection = f"postgresql://{user}:{password}@{host}:{port}/{db_name}"
engine = create_engine(connection)

BASE_DIR = Path(__file__).resolve().parent.parent

def load_sql(relative_path):
    sql_path = BASE_DIR / relative_path
    with open(sql_path, "r", encoding="utf-8") as file:
        return file.read()

matches_df = pd.read_sql(
    load_sql("datasets/dataset_matches.sql"),
    engine
)    

teams_df = pd.read_sql(
    load_sql("datasets/dataset_teams.sql"),
    engine
)    

leagues_df = pd.read_sql(
    load_sql("datasets/dataset_leagues.sql"),
    engine
)    

players_df = pd.read_sql(
    load_sql("datasets/dataset_players.sql"),
    engine
)    

datasets = {
    "Matches": matches_df,
    "Teams": teams_df,
    "Leagues": leagues_df,
    "Players": players_df
}

# -----------------------------------------------------
# Завдання 1
# Перевірити розмір датасетів.
#
# Для кожного DataFrame визначити:
# - кількість рядків
# - кількість колонок
#
# Датасети:
# matches
# teams
# leagues
# players
# -----------------------------------------------------
for name,df in datasets.items():
    print(f"{name} dataset shape:", df.shape)

    # -----------------------------------------------------
# Завдання 2
# Переглянути структуру датасетів.
#
# Для кожного DataFrame вивести:
# - список колонок
# - типи даних
#
# Це потрібно для розуміння структури даних.
# -----------------------------------------------------
for name, df in datasets.items():
    print(f"{name} columns:")
    print(df.columns.to_list)

    print(f"{name} type:")
    print(df.info())
    print()

# -----------------------------------------------------
# Завдання 3
# Перевірити пропущені значення (NULL).
#
# Для кожного датасету визначити
# кількість NULL значень у кожній колонці.
#
# Датасети:
# matches
# teams
# leagues
# players
# -----------------------------------------------------
for name,df in datasets.items():
    if df.isna().sum().sum() > 0:   
        print(f"{name} are", df.isna().sum().sum() ,"NULL value")
        print(df.isna().sum())

    else:  
        print(f"{name} has not NULL value")

# -----------------------------------------------------
# Завдання 4
# Перевірити унікальність ключових ID.
#
# Перевірити чи є дублікати у колонках:
#
# match_id
# team_id
# league_id
# player_id
#
# Це перевірка якості даних.
# -----------------------------------------------------
print(matches_df.shape[0] - matches_df["match_id"].nunique())
print(teams_df.shape[0] - teams_df["team_id"].nunique())
print(leagues_df.shape[0] - leagues_df["league_id"].nunique())
print(players_df.shape[0] - players_df["player_id"].nunique())

# -----------------------------------------------------
# Завдання 5
# Базова статистика матчів.
#
# Для колонки total_goals визначити:
#
# - середню кількість голів
# - максимальну кількість
# - мінімальну кількість
# - медіану
# -----------------------------------------------------
goals_info = matches_df["total_goals"].agg(
        AVG_Goals = "mean",
        MAX_Goals = "max",
        MIN_Goals = "min",
        Median = "median"
).round(2)

# -----------------------------------------------------
# Завдання 6
# Розподіл результатів матчів.
#
# Порахувати кількість:
#
# home_win
# away_win
# draw
#
# Використати колонку result.
# -----------------------------------------------------
sum_results = matches_df["result"].value_counts()

# -----------------------------------------------------
# Завдання 7
# Знайти найрезультативніші матчі.
#
# Визначити топ-10 матчів
# за кількістю total_goals.
#
# Результат:
# date
# league_name
# home_team_name
# away_team_name
# total_goals
# -----------------------------------------------------
top_matches = (
    matches_df
    .sort_values("total_goals", ascending=False)
    .loc[:, ["match_date", "league_name", "home_team_name", "away_team_name", "total_goals"]]
    .head(10)
)

# -----------------------------------------------------
# Завдання 8
# Порахувати середню результативність
# по кожній лізі.
#
# Метрика:
# avg_goals_per_match
#
# Групування:
# league_name
# -----------------------------------------------------
avg_goals_per_match = matches_df.groupby("league_name", as_index=False)["total_goals"].mean()
avg_goals_per_match = avg_goals_per_match.sort_values("total_goals", ascending=False)

# -----------------------------------------------------
# Завдання 9
# Знайти найрезультативніші команди.
#
# Визначити топ-10 команд
# за кількістю goals_scored.
#
# Результат:
# team_name
# goals_scored
# -----------------------------------------------------
top_team = (
    teams_df
    .sort_values("goals_scored", ascending=False)
    .loc[:, ["team_name","goals_scored"]]
    .head(10)
)

# -----------------------------------------------------
# Завдання 10
# Проаналізувати рейтинг гравців
# залежно від домінуючої ноги.
#
# Метрика:
# avg_overall_rating
#
# Групування:
# preferred_foot
# -----------------------------------------------------
avg_overall_rating = players_df.groupby("preferred_foot", as_index=False)["avg_overall_rating"].mean().round(2)
avg_overall_rating = avg_overall_rating.sort_values("avg_overall_rating", ascending=False)

print(avg_overall_rating)

# -----------------------------------------------------
# Insight 1
# Перевірити чи існує перевага домашнього поля.
#
# Порахувати відсоток:
# - home_win
# - away_win
# - draw
#
# Використати колонку result.
# -----------------------------------------------------
home_advantage = (matches_df["result"].value_counts() * 100.0 / matches_df["match_id"].count()).round(2)

print(home_advantage)

# -----------------------------------------------------
# Insight 2
# Проаналізувати середню результативність
# матчів по сезонах.
#
# Метрика:
# avg_total_goals
#
# Групування:
# season
# -----------------------------------------------------
avg_total_goals_per_season = (
    matches_df.groupby("season", as_index=False)
    .agg(
        avg_goals = ("total_goals", "mean")
    )
).round(2).sort_values("season")

print(avg_total_goals_per_season)

# -----------------------------------------------------
# Insight 3
# Перевірити зв'язок між:
#
# goals_scored
# win_percentage
#
# для команд.
#
# Визначити чи команди
# з більшою кількістю голів
# мають більший відсоток перемог.
# -----------------------------------------------------
goals_and_win = (
    teams_df[["team_name", "goals_scored", "win_percentage"]]
    .sort_values("goals_scored", ascending=False)
)

correlation = teams_df["goals_scored"].corr(teams_df["win_percentage"])

print(goals_and_win.head(10))
print("Correlation:", round(correlation, 2))


# -----------------------------------------------------
# Visualization 1
# Побудувати графік розподілу результатів матчів.
#
# Категорії:
# home_win
# away_win
# draw
#
# Використати колонку result.
# -----------------------------------------------------
plt.figure(figsize=(6,4))
sns.barplot(x=sum_results.index, y=sum_results.values)

plt.title("Distribution of Match Results")
plt.xlabel("Result")
plt.ylabel("Number of Matches")



# -----------------------------------------------------
# Visualization 2
# Побудувати графік середньої результативності
# матчів по сезонах.
#
# Метрика:
# avg_goals
#
# Групування:
# season
# -----------------------------------------------------
plt.figure(figsize=(10,5))
sns.lineplot(
    data=avg_total_goals_per_season,
    x="season",
    y="avg_goals",
    marker="o"
)

plt.title("Average Goals per Match by Season")
plt.xlabel("Season")
plt.ylabel("Average Goals")

plt.xticks(rotation=45)

# -----------------------------------------------------
# Visualization 3
# Побудувати scatter plot для перевірки
# зв'язку між:
#
# goals_scored
# win_percentage
# -----------------------------------------------------

plt.figure(figsize=(7,5))

sns.scatterplot(
    data=teams_df,
    x="goals_scored",
    y="win_percentage"
)

plt.title("Goals Scored vs Win Percentage")
plt.xlabel("Goals Scored")
plt.ylabel("Win Percentage")

plt.show()