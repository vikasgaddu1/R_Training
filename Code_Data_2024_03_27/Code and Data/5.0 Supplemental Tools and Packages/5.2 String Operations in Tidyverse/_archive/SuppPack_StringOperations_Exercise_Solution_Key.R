# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(haven)
library(scales)

# Exercise Step 4
sentence <- "The quick brown fox jumps over the lazy dog."

# Exercise Step 5
# find beginning and ending position of the string "lazy"
lazy <- str_locate(sentence, "lazy")

# Exercise Step 6
# Switch the words fox around with dog.
new_sentence <- str_replace(sentence, "dog", "fox") %>%
  str_replace("fox", "dog")
new_sentence

# Exercise Step 7
new_sentence <-
  new_sentence %>%
  str_remove("lazy")

# Exercise Step 8
# From those variables and some constant text that you insert create a variable with the following sentence.
cost = 123.56
retail = 495.25
margin = (retail - cost)
percent_markup = margin / cost

# Each pill pack costs $123.56 and is sold for $495.25 resulting in a % markup of 300.8%
# Use the functions str_glue(), dollar(), and percent().
context <- str_glue(
  "Each pill pack costs ",
  dollar(cost, accuracy = .01),
  " and is sold for ",
  dollar(cost, accuracy = .01),
  " resulting in a % markup of ",
  percent(percent_markup, accuracy = .1),
  "."
)
context


# Exercise Step 9
# Read in the data sets listed below using the rules associated with each.
# Exercise Step 9.a
abc_crf_aesr <-
  read_sas(
    'abc_crf_aesr.sas7bdat',
    col_select = c(STUDYID, SUBJECT, AETERM, HLGT_TER, HLT_TERM, PT_TERM, SOC_TERM)
  )

# Exercise Step 9.b
bbc_crf_aesr <-
  read_sas(
    'bbc_crf_aesr.sas7bdat',
    col_select = c(STUDYID, SUBJECT, AETERM, HLGT_TER, HLT_TERM, PT_TERM, SOC_TERM)
  )

# Exercise Step 9.c
abc_crf_cm <-
  read_sas('abc_crf_cm.sas7bdat',
           col_select = c(STUDYID, SUBJECT, DRUGTERM))

# Exercise Step 9.d
bbc_crf_cm <-
  read_sas('bbc_crf_cm.sas7bdat',
           col_select = c(STUDYID, SUBJECT, DRUGTERM))

# Exercise Step 9.e
aesr_skin <-
  bind_rows(abc_crf_aesr, bbc_crf_aesr) %>%
  filter(
    str_detect(tolower(AETERM), "skin") |
      str_detect(tolower(HLGT_TER), "skin") |
      str_detect(tolower(HLT_TERM), "skin") |
      str_detect(tolower(PT_TERM), "skin") |
      str_detect(tolower(SOC_TERM), "skin")
  )



cm_skin <-
  bind_rows(abc_crf_cm, bbc_crf_cm) %>%
  filter(str_detect(tolower(DRUGTERM), "lidex")) %>%
  distinct(SUBJECT, DRUGTERM)


skin_lidex <-
  left_join(aesr_skin, cm_skin, by = c("SUBJECT" = "SUBJECT")) %>%
  mutate(DRUGTERM = ifelse(is.na(DRUGTERM), "nothing with Lidex", DRUGTERM)) %>%
  mutate(narrative = 
    str_to_sentence(
      str_glue("Subject {SUBJECT} took {DRUGTERM} and experienced {AETERM}.")
  )) %>%
  select(narrative) %>%
  print()

# Exercise Step 10
skin_lidex %>%
  pull(narrative) %>%
  str_wrap(width = 25,
           indent = 3,
           exdent = 5) %>%
  cat(sep = "\n \n")


