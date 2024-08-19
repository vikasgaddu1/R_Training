# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Troubleshoot_Me.R


# Setup -------------------------------------------------------------------
library(tidyverse)
library(janitor)

# 1
Paste("Random Sample Mean:", format(mean(runif(100)), digits = 3))


# 2
paste("Random Sample Mean:", format(mean(runif(100)), digits = 3)))


# 3
paste("Random Sample Mean:"  format(mean(runif(100)), digits = 3))

# 4
poste("Random Sample Mean:", format(mean(runif(100)), digits = 3))


# 5
mean(c(1,3,NA), rm.na=T)


# 6
mtcars_6 <-
  mtcars %>% 
  mutate(
    mpg_cat = if_else(mpg < 21, "Bad", "Good"),
    mpg_eval = case_when(mgp_cat == "Good" and 
                         cyl > 4 ~ "Excellent",
                         TRUE ~ "OK"))
  
# 7
mtcars_7 <-
  mtcars %>% 
  arrange(color, cyl, mpg) %>% 
  group_by(color, cyl) %>% 
  summarize(avempg = mean(mgp))

# 8
_mtcars_8 <-
  mtcars <%>
  filter(mpg < 20)

# 9
answer_9 <-
  mtcars %>% 
  mutate(case_when(mpg < 21 or cyl > 6 ~ "Bad",
            TRUE ~ "Good"))

# 10
demo <- tribble(
  ~patient, ~sex
  ,"1", "M"
  ,"2", "F"
  ,"1", "M"
)

pedata <- tribble(
  ~Patient, ~visit, ~other
  ,1, "S", "Normal"
  ,1, "B", "Normal"
  ,2, "B", "Normal"
  ,2, "1", "Normal"
  ,1, "1", "Abnormal"
  ,2, "S", "Abnormal"
)

inner_join(demo, pedata, by=patient)




