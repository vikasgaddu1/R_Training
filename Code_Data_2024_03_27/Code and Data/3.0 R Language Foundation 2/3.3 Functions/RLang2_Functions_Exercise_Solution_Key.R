# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key


# Functions I -------------------------------------------------------------

# Exercise Step 3
# Create a function to convert Fahrenheit to Celsius using the formula
# C = (F-32) * (5/9)
Fahrenheit2Celsius <- function(f) {
  Celsius <- (f - 32) * (5 / 9)

  return(Celsius)
}

# Exercise Step 4
Fahrenheit2Celsius(32)
Fahrenheit2Celsius(212)


# Exercise Step 6
# Modify Fahrenheit2Celsius and add a second parameter named `whichway`,
# which can take the values F2C or C2F. Name this function `tempconversion`.
# This will allow your function to convert either way.
# For the `C2F` conversion, use the equation `F = C*(9/5) + 32`.
# If the `whichway` parameter value is not `"F2C"` or `"C2F"` execute
# the following `stop("Invalid whichway parameter value")`.
tempconversion <- function(temp, whichway) {
  if ((whichway) == 'F2C') {
    result <- (temp - 32) * (5 / 9)
  } else if ((whichway) == 'C2F') {
    result <- (temp * (9 / 5)) + 32
  } else {
    stop("Invalid whichway parameter value")
  }
  return(result)
}

# Exercise Step 7
tempconversion(32, 'F2C')
tempconversion(0, 'C2F')
tempconversion(37, 'c2f')

# Exercise Step 8
# Using the `toupper()` function, make your function more robust to case
# sensitivity issues and test again.
tempconversion <- function(temp, whichway) {
  if (toupper(whichway) == 'F2C') {
    result <- (temp - 32) * (5 / 9)
  } else if (toupper(whichway) == 'C2F') {
    result <- (temp * (9 / 5)) + 32
  } else {
    stop("Invalid whichway parameter value")
  }
  return(result)
}

tempconversion(32, 'F2C')
tempconversion(0, 'C2F')
tempconversion(37, 'c2f')


# Exercise Step 9
raw_vitals <- readRDS('./_data/raw_vitals.rds')

# Exercise Step 10
raw_vitals$TEMPF <- tempconversion(raw_vitals$TEMP, 'C2F')
raw_vitals$TEMPF

# Exercise Step 11
# Update the temperature conversion function so that whichway is a named parameter
# with a default value of 'C2F'
tempconversion <- function(temp, whichway = 'C2F') {
  if (toupper(whichway) == 'F2C') {
    result <- (temp - 32) * (5 / 9)
  } else if (toupper(whichway) == 'C2F') {
    result <- (temp * (9 / 5)) + 32
  } else {
    stop("Invalid whichway parameter value")
  }
  return(result)
}

tempconversion(98,whichway = 'F2C')

# Vectorized functions ----------------------------------------------------

##### raw_vitals$TEMPF <- tempconversion(raw_vitals$TEMP)

# Exercise Step 3
# Create a vector of sample Fahrenheit temperatures ranging from 93 to 105.
# Name it tempf_vector.
tempf_vector <- c(93:105)

# Exercise Step 4
# Create a function containing conditional logic with `if - then - else`
# syntax that creates a rule like the following:
# Less than 95 is "Low" Between 95 and 100 inclusive is "Normal"
# Greater than 100 is "Fever". Name the function `flag_tempF`.
# Return a value for unknown cases.
flag_tempF <- function(tempf) {
  if (tempf < 95) {
    ret <- "Low"
  } else if (tempf >= 95 & tempf < 100) {
    ret <- "Normal"
  } else if (tempf >= 100) {
    ret <- "Fever"
  } else {
    ret <- "Unknown"
  }

  return(ret)

}
flag_tempF(tempf_vector)

# Exercise Step 5
# Create a vectorized version of `flag_tempf()` and name it `flag_tempF_V()`.
flag_tempF_V <- Vectorize(function(tempf) {
  if (tempf < 95) {
    ret <- "Low"
  } else if (tempf >= 95 & tempf < 100) {
    ret <- "Normal"
  } else if (tempf >= 100) {
    ret <- "Fever"
  } else {
    ret <- "Unknown"
  }

  return(ret)

})

# Exercise Step 6
# Use the `flag_tempF_V()` function on the `tempf_vector` you created
# to create a new vector named `tempf_flag_vector`. Examine the results.
tempf_flag_vector <- flag_tempF_V(tempf_vector)
tempf_flag_vector

# Exercise Step 7
# Use sapply to apply the non-vectorized function `flag_tempF()` on `tempf_vector`
# and create a vector `tempf_flag_sapply`. Compare the results and the approach.
tempf_flag_sapply <- sapply(tempf_vector,flag_tempF)
tempf_flag_sapply
typeof(tempf_flag_sapply)

# Exercise Step 8
raw_vitals <- readRDS('./_data/raw_vitals.rds')

# Exercise Step 9
# The values are in Celsius and our thresholds are in Fahrenheit.
# Modify the function to accept a flag, `scale`, which could be `C` or `F`.
# If `scale` is `C`, convert the vector to Fahrenheit.
# Name this new version `flag_temp`.
flag_temp <- function(tempf,scale='F') {
  if (scale == 'C') {
    tempf <- tempconversion(tempf)
  }
  if (tempf < 95) {
    ret <- "Low"
  } else if (tempf >= 95 & tempf < 100) {
    ret <- "Normal"
  } else if (tempf >= 100) {
    ret <- "Fever"
  } else {
    ret <- "Unknown"
  }

  return(ret)

}

# Exercise Step 10
# Use sapply to run `flag_temp` on the variable `TEMP` from `raw_vitals`.
# You can pass in the value for the `scale` parameter after the name
# of the function you are applying. E.g. sapply(X,FUN,<parameters for FUN>)
# What happens?
sapply(raw_vitals$TEMP,flag_temp,'C')

# Exercise Step 11
# The second problem is that some of the values are missing, i.e. `NA`.
# Our conditionals do not handle those and error out.
# Modify the function again (last time!) to check whether a value of tempf
# is missing (`NA`) or not. If it is missing, return `NA`.
# If not, execute the function as intended.
temp_cat <- function(tempf){
  if (tempf < 95) {
    ret <- "Low"
  } else if (tempf >= 95 & tempf < 100) {
    ret <- "Normal"
  } else if (tempf >= 100) {
    ret <- "Fever"
  } else {
    ret <- "Unknown"
  }
  return(ret)
}

flag_temp <- function(tempf,scale='F') {
  if (is.na(tempf)) {
    ret <- NA
    } else {
    if (scale == 'C') {
      tempf <- tempconversion(tempf)
    }
    ret <- temp_cat(tempf)
  }
  return(ret)

}

# Exercise Step 12
# Use sapplyto run this version of the function on the variable `TEMP` from `raw_vitals`.
sapply(raw_vitals$TEMP,flag_temp,'C')

