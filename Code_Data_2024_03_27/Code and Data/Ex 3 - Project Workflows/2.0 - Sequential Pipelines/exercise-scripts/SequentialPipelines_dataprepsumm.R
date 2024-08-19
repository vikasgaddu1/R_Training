
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: SequentialPipelines_dataprepsumm.R

# Pseudo Code -------------------------------------------------------------

# |- Combine and prepare the data

# Prepare & Summarize Data -------------------------------------------------------------------
dm_ae <- 
  inner_join(dm, ae, by = c("USUBJID" = "USUBJID")) 

bs_counts <- 
  dm_ae %>% 
  group_by(AEBODSYS) %>% 
  summarize(n = n())


