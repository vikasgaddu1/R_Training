
# Anova Accel2R - Clinical R Training -----------------------------------

# Title: Tidyverse Date Operations with lubridate

# Packages & Functions on Display:
# - {lubridate 1.7.9}: now, today, as_date, as_datetime, period, duration, interval,
#                     ymd, year, month, day, update, %--%, %within%


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
library(lubridate)


# Basic Date Operations ---------------------------------------------------

lubridate::now()
lubridate::today()

# Convert from String to Date, Default Format
dt <- as_date("2020-01-15")
format(dt,"%d%b%Y")
class(dt)

dtm <- as_datetime("2020-01-15 12:30:00")
class(dtm)

# Provide Custom Format
format = "%Y%m%d"
as_date("20200115",format=format )
as_datetime("20200115 153045", format = "%Y%m%d %H%M%S")

# Format Shortcuts
ymd("20200115")
mdy("01/15/2020")
dmy("01JAN2020")
ydm("20-15-06")

ymd_h(  "2020-01-15 12",       tz = "EST")
ymd_hm( "2020-01-15 12:30",    tz = "EST")
ymd_hms("2020-01-15 12:30:00", tz = "EST")
# *_hms(): mdy, dmy, ydm, etc.


# Access Date Parts -------------------------------------------------------

date_string_1 <- "2025-02-09 12:30:15"

year(date_string_1)
quarter(date_string_1)
month(date_string_1)
day(date_string_1)
minute(date_string_1)
second(date_string_1)
tz(date_string_1)
# others: millisecond, microsecond, nanosecond, picosecond


# Days of the Period
yday(date_string_1)
qday(date_string_1)
mday(date_string_1)
wday(date_string_1)


# Labels and Abbreviations
wday( date_string_1, label = TRUE, abbr = FALSE)
month(date_string_1, label = TRUE, abbr = TRUE)


# Updating Date Parts -----------------------------------------------------

date_string <- as_datetime("2020-01-15 12:30:00 EST") %>% print()

stats::update(date_string, year = 1920)
stats::update(date_string, year = 1920, day = 5, minute = 45, tz = "EST")


# Update Individually
second(date_string) <- 45;   print(date_string)
minute(date_string) <- 30;   print(date_string)
hour(date_string)   <- 15;   print(date_string)
day(date_string)    <- 10;   print(date_string)
month(date_string)  <- 05;   print(date_string)
year(date_string)   <- 1920; print(date_string)


# Rounding Dates ----------------------------------------------------------
# units: seconds, minute, hour, day, week, month, bimonth, quarter,
#       season, halfyear, year

date_string <- as_datetime("2020-07-15 12:30:00 EST") %>% print()

round_date(date_string,   unit = "year")
ceiling_date(date_string, unit = "month")
floor_date(date_string,   unit = "week")

# Roll Back to Beginning of Month
rollback(date_string, roll_to_first = FALSE)
rollback(date_string, roll_to_first = TRUE)
rollforward(date_string, roll_to_first = TRUE)


# Date Periods ------------------------------------------------------------
# Observed Clock Time - Adjusts for leap year and daylight savings

date_period <- period("10y 10m 10d")

date_string         # Moment of Time
date_period         # Period of Time

class(date_string)
class(date_period)

# More Period Definitions
period("90d")
period("90 days")
period(90, "days")
period(days = 90)


# Period Arithmetic
date_string + date_period
date_string - date_period

# Period Parts
years(10)
months(10)
weeks(10)

date_string - years(10)
date_string + months(10)
date_string - weeks(10)
# others: quarters, days, hours, minutes, seconds, etc.


# Time Duration -----------------------------------------------------------
# Number of Seconds Passed: No adjustments for leap years, daylight savings

date_duration <- duration("10y 10m 10d")

date_string    # Moment of Time
date_duration  # Duration of Time (s)

class(date_duration)


# More Duration Definitions
duration("90d")
duration("90 days")
duration(90, "days")
duration(days = 90)


# Duration Arithmetic
date_string - date_duration


# Duration Parts
dyears(10)
dmonths(10)
dweeks(10)

date_string - dyears(10)
date_string + dmonths(10)
date_string - dweeks(10)
# others: ddays, dhours, dminutes, dseconds, etc.

library(lubridate)

# Define start and end date-times around a DST transition
start <- mdy_hm("3-11-2017 5:21", tz = "US/Eastern")
end   <- mdy_hm("3-12-2017 5:21", tz = "US/Eastern")
intv  <- start %--% end

# Convert the interval to a duration (exact elapsed seconds)
dur <- as.duration(intv)
print(dur)

#> [1] "82800s (~23 hours)"

# Convert the interval to a period (calendar time)
per <- as.period(intv)
print(per)
#> [1] "1d 0H 0M 0S"


# Date Intervals ----------------------------------------------------------

date_checkins <- date_string + months(c(0, 2, 6, 12))
date_checkins

date_interval <- int_diff(date_checkins)

date_interval
class(date_interval)


# Alternate Interval Definition
"2020-01-01" %--% "2020-06-01"
interval(start = "2020-01-01", end = "2020-06-01")


# Length of Interval (Seconds)
int_length(date_interval)


# Unit Conversion
date_interval / period("day")
date_interval / period("month")
date_interval / period("year")     # Adjust for leap year and daylight savings
date_interval / duration("year")   # Don't adjust for leap year and daylight savings


# Interval Endpoints
int_end(date_interval)
int_start(date_interval)


# Interval Flip
int_flip(date_interval)


# Shift an Interval
int_shift(date_interval, by = period("5 years"))
int_shift(date_interval, by = years(-10))


# Interval Overlap
ymd("2020AUG01") %within% date_interval


# Advanced - Date Use Case ------------------------------------------------

data_checkin <-
  tribble(~patient, ~dob, ~checkin_date,
          1, "1985-06-15", "2020-01-15",
          1, "1985-06-15", "2020-03-01",
          1, "1985-06-15", "2020-05-15",
          1, "1985-06-15", "2020-09-01")

data_checkin %>%
  distinct(patient, dob) %>%
  mutate(age_int = interval(dob, now()),
         age_yrs = age_int / period("years"))


data_checkin %>%
  group_by(patient) %>%
  reframe(interval = int_diff(checkin_date)) %>%
  mutate(d = interval / period("day"),
         m = interval / period("month"))


# Documentation -----------------------------------------------------------

# Vignettes
vignette("lubridate", package = "lubridate")

# Help Pages
help(ymd,      package = "lubridate")
help(as_date,  package = "lubridate")

help(period,   package = "lubridate")
help(duration, package = "lubridate")
help(interval, package = "lubridate")

# Website References
# - https://lubridate.tidyverse.org/
# - https://github.com/tidyverse/lubridate/
# - https://rstudio.com/resources/cheatsheets/


# Equivalent Operations ---------------------------------------------------

help("as.Date",  package = "base")
help("Sys.Date", package = "base")
help("Sys.time", package = "base")
help("difftime", package = "base")

# -------------------------------------------------------------------------
