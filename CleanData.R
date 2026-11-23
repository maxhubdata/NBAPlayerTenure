library(tidyverse)

raw_draft <- readRDS("data/draft_raw.rds")
raw_players <- readRDS("data/players_raw.rds")

glimpse(raw_draft)
clean_draft <- raw_draft |> 
  transmute(
    draft_team = TEAM_ABBREVIATION,
    draft_year = as.integer("SEASON"),
    round = as.integer("ROUND_NUMBER"),
    overall_pick = as.integer("OVERALL_PICK")
  )

