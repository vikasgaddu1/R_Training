# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(diffdf)
library(fmtr)
library(logr)
library(reporter)
library(stringr)
library(tidylog, warn.conflicts = FALSE)

# Attach loggers
options("tidylog.display" = list(log_print), 
        "logr.on" = TRUE,
        "logr.notes" = FALSE)

# Open Log
log_path <- log_open("Table2_0")


# Prepare Data ------------------------------------------------------------


sep("Prepare table data")


put("Read in ADAE")
dat <- read.csv("data/abc/ADaM/ADAE.csv") %>% 
  filter(SAFFL == 'Y') %>% 
  put()


put("Get population counts")
arm_pop <- dat  %>% 
  select(USUBJID, TRTA) %>%  
  distinct() %>% 
  count(TRTA)  %>% 
  deframe() %>% put()

put("Subset ADAE for needed rows and columns")
df_sub <- dat %>% 
  select(USUBJID, TRTA, AESEV, AESEVN, AESOC, AEDECOD) %>% 
  distinct() %>% 
  put()


# Perform Calculations ----------------------------------------------------


put("Create template for needed ARM columns")
col_template <- paste0(c(rep("ARM A_", 3), rep("ARM B_", 3), rep("ARM C_", 3),
                         rep("ARM D_", 3)), rep(c(1, 2, 3), 3))



put("Identify and count highest severity grade for each subject")
df1 <- df_sub %>% arrange(USUBJID, AESOC, AEDECOD, AESEVN) %>% 
  group_by(USUBJID, TRTA, AESOC, AEDECOD) %>% 
  mutate(max_sev = ifelse(row_number() == n(), TRUE, FALSE)) %>% 
  filter(max_sev == TRUE) %>% 
  group_by(TRTA, AESOC, AEDECOD, AESEVN) %>% 
  summarize(cnt = n()) %>% 
  pivot_wider(names_from = c(TRTA, AESEVN),
              values_from = cnt, 
              values_fill = 0) %>% 
  put()


put("Fill in missing columns where there were no events.")
for (nm in col_template) {
  if (!nm %in% names(df1))
    df1[[nm]] <- 0
}
put(df1)

put("Format counts and percents for each column")
df_events <- df1 %>% 
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
  arrange(AESOC, AEDECOD) %>% 
  ungroup() %>% 
  put()


put("Get counts for All Adverse Events")
df2 <- df_sub %>% 
  select(USUBJID, TRTA, AESEVN) %>% 
  arrange(USUBJID, AESEVN) %>% 
  group_by(USUBJID) %>% 
  mutate(max_sev = ifelse(row_number() == n(), TRUE, FALSE)) %>% 
  filter(max_sev == TRUE) %>% 
  group_by(TRTA, AESEVN) %>% 
  summarize(cnt = n()) %>% 
  pivot_wider(names_from = c(TRTA, AESEVN),
              values_from = cnt, 
              values_fill = 0) %>% 
  ungroup() %>% 
  put()

put("Fill in missing columns where there were no events.")
for (nm in col_template) {
  if (!nm %in% names(df2))
    df2[[nm]] <- 0
}
put(df2)

put("Format counts and percents for all adverse events.")
df_all <- df2 %>% 
  transmute(AESOC = "All System Organ Classes",
            AEDECOD = "All Adverse Events", 
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
  put()


# Final Data --------------------------------------------------------------

sep("Create final data frame")

final <- bind_rows(df_all, df_events) %>% put()


# Print Report ----------------------------------------------------------

sep("Create and print report")

put("Create table object")
# < Add create_table function here >


put("Create report object")
# < Add create_report function here >

put("Print report")
write_report(rpt) %>% put()



# Clean Up ----------------------------------------------------------------


log_close()

options("tidylog.display" = NULL)


