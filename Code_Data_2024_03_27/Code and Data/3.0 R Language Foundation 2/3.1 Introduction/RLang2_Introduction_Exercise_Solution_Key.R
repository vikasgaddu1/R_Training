# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Exercise Step 3
# Create vectors, factors, and data frame ---------------------------------

# Exercise Step 4
# Create a vector that contains investigator numbers from 1001 to 1005. Name it invid.
invid <- c(1001:1005)

# Exercise Step 5
# Create a factor named sex with values 'M', 'F', 'M', 'M', 'F' and levels 'M', 'F', 'NR'.
sex <- factor(c('M', 'F', 'M', 'M', 'F'), levels = c("M", "F", "NR"))

# Exercise Step 6
# Create a vector named yearsexp with the values 23, 12, 10, 3, 2.
yearsexp <- c(23, 12, 10, 3, 2)

# Exercise Step 7
# Create a vector named site with the values 'KAL', 'KAL', 'SFO', 'ORD','ORD'.
site <- c('KAL', 'KAL', 'SFO', 'ORD', 'ORD')

# Exercise Step 8
# Create a data frame named invdata using the data.frame function
# to combine the 5 vectors above.
invdata <- data.frame(invid, sex, yearsexp, site)

# Exercise Step 9
# Check the value of your working directory and make sure it is set to the
# appropriate location for the 'R Language Foundation 2' course.
# We will be using this across the modules within this course.
getwd()

# Exercise Step 10
# Use the saveRDS function to save the invdata data frame to disk in your
# working directory. Name the file invdata.rds.
saveRDS(invdata, "_data/invdata.rds")

# Exercise Step 11
# Use the readRDS function to read in invdata.rds and create a data frame named
# invdata_fromdisk.
invdata_fromdisk <- readRDS('_data/invdata.rds')


# Exercise Step 12
saveRDS(sex, "_data/sex_factor.rds")

# Exercise Step 13
# Source Function

# Exercise Step 15
# Using the source() function, "%include" the decodes.R script.
source("3.1 Introduction/decodes.R")

