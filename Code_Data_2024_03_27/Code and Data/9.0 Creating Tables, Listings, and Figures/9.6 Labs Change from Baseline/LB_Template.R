# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(readr)
library(logr)
library(reporter)
library(fmtr)
library(broom)
library(tidylog, warn.conflicts = FALSE)


# Attach loggers
options("tidylog.display" = list(log_print), 
        "logr.on" = TRUE,
        "logr.notes" = FALSE)

# Open Log
log_path <- log_open("Table4_0")


# Prepare Data  ---------------------------------------------------------

sep("Read in ADLB data")

put("Data Filepath")
dir_data <- "./data/abc/ADaM" %>% put()

put("Load Data, filter by safety flag, and select desired columns")
adlb <- file.path(dir_data, "ADLB.csv") %>% read_csv() %>% 
  filter(SAFFL == "Y", PARCAT1 == "CHEMISTRY", is.na(AVISITN) == FALSE) %>% 
  select(USUBJID, TRTA, SAFFL, AVISIT, AVISITN, PARAM, 
         PARAMCD, PARAMN, AVAL) %>% 
  put()

put("Get unique subjects per treatment group")


put("Count subjects per treament group")



# Statistics Block Functions ------------------------------------------------

sep("Create utility functions for summary statistics blocks")




# Calculate Block Statistics ----------------------------------------------

sep("Calculate summary statistics for each block")

put("Get distinct params, in correct order")


put("Call get_visit_block function for each visit")



put("Combine all blocks into final data frame")



# Print Report ------------------------------------------------------------

sep("Create and print report")


# Create Table


# Create Report



write_report(rpt) %>% put()


# Clean Up ----------------------------------------------------------------


log_close()

options("tidylog.display" = NULL)

