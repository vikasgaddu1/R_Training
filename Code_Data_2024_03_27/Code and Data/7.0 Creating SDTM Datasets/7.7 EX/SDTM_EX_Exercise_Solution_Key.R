# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(readr)
library(lubridate)
library(janitor)
library(logr)
library(fmtr)
library(arsenal)
library(diffdf)
library(tidylog, warn.conflicts = FALSE)

options("tidylog.display" = list(log_print))

log_open("EX", show_notes = FALSE)

sep("Set up paths to raw data area and SDTM data area.")

base_path <- "data/abc/CRF/"
out_path <- "data/abc/SDTM/"

# convert month abbreviations to a month number.
mon2num <- function(invar) {

ret <-
  case_when(invar == "JAN" ~ "01",
            invar == "FEB" ~ "02",
            invar == "MAR" ~ "03",
            invar == "APR" ~ "04",
            invar == "MAY" ~ "05",
            invar == "JUN" ~ "06",
            invar == "JUL" ~ "07",
            invar == "AUG" ~ "08",
            invar == "SEP" ~ "09",
            invar == "OCT" ~ "10",
            invar == "NOV" ~ "11",
            invar == "DEC" ~ "12",
            TRUE ~ as.character(NA)
           )

  return(ret)
}

# Prepare Formats ---------------------------------------------------------
sep("Load format catalog")
fc <- read.fcat("data/abc/sdtm_fmts.fcat") %>% 
  put()

# Import Data ------------------------------------------------------------
put("Read RANPOP")
ranpop <- readRDS(file.path(out_path, "RANPOP.rds")) %>% 
  mutate(USUBJID   = paste0(STUDYID, '-', SUBJECT)) %>% 
  select(STUDYID, USUBJID, TREATMENT)

put("Read SV")
sv <- readRDS(file.path(out_path, "SV.rds")) %>% 
  filter(VISITNUM == 1) %>% 
  select(STUDYID, USUBJID, SVSTDTC)

put("Read COMPLY")
raw_comply <-
  read_csv(file.path(base_path, "COMPLY.csv"),
           col_types = cols(ENDDT1 = col_date("%d%b%Y"),
                            ENDDT2 = col_date("%d%b%Y"),
                            ENDDT3 = col_date("%d%b%Y"))) %>%
  mutate(ENDMON1 = case_when(ENDMON1 == "DASH" | ENDMON1 == "." | 
                             ENDMON1 == "" ~ as.character(NA),
                             TRUE ~ mon2num(ENDMON1)),
         ENDMON2 = case_when(ENDMON2 == "DASH" | ENDMON2 == "." | 
                             ENDMON2 == "" ~ as.character(NA),
                             TRUE ~ mon2num(ENDMON2)), 
         ENDMON3 = case_when(ENDMON3 == "DASH" | ENDMON3 == "." | 
                             ENDMON3 == "" ~ as.character(NA),
                             TRUE ~ mon2num(ENDMON3)),
         ENDDD1 = case_when(ENDDD1 == 86 | is.na(ENDDD1)  ~ as.numeric(NA),
                             TRUE ~ (ENDDD1)),
         ENDDD2 = case_when(ENDDD2 == 86 | is.na(ENDDD2)  ~ as.numeric(NA),
                            TRUE ~ (ENDDD2)),
         ENDDD3 = case_when(ENDDD3 == 86 | is.na(ENDDD3)  ~ as.numeric(NA),
                            TRUE ~ (ENDDD3))) %>% 
  filter(!is.na(ENDDT1)  |  !is.na(ENDDT2)  | !is.na(ENDDT3) |
         !is.na(ENDMON1) |  !is.na(ENDMON2) | !is.na(ENDMON3) |   
         !is.na(ENDYY1)  |  !is.na(ENDYY2)  | !is.na(ENDYY3))   

put("Prepare dataset")
comply_prep0 <- 
  raw_comply %>% 
  mutate(part_enddt = case_when(is.na(ENDDT1) & !is.na(ENDYY1) & !is.na(ENDMON1) &
                                ENDYY1 >= ENDYY2 & ENDYY1 >= ENDYY3 & 
                                ENDMON1 >= ENDMON2 & ENDMON1 >= ENDMON3
                                ~ paste0(as.character(ENDYY1), "-", ENDMON1),
                                is.na(ENDDT2) & !is.na(ENDYY2) & !is.na(ENDMON2) &
                                  ENDYY2 >= ENDYY1 & ENDYY2 >= ENDYY3 & 
                                  ENDMON2 >= ENDMON1 & ENDMON2 >= ENDMON3
                                ~ paste0(as.character(ENDYY2), "-", ENDMON2),
                                is.na(ENDDT3) & !is.na(ENDYY3) & !is.na(ENDMON3) &
                                  ENDYY3 >= ENDYY1 & ENDYY3 >= ENDYY2 & 
                                  ENDMON3 >= ENDMON1 & ENDMON3 >= ENDMON2
                                ~ paste0(as.character(ENDYY3), "-", ENDMON3),
                                is.na(ENDDT1) & !is.na(ENDYY1) & is.na(ENDMON1) &
                                  ENDYY1 >= ENDYY2 & ENDYY1 >= ENDYY3
                                ~ as.character(ENDYY1),
                                is.na(ENDDT2) & !is.na(ENDYY2) & is.na(ENDMON2) &
                                  ENDYY2 >= ENDYY1 & ENDYY2 >= ENDYY3
                                ~ as.character(ENDYY2),
                                is.na(ENDDT3) & !is.na(ENDYY3) & is.na(ENDMON3) &
                                  ENDYY3 >= ENDYY1 & ENDYY3 >= ENDYY2
                                ~ as.character(ENDYY3)
            ))  %>% 
  rowwise() %>% 
  mutate(EXENDT  = max(ENDDT1, ENDDT2, ENDDT3)) %>% 
  mutate(EXENDTC = case_when(is.na(as.Date(EXENDT)) ~ part_enddt,
                             TRUE ~ as.character(EXENDT))) 
  
put("Prepare dataset")
comply_prep1 <-
  comply_prep0 %>% 
  transmute(STUDYID     = STUDYID,
            DOMAIN      = "EX",
            USUBJID     = paste0(STUDYID, '-', SUBJECT),
            EXDOSE      = NA,
            EXDOSTXT    = "0-15",
            EXDOSU      = "ug/g",
            EXDOSFRM    = "CREAM",
            EXENDTC     = EXENDTC) %>%
  inner_join(ranpop, by=c("STUDYID", "USUBJID"))     %>% 
  inner_join(sv, by=c("STUDYID", "USUBJID")) %>% 
  mutate(EXTRT = case_when(TREATMENT == "1" ~ "ARM A",
                           TREATMENT == "2" ~ "ARM B",
                           TREATMENT == "3" ~ "ARM C",
                           TREATMENT == "4" ~ "ARM D",
                           TRUE ~ as.character(NA)),
#   EXTRT   = fapply(TREATMENT, fc$ARM_CD),
         EXSTDTC = SVSTDTC) %>% 
  select( -TREATMENT, -SVSTDTC)

put("Create Final dataset")
 
ex_final <-
  comply_prep1 %>% 
  arrange(USUBJID, EXTRT) %>% 
  group_by(USUBJID) %>% 
  mutate(EXSEQ = as.numeric(seq_along(USUBJID))) %>% 
  ungroup() %>% 
  select(STUDYID, DOMAIN, USUBJID, EXSEQ, EXTRT, EXDOSE, 
         EXDOSTXT, EXDOSU, EXDOSFRM, EXSTDTC, EXENDTC )

put("SAve RDS")
saveRDS(ex_final, 'data/abc/SDTM/ex.rds')

# Compare to Reference Dataset --------------------------------------------

qc_ex <- "data/abc/SDTM/EX.csv"

qc_ex <- 
  read_csv(qc_ex) %>% 
  mutate(EXSTDTC = as.character(EXSTDTC)) %>% 
  put()

diff1 <- anti_join(ex_final, qc_ex) %>% put()

diff2 <- comparedf(ex_final, qc_ex) %>% put()


if (nrow(diff1) == 0) {
  put("NOTE: Final data frame and QC are identical.")
} else {
  put("WARNING: Differences found between final data frame and QC", msg = TRUE)
  
  summary(comparedf(ex_final, qc_ex)) %>% put()
}

diff <-
  diffdf(ex_final, qc_ex)

identical(ex_final,qc_ex)


# Clean Up ----------------------------------------------------------------

log_close()
options("tidylog.display" = NULL)
