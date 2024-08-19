# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Dates Exercises ------------------------

# Exercise Step 3
weekdays(as.Date("<your dob here>"), abbreviate = FALSE)

# Exercise Step 4
#	Create a vector that returns the first day of each month of 2019.
fdm2019 <- seq(as.Date("2019-01-01"), as.Date("2019-12-31"), by = "month")
fdm2019


# Exercise Step 5
# C4)	Create a function called find_fri13 that finds and returns a vector containing all Friday the 13ths
# for the four digit year you pass in.
find_fri13 <- function(yyyy) {

  mon13 <- seq(as.Date(paste(yyyy, "01", "13", sep = "-")),
               as.Date(paste(yyyy, "12", "13", sep = "-")), by = "month")

  fri13 <- mon13[weekdays(mon13, abbreviate = FALSE) == 'Friday']

  return(fri13)
}

find_fri13(2020)
find_fri13(2019)


# Exercise Step 6
# Create a function called age_formula1 that calculates and returns an integer age using the formula
# (dob - <current_date>) / 365.25. Use one named parameter with the default value of "1970-01-01".
# Test your function with a few values.
age_formula1 <- function(dob = "1970-01-01") {

   age <- (Sys.Date() - as.Date(dob)) / 365.25

   age <- as.integer(age)

   return(age)

}

current_age <- age_formula1(dob = "1965-09-12")


# Exercise Step 7
# Read in the dm.rds data frame from the working directory. Name the data frame dm.
dm <- readRDS('_data/dm.rds')

# Exercise Step 8
#	Create a data frame from dm named dmss keeping all records but only the variables SUBJID, BRTHDTC, RFSTDTC, & AGE#
dmss <-
  dm[c('SUBJID', 'BRTHDTC', 'RFSTDTC', 'AGE')]

# Exercise Step 9
# Using the function you created, age_formula1, add the variable, agecalc_today to
# the dmss data frame. Use the variable BRTHDTC as the date of birth.
dmss$agecalc_today <- age_formula1(dmss$BRTHDTC)

# Exercise Step 10
# Create a function named age_formula2 that adds the functionality of passing in a date of choice other than
# the current date. Name the parameter for the date of choice refdate. The parameter refdate should be a named
# parameter with the default set to Sys.Date().  Hint: you may have to test the class of refdate and conditionally
# perform the calculation.
age_formula2 <- function(dob = "1970-01-01", refdate = Sys.Date()) {
  if (class(refdate) == "character") {
    age <- (as.Date(refdate) - as.Date(dob)) / 365.25
  }
  else {
    age <- (refdate - as.Date(dob)) / 365.25
  }

  age <- as.integer(age)

  return(age)

}

# Exercise Step 11
# Use your new function to add the variable agecalc_study by using BRTHDTC as the date of birth and RFSTDTC as the refdate.
dmss$agecalc_study <- age_formula2(dmss$BRTHDTC, dm$RFSTDTC)


# Exercise Step 12
# Add descriptive label attributes to your calculated variables on the data frame dmss.
attr(dmss$agecalc_today, "label") <- "Age as of Today"
attr(dmss$agecalc_study, "label") <- "Age as of Study Start"

currtm <- as.POSIXlt("2020-07-20 14:45:00")
currtm$hour

# Times Exercises --------------------

# Exercise Step 3
# Create a function called work_life_balance which returns a message
# stating "Keep working!" or "Stop working!" based
# on whether it is currently before 5pm or after 5pm. This function needs no parameters.
work_life_balance <- function() {
  currtm <- as.POSIXlt(Sys.time())
  if (currtm$hour > 16) {
    message <- "Stop working!"
  }
  else {
    message <- "Keep working!"
  }
  return(message)
}

work_life_balance()
