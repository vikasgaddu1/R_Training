# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Setup -------------------------------------------------------------------
library(reporter)
library(magrittr)
library(readr)
library(logr)

options("logr.on" = TRUE, "logr.notes" = FALSE)

log_open("Listing1_0")


# Prepare Data ------------------------------------------------------------

sep("Read ADSL data")

dp <- "./5.14 Reporting/ADSL.csv"

dat <- read_csv(dp, na = c("NA")) %>% put()


# Print Report ------------------------------------------------------------


sep("Create Listing")

tbl <- create_table(dat) %>% 
  define(USUBJID, id_var = TRUE)

rpt <- create_report("output/Listing1_0.txt") %>% 
  page_header("Client: Anova", "Study: BBC") %>% 
  titles("Listing 1.0", "Analysis Data Subject Listing") %>% 
  add_content(tbl, align = "left") %>% 
  page_footer(Sys.time(), "Confidential", "Page [pg] of [tpg]")

write_report(rpt) %>% put()



# Clean Up ----------------------------------------------------------------



log_close()

