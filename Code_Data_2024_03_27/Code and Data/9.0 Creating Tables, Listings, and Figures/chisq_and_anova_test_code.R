library(tidyverse)
library(broom)
library(janitor)
library(haven)

setwd("C:/Users/User/ManpowerGroup/ES-SAS Migrations - Stage 3/Content/6.0 Statistical Computing")

# Read in abc_adam_adsl.sas7bdat and bbc_adam_adsl.sas7bdat stacking them 
# together into a data frame called adsl. 
adsl <-
  bind_rows(read_sas('abc_adam_adsl.sas7bdat'), 
            read_sas('bbc_adam_adsl.sas7bdat')) %>% 
  select(STUDYID, SUBJID, ARM, SEX, AGEGR1, AGE) %>% 
  filter(ARM != "SCREEN FAILURE") %>% 
  mutate(ARM    = factor(ARM),
         SEX = factor(SEX),
         AGEGR1 = factor(AGEGR1))

# Create a nice table using the tabyl() function.
table_results <-
  adsl %>% 
  tabyl(SEX, ARM) %>%
  adorn_percentages(denominator = "col") %>%
  adorn_pct_formatting(digits = 2, rounding = "half up") %>%
  adorn_ns(position = "front")

# Chi Square Test ---------------------------------------------------------

stats_chisq <- stats::chisq.test(adsl$ARM, adsl$SEX, correct=FALSE) %>% print()
stats_chisq_adj <- stats::chisq.test(adsl$ARM, adsl$SEX, correct=TRUE) %>% print()

tidy_stats_chisq <-
  tidy(stats_chisq) 


# ANOVA Test ---------------------------------------------------------

stats_anova_AGE_ARM <- aov(AGE ~ ARM, data = adsl) %>% 
  print()

tidy_anova_AGE_ARM <-
  tidy(stats_anova_AGE_ARM)

