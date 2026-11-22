library(tidyverse)
library(hoopR)

draftseasons <- 2000:2010

draft <- map_dfr(draftseasons, \(yr){
  Sys.sleep(1)
  nba_drafthistory(season=yr)$DraftHistory
  })
saveRDS(draft, "data/draft_raw.rds")
