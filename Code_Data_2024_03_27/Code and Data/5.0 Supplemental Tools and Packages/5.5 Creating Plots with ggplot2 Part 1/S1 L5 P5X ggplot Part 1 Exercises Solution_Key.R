# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Aesthetics -------------------------------------------------------------------

# Excercise Step 3
library(tidyverse)
library(haven)
# Use the following code to get started with this exercise. Ensure you understand the data pipeline
# and how it is creating the resulting data. Ensure your working directory is set to the course level.
# Excercise Step 4.a

adsl <- read_sas("_data/abc_adam_adsl.sas7bdat") %>%
  select(SUBJID, SITEID, ARM, AGEGR1, SEX) %>%
  filter(ARM != "SCREEN FAILURE") %>%
  mutate(
    ARM = factor(
      ARM,
      levels = c("ARM A", "ARM B", "ARM C", "ARM D"),
      ordered = TRUE
    ),
    AGEGR1 = factor(
      AGEGR1,
      levels = c(
        "18-29 years",
        "30-39 years",
        "40-49 years",
        "50-65 years",
        ">65 years"
      ),
      ordered = TRUE
    )
  )

advs <- read_sas("data/abc_adam_advs.sas7bdat") %>%
  select(SUBJID, SITEID, AVISITN, PARAMCD, AVAL) %>%
  filter(PARAMCD == "BMI" | (PARAMCD == "PULSE" & AVISITN == 0)) %>%
  pivot_wider(
    id_cols = c(SUBJID, SITEID),
    names_from = PARAMCD,
    values_from = AVAL,
    names_repair = "universal"
  )

# Excercise Step 4.c
plotdata <-
  inner_join(adsl, advs)

# Excercise Step 5.a
# Scatterplot of PULSE by BMI
ggplot(plotdata, aes(x = BMI, y = PULSE)) + geom_point()

# Excercise Step 5.b
# Scatterplot of PULSE by ARM
ggplot(plotdata, aes(x = ARM, y = PULSE)) + geom_point()

# Excercise Step 5.C
# Scatterplot of PULSE by BMI colored by ARM
ggplot(plotdata, aes(x = BMI, y = PULSE, color = ARM)) + geom_point()

# Excercise Step 6
# Look in the vignette for ggplot2 and find two other shapes that are
# interesting. Redo two of the three plots above with those shapes. Use the
# name for one shape and the number for the other.
vignette("ggplot2-specs")

# For example,
# shape = 8
ggplot(plotdata, aes(x = BMI, y = PULSE)) + geom_point(shape = 8)

# shape = "plus"
ggplot(plotdata, aes(x = ARM, y = PULSE)) + geom_point(shape = "plus")

# Excercise Step 7
# Create a scatterplot of PULSE by BMI. Set the shape according to the SITEID. We have 8 Site ID's (we are missing Site #5). What did ggplot2 warn us about with regard to using shapes and what was its behavior? Looking at the plot, do you agree?
ggplot(plotdata, aes(x = BMI, y = PULSE, shape = SITEID)) + geom_point()

# Excercise Step 8
# Create a scatterplot of PULSE by BMI. Define the shape with ARM. What warning does ggplot2 give about using shapes? Why does it give this warning? What aesthetics could you use to overcome this problem? Why do they work where shape did not? Which one do you think works better?
ggplot(plotdata, aes(x = BMI, y = PULSE, shape = ARM)) + geom_point()

# Can also use color or size.
ggplot(plotdata, aes(x = BMI, y = PULSE, color = ARM)) + geom_point()
ggplot(plotdata, aes(x = BMI, y = PULSE, size = ARM)) + geom_point()

# Scatter and Line --------------------------------------------------------

# Excercise Step 5.a
# Smoothed plot of PULSE by BMI with separate lines for each value of sex.
ggplot(plotdata, aes(x = BMI, y = PULSE, color = SEX)) + geom_smooth()

# Excercise Step 5.b
# Scatterplot of PULSE by AGEGR1, colored by SEX, and using a position jitter width of 0.10
ggplot(plotdata, aes(x = AGEGR1, y = PULSE, color = SEX)) +
  geom_point(size = 3, position = position_jitter(width = 0.10))

# Box, Bar, Histogram -------------------------------------------------------

# Excercise Step 5.a
# Horizontal bar chart showing counts on ARM.
ggplot(plotdata, aes(y = ARM)) + geom_bar(fill = 'pink')

# Excercise Step 5.b
ggplot(plotdata, aes(x = AGEGR1)) + geom_bar(color = 'green', fill = 'purple')

# Excercise Step 5.c
# Vertical stacked bar chart showing counts of ARM by SEX
ggplot(plotdata, aes(y = ARM, fill = SEX)) + geom_bar(position = position_dodge())

# Excercise Step 5.d
ggplot(plotdata, aes(x = ARM, fill = SEX)) + geom_bar(position = position_fill())

# Excercise Step 5.e
# Box plot on PULSE grouped by ARM.
ggplot(plotdata, aes(x = ARM, y = PULSE)) +
  geom_boxplot(outlier.shape = 5,
               varwidth = TRUE,
               color = "blue")


# Excercise Step 5.f
# Histogram of PULSE stacking by SEX using 10 bins.
ggplot(plotdata, aes(x = PULSE, fill = SEX)) + geom_histogram(bins = 10, color = "white")

# Excercise Step 5.g
# Density plot of PULSE with each SITEID having its own line type.
ggplot(plotdata, aes(x = PULSE, linetype = SITEID)) + geom_density()

# Excercise Step 6
#	Use the colors() function to list out all the acceptable color names that can be used in code.
colors()


