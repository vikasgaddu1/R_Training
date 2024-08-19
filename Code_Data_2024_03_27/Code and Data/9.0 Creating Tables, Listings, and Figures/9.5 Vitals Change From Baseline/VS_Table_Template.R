# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(readr)
library(logr)
library(reporter)
library(fmtr)
library(tidylog, warn.conflicts = FALSE)


# Attach loggers
options("tidylog.display" = list(log_print), 
        "logr.on" = TRUE,
        "logr.notes" = FALSE)

# Open Log
log_path <- log_open("Table3_0")


# Prepare Data  ---------------------------------------------------------

sep("Read in ADVS data")

put("Data Filepath")
dir_data <- "./data/abc/ADaM" %>% put()

put("Load Data, filter by safety flag, and select desired columns")
advs <- file.path(dir_data, "ADVS.csv") %>% read_csv() %>% 
  filter(SAFFL == "Y") %>% 
  select(USUBJID, TRTA, SAFFL, AVISIT, AVISITN, PARAM, 
         PARAMCD, PARAMN, AVAL, BASE, CHG) %>% 
  put()

put("Get unique subjects per treatment group")
pop <- advs %>% select(USUBJID, TRTA) %>% distinct() %>% put()

put("Count subjects per treament group")
arm_pop <- pop %>% count(TRTA) %>% deframe() %>% put()



# Statistics Block Functions ------------------------------------------------

sep("Create utility functions for summary statistics blocks")

get_block <- function(visit, paramcd) {
  
  block <- 
    advs %>%
    filter(AVISIT == visit, PARAMCD == paramcd) %>% 
    select(TRTA, AVISIT, PARAM, PARAMCD, AVAL) %>% 
    group_by(AVISIT, PARAM, PARAMCD, TRTA) %>%
    summarise( N = fmt_n(AVAL),
               `Mean (SD)` = fmt_mean_sd(AVAL),
               Median = fmt_median(AVAL),
               Range  = fmt_range(AVAL)) %>%
    pivot_longer(cols = c(N, `Mean (SD)`, Median, Range),
                 names_to  = "label",
                 values_to = "value") %>%
    pivot_wider(names_from = TRTA,
                values_from = "value") %>% 
    ungroup()
  
  return(block)
  
}

get_visit_block <- function(visit) {
  
  temp_block <- get_block(visit, "TEMP") 
  sysbp_block <- get_block(visit, "SYSBP") 
  diabp_block <- get_block(visit, "DIABP") 
  resp_block <- get_block(visit, "RESP") 
  pulse_block <- get_block(visit, "PULSE") 
  
  ret <- bind_rows(temp_block, sysbp_block, diabp_block, 
                   resp_block, pulse_block) 
  
  return(ret)
}

# Calculate Block Statistics ----------------------------------------------

sep("Calculate summary statistics for each block")

put("Get distinct visits, in correct order")
visits <- advs %>% select(AVISIT, AVISITN) %>% 
  distinct() %>% arrange(AVISITN) %>% filter(!is.na(AVISIT)) %>% put()

put("Call get_visit_block function for each visit")
datlst <- map(visits$AVISIT, get_visit_block)


put("Combine all blocks into final data frame")
final <- bind_rows(datlst)  %>% 
  mutate(AVISIT = factor(AVISIT, levels = visits$AVISIT)) %>% put()


# Print Report ------------------------------------------------------------

sep("Create and print report")


# Create Table



res <- write_report(rpt) 

# Clean Up ----------------------------------------------------------------


log_close()

options("tidylog.display" = NULL)

