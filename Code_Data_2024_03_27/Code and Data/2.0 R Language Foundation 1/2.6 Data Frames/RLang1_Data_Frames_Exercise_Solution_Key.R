
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key


# Data Frames Part 1 Exercises ---------------------------------------------

# Exercise Step 3
# Enter the code below, examine the results, and get familiar with the rep function
# and arguments times=, each=, and length.out= arguments. Experiment on your own.
tcr_times <- rep(c('A20', 'A50', 'P'), times = 3)
print(tcr_times)

tcr_each <- rep(c('A20', 'A50', 'P'), each = 3)
print(tcr_each)

tcr_times_each <- rep(c('A20', 'A50', 'P'), times = c(4, 3, 2))
print(tcr_times_each)

tcr_times_lenout <- rep(c('A20', 'A50', 'P'), length.out = 8)
print(tcr_times_lenout)

# Exercise Step 4
# Now let's build a data frame by creating some vectors and then putting them together.
# Our first data frame will have two rows and three columns. The columns will be named
# trt_code, blinded_code, and trt_label. The data frame should look like the one below.
#
# trt_code   blinded_code   trt_label
# A          X              Active 5mg
# P          Y              Placebo
trt_code <- c('A5', 'P')
blinded_code <- c('X', 'Y')
trt_label <- c('Active 5mg', 'Placebo')
age <- c(34,56)
trt_table <- data.frame(trt_code, blinded_code, trt_label,age)


# Exercise Step 5
print(trt_table)

# Exercise Step 6
# Build a data frame named demo_p100 that looks like data table below.
# study      subjid   sex    age  trtarm
# P100       1        F      33   A10
# P100       2        M      41   A50
# P100       3        F      29   P
# P100       4        F      25   P
# P100       5        M      28   A50

study <- rep(c("P100"), time = 5)
subjid <- seq(c(1:5))
sex <- c('F', 'M', 'F', 'F', 'M')
age <- c(33, 41, 29, 25, 28)
trtarm <- c('A10', 'A50', 'P', 'P', 'A50')

demo_p100 <- data.frame(study, subjid, sex, age, trtarm)


# Data Frames Part 2 Exercises --------------------------------------------

# Exercise Step 3
# Add label attributes to each of the three columns of your data frame.
attr(trt_table$trt_code, "label") <- "Treatment Code"
attr(trt_table$blinded_code, "label") <- "Blinded Code"
attr(trt_table$trt_label, "label") <- "Treatment Label"

# Exercise Step 4
print(trt_table)

# Exercise Step 5
attr(demo_p100$study, "label") <- "Study"
attr(demo_p100$subjid, "label") <- "Subject #"
attr(demo_p100$sex, "label") <- "Sex"
attr(demo_p100$age, "label") <- "Age"
attr(demo_p100$trtarm, "label") <- "Treatment Arm"

# Exercise Step 6
# Examine the metadata of the data frame demo_p100 using the
# class(), attributes(), typeof(), and str() functions.
class(demo_p100)
attributes(demo_p100)
typeof(demo_p100)
str(demo_p100)

# Exercise Step 7
# Examine the data of the data frame demo_p100 using the print() function.
print(demo_p100)


# Data Frames Part 3 Exercises --------------------------------------------

# Exercise Step 3
# Create vectors called bc_v1 and bc_v2 which subset the trt_table keeping only the
# blinded_code variable. Use the dataframe$variable notation for the bc_v1 variable
# and dataframe[['variable']] notation for the bc_v2 variable.
# Use the class() function on bc_v1 and bc_v2 to examine the object type.
bc_v1 <- trt_table$blinded_code
bc_v2 <- trt_table[['blinded_code']]
class(bc_v1)
class(bc_v2)

# Exercise Step 4
# Create a data frame called bc_df which subsets the trt_table keeping only the
# blinded_code variable.
bc_df <- trt_table['blinded_code']
class(bc_df)

# Exercise Step 5
# Find the range of subjid using the range() function.
# Refer to the subjid using the double [[ ]] notation.  i.e.  dataframe[['variable']]
range(demo_p100[['subjid']])

# Exercise Step 6
# Find the mean, median, and quantiles of age in demo_p100 using the mean(),
# median(), and quantile() functions respectively.
# Refer to the age variable using the $ notation. i.e.  dataframe$variable
mean(demo_p100$age)
median(demo_p100$age)
quantile(demo_p100$age)

# Exercise Step 7
# Using the subset function, create a data frame named demo_subset that only
# contains the variables subjid, age, and trtarm for only subjects that are
# between 30 and 40 years old.
demo_subset <- subset(demo_p100,
                      demo_p100$age > 30 & demo_p100$age < 40,
                      c("subjid", "age", "trtarm"))

# Exercise Step 8
# Examine the metadata of demo_subset using the str() function. Notice if the variable labels
# were propagated from demo_p100.
str(demo_subset)

