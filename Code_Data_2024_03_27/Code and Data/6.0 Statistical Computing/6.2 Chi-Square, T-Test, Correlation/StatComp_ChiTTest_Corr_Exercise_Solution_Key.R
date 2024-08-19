-# Anova Accel2R - Clinical R Training -----------------------------------
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
  bind_rows(read_sas('data/abc_adam_adsl.sas7bdat'),
            read_sas('data/bbc_adam_adsl.sas7bdat')) %>%
  select(STUDYID, SUBJID, ARM, SEX, AGEGR1) %>%
  mutate(ARM    = factor(ARM),
         SEX = factor(SEX),
         AGEGR1 = factor(AGEGR1))

# Exercise Step 5
# Create a nice table using the tabyl() function.
table_results <-
  adsl %>%
  tabyl(STUDYID, SEX) %>%
  adorn_percentages(denominator = "col") %>%
  adorn_pct_formatting(digits = 2, rounding = "half up") %>%
  adorn_ns(position = "front")


# Exercise Step 6
# Chi Square Test ---------------------------------------------------------

#	Using the chisq.test() function, test for a relationship between
# STUDYID and SEX. Generate a Pearson and Adjusted Pearson Chi Square
# statistic.
stats_chisq <- stats::chisq.test(adsl$STUDYID, adsl$SEX, correct = FALSE) %>% print()
stats_chisq_adj <- stats::chisq.test(adsl$STUDYID, adsl$SEX, correct = TRUE) %>% print()

tidy_stats_chisq <-
  tidy(stats_chisq)

aug_stats_chisq <-
  augment(stats_chisq)

tidy_stats_chisq_adj <-
  tidy(stats_chisq_adj)


# Exercise Step 7
# Correlations ------------------------------------------------------------

# Read in the abc_adam_advs.sas7bdat and bbc_adam_advs.sas7bdat stacking
# them together into a data frame called advs. Filter by ADY = 1 and only
# keep the following PARAMCD values of "TEMP", "PULSE", and "RESP".
# Transpose the data so each PARAMCD value is its own variable with the
# values from AVAL. Use the id_cols parameter to keep the variables STUDYID
# and SUBJID.
advs <-
  bind_rows(read_sas('data/abc_adam_advs.sas7bdat'),
            read_sas('data/bbc_adam_advs.sas7bdat')) %>%
  filter(ADY == 1 & TRTA != "" &
        (PARAMCD == 'RESP' | PARAMCD == 'TEMP' | PARAMCD == 'PULSE')) %>%
  pivot_wider(id_cols = c(STUDYID, SUBJID),
              names_from = PARAMCD,
              values_from = AVAL)

# Exercise Step 8
# Using the cor() function and cor.test() function. Calculate the correlation
# for PULSE vs TEMP. Tidy the results from the cor.test() function.
advs_corr <-
  cor(advs$PULSE, advs$TEMP, use = "all.obs",
      method = "pearson")

advs_corr_test <-
  cor.test(advs$PULSE, advs$TEMP, use = "all.obs",
      method = c("pearson"))

tidy(advs_corr_test)


# Exercise Step 9
# T-Test ------------------------------------------------------------------

# Using the t.test() function perform a T-Test to see if there is a
# significant difference in PULSE between the two STUDYID values.
# Tidy the results.
stats_twot <- stats::t.test(PULSE ~ STUDYID, data = advs, var = TRUE) %>%
  tidy()


# Exercise Step 10
# Using the t.test() function perform a Welch's T-Test to see if there is a
# significant difference in PULSE between the two STUDYID values.
# Tidy the results.
stats_welt <- stats::t.test(PULSE ~ STUDYID, data = advs, var = FALSE) %>%
  tidy()


# Exercise Step 11
# Normality Check ---------------------------------------------------------

# Test the PULSE variable for normality using the shapiro.test() function.
# Also use the hist() and qqnorm() functions to view the histogram and
# QQ plots for PULSE.
shapiro.test(advs$PULSE) %>%
  tidy()

hist(advs$PULSE)
qqnorm(advs$PULSE)


# Exercise Step 12
# Generate the Summary and Pearson's Chi Square test statistic Values and
# P-values that would go in the table excerpt below. Use the adsl data frame
# and exclude the records where ARM is equal to "SCREEN FAILURE".
# There should be one for testing a relationship between ARM and AGEGR1 and
# one for ARM vs SEX. Use the Pearson test without the Yate's correction.
adsl2 <-
  adsl %>%
  filter(ARM != "SCREEN FAILURE") %>%
  mutate(ARM = factor(ARM),
         AGEGR1 = factor(AGEGR1,
                         levels = c("18-29 years", "30-39 years",
                                    "40-49 years", "50-65 years",
                                    ">65 years"),
                         ordered = TRUE),
         SEX = factor(SEX,
                      levels = c("M", "F"),
                      labels = c("Male", "Female"),
                      ordered = TRUE))


adsl2 %>%
  tabyl(AGEGR1, ARM) %>%
  adorn_percentages(denominator = "col") %>%
  adorn_pct_formatting(digits = 2, rounding = "half up") %>%
  adorn_ns(position = "front")

adsl2 %>%
  tabyl(ARM)

ARM_AGEGR1_chisq <- chisq.test(adsl2$ARM, adsl2$AGEGR1, correct = FALSE) %>% print()
tidy(ARM_AGEGR1_chisq)


adsl2 %>%
  tabyl(SEX, ARM) %>%
  adorn_percentages(denominator = "col") %>%
  adorn_pct_formatting(digits = 2, rounding = "half up") %>%
  adorn_ns(position = "front")

ARM_SEX_chisq <- chisq.test(adsl2$ARM, adsl2$SEX, correct = FALSE) %>% print()
tidy(ARM_SEX_chisq)




