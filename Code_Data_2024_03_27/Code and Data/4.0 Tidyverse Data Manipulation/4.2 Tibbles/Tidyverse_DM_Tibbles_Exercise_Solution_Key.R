
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key


# Data frames -------------------------------------------------------------
install.packages('tidyverse')
# Exercise Step 4
library(tidyverse)
setwd("/cloud/project/Code_Data_2024_03_27/Code and Data/4.0 Tidyverse Data Manipulation")
# Exercise Step 5
# read in the adae.rds data file in the course directory
adae <- readRDS('_data/adae.rds')

# Exercise Step 6
# Use the as.data.frame() function to create a data frame called adae_df
adae_df <- as.data.frame(adae)
# adae_df <- as_data_frame(adae) deprecated

# Exercise Step 8
# Examine adae_df using the class() function and examine the results.
class(adae_df)

# Exercise Step 9
# Subset the data frame so that it's just the *TRTP* variable.
# Examine the class of that subset. You can do this in two steps or one.
class(adae_df["TRTP"])

# Exercise Step 10
# Create a two-dimensional subset of the data frame,
# e.g. *TRTP* and rows 50 to 100, and examine the class. What is different?
class(adae_df[50:100,"TRTP"])

# Exercise Step 11
# Print the results of adae_df to the console and examine the results.
print(adae_df)

# Tibbles -----------------------------------------------------------------

# Exercise Step 6
# To ensure we have a tibble, use the function as_tibble() to create a tibble
# called adae_tibble
adae_tibble <- as_tibble(adae)

# Exercise Step 7
# examine adae_tibble using the class() function and examine the results.
class(adae_tibble)

# Exercise Step 9
# Print the results of adae_tibble to the console and examine the results.
# How does this compare to printing the data frame?
print(adae_tibble)

class(adae_tibble["TRTP"])

class(adae_tibble[50:100,"TRTP"])

# Exercise Step 10
# create a tibble data frame called invdata using the tribble function
# it should be equivalent to
#
# data invdata;
#  infile cards truncover;
#  input invid invname $ site $ yearsexp;
#  cards;
# 1001 Phil AZO 12
# 1002 Oz ORD 19
# run;
invdata <- tribble(
~invid, ~invname, ~site, ~yearsexp,
1001,   "Phil", "AZO", 12,
1002,   "Oz", "ORD", 19
)

# Exercise Step 13
# examine invdata using the class() function and examine the results.
class(invdata)

# Print the results of invdata to the console and examine the results.
print(invdata)

