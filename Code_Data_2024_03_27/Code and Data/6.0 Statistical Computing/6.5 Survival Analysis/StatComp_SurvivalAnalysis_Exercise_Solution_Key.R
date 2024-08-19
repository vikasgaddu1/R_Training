# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
library(broom)
library(haven)
library(survival)
library(survminer)

# Gather and Prepare Data -------------------------------------------------------------

# Read in the abc_adam_adpsga.sas7bdat and bbc_adam_adpsga.sas7bdat and stack them.
#  Also prepare the data using the following steps. Keep the variables USUBJID, TRTA,
#  AVISIT, AVISITN, AVAL & CRIT1FL. The resulting data frame should be named adpsga.
# a.Filter the data to PARAMCD equal to PSGA. TRTA not equal to "" and AVISITN not equal to NA.
#
# b.CRIT1FL='Y' is a successful endpoint. Split the data into USUBJID values that have a successful
#  endpoint and those that do not. For those that have a successful endpoint, only keep the record
#  for the minimum AVISITN value with a successful endpoint. For all other USUBJID values keep the record with the maximum value for AVISITN.
#
# c.Combine all the data together and create a variable called cured which is
#  TRUE for CRIT1FL='Y' and FALSE for CRIT1FL='N'.
#
# d.The resulting data frame should look like the excerpt below. Name it adslpsga_final.
#  For example, USUBJID ABC-01-049 was not cured so we kept their maximum visit.
#  But USUBJID ABC-01-052 was cured so we kept their first visit that they had a CRIT1FL="Y".
adsl <-
  bind_rows(read_sas('data/abc_adam_adsl.sas7bdat'),
            read_sas('data/bbc_adam_adsl.sas7bdat')) %>%
  select(USUBJID, SEX, AGEGR1, AGE)

adpsga <-
  bind_rows(read_sas('data/abc_adam_adpsga.sas7bdat'),
            read_sas('data/bbc_adam_adpsga.sas7bdat')) %>%
  filter(   PARAMCD =="PSGA" &
            TRTA != "" & !is.na(AVISITN)) %>%
  select(USUBJID, TRTA, AVISIT, AVISITN, AVAL, CRIT1FL)


adpsga_minvsuccess <-
  adpsga %>%
  filter(CRIT1FL == 'Y') %>%
  group_by(USUBJID) %>%
  summarize(minvisit = min(AVISITN))

adpsga_nosuccess <-
  anti_join(adpsga, adpsga_minvsuccess, by = ('USUBJID')) %>%
  group_by(USUBJID) %>%
  summarize(maxvisit = max(AVISITN))

adslpsga_final <-
  inner_join(adsl, adpsga, by = c('USUBJID')) %>%
  left_join(adpsga_minvsuccess, by = c('USUBJID')) %>%
  left_join(adpsga_nosuccess, by = c('USUBJID')) %>%
  filter((AVISITN == minvisit & !is.na(minvisit)) |
         (AVISITN == maxvisit & !is.na(maxvisit))) %>%
  mutate(cured    = case_when(CRIT1FL == "Y" ~ TRUE,
                              TRUE ~ as.logical(FALSE))) %>%
  select(-minvisit, -maxvisit)

summary(adslpsga_final)

# Create a survival vector named surv_vct using the Surv() function with time = AVISITN and
# event = cured. The printed vector should look like as shown below.
surv_vct <- Surv(time = adslpsga_final$AVISITN, event = adslpsga_final$cured)
surv_vct %>% print()
surv_vct %>% class()

# Use the ggsurv() function on the survival vector to generate the graph plot below.
surv_gg <- survminer::ggsurvevents(surv_vct)
surv_gg

# Use the survfit() function to fit the intercept only model on the survival vector surv_vct.
# Save the model to a list named stats_surv_int.
stats_surv_int <- survival::survfit(surv_vct ~ 1, data = adslpsga_final) %>% print()

# Working with the Model
stats_surv_int %>% typeof()
stats_surv_int %>% class()
stats_surv_int %>% names()
stats_surv_int$surv

# Tidying the Output
stats_surv_int %>% tidy()

# Use the survfit() function to fit the model on the survival vector surv_vct.
# The model should contain the variable TRTA. Save the model to a list named stats_survfit_trta.
stats_survfit_trta <- survival::survfit(surv_vct ~ TRTA, data = adslpsga_final) %>%
  print()

# Use the survdiff() function to fit the logrank model on the survival vector surv_vct.
# The model should contain TRTA. Save the model to a list named stats_survdiff_trta.
stats_survdiff_trta <- survival::survdiff(surv_vct ~ TRTA, data = adslpsga_final) %>%
  print()

# Cox Proportional Hazards ------------------------------------------------
# Now run a Cox Proportional Hazard model on the data frame adslpsga_final with the variables
# AGE and TRTA in the model. Save the model to a list named stats_surv_cph.
stats_surv_cph   <- survival::coxph(surv_vct ~ AGE + TRTA,         data = adslpsga_final) %>%
  print()

# Now run a Cox Proportional Hazard model on the data frame adslpsga_final with the variable
# AGE and a strata variable of TRTA. Save the model to a list named stats_surv_cph_s.
stats_surv_cph_s <- survival::coxph(surv_vct ~ AGE + strata(TRTA), data = adslpsga_final) %>%
  print()


# Tidying the Output
stats_surv_cph_s %>% tidy()
stats_surv_cph_s %>% glance()


# CPH Diagnostics
stats_surv_cph_s %>% survminer::ggcoxdiagnostics()
stats_surv_cph_s %>% survminer::ggcoxdiagnostics(type = "deviance")


# CPH Assumptions - Schoenfeld Test
stats_surv_cph_s <- stats_surv_cph_s %>% survival::cox.zph()
stats_surv_cph_s

# Now use the ggcoxzph() function on the model stats_surv_cph_s
stats_surv_cph_s %>% ggcoxzph()

