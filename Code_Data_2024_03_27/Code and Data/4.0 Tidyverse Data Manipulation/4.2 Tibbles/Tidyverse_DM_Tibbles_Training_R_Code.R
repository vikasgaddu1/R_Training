
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2020 Anova Groups All rights reserved

# Title: Dataframes and Tibbles

# Packages & Functions on Display:
# - {tibble 3.0.1}: as_tibble, tibble, tribble, rowid_to_column


# Setup -------------------------------------------------------------------

library(randomNames)
library(tidyverse)


# Dataframe Inconveniences ------------------------------------------------

subjid <- 1020:2019
name   <- randomNames(1000)
sex    <- sample(c("M", "F", "UNK"), size = 1000, replace = TRUE)
age    <- sample(40:75, size = 1000, replace = TRUE)
arm    <- sample(c("A", "B", "C"), size = 1000, replace = TRUE)


# Factor Conversion: Default Before R version 4.0, June 2020
data_df <- data.frame(subjid, name, sex, age, arm, stringsAsFactors = TRUE)
str(data_df)


# Prints Too Much Text
print(data_df)


# Inconsistent Subsetting
class(data_df["name"])
class(data_df[1:10,  "name"])

class(data_df[["name"]])


# Motivation for the Tibble -----------------------------------------------

# Convert between Dataframe and Tibble
data_tb <- as_tibble(data_df)
data_df <- as.data.frame(data_tb)


# Create Tibble with Existing Vectors
data_tb <- tibble(subjid, name, sex, age, arm)
str(data_tb)


# Improved Console Printing
print(data_tb)


# Consistent Subsetting
class(data_tb["name"])
class(data_tb[1:10, "name"])

class(data_tb[["name"]])


# Transposed Tibble -------------------------------------------------------

# Defined Variable by Variable
tibble(subjid = c(100, 200),
       name   = c("Crowe, Autumn", "Raven, Spring"),
       sex    = c("F", "M"),
       age    = c(60, 65),
       arm    = c("A", "B"))


# Defined Row by Row (SAS CARDS / DATALINES)
tribble(~subjid,           ~name, ~sex, ~age, ~arm,
            100, "Crowe, Autumn",  "F",   60,  "A",
            200, "Raven, Spring",  "M",   65,  "B")


# Row IDs -----------------------------------------------------------------

rowid_to_column(data_tb, var = "my_rowid")


# Documentation -----------------------------------------------------------

# Vignettes
vignette("tibble")

# Help Pages
help(tibble,          package = "tibble")
help(as_tibble,       package = "tibble")
help(formatting,      package = "tibble")
help(as.data.frame,   package = "base")
help(rowid_to_column, package = "tibble")

# Website References
# https://rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------

