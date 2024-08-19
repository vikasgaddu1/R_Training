

# Anova Accel2R - Clinical R Training -----------------------------------

# Title: Data Quality Checks

# Packages & Functions on Display:
# tidyverse, janitor, lubridate, haven, dqldf
# 


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
library(lubridate)
library(janitor)
library(haven)
library(sqldf)

dm_a <- 
  read_sas("demo_studya.sas7bdat") %>%
  filter(patient != 2) %>%
  print()
summary(dm_a)
  
vistrt_a <- 
  read_sas("vistrt_studya.sas7bdat") %>%
  print()
summary(vistrt_a)

ae_a <- 
  read_sas("ae_studya.sas7bdat") %>%
  print()
summary(ae_a)

vitals_a <- 
  read_sas("vitals_studya.sas7bdat") %>%
  print()
summary(vitals_a)

ae_dm <-
  full_join(dm_a, ae_a, by = c("patient" = "patient")) %>%
  print()

vitals_dm <-
  full_join(dm_a, vitals_a, by = c("patient" = "patient")) %>%
  print()


# Missing values  ------------------------------------------------------------------------

# Across Data Frame
anyNA(dm_a)
sum(anyNA(dm_a))
anyNA(ae_a)
sum(anyNA(ae_a))

# On one variable.
sum(is.na(ae_a$soc_term))
sum(ae_a$soc_term == "")
sum(ae_a$soc_term == " ")
sum(ae_a$soc_term == ".")

sum(is.na(vitals_a$pulse))

sum(is.na(vitals_dm$pulse))

sum(is.infinite(vitals_dm$pulse))

vitals_dm$pulse/0

sum(is.infinite(vitals_dm$pulse / 0))



summary(vitals_a$pulse)
summary(vitals_a$bpd)
summary(vitals_a$bps)

lower_pulse = mean(vitals_a$pulse) - 2*sd(vitals_a$pulse)
upper_pulse = mean(vitals_a$pulse) + 2*sd(vitals_a$pulse)

# Identify Outliers based on mean and standard deviation
outliers <-
  vitals_a %>% 
  filter(pulse < lower_pulse | pulse > upper_pulse)

# See them graphically
ggplot(vitals_a, aes(x=visit, y=pulse, label = patient)) +
  geom_rect(aes(xmin = -Inf,
                xmax = Inf,
                ymin = mean(pulse, na.rm=TRUE) - 2*sd(pulse, na.rm=TRUE),
                ymax = mean(pulse, na.rm=TRUE) + 2*sd(pulse, na.rm=TRUE)),
            fill = "pink") +
  geom_point() +
  geom_text(data = outliers , color='red', size = 4, fontface = "bold", hjust=1.5)


# Invalid categories
vitals_a %>% 
  tabyl(timing)


# Date Validity
date_violations <- 
  ae_a %>% 
  mutate(stdate = as_date(aedtstart)) %>% 
  filter(is.na(stdate)) %>% 
  print()

suspicious_dob <-
  dm_a %>% 
  filter(dob > as.Date("1994-01-01") | dob < as.Date("1990-01-01")) %>% 
  print()

# Duplicates
dm_dups <- 
  dm_a %>% 
  get_dupes(inv, patient) %>%
  print()

ae_dm_dups <- 
  ae_dm %>% 
  get_dupes(inv, patient, visit.y, aeraw) %>%
  print()

ae_vs_dups <- 
  vitals_dm %>% 
  get_dupes(inv, patient, visit.y, timing) %>%
  print()

# Cross Data Frame Checks
indm_not_ae <-
  anti_join(dm_a, ae_a, by = c("patient" = "patient")) %>% 
  print()

inae_not_dm <-
  anti_join(ae_a, dm_a, by = c("patient" = "patient")) %>% 
  print()

indm_not_vitals <-
  anti_join(dm_a, vitals_a, by = c("patient" = "patient")) %>% 
  print()

invitals_not_dm <-
  anti_join(vitals_a, dm_a, by = c("patient" = "patient")) %>% 
  print()

indm_not_in_vitals_sql <- 
  sqldf("select * 
          from dm_a where patient not in (select distinct patient 
                                            from vitals_a)")  %>% 
  print()

inae_with_high_pulse <- 
  sqldf("select * 
          from ae_a where patient in (select distinct patient 
                                      from vitals_a
                                      where pulse > 140)") %>% 
  print()


# Data Attribute Consistency

setwd("C:/Users/User/ManpowerGroup/ES-SAS Migrations - Stage 3/Content/5.0 Supplemental Packages")

dataset_filenames <-
  dir(pattern = ".sas7bdat") %>%
  print()
 
dataset_list_named <- 
   dataset_filenames %>% 
   map(read_sas)  %>%   
   set_names(dataset_filenames) 

