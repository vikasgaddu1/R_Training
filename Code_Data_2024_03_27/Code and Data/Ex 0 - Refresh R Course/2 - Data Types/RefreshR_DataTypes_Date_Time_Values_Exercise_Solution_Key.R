# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(lubridate)  # Lubridate is installed with tidyverse, but not loaded

# Exercise Step 2
today_sd <- Sys.Date()
today_td <- today()

difftime(today_td, as.Date("2000-01-01"))

# Exercise Step 3
seq(as_date("2022-01-01"), as_date("2022-12-31"), by = "days")


# Exercise step 4
vec_times <- c(now(), as_datetime("2020-01-02 13:14:15"), as_datetime("2021-02-02 14:48:34"))

year(vec_times)
months(vec_times, abbreviate = F)
day(vec_times)
wday(vec_times, label = TRUE, abbr = FALSE)
hour(vec_times)
second(vec_times)

# Exercise Step 5
# example if your birthdate was January 1st, 1965
myage <- interval("1965-01-01", today()) / years()   # A period of years
