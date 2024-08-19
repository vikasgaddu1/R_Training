# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Setup -------------------------------------------------------------------

library(tidyverse)
library(haven)
library(reporter)
library(fmtr)
library(logr)
library(stringr)
library(tidylog, warn.conflicts = FALSE)

options("tidylog.display" = list(log_print))
options("logr.on" = TRUE, "logr.notes" = FALSE)

log_open("Ex4.txt")


# Prepare Data ------------------------------------------------------------


sep("Read CM data")

dp <- read_sas("data/abc_adam_adlb.sas7bdat") %>%
  filter(TRTA != "" & (ADY == 1) & ANRIND != "" )


# Get population counts
arm_pop <-
  dp %>%
  distinct(USUBJID, TRTA) %>%
  count(TRTA) %>% deframe() %>% put()


# Calculate AE Counts and Percents ----------------------------------------

sep("Prepare calculations")

# Get counts and percents
df1 <- dp %>%
  group_by(TRTA, PARCAT1, PARAM, ANRIND) %>%
  summarize(cnt = n()) %>%
  pivot_wider(names_from = c(TRTA, ANRIND),
              values_from = cnt,
              values_fill = 0)

# Create column template with all expected ARM column names
col_template <- paste0(c(rep("ARM A_", 3), rep("ARM B_", 3),
                         rep("ARM C_", 3), rep("ARM D_", 3)),
                       rep(c('Low', 'Normal', 'High'), 3))

# Fill any empty columns with zeros
for (nm in col_template) {
  if (!nm %in% names(df1))
    df1[[nm]] <- 0
}

# Format final data frame
final <- df1 %>%
  transmute(PARCAT1 = PARCAT1,
            PARAM = str_to_title(PARAM),
            `ARM A_Low` = fmt_cnt_pct(`ARM A_Low`, arm_pop["ARM A"]),
#           `ARM A_Normal` = fmt_cnt_pct(`ARM A_Normal`, arm_pop["ARM A"]),
            `ARM A_High` = fmt_cnt_pct(`ARM A_High`, arm_pop["ARM A"]),
            `ARM B_Low` = fmt_cnt_pct(`ARM B_Low`, arm_pop["ARM B"]),
#           `ARM B_Normal` = fmt_cnt_pct(`ARM B_Normal`, arm_pop["ARM B"]),
            `ARM B_High` = fmt_cnt_pct(`ARM B_High`, arm_pop["ARM B"]),
            `ARM C_Low` = fmt_cnt_pct(`ARM C_Low`, arm_pop["ARM C"]),
#           `ARM C_Normal` = fmt_cnt_pct(`ARM C_Normal`, arm_pop["ARM C"]),
            `ARM C_High` = fmt_cnt_pct(`ARM C_High`, arm_pop["ARM C"]),
            `ARM D_Low` = fmt_cnt_pct(`ARM D_Low`, arm_pop["ARM D"]),
#           `ARM D_Normal` = fmt_cnt_pct(`ARM D_Normal`, arm_pop["ARM D"]),
            `ARM D_High` = fmt_cnt_pct(`ARM D_High`, arm_pop["ARM D"])) %>%
  ungroup() %>%
  put()



# Print Report ------------------------------------------------------------


sep("Create Table")

tbl <- create_table(final, first_row_blank = TRUE) %>%
  spanning_header("ARM A_Low", "ARM A_High", label = "ARM A", n = arm_pop["ARM A"]) %>%
  spanning_header("ARM B_Low", "ARM B_High", label = "ARM B", n = arm_pop["ARM B"]) %>%
  spanning_header("ARM C_Low", "ARM C_High", label = "ARM C", n = arm_pop["ARM C"]) %>%
  spanning_header("ARM D_Low", "ARM D_High", label = "ARM D", n = arm_pop["ARM D"]) %>%
  stub(vars = c("PARCAT1", "PARAM"), label = "Assay Type\n   Assay Name") %>%
  define(PARCAT1, blank_after = TRUE, label_row = TRUE) %>%
  define(PARAM, indent = .1) %>%
  define(`ARM A_Low`, align = "center", label = "Low") %>%
# define(`ARM A_Normal`, align = "center", label = "Normal") %>%
  define(`ARM A_High`, align = "center", label = "High") %>%
  define(`ARM B_Low`, align = "center", label = "Low", page_wrap = TRUE) %>%
# define(`ARM B_Normal`, align = "center", label = "Normal") %>%
  define(`ARM B_High`, align = "center", label = "High") %>%
  define(`ARM C_Low`, align = "center", label = "Low", page_wrap = TRUE) %>%
# define(`ARM C_Normal`, align = "center", label = "Normal") %>%
  define(`ARM C_High`, align = "center", label = "High") %>%
  define(`ARM D_Low`, align = "center", label = "Low", page_wrap = TRUE) %>%
# define(`ARM D_Normal`, align = "center", label = "Normal") %>%
  define(`ARM D_High`, align = "center", label = "High")

rpt <- create_report("output/Table_ex4.txt", orientation = "portrait") %>%
  page_header("Client: Anova", "Study: ABC") %>%
  titles("Table 4.0", "Abnormal Lab Flag Summary") %>%
  add_content(tbl) %>%
  page_footer(Sys.time(), "Confidential", "Page [pg] of [tpg]")

write_report(rpt) %>% put()

