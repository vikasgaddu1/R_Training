# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(readr)
library(lubridate)
library(logr)
library(fmtr)
library(arsenal)
library(tidylog, warn.conflicts = FALSE)

options("tidylog.display" = list(log_print))

log_open("AE", show_notes = FALSE)

sep("Set up paths to raw data area and SDTM data area in course level directory.")

base_path <- "data/abc/CRF/"
out_path <- "data/abc/SDTM/"

# Prepare Formats ---------------------------------------------------------
sep("Load format catalog")
fc <- read.fcat("data/abc/sdtm_fmts.fcat") %>% 
  put()

# Import Data ------------------------------------------------------------

sep("Read Needed CRF Data")

put("Read DM SDTM Data Set")
dm <- readRDS(file.path(out_path, "DM.rds")) %>% 
  mutate(SUBJECT = substring(USUBJID,5,10)) %>% 
  select(STUDYID, SUBJECT, RFSTDTC)

put("Read AESR")
raw_aesr <- 
  read_csv(file.path(base_path, "AESR.csv"), 
           col_types = cols(AESTDT = col_date("%d%b%Y"),
                            AEENDT = col_date("%d%b%Y"))) %>% 
  mutate(AESTDTC = case_when(is.na(AESTDT) & 
                             AESTMON != "DASH"      ~ paste0(AESTYY,'-',AESTMON),
                             is.na(AESTDT)           ~ as.character(AESTYY),
                             TRUE ~ as.character(AESTDT))) %>% 
  put()

put("Read AESF")
put("  Fill in missing AESF with AEFENDT in new variable aefdtnew")
raw_aesf <- 
  read_csv(file.path(base_path, "AESF.csv"), 
           col_types = cols(AEFDT = col_date("%d%b%Y"),
                            AEFENDT = col_date("%d%b%Y"))) %>% 
  select(STUDYID, SUBJECT, VISIT, VISITREP, AEFDT, AEFENDT, AEOUTF) %>% 
  mutate(aefdtnew = case_when(is.na(AEFDT) ~ AEFENDT,
                                    TRUE ~ (AEFDT))) %>% 
  put()

put("Combine AESR and AESF and apply values from AESF")
put("  Create new variables taking into account missing and/or incomplete dates.")
raw_ae <-
  left_join(raw_aesr, raw_aesf, 
            by = c("STUDYID", "SUBJECT", "VISIT", "VISITREP")) %>% 
  inner_join(dm, by = c("STUDYID", "SUBJECT")) %>% 
  mutate(AEOUTnew = case_when(is.na(AEOUTF) ~ AEOUT,
                              TRUE ~ as.numeric(AEOUTF)),
         AEENDTnew = case_when(is.na(aefdtnew) ~ AEENDT,
                              TRUE ~ as.Date(aefdtnew))) %>% 
  mutate(AEENDTC = case_when(is.na(AEENDTnew) & 
                             (AEENMON != "DASH" & AEENMON != '.')
                                                        ~ paste0(AEENYY,'-',AEENMON),
                             is.na(AEENDTnew)           ~ as.character(AEENYY),
                             TRUE ~ as.character(AEENDTnew)))  
  
  
# Prepare Data ------------------------------------------------------------

raw_aesr_w_seq <-
  raw_ae %>% 
  mutate(USUBJID = paste0(STUDYID, "-", SUBJECT)) %>% 
  arrange(USUBJID, PT_TERM, AESEV, AESTDT, AETERM ) %>% 
  group_by(USUBJID) %>% 
  mutate(AESEQ = seq_along(USUBJID)) %>% 
  ungroup()

# Create Final Data Frame -------------------------------------------------
put("Create final data frame")
ae_final <-
  raw_aesr_w_seq %>% 
  transmute(STUDYID   = STUDYID,
         DOMAIN    = "AE",
         USUBJID   = USUBJID,
         AESEQ     = as.numeric(AESEQ),
         AETERM    = AETERM,
         AELLT     = NA,
         AELLTCD   = NA,
         AEDECOD   = PT_TERM,
         AEPTCD    = CODE1_PT,
         AEHLT     = HLT_TERM,
         AEHLTCD   = HLT_CODE,
         AEHLGT    = HLGT_TER,
         AEHLGTCD  = HLGT_COD,
         AECAT     = "GENERAL ADVERSE EVENT",
         AEBODSYS  = SOC_TERM,
         AEBDSYCD  = CODE2_SO,
         AESOC     = SOC_TERM,
         AESOCCD   = CODE2_SO,
         AESEV     = fapply(AESEV, fc$AESEV),
         AESER     = case_when(AESER == 0 ~ "N",
                               AESER == 1 ~ "Y",
                               TRUE ~ as.character("")),
         AEACN     = fapply(AEACN, fc$ACN),
         AEREL     = fapply(AEREL, fc$AEREL),
         AEOUT     = fapply(AEOUTnew, fc$OUT),
         AESTDTC   = AESTDTC,
         AEENDTC   = AEENDTC,
         AESTDY    = case_when(as.numeric(AESTDT) < as.numeric(RFSTDTC) 
                                       ~ as.numeric(AESTDT - RFSTDTC),
                               TRUE ~ as.numeric(AESTDT - RFSTDTC + 1)),
         AEENDY    = case_when(as.numeric(AEENDTnew) < as.numeric(RFSTDTC) 
                                   ~ as.numeric(AEENDTnew - RFSTDTC),
                               TRUE ~ as.numeric(AEENDTnew - RFSTDTC + 1)))


# Save to file
write_rds(ae_final, file.path(out_path, "AE.rds"))

# Compare to Reference Dataset --------------------------------------------

qc_ae <- "data/abc/SDTM/AE.csv"

qc_ae <- 
  read_csv(qc_ae) %>% 
  put()

diff1 <- anti_join(ae_final, qc_ae) %>% put()

diff2 <- comparedf(ae_final, qc_ae) %>% put()

if (nrow(diff1) == 0) {
  put("NOTE: Final data frame and QC are identical.")
} else {
  put("WARNING: Differences found between final data frame and QC", msg = TRUE)
  
  summary(comparedf(ae_final, qc_ae)) %>% put()
}

# Clean Up ----------------------------------------------------------------

log_close()
options("tidylog.display" = NULL)


