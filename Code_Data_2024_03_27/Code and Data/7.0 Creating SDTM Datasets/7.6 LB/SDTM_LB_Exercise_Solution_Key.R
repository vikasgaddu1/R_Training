# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(readr)
library(lubridate)
library(janitor)

# Set up a path to the raw data area.
crf_path <- "data/abc/CRF/"

# Read the LAB.csv file
lab <- 
  read_csv(file.path(crf_path, "LAB.csv")) 
         
# Collapse records down to one comment.
# Add dateofbirth and col_datetime variables.
# Alter EVENT value for values of COMMENT that contain the word repeat
lab2 <- 
  lab %>% 
  pivot_wider(id_cols = c("PROTOCOL", "EVENT",  "SITE", "SUBNUM", "SEX",
                         "DOB", "PATEVENT", "ACCESNUM", "COL_DT", "ORDCODE",
                         "ORDNAME",  "RESLTCOD", "ANALYTE", "RESLTVAL",
                         "UNIT",     "RESLTFLG", "LOWRNGE", "HIGHRNGE"),
              names_from   = COMMSEQ,
              values_from  = COMMENT,
              names_prefix = "COMMENT",
              values_fill  = "") %>% 
  mutate(COMMENT = str_squish(str_c(COMMENT1, COMMENT2, COMMENT3, COMMENT4, COMMENT5,
                              COMMENT6, COMMENT7, COMMENT8, COMMENT9, sep=" "))) %>% 
  mutate(col_dob = dmy(DOB),
         col_datetime = dmy_hms(COL_DT),
         EVENT = case_when(str_detect(tolower(COMMENT), "repeat") 
                           ~ "Unscheduled Visit",
                           TRUE ~ EVENT)) 

# Create mapping data frame for col_datetime and EVENT values for each SUBNUM.
# Create the new variable VISEVENT with the incremented number on UNSCHEDULED VISEVENTS.
ulv <- 
  lab2 %>% 
  select(SUBNUM, col_datetime, EVENT) %>%
  arrange(SUBNUM, col_datetime) %>% 
  group_by(SUBNUM, col_datetime, EVENT) %>% 
  slice_head(n = 1) %>% 
  ungroup() %>% 
  group_by(SUBNUM, EVENT) %>% 
  mutate(VISITEVENT = case_when(str_detect(EVENT, "Unsched") ~ 
                             paste0("UNSCHEDULED ", seq_along(SUBNUM)),
                           TRUE ~ EVENT)) %>% 
  ungroup()  %>% 
  arrange(SUBNUM, col_datetime)  

tabyl(ulv$VISITEVENT)

# Join the value VISEVENT onto the lab2 data frame.
lab3 <-
  lab2 %>% 
  inner_join(ulv, by = c("SUBNUM", "col_datetime", "EVENT"))

