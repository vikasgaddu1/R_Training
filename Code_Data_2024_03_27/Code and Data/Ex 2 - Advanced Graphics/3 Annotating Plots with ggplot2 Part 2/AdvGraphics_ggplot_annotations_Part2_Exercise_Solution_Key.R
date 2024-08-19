# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(haven)
library(janitor)

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

data_summary <-
  plotdata %>%
  tabyl(ARM) %>%
  adorn_pct_formatting() %>%
  mutate(n_pct = paste0(n, "(", percent,")")) %>%
  print()

ggplot(data_summary, aes(x = ARM, y = n, label=n_pct)) +
  geom_hline(yintercept=22, color='red', size=1.5) +
  geom_col(fill='black') +
  geom_text(size = 5, color='white', vjust = 1.25) +
  labs(title = "Figure 1",
       subtitle = "Subject Counts by ARM",
       x = "Treatment Arm",
       y = "# of Subjects",
       caption = "Note: Need at least 22 subjects to be a valid trial.") +
  scale_y_continuous(breaks = scales::breaks_width(4)) +
  theme(plot.title        = element_text(face = "bold", color = "black", size=20, hjust=.5),
        plot.subtitle     = element_text(face = "bold", color = "black" , size=15),
        plot.caption      = element_text(face = "italic", color = "black", size=15, hjust=0),
        axis.text.x       = element_text(face = "bold", size = 15, angle=45),
        axis.title.x      = element_text(face = "bold", size=20),
        axis.title.y      = element_text(face = "bold", size=20, angle=270),
        axis.text.y       = element_text(face="bold", size = 15),
        panel.background  = element_rect(fill = "lightblue")
  )



ggplot(plotdata, aes(x=TEMP, y=PULSE)) +
  geom_rect(aes(xmin = mean(TEMP, na.rm=TRUE) - 2*sd(TEMP, na.rm=TRUE),
                xmax = mean(TEMP, na.rm=TRUE) + 2*sd(TEMP, na.rm=TRUE),
                ymin = mean(PULSE, na.rm=TRUE) - 2*sd(PULSE, na.rm=TRUE),
                ymax = mean(PULSE, na.rm=TRUE) + 2*sd(PULSE, na.rm=TRUE)),
            fill = "pink") +
geom_point()

outliers <-
  plotdata %>%
  filter(PULSE < mean(PULSE, na.rm=TRUE) - 2*sd(PULSE, na.rm=TRUE) |
         PULSE > mean(PULSE, na.rm=TRUE) + 2*sd(PULSE, na.rm=TRUE) |
           TEMP < mean(TEMP, na.rm=TRUE) - 2*sd(TEMP, na.rm=TRUE) |
           TEMP > mean(TEMP, na.rm=TRUE) + 2*sd(TEMP, na.rm=TRUE))

figure_2 <-
ggplot(plotdata, aes(x=TEMP, y=PULSE, label = SUBJID)) +
  geom_rect(aes(xmin = mean(TEMP, na.rm=TRUE) - 2*sd(TEMP, na.rm=TRUE),
                xmax = mean(TEMP, na.rm=TRUE) + 2*sd(TEMP, na.rm=TRUE),
                ymin = mean(PULSE, na.rm=TRUE) - 2*sd(PULSE, na.rm=TRUE),
                ymax = mean(PULSE, na.rm=TRUE) + 2*sd(PULSE, na.rm=TRUE)),
            fill = "pink") +
  geom_point() +
  geom_text(data = outliers , color='red', size = 4, fontface = "bold", hjust=1.25) +
  annotate(geom = "label",
           x = 39.4, y = 100, color='white', fill="blue", size=4, fontface='bold',
           label = "Outliers are points\n outside of\nmean +- 2*(standard deviation)") +
    scale_x_continuous(breaks = scales::breaks_width(.5)) +
  scale_y_continuous(breaks = scales::breaks_width(5)) +
  labs(title     = "Figure 2",
       subtitle  = "Outliers of Pulse and Temperature (C)",
       caption   = "Outliers are marked by a red subject # to the left of the data point",
       x         = "Temperature",
       y         = "Pulse") +
  theme(plot.title        = element_text(face = "bold", color = "black", size=20, hjust=.5),
        plot.subtitle     = element_text(face = "bold", color = "black" , size=15),
        plot.caption      = element_text(face = "italic", color = "black", size=15, hjust=0),
        axis.text.x       = element_text(face = "bold", size = 10),
        axis.title.x      = element_text(face = "bold", size=20),
        axis.title.y      = element_text(face = "bold", size=20),
        axis.text.y       = element_text(face="bold", size = 10),
        panel.background  = element_rect(fill = "lightblue"))

figure_2

ggsave(filename = "figure_2.jpeg", plot = figure_2, scale = 2)


