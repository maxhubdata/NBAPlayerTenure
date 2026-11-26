library(tidyverse)

raw_draft <- readRDS("data/draft_raw.rds")
raw_players <- readRDS("data/players_raw.rds")

##Data Cleaning
clean_draft <- raw_draft |> 
  transmute(
    draft_team = TEAM_ABBREVIATION,
    draft_team_id = TEAM_ID,
    draft_year = as.integer(SEASON),
    player_name = PLAYER_NAME,
    player_id = PERSON_ID,
    round = as.integer(ROUND_NUMBER),
    overall_pick = as.integer(OVERALL_PICK)
  ) |> 
  arrange(player_id, draft_team_id)

#dropping TOT to have only one row per team played for 
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
#Which players were drafted but never played in the NBA (115 players)
never_played <- anti_join(clean_draft, clean_players, by = "player_id")
#How many players played for more than one team in a season (484 players)
clean_players |> count(player_id, season_start) |> filter(n > 1)

#removing all players who never played from the draft data
clean_draft_played <- anti_join(clean_draft,never_played,by = "player_id")

first_team <- clean_players |> 
  arrange(player_id,season_start) |> 
  group_by(player_id) |> 
  slice(1) |> 
  ungroup(player_id) |> 
  select(player_id, first_team = team, first_team_id = team_id)

#checking 
check <- clean_draft_played |>
  inner_join(first_team, by = "player_id") |>
  mutate(same_team = draft_team_id == first_team_id)
count(check, same_team)

check |>
  filter(!same_team) |>
  select(player_name, draft_year, overall_pick, draft_team, first_team_id,first_team) |>
  View()

saveRDS(clean_draft_played,"data/clean_draft.rds")
saveRDS(clean_players,"data/clean_players.rds")
