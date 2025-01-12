setwd("/cloud/project/Code_Data_2024_03_27/Code and Data/4.0 Tidyverse Data Manipulation")
library(tidyverse)
file_dm <- file.path('_data','dm.csv')
spec_csv(file_dm)

dm_allvars <- read_csv(file = file_dm)
glimpse(dm_allvars)
str(dm_allvars)

coldefs <- cols(   
  USUBJID = col_character(),   
  SUBJID  = col_integer(),   
  BRTHDTC = col_date(format = ""),   
  AGE     = col_integer(),   
  SEX     = col_factor(levels = c("M", "F", include_na = TRUE)),   
  RACE    = col_character(),   
  ARM     = col_character())

dm_somevars <- read_csv(file_dm,
                        col_names = T, 
                        col_types = coldefs,
                        col_select = c('USUBJID','AGE','SEX'),
                        n_max = 5)

write_csv(dm_somevars,'_data/dm_subset.csv')


library(writexl)

mult_sheet <- list('sh1' = dm_allvars,
                   'sh2' = dm_somevars)

write_xlsx(mult_sheet,'_data/multiple_dm.xlsx')

library(readxl)

abc_data_dict <- read_excel('_data/study abc data dictionary.xlsx')


library(haven)

dm_sasds <- read_sas('_data/dm.sas7bdat',
               col_select = c(USUBJID, SUBJID, BRTHDTC, AGE, SEX, RACE,ARM))

library(labelled)

var_label(dm_sasds)

var_label(dm_sasds) <- list(BRTHDTC = "Date of Birth",
                            ARM = "Treatment Group")

dm_vl <- unlist(var_label(dm_sasds))

write_rds(dm_sasds, '_data/dm_r.rds')
