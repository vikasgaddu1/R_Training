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
log_path <- log_open("Table1_0")


# Prepare Data  ---------------------------------------------------------

# Write out log separator
sep("Read in ADSL data")

put("Data Filepath")
dir_data <- "./data/abc/ADaM" %>% put()

put("Load Data")
adsl   <- file.path(dir_data, "ADSL.rds") %>% read_rds() %>% 
  filter(ARM != "SCREEN FAILURE") %>% put()


put("Get ARM population counts")
arm_pop <- count(adsl, ARM) %>% deframe() %>% put()

put("Get ADaM format catalog")
adam_fmts <- read.fcat("./data/abc/adam_fmts.fcat")

# Stats Tests --------------------------------------------------------


put("Perform anova test on age and arm.")
age_anova <- aov(AGE ~ ARM, data = adsl) %>% 
  tidy() %>% filter(term == "ARM") %>% 
  transmute(stat = sprintf("%.3f (%.3f)", statistic,p.value)) %>%  put()

put("Perform chi squared test for each categorical variable.")
ageg_chisq <- chisq.test(adsl$ARM, adsl$AGEGR1, correct=FALSE) %>% 
  tidy() %>% transmute(stat = sprintf("%.3f (%.3f)", statistic,p.value)) %>% 
  put()
sex_chisq <- chisq.test(adsl$ARM, adsl$SEX, correct=FALSE) %>% 
  tidy() %>% transmute(stat = sprintf("%.3f (%.3f)", statistic,p.value)) %>% 
  put()
race_chisq <- chisq.test(adsl$ARM, adsl$RACE, correct=FALSE) %>% 
  tidy() %>% transmute(stat = sprintf("%.3f (%.3f)", statistic,p.value)) %>% 
  put()


# Age Summary Block -------------------------------------------------------

sep("Create summary statistics for age")

age_block <- 
  adsl %>%
  group_by(ARM) %>%
  summarise( N = fmt_n(AGE),
             `Mean (SD)` = fmt_mean_sd(AGE),
             Median = fmt_median(AGE),
             `Q1 - Q3` = fmt_quantile_range(AGE),
             Range  = fmt_range(AGE)) %>%
  pivot_longer(-ARM,
               names_to  = "label",
               values_to = "value") %>%
  pivot_wider(names_from = ARM,
              values_from = "value") %>% 
  add_column(var = "AGE", .before = "label") %>% 
  bind_cols(age_anova) %>% 
  put()


# Age Group Block ----------------------------------------------------------

sep("Create frequency counts for Age Group")


put("Create age group frequency counts")
ageg_block <- 
  adsl %>% 
  select(ARM, AGEGR1) %>% 
  group_by(ARM, AGEGR1) %>% 
  summarize(n = n()) %>% 
  pivot_wider(names_from = ARM,
              values_from = n, 
              values_fill = 0) %>% 
  transmute(var = "AGEGR1", 
            label =  factor(AGEGR1, levels = labels(adam_fmts$AGEGRP)),
            `ARM A` = fmt_cnt_pct(`ARM A`, arm_pop["ARM A"]),
            `ARM B` = fmt_cnt_pct(`ARM B`, arm_pop["ARM B"]),
            `ARM C` = fmt_cnt_pct(`ARM C`, arm_pop["ARM C"]),
            `ARM D` = fmt_cnt_pct(`ARM D`, arm_pop["ARM D"])) %>% 
  arrange(label) %>% 
  bind_cols(ageg_chisq) %>% 
  put()


# Sex Block ---------------------------------------------------------------

sep("Create frequency counts for SEX")




# Race Block --------------------------------------------------------------

sep("Create frequency counts for RACE")







# Final Data --------------------------------------------------------------

sep("Create final data frame")


final <- bind_rows(age_block, ageg_block, sex_block, race_block) %>% 
  put()



# Print Report (Separate Labels) -------------------------------------------

sep("Create and print report (Separate Labels)")

var_fmt <- c("AGE" = "Age", "AGEGR1" = "Age Group", "SEX" = "Sex", "RACE" = "Race")

# Create Table
tbl <- create_table(final, first_row_blank = TRUE, width = 9) %>% 
  column_defaults(from = `ARM A`, to = `ARM D`, align = "center", width = 1) %>% 
  stub(vars = c("var", "label"), "Variable", width = 2.5) %>% 
  define(var, blank_after = TRUE, dedupe = TRUE, label = "Variable",
         format = var_fmt,label_row = TRUE) %>% 
  define(label, indent = .25, label = "Demographic Category") %>% 
  define(`ARM A`,  n = arm_pop["ARM A"]) %>% 
  define(`ARM B`,  n = arm_pop["ARM B"]) %>% 
  define(`ARM C`,  n = arm_pop["ARM C"]) %>% 
  define(`ARM D`,  n = arm_pop["ARM D"]) %>% 
  define(stat, label = "Tests of Association*\nValue (P-value)",  
         width = 2, dedupe = TRUE, align = "center") %>% 
  titles("Table 1.0", "Analysis of Demographic Characteristics", 
         "Safety Population") %>% 
  footnotes("R Program: Table1_0.R",
            "NOTE: Denominator based on number of non-missing responses.",
            "*Pearsons's Chi-Square tests will be used for categorical variables",
            "   and ANOVA tests for continuous variables.") 

saveRDS(tbl, "reports/DM_Table.rds")

rpt <- create_report("output/DM_Table.rtf", output_type = "RTF") %>% 
  set_margins(top = 1, bottom = 1) %>% 
  page_header("Sponsor: Anova", "Study: ABC") %>% 
  add_content(tbl) %>% 
  page_footer(paste0("Date Produced: ", fapply(Sys.time(), "%d%b%y %H:%M")), 
              right = "Page [pg] of [tpg]")

write_report(rpt) %>% put()



# Clean Up ----------------------------------------------------------------


log_close()

options("tidylog.display" = NULL)

