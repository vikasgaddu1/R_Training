# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(haven)


# 3)	Create a data frame following the instructions below.
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


# Vertical bar chart showing counts on ARM. The bars should be filled with pink with a black
# outline. Draw a dark green, gold, and dark red horizontal reference line of size 1.5 at the values
# of 15, 20, and 22 respectfully.
ggplot(plotdata, aes(x=ARM, fill=SEX)) +
  geom_bar(color='black')

ggplot(plotdata, aes(x=ARM, fill=SEX)) +
  geom_bar(color='black') +
  labs(title = "Study ABC\nSubject Counts",
       subtitle = "Treatment ARM by Gender",
       caption = "Note: from Study ABC",
       x = "Treatment ARM",
       y = "# of Subjects",
       fill = "Gender",
       tag = "Chart Tag") +
  theme(plot.title    = element_text(hjust=0.5),
        plot.subtitle = element_text(hjust=0.5),
        legend.position = c(.1, .99)) +
  scale_y_continuous(breaks = scales::breaks_width(6)) +
  scale_fill_discrete(labels = c("M"="Male", "F"="Female"))


summary(plotdata)
# Now produce a scatter plot of TEMP by PULSE with a smoothed line overlayed.
ggplot(plotdata, aes(x=BMI, y=PULSE, color = AGEGR1)) +
  geom_point()

ggplot(plotdata, aes(x=BMI, y=PULSE, color = AGEGR1)) +
  geom_point() +
  lims(x = c(15, 50),
       y = c(50, 120),
       color = c("30-39 years", "40-49 years", "50-65 years"))


ggplot(plotdata, aes(x=BMI, y=PULSE, color = AGEGR1)) +
  geom_point(size=3) +
  lims(x = c(15, 50),
       y = c(50, 120),
       color = c("30-39 years", "40-49 years", "50-65 years")) +
  scale_x_continuous(name = "Body Mass Index",
                     breaks = scales::breaks_width(5)) +
  scale_y_continuous(name = "Pulse (bpm)",
                     breaks = scales::breaks_width(10)) +
  labs(title = "Pulse by Body Mass Index",
       subtitle = "Colored by Age Group")


ggplot(plotdata, aes(x=BMI, y=PULSE, color = AGEGR1)) +
  geom_point(size=3) +
  lims(x = c(15, 50),
       y = c(50, 120),
       color = c("30-39 years", "40-49 years", "50-65 years")) +
  scale_x_continuous(name = "Body Mass Index",
                     breaks = scales::breaks_width(5)) +
  scale_y_continuous(name = "Pulse (bpm)",
                     breaks = scales::breaks_width(10)) +
  labs(title = "Pulse by Body Mass Index",
       subtitle = "Colored by Age Group") +
  scale_color_viridis_d(begin = 0.10, end = 0.90)


# Now produce a scatter plot of TEMP by PULSE with a smoothed line overlayed.
ggplot(plotdata, aes(x = BMI, y = TEMP, color = PULSE)) +
  geom_point(size=3) +
  labs(title = "Study ABC - Temp by Body Mass Index",
       subtitle = "Colored by Pulse",
       x = "Body Mass Index",
       y = "Temperature (C)",
       color = "Pulse") +
  guides(color = guide_legend(nrow = 1, ncol = 5)) +
  theme(plot.title    = element_text(hjust=0.5),
        plot.subtitle = element_text(hjust=0.5),
        legend.position = c(.20, .90)) +
  scale_color_continuous(type = "gradient", low = "red", high = "yellow")


