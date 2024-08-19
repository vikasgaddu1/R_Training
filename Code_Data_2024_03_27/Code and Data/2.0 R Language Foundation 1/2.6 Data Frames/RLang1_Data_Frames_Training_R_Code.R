# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Data Frame Introduction -------------------------------------------------
library(randomNames)

# Generate random names
name <- randomNames(10)

# Create Vectors
subjid <- 100:109
sex <- factor(c("M", "F", "F", "M", "M", "F", "M", "F", "F", "M"),
              levels =  c("M", "F", "UNK"))
age <- c(41, 53, 43, 39, 47, 52, 21, 38, 62, 26)
arm <- c(rep("A", 5), rep("B", 5))

# First data frame
df <- data.frame(subjid, name, sex, age, arm)
df

# Examine dimensions
length(df)
ncol(df)
nrow(df)

# Examine attributes
class(df)
names(df)
attributes(df)
str(df)
typeof(df)

View(df)

# Data Frame Attributes ---------------------------------------------------

# Add label attribute
attr(df$subjid, "label") <- "Subject ID"
attr(df$name, "label") <- "Subject Name"
attr(df$sex,  "label") <- "Sex"
attr(df$age,  "label") <- "Age"
attr(df$arm,  "label") <- "Arm Code"

View(df)

# Add description attribute
attr(df$subjid, "description") <- "A three-digit subject identifier"
attr(df$name, "description") <- "The first name of the subject."
attr(df$sex,  "description") <-
  "The sex of the subject.  Valid values are M, F or UNK."
attr(df$age,  "description") <- "The age of the subject."

View(df)

attributes(df$subjid)
str(df)


# Data Frame Subsetting ---------------------------------------------------

# Subset by position or name
df[1]
df["subjid"]
df[c("subjid", "name")]

# Vectorized functions
mean(df$age)
range(df$age)
summary(df$age)
table(df$sex)

mean(df["age"])  # Error

# Subset by Column
df1 <- df[c("subjid", "name")]
print(df1)
class(df1)

# Subset by Column
df2 <- df["age"]
print(df2)
class(df2)

# Extract Vector
v1 <- df$age
print(v1)
class(v1)

# Extract Vector
v2 <- df[["age"]]
print(v2)
class(v2)

# Two dimensional subsetting
df[1, "subjid"]
df[1:5, c("subjid", "name")]
df[1:5,]
df[df$age > 40,]

# Subset function
subset(df, df$age > 40, c("subjid", "name"))
