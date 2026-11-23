library(tidyverse)

raw_draft <- readRDS("data/draft_raw.rds")
raw_players <- readRDS("data/players_raw.rds")

##Data Cleaning
clean_draft <- raw_draft |> 
  transmute(
    draft_team = TEAM_ABBREVIATION,
    draft_year = as.integer(SEASON),
    player_name = PLAYER_NAME,
    player_id = PERSON_ID,
    round = as.integer(ROUND_NUMBER),
    overall_pick = as.integer(OVERALL_PICK)
  )

clean_players <- raw_players |> 
  filter(TEAM_ABBREVIATION != "TOT") |> 
  transmute(
    team = TEAM_ABBREVIATION,
    team_id = TEAM_ID,
    season_start = as.integer(str_sub(SEASON_ID,1,4)),
    player_id = PLAYER_ID,
    games = as.integer(GP)
  ) |> 
  distinct() |> 
  arrange(player_id,season_start)

##Validating no errors
#Checking for duplicates
clean_draft |> count(player_id) |> filter(n>1)
#Checking for correct # of years
clean_draft |> count(draft_year)
#Which players were drafted but never played in the NBA
anti_join(clean_draft, clean_players, by = "player_id")
#How many players played for more than one team in a season
clean_players |> count(player_id, season_start) |> filter(n > 1)
