
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Creating Package Functions - Solution Key

# Setup -------------------------------------------------------------------
library(devtools)
library(dplyr)


text_sub <- function(unqarg) {
  deparse(substitute(unqarg))
}


create_group_var <- function(medata, varname) {

  medata %>% group_by(.data[[ varname ]])
}

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
