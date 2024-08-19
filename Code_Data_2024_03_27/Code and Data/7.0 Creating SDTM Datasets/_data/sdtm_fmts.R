library(tidyverse)
library(fmtr)
library(logr)
library(readxl)
library(tidylog, warn.conflicts = FALSE)

options("tidylog.display" = list(log_print))


log_open("sdtm_fmts", show_notes = FALSE)


# Read in Excel -----------------------------------------------------------

sep("Read in Codelists from specs")

put("Read codelists sheet")
file_path <- "./specs/SDTM_Specs_Clean.xlsx"

codelists <- read_excel(file_path, sheet = "Codelists", 
                        .name_repair = "universal") %>% 
  filter(!is.na(CRF.Value)) %>% 
  put()


put("Read value lists sheet")
vs_valuelists <- read_excel(file_path, sheet = "ValueLevel", 
                            .name_repair = "universal") %>% 
  filter(DATASET == "VS" | DATASET == "SV", !is.na(CTVALUE)) %>% 
  select(DATASET, VARIABLE, CONDITIONAL_VALUE1, CTVALUE) %>% 
  arrange(VARIABLE) %>% 
  put()


# Prepare Data ------------------------------------------------------------



sep("Make modifications to CRF Value column")

codelists_mod <- codelists %>% 
  mutate(CRF.Value = 
           case_when(CTLIST == "NCOMPLT" & SUBMISSION_VALUE == "COMPLETED" ~ "x == 0 | x == 1",
                     CTLIST == "VISIT" & SUBMISSION_VALUE == "SCREENING" ~ "x == \"screen\"",
                     CTLIST == "VISIT" & SUBMISSION_VALUE == "DAY 1" ~ "x == \"day1\"",
                     CTLIST == "VISIT" & SUBMISSION_VALUE == "WEEK 2" ~ "x == \"wk2\"",
                     CTLIST == "VISIT" & SUBMISSION_VALUE == "WEEK 4" ~ "x == \"wk4\"",
                     CTLIST == "VISIT" & SUBMISSION_VALUE == "WEEK 6" ~ "x == \"wk6\"",
                     CTLIST == "VISIT" & SUBMISSION_VALUE == "WEEK 8" ~ "x == \"wk8\"",
                     CTLIST == "VISIT" & SUBMISSION_VALUE == "WEEK 12" ~ "x == \"wk12\"",
                     CTLIST == "VISIT" & SUBMISSION_VALUE == "WEEK 16" ~ "x == \"wk16\"",
                     CTLIST == "VISIT" & SUBMISSION_VALUE == "END OF STUDY EARLY TERMINATION" ~ "x == \"eoset\"",
                     TRUE ~ str_c("x == ", CRF.Value))) %>% 
  put()


sep("Prepare final metadata")

put("Create codelist data frame")
codelists_final <- codelists_mod %>% 
  transmute(Name = CTLIST,
            Type = "U", 
            Expression = CRF.Value,
            Label = SUBMISSION_VALUE,
            Order = NA) %>% 
  group_by(Name) %>% 
  mutate(Order = seq(Name)) %>% 
  ungroup() %>% put()


put("Create valuelists data frame")
vs_valuelists_final <- vs_valuelists %>% 
  transmute(Name = VARIABLE,
            Type = "U", 
            Expression = str_c("x == '", CONDITIONAL_VALUE1, "'"),
            Label = CTVALUE,
            Order = NA) %>% 
  group_by(Name) %>% 
  mutate(Order = seq_along(Name)) %>% 
  put()

put("Combine codelists and valuelists")
final <- bind_rows(codelists_final, vs_valuelists_final)

# Create Format Catalog ---------------------------------------------------



sep("Create format catalog")


sdtm_fmts <- as.fcat(final) %>% put()


# Add ISO 8601 Date and Time formats
sdtm_fmts$ISO_DATE <- "%Y-%m-%d"
sdtm_fmts$ISO_TIME <- "%H:%M:%S"
sdtm_fmts$ISO_DATETIME <- "%Y-%m-%dT%H:%M:%S"


write.fcat(sdtm_fmts, dir_path = "./data/abc") %>% put()



# Clean Up ----------------------------------------------------------------



log_close()
options("tidylog.display" = NULL)



