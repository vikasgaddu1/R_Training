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

log_open("ADAE", show_notes = FALSE)

sep("Set up paths to raw data area and SDTM data area.")

SDTM_path <- "data/abc/SDTM/"
ADaM_path <- "data/abc/ADaM/"

# Prepare Formats ---------------------------------------------------------
sep("Load format catalog")
fc_adam <- read.fcat("data/abc/adam_fmts.fcat") %>% 
  put()

# Import Data ------------------------------------------------------------
adam_specs_path <- "./specs/ADaM_Specs_Clean.xlsx"

# Read in the data from the ADaM ADSL data set.
adsl <-
  read_csv(file.path(ADaM_path, "ADSL.csv"))  %>% 
  mutate(TRTSDT = dmy(TRTSDT),
         TRTEDT = dmy(TRTEDT)) %>% 
  rename(TRTP = TRT01P, TRTPN = TRT01PN, TRTA = TRT01A, TRTAN = TRT01AN) %>% 
  select(USUBJID, SUBJID, SITEID, TRTP, TRTPN, TRTA, TRTAN, RANDFL, 
         SAFFL, MITTFL, PPROTFL, TRTSDT, TRTEDT)

# read in the data from the SDTM AE data set. Calculate any necessary variables 
# that can be accomplished in the same step. 
ae <-
  read_csv(file.path(SDTM_path, "AE.csv")) %>% 
  select(STUDYID, USUBJID, AESEQ, AESEV, AEREL, AEACN, AESER, AECAT, AESTDTC, AETERM, AEDECOD,
         AEPTCD, AESOC, AESOCCD, AEBODSYS, AEBDSYCD, AEHLT, AEHLTCD, AEHLGT,
         AEHLGTCD, AESTDY, AEENDTC, AEENDY) %>% 
  left_join(adsl, by = "USUBJID") %>% 
  mutate(AESEVN     = case_when(AESEV == "MILD"     ~ 1,
                                AESEV == "MODERATE" ~ 2,
                                AESEV == "SEVERE"   ~ 3,
                                TRUE ~ as.numeric(NA)),
         AREL       = case_when(AEREL != "NOT RELATED"  ~ "RELATED",
                                TRUE ~ AEREL),
         AACN       = case_when(is.na(AEACN)    ~ "DRUG WITHDRAWN",
                                TRUE ~ AEACN),
         ASER       = case_when(AESER != "N"    ~ "Y",
                                TRUE ~ AESER),
         ASTDTC     = case_when(nchar(AESTDTC) == 4 ~ paste0(AESTDTC, "-01", "-01"),
                                nchar(AESTDTC) == 7 ~ paste0(AESTDTC, "-01"),
                                TRUE ~ AESTDTC),
         ASTDT      = as_date(ASTDTC),
         ASTDY      = as.numeric(case_when((ASTDT >= TRTSDT) ~ ASTDT - TRTSDT + 1,
                                (ASTDT < TRTSDT)  ~ ASTDT - TRTSDT,
                                TRUE ~ as.numeric(NA))),
         ASTDTF     = case_when(nchar(AESTDTC) == 4 ~ "M",
                                nchar(AESTDTC) == 7 ~ "D",
                                TRUE ~ as.character(NA)),
         AENDTC     = case_when(nchar(AEENDTC) == 4 ~ paste0(AEENDTC, "-01", "-01"),
                       nchar(AEENDTC) == 7 ~ paste0(AEENDTC, "-01"),
                       TRUE ~ AEENDTC),
         AENDT      = as_date(AENDTC),
         AENDTF     = case_when(nchar(AEENDTC) == 4 ~ "M",
                                nchar(AEENDTC) == 7 ~ "D",
                                TRUE ~ as.character(NA)),
         AENDY      = as.numeric(case_when((AENDT >= TRTSDT) ~ AENDT - TRTSDT + 1,
                                (AENDT < TRTSDT)  ~ AENDT - TRTSDT,
                                TRUE ~ as.numeric(NA))),
         ADURN     = as.numeric(AENDT - ASTDT + 1)
  )

# Calculate flags as described in the specs.
aoccfl <-
  ae %>% 
  arrange(USUBJID, ASTDT, AESEQ) %>% 
  group_by(USUBJID) %>% 
  slice_head(n = 1) %>% 
  ungroup() %>% 
  mutate(AOCCFL = "Y") %>% 
  select(USUBJID, ASTDT, AESEQ, AOCCFL)

aoccsfl <-
  ae %>% 
  arrange(USUBJID, AEBODSYS, ASTDT, AESEQ) %>% 
  group_by(USUBJID, AEBODSYS) %>% 
  slice_head(n = 1) %>% 
  ungroup() %>% 
  mutate(AOCCSFL = "Y") %>% 
  select(USUBJID, AEBODSYS, ASTDT, AESEQ, AOCCSFL)

aoccpfl <-
  ae %>% 
  arrange(USUBJID, AEBODSYS, AEDECOD, ASTDT, AESEQ) %>% 
  group_by(USUBJID, AEBODSYS, AEDECOD) %>% 
  slice_head(n = 1) %>% 
  ungroup() %>% 
  mutate(AOCCPFL = "Y") %>% 
  select(USUBJID, AEBODSYS, AEDECOD, ASTDT, AESEQ, AOCCPFL)

maxaesevn <-
  ae %>% 
  group_by(USUBJID) %>%
  summarize(maxAESEVN = max(AESEVN, na.rm = TRUE)) %>% 
  ungroup() 

aoccifl <-
  ae %>% 
  left_join(maxaesevn, by = "USUBJID") %>%
  filter(AESEVN == maxAESEVN) %>% 
  arrange(USUBJID, ASTDT, AESEQ) %>% 
  group_by(USUBJID) %>% 
  slice_head(n = 1) %>% 
  ungroup() %>% 
  mutate(AOCCIFL = "Y") %>% 
  select(USUBJID, ASTDT, AESEQ, AOCCIFL)

maxaesevns <-
  ae %>% 
  group_by(USUBJID, AEBODSYS) %>%
  summarize(maxAESEVN = max(AESEVN, na.rm = TRUE)) %>% 
  ungroup() 

aoccsifl <-
  ae %>% 
  left_join(maxaesevns, by = c("USUBJID", "AEBODSYS")) %>%
  filter(AESEVN == maxAESEVN) %>% 
  arrange(USUBJID, AEBODSYS, ASTDT, AESEQ) %>% 
  group_by(USUBJID, AEBODSYS) %>% 
  slice_head(n = 1) %>% 
  ungroup() %>% 
  mutate(AOCCSIFL = "Y") %>% 
  select(USUBJID, AEBODSYS, ASTDT, AESEQ, AOCCSIFL)

maxaesevnp <-
  ae %>% 
  group_by(USUBJID, AEBODSYS, AEDECOD) %>%
  summarize(maxAESEVN = max(AESEVN, na.rm = TRUE)) %>% 
  ungroup() 

aoccpifl <-
  ae %>% 
  left_join(maxaesevnp, by = c("USUBJID", "AEBODSYS", "AEDECOD")) %>%
  filter(AESEVN == maxAESEVN) %>% 
  arrange(USUBJID, AEBODSYS, AEDECOD, ASTDT, AESEQ) %>% 
  group_by(USUBJID, AEBODSYS, AEDECOD) %>% 
  slice_head(n = 1) %>% 
  ungroup() %>% 
  mutate(AOCCPIFL = "Y") %>% 
  select(USUBJID, AEBODSYS, AEDECOD, ASTDT, AESEQ, AOCCPIFL)

aoccrlfl <-
  ae %>%
  filter(AREL == "RELATED") %>% 
  arrange(USUBJID, ASTDT, AESEQ) %>% 
  group_by(USUBJID) %>% 
  slice_head(n = 1) %>% 
  ungroup() %>% 
  mutate(AOCCRLFL = "Y") %>% 
  select(USUBJID, ASTDT, AESEQ, AOCCRLFL)

aoccdsfl <-
  ae %>%
  filter(AACN == "DRUG WITHDRAWN") %>% 
  arrange(USUBJID, ASTDT, AESEQ) %>% 
  group_by(USUBJID) %>% 
  slice_head(n = 1) %>% 
  ungroup() %>% 
  mutate(AOCCDSFL = "Y") %>% 
  select(USUBJID, ASTDT, AESEQ, AOCCDSFL)

aoccsrfl <-
  ae %>%
  filter(ASER == "Y") %>% 
  arrange(USUBJID, ASTDT, AESEQ) %>% 
  group_by(USUBJID) %>% 
  slice_head(n = 1) %>% 
  ungroup() %>% 
  mutate(AOCCSRFL = "Y") %>% 
  select(USUBJID, ASTDT, AESEQ, AOCCSRFL)

aoccsvfl <-
  ae %>%
  filter(AESEV == "SEVERE") %>% 
  arrange(USUBJID, ASTDT, AESEQ) %>% 
  group_by(USUBJID) %>% 
  slice_head(n = 1) %>% 
  ungroup() %>% 
  mutate(AOCCSVFL = "Y") %>% 
  select(USUBJID, ASTDT, AESEQ, AOCCSVFL)

# add the flags to the ae data.
adae_final <-
  ae %>% 
  left_join(aoccfl, by = c("USUBJID", "ASTDT", "AESEQ")) %>% 
  left_join(aoccsfl, by = c("USUBJID", "ASTDT", "AESEQ", 
                            "AEBODSYS")) %>% 
  left_join(aoccpfl, by = c("USUBJID", "ASTDT", "AESEQ", 
                            "AEBODSYS", "AEDECOD")) %>%
  left_join(aoccifl, by = c("USUBJID", "ASTDT", "AESEQ")) %>%
  left_join(aoccsifl, by = c("USUBJID", "ASTDT", "AESEQ", 
                            "AEBODSYS")) %>% 
  left_join(aoccpifl, by = c("USUBJID", "ASTDT", "AESEQ", 
                            "AEBODSYS", "AEDECOD")) %>% 
  left_join(aoccrlfl, by = c("USUBJID", "ASTDT", "AESEQ")) %>% 
  left_join(aoccdsfl, by = c("USUBJID", "ASTDT", "AESEQ")) %>% 
  left_join(aoccsrfl, by = c("USUBJID", "ASTDT", "AESEQ")) %>% 
  left_join(aoccsvfl, by = c("USUBJID", "ASTDT", "AESEQ")) %>% 
  select(STUDYID,USUBJID,SUBJID,SITEID,TRTP,TRTPN,TRTA,TRTAN,
         RANDFL,SAFFL,MITTFL,PPROTFL,TRTSDT,TRTEDT,AESEQ,AESEV,AESEVN,
         AEREL,AREL,AEACN,AACN,AESER,ASER,AECAT,AESTDTC,AETERM,AEDECOD,
         AEPTCD,AESOC,AESOCCD,AEBODSYS,AEBDSYCD,AEHLT,AEHLTCD,AEHLGT,
         AEHLGTCD,AESTDY,ASTDT,ASTDY,ASTDTF,AEENDTC,AEENDY,AENDT,AENDY,
         AENDTF,ADURN,AOCCFL,AOCCSFL,AOCCPFL,AOCCIFL,AOCCSIFL,AOCCPIFL,
         AOCCRLFL,AOCCDSFL,AOCCSRFL,AOCCSVFL)
  
tabyl(adae_final$AOCCFL)
summary(adae_final$AESEQ)

saveRDS(adae_final, 'data/abc/ADaM/adae.rds')

# Compare to Reference Dataset --------------------------------------------

qc_adaef <- "data/abc/ADaM/ADAE.csv"
qc_adae <-
  read_csv(qc_adaef) %>% 
  mutate(TRTSDT = dmy(TRTSDT),
         TRTEDT = dmy(TRTEDT),
         ASTDT   = dmy(ASTDT),
         AENDT   = dmy(AENDT))
  

diff1 <- anti_join(adae_final, qc_adae) %>% put()

diff2 <- comparedf(adae_final, qc_adae, by = c("USUBJID", "AESEQ")) %>% put()


if (nrow(diff1) == 0) {
  put("NOTE: Final data frame and QC are identical.")
} else {
  put("WARNING: Differences found between final data frame and QC", msg = TRUE)
  
  summary(comparedf(adae_final, qc_adae, by = c("USUBJID", "AESEQ"))) %>% put()
}

sumdiff <-  summary(comparedf(adae_final, qc_adae, by = c("USUBJID", "AESEQ")))

sep("Create a nice data frame that outlines the differences")
sd_df <- sumdiff$diffs.table

tabyl(sd_df$var.x)

# Clean Up ----------------------------------------------------------------
log_close()
options("tidylog.display" = NULL)
