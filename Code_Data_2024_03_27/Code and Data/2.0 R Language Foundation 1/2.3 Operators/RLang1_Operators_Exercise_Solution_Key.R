
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key


# Basic Operators Exercises -----------------------------------------------

# Exercise Step 3
## Declare numeric variables named bps and bpd and assign
## them values of 120 and 80 respectively
bps <- 120
bpd <- 80


# Exercise Step 4
## Calculate Mean Arterial Blood Pressure using the bps and bpd variables.
MAP <- (2 / 3) * bpd + (1 / 3) * bps

# Exercise Step 5
print(MAP)

# Exercise Step 6
## Declare a variable for patient_temp_f and assign it the value 98.6.
patient_temp_f <- 98.6


# Exercise Step 7
## Using the formula (patient_temp_f - 32) * (5/9), create a variable called patient_temp_c
patient_temp_c <- (patient_temp_f - 32) * (5 / 9)

# Exercise Step 8
##	Print the value for patient_temp_c.
print(patient_temp_c)


# Exercise Step 9
## Create a variable called patient_temp_f_check using the formula (9/5)*patient_temp_c + 32.
patient_temp_f_check <- (9 / 5) * patient_temp_c + 32


# Exercise Step 10
## Create a variable called checkwork and test to see if patient_temp_f is equal
## to patient_temp_f_check.
checkwork <- patient_temp_f == patient_temp_f_check

# Exercise Step 11
print(checkwork)

# Exercise Step 12
## Create a variable called diff that subtracts patient_temp_f_check from patient_temp_f.
diff <- patient_temp_f - patient_temp_f_check

# Exercise Step 13
print(diff)

# Exercise Step 14 and 15
## Use the code print(patient_temp_f, digits=20) to print with enough precision
## to see the actual value
print(patient_temp_f, digits = 20)
print(patient_temp_f_check, digits = 20)


# Vector Operators Exercises ---------------------------------------------

# Exercise Step 1
##	Create a vector called temp_vector_c with the values 0 to 100.
temp_vector_c <- c(0:100)
length(temp_vector_c)
# Exercise Step 2
## Create a vector called temp_vector_f using the formula (9/5)*patient_vector_c + 32.
temp_vector_f <- (9 / 5) * temp_vector_c + 32

# Exercise Step 3
## Print temp_vector_f to the console
print(temp_vector_f)

# Exercise Step 4
## Create a variable called group_min that is equal to 86
## and group_max that is equal to 120.
group_min <- 86
group_max <- 120

# Exercise Step 5
## Create a vector, called group, of values from the group_min
## to the group_max.
group <- c(group_min:group_max)
group < 98
# Exercise Step 6
## Suppose we have a threshold of 98. Use the sum() function to
## determine the number of values in group that are less than
## that threshold.
sum(group < 98)
table(group < 98)
janitor::tabyl(group < 98)

# NAMESPACES 
library(tidyverse)
