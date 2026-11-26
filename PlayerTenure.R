library(tidyverse)

draft <- readRDS("data/clean_draft.rds")
players <- readRDS("data/clean_players.rds")

tenure <- players |> 
  inner_join(draft,by = "player_id") |> 
  arrange(player_id,season_start) |> 
  group_by(player_id, player_name, draft_year, round, overall_pick, draft_team) |> 
  summarise(
    left_team = match(TRUE, team!=draft_team),
    tenure = if(is.na(left_team)) n_distinct(season_start)
             else n_distinct(season_start[seq_len(left_team-1)]),
    event = as.integer(!is.na(left_team)),
    .groups = "drop"
  ) |> 
  mutate(time = tenure+event)
  
count(tenure, time)

summary(tenure$tenure)
count(tenure, tenure == 0)


ggplot(tenure, aes(tenure))+geom_histogram()
