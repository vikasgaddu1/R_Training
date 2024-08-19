# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(readr)
library(logr)
library(fmtr)
library(diffdf)
library(tidylog, warn.conflicts = FALSE)

options("tidylog.display" = list(log_print))

log_open("DM", show_notes = FALSE)


# Import Data ------------------------------------------------------------

sep("Read Needed CRF Data")


base_path <- "data/abc/CRF/"
out_path <- "data/abc/SDTM/"

put("Read DM")
raw_dm <- 
  read_csv(file.path(base_path, "DM.csv"), 
           col_types = cols(BIRTHDT = col_date(format = "%d%b%Y"))) %>% 
  put()

put("Read TV")


put("Read IC")


put("Read AESR")


put("Read RANPOP")
ranpop <- read_rds(file.path(out_path, "RANPOP.rds")) %>% put()


# Prepare Data ------------------------------------------------------------

sep("Perform subsetting on datasets")

put("Select needed columns from DM.")
dat_dm <- raw_dm %>% select(STUDYID, SUBJECT, VISIT, BIRTHDT, 
                            ETHNIC, RACE, SEX) %>% put()

put("Select needed columns from TV.")

put("Select needed columns from IC")

put("Select needed columns and rows from AESR.")
dat_aesr <- raw_aesr %>% select(STUDYID, SUBJECT, AESTDT, AEOUT) %>% 
  filter(AEOUT == 3) %>% put()

sep("Join CRF datasets")


by_condition <- c("STUDYID" = "STUDYID", "SUBJECT" = "SUBJECT")

put("Combine subsetted data.")



# Prepare Formats ---------------------------------------------------------


sep("Load format catalog")


pth <- "./data/abc/sdtm_fmts.fcat" %>% put()

sdtm_fmts <- read.fcat(pth) %>% put()


# Create Final Data Frame -------------------------------------------------



sep("Add and modify columns from combined data frame.")


put("Create final data frame")

dat_final <- dat_combined  # %>%  Create dat_final here


# view(dat_final)    

# Save to file
write_rds(dat_final, file.path(out_path, "DM.rds"))



# Compare to Reference Dataset --------------------------------------------

qc_pth <- "./data/abc/SDTM/DM.csv"

dat_qc <- 
  read_csv(qc_pth, 
           col_types = cols(DTHDTC = col_date(format = "%d%b%Y"),
                            RFXSTDTC = col_date(format = "%d%b%Y"),
                            RFXENDTC = col_date(format = "%d%b%Y"),
                            ACTARM = col_character(), 
                            ACTARMCD = col_character(),
                            ARMCD = col_character(), 
                            COUNTRY = col_character())) %>% 
  put()



diff1 <- anti_join(dat_final, dat_qc) %>% put()
diffdf(dat_final, dat_qc) %>% put()

if (nrow(diff1) == 0) {
  put("NOTE: Final data frame and QC are identical.")
} else {
  put("WARNING: Differences found between final data frame and QC", msg = TRUE)
  
}



# Clean Up ----------------------------------------------------------------


log_close()
options("tidylog.display" = NULL)


