# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 3
vs_analysis <- readRDS('data/vs_analysis.rds')

# Exercise Step 4
# Use the summary() function on the Diff_fromLastMAP variable. You should get the following output to the console.
# Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's
# -26.7000  -5.4000   0.0000  -0.1684   4.6250  29.3000       94
summary(vs_analysis$Diff_fromLastMAP)

# Exercise Step 5
# Reproduce these results by using a summarize() function. The following should be the results printed to the console when you are finished.
# # A tibble: 1 x 7
# min firstq median   mean thirdq   max   NAs
# <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl> <int>
#  1 -26.7   -5.4      0 -0.168   4.62  29.3    94
vs_analysis %>%
  select(Diff_fromLastMAP) %>%
  summarize(
    min = min(Diff_fromLastMAP, na.rm = TRUE),
    firstq = quantile(Diff_fromLastMAP, prob = .25, na.rm = TRUE),
    median = median(Diff_fromLastMAP, na.rm = TRUE),
    mean = mean(Diff_fromLastMAP, na.rm = TRUE),
    thirdq = quantile(Diff_fromLastMAP, prob = .75, na.rm = TRUE),
    max = max(Diff_fromLastMAP, na.rm = TRUE),
    NAs = sum(is.na(Diff_fromLastMAP))
  )


# Exercise Step 6
# Using the MAP variable in the vs_analysis data frame. Use the summarize() function to create a summary for
# subject "01-051" that contains the following summary statistics: # of non-missing, # of missing, minimum,
# median, mean, maximum, first value, second value, last value. The results should be saved in a data frame named
# vsa_01_051. The following should be the results printed to the data frame when you print(vsa_01_051).
#  # A tibble: 1 x 9
#  n_MAP nmiss_MAP min_MAP median_MAP mean_MAP max_MAP first_MAP second_MAP last_MAP
# <int>     <int>   <dbl>      <dbl>    <dbl>   <dbl>     <dbl>      <dbl>    <dbl>
#  1     7         1    86.7       98.7     95.5    107.      107.         NA     99.3
vsa_01_051 <- vs_analysis %>%
  filter(SUBJECT == "01-051") %>%
  summarise(
    n_MAP = sum(!is.na(MAP)),
    nmiss_MAP = sum(is.na(MAP)),
    min_MAP = min(MAP, na.rm = TRUE),
    median_MAP = median(MAP, na.rm = TRUE),
    mean_MAP = mean(MAP, na.rm = TRUE),
    max_MAP = max(MAP, na.rm = TRUE),
    first_MAP = first(MAP),
    second_MAP = nth(MAP, 2),
    last_MAP = last(MAP)
  )
vsa_01_051


# Exercise Step 7
# Create a data frame named deciles which contains the deciles for the variables PULSE, TempF, and MAP from the data frame
# vs_analysis. When the deciles data frame is printed to the console, it should look like the following:
#
#  # A tibble: 9 x 4
#  Decile Pulse_Deciles TempF_Deciles MAP_Deciles
# <chr>          <dbl>         <dbl>       <dbl>
# 1 10%               62          96.8        80.2
# 2 20%               66          97.0        86
# 3 30%               68          97.2        88
# 4 40%               72          97.2        91.3
# 5 50%               72          97.3        93.3
# 6 60%               76          97.5        96
# 7 70%               78          97.7        98.7
# 8 80%               80          97.9       102.
# 9 90%               88          98.3       107.
deciles <-
  vs_analysis %>%
  summarise(
    Decile = c("10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%"),
    Pulse_Deciles = quantile(
      PULSE,
      probs = c(.1, 0.20, .3, .4,  0.50, .6, .7,  0.80, .9),
      na.rm = TRUE
    ),
    TempF_Deciles = quantile(
      TempF,
      probs = c(.1, 0.20, .3, .4,  0.50, .6, .7,  0.80, .9),
      na.rm = TRUE
    ),
    MAP_Deciles = quantile(
      MAP,
      probs = c(.1, 0.20, .3, .4,  0.50, .6, .7,  0.80, .9),
      na.rm = TRUE
    ),
  )
deciles


