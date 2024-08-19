# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)


name <- "Brian Varney"
places_lived <- c("San Diego, CA", "Denver, CO", "Austin, TX", "Buffalo, NY")
address1 <- "123 Candyland Lane"
city <- "Buffalo"
state <- "NY"
zip <- "14201"
age <- 54
height_in <- 70


profile <- lst(name, places_lived, address1, city, state, zip, age, height_in)

# exercise step 3
my_age <- profile[["age"]]
