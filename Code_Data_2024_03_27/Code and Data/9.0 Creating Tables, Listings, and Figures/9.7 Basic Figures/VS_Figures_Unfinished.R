# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(haven)
library(janitor)
library(reporter)
library(logr)
library(tidylog, warn.conflicts = FALSE)

# Attach loggers
options("tidylog.display" = list(log_print), 
        "logr.on" = TRUE,
        "logr.notes" = FALSE)

# Open Log
log_path <- log_open("VS_Figures")


# Prepare Data ------------------------------------------------------------


put("Set data directory")
data_dir <- "data" %>% put()

put("Read and filter ADSL dataset")
adsl <- read_sas(file.path(data_dir, "abc_adam_adsl.sas7bdat")) %>% 
  select(SUBJID, SITEID, ARM, AGEGR1, SEX) %>%
  filter(ARM != "SCREEN FAILURE") %>% 
  mutate(ARM = factor(ARM, levels = c("ARM A", "ARM B", "ARM C", "ARM D"), 
                      ordered = TRUE),
         AGEGR1 = factor(AGEGR1, levels = c("18-29 years", "30-39 years", 
                                            "40-49 years", "50-65 years", 
                                            ">65 years"), ordered = TRUE)) %>% 
  put()

put("Read and filter ADVS dataset")
advs <- read_sas(file.path(data_dir, "abc_adam_advs.sas7bdat")) %>% 
  select(SUBJID, SITEID, AVISITN, PARAMCD, AVAL) %>% 
  filter(PARAMCD == "BMI" | ((PARAMCD == "PULSE" | PARAMCD == "TEMP") & AVISITN == 0)) %>%
  pivot_wider(id_cols = c(SUBJID, SITEID),
              names_from = PARAMCD,
              values_from = AVAL,
              names_repair = "universal") %>% put()

put("Join ADSL and ADVS")
plotdata <-
  inner_join(adsl, advs) %>% 
  put()


# Create bar chart for ARMs -----------------------------------------------



put("Prepare data for bar chart")
data_summary <-
  plotdata %>%
  tabyl(ARM) %>% 
  adorn_pct_formatting() %>%
  mutate(n_pct = paste0(n, "(", percent,")")) %>% 
  print()

put("Create bar chart")
figure_1 <- ggplot(data_summary, aes(x = ARM, y = n, label=n_pct)) +
  geom_hline(yintercept=22, color='red', size=1.5) +
  geom_col(fill='pink') +
  geom_text(size = 5, color='white', vjust = 1.25) +
  labs(x = "Treatment Arm", 
       y = "# of Subjects") +
  scale_y_continuous(breaks = scales::breaks_width(4)) +
  theme(axis.title.x      = element_text(face = "bold", size=10),
        axis.title.y      = element_text(face = "bold", size=10),
        panel.background  = element_rect(fill = "lightblue")
  )


# Create scatter plot for PULSE/TEMP outliers -----------------------------



put("Prepare outlier data")
outliers <-
  plotdata %>% 
  filter(PULSE < mean(PULSE, na.rm=TRUE) - 2*sd(PULSE, na.rm=TRUE) | 
           PULSE > mean(PULSE, na.rm=TRUE) + 2*sd(PULSE, na.rm=TRUE) |   
           TEMP < mean(TEMP, na.rm=TRUE) - 2*sd(TEMP, na.rm=TRUE) | 
           TEMP > mean(TEMP, na.rm=TRUE) + 2*sd(TEMP, na.rm=TRUE))

put("Create scatter plot for temp and pulse")
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
           x = 39, y = 100, color='white', fill="blue", size=4, fontface='bold',
           label = "Outliers are points\n outside of\nmean +- 2*(standard deviation)") +
  scale_x_continuous(breaks = scales::breaks_width(.5)) +
  scale_y_continuous(breaks = scales::breaks_width(5)) +
  labs(x         = "Temperature",
       y         = "Pulse") +
  theme(axis.title.x      = element_text(face = "bold", size=10),
        axis.title.y      = element_text(face = "bold", size=10),
        panel.background  = element_rect(fill = "lightblue"))


# Create report -----------------------------------------------------------



put("Create VS report with two figures")




## Write report code here ##







write_report(rpt) %>% put()



# Clean up ----------------------------------------------------------------


log_close()

options("tidylog.display" = NULL)



