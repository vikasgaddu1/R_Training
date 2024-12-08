# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# check to ensure your working directory is set to the course level
# using the top program menu Session > Set Working Directory > Choose Directory..


# Exercises for Conditions ---------
# Exercise Step 3
# create a variable called study_blind_status and assign the value Blinded.
setwd("/cloud/project/Code_Data_2024_03_27/Code and Data/3.0 R Language Foundation 2")

study_blind_status <- "Blinded"

# Exercise Step 4
# use a condition to perform specific actions based on whether the variable
# study_blind_status is equal to Blinded or Unblinded.
if (study_blind_status == 'Blinded') {
  message = "Blind NOT broken. Results can be shared internally."
  trt_vector <- c('TRT A', 'TRT B')

} else if (study_blind_status == 'Unblinded') {
  message <- "Blind is broken. Share results with extreme caution!"
  trt_vector <- c('Active 100mg', 'Placebo')
} else {
  message <- "Fix study_blind_status value immediately!"
  trt_vector <- c('N/A 1', 'N/A 2')
  stop("(USER DEFINED) Invalid Value Supplised for study_blind_status")
}

# Exercise Step 5
study_blind_status <- "Blinded"
study_blind_status <- "Unblinded"
study_blind_status <- "something else"


# Exercise Step 6
# change the conditional logic so the case sensitivity of the values for
# study_blind_status does not matter using the tolower()function.
study_blind_status <- tolower(study_blind_status)
if (tolower(study_blind_status) == 'blinded') {
  message = "Blind NOT broken. Results can be shared internally."
  trt_vector <- c('TRT A', 'TRT B')
} else if (tolower(study_blind_status) == 'unblinded') {
  message <- "Blind is broken. Share results with extreme caution!"
  trt_vector <- c('Active 100mg', 'Placebo')
} else {
  message <- "Fix study_blind_status value immediately!"
  trt_vector <- c('N/A 1', 'N/A 2')
  stop("(USER DEFINED) Invalid Value Supplied for study_blind_status")
}

# Exercise Step 7
study_blind_status <- "BLINDED"
study_blind_status <- "UnBlinded"
study_blind_status <- "something else"


# If needed, code to create invdata_metadata
# varnames  <- c("invid","sex","yearsexp","site")
# varlabels <- c("Investigator #","Sex","Years Experience","Site Code")
# vardesc   <- c("Investigator ID assigned by FDA",
#               "Investigator sex at birth",
#               "Years of experience in industry",
#               "Closest site hub to investigator's home address")
#
# invdata_metadata <- data.frame(varnames, varlabels, vardesc)
# saveRDS(invdata_metadata, 'invdata_metadata.rds')

# Exercises for Loops ---------
# Exercise Step 3
# Read in the invdata.rds file that we created in the last exercise.
invdata <- readRDS('_data/invdata.rds')

# Exercise Step 4
# in the course level directory, there is an rds file called invdata_metadata.rds.
# Read it into a data frame called invdata_metadata and view the data.
# As you will notice there are labels and descriptions for each variable in the invdata
# data frame.
# Use a for loop to loop over each variable in the invdata data frame and read in the corresponding
# labels and descriptions, and update the label and description attributes on invdata.
invdata_metadata <- readRDS('_data/invdata_metadata.rds')

class(invdata['invid'])


# Exercise Step 5
for (varnm in names(invdata)) {
  attr(invdata[[varnm]], "label") <-
    invdata_metadata$varlabels[invdata_metadata$varname == varnm]
  attr(invdata[[varnm]], "description") <-
    invdata_metadata$vardes[invdata_metadata$varname == varnm]
}

str(invdata)
# Exercise Step 7
# using the unique() function, create a vector of unique sites from the invdata data frame.
distinct_sites <- unique(invdata$site)
library(janitor)
tabyl(invdata$site)
summary(invdata$yearsexp)

# Exercise Step 8
# using the vectorized ifelse change the value for the site "KAL" to "AZO".
invdata$site <- ifelse(invdata$site == "KAL", "AZO", invdata$site)

# Exercise Step 9
library(dplyr)

# Exercise Step 10
invdata$site_city <- case_when(
  invdata$site == "AZO" ~ "Kalamazoo",
  invdata$site == "ORD" ~ "Chicago",
  invdata$site == "SFO" ~ "San Francisco",
  TRUE ~ "Unknown"
)

# Exercise Step 11
saveRDS(invdata, '_data/invdata_new.rds')
