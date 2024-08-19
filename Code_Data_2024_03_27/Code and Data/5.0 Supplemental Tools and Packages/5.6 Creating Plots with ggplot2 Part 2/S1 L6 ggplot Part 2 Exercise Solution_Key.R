# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Setup -------------------------------------------------------------------
# Exercise Step 3
library(tidyverse)
library(haven)
library(janitor)


# Exericse Step 4
# Create a data frame following the instructions below.
#
# a.	adsl.sas7bdat
# i.	select the variables SUBJID, SITEID, ARM, AGEGR1, SEX
# ii.	filter out ARM = "SCREEN FAILURES" from the data.
# iii.	Make ARM an ordered factor with the levels in the following order: "ARM A", "ARM B", "ARM C", "ARM D".
# iv.	Make AGEGR1 an ordered factor with the levels in the following order: "18-29 years", "30-39 years", "40-49 years", "50-65 years", "> 65 years".
# b.	advs.sas7bdat
# i.	select the variables SUBJID, SITEID, AVISITN, PARAMCD, AVAL.
# ii.	filter keeping only if PARAMCD = "BMI" or ((PARAMCD = "PULSE" or PARAMCD="TEMP") and AVISITN = 0).
# iii.	Pivot the data wider getting names from PARAMCD and values from AVAL. Get the id columns from SUBJID and SITEID.
# c.	Perform an inner join on the above data frames to combine them into one data frame named plotdata.  Note: should have 85 records and 7 variables.
adsl <- read_sas("data/abc_adam_adsl.sas7bdat") %>%
  select(SUBJID, SITEID, ARM, AGEGR1, SEX) %>%
  filter(ARM != "SCREEN FAILURE") %>%
  mutate(ARM = factor(ARM, levels = c("ARM A", "ARM B", "ARM C", "ARM D"), ordered = TRUE),
         AGEGR1 = factor(AGEGR1, levels = c("18-29 years", "30-39 years",
                                            "40-49 years", "50-65 years", ">65 years"), ordered = TRUE))

advs <- read_sas("data/abc_adam_advs.sas7bdat") %>%
  select(SUBJID, SITEID, AVISITN, PARAMCD, AVAL) %>%
  filter(PARAMCD == "BMI" | ((PARAMCD == "PULSE" | PARAMCD == "TEMP") & AVISITN == 0)) %>%
  pivot_wider(id_cols = c(SUBJID, SITEID),
              names_from = PARAMCD,
              values_from = AVAL,
              names_repair = "universal")

plotdata <-
  inner_join(adsl, advs)


# Multiple Geometries -----------------------------------------------------

# Exercise Step 5.a
# Vertical bar chart showing counts on ARM. The bars should be filled with pink with a black
# outline. Draw a dark green, gold, and dark red horizontal reference line of size 1.5 at the values
# of 15, 20, and 22 respectfully.
ggplot(plotdata, aes(x = ARM)) +
  geom_bar(fill = 'tan', color = 'black') +
  geom_hline(yintercept = c(15, 20, 22), size = 1.5, color = c('darkgreen', 'gold', 'darkred'))

# Verify the counts in the bar chart are correct by using the tabyl function from the
# janitor package to produce counts.
plotdata %>%
  tabyl(ARM)

# Exercise Step 5.b
# Now change to a horizontal bar chart with the reference lines behind the bars.
ggplot(plotdata, aes(y = ARM)) +
  geom_vline(xintercept = c(15, 20, 22), size = 1.5, color = c('darkgreen', 'gold', 'darkred')) +
  geom_bar(fill = 'tan', color = 'black')

# Plot Facets -------------------------------------------------------------

# Exercise Step 5.a
# Produce the plot below with a `facet` variable of `AGEGR1`.
ggplot(plotdata, aes(x = ARM)) +
  geom_bar(fill = 'black', color = 'black') +
  facet_grid(cols = vars(AGEGR1))

# Exercise Step 5.d
# Switch to a grid of bar charts by introducing a row variable of SEX.
# Be sure to have the SEX values displayed on the left hand side.
ggplot(plotdata, aes(x = ARM)) +
  geom_bar(fill = 'black', color = 'black') +
  facet_grid(cols = vars(AGEGR1), rows = vars(SEX), switch = "y")


# Exercise Step 5.e
# Now compare to stacking the bars by SEX.
ggplot(plotdata, aes(x = ARM, fill = SEX)) +
  geom_bar(color = 'black') +
  facet_grid(cols = vars(AGEGR1))


# Using Summary Data ------------------------------------------------------

# Exercise Step 5
# Create a new data frame that is a summary of plotdata calculating n, mean, standard deviation, minimum,
# median, and maximum of BMI by ARM. The resulting data frame should look like the one below.
plotdata_summary_BMIbyARM <-
  plotdata %>%
  group_by(ARM) %>%
  summarise(n   = n(),
            avg = mean(BMI, na.rm = TRUE),
            std = sd(BMI, na.rm = TRUE),
            min = min(BMI, na.rm = TRUE),
            med = median(BMI, na.rm = TRUE),
            max = max(BMI, na.rm = TRUE)) %>%
  print()


# Exercise Step 5.a
# Produce a bar chart showing the mean value of BMI for each ARM.
ggplot(plotdata_summary_BMIbyARM, aes(x = ARM, y = avg)) +
  geom_col(fill = 'orange')


# Exercise Step 5.b
# Using a combination of geom_point(), geom_line(), and geom_errorbar(),
# create the plot below showing average BMI with lines representing plus or
# minus 1 standard deviation.
ggplot(plotdata_summary_BMIbyARM, aes(x = ARM, y = avg)) +
  geom_point(size = 3) +
  geom_line(aes(group = 1)) +
  geom_errorbar(aes(ymin = avg - std, ymax = avg + std), width = 0.05)


# Using Summary Functions -------------------------------------------------

# Exercise Step 5.a
# A scatter plot of TEMP by PULSE with a smoothed line overlayed.
ggplot(plotdata, aes(x = TEMP, y = PULSE)) +
  geom_point() +
  geom_smooth()


# Exercise Step 5.b
# Add a pink shaded area to the plot that is 2 standard deviations wide from the mean of TEMP and covers the
# whole vertical space.
# Note: aesthetics that involve calculations need to be in the aes() function.
# Note: don't forget the na.rm=TRUE when functions need to ignore missing values.
ggplot(plotdata, aes(x = TEMP, y = PULSE)) +
  geom_rect(aes(xmin = mean(TEMP, na.rm = TRUE) - 2*sd(TEMP, na.rm = TRUE),
                xmax = mean(TEMP, na.rm = TRUE) + 2*sd(TEMP, na.rm = TRUE)),
            ymin = -Inf, ymax = Inf, fill = "pink") +
  geom_point() +
  geom_smooth()

# Exercise Step 5.c
# Now modify the pink shaded area to the plot so it is 2 standard deviations wide from the mean of
# TEMP and 2 standard deviations tall from the mean of PULSE.
ggplot(plotdata, aes(x = TEMP, y = PULSE)) +
  geom_rect(aes(xmin = mean(TEMP, na.rm = TRUE) - 2*sd(TEMP, na.rm = TRUE),
                xmax = mean(TEMP, na.rm = TRUE) + 2*sd(TEMP, na.rm = TRUE),
                ymin = mean(PULSE, na.rm = TRUE) - 2*sd(PULSE, na.rm = TRUE),
                ymax = mean(PULSE, na.rm = TRUE) + 2*sd(PULSE, na.rm = TRUE)),
            fill = "pink") +
  geom_point() +
  geom_smooth()


# Exercise Step 5.d
# Create a grid of these plots based on ARM and SEX as shown below.
ggplot(plotdata, aes(x = TEMP, y = PULSE)) +
  geom_rect(aes(xmin = mean(TEMP, na.rm = TRUE) - 2*sd(TEMP, na.rm = TRUE),
                xmax = mean(TEMP, na.rm = TRUE) + 2*sd(TEMP, na.rm = TRUE),
                ymin = mean(PULSE, na.rm = TRUE) - 2*sd(PULSE, na.rm = TRUE),
                ymax = mean(PULSE, na.rm = TRUE) + 2*sd(PULSE, na.rm = TRUE)),
            fill = "pink") +
  geom_point(size = 3) +
  geom_smooth() +
  facet_grid(cols = vars(SEX), rows = vars(ARM), switch = "y")


