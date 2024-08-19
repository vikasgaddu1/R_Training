library(tidyverse)
library(fmtr)
library(logr)
library(readxl)
library(tidylog, warn.conflicts = FALSE)

options("tidylog.display" = list(log_print))


log_open("adam_fmts", show_notes = FALSE)


# Read in Excel -----------------------------------------------------------

sep("Read in Codelist from specs")

file_path <- "./specs/ADaM_Specs.xlsx"

codelists <- read_excel(file_path, sheet = "Codelists", 
                        .name_repair = "universal") %>% 
  put()



# Prepare Data ------------------------------------------------------------



sep("Prepare final metadata")

codelists_final <- codelists %>% 
  transmute(Name = CTLIST,
            Type = "U", 
            Expression = str_c("x == '", SUBMISSION_VALUE, "'"),
            Label = DECODE,
            Order = NA) %>% 
  group_by(Name) %>% 
  mutate(Order = seq_along(Name)) %>% 
  ungroup() %>% 
  put()


# Create Format Catalog ---------------------------------------------------


sep("Create format catalog")


adam_fmts <- as.fcat(codelists_final) %>% put()


# Add ISO 8601 Date and Time formats
adam_fmts$ISO_DATE <- "%Y-%m-%d"
adam_fmts$ISO_TIME <- "%H:%M:%S"
adam_fmts$ISO_DATETIME <- "%Y-%m-%dT%H:%M:%S"


write.fcat(adam_fmts, dir_path = "./data/abc") %>% put()



# Clean Up ----------------------------------------------------------------



log_close()
options("tidylog.display" = NULL)




