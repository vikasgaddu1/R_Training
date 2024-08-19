
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: ProjWork_SequentialPipelines_Exercise.R

# Pseudo Code --------------------------------------------------------------

# |- Setup
# |- Get Data
# |- Summarize Data
# |- Show AE Body System Counts

# Setup ---------------------------------------------------------------------
library(tidyverse)

company  <- "Anova"
study    <- "ABC"
environ  <- "production"
basepath <- "../"
codepath <- "code"
datapath <- "data"

# Get Demo -------------------------------------------------------------------
dm <- readRDS(paste0(basepath, datapath, "DM.rds")) %>%
  select(USUBJID, SITEID, SEX, AGE)

# Get AE ---------------------------------------------------------------------
ae <- readRDS(paste0(basepath, datapath, "AE.rds")) %>%
  select(USUBJID, AEBODSYS, AETERM, AEHLT)

# Prepare & Summarize Data ---------------------------------------------------
dm_ae <-
  inner_join(dm, ae, by = c("USUBJID" = "USUBJID"))

bs_counts <-
  dm_ae %>%
  group_by(AEBODSYS) %>%
  summarize(n = n())


# Show Data ------------------------------------------------------------------
bs_counts %>%
  ggplot(aes(y = AEBODSYS, x = n)) +
  geom_col(fill = 'orange') +
  labs(title = company,
       subtitle = study,
       x = "Counts",
       y = "AE Body System",
       caption = paste("Note: ",
                       environ,
                       basepath,
                       '.'))

