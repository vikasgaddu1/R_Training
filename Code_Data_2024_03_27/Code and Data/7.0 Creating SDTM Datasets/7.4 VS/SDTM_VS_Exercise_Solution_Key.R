# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(readr)
library(logr)
library(fmtr)
library(arsenal)
library(tidylog, warn.conflicts = FALSE)

options("tidylog.display" = list(log_print))

log_open("VS", show_notes = FALSE)


# Import Data ------------------------------------------------------------

sep("Read Needed CRF Data")


base_path <- "data/abc/CRF/"
out_path <- "data/abc/SDTM/"

put("Read VS")
raw_vs <- 
  read_csv(file.path(base_path, "VS.csv")) %>% 
  put()


put("Read DM")
sdtm_dm <- read_rds(file.path(out_path, "DM.rds")) %>% put()

put("Read SV")
sdtm_sv <- read_rds(file.path(out_path, "SV.rds")) %>% put()

put("Read RANPOP")
ranpop <- read_rds(file.path(out_path, "RANPOP.rds")) %>% put()



# Prepare Formats ---------------------------------------------------------


sep("Load SDTM format catalog")

pth <- "./data/abc/sdtm_fmts.fcat" %>% put()

sdtm_fmts <- read.fcat(pth) %>% put()


# Prepare Data ------------------------------------------------------------


sep("Pre-process data")

put("Select needed columns from DM.")
dat_dm <- sdtm_dm %>% select(USUBJID, RFSTDTC) %>% put()


put("Select needed columns from VS and create USUBJID and VISITNUM.")
dat_vs <- raw_vs %>% 
  mutate(USUBJID = str_c(STUDYID, "-", SUBJECT),
         VISITNUM = as.integer(fapply(fapply(VISIT, sdtm_fmts$VISIT), sdtm_fmts$VISITNUM))) %>%
  select(-VISITREP, -PAGEID, -PAGEREP, -STUDYID, -VISIT) %>% put()


put("Join DM and SV to VS.")
dat_combined <- dat_vs %>% 
  left_join(dat_dm, by = c("USUBJID" = "USUBJID")) %>% 
  left_join(sdtm_sv, by = c("USUBJID" = "USUBJID", "VISITNUM" = "VISITNUM")) %>% 
  put()

put("Transform vital signs variables")
dat_pivoted <- dat_combined %>% 
  pivot_longer(cols = c(DIABP, SYSBP, HEIGHT, PULSE, RESP, TEMP, WEIGHT),
               names_to = "VSTESTCD",
               values_to = "VSORRES") %>% 
  put()
  

put("Add sequence variable")
dat_sequenced <- dat_pivoted %>% 
  filter(!is.na(VSORRES)) %>% 
  arrange(USUBJID, VSTESTCD, VISITNUM) %>% 
  group_by(USUBJID) %>% 
  mutate(VSSEQ = seq_along(USUBJID)) %>% 
  ungroup() %>% 
  put()



# Create Final Data Frame -------------------------------------------------


sep("Add and modify columns from combined data frame.")


put("Create staged data frame")

dat_staged <- dat_sequenced %>% 
  transmute(STUDYID, 
            DOMAIN = "VS", 
            USUBJID, 
            VSSEQ, 
            VSTESTCD, 
            VSTEST = fapply(VSTESTCD, sdtm_fmts$VSTEST),
            VSPOS = ifelse(VSTESTCD %in% c("SYSBP", "DIABP"), "SITTING", NA), 
            VSORRES, 
            VSORRESU = fapply(VSTESTCD, sdtm_fmts$VSORRESU),
            VSSTRESC = VSORRES,
            VSSTRESN = as.numeric(VSSTRESC),
            VSSTRESU = VSORRESU,
            VSBLFL = ifelse(as.Date(SVSTDTC) <= RFSTDTC, "Y", NA),
            VISITNUM,
            VISIT = fapply(VISIT, sdtm_fmts$VISIT),
            VSDTC = as.Date(SVSTDTC),
            VSDY =  ifelse(VSDTC - RFSTDTC >= 0 ,  VSDTC - RFSTDTC + 1, VSDTC - RFSTDTC)) %>% 
  arrange(USUBJID, VSSEQ) %>% 
  put()

put("Get max baseline dates")
max_baseline_dates <- dat_staged %>% 
  filter(VSBLFL == "Y") %>% 
  select(USUBJID, VSTESTCD, VSBLFL, VSDTC) %>% 
  group_by(USUBJID, VSTESTCD, VSBLFL) %>% 
  summarize(VSDTC = max(VSDTC)) %>% 
  ungroup() %>% put()

put("Clear out VSBLFL")
dat_staged$VSBLFL <- NA
put(dat_staged)

put("Create final data frame")
dat_final <- dat_staged %>% 
  left_join(max_baseline_dates, c("USUBJID" = "USUBJID", 
                                  "VSTESTCD" = "VSTESTCD",
                                  "VSDTC" = "VSDTC")) %>% 
  rename(VSBLFL = VSBLFL.x) %>% 
  mutate(VSBLFL = VSBLFL.y) %>% 
  select(-VSBLFL.y) %>% put()

# view(dat_final)    

# Save to file
write_rds(dat_final, file.path(out_path, "VS.rds"))

rownames(dat_final) <- NULL

# Compare to Reference Dataset --------------------------------------------

qc_pth <- "./data/abc/SDTM/VS.csv"

dat_qc <- 
  read_csv(qc_pth, 
           col_types = cols(VSDTC = col_date(),
                            VSSEQ = col_integer(),
                            VISITNUM = col_integer())) %>% 
  put()


# view(dat_qc)

diff1 <- anti_join(dat_final, dat_qc) %>% put()
diff2 <- comparedf(dat_final, dat_qc) %>% put()

if (nrow(diff1) == 0) {
  put("NOTE: Final data frame and QC are identical.")
} else {
  put("WARNING: Differences found between final data frame and QC", msg = TRUE)
  
  summary(comparedf(dat_final, dat_qc)) %>% put()
}



# Clean Up ----------------------------------------------------------------


log_close()
options("tidylog.display" = NULL)


