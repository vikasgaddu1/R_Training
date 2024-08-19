# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Setup -------------------------------------------------------------------

library(reporter)
library(fmtr)
library(tidyverse)
library(haven)
library(labelled)

library(logr)

options("logr.on" = TRUE, "logr.notes" = FALSE)

log_open("Lab_Listing1_0")

# Prepare Data ------------------------------------------------------------

sep("Read Day 1 Chemistry Lab Data")

abc_lb <-
  read_sas('data/abc_adam_adlb.sas7bdat') %>%
  select (USUBJID, TRTA, PARCAT1, ADY, PARAMCD, PARAM, AVAL, ANRIND, AVISITN, ADY) %>%
  filter(PARCAT1 == "CHEMISTRY" & ADY == 1 & TRTA != "")

var_label(abc_lb$AVAL) <- NULL

abc_lb_wide <-
  abc_lb %>%
  pivot_wider(id_cols = c(USUBJID, TRTA),
              names_from = PARAMCD,
              values_from = AVAL)


lb_tbl <- create_table(abc_lb_wide) %>%
  define(USUBJID, id_var = TRUE)

lb_rpt <- create_report("output/Chemistry_Day1_Lab_Listing1_0.txt") %>%
  page_header("Client: Anova", "Study: ABC") %>%
  titles("Listing 1.0", "Laboratory Chemistry Assay Data Subject Listing") %>%
  add_content(lb_tbl, align = "left") %>%
  page_footer(Sys.time(), "Confidential", "Page [pg] of [tpg]")

write_report(lb_rpt) %>% put()


# Lab Summary Table
abc_lb_total <-
  abc_lb %>%
  mutate(TRTA = "Total")

abc_lb <-
  bind_rows(abc_lb, abc_lb_total)

abc_lb_val_summary <-
  abc_lb %>%
  group_by(TRTA, PARAMCD) %>%
  summarise(across(.cols = AVAL,
                   .fns = list(N = ~ fmt_n(.),
                               `Mean (SD)` = ~ fmt_mean_sd(.),
                               Median = ~ fmt_median(.),
                               `Q1 - Q3` = ~ fmt_quantile_range(.),
                               Range  = ~ fmt_range(.)
                   ))) %>%
  pivot_longer(cols =  c(-TRTA, -PARAMCD),
               names_to  = c("var", "label"),
               names_sep = "_",
               values_to = "value") %>%
  pivot_wider(names_from = TRTA,
              values_from = "value") %>%
  select(-var)

# Create Table
lb_val_summary <- create_table(abc_lb_val_summary, first_row_blank = TRUE) %>%
  define(PARAMCD, blank_after = TRUE, dedupe = TRUE, label = "") %>%
  define(label, label = "")

lb_val_rpt <- create_report("output/Chemistry_Day1_Lab_Summary_1_0.txt") %>%
  page_header("Client: Anova", "Study: ABC") %>%
  titles("Table 1.0", "Chemistry Lab Assay Summary") %>%
  add_content(lb_val_summary, align = "left") %>%
  page_footer(Sys.time(), "Confidential", "Page [pg] of [tpg]")

write_report(lb_val_rpt) %>% put()


