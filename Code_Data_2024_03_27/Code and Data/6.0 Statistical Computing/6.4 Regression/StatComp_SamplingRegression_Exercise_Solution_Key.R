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
  filter(ADY == 1  & TRTA != "" &
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

# Exercise Step 7
adaapasi <-
  bind_rows(read_sas('abc_adam_adaapasi.sas7bdat'),
            read_sas('bbc_adam_adaapasi.sas7bdat')) %>%
  filter(  VISITNUM == 8 &
           PARAMCD == "PASISCOR" &
           TRTA != "" & 
           is.na(CHG) == FALSE) %>% 
  mutate(PASISCOR_Baseline = BASE,
         PASISCOR_Week8    = AVAL,
         PASISCOR_CFB      = CHG) %>% 
  select(STUDYID, SUBJID, PASISCOR_Baseline, PASISCOR_Week8, PASISCOR_CFB) 

# Exercise Step 8
ad_all <-
  inner_join(adslvs, adaapasi, by = c("STUDYID", "SUBJID")) 
  
summary(ad_all)

# Exercise Step 9
set.seed(20)
data_train <- 
  ad_all %>% 
 group_by(ARM) %>% 
  slice_sample(prop = 0.75)

data_valid <- anti_join(ad_all, data_train)

summary(data_train)
summary(data_valid)

# Exercise Step 10
# sampling without stratification
set.seed(20)
data_train_wostrat <- 
  ad_all %>% 
  slice_sample(prop = 0.75)

summary(data_train_wostrat)


ad_all %>% tabyl(ARM)
data_train %>% tabyl(ARM)

# Exercise Step 11
# Using the data_train data frame, run a linear regression using the model
# PASISCOR_CFB  = AGE + PULSE
stats_ols <- lm(PASISCOR_CFB ~ AGE + PULSE, data = data_train) %>% 
  print()

# Exercise Step 12
tidy(stats_ols)
augment(stats_ols)
glance(stats_ols)
summary(stats_ols)

# Exercise Step 13
#	Now use your model and the predict() function on the data_valid data frame and view the 
# predicted results. 
olspred <- 
  predict(stats_ols, data_valid) %>% 
  print()

# Exercise Step 14
# Now use your model on the data_valid data frame with the augment() function. 
# Select the variables STUDYID, SUBJID, AGE, PULSE, PASISCOR_CFB, .fitted, .resid and 
# print the results to the console. 
olsaug <- 
  augment(stats_ols, newdata = data_valid) %>% 
  select(STUDYID, SUBJID, AGE, PULSE, PASISCOR_CFB, .fitted, .resid) %>% 
  print()


# set.seed(20)
# RECOVERED <-
#  ad_all %>%  
#  slice_sample(prop = 0.25) %>% 
#  mutate(recovered=1) %>% 
#  select(STUDYID, SUBJID, recovered)  
# saveRDS(RECOVERED, 'recovered.rds')

# Exercise Step 15
# read in the file recovered.rds for a list of subjects who have recovered. 
RECOVERED <-
  readRDS('recovered.rds')

# Exercise Step 16
# Left join the recovered data onto the data_train and data_valid data frames. 
# If recovered is not equal to 1, set it to zero. 
ad_logreg_train <-
  data_train %>% 
  left_join(RECOVERED) %>% 
  mutate(recovered = factor(case_when(recovered == 1 ~ 1,
                               TRUE ~ (0))))

tabyl(ad_logreg_train, recovered )


ad_logreg_valid <-
  data_valid %>% 
  left_join(RECOVERED) %>% 
  mutate(recovered = factor(case_when(recovered == 1 ~ 1,
                               TRUE ~ (0))))

tabyl(ad_logreg_valid, recovered )

ad_logreg_train %>% 
  tabyl(recovered, ARM)
ad_logreg_valid %>% 
  tabyl(recovered, ARM)

# Exercise Step 17
stats_lr <-
  glm(relevel(recovered, ref = 1)  ~ AGE + PULSE, data = ad_logreg_train,
      family = "binomial")

# Exercise Step 18
# Using the Results
stats_lr

# Tidying the Results
stats_lr %>% glance()
stats_lr %>% augment()

stats_lr %>% tidy()
stats_lr %>% tidy(conf.int = TRUE)

# Create confidence intervals using the exponentiate=TRUE parameter on the tidy() function. 
stats_lr %>% tidy(conf.int = TRUE, exponentiate = TRUE)    # Request Odds Ratios

# Diagnostics
plot(stats_lr)

# Exercise Step 19 
# Prediction
predict(stats_lr, new_data = data_valid, type = "response")
augment(stats_lr, new_data = data_valid, type.predict = "response")

