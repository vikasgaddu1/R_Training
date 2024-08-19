# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Setup -------------------------------------------------------------------
library(tidyverse)
library(reporter)
library(fmtr)
library(logr)
library(stringr)
library(tidylog, warn.conflicts = FALSE)

options("tidylog.display" = list(log_print))
options("logr.on" = TRUE, "logr.notes" = FALSE)

log_open("Table2_0")


# Prepare Data ------------------------------------------------------------



sep("Read ADSL data")

dp <- "./5.14 Reporting/ADSL.csv"

dat <- read_csv(dp) %>% put()

dat %>% glimpse() %>% put()


# Disposition Counts and Percents -----------------------------------------



sep("Prepare calculations")

# Get population counts
arm_pop <- dat %>% count(ARM) %>% deframe() %>% put()

# Subset ADSL for needed rows and columns
df_sub <- dat %>% filter(SAFFL == "Y") %>% 
  select(ARM, COMPLFL, STDYDISP, STDYREAS) 

# Get counts and percents for disposition
df1 <- df_sub %>% 
  select(-STDYREAS) %>% 
  group_by(ARM, COMPLFL, STDYDISP) %>% 
  summarize(cnt = n()) %>% 
  pivot_wider(names_from = ARM,
              values_from = cnt, 
              values_fill = 0) %>% 
  mutate(`ARM A` = fmt_cnt_pct(`ARM A`, arm_pop["ARM A"]),
         `ARM B` = fmt_cnt_pct(`ARM B`, arm_pop["ARM B"]),
         `ARM C` = fmt_cnt_pct(`ARM C`, arm_pop["ARM C"]),
         `ARM D` = fmt_cnt_pct(`ARM D`, arm_pop["ARM D"]), 
         STDYDISP = fct_shift(factor(STDYDISP), n = -1)) %>% 
  arrange(STDYDISP) %>% 
  ungroup() %>% 
  put()

# Rearrange Rows
df1 <- df1[c(3, 2, 1), ]

# Get counts and percents for termination reason
df2 <- df_sub %>% filter(COMPLFL == "N") %>% 
  group_by(ARM, COMPLFL, STDYDISP, STDYREAS) %>% 
  summarize(cnt = n()) %>% 
  pivot_wider(names_from = ARM,
              values_from = cnt,
              values_fill = 0) %>% 
  mutate(`ARM A` = fmt_cnt_pct(`ARM A`, arm_pop["ARM A"]),
         `ARM B` = fmt_cnt_pct(`ARM B`, arm_pop["ARM B"]),
         `ARM C` = fmt_cnt_pct(`ARM C`, arm_pop["ARM C"]),
         `ARM D` = fmt_cnt_pct(`ARM D`, arm_pop["ARM D"]),
         STDYREAS = str_pad(STDYREAS, 4, "left")) %>% 
  ungroup() %>% 
  put()

d1 <-  rename(df1, Label = STDYDISP) 
d2 <- select(df2, -STDYDISP) %>% rename(Label = STDYREAS)
d2$Label <- paste0("    ", d2$Label)
d2 <- d2[c(2, 3, 1), ]

final <- bind_rows(d1,
                   d2) %>% put()


# Print Report ------------------------------------------------------------


sep("Create Table")

tbl <- create_table(final, first_row_blank = TRUE) %>% 
  define(COMPLFL, visible = FALSE) %>% 
  define(Label, width = 4.5, label = "Completion Status\n    Reason for Discontinuation") %>% 
  define(`ARM A`, align = "center", n = arm_pop["ARM A"]) %>% 
  define(`ARM B`, align = "center", n = arm_pop["ARM B"]) %>% 
  define(`ARM C`, align = "center", n = arm_pop["ARM C"]) %>% 
  define(`ARM D`, align = "center", n = arm_pop["ARM D"]) 


rpt <- create_report("output/Table2_0.txt") %>% 
  page_header("Client: Anova", "Study: BBC") %>% 
  titles("Table 2.0", "Subject Disposition") %>% 
  add_content(tbl) %>% 
  footnotes(paste("Date Produced:", Sys.time(), ";  SAS Program: Table2_0.R"),
            paste("NOTE: % for Subject Completed rows and Early Termination", 
                  "row are based on N"),
            paste("% for Reason for discontinuation is based",
                  "on the number of Early Terminations")) %>% 
  page_footer(Sys.time(), "Confidential", "Page [pg] of [tpg]")

write_report(rpt) %>% put()



# Clean Up ----------------------------------------------------------------

log_close()

options("tidylog.display" = NULL)
