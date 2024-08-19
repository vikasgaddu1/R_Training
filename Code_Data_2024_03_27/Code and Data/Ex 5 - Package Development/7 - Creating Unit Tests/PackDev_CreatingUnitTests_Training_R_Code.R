
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Creating Unit Tests

# Packages & Functions on Display:
# - {devtools 2.4.2}
# - {testthat 3.0.2}: expect_*, test_that, test_file, test_dir,
# - {covr     3.5.1}: file_coverage, report


# Setup -------------------------------------------------------------------
# Devtools is a meta-package that includes dozens of packages meant for assisting
# with common workflows in R and RStudio, including working projects and packages

library(devtools)
library(testthat)           # Installed with devtools, used to create unit tests
library(covr)               # For checking unit test coverage
library(DT)                 # Required covr summary report


# Getting Started ---------------------------------------------------------

# - Unit tests check for the correct behavior of a function
# - Forces you to write testable code, which improves whole process and pipeline
# - Balance productivity with testing. Don't write unit tests before starting a
#  function, and don't write unit tests after the function has been completed


# - The entire testing process should be as simple and as fast as possible
# - A test should report clearly and exactly where a problem occurs
# - No manual testing should be involved
# - Unit tests should be independent of each other, so they can all run in parallel
# - You will discover bugs by setting expectations first


# Setting Expectations ----------------------------------------------------
# Setting expectations once your function has a general outline can help you
# maintain a working function as you continue to flesh out the details

sum_result <- sum(1:5)

expect_equal(sum_result, 15)
expect_identical(sum_result, 15)


# Why are these different?
typeof(sum_result)        # The sequence of numbers 1:5 are integers
typeof(15)                # While, the number on its own is a double


# Additional Arguments
expect_equal(1.00001, 1.001)
expect_equal(1.00001, 1.001, tolerance = 0.01)
expect_equal(1.00001, 1.001, tolerance = 0.000000001)


# Additional Expectations
help(expect_message, package = "testthat")    # Check for a specific message in the console log
help(expect_warning, package = "testthat")    # Check for a specific warning in the console log
help(expect_error,   package = "testthat")    # Check for a specific error in the console log
help(expect_output,  package = "testthat")    # Check for a specific string in the console log

help(expect_lt,      package = "testthat")    # Check that resulting value is less than another
help(expect_lte,     package = "testthat")    # Check that resulting value is less or equal to another
help(expect_gt,      package = "testthat")    # Check that resulting value is greater than another
help(expect_gte,     package = "testthat")    # Check that resulting value is greater or equal another

help(expect_length,  package = "testthat")    # Check that resulting string is of specified length
help(expect_true,    package = "testthat")    # Check that result is TRUE
help(expect_false,   package = "testthat")    # Check that result is FALSE


# Demo Function -----------------------------------------------------------

# Creating a New Function Script:
# [RStudio ] : File > New File > New R Script
# [Keyboard] : Ctrl/Cmd + Shift + N
# [Function] : use_r()


use_r("my_demo_function")


# Function Definition

#' A Function to Demo Unit Tests and Coverage
#'
#' @param input_values A numeric vector to be summarized
#' @param operation A character of either "sum", "mean", or "median"
#'
#' @return A single value summarizing a numeric vector
#'
my_demo_function <- function(input_values, operation) {
  if (operation == "sum") {
    sum(input_values)
  } else if (operation == "mean") {
    mean(input_values)
  } else if (operation == "median") {
    median(input_values)
  } else {
    stop("Only sum, mean, median are allowed")
  }
}


# Update Documentation
# [RStudio ] : Build > Document
# [Keyboard] : Cmd/Ctrl + Shift + D
# [Function] : document()

document()


# Create a Unit Test Script -----------------------------------------------

## Directory Structure ----
# Create directory structure to store unit tests

use_testthat()

# Now you'll see a new directory in the Files Panel
# /tests/         : contains the testthat.R script which is used for automated testing
# /tests/testthat : contains the individual "test-*.R" scripts for manual tests



## Individual Unit Tests ----
# Open script you want to create unit tests for
# Navigate to my_demo_function.R that we just created

use_test()      # create unit test with prefix "test-" for currently open script



# Writing Unit Tests ------------------------------------------------------

# Load Functions for Testing
load_all()

# Check for Equality
result_1 <- my_demo_function(1:5, "sum") %>% print()
expect_equal(result_1, 15)
expect_equal(result_1, 30)


result_2 <- my_demo_function(c(1, 2, NA, 4, 5), "mean") %>% print()
expect_equal(result_2, 3)
expect_equal(result_2, NA)
expect_equal(result_2, NA_integer_)


# Check for Errors
my_demo_function(1:5, "apples")
expect_error(my_demo_function(1:5, "apples"))
expect_error(my_demo_function(1:5, "median"))

my_demo_function(c("1", "2", "3"), "sum")
expect_error(my_demo_function(c("1", "2", "3"), "sum"))
expect_error(my_demo_function(c( 1 ,  2 ,  3 ), "sum"))


# Check for Comparison
result_3 <- my_demo_function(1:100, "mean")
expect_lte(result_3, 50)
expect_gte(result_3, 50)



# Writing Multiple Tests --------------------------------------------------
# Multiple tests allow you to create many tests under a single header description


test_that(
  desc = "Check for numeric input",
  code = {
    expect_equal(my_demo_function(1:5, "sum"), 15)
    expect_equal(my_demo_function(1:5, "mean"), 3)
    expect_equal(my_demo_function(c(1, 2, NA, 4, 5), "mean"), NA_integer_)
  })


test_that(
  desc = "Check for Errors",
  code = {
    expect_error(my_demo_function(1:5, "apples"))
    expect_error(my_demo_function(c("a", "b", "c"), "sum"))
    expect_gte(my_demo_function(1:100, "mean"), 50)
  })


test_that(
  desc = "Set to Fail",
  code = {
    expect_gt(my_demo_function(1:100, "mean"), 1000)
    expect_lt(my_demo_function(1:100, "mean"), 10)
    expect_gte(my_demo_function(1:100, "mean"), 1000)
    expect_lte(my_demo_function(1:100, "mean"), 10)
  })



# Running Tests -----------------------------------------------------------
# Run your unit tests often, maybe even use .Rprofile to run test upon start

# [RStudio ] : Build > Test
# [Keyboard] : Cmd/Ctrl + Shift + T     (Desktop)
# [Keyboard] : Ctrl/Cmd + Alt/Opt + F7  (Browser)
# [Function] : test()

test_file("path/to/specific/script.R")  # Run a single unit test
test_dir("path/to/dir")                 # Run all unit tests in a directory



# Test Coverage -----------------------------------------------------------
# We want to write tests the cover the entirety of our functions
# If we have multiple if-else statements, we want to make sure we're testing
# each of the possible conditions

covr::file_coverage(
  source_files = c("R/my_demo_function.R"),
  test_files   = c("tests/testthat/test-my_demo_function.R")) %>%
  covr::report()


# In interactive report, click filename to see which lines of code are not tested
# Note: devtools::test_coverage() provides a similar report, but is more strict



# Documentation -----------------------------------------------------------

# Vignettes
vignette("how_it_works", package = "covr")

# Help Pages
help(test_file,          package = "testthat")
help(test_dir,           package = "testthat")
help(file_coverage,      package = "covr")
help(report,             package = "covr")

# Learn More:
# https://r-pkgs.org/tests.html

# Websites
# covr       : https://covr.r-lib.org
# testthat   : https://testthat.r-lib.org
# usethis    : https://usethis.r-lib.org
# devtools   : https://devtools.r-lib.org/
# R Packages : https://r-pkgs.org

# -------------------------------------------------------------------------
