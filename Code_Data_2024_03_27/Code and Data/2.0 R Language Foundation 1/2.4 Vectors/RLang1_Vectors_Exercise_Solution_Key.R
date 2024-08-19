
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key


# Vectors Part 1 Exercises ----------------------------------------------

# Exercise Step 3
#	Declare a vector named resting_pulse containing the following values:
# 76,67,78,67,56,89,58,65,66,61
resting_pulse <- c(76, 67, 78, 67, 56, 89, 58, 65, 66, 61)

# Exercise Step 4
class(resting_pulse)
min(resting_pulse)
median(resting_pulse)
max(resting_pulse)
quantile(resting_pulse)

# Exercise Step 5
# Declare a vector named outliers containing only resting pulses less than 60 and
# resting pulses greater than 80
outliers <- resting_pulse[resting_pulse < 60 | resting_pulse > 80]

# Exercise Step 6
# Declare a vector named exceptfirst containing all elements from the
# vector resting_pulse except the first element.
exceptfirst <- resting_pulse[-1]


# Exercise Step 7
# Using the mean() and sd() functions, create a new vector named
# standardized_resting_pulse from resting_pulse by subtracting the
# mean and dividing by the standard deviation of the resting_pulse vector.
standardized_resting_pulse <-
  (resting_pulse - mean(resting_pulse)) / sd(resting_pulse)


# Exercise Step 8
# Examine the mean and standard deviation of the vector standardized_resting_pulse.
# Does is have a mean of zero and standard deviation of one as expected?
mean(standardized_resting_pulse)
sd(standardized_resting_pulse)


# Vectors Part 2 Exercises ------------------------------------------------

# Exercise Step 3
# Declare a vector named inv_sites containing the following values.
# 'NIH','Mayo Clinic','Cleveland CLINIC','Northwestern'
# and print the value of the third element of the vector to the console.
inv_sites <-
  c('NIH', 'Mayo Clinic', 'Cleveland CLINIC', 'Northwestern')
print(inv_sites[3])

# Exercise Step 4
# Declare a named vector named inv_sites_named containing the following name value pairs.
# NIH='NIH', MC='MAYO Clinic', CC='Cleveland Clinic', NW='Northwestern'
# and print the value of the third element of the vector to the console
# using the element name instead of the element number.
inv_sites_named <-
  c(NIH = 'NIH',
    MC = 'MAYO Clinic',
    CC = 'Cleveland Clinic',
    NW = 'Northwestern')
print(inv_sites_named["CC"])

# Exercise Step 5
# Update the value of the third element of the vector inv_sites to the value
# 'Cleveland Clinic'
inv_sites[3] <- "Cleveland Clinic"


# Exercise Step 6
# Update the value of the element MC of the vector inv_sites_named to the value  'Mayo Clinic'
inv_sites_named['MC'] <- "Mayo Clinic"

# Exercise Step 7
# Declare a vector named group_code with the values
# 'a','B','C','d','A','b','c','D','d','d','a','b','B'
group_code <- c('a', 'B', 'C', 'd', 'A', 'b', 'c', 'D', 'd', 'd', 'a', 'b', 'B')

# Exercise Step 8
# Declare a vector named group_name with the values A='100mg',B='200mg',C='300mg',D='400mg'
group_name <- c(A = '100mg',
                B = '200mg',
                C = '300mg',
                D = '400mg')

# Exercise Step 9
# Using the decode technique, declare a vector named groups as groups <- group_name[group_code]
# and examine the values of the vector groups.
groups <- group_name[group_code]

# Exercise Step 10
# Fix the case issue by using the toupper function in the vector definition of
# groups the toupper function is used in the same way as the upcase function in SAS.
groups <- group_name[toupper(group_code)]

# Exercise Step 11
# We should also update the group_code vector to be all upper case.
# Use the toupper() function to change the group_code vector to all upper case.
group_code <- toupper(group_code)

