
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Data Types - Data Frames

# Packages & Functions on Display:
# - {base   4.2.0}: mtcars, letters, month.name,
#                  data.frame(), class(), as.list(), as.data.frame()
#                  [ ], [[ ]], $
#
# - {tibble 3.1.6}: tibble(), as_tibble()
# - {dplyr  1.0.8}: lst()


# Setup -------------------------------------------------------------------

library(tidyverse)

# Data Frames -------------------------------------------------------------
# A list displayed in tabular/spreadsheet format

# Many built-in data frames
mtcars


# Create a Data Frame -----------------------------------------------------

df_1 <-
  data.frame(
    col_1 = 1:10,
    col_2 = letters[1:10],
    col_3 = month.name[1:10])


# Create a Tibble ---------------------------------------------------------

df_2 <-
  tibble(
    col_1 = 1:10,
    col_2 = letters[1:10],
    col_3 = month.name[1:10])


# Subset a Data Frame -----------------------------------------------------

df_2[2]              # Subset a column
df_2[1, 2]           # Subset rows and column
df_2[1:3, c(2, 3)]   # Subset many rows and many columns

df_2[1:3, c("col_2", "col_3")]      # Using column names

df_2$col_2           # Using $ operator
df_2$col_2[1:3]


# Data Frame vs Tibble ----------------------------------------------------

df_1; df_2     # Tibbles display more information about the data

class(df_1)
class(df_2)    # A dataframe with additional attributes

df_1[1:3, 1]   # Subsetting a dataframe silently converts to a vector
df_2[1:3, 1]   # Subsetting a tibble consistently remains a tibble



# Data Frame vs List ------------------------------------------------------

col_1 <- 1:10
col_2 <- letters[1:10]
col_3 <- month.name[1:10]

df_1 %>% as.list()
dplyr::lst(col_1, col_2, col_3) %>% as.data.frame()
dplyr::lst(col_1, col_2, col_3) %>% as_tibble()


# Documentation -----------------------------------------------------------

# Vignettes
vignette("tibble")

# Help Pages
help("data.frame")

# Website References
# - https://tibble.tidyverse.org/
# - https://r4ds.had.co.nz/tibbles.html
# - https://www.rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
