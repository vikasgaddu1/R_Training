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


base_path <- "_data/abc/CRF/"
out_path <- "_data/abc/SDTM/"

put("Read DM")
raw_dm <- 
  read_csv(file.path(base_path, "DM.csv"), 
           col_types = cols(BIRTHDT = col_date(format = "%d%b%Y"))) %>% 
  put()

put("Read TV")
raw_tv <- 
  read_csv(file.path(base_path, "TV.csv"), 
           col_types = cols(SVDT = col_date("%d%b%Y"))) %>% 
  put()

put("Read IC")
raw_ic <- 
  read_csv(file.path(base_path, "IC.csv"), 
           col_types =  cols(ICDT = col_date("%d%b%Y"))) %>% 
  put()

put("Read AESR")
raw_aesr <- 
  read_csv(file.path(base_path, "AESR.csv"), 
           col_types = cols(AESTDT = col_date("%d%b%Y"))) %>% 
  put()

put("Read RANPOP")
ranpop <- read_rds(file.path(out_path, "RANPOP.rds")) %>% put()


# Prepare Data ------------------------------------------------------------

sep("Perform subsetting on datasets")

put("Select needed columns from DM.")
dat_dm <- raw_dm %>% select(STUDYID, SUBJECT, VISIT, BIRTHDT, 
                            ETHNIC, RACE, SEX) %>% put()

put("Select needed columns from TV.")
dat_tv <- raw_tv %>% select(STUDYID, SUBJECT, VISIT, SVDT) %>% put()
  
put("Select needed columns from IC")
dat_ic <- raw_ic %>% select(STUDYID, SUBJECT, ICDT) %>% put()

put("Select needed columns and rows from AESR.")
dat_aesr <- raw_aesr %>% select(STUDYID, SUBJECT, AESTDT, AEOUT) %>% 
  filter(AEOUT == 3) %>% put()

sep("Join CRF datasets")


by_condition <- c("STUDYID" = "STUDYID", "SUBJECT" = "SUBJECT")

put("Combine subsetted data.")
dat_combined <- dat_dm %>% 
  left_join(dat_ic, by = by_condition) %>% 
  left_join(dat_aesr, by = by_condition) %>% 
  left_join(select(filter(dat_tv, VISIT == "day1"), STUDYID, SUBJECT, RFSTDTC = SVDT), 
            by = by_condition) %>% 
  left_join(select(filter(dat_tv, VISIT == "eoset"), STUDYID, SUBJECT, RFENDTC = SVDT), 
            by = by_condition) %>% 
  left_join(ranpop, by = by_condition) %>% 
  put()


# Prepare Formats ---------------------------------------------------------


sep("Load format catalog")


pth <- "./_data/abc/sdtm_fmts.fcat" %>% put()

sdtm_fmts <- read.fcat(pth) %>% put()


# Create Final Data Frame -------------------------------------------------



sep("Add and modify columns from combined data frame.")

  
put("Create final data frame")

dat_final <- dat_combined %>% 
  transmute(STUDYID, 
            DOMAIN = "DM", 
            USUBJID = paste0(STUDYID, "-", SUBJECT), 
            SUBJID = substring(SUBJECT, nchar(SUBJECT) - 2),
            RFSTDTC,
            RFENDTC,
            RFXSTDTC = as.Date(NA),
            RFXENDTC = as.Date(NA), 
            RFICDTC = ICDT,
            RFPENDTC = RFENDTC,
            DTHDTC = AESTDT,
            DTHFL = ifelse(AEOUT == 3, "Y", NA),
            SITEID = str_sub(SUBJECT, 1, 2),
            BRTHDTC = BIRTHDT, 
            AGE = floor(as.integer(RFSTDTC - BRTHDTC) / 365.25),
            AGEU = "YEARS",
            SEX = fapply(SEX, sdtm_fmts$SEX),
            RACE = fapply(RACE, sdtm_fmts$RACE),
            ETHNIC = fapply(ETHNIC, sdtm_fmts$ETHNIC),
            ARMCD = ifelse(!is.na(TREATMENT), TREATMENT, "SCRNFAIL"), 
            ARM = ifelse(ARMCD == "SCRNFAIL", "SCREEN FAILURE",
                         fapply(TREATMENT, sdtm_fmts$ARM_CD)),
            ACTARMCD = as.character(NA),
            ACTARM = as.character(NA),
            COUNTRY = as.character(NA)) %>% 
  arrange(USUBJID) %>% 
  put()
            
            
# view(dat_final)    

# Save to file
write_rds(dat_final, file.path(out_path, "DM.rds"))



# Compare to Reference Dataset --------------------------------------------

qc_pth <- "./_data/abc/SDTM/DM.csv"

dat_qc <- 
  read_csv(qc_pth, 
           col_types = cols(TRTSDT = col_date(format = "%d%b%Y"),
                            TRTEDT = col_date(format = "%d%b%Y"),
                            TR01SDT = col_date(format = "%d%b%Y"),
                            DTHDTC = col_date(format = "%d%b%Y"),
                            RFXENDTC = col_date(format = "%d%b%Y"),
                            RFXSTDTC = col_date(format = "%d%b%Y"),
                            COUNTRY = col_character(), 
                            ACTARM = col_character(), 
                            ACTARMCD = col_character(), 
                            TR01EDT = col_character(), 
                            INCNDT = col_character(),
                            RANDDT = col_character(), 
                            DTHDT = col_character())) %>% 
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


