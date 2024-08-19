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
pop <- adlb %>% select(USUBJID, TRTA) %>% distinct() %>% put()

put("Count subjects per treament group")
arm_pop <- pop %>% count(TRTA) %>% deframe() %>% put()



# Statistics Block Functions ------------------------------------------------

sep("Create utility functions for summary statistics blocks")

get_block <- function(visit, paramcd) {
  
  block <- 
    adlb %>%
    filter(AVISITN == visit, PARAMCD == paramcd) %>% 
    select(TRTA, AVISIT, AVISITN, PARAM, PARAMCD, AVAL) %>% 
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

get_param_block <- function(paramcd) {
  
  day1_block <- get_block(0, paramcd) 
  week2_block <- get_block(2, paramcd) 
  week6_block <- get_block(6, paramcd) 
  week12_block <- get_block(12, paramcd) 
  
  ret <- bind_rows(day1_block, week2_block, week6_block, 
                   week12_block) 
  
  return(ret)
}

# Calculate Block Statistics ----------------------------------------------

sep("Calculate summary statistics for each block")

put("Get distinct params, in correct order")
params <- adlb %>% select(PARAM, PARAMCD) %>% 
  distinct() %>% arrange(PARAMCD) %>% filter(!is.na(PARAM)) %>% put()

put("Call get_visit_block function for each visit")
datlst <- map(params$PARAMCD, get_param_block)


put("Combine all blocks into final data frame")
final <- bind_rows(datlst)  %>% 
  mutate(PARAM = factor(PARAM, levels = params$PARAM)) %>% put()


# Print Report ------------------------------------------------------------

sep("Create and print report")


# Create Table
tbl <- create_table(final, width = 9) %>% 
  column_defaults(from = `ARM A`, to = `ARM D`, align = "center", width = 1.2) %>% 
  page_by(PARAM, label = "Parameter: ") %>% 
  stub(vars = c(AVISIT, label), label  = "Visit", width = 2) %>% 
  define(PARAM, visible = FALSE) %>% 
  define(PARAMCD, visible = FALSE) %>% 
  define(AVISIT, label_row = TRUE, blank_after = TRUE) %>% 
  define(label, indent = .25) %>% 
  define(`ARM A`,  n = arm_pop["ARM A"]) %>% 
  define(`ARM B`,  n = arm_pop["ARM B"]) %>% 
  define(`ARM C`,  n = arm_pop["ARM C"]) %>% 
  define(`ARM D`,  n = arm_pop["ARM D"]) %>% 
  titles("Table 4.0", "Summary of Chemistry Parameters by Visit", 
         "Safety Population") %>% 
  footnotes("Program: Table4.R") 
  

rpt <- create_report("output/LB_Table", output_type = "RTF") %>% 
  set_margins(top = 1, bottom = .9) %>% 
  page_header("Sponsor: Anova", "Study: ABC") %>% 
  add_content(tbl) %>% 
  page_footer(paste0("Date Produced: ", fapply(Sys.time(), "%d%b%y %H:%M")), 
              right = "Page [pg] of [tpg]")

write_report(rpt)

# Clean Up ----------------------------------------------------------------


log_close()

options("tidylog.display" = NULL)

