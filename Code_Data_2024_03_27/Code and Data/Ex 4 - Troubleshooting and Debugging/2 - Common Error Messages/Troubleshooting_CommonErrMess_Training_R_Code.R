
#' Anova Accel2R - Clinical R Training -----------------------------------
#' © 2022 Anova Groups All rights reserved

# Title: Common Error Messages in R


# Getting Started ---------------------------------------------------------

#' Although the `tidyverse` has been striving to make its error and warnings
#' messages more easily understood, Base R still has errors and warnings that
#' can be challenging to make sense of.

library(tidyverse)

# Error Messages ----------------------------------------------------------

#' [Operator is invalid for atomic vectors]
#' The operation you are trying to use does not work on vectors

my_vec <- c(a = 1, b = 2, c = 3)
my_vec$a
my_vec["a"]


#' [Cannot open the connection]
#' Usually an issue with file paths, check working directory, project directory,
#' and that files still exist where you think they should using `fs` package
#' with `fs::dir_ls()` or `fs::dir_info()`

read.csv("path/to/my_file.csv")


#' [Object cannot be coerced to type ...]:
#' an operation is failing to change the data types you are working with.  In
#' some cases type conversion is expected, like with `paste()`, but in other
#' cases you should explicitly specify the type you're expecting like the in the
#' case of the tidyverse if_else

if_else(TRUE, 10, "20")
if_else(TRUE, as.character(10), as.character("20"))


#' Special note about creating missing values, NA values are logical by default,
#' and in some cases you will run into trouble if you want to create missing
#' values.  In these cases, you can use `NA_real_`, `NA_complex_`,
#' `NA_character_`, or `NA_integer_`.  The `rlang` package also has `na_lgl` for
#' logical missing values when needed

if_else(TRUE, "text", NA)
if_else(TRUE, "text", NA_character_)


#' [Could not find function ...]
#' Ensure you are properly calling the `library()` you intend to, or are
#' properly calling the `source()` you for personal R functions you want to load

my_function("argument_1")


#' [Missing value where TRUE/FALSE needed] / [Argument is not interpretable as logical]
#' This occurs when a condition check does not produce a TRUE or FALSE value

if (format(0.12345, digits = 2)) {
  print("Success!")
}

if (mean(c(1, 2, NA))) {
  print("Success!")
}


#' [Argument "x" is missing, with no default]
#' The function you are using requires additional arguments. Check the help page
#' for this function to see all the required arguments

mean()


#' [Object of type 'closure' is not subsettable]
#' This error occurs when an operation is attempting to work with elements of an
#' R object, when it is not appropriate to do so. This error can commonly occurs
#' when matrix operations are being run, or when working within a Shiny reactive
#' context.

mean$not_an_element
mean["not_an_element"]
mean[["not_an_element"]]


#' [Error in eval(...): object not found]
#' This error occurs when objects being referenced do not exist in the
#' environment that the function is operating within, either in the Global
#' Environment, the function environment, or as a variable in the data.  This
#' often occurs in a tidyverse pipeline when quoted/unquoted variable names get
#' mismatched


#' [Miscellaneous Errors]
#' Sometimes when you encounter an error that doesn't seem to fit the context of
#' your operation, you might have loaded a package with conflicting function
#' names.  To combat this, ensure you are using the package prefix notation when
#' specifying the function you are using like `packagename::function()`. Or you
#' can explore the `conflicted` package on CRAN for greater control over
#' function-name priority

#' If you are expecting to receive errors consistently in your scripts, you
#' can use the `tryCatch()` function to suppress the error message and continue
#' the operation


# Warning Messages --------------------------------------------------------

#' Sometimes warnings indicate a larger issues with data quality, and sometimes
#' they are simply messages included by a function's author to inform the user
#' of what is happening.  So, some warnings can be safely ignored, while others
#' should definitely be investigated.
#'
#' If you continuously receive warnings that you want to hide, use the
#' `suppressWarnings()` function.  If you want to see a print the most recent
#' warning or set of warnings from an operation, use the `warnings()` function


#' [Condition has length > 1 and only the first element will be used]
#' In this case, the operation you are attempting to use is not vectorized and
#' will only use the first element of the vector you are supplying.  this is
#' dangerous because it will still return a valid result, but you won't know
#' that it ignored a majority of the values. In cases like these, the functions
#' `any()` and `all()` can be used to check all the values of a vector

my_conditions <- c(1, 2, 3)

if (my_conditions == 1){
  print("Success!")
}


#' [NAs introduced by coercion]
#' Commonly occurs when attempting to convert character values to numeric
#' values.  Be sure to take extra care when setting up these conversions.  the
#' `readr::parse_` functions can assist with this process to grab relevant text
#' from a string

as.numeric(c(1, 2, "text", "text"))



# Seeking Help ------------------------------------------------------------

#' For other types of error messages not listed here, it is recommended to
#' directly copy and paste the error into an internet search engine. Oftentimes,
#' there will be others that have had the same issues and have discussed it
#' online.
#'
#' [RStudio Help Panel]
#' Click the [Home] button to find links to online resources, including "R on
#' StackOverflow", "Getting Help with R", and the "RStudio Community Forum"



# Documentation -----------------------------------------------------------

#' Website References:
#'
#' - 2015 Analysis of Most Common R Questions on StackOverflow
#'   [https://github.com/noamross/zero-dependency-problems/blob/master/misc/stack-overflow-common-r-errors.md]


# -------------------------------------------------------------------------
