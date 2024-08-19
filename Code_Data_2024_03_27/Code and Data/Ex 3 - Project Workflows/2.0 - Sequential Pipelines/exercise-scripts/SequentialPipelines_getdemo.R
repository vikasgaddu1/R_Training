
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: SequentialPipelines_getdemo.R

# Pseudo Code -------------------------------------------------------------

# |- Read in the demographics data set

# Get Demo -------------------------------------------------------------------
dm <- readRDS(paste0(basepath, datapath, "DM.rds")) %>% 
  select(USUBJID, SITEID, SEX, AGE)

