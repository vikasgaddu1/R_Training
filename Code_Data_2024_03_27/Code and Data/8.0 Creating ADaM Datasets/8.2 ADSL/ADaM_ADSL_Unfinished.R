# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(readr)
library(lubridate)
library(janitor)
library(readxl)
library(logr)
library(fmtr)
library(arsenal)
library(diffdf)
library(tidylog, warn.conflicts = FALSE)

options("tidylog.display" = list(log_print))

log_open("ADSL", show_notes = FALSE)

sep("Set up paths to raw data area and SDTM data area.")

SDTM_path <- "data/abc/SDTM/"
ADaM_path <- "data/abc/ADaM/"

# Prepare Formats ---------------------------------------------------------
sep("Load format catalog")
fc_adam <- read.fcat("data/abc/adam_fmts.fcat") %>% 
  put()

# Import Data ------------------------------------------------------------

adam_specs_path <- "./specs/ADaM_Specs_Clean.xlsx"
adsl_valuelevel <- read_excel(adam_specs_path, sheet = "ValueLevel", 
                             .name_repair = "universal") %>% 
  filter(DATASET == "ADSL") %>% 
  put()
  
racen <-
  adsl_valuelevel %>% 
  filter(VARIABLE == "RACEN") %>% 
  transmute(RACE = CONDITIONAL_VALUE1,
            RACEN = as.numeric(CTVALUE))

ethnicn <-
  adsl_valuelevel %>% 
  filter(VARIABLE == "ETHNICN") %>% 
  transmute(ETHNIC = CONDITIONAL_VALUE1,
            ETHNICN = as.numeric(CTVALUE))

ie <-
  read_csv(file.path(SDTM_path, "IE.csv")) %>% 
  mutate(iedt = as_date(IEDTC),
         inie = "Y") %>% 
  select(USUBJID, IECAT, iedt, inie)


dm <- readRDS(file.path(SDTM_path, "DM.rds")) %>% 
  left_join(racen, by = "RACE") %>% 
  left_join(ethnicn, by = "ETHNIC") %>% 
  left_join(ie, by = "USUBJID") %>% 
  mutate(AGEGR1 = case_when(AGE >= 18 & AGE <= 29 ~ "18-29 years",
                            AGE >= 30 & AGE <= 39 ~ "30-39 years",
                            AGE >= 40 & AGE <= 49 ~ "40-49 years",
                            AGE >= 50 & AGE <= 65 ~ "50-65 years",
                            AGE > 65              ~ ">65 years",
                            TRUE ~ as.character(NA)),
         TRT01P = case_when(ARM != "SCREEN FAILURE" ~ ARM,
                            TRUE ~ as.character(NA)),
         TRT01PN = case_when(ARMCD != "SCRNFAIL" ~ as.numeric(ARMCD),
                             TRUE ~ as.numeric(NA)),
         TRT01A = case_when(ARM != "SCREEN FAILURE" ~ ARM,
                            TRUE ~ as.character(NA)),
         TRT01AN = case_when(ARMCD != "SCRNFAIL" ~ as.numeric(ARMCD),
                             TRUE ~ as.numeric(NA)),
         INCNFL  = case_when( !is.na(RFICDTC)  ~ "Y",
                              TRUE ~ "N"),
         RANDFL  = case_when( INCNFL == "Y" & (ARMCD == "1" | ARMCD == "2" | 
                                               ARMCD == "3" | ARMCD == "4") &
                              is.na(inie)                                      ~ "Y",
                              TRUE ~ "N")
  ) %>% 
  select(STUDYID, USUBJID, SUBJID, SITEID, AGE, AGEU, AGEGR1, SEX, 
         RACE, RACEN, ETHNIC, ETHNICN, COUNTRY, ARM, ACTARM,
         TRT01P, TRT01PN, TRT01A, TRT01AN, INCNFL, RANDFL, RFICDTC
  )


ex <- readRDS(file.path(SDTM_path, "ex.rds")) %>%
  select(USUBJID, EXSTDTC, EXENDTC, EXDOSTXT) %>% 
  mutate(inex = 1)

sv <- readRDS(file.path(SDTM_path, "SV.rds")) %>% 
  filter(VISITNUM == 1 | VISITNUM == 16) %>% 
  mutate(SVSTDTC = as_date(SVSTDTC)) %>% 
  select(USUBJID, VISITNUM, SVSTDTC) %>% 
  pivot_wider(id_cols = USUBJID,
              names_from = VISITNUM,
              values_from  = SVSTDTC,
              names_prefix = "VISIT")


ds <-
  read_csv(file.path(SDTM_path, "DS.csv")) %>% 
  mutate(ds_infcon    = case_when(DSDECOD == "INFORMED CONSENT OBTAINED" ~ 1,
                             TRUE ~ 0),
         ds_compvio = case_when(str_detect(DSTERM, "COMPLETED") == TRUE &
                                     str_detect(DSTERM, "VIOLATION")    ~ 1,
                                     TRUE ~ 0),
         ds_comp    = case_when(DSDECOD == "COMPLETED"  ~ 1,
                                     TRUE ~ 0)) %>% 
  group_by(USUBJID) %>% 
  summarize(ds_infconsent = sum(ds_infcon),
            ds_completed  = sum(ds_comp),
            ds_completedvio = sum(ds_compvio)) %>% 
  select(USUBJID, ds_infconsent, ds_completed, ds_completedvio) %>% 
  ungroup()

ds_disp <-
  read_csv(file.path(SDTM_path, "DS.csv")) %>% 
  filter(DSCAT == "DISPOSITION EVENT") %>% 
  select(USUBJID, DSTERM, DSDECOD)

qs <-
  read_csv(file.path(SDTM_path, "QS.csv")) %>% 
  filter(QSTESTCD == 'PSGA') %>% 
  left_join(ex, by = "USUBJID") %>% 
  select(USUBJID, VISITNUM, QSTESTCD, QSDTC, EXSTDTC, EXENDTC) %>% 
  mutate(MITTFLp = case_when(as_date(QSDTC) > as_date(EXSTDTC) &
                              as_date(QSDTC) <= as_date(EXENDTC) +3
                               ~ 1,
                              TRUE ~ 0)) %>% 
  group_by(USUBJID) %>% 
  summarize(MITTFLn = max(MITTFLp)) %>% 
  ungroup() 

suppex <-
  read_csv(file.path(SDTM_path, "SUPPEX.csv")) %>% 
  select(USUBJID, QNAM, QVAL) %>% 
  mutate(QNAMtype = case_when(str_detect(QNAM, "MD") == TRUE ~ "MD",
                              str_detect(QNAM, "RESUME") == TRUE ~ QNAM,
                              TRUE ~ as.character(NA)),
         QVALn = case_when(QNAMtype == "MD" ~ as.numeric(QVAL),
                           str_detect(QNAMtype, "RESUME") == TRUE & QVAL == "N"
                               ~ 0,
                           str_detect(QNAMtype, "RESUME") == TRUE & QVAL == "Y"
                               ~ 1,
                           TRUE ~ as.numeric(NA))) %>% 
  group_by(USUBJID, QNAMtype) %>% 
  summarize(MD_sum = sum(QVALn)) %>% 
  ungroup()

suppex_prep <-
  suppex %>% 
  pivot_wider(id_cols = USUBJID,
              names_from = QNAMtype,
              values_from  = MD_sum) %>% 
  mutate(insuppex = 1)

adsl_final <-
  left_join(dm, ex, by = "USUBJID") %>% 
  mutate(TRTSDT   = as_date(EXSTDTC),
         TRTEDT   = as_date(EXENDTC),
         TR01SDT  = as_date(EXSTDTC),
         TR01EDT  = as_date(EXENDTC),
         TRTDURN  = as.numeric(as_date(EXENDTC) - as_date(EXSTDTC) + 1), 
         TRTDURU  = case_when(!is.na(TRTDURN) ~ "DAY",
                              TRUE ~ as.character(NA))) %>% 
  left_join(ds, by = "USUBJID") %>% 
  mutate(INCNFL   = case_when(ds_infconsent == 1 ~ "Y",
                              TRUE ~ "N"), 
         RANDEXC1 = case_when(RANDFL == "N" & INCNFL == "N" 
                               ~ "Subject did not agree to participate in the study via informed consent",
                              TRUE ~ as.character(NA))) %>%   
  left_join(ie, by = "USUBJID") %>% 
  mutate(RANDEXC2 = case_when(RANDFL == "N" & inie == "Y" & IECAT == "EXCLUSION"
                                ~ "Subject met at least one of the exclusion criterion",
                              TRUE ~ as.character(NA)),
         RANDEXC3 = case_when(RANDFL == "N" & inie == "Y" & IECAT == "INCLUSION"
                                ~ "Subject did not meet all of the inclusion criterion",
                              TRUE ~ as.character(NA)),
         RANDEXC4 = case_when(RANDFL == "N" & is.na(TRT01PN)
                              ~ "Subject is not assigned a randomization number",
                              TRUE ~ as.character(NA)),
         SAFFL    = case_when(RANDFL == "Y" & !is.na(TRTSDT) ~ "Y",
                              TRUE ~ "N"),
         SAFEXC1  = case_when(SAFFL == "N" & RANDFL == "N" 
                                ~ "Subject is not included in Randomized Population",
                              TRUE ~ as.character(NA)),
         SAFEXC2  = case_when(SAFFL == "N" & RANDFL == "Y" & 
                              is.na(TRTSDT)  
                                ~ "Subject did not take at least one dose of study medication",
                              TRUE ~ as.character(NA))) %>% 
  left_join(qs, by = "USUBJID") %>% 
  mutate(MITTFL   = case_when(SAFFL == "Y" & MITTFLn == 1 ~ "Y",
                              TRUE ~ "N"),
         MITTEXC1 = case_when(MITTFL == "N" & SAFFL == "N" 
                                ~ "Subject is not included in the Safety Population",
                              TRUE ~ as.character(NA)),
         MITTEXC2 = case_when(MITTFL == "N" & SAFFL == "Y"
                                ~ "Subject did not have at least one post-baseline assessment of the primary endpoint",
                              TRUE ~ as.character(NA))
         ) %>% 
  left_join(suppex_prep, by = "USUBJID") %>% 
  mutate(MISSDOSE  = case_when(is.na(insuppex) & inex == 1 ~ 0,
                               is.na(insuppex) & is.na(inex) ~ as.numeric(NA),
                               MD > TRTDURN | is.na(TRTDURN) ~ 0,
                               TRUE ~ MD),
         COMPLFL   = case_when(ds_completed == 1 ~ "Y",
                               TRUE ~ "N"),
         comply    = 100 * (TRTDURN - MISSDOSE) / TRTDURN,
         PPROTFL   = case_when(MITTFL == "Y" & !is.na(TRTDURN) &
                               COMPLFL == "Y" & comply >=85  
                                 ~ "Y",
                               TRUE ~ "N"),
         PPROTEX1  = case_when(PPROTFL == "N" & MITTFL == "N"
                                 ~ "Subject is not included in the MITT Population",
                               TRUE ~ as.character(NA)),
         PPROTEX2  = case_when(PPROTFL == "N" & COMPLFL == "N"
                                 ~ "Subject did not have a complete efficacy assessment at Week 12",
                               TRUE ~ as.character(NA)),
         PPROTEX3  = case_when(PPROTFL == "N" & !is.na(TRTDURN) & 
                               comply < 85 
                                 ~ "Subject did not receive at least 85% of prescribed doses of study medication",
                               TRUE ~ as.character(NA)),
         PPROTEX4  = case_when(PPROTFL == "N" & !is.na(TRTDURN) &
                               ds_completedvio == 1 
                                 ~ "Subject completed all visits but with major protocol violations")) %>% 
  left_join(ds_disp, by = "USUBJID") %>%   
  mutate(STDYDISP   = case_when(COMPLFL == "Y"  ~ str_to_title(DSTERM),
                                TRUE ~ "Early Termination"),
         STDYREAS   = case_when(COMPLFL == "N"  ~ str_to_title(DSDECOD),
                                TRUE ~ as.character(NA)),
         INCNDT     = as_date(RFICDTC)) %>% 
  left_join(sv, by = "USUBJID") %>% 
  mutate(RANDDT     = as_date(VISIT1),
         TP1TRTR    = case_when(RESUME1 == 1 ~ "Y",
                                RESUME1 == 0 ~ "N",
                                TRUE ~ as.character(NA)),
         TP2TRTR    = case_when(RESUME2 == 1 ~ "Y",
                                RESUME2 == 0 ~ "N",
                                TRUE ~ as.character(NA)),
         TP3TRTR    = case_when(RESUME3 == 1 ~ "Y",
                                RESUME3 == 0 ~ "N",
                                TRUE ~ as.character(NA)),
         PSORTRTR   = case_when(RESUME1 == 1 | RESUME2 == 1 | 
                                RESUME3 == 1    ~ "Y",
                                TRUE ~ "N")) 

# %>% 
#  select(STUDYID,USUBJID,SUBJID,SITEID,AGE,AGEU,AGEGR1,SEX,
#         RACE,RACEN,ETHNIC,ETHNICN,COUNTRY,ARM,ACTARM,
#         TRT01P,TRT01PN,TRT01A,TRT01AN,TRTSDT,TRTEDT,
#         TRTDURN,TRTDURU,TR01SDT,TR01EDT,INCNFL,
#         RANDFL,RANDEXC1,RANDEXC2,RANDEXC3,RANDEXC4,
#         SAFFL,SAFEXC1,SAFEXC2,MITTFL,MITTEXC1,MITTEXC2,
#         PPROTFL,PPROTEX1,PPROTEX2,PPROTEX3,PPROTEX4,
#         COMPLFL,STDYDISP,STDYREAS,INCNDT,
#         RANDDT,DTHDT,DTHFL,MISSDOSE,TP1TRTR,TP2TRTR,TP3TRTR,
#         PSORTRTR,FUPVISIT,AEREPORT)

# saveRDS(adsl_final, 'data/abc/ADaM/adsl.rds')

# Compare to Reference Dataset --------------------------------------------

qc_adslf <- "data/abc/ADaM/ADSL.csv"
qc_adsl <-
  read_csv(qc_adslf,
  col_types = cols(TRTSDT = col_date(format = "%d%b%Y"),
                   TRTEDT = col_date(format = "%d%b%Y"),
                   TR01SDT = col_date(format = "%d%b%Y"),
                   TR01EDT = col_date(format = "%d%b%Y"),
                   INCNDT = col_date(format = "%d%b%Y"),
                   RANDDT = col_date(format = "%d%b%Y"),
                   DTHDT = col_date(format = "%d%b%Y"),
                   ACTARM = col_character(),
                   COUNTRY = col_character(),
                   RANDEXC1 = col_character())) %>%

  put()

diff1 <- anti_join(adsl_final, qc_adsl) %>% put()

diff2 <- comparedf(adsl_final, qc_adsl) %>% put()


if (nrow(diff1) == 0) {
  put("NOTE: Final data frame and QC are identical.")
} else {
  put("WARNING: Differences found between final data frame and QC", msg = TRUE)
  
  summary(comparedf(adsl_final, qc_adsl)) %>% put()
}

sumdiff <-  summary(comparedf(adsl_final, qc_adsl))

sep("Create a nice data frame that outlines the differences")
sd_df <- sumdiff$diffs.table

# Clean Up ----------------------------------------------------------------
log_close()
options("tidylog.display" = NULL)

