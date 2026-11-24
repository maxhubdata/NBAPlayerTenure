library(tidyverse)

draft <- readRDS("data/clean_draft.rds")
players <- readRDS("data/clean_players.rds")

tenure <- players |> 
  inner_join(draft,by = "player_id") |> 
  arrange(player_id,season_start) |> 
  group_by(player_id) |> 
  summarise(
    
  )
  
