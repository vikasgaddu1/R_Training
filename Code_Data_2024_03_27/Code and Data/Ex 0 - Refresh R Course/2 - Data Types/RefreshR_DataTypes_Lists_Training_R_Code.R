
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Data Types - Lists

# Packages & Functions on Display:
# - {base  4.2.0}: list(), [ ], [[ ]], $
# - {dplyr 1.0.8}: lst()


# Setup -------------------------------------------------------------------

library(tidyverse)

# Create a List -----------------------------------------------------------
# Vectors store values of a single type, lists store vectors of varying types

# Create a list with existing vectors
vec_1 <- pi
vec_2 <- letters
vec_3 <- month.name
vec_4 <- 1:100

base::list(vec_1, vec_2, vec_3, vec_4)
dplyr::lst(vec_1, vec_2, vec_3, vec_4)    # Tidyverse list retains vector names


# Create a List Directly --------------------------------------------------

list_1 <-
  list(
    vec_1 = pi,
    vec_2 = letters,
    vec_3 = month.name,
    vec_4 = 1:100)


# Subset a List
list_1[2]  ; list_1["vec_2"]    # Return the return the list element
list_1[[2]]; list_1[["vec_2"]]  # Return the raw vector
list_1$vec_2                    # Equivalent to using [[ ]]


# Documentation -----------------------------------------------------------

# Help Pages
help("list")

# Website References
# - https://www.w3schools.com/r/r_lists.asp
# - https://r4ds.had.co.nz/vectors.html#lists

# -------------------------------------------------------------------------
