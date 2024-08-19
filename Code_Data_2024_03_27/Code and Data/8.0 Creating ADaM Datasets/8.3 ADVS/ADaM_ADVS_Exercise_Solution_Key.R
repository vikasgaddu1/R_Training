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

log_open("ADVS", show_notes = FALSE)

sep("Set up paths to raw data area and SDTM data area.")

SDTM_path <- "data/abc/SDTM/"
ADaM_path <- "data/abc/ADaM/"

# Prepare Formats ---------------------------------------------------------
sep("Load format catalog")
fc_adam <- read.fcat("data/abc/adam_fmts.fcat") %>% 
  put()

# Import Data ------------------------------------------------------------

adam_specs_path <- "./specs/ADaM_Specs_Clean.xlsx"

advs_valuelevel <- read_excel(adam_specs_path, sheet = "ValueLevel", 
                             .name_repair = "universal") %>% 
  filter(DATASET == "ADVS") %>% 
  put()

param <-
  advs_valuelevel %>% 
  filter(VARIABLE == "PARAM") %>% 
  select(CONDITIONAL_VALUE1, CTVALUE)

paramn <-
  advs_valuelevel %>% 
  filter(VARIABLE == "PARAMN")  %>% 
  select(CONDITIONAL_VALUE1, CTVALUE)

aval <-
  advs_valuelevel %>% 
  filter(VARIABLE == "AVAL")  %>% 
  select(CONDITIONAL_VALUE1, NUMB_DEC_PLACES)

awtarget <-
  advs_valuelevel %>% 
  filter(VARIABLE == "AWTARGET")  %>% 
  select(CONDITIONAL_VALUE1, CTVALUE) %>% 
  mutate(CTVALUE = as.numeric(CTVALUE)) %>% 
  rename(AVISIT = CONDITIONAL_VALUE1, AWTARGET = CTVALUE)

awlo <-
  advs_valuelevel %>% 
  filter(VARIABLE == "AWLO")  %>% 
  select(CONDITIONAL_VALUE1, CTVALUE) %>% 
  mutate(CTVALUE = as.numeric(CTVALUE)) %>% 
  rename(AVISIT = CONDITIONAL_VALUE1, AWLO = CTVALUE)

awhi <-
  advs_valuelevel %>% 
  filter(VARIABLE == "AWHI")  %>% 
  select(CONDITIONAL_VALUE1, CTVALUE) %>% 
  mutate(CTVALUE = as.numeric(CTVALUE)) %>% 
  rename(AVISIT = CONDITIONAL_VALUE1, AWHI = CTVALUE)

awrange <-
  advs_valuelevel %>% 
  filter(VARIABLE == "AWRANGE")  %>% 
  select(CONDITIONAL_VALUE1, CTVALUE) %>% 
  rename(AVISIT = CONDITIONAL_VALUE1, AWRANGE = CTVALUE)


adsl <-
  read_csv(file.path(ADaM_path, "ADSL.csv"))  %>% 
  mutate(TRTSDT = dmy(TRTSDT),
         TRTEDT = dmy(TRTEDT)) %>% 
  select(STUDYID, USUBJID, SUBJID, SITEID, TRT01P,TRT01PN, TRT01A,
         TRT01AN, RANDFL, SAFFL, MITTFL, PPROTFL, TRTSDT, TRTEDT)
  
vs <-
  read_csv(file.path(SDTM_path, "VS.csv")) %>%
  rename(SRCSEQ = VSSEQ,
         ADTC   = VSDTC) %>% 
  mutate(VSSTRESC = as.character(VSSTRESC),
         SRCDOM   = "VS",
         SRCVAR   = "VSSTRESN")

bmi <-
  vs %>% 
  filter(VSTESTCD == "HEIGHT" | VSTESTCD == "WEIGHT") %>% 
  pivot_wider(id_cols = c(STUDYID, DOMAIN, USUBJID, VISITNUM, VISIT, ADTC, VSDY),
              names_from = VSTESTCD,
              values_from = VSORRES) %>% 
  filter(!is.na(HEIGHT) & !is.na(WEIGHT)) %>% 
  mutate(SRCSEQ    = as.numeric(NA),
         VSPOS    = as.character(NA),
         VSORRESU = as.character(NA),
         VSSTRESU = as.character(NA),
         VSBLFL   = as.character(NA),
         VSTESTCD = "BMI",
         VSTEST   = "Body Mass Index",
         VSORRES  =  round(WEIGHT / ((HEIGHT / 100) ** 2), digits = 1),
         VSSTRESN =  round(WEIGHT / ((HEIGHT / 100) ** 2), digits = 1),
         VSSTRESC =  as.character(VSORRES),
         SRCDOM   = as.character(NA),
         SRCVAR   = as.character(NA)) %>% 
  select(STUDYID,	DOMAIN,	USUBJID, SRCDOM, SRCVAR, SRCSEQ,	VSTESTCD,	VSTEST,	VSPOS, VSORRES,	VSORRESU,
         VSSTRESC, VSSTRESN, VSSTRESU, VSBLFL, VISITNUM, VISIT,	ADTC, VSDY)

pe <-
  read_csv(file.path(SDTM_path, "PE.csv"))  %>% 
  filter(PETESTCD == "PCTBSA") %>% 
  rename(SRCSEQ    = PESEQ,
         VSTESTCD = PETESTCD,
         VSTEST   = PETEST,
         VSORRES  = PEORRES,
         VSORRESU = PEORRESU,
         VSSTRESC = PESTRESC,
         VSSTRESN = PESTRESN,
         VSSTRESU = PESTRESU,
         ADTC     = PEDTC,
         VSDY     = PEDY) %>%
  mutate(VSORRES = as.numeric(VSORRES),
         SRCDOM   = "PE",
         SRCVAR   = "PESTRESN") %>% 
  select(-PECAT, -PESTAT)
  
advs_prep <-
  bind_rows(vs, bmi) %>% 
  bind_rows(pe) %>% 
  left_join(adsl, by = c("STUDYID", "USUBJID")) %>% 
  mutate(STUDYID     = STUDYID,
         USUBJID     = USUBJID,
         SUBJID      = SUBJID,
         SITEID      = substring(USUBJID, 5, 6),
         SRCDOM      = SRCDOM,
         SRCVAR      = SRCVAR,
         TRTP        = TRT01P,
         TRTPN       = TRT01PN,
         TRTA        = TRT01A,
         TRTAN       = TRT01AN,
         RANDFL      = RANDFL,
         SAFFL       = SAFFL,
         MITTFL      = MITTFL,
         PPROTFL     = PPROTFL,
         TRTSDT      = TRTSDT,
         TRTEDT      = TRTEDT,
         ADT         = as_date(ADTC),
         ADY         = as.numeric(case_when(ADT >= TRTSDT ~ (ADT - TRTSDT +1),
                                            ADT < TRTSDT  ~ (ADT - TRTSDT),
                                            TRUE ~ as.numeric(NA))),
         ADTF        = case_when(is.na(substring(ADTC, 6, 7)) &
                                 is.na(substring(ADTC, 9, 10)) ~ "D",
                                 is.na(substring(ADTC, 6, 7))  ~ "M",
                                 TRUE ~ as.character(NA)),
         AVISIT      = case_when(VISIT == "SCREENING"  ~ "Screening",
                                 VISIT == "DAY 1"      ~ "Day 1 Baseline",
                                 (ADY >=8 & ADY <= 22 &
                                     VISIT != "WEEK 16" ) ~ "Week 2",
                                 (ADY >=23 & ADY <= 36 &
                                   VISIT != "WEEK 16" )   ~ "Week 4",
                                 (ADY >=37 & ADY <= 50 &
                                   VISIT != "WEEK 16" )   ~ "Week 6",
                                 (ADY >=51 & ADY <= 71 &
                                   VISIT != "WEEK 16" )   ~ "Week 8",
                                 (ADY >=72 & ADY <= 99 &
                                    VISIT != "WEEK 16" )   ~ "Week 12",
                                 VISIT == "WEEK 16" &
                                  ADY >= (TRTEDT - TRTSDT + 22) &
                                  ADY <= (TRTEDT - TRTSDT + 36) ~ "Week 16",
                                 TRUE ~ as.character(NA)),
         AVISITN     = case_when(AVISIT == "Screening"      ~ -1,
                                 AVISIT == "Day 1 Baseline" ~  0,
                                 AVISIT == "Week 2"         ~  2,
                                 AVISIT == "Week 4"         ~  4,
                                 AVISIT == "Week 6"         ~  6,
                                 AVISIT == "Week 8"         ~  8,
                                 AVISIT == "Week 12"        ~ 12,
                                 AVISIT == "Week 16"        ~ 16,
                                 TRUE ~ as.numeric(NA))) %>% 
  left_join(param, by = c("VSTESTCD" = "CONDITIONAL_VALUE1")) %>% 
  rename(PARAM = CTVALUE) %>% 
  left_join(paramn, by = c("VSTESTCD" = "CONDITIONAL_VALUE1")) %>% 
  mutate(PARAMN   = as.numeric(CTVALUE), 
         PARAMCD  = VSTESTCD,
         PARAMTYP = case_when(PARAMCD == "BMI" ~ "DERIVED",
                              TRUE ~ as.character(NA))) %>% 
  left_join(aval, by = c("VSTESTCD" = "CONDITIONAL_VALUE1")) %>% 
  mutate(AVAL = VSSTRESN)
  # mutate(AVAL  = case_when(NUMB_DEC_PLACES == 3  ~ round(VSSTRESN, .001),
  #                         NUMB_DEC_PLACES == 2  ~ round(VSSTRESN, .01),
  #                         NUMB_DEC_PLACES == 0  ~ round(VSSTRESN, 1),
  #                         NUMB_DEC_PLACES == 1  ~ round(VSSTRESN, .1),
  #                         TRUE ~ VSSTRESN))

advs_base <-
  advs_prep %>% 
  filter(ADY <= 1) %>% 
  select(USUBJID, PARAMCD, AVAL, ADY) %>%
  arrange(USUBJID, PARAMCD, ADY) %>% 
  group_by(USUBJID, PARAMCD) %>% 
  slice_tail(n=1) %>% 
  ungroup() %>% 
  rename(BASE = AVAL) %>% 
  select(USUBJID, PARAMCD, BASE)

advs_ablfl <-
  advs_prep %>% 
  filter(ADY <= 1) %>% 
  select(USUBJID, PARAMCD, ADY) %>%
  arrange(USUBJID, PARAMCD, ADY) %>% 
  group_by(USUBJID, PARAMCD) %>% 
  slice_tail(n=1) %>% 
  ungroup() %>% 
  mutate(ABLFL = "Y") %>% 
  select(USUBJID, PARAMCD, ADY, ABLFL)


advs_prep2 <-
  advs_prep %>% 
  left_join(advs_base, by = c("USUBJID", "PARAMCD")) %>% 
  mutate(CHG         = case_when(ADY > 1 ~ (AVAL - BASE),
                                 TRUE ~ as.numeric(NA))) %>% 
  arrange(USUBJID, PARAMN, ADY) %>% 
  left_join(awlo, by = "AVISIT") %>% 
  left_join(awtarget, by = "AVISIT") %>% 
  left_join(awhi, by = "AVISIT") %>% 
  mutate(AWTARGET  = case_when(AVISIT == "Week 16" ~ as.numeric((TRTEDT - TRTSDT + 29)),
                               TRUE ~ AWTARGET),
         AWLO      = case_when(AVISIT == "Week 16" ~ as.numeric((TRTEDT - TRTSDT + 22)),
                               TRUE ~ AWLO),
         AWHI      = case_when(AVISIT == "Week 16" ~ as.numeric((TRTEDT - TRTSDT + 36)),
                               TRUE ~ AWHI)) %>% 
  mutate(AWTDIFF    =  abs(as.numeric(ADY - AWTARGET))) %>% 
  mutate(AWU = case_when(!is.na(AWTARGET)  ~ "DAYS",
                         TRUE ~ as.character(NA))) %>% 
  left_join(awrange, by = "AVISIT") %>% 
  left_join(advs_ablfl, by = c("USUBJID", "PARAMCD", "ADY")) %>% 
  select(STUDYID,USUBJID,SUBJID,SITEID,SRCDOM,SRCVAR,SRCSEQ,TRTP,TRTPN,
         TRTA,TRTAN,RANDFL,SAFFL,MITTFL,PPROTFL,TRTSDT,TRTEDT,ADT,ADY,
         ADTF,AVISIT,AVISITN,PARAM,PARAMCD,PARAMN,PARAMTYP,AVAL,BASE,CHG,
         AWRANGE,AWTARGET,AWTDIFF,AWLO,AWHI,AWU,ABLFL
  )

advs_prep2 %>% filter(AWTDIFF < 0)

advs_anl01fl <-
  advs_prep2 %>% 
  filter((AVISIT != "Screening" & AVISIT != "Day 1 Baseline" & 
            ADT <= (TRTEDT + 3))) %>% 
  select(USUBJID, PARAMCD, AVISITN, 
         AWTDIFF, ADY) %>% 
  arrange(USUBJID, PARAMCD, AWTDIFF, ADY) %>% 
  group_by(USUBJID, PARAMCD, AVISITN) %>% 
  slice_head(n=1) %>% 
  ungroup() %>% 
  transmute(USUBJID,
            PARAMCD, 
            AVISITN,
            ADY,
            ANL01FL = "Y") 

advs_final <-
  advs_prep2 %>% 
  left_join(advs_anl01fl, by = c("USUBJID", "PARAMCD", "AVISITN", "ADY")) %>% 
  mutate(ANL01FL = case_when(AVISIT == "Screening" | 
                             AVISIT == "Day 1 Baseline" ~ "Y",
                             TRUE ~ ANL01FL)) %>% 
  arrange(USUBJID, PARAMCD, SRCSEQ) %>% 
  select(STUDYID,USUBJID,SUBJID,SITEID,SRCDOM,SRCVAR,SRCSEQ,TRTP,TRTPN,
         TRTA,TRTAN,RANDFL,SAFFL,MITTFL,PPROTFL,TRTSDT,TRTEDT,ADT,ADY,
         ADTF,AVISIT,AVISITN,PARAM,PARAMCD,PARAMN,PARAMTYP,AVAL,BASE,CHG,
         AWRANGE,AWTARGET,AWTDIFF,AWLO,AWHI,AWU,ABLFL, ANL01FL)

advs_final %>% filter(PARAMCD == "BMI") %>% select(AVAL) %>% summary()
tabyl(advs_final$ANL01FL)
summary(advs_final$SRCSEQ)
  
saveRDS(advs_final, 'data/abc/ADaM/advs.rds')

# Compare to Reference Dataset --------------------------------------------

qc_advsf <- "data/abc/ADaM/ADVS.csv"
qc_advs <-
  read_csv(qc_advsf) %>%
  mutate(TRTSDT = dmy(TRTSDT),
         TRTEDT = dmy(TRTEDT),
         ADT    = dmy(ADT),
		 ADTF   = as.character(ADTF)) %>% 
  arrange(USUBJID, PARAMCD, SRCSEQ) %>% 
  put()

diff1 <- anti_join(advs_final, qc_advs,  
                   by = c("USUBJID", "PARAMCD", "SRCSEQ")) %>% put()

diff2 <- comparedf(advs_final, qc_advs,  
                   by = c("USUBJID", "PARAMCD", "SRCSEQ")) %>% put()


if (nrow(diff1) == 0) {
  put("NOTE: Final data frame and QC are identical.")
} else {
  put("WARNING: Differences found between final data frame and QC", msg = TRUE)
  
  summary(comparedf(advs_final, qc_advs)) %>% put()
}

sumdiff <-  summary(comparedf(advs_final, qc_advs, 
                              by = c("USUBJID", "PARAMCD", "SRCSEQ")))

sep("Create a nice data frame that outlines the differences")
sd_df <- sumdiff$diffs.table

tabyl(sd_df$var.x)

# Clean Up ----------------------------------------------------------------
log_close()
options("tidylog.display" = NULL)
