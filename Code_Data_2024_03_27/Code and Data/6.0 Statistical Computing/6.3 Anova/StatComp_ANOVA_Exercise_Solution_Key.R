# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

# Exercise Step 3
library(tidyverse)
library(broom)
library(janitor)
library(haven)

# Exercise Step 4
# Read in abc_adam_adsl.sas7bdat and bbc_adam_adsl.sas7bdat stacking them 
# together into a data frame called adsl. 
adsl <-
  bind_rows(read_sas('abc_adam_adsl.sas7bdat'), 
            read_sas('bbc_adam_adsl.sas7bdat')) %>% 
  select(STUDYID, SUBJID, ARM, SEX, AGEGR1, AGE) 


# Exercise Step 5
# Read in the abc_adam_advs.sas7bdat and bbc_adam_advs.sas7bdat stacking 
# them together into a data frame called advs. Filter by ADY = 1 and only 
# keep the following PARAMCD values of "TEMP", "PULSE", and "RESP". 
# Transpose the data so each PARAMCD value is its own variable with the 
# values from AVAL. Use the id_cols parameter to keep the variables STUDYID 
# and SUBJID.
advs <-
  bind_rows(read_sas('abc_adam_advs.sas7bdat'),
            read_sas('bbc_adam_advs.sas7bdat')) %>% 
  filter(ADY == 1 & TRTA != "" &
           (PARAMCD == 'RESP' | PARAMCD == 'TEMP' | PARAMCD == 'PULSE')) %>% 
  pivot_wider(id_cols = c(STUDYID, SUBJID),
              names_from = PARAMCD,
              values_from = AVAL)


# Exercise Step 6
adslvs <-
  inner_join(adsl, advs, by = c("STUDYID", "SUBJID")) %>% 
  mutate(STUDYID = factor(STUDYID),
         ARM     = factor(ARM),
         AGEGR1 = factor(AGEGR1,
                         levels = c("18-29 years", "30-39 years",
                                    "40-49 years", "50-65 years",
                                    ">65 years"),
                         ordered = TRUE),
         SEX = factor(SEX,
                      levels = c("M", "F"),
                      labels = c("Male", "Female"),
                      ordered = TRUE))


summary(adslvs$AGE)
summary(adslvs$PULSE)

# Exercise Step 7
# Test for a significant difference in PULSE between values of SEX by 
# running a one way ANOVA using the model PULSE = SEX. Tidy the results 
# using the tidy() function. 
stats_anova_PULSE_SEX <- aov(PULSE ~ SEX, data = adslvs) %>% 
# tidy() %>% 
  print()
summary(stats_anova_PULSE_SEX)

# Exercise Step 8
#	Test for a significant difference in PULSE between values of SEX and 
# the variable AGE by running a one way ANCOVA using the model PULSE = SEX 
# and the variable AGE. Tidy the results using the tidy() function. 
stats_ancova_PULSE_SEX_AGE <- aov(PULSE ~ SEX + AGE, data = adslvs) %>% 
  tidy() %>% 
  print()

# Exercise Step 9
#	Test for a significant difference in PULSE between values of SEX and 
# AGEGR1 by running a two way ANOVA using the model PULSE = SEX AGEGR1.
# Tidy the results using the tidy() function.
stats_anova_PULSE_SEX_AGEGR1 <- aov(PULSE ~ SEX + AGEGR1, data = adslvs) %>% 
  tidy() %>% 
  print()

# Exercise Step 10
#	Test for a significant difference in PULSE between values of SEX and AGEGR1 
# by running a two way ANOVA using the model PULSE = SEX AGEGR1 and the 
# interactions of SEX and AGEGR1. Tidy the results using the tidy() function.
stats_anova_factorial_PULSE_SEX_AGEGR1_tidy <- aov(PULSE ~ SEX*AGEGR1, data = adslvs) %>% 
  tidy() %>% 
  print()

# Exercise Step 11
# Run the same model but use the augment() function instead of the tidy() 
# function.
stats_anova_factorial_PULSE_SEX_AGEGR1_aug <- aov(PULSE ~ SEX*AGEGR1, data = adslvs) %>% 
  augment() %>% 
  print()

# Exercise Step 12
# Run the same model but use the glance() function instead of the tidy() 
# function.
stats_anova_factorial_PULSE_SEX_AGEGR1_glance <- aov(PULSE ~ SEX*AGEGR1, data = adslvs) %>% 
  glance() %>% 
  print()

# Exercise Step 13
# Run the same model but use the plot().
aov(PULSE ~ SEX*AGEGR1, data = adslvs) %>% 
  plot()


# Exercise Step 14
# Using the same model, run the shapiro.test() function on the residuals. 
# Your tidied results should look like the following:
shapiro.test(stats_anova_factorial_PULSE_SEX_AGEGR1_aug$.resid) %>% 
  tidy()

