# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(lubridate)

# Exercise Step 2
profile <- function(fname, lname, dob, zipcode, parents){
  
  prof_list <- list(fname,
                       lname,
                       dob,
                       zipcode,
                       parents)
  
  return(prof_list)
}

# Exercise Step 3
profile("Jake", "Adams", as.Date("1999-01-01"), 44444, c("Jack", "Jill"))

# Exercise Step 4
profile2 <- function(fname, lname, dob, zipcode, parents){
  
  stopifnot(is.Date(dob))
  
  prof_list <- list(fname,
                    lname,
                    dob,
                    zipcode,
                    parents)
  
  return(prof_list)
}

# Exercise Step 5
# Test with dob as date value
profile2("Jake", "Adams", as.Date("1999-01-01"), 44444, c("Jack", "Jill"))

# Exercise Step 6
# Test with dob as non-date value
profile2("Jake", "Adams", "1999-01-01", 44444, c("Jack", "Jill"))
