
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Data Types - Vectors

# Packages & Functions on Display:
# - {base 4.2}: c(), print(), class(), typeof(), length(), [ ], [[ ]],
#              paste()


# Setup -------------------------------------------------------------------

library(tidyverse)

# Vectors -----------------------------------------------------------------
# A set of values of the same data type

# Create a Vector
vec_1 <- c(1, 2, 3) %>% print()
vec_2 <- c("A", "B", "C") %>% print()


# Create a Named Vector
vec_3 <- c("N1" = 10, "N2" = 20, "N3" = 30) %>% print()


# Inspect a Vector --------------------------------------------------------

class(vec_1); typeof(vec_1); length(vec_1)


# Subset a Vector ---------------------------------------------------------

vec_3[3]
vec_3[c(2, 1)]
vec_3["N1"]


# Remove an Element
vec_3[-2]


# Vector Operations -------------------------------------------------------

vec_1 + 10
paste("ARM", vec_2)


# Vector Arithmetic by Index
vec_1 + c(10, 20, 30)


# Use Case: Vector Decode -------------------------------------------------

event       <- c(1, 2, 3, 3, 2, 1) %>% print()
event_label <- c("1" = "Event A", "2" = "Event B", "3" = "Event C") %>% print()

event_label[event]


# Documentation -----------------------------------------------------------

# Help Pages
help("c")
help("vector")

# Website References
# - https://r4ds.had.co.nz/vectors.html
# - https://www.w3schools.com/r/r_vectors.asp

# -------------------------------------------------------------------------
