
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: SequentialPipelines_getae.R

# Pseudo Code -------------------------------------------------------------

# |- Read in the adverse events data set

# Get AE -------------------------------------------------------------------
ae <- readRDS(paste0(basepath, datapath,"AE.rds")) %>% 
  select(USUBJID, AEBODSYS, AETERM, AEHLT)

