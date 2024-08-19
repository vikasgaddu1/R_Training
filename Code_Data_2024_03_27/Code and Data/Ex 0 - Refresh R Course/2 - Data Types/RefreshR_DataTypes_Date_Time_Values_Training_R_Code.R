
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Data Types - Date and Time Values

# Packages & Functions on Display:
# - {base 4.2.0}: as.Date(), as.POSIXct(), Sys.Date(), Sys.Time(), difftime(),
#
# - {lubridate 1.8.0}: today(), now(), as_date(), as_datetime(), dmy(), dmy_hms(),
#                     year(), minute(), yday(), wday(), month(), ceiling_date(),
#                     period(), years(), months(), days(), duration(), dyears(),
#                     dmonths(), ddays(), interval()


# Setup -------------------------------------------------------------------

library(lubridate)  # Lubridate is installed with tidyverse, but not loaded
library(tidyverse)


# Dates and Times in Base R -----------------------------------------------
# Dates and times are specified in quotes before being converted

vec_date <- as.Date("1970-01-01") %>% print()
vec_time <- as.POSIXct("1970-01-01 10:10:10") %>% print()


vec_date %>% as.numeric()  # Dates are the number of days since January 1, 1970
vec_time %>% as.numeric()  # Times are the number of secs since January 1, 1970


## Date Formats ----
# Control the incoming format, see help("strptime") for formatting characters
"01JAN1970" %>% as.Date(format = "%d%b%Y")


## Date/Time Functions ----
Sys.Date(); Sys.time()


## Date/Time Arithmetic ----
# Operates on the smallest unit provided (days/seconds)
vec_date + 10
vec_time - 10


## Date Differences ----
difftime(Sys.Date(), vec_date)
difftime(Sys.Date(), vec_date) %>% as.numeric()


## Date Sequence ----
seq(vec_date, Sys.Date(), by = "year")



# Dates and Times in Tidyverse --------------------------------------------

# Date/Time Functions
today(); now()


# Create Dates/Times
as_date("1970-01-01")
as_datetime("1970-01-01 10:10:10")


# Format Shortcuts (And many more...)
dmy("01JAN1970") ; dmy_h("01JAN1970 12")
mdy("01/01/1970"); mdy_hms("01/01/1970 10:10:10")


# Access Parts (there are functions for every part of the date and time)
vec_time %>% year()
vec_time %>% minute()


# Days in Period of Time (yday, qday, mday, wday)
vec_time %>% yday()      # 1st day of the year
vec_time %>% wday()      # 5th day of the week


# Date Labels
vec_time %>% month(label = T, abbr = T)
vec_time %>% wday(label = T, abbr = F)


# Rounding  (round_date, ceiling_date, rollbackward, rollforward)
vec_time %>% ceiling_date("month")



## Date Periods ----
# Adjusting for Leap Year and Daylight Savings

period("10y 10m 10d")
period("10 years 10 months 10 days 10 hours 10 minutes 10 seconds")
years(10) + months(10) + days(10)

# Period Arithmetic (with many other time period functions)
vec_time + years(10)



## Time Duration ----
# Number of seconds between two points
duration("10y 10m 10d")
dyears(10) + dmonths(10) + ddays(10)


## Date/Time Intervals ----
interval(vec_time, today())
interval(vec_time, today()) / days()    # A period of days
interval(vec_time, today()) / years()   # A period of years



# Documentation -----------------------------------------------------------

# Vignettes
vignette("lubridate", package = "lubridate")

# Help Pages
help("strptime")
help("as.Date")

# Website References
# - https://lubridate.tidyverse.org/
# - https://rstudio.com/resources/cheatsheets/
# - https://r4ds.had.co.nz/dates-and-times.html

# -------------------------------------------------------------------------
