# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Troubleshoot_Me.R


# Setup -------------------------------------------------------------------
library(tidyverse)
library(janitor)

# 1
# There is no paste function with a capital P
paste("Random Sample Mean:", format(mean(runif(100)), digits = 3))


# 2
# Too many parantheses at end
paste("Random Sample Mean:", format(mean(runif(100)), digits = 3))


# 3
# Missing comma between paste function parameters.
paste("Random Sample Mean:",  format(mean(runif(100)), digits = 3))

# 4
# The paste function was misspelled as poste.
paste("Random Sample Mean:", format(mean(runif(100)), digits = 3))


# 5
# suggested spaces around the equal sign. na.rm was misspelled as rm.na.
mean(c(1,3,NA), na.rm = T)


# 6
# need to use ampersand and not the word and.
# mpg is misspelled in the case_when function.
mtcars_6 <-
  mtcars %>% 
  mutate(
    mpg_cat = if_else(mpg < 21, "Bad", "Good"),
    mpg_eval = case_when(mpg_cat == "Good" & 
                         cyl > 4 ~ "Excellent",
                         TRUE ~ "OK"))
  
# 7
# there is no variable named color in the mtcars data frame.
# mpg was misspelled in the summarize function.
mtcars_7 <-
  mtcars %>% 
  arrange(cyl, mpg) %>% 
  group_by(cyl) %>% 
  summarize(avempg = mean(mpg))

# 8
# cannot have a leading underscore in an R object name.
# tidyverse pipe was incorrectly defined.
mtcars_8 <-
  mtcars %>% 
  filter(mpg < 20)

# 9
# need to use a pipe character instead of the word or.
answer_9 <-
  mtcars %>% 
  mutate(case_when(mpg < 21 | cyl > 6 ~ "Bad",
            TRUE ~ "Good"))

# 10
# the variable patient has inconsistent types.
# the variable patient should be in quotes in the inner_join function.
# bonus find: there is a cartesian product/many to many merge 
#            situation in the data that needs investigating.
demo <- tribble(
  ~patient, ~sex
  ,1, "M"
  ,2, "F"
  ,1, "M"
)

pedata <- tribble(
  ~patient, ~visit, ~other
  ,1, "S", "Normal"
  ,1, "B", "Normal"
  ,2, "B", "Normal"
  ,2, "1", "Normal"
  ,1, "1", "Abnormal"
  ,2, "S", "Abnormal"
)

inner_join(demo, pedata, by="patient")




