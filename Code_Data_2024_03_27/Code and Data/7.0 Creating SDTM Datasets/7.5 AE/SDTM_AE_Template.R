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


put("Read AESR")


put("Read AESF")
put("  Fill in missing AESF with AEFENDT in new variable aefdtnew")



put("Combine AESR and AESF and apply values from AESF")
put("  Create new variables taking into account missing and/or incomplete dates.")


  
# Prepare Data ------------------------------------------------------------



# Create Final Data Frame -------------------------------------------------
put("Create final data frame")


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


