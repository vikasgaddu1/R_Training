# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Exercise Step 3
raw_vs <- readRDS("_data/raw_vitals.rds")

# Exercise Step 4
# Using the function anyNA(), test to see if there are any missing values in any of the variables in the raw_vs # # data frame.
anyNA(raw_vs)

# Exercise Step 5
# Using the is.na() function on the data frame raw_vs, find out how many total missing values in the data frame.
sum(is.na(raw_vs))

# Exercise Step 6
#	Using the is.na() function on the data frame raw_vs, find out how many total non-missing values in the data frame.
sum(!is.na(raw_vs))

# Exercise Step 7
#	Using the ncol() and nrow() functions, multiply the number of variables in the raw_vs data frame by
# the number of rows and see if it matches the sum from the previous two steps.
ncol(raw_vs) * nrow(raw_vs)

# Exercise Step 8 and 9
# Using the is.na() function on the data frame raw_vs, find out how many total missing values in the data frame variable
# WEIGHT. Try using the function referring to the variable using the $ notation and also with the [[ ]] notation.
d_weight_miss <- sum(is.na(raw_vs$WEIGHT))
d_weight_nmiss <- sum(!is.na(raw_vs$WEIGHT))

db_weight_miss <- sum(is.na(raw_vs[['WEIGHT']]))
db_weight_nmiss <- sum(!is.na(raw_vs[['WEIGHT']]))

# Missing Values in Action Excercises

# Exercise Step 4
# Using a for loop, names function, and paste functions, print a line to the console for each variable in the raw_vs
# data frame using the following format example.
# "There are 0 missing and 642 non-missing values for the variable STUDYID"
for (nm in names(raw_vs)) {
  nm <- paste(
    "There are",
    sum(is.na(raw_vs[[nm]])),
    "missing and",
    sum(!is.na(raw_vs[[nm]])),
    "non-missing values for the variable",
    nm,
    "."
  )
  # nm <- sprintf("There are %d missing and %d non-missing values for the variable %s",
  #                sum(is.na(raw_vs[[nm]])), sum(!is.na(raw_vs[[nm]])), nm)
  print(nm)

}

# Exercise Step 5
# Create a new data frame called missing_weights that consists of records that have a missing weight at the screen visit
missing_weight <-
  raw_vs[is.na(raw_vs$WEIGHT) & raw_vs$VISIT == 'screen',]

# Exercise Step 6
# For any records in raw_vs that have a missing weight at screen, replace that weight value with the average weight
# at screen for all other patients.
raw_vs[is.na(raw_vs$WEIGHT) &
         raw_vs$VISIT == 'screen', 'WEIGHT'] <-
  mean(raw_vs[raw_vs$VISIT == 'screen', 'WEIGHT'], na.rm = TRUE)

summary(raw_vs$WEIGHT)
