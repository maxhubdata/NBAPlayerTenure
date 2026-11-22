library(tidyverse)
library(hoopR)

draftseasons <- 2000:2010

draft <- map_dfr(draftseasons, \(yr){
  Sys.sleep(1)
  nba_drafthistory(season=yr)$DraftHistory
  })
dir.create("data")
saveRDS(draft, "data/draft_raw.rds")

get_players <- \(id){
  Sys.sleep(1)
  output <- tryCatch(
    nba_playercareerstats(player_id=id)$SeasonTotalsRegularSeason,
    error = function(e) NULL
  )
  if(!is.null(output)) output$Player_ID <- id
  output
  }
players <- map_dfr(unique(draft$PERSON_ID),get_players)
saveRDS(players,"data/players_raw.rds")
