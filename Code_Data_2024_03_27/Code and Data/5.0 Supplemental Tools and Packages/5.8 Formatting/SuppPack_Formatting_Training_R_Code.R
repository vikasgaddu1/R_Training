# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Setup -------------------------------------------------------------------

# Introduction ------------------------------------------------------------

# No equivalent to SAS® formats in R

# But there are ways to format data
# - Named vectors as decodes
# - format() for dates and numbers
# - sprintf() for numbers and strings
# - scales package functions
# - Custom vectorized functions

library(tidyverse)
library(haven)
library(fmtr)

# Import Data -------------------------------------------------------------


# Load Data
# dat  <- file.path("./data", "abc_adam_advs.sas7bdat") %>%
dat <-  read_sas("abc_adam_advs.sas7bdat") %>% 
  select(USUBJID, SITEID, TRTA, ADT, AVISIT, AVISITN, PARAM, PARAMCD, AVAL) %>% 
  filter(AVISIT != "Screening") %>% arrange(SITEID, USUBJID, AVISITN, PARAMCD)

View(dat)

# Apply formatting to columns ---------------------------------------------

# Create site decode
site_decode <- c("01" = "San Francisco", 
                 "02" = "London", 
                 "03" = "Tokyo",
                 "04" = "Beijing",
                 "05" = "Paris",
                 "06" = "Berlin", 
                 "07" = "Moscow",
                 "08" = "Capetown", 
                 "09" = "Rio de Janeiro")

# Create user-defined format for treatment
trt_fmt <- value(condition(x == "ARM A", "Placebo"),
                 condition(x == "ARM B", "Drug 50mg"), 
                 condition(x == "ARM C", "Drug 100mg"),
                 condition(x == "ARM D", "Competitor"),
                 condition(TRUE, "Missing"))

# Assign formats to data frame attributes (attr())
formats(dat) <- list(SITEID = site_decode,
                     TRTA = trt_fmt,
                     ADT = "%d %b %Y",
                     AVAL = "%.2f")
# View attributes
str(dat)

dat$SITEID2 <- fapply(dat$SITEID)

# Apply formats
dat_fmt <- fdata(dat)


View(dat_fmt)



# Formatting Code Refresher -----------------------------------------------


# Date/Time Formatting codes
# %d = day as a number 
# %a = abbreviated weekday
# %A = unabbreviated weekday	
# %m = month 
# %b = abbreviated month
# %B = unabbreviated month
# %y = 2-digit year
# %Y = 4-digit year	
# %H = hour
# %M = minute
# %S = second

# Examples:
# Standard mdy Date: "%m/%d/%Y"

# Number and Strings Formatting 
# %s = string
# %d = integer
# %f = decimal number

# Examples:
# One decimal place = "%.1f"       
# Fixed width = "%8.1f"      
# Zero padded = "%08.1f"   
# Forced sign = "%+.1f"
# Percentage = "%.1f%%"
# Currency = "$%.2f"      


# Formatting List ---------------------------------------------------------

# Create user-define format for respirations
resp_fmt <- value(condition(is.na(x) | trimws(x) == "", "Missing"),
                  condition(x > 16, "High"),
                  condition(x < 12, "Low"), 
                  condition(TRUE, "Normal"))

# Create vectorized function for pulse
pulse_fmt <- Vectorize(function(x) {
  
  ret <- ""
  
  if (is.na(x) | trimws(x) == "")
    ret <- "Missing"
  else if (x > 100)
    ret <- "High"
  else if (x < 60)
    ret <- "Low"
  else
    ret <- as.character(round(x))
  
  return(ret)
  
})

# Formatting list
aval_fmt <- flist(type = "row", lookup = dat$PARAMCD,
                  TEMP = "%.1f°C",
                  SYSBP = "%.0f mmHg", 
                  DIABP = "%.0f mmHg", 
                  RESP = resp_fmt,
                  PULSE = pulse_fmt,
                  PCTBSA = "%.0f%%")


# Assign formats to data frame attributes (attr())
formats(dat) <- list(SITEID = site_decode,
                     TRTA = trt_fmt,
                     ADT = "%d %b %Y",
                     AVAL = aval_fmt)

# Apply formatting list
dat_fmt <- fdata(dat)

View(dat_fmt)

# See if pulse_fmt is working
pdat <- dat_fmt %>% filter(PARAMCD == "PULSE")

View(pdat)

# Formatting Helper Functions ---------------------------------------------

# Helper function for range
# Calculates and formats
fmt_range(dat$AVAL)

# Calculate summary statistics for each patient
summary_pulse <- dat %>% filter(PARAMCD == "PULSE") %>% 
  group_by(SITEID, USUBJID) %>% 
  summarize(PARAM = "PULSE",
            n = fmt_n(AVAL),
            "Mean (SD)" = fmt_mean_sd(AVAL),
            Median = fmt_median(AVAL),
            "Q1 - Q3" = fmt_quantile_range(AVAL),
            "Min - Max" = fmt_range(AVAL)) %>% 
  pivot_longer(cols = c(n, `Mean (SD)`, Median, `Q1 - Q3`, `Min - Max`),
               names_to = "LABEL",
               values_to = "STAT")

View(summary_pulse)

# Calculate population counts for treatment groups
resp_pop <- dat_fmt %>% count(TRTA) %>% deframe()
resp_pop

# Create frequency counts and percents for treatment groups
freq_resp <- dat_fmt %>% filter(PARAMCD == "RESP") %>% 
  group_by(TRTA, AVAL) %>% 
  summarize(PARAM = "RESP",
            n = n()) %>% 
  pivot_wider(names_from = TRTA,
              values_from = n, 
              values_fill = 0) %>% 
  transmute(PARAM, 
            LABEL = factor(AVAL, levels = c("Normal", "High", "Low", "Missing")), 
            Placebo = fmt_cnt_pct(Placebo, resp_pop[["Placebo"]]),
            `Drug 50mg` = fmt_cnt_pct(`Drug 50mg`, resp_pop[["Drug 50mg"]]),   
            `Drug 100mg` = fmt_cnt_pct(`Drug 100mg`, resp_pop[["Drug 100mg"]]), 
            Competitor = fmt_cnt_pct(Competitor, resp_pop[["Competitor"]])) %>% 
  arrange(LABEL)

View(freq_resp)

# Documentation -----------------------------------------------------------


# Vignette
# https://cran.r-project.org/web/packages/fmtr/vignettes/fmtr-vignette.html


