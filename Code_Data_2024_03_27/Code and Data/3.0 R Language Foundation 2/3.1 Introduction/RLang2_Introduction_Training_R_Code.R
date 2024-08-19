# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved


library(randomNames)

# How to Save an object ---------------------------------------------------

# Setup
subjid <- 100:109
name <- randomNames(10)
sex <- factor(c("M", "F", "F", "M", "M", "F", "M", "F", "F", "M"),
              levels = c("M", "F", "UNK"))
age <- c(41, 53, 43, 39, 47, 52, 21, 38, 62, 26)
arm <- c(rep("A", 5), rep("B", 5))

# Create data frame
df <- data.frame(subjid, name, sex, age, arm)
df

# Save to rds file
saveRDS(df, "df.rds")

# Read from rds file
df2 <- readRDS("df.rds")
df2


# Save any R object!


# How to source a script --------------------------------------------------


# 1. Create script file

# 2. Source script
source("3.1 Introduction/formats.R")   # %include

# 3. Use script content
arm_decoded <- arm_decode[df$arm]
arm_decoded



# File Paths  -------------------------------------------------------------


formats_path <- "c:\Projects\R Training\formats.R"       # Error

formats_path <- "c:\\Projects\\R Training\\formats.R"    # No error

formats_path <- "c:/Projects/R Training/formats.R"       # No error
