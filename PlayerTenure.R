library(tidyverse)
library(survival)
library(ggsurvfit)

draft <- readRDS("data/clean_draft.rds")
players <- readRDS("data/clean_players.rds")

tenure <- players |> 
  inner_join(draft,by = "player_id") |> 
  arrange(player_id,season_start) |> 
  group_by(player_id, player_name, draft_year, round, overall_pick, first_team, first_team_id) |> 
  summarise(
    left_team = match(TRUE, team_id!=first_team_id),
    tenure = if(is.na(left_team)) n_distinct(season_start)
             else n_distinct(season_start[seq_len(left_team-1)]),
    event = as.integer(!is.na(left_team)),
    .groups = "drop"
  ) |> 
  mutate(time = tenure+event)
  
count(tenure, time)

summary(tenure$tenure)
count(tenure, tenure == 0)


ggplot(tenure, aes(tenure, col="red"))+geom_histogram(binwidth = 1)

round1 <- tenure |> 
  filter(round==1)
summary(round1$tenure)


round2 <- tenure |> 
  filter(round==2)
summary(round2$tenure)

tenure |> filter(round==1) |> select(tenure) |> summary()

fit <- survfit2(Surv(tenure,event) ~ round, data=tenure) |> ggsurvfit() 
diff <- survdiff(Surv(tenure,event)~round, data=tenure)




