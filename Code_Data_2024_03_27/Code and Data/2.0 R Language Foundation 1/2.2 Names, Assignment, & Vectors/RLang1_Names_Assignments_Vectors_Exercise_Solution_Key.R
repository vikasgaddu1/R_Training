
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved
# Solution Key


## Insert a section description (Ctrl + Shift + R) with the text "Variables & Assignments"

# Variables and Assignments -----------------------------------------------


# Names & Assignments Exercises -------------------------------------------------

# Exericse Step 6
## Insert a comment(Ctrl + Shift + C) with the text "Variables"
# Variables
num_var1 <- c(1000,2000)
length(num_var1)

# Exercise Step 7
## Declare a character variable named ae_raw and set the value to "MIGRAINE HEADACHE".
ae_raw <- "MIGRAINE HEADACHE"
nchar(ae_raw)
length(ae_raw)

# Exercise Step 8
## Declare a character variable named ae_start_dt and set the value to "2020-02-28".
ae_start_dt <- "2020-02-28"
class(ae_start_dt)

# Exercise Step 9
## Declare a date variable named date_visit and set the value to "2020-03-05".
date_visit <- as.Date("2020-03-05")
class(date_visit)

# Exericse Step 10
## Declare a numeric variable named int_var1 and set the value to 1000L using a left directional operator.
# Integer Variables
int_var1 <- 1000L

# Exercise Step 11
## Print each of the variables and note the output.
print(num_var1)
print(ae_raw)
print(ae_start_dt)
print(date_visit)
print(int_var1)

# Vectors Exercises Portion -------------------------------------------

# Exercise Step 5
## Print the class of the variable num_var1 to the console.
class(num_var1)
length(num_var1)
print(num_var1)

class(ae_raw)
length(ae_raw)
print(ae_raw)

class(ae_start_dt)
length(ae_start_dt)
print(ae_start_dt)

class(date_visit)
length(date_visit)
print(date_visit)

class(int_var1)
length(int_var1)
print(int_var1)

# Exercise Step 6
## Create a date variable called ae_start_date
## from the character variable ae_start_dt using the as.Date function.
ae_start_date <- as.Date(ae_start_dt)

# Exercise Step 7
## Print the class and length of the ae_start_date variable to the console.
class(ae_start_date)
length(ae_start_date)

# Exercise Step 8
## Insert a comment with the text "Vectors"
# Vectors

# Vectors are homogeneous 
mixed <- c(1,"1")
class(mixed)

# Exercise Step 9
## Declare a date vector named vect_dates and set the values to the first three days of May, 2020.
vect_dates <-
  c(as.Date("2020-05-01"),
    as.Date("2020-05-02"),
    as.Date("2020-05-03"))
class(vect_dates[1])
# Exericse Step 10
## Declare a vector named vect_nums and set the values to the numbers 1, 2, and 3
vect_nums <- c(1, 2, 3)

# Exercise Step 11
## Print the length, class, and values for the two vectors you just created to the console.
class(vect_dates)
length(vect_dates)
print(vect_dates)

class(vect_nums)
length(vect_nums)
print(vect_nums)

# Exercise Step 12
# Remember, only vectors of the same type should be combined.

combine_vects_good <- c(vect_nums, num_var1)
print(combine_vects_good)
class(combine_vects_good)

class(int_var1)
class(vect_nums)
combine_vects_ok1 <- c(int_var1, vect_nums)
print(combine_vects_ok1)
class(combine_vects_ok1)

check <- function(val1, val2)
  {
  if (class(val1) != class(val2))
    {
    print("Error:")
    return()
  }
  return (c(val1, val2))
}
result <- check(int_var1, vect_nums)
result
combine_vects_ok2 <- c(num_var1, vect_dates)
vect_dates
print(combine_vects_ok2)
class(combine_vects_ok2)

combine_vects_bad1 <- c(vect_nums, ae_raw)
class(vect_nums)
print(combine_vects_bad1)
class(combine_vects_bad1)

combine_vects_bad2 <- c(vect_dates,ae_raw)
print(combine_vects_bad2)
class(combine_vects_bad2)


