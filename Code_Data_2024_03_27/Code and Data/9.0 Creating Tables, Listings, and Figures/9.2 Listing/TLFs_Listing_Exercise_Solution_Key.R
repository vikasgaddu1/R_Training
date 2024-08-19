# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(reporter)
library(magrittr)
library(readr)
library(logr)

options("logr.on" = TRUE, "logr.notes" = TRUE)

log_open("Listing1_0")


# Prepare Data ------------------------------------------------------------

sep("Read DM data")

dp <- "data/abc/SDTM/DM.rds"

dat <- read_rds(dp) %>% put()


# Print Report ------------------------------------------------------------


sep("Create Listing")

tbl <- create_table(dat, use_attributes = "none") %>% 
  define(USUBJID, id_var = TRUE)

rpt <- create_report("output/Listing1_0.txt", output_type = "TXT") %>% 
  page_header("Client: Anova", "Study: ABC") %>% 
  titles("Listing 1.0", "Demographics") %>% 
  add_content(tbl, align = "left") %>% 
  page_footer(Sys.time(), "Confidential", "Page [pg] of [tpg]")

write_report(rpt) %>% put()



# Clean Up ----------------------------------------------------------------



log_close()

