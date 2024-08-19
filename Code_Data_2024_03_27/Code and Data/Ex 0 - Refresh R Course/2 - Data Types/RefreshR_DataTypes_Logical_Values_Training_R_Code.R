
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Data Types - Logical Values

# Packages & Functions on Display:
# - {base 4.2.0}: T, TRUE, F, FALSE, NA, NULL,
#                as.numeric(), sum(), mean(), list(), data.frame(), print()


# Setup -------------------------------------------------------------------

library(tidyverse)

# Logical Values ----------------------------------------------------------

T; TRUE
F; FALSE


# Logical Values as Integers ----------------------------------------------

as.numeric(T); as.numeric(F)

# Count TRUE values
sum(T, T, T)
sum(F, F, F)


# Missing Values ----------------------------------------------------------

NA

mean(c(1, 2, 3))
mean(c(1, 2, 3, NA))              # Missing values are "contagious"
mean(c(1, 2, 3, NA), na.rm = T)


# Null Values -------------------------------------------------------------
# NULL removes elements

my_lst    <- list(a = 1, b = 2, c = 3) %>% print()
my_lst[1] <- NULL
my_lst


my_df   <- data.frame(a = 1, b = 2, c = 3) %>% print()
my_df$a <- NULL
my_df


# Documentation -----------------------------------------------------------

# Help Pages
help("logical")

# Website References
# - https://www.w3schools.com/r/r_booleans.asp
# - https://r4ds.had.co.nz/vectors.html#logical

# -------------------------------------------------------------------------
