
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Data Types - Numeric Values

# Packages & Functions on Display:
# - {base  4.2.0}: typeof(), summary(), median(), mean(), sd(), sum(), range(),
#                 length(), quantile(),
#                 :, +, -, *, /, ^, %%
#
# - {dplyr 1.0.8}: cummean(), cumsum(), ntile(), dense_rank()


# Setup -------------------------------------------------------------------

library(tidyverse)

# Numeric Values ----------------------------------------------------------

typeof(1)          # Double
typeof(1L)         # Integer

typeof(1.0)        # Double

typeof(1:10)       # Integer
typeof(1:10 / 100) # Double


# Numeric Arithmetic ------------------------------------------------------

10 : 2      # Create a series
10 + 2      # Addition
10 - 2      # Subtraction
10 * 2      # Multiplication
10 / 2      # Division
10 ^ 2      # Exponentiation

10 %% 2     # Modulo / Remainder


# Numeric Summary ---------------------------------------------------------

15:125 %>% summary()
15:125 %>% median()
15:125 %>% mean()
15:125 %>% sd()
15:125 %>% sum()
15:125 %>% range()
15:125 %>% length()
15:125 %>% quantile()
15:125 %>% quantile(.45)


# Tidyverse Numeric Functions ---------------------------------------------
15:125 %>% cummean()    # Cumulative Mean
15:125 %>% cumsum()     # Cumulative Sum
15:125 %>% ntile(2)     # Break vector into n equal groups
15:125 %>% dense_rank() # Rank the values


# Documentation -----------------------------------------------------------

# Help Pages
help("numeric")

# Website References
# - https://www.w3schools.com/r/r_numbers.asp
# - https://r4ds.had.co.nz/vectors.html#numeric

# -------------------------------------------------------------------------
