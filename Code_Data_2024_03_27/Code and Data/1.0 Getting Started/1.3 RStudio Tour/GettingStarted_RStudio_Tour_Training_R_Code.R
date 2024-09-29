# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# An Introduction to R Studio ----
# In this section we load a package and get summary statistics


days <- 245
years <- days / 365
print(years)

library(dplyr)
mtcars
our_data <- mtcars

our_summary <- summary(our_data)

class(our_summary)

# Help ------------------------------------------------------------------------
# In this section we ask for help with a function

?summary
our_summary
