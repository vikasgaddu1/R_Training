
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Creating Package Functions

# Packages & Functions on Display:
# - {devtools 2.4.2}: document, load_all, run_examples
# - {usethis  2.0.1}: use_r, use_vignette


# Setup -------------------------------------------------------------------
# Devtools is a meta-package that includes dozens of packages meant for assisting
# with common workflows in R and RStudio, including working projects and packages

library(devtools)


# Getting Started ---------------------------------------------------------

# Creating Functions:
# - In general, if you are running an operation once, you don't need to write a
#  function, but if you find yourself repeating the same lines of code over and
#  over, then it will be easier in the long run to make a function that you can
#  edit and test in a central place.
#
# - Abstraction is the process of making your repeatable code general enough to
#  cover different situations, under some constraints.
#
# - For example, if you find yourself running the same summarize() operation to
#  create a dozen summary values, then you could wrap that into a function, where
#  the input is a dataframe that meets certain variable requirements


# Recommended Practices:
# - Store many small functions in a single combined script
# - Store single large/important function in its own script
# - Ensure your script and function names are informative for your self and
#  your collaborators.
# - Consider using a common prefix for the functions in your package, to make it
#  easier to find when using RStudio auto-complete

# Design Principles:
# - The development of your functions and packages are entirely up to you, but
#  remember that the main purpose of creating a package is to share your
#  functions with others.  So if people don't like using your functions, or
#  find them confusing, then they will simply not use them.



# Creating a Function -----------------------------------------------------
# Creating a New Function Script:
# [RStudio ] : File > New File > New R Script
# [Keyboard] : Ctrl/Cmd + Shift + N
# [Function] : use_r() will remind you to create a corresponding unit test

use_r("my_new_script")


# Because package functions are loaded differently, it is important to
# prefix functions with the package it comes from with like pkg::fn()
# But, Base R functions will not need this syntax

fn_write_data <- function(data, output_path = "/data"){

  # Deparse & Substitute can capture incoming arguments as text
  df_name    <- deparse(substitute(data))
  fn_message <- stringr::str_glue("Writing {df_name} dataset to disk.")

  message(fn_message)
  readr::write_rds(data, output_path)
}



# Roxygen Documentation ---------------------------------------------------
# 'roxygen2' templates are meant for package development, but are used in any script
# The '# symbols are used to indicate this is a special documentation comment


# --- Function Documentation Template ---
#' Title
#'
#' @param data 
#' @param output_path 
#'
#' @return
#' @export
#'
#' @examples
fn_write_data <- function(data, output_path = "/data"){

  # Deparse & Substitute can capture incoming arguments as text
  df_name    <- deparse(substitute(data))
  fn_message <- stringr::str_glue("Writing {df_name} dataset to disk.")

  message(fn_message)
  readr::write_rds(data, output_path)
}


# --- In RStudio ---
# Place cursor inside function definition:
# [RStudio ] : Code > Insert Roxygen Skeleton
# [Keyboard] : Ctrl/Cmd + Alt/Option + Shift + R



# --- Roxygen Parameters ---
# First Line  : The title of the documentation page
# Second Line : This needs to be empty
# Third Line  : The description of the documentation page
# @param      : Provides a description for each argument of the function
# @return     : Provides a description for the expected result of the function
# @examples   : Provides sample code of how the function should be used
# @export     : Indicates whether or not the function will be available for end user



# Functions with Documentation --------------------------------------------

#' Function for Exporting Data in .rds Format
#'
#' This function will write the provided data to the given path using write_rds()
#'
#' @param data The data to be written to disk
#' @param output_path The directory path that the data will be saved to
#'
#' @return No R objects will be returned
#' @export
#'
#' @examples
#' fn_write_data(mtcars, output_path = "./path/file.rds")
#'
fn_write_data <- function(data, output_path = "/data"){

  # Deparse & Substitute can capture incoming arguments as text
  df_name    <- deparse(substitute(data))
  fn_message <- stringr::str_glue("Writing {df_name} dataset to disk.")

  message(fn_message)
  readr::write_rds(data, output_path)
}



#' Function for Importing Data in .rds Format
#'
#' This function will take the provided file path and read it in using read_rds()
#'
#' @param path_to_rawdata This is the file path where the data is stored
#'
#' @return A dataframe loaded into memory with read_rds()
#' @export
#'
#' @examples
#' fn_get_data(path_to_rawdata = "./path/file.rds")
#' fn_get_data("another/file.rds")
#'
fn_get_data <- function(path_to_rawdata){
  readr::read_rds(path_to_rawdata)
}



# Functions for Demonstration ---------------------------------------------


#' Function for Internal Use
#'
#' This is a function that does not include `@export`,
#' so it will not be exported, and will not be available for use by the end-user
#'
#' @return The mean of a random set of numbers
#'
fn_internal_use <- function(){
  my_sequence <- runif(n = 1000, min = 0, max = 1000)
  mean(my_sequence)
}



#' Function for Demonstrating Build Time
#'
#' `package_time` is defined and captured when the package is built,
#' but when running `Sys.time()` on it's own, the user will see the current time
#' when they executed the function.
#'
#' This is because when we assign something in a package function, that object
#' is stored as is for the end user.
#'
#' @return A string showing the package build time and the current time
#' @export
#'
fn_print_time <- function(){

  package_time <- Sys.time()

  paste("The package was built on", package_time,
        "But the current time is",  Sys.time())
}



# Note: After building the package in later lessons, we will demonstrate this



# Creating the Documentation Files------------------------------------------
# When your function operations are finalized, and the documentation is written,
# the Document process will compile the roxygen comments into the markdown
# style format, and will update the NAMESPACE file with the functions that
# will be available for the end user

# [RStudio ] : Build > Document
# [Keyboard] : Ctrl/Cmd + Shift + D
# [Function] : document()


document()


# Now when we view the NAMESPACE file, we see the updated listing of functions
# Notice a new directory has been created in the files panel
# - man/ contains all of the help pages for your functions



# Viewing the Documentation -----------------------------------------------
# After creating documentation, load all functions you've created and test
# documentation examples

# [RStudio ] : Build > Load All
# [Keyboard] : Ctrl/Cmd + Shift + L
# [Function] : load_all()


load_all()
run_examples()


# Now you can view the help pages you just created, displaying files in man/
help("fn_write_data")
help("fn_get_data")
help("fn_internal_use")



# Creating Vignettes ------------------------------------------------------
# A vignette uses R Markdown to create a more in-depth guide to using your
# package and functions

use_vignette("how-to-use-pkg")

# Learn More:
# https://r-pkgs.org/vignettes.html



# Documentation -----------------------------------------------------------

# Vignettes
vignette("roxygen2", package = "roxygen2")

# The NAMESPACE files is more important than it seems
# Learn More: https://r-pkgs.org/namespace.html

# Websites
# roxygen2   : https://roxygen2.r-lib.org
# usethis    : https://usethis.r-lib.org
# devtools   : https://devtools.r-lib.org/
# R Packages : https://r-pkgs.org

# -------------------------------------------------------------------------
