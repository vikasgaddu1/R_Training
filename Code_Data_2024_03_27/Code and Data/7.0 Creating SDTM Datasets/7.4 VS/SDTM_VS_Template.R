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


put("Read DM")


put("Read SV")


put("Read RANPOP")



# Prepare Formats ---------------------------------------------------------


sep("Load SDTM format catalog")

pth <- "./data/abc/sdtm_fmts.fcat" %>% put()

sdtm_fmts <- read.fcat(pth) %>% put()


# Prepare Data ------------------------------------------------------------



sep("Pre-process data")

put("Select needed columns from DM.")



put("Select needed columns from VS and create USUBJID and VISITNUM.")



put("Join DM and SV to VS.")


put("Transform vital signs variables")



put("Add sequence variable")




# Create Final Data Frame -------------------------------------------------


sep("Add and modify columns from combined data frame.")


put("Create staged data frame with columns according to spec")



put("Get max baseline dates")


put("Clear out VSBLFL")


put("Create final data frame")


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


