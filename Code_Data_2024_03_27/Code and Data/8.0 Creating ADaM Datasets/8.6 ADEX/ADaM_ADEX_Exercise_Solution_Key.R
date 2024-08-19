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

log_open("ADEX", show_notes = FALSE)


# Import Data ------------------------------------------------------------

sep("Read Needed Input Data")


base_path <- "data/abc/SDTM/"
out_path <- "data/abc/ADaM/"

put("Read ADSL")
adsl <- 
  read_csv(file.path(out_path, "ADSL.csv")) %>% 
  put()

put("Read EX")
ex <- 
  read_csv(file.path(base_path, "EX.csv")) %>% 
  put()

put("Read DA")
da <- read_csv(file.path(base_path, "DA.csv")) %>% 
  put()


# Create Formats ----------------------------------------------------------

sep("Create format catalog for ADEX")

put("Create format for PARAM")
PARAM <- value(condition(x == "TRTDUR", "Total Duration of Treatment"),
               condition(x == "NUMAPP", "Total Number of Applications"), 
               condition(x == "COMPLNC", "Percent Compliance"), 
               condition(x == "STMEDWGT", "Total Weight of Study Medication Used (grams)"))

put("Create format for PARAMN")
PARAMN <- value(condition(x == "TRTDUR", 1),
                condition(x == "NUMAPP", 3), 
                condition(x == "COMPLNC", 4), 
                condition(x == "STMEDWGT", 2))

put("Create format for TRTDUR_CAT")
TRTDUR_CAT <- value(condition(x >= 1 & x <= 22,  "1-22 Days"),
                    condition(x >= 23 & x <= 36, "23-36 Days"),
                    condition(x >= 37 & x <= 50, "37-50 Days"),
                    condition(x >= 51 & x <= 71, "51-71 Days"),
                    condition(x >= 72 & x <= 99, "72-99 Days"),
                    condition(x >= 100, ">=100 Days"), 
                    condition(is.na(x), "Missing"))

put("Create format for NUMAPP_CAT")
NUMAPP_CAT <- value(condition(x >= 1 & x <= 22,  "1-22"),
                    condition(x >= 23 & x <= 36, "23-36"),
                    condition(x >= 37 & x <= 50, "37-50"),
                    condition(x >= 51 & x <= 71, "51-71"),
                    condition(x >= 72 & x <= 99, "72-99"),
                    condition(x >= 100, ">=100"), 
                    condition(is.na(x), "Missing"))

put("Create format for COMPLNC_CAT")
COMPLNC_CAT <- value(condition(x >= 0 & x < 21,  "0.0-20.9"),
                     condition(x >= 21 & x < 41, "21.0-40.9"),
                     condition(x >= 41 & x < 61, "41.0-60.9"),
                     condition(x >= 61 & x < 85, "61.0-84.9"),
                     condition(x >= 85 & x <= 100, "85.0-100.0"),
                     condition(is.na(x), "Missing"))

put("Combine into format catalog")
adex_fmts <- fcat(PARAM = PARAM, 
                  PARAMN = PARAMN, 
                  TRTDUR_CAT = TRTDUR_CAT, 
                  NUMAPP_CAT = NUMAPP_CAT, 
                  COMPLNC_CAT = COMPLNC_CAT) %>% put()


# Prepare Data ------------------------------------------------------------

sep("Perform preparation of input data")



put("Select needed columns from ADSL.")
dat_adsl <- adsl %>% 
  select(STUDYID, USUBJID, SUBJID, SITEID, TRT01P, TRT01PN, TRT01A, TRT01AN,
         RANDFL, SAFFL, MITTFL, PPROTFL, MISSDOSE) %>% 
  put()


put("Select needed rows and columns from DA and summarize by subject.")
dat_da <- da %>% select(USUBJID, DATESTCD, DAORRES) %>% 
  filter(DATESTCD == "WGTDIFF") %>% 
  group_by(USUBJID, DATESTCD) %>% 
  summarize(AVAL = sum(DAORRES)) %>% 
  ungroup() %>% 
  right_join(adsl, by = c("USUBJID" = "USUBJID")) %>% 
  transmute(USUBJID, 
            PARAMCD = "STMEDWGT",
            PARAMN = 2,
            AVAL,
            AVALCAT1 = NA) %>% 
  put()
  
ex_base <- adsl %>% left_join(ex, by = c("USUBJID" = "USUBJID")) 


put("Select needed columns from EX and calculate duration")
dat_ex <- ex_base %>% select(USUBJID, EXSTDTC, EXENDTC) %>% 
  mutate(EXENDTC_MOD = ifelse(nchar(EXENDTC) <= 4, NA, EXENDTC),
         EXENDTC_MOD = as.Date(EXENDTC_MOD),
         DURATION = EXENDTC_MOD - EXSTDTC + 1) %>% 
  transmute(USUBJID, 
            PARAMCD = "TRTDUR",
            PARAMN = 1,
            AVAL = as.integer(DURATION),
            AVALCAT1 = fapply(AVAL, adex_fmts$TRTDUR_CAT)) %>% 
  put()
  
put("Join adsl to ex to add missed dose")
dat_ext <- dat_ex %>% 
  left_join(select(dat_adsl, USUBJID, MISSDOSE), 
            by = c("USUBJID" = "USUBJID")) %>% 
  put()

put("Calculate num of applications")
dat_app <- dat_ext %>% 
  transmute(USUBJID, 
            PARAMCD = "NUMAPP", 
            PARAMN = 3,
            AVAL = AVAL - MISSDOSE,
            AVALCAT1 = fapply(AVAL, adex_fmts$NUMAPP_CAT)) %>% 
  put()

put("Calculate compliance percentage")
dat_compl <- dat_ext %>% 
  inner_join(dat_app, by = c("USUBJID" = "USUBJID")) %>% 
  transmute(USUBJID, 
           PARAMCD = "COMPLNC", 
           PARAMN = 4,
           AVAL = round(AVAL.y / AVAL.x * 100, 1),
           AVALCAT1 = fapply(AVAL, adex_fmts$COMPLNC_CAT)) %>% 
  put()
  


# Create Final Data Frame -------------------------------------------------



sep("Combine prepared data to create final ADEX data frame.")



put("Combine EX rows")
final_ex <- bind_rows(dat_da, dat_ex, dat_app, dat_compl) %>% 
  arrange(USUBJID, PARAMN) %>% 
  mutate(PARAM = fapply(PARAMCD, adex_fmts$PARAM)) %>% 
  put()

put("Combine dat_adsl with final_ex")
final <- inner_join(dat_adsl, final_ex, by = c("USUBJID" = "USUBJID")) %>%
  transmute(STUDYID, 
            USUBJID, 
            SUBJID, 
            SITEID,
            TRTP = TRT01P,
            TRTPN = TRT01PN,
            TRTA = TRT01A,
            TRTAN = TRT01AN,
            RANDFL,
            SAFFL, 
            MITTFL,
            PPROTFL,
            PARAM,
            PARAMCD,
            PARAMN,
            AVAL, 
            AVALCAT1) %>% 
  arrange(USUBJID, PARAMN) %>% 
  put()
                      


# view(final)    

# Save to file
write_rds(final, file.path(out_path, "ADEX.rds"))



# Compare to Reference Dataset --------------------------------------------

qc_pth <- "./data/abc/ADaM/ADEX.csv"

dat_qc <- 
  read_csv(qc_pth) %>% 
  put()



diff1 <- anti_join(final, dat_qc) %>% put()
diffdf(final, dat_qc) %>% put()

if (nrow(diff1) == 0) {
  put("NOTE: Final data frame and QC are identical.")
} else {
  put("WARNING: Differences found between final data frame and QC", msg = TRUE)
  
}



# Clean Up ----------------------------------------------------------------


log_close()
options("tidylog.display" = NULL)


