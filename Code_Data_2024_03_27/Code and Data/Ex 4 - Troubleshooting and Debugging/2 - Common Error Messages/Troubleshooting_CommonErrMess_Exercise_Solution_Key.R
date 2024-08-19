# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key


# Setup -------------------------------------------------------------------


# Run the code library(Tidyverse) and examine the console. Which functions are 
# listed as conflicts? What precautions should be taken when using these functions? 
library(tidyverse)

# Answer: filter() and lag()
# These functions should be referenced with the double colon notation (package::function()).
# i.e.  stats::filter()

# define vector trt_arms
trt_arms <- c(arm1 = "ARM A", arm2 = "ARM B", arm3 = "ARM C")

# fix this test for the condition on the arm2 element of vector trtarms
test_result <- if_else(trt_arms$arm2 == "ARM B", "YES", "NO")

# remedied code
test_result <- if_else(trt_arms["arm2"] == "ARM B", "YES", "NO")

# now fix this test for the condition on the arm2 element of vector trtarms
test_result2 <- if_else(trt_arms[arm2] == "ARM B", "YES", "NO")

# remedied code
test_result2 <- if_else(trt_arms["arm2"] == "ARM B", "YES", "NO")


# Line 1
if_else(TRUE == FALSE, "FALSE", TRUE)

# Line 2      
if_else(if_else(trt_arms["arm2"] == "ARM B", TRUE, FALSE) == TRUE, 1, NA)

# Line 3
if_else(trt_arms["arm2"] == "ARM B", "YES", NA)

# Line 4
if_else(trt_arms["arm2"] == "ARM B", NA, 0)


# see if a result is missing. If it is not missing return "Success" 
# otherwise return "Not Available".
if (!is.na(mean(c(1, 2, NA)))) {
  print("Success!")
} else {
  print("Not Available")
}


# The code below produces a warning. Please use the suppressWarnings() 
# function to suppress it.
a <- suppressWarnings(as.numeric(c(1,2,3,"four")))




