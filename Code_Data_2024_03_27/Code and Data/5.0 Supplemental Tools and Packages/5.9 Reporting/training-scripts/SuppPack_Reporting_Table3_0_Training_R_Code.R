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

log_open("Table3_0")


# Prepare Data ------------------------------------------------------------


sep("Read ADAE data")

dp <- "./5.14 Reporting/ADAE.csv"

# Read in AE data from CSV
dat <- read_csv(dp) %>% put()

dat %>% glimpse() %>% put()

# Subset ADSL for needed rows and columns
df_sub <- dat %>% filter(SAFFL == "Y") %>% 
  select(TRTA, AESEV, AESEVN, AEREL, AESOC, AEDECOD) 

# Get population counts
arm_pop <- df_sub %>% count(TRTA) %>% deframe() %>% put()


# Calculate AE Counts and Percents ----------------------------------------

sep("Prepare calculations")

# Get counts and percents 
df1 <- df_sub %>% 
  select(-AESEV, -AEREL) %>% 
  group_by(TRTA, AESOC, AEDECOD, AESEVN) %>% 
  summarize(cnt = n()) %>% 
  pivot_wider(names_from = c(TRTA, AESEVN),
              values_from = cnt, 
              values_fill = 0)

# Create column template with all expected ARM column names
col_template <- paste0(c(rep("ARM A_", 3), rep("ARM B_", 3), 
                         rep("ARM C_", 3), rep("ARM D_", 3)), 
                       rep(c(1, 2, 3), 3))

# Fill any empty columns with zeros
for (nm in col_template) {
  if (!nm %in% names(df1))
    df1[[nm]] <- 0
}

# Format final data frame
final <- df1 %>% 
  transmute(AESOC = AESOC, 
            AEDECOD = str_to_title(AEDECOD),
         `ARM A_1` = fmt_cnt_pct(`ARM A_1`, arm_pop["ARM A"]),
         `ARM A_2` = fmt_cnt_pct(`ARM A_2`, arm_pop["ARM A"]),
         `ARM A_3` = fmt_cnt_pct(`ARM A_3`, arm_pop["ARM A"]),
         `ARM B_1` = fmt_cnt_pct(`ARM B_1`, arm_pop["ARM B"]),
         `ARM B_2` = fmt_cnt_pct(`ARM B_2`, arm_pop["ARM B"]),
         `ARM B_3` = fmt_cnt_pct(`ARM B_3`, arm_pop["ARM B"]),
         `ARM C_1` = fmt_cnt_pct(`ARM C_1`, arm_pop["ARM C"]),
         `ARM C_2` = fmt_cnt_pct(`ARM C_2`, arm_pop["ARM C"]),
         `ARM C_3` = fmt_cnt_pct(`ARM C_3`, arm_pop["ARM C"]),
         `ARM D_1` = fmt_cnt_pct(`ARM D_1`, arm_pop["ARM D"]), 
         `ARM D_2` = fmt_cnt_pct(`ARM D_2`, arm_pop["ARM D"]), 
         `ARM D_3` = fmt_cnt_pct(`ARM D_3`, arm_pop["ARM D"])) %>% 
  ungroup() %>% 
  put()



# Print Report ------------------------------------------------------------


sep("Create Table")

tbl <- create_table(final, first_row_blank = TRUE) %>% 
  spanning_header(from = "ARM A_1", to = "ARM A_3", label = "ARM A", n = arm_pop["ARM A"]) %>% 
  spanning_header(from = "ARM B_1", to = "ARM B_3", label = "ARM B", n = arm_pop["ARM B"]) %>% 
  spanning_header(from = "ARM C_1", to = "ARM C_3", label = "ARM C", n = arm_pop["ARM C"]) %>% 
  spanning_header(from = "ARM D_1", to = "ARM D_3", label = "ARM D", n = arm_pop["ARM D"]) %>% 
  stub(vars = c("AESOC", "AEDECOD"), label = "System Organ Class\n   Preferred Term") %>% 
  define(AESOC, blank_after = TRUE, label_row = TRUE) %>% 
  define(AEDECOD, indent = .25) %>% 
  define(`ARM A_1`, align = "center", label = "Mild") %>% 
  define(`ARM A_2`, align = "center", label = "Moderate") %>% 
  define(`ARM A_3`, align = "center", label = "Severe") %>% 
  define(`ARM B_1`, align = "center", label = "Mild", page_wrap = TRUE) %>% 
  define(`ARM B_2`, align = "center", label = "Moderate") %>% 
  define(`ARM B_3`, align = "center", label = "Severe") %>% 
  define(`ARM C_1`, align = "center", label = "Mild", page_wrap = TRUE) %>% 
  define(`ARM C_2`, align = "center", label = "Moderate") %>% 
  define(`ARM C_3`, align = "center", label = "Severe") %>% 
  define(`ARM D_1`, align = "center", label = "Mild", page_wrap = TRUE) %>% 
  define(`ARM D_2`, align = "center", label = "Moderate") %>% 
  define(`ARM D_3`, align = "center", label = "Severe") 

rpt <- create_report("output/Table3_0.txt") %>% 
  page_header("Client: Anova", "Study: BBC") %>% 
  titles("Table 3.0", "Adverse Events by Severity", "Safety Population") %>% 
  add_content(tbl) %>% 
  footnotes(paste("Date Produced:", Sys.time(), ";  SAS Program: Table3_0.R"),
            paste("* Total Reporting is defined as number of subjects", 
                  "who reported at least one adverse event."),
            paste("# Episodes is defined as the total number of occurances",
                  "of adverse events"),
            paste("% is defined as Number of Subjects divided by Total Reporting"),
            "Note: Adverse events were coded using MedDRA Version 9.1") %>% 
  page_footer(Sys.time(), "Confidential", "Page [pg] of [tpg]")

write_report(rpt) %>% put()



# Clean Up ----------------------------------------------------------------


log_close()

options("tidylog.display" = NULL)

