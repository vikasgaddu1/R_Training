# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Date Introduction -------------------------------------------------------

# String to date
dt1 <- as.Date("2020-06-14")
class(dt1)

# Internally stored as integer
as.numeric(dt1)

# Default Origin
as.numeric(as.Date("1970-01-01"))

# Prior to origin is negative
as.numeric(as.Date("1930-07-04"))

# Non-standard format
dt2 <- as.Date("14JUL2020", "%d%b%Y")
class(dt2)
dt2

# Sample formatting codes
# %d = day as a number
# %a = abbreviated weekday
# %A = unabbreviated weekday
# %m = month
# %b = abbreviated month
# %B = unabbreviated month
# %y = 2-digit year
# %Y = 4-digit year
# %H = hour
# %M = minute
# %S = second

# Format output
format(dt1, "%d/%m/%Y")
format(dt1, "%d.%m.%Y")
format(dt1, "%d")
format(dt1, "%m")
format(dt1, "%A")

# Date part functions
weekdays(dt1)
months(dt1)
quarters(dt1)

# Get current date
dt3 <- Sys.Date()
dt3

# Date arithmetic
dt3 + 30
dt3 - 10

# Date differences
diff1 <- dt2 - dt1
diff1
class(diff1)
as.numeric(diff1, units = "hours")
as.numeric(diff1, units = "weeks")

# Date sequences
dseq <- seq(as.Date("2020-01-01"), Sys.Date(), by = "month")
dseq

# All above functions work with vectors
v1 <- c("1930-07-04", "1944-10-17", "1950-05-21", "1963-02-11")
v2 <- c("1930-10-16", "1944-12-01", "1950-01-15", "1963-08-23")

# Convert vector of strings
dtv1 <- as.Date(v1)
dtv2 <- as.Date(v2)
dtv1
class(dtv1)

# Format vector
format(dtv1, "%d%b%Y")

# Date part functions
weekdays(dtv1)
quarters(dtv1)

# Date Vector Arithmetic
dtv1 + 10
dtv2 - dtv1

# Statistical functions
mean(dtv1)
min(dtv1)
max(dtv1)


# Time Introduction -------------------------------------------------------

# Get current time
tm1 <- Sys.time()
tm1
as.numeric(tm1)
class(tm1)

# Time calendar literal
# (Portable Operating System Interface)
tm2 <- as.POSIXct("2020-06-14 12:13:47 EDT")
tm2
class(tm2)

# Format times
format(tm1, "%d%b%Y %H:%M:%S")

# Time arithmetic
diff2 <- tm1 - tm2
diff2

# Time part extraction
as.numeric(diff2, units = "hours")


# Time List
tm3 <- as.POSIXlt("2020-06-14 12:13:47 EDT")
tm3
class(tm3)
tm3$mon
tm3$mday
tm3$min
tm3$zone
