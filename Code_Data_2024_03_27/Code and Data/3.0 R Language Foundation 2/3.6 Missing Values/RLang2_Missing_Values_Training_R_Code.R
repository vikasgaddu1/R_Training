# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Missing Values Introduction ---------------------------------------------

NA             # Not Available
NaN            # Not a Number
Inf            # Infinity (+/-)
NULL           # NULL
""             # Empty String

# Examples
t <- c(1)
t[2]           # NA
0 / 0          # NaN
1 / 0          # Inf-1 / 0         # -Inf
c()            # NULL
""             # Empty String
nchar("")

# Missing Classes
class(NA)      # Logical
class(NaN)     # Numeric
class(Inf)     # Numeric
class(NULL)    # Own class
class("")      # Character

# Relational Expressions
NA > 0         # NA
NaN > 0        # NA
Inf > 0        # TRUE
NULL > 0       # logical(0)
"" > 0         # FALSE

# Vectors
a <- c(1, NA, 2, 3)
a > 0

a <- c("1", NA, "2", "3")
a > "0"

b <- c(1, NaN, 2, 3)
b > 0

c <- c(1, Inf, 2, 3)
c > 0

d <- c(1, NULL, 2, 3)
d > 0

e <- c(1, 2, 3, 4)
e

# Assignment
e[2] <- NA       # Works
e

e[2] <- NULL     # Doesn't work
e

# Lists
f <- list(1, 2, 3, 4)
f
f[[2]] <- NA     # Works
f
f[[2]] <- NULL   # Removes
f

# NA in Functions
e
mean(e)
min(e)
max(e)

# Explicit exclusion
mean(e, na.rm = TRUE)
mean(na.omit(e))

# Testing for missing values
e == NA  # Incorrect
is.na(e) # Correct

is.na(a)
is.nan(b)
is.infinite(c)
is.null(d)      # Whole function returns NULL

is.na(b)        # NA test on NaN: TRUE
is.na(c)        # NA test on Inf: FALSE


# Use Cases ---------------------------------------------------------------

library(randomNames)

# No missing values
subjid <- 100:109
name <- randomNames(10)
sex <- factor(c("M", "F", "F", "M", "M", "F", "M", "F", "F", "M"),
              levels =  c("M", "F", "UNK"))
age <- c(41, 53, 43, 39, 47, 52, 21, 38, 62, 26)
arm <- c(rep("A", 5), rep("B", 5))

# Create data frame
df <- data.frame(subjid, name, sex, age, arm)
df

# Missing values
sex <- factor(c("M", "F", NA, "M", "M", "F", "M", "F", "F", "M"),
              levels =  c("M", "F", "UNK"))
age <- c(41, 53, 43, 39, 47, 52, 21, NA, 62, 26)


# Create data frame
df2 <- data.frame(subjid, name, sex, age, arm)
df2

# Table function
table(df$sex)
table(df2$sex)

# Mean function
mean(df$age)
mean(df2$age)
mean(df2$age, na.rm = TRUE)

# Subset function
subset(df2, is.na(df2$sex))
subset(df2,!is.na(df2$sex))

subset(df2, is.na(df2$age))
subset(df2,!is.na(df2$age))
