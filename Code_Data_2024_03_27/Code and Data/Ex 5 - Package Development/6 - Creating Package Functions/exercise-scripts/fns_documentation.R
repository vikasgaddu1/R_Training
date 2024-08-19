
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Creating Package Functions - Solution Key

# Setup -------------------------------------------------------------------
library(devtools)
library(dplyr)


#' Function for Quoting an Unquoted Single String
#'
#' Pass in a single unquoted string and the text_sub function will add quotes to it.
#'
#' @param unqarg The string to add quotes around.
#'
#' @return unqarg as a quoted string
#' @export
#'
#' @examples
#' text_sub(blahblahblah)
#'
text_sub <- function(unqarg) {
  deparse(substitute(unqarg))
}


#' A function to add a group for a single variable to a data frame.
#'
#' @param medata The data to add the group_by flag to
#' @param varname The variable name to group by. Should be in quotes.
#'
#' @return a data frame grouped by the specified variable
#' @export
#'
#' @examples
#' mtcars %>% create_group_var("am")
#'
create_group_var <- function(medata, varname) {

  medata %>% group_by(.data[[ varname ]])
}

#' A function to return summary stats
#'
#' @param input_values values to summarize
#' @param operation  the statistic to summarize the values by
#'
#' @return The specified summary stats
#' @export
#'
#' @examples
#' my_summstats_function(c(1,2,3), "sum")
#'
my_summstats_function <- function(input_values, operation) {
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
