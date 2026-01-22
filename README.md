🎬 Netflix Content Analysis using SQL
🔹 Project Overview

This project analyzes the Netflix dataset using SQL to answer 15 business and content-related questions.
The goal is to understand content distribution, ratings, genres, countries, and actor/director patterns on Netflix.

🔹 Business Questions Answered

1.The analysis answers the following key questions:
2.Count of Movies vs TV Shows
3.Most common rating for Movies and TV Shows
4.Movies released in a specific year (e.g., 2020)
5.Top 5 countries with the most Netflix content
6.Longest movie on Netflix
7.Content added in the last 5 years
8.Content by director Rajiv Chilaka
9.TV shows with more than 5 seasons
10.Content count by genre
11.Top 5 years with highest average content release in India
12.List of documentary movies
13.Content without a director
14.Movies featuring Salman Khan in last 10 years
15.Top 10 actors in Indian-produced movies,Content categorized as Good vs Bad based on keywords in description

🔹 Dataset
Source: Netflix Titles Dataset
Records: ~8,800 titles
Key Columns:
Type (Movie / TV Show)
Title
Director
Cast
Country
Date Added
Release Year
Rating
Duration
Genre
Description

🔹 Tools Used
SQL (MySQL / PostgreSQL / SQLite)
Excel (for initial data inspection)

🔹 Key Insights
Movies form the majority of Netflix content compared to TV Shows.
The United States and India are among the top content-producing countries.
TV Shows with more than 5 seasons are relatively rare.
Documentary movies form a small but distinct category.
A significant portion of content lacks director information, indicating metadata quality issues.

🔹 Deliverables
netflix_titles.csv – Raw dataset
netflix_analysis.sql – All 15 SQL queries
