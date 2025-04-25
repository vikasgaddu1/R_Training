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

dp <- "_data/abc/SDTM/DM.rds"

dat <- read_rds(dp) %>% put()
names(dat)

# Print Report ------------------------------------------------------------


sep("Create Listing")

tbl <- create_table(dat, use_attributes = "none") %>% 
  define(USUBJID, id_var = TRUE, label = "Subject ID")

rpt <- create_report("_output/Listing1_0.txt", output_type = "TXT") %>% 
  page_header("Client: Anova", "Study: ABC") %>% 
  titles("Listing 1.0", "Demographics") %>% 
  add_content(tbl, align = "left") %>% 
  page_footer(Sys.time(), "Confidential", "Page [pg] of [tpg]")

write_report(rpt) %>% put()

install.packages("rlistings")

library(rlistings)

lst <- as_listing(dat,
           key_cols = c("USUBJID"),
           disp_cols = c("SEX", "RACE", "ETHNIC")
           ) 
  main_title(lst) <- "Listing 16.1.1: Demographics" 

export_as_txt(lst, "_output/rListing1_0.txt")
# Clean Up ----------------------------------------------------------------



log_close()

