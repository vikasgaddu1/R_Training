# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Setup -------------------------------------------------------------------

library(randomNames)
library(logr)


log_open("sp_intro1", show_notes = TRUE)


# Data Frame Construction -------------------------------------------------

sep("Create data frame")

subjid <- 100:109
name <- randomNames(10)
sex <- factor(c("M", "F", "F", "M", "M", "F", "M", "F", "F", "M"),
              levels =  c("M", "F", "UNK"))
age <- c(41, 53, 43, 39, 47, 52, 21, 38, 62, 26)
arm <- c(rep("A", 5), rep("B", 5))

# First data frame
df <- data.frame(subjid, name, sex, age, arm)

put(df)


# Data Frame Subsetting  ---------------------------------------------------


sep("Subset data frame")


put("subjid and name subet")

df1 <- df[c("subjid", "name")]

put(df1)

put("arm A subset")

df2 <- subset(df, df$arm == "A")

put(df2)



# Data Frame Statistics ---------------------------------------------------


sep("Get data frame statistics")


put("Summary statistics")
put(summary(df))


put("Frequency statistics")
put(table(df$sex))



# Clean up ----------------------------------------------------------------



log_close()


