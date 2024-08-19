# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(haven)

# Exercise Step 3
# Read the file adae.rds from the course directory into a data frame called adae.
raw_vs <- read_sas('data/vs.sas7bdat')

# Construct a data frame called vs_analysis using vs.sas7bdat from the course level directory and the following
# requirements/steps.
# a.	Read in the following variables SUBJECT, VISIT, SYSBP, DIABP, PULSE, TEMP.
# b.	Create a new variable named VisitSeq that maps the following VISIT values to the corresponding numbers.
#    	screen = 0 , day1 = 1, wk2 = 2, wk4 = 3, wk6 = 4, wk8 = 5, wk12 = 6, wk16 = 7, eoset = 8).
#    	Move that variable to be after the VISIT variable.
# c.	Create a new variable name MAP which is calculated by (1/3) * SYSBP + (2/3)*DIABP. Round it to the 1st decimal place.
#    	Move the variable to be after the DIABP variable.
# d.	Create a new variable named TempF which is caluclated by TEMP*(9/5) + 32. Move the variable to be after the TEMP variable.
# e.	Sort by SUBJECT and VisitSeq.
# f.	Create a variable called LastMAP which is equal to NA at screen but equal to the lag(MAP) for other records.
# g.	Create a variable named Diff_fromLastMAP which is calculated by MAP - Diff_fromLastMAP.
# h.	Once your data frame is built, add descriptive lables to your newly calculated variables using the var_label
#    	function from the labelled package.

vs_analysis <-
   raw_vs %>%
   select(SUBJECT, VISIT, SYSBP, DIABP, PULSE, TEMP) %>%
   mutate(
      VisitSeq = case_when(
         VISIT == "screen" ~ 0,
         VISIT == "day1"   ~ 1,
         VISIT == "wk2"    ~ 2,
         VISIT == "wk4"    ~ 3,
         VISIT == "wk6"    ~ 4,
         VISIT == "wk8"    ~ 5,
         VISIT == "wk12"   ~ 6,
         VISIT == "wk16"   ~ 7,
         VISIT == "eoset"  ~ 8
      ),
      .after = VISIT
   ) %>%
   mutate(MAP = round((1 / 3) * SYSBP + (2 / 3) * DIABP, 1), .after = DIABP) %>%
   mutate(TempF = TEMP * 9 / 5 + 32, .after = TEMP) %>%
   arrange(SUBJECT, VisitSeq) %>%
   mutate(
      LastMAP = ifelse(VISIT == "screen", NA, lag(MAP)),
      Diff_fromLastMAP = MAP - LastMAP,
      .after = MAP
   )

library(labelled)

var_label(vs_analysis$VisitSeq) <- "Visit Sequence"
var_label(vs_analysis$MAP) <- "Mean Arterial Pressure"
var_label(vs_analysis$LastMAP) <- "Last MAP Reading"
var_label(vs_analysis$Diff_fromLastMAP) <- "Difference from Last MAP Reading"
var_label(vs_analysis$TempF) <- "Temperature (Fahrenheit)"

# Exercise Step 4
saveRDS(vs_analysis, 'data/vs_analysis.rds')


# Exercise Step 5
# Construct a data frame called BMI_Analysis using the data from vs.sas7bdat from the course level directory and the
# following requirements/steps.
# a.	Filter records to only include the screen VISIT.
# b.	Select only the SUBJECT, WEIGHT, and HEIGHT variables.
# c.	Replace NA values of HEIGHT and WEIGHT with the mean of the other subjects values for those variables respectively.
# d.	Create a variable called BMI that uses the formula WEIGHT(kg) / (HEIGHT(m) squared). WEIGHT is already in kg but
#    	HEIGHT needs to be converted from CM to M in the calculation.
# e.	Create a variable called ntile_BMI calculated using the ntile function with n=5
BMI_analysis <-
   raw_vs %>%
   filter(VISIT == 'screen') %>%
   select(SUBJECT, WEIGHT, HEIGHT) %>%
   mutate(HEIGHT = ifelse(is.na(HEIGHT), mean(HEIGHT, na.rm = TRUE), HEIGHT)) %>%
   mutate(WEIGHT = ifelse(is.na(WEIGHT), mean(WEIGHT, na.rm = TRUE), WEIGHT)) %>%
   mutate(BMI = WEIGHT / (HEIGHT / 100) ^ 2) %>%
   mutate(ntile_BMI = ntile(BMI, n = 5)) %>%
   arrange(BMI)

var_label(BMI_analysis$BMI) <- "BMI"
var_label(BMI_analysis$ntile_BMI) <- "BMI N-Tiles"

# Exercise Step 6
saveRDS(BMI_analysis, 'data/BMI_analysis.rds')

