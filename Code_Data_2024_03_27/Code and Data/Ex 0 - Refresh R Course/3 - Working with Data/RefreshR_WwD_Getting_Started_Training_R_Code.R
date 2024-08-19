
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Working with Data - Getting Started

# Packages & Functions on Display:
# - {base 4.2.0}: class(), nrow(), ncol(), colnames(), attributes(), str(),
#                colnames(), sort(), order(), attr(), View(), [ ], [[ ]]

# - {dplyr  1.0.8}: select(), pull(), glimpse(), rename(), relocate(), last_col()
# - {tibble 3.1.6}: as_tibble()


# Setup -------------------------------------------------------------------

library(tidyverse)


# Working with Data -------------------------------------------------------

# There are many built-in datasets that R provides
library(help = "datasets")


# Motor Trend Car Road Tests is a popular one
df_base <- mtcars %>% print()


# Inspect Data
df_base %>% class()


# Convert to Tidyverse Tibble
df_tidy <- df_base %>% as_tibble()    # Additional information, truncated display
df_tidy %>% class()                   # A DF with more classes


# Data Inspection ---------------------------------------------------------

df_base %>% nrow()
df_base %>% ncol()
df_base %>% colnames()
df_base %>% attributes()


# Data Structure
df_base %>% str()       # Base R Function
df_base %>% glimpse()   # Tidyverse Function


# Data Subset -------------------------------------------------------------

# Base R Operators
df_base$mpg          # Output is a dataframe column
df_base["mpg"]
df_base[["mpg"]]     # Output is a vector


# Tidyverse Functions
df_base %>% select(mpg)   # Equivalent to [ ]
df_base %>% pull(mpg)     # Equivalent to [[ ]]


# Tidyverse Subsetting
df_base[1:5, "mpg"]  # Dataframes silently become vectors
df_tidy[1:5, "mpg"]  # Tibbles remain tibbles



# Rename Columns ----------------------------------------------------------

# Using Base R
df_base <- mtcars %>% print()
colnames(df_base)[colnames(df_base) == "mpg"] <- "miles_per_gallon"
colnames(df_base)[colnames(df_base) == "cyl"] <- "cylinders"
df_base


# Using Tidyverse Function
df_tidy %>% rename(miles_per_gallon = mpg, cylinders = cyl)



# Arrange Columns by Value ------------------------------------------------

df_base <- mtcars %>% print()

# Using Base R
df_base[order(df_base[["mpg"]]), colnames(df_base)]


# Using Tidyverse Function
df_base %>% arrange(mpg)
df_base %>% arrange(cyl, mpg)



# Arrange Column Order ----------------------------------------------------

# Using Base R
df_base
df_base[sort(colnames(df_base))]

# - Move "qsec" to the front of the dataset
df_base[c("qsec", "mpg", "cyl", "disp", "hp", "drat", "wt", "vs", "am", "gear", "carb")]


# Using Tidyverse Functions
df_base %>% relocate(sort(colnames(df_base)))
df_base %>% relocate(qsec, .before = 1)
df_base %>% relocate(qsec, .after = last_col())



# Create Variable Labels --------------------------------------------------

attr(df_base$mpg, "label") <- "Miles Per Gallon"
View(df_base)


# Documentation -----------------------------------------------------------

# Vignettes
vignette("base")
vignette("dplyr")
vignette("tidy-data")

# Website References
# - https://r4ds.had.co.nz/transform.html
# - https://r4ds.had.co.nz/tidy-data.html
# - https://www.rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
