# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key


# Basic String Operations -------------------------------------------------

library(tidyverse)
library(haven)
library(scales)

# Exercise Step 2
# Starting with the vectors, TrtName <- "Trt",  TrtList <- c("A","B","C"),
# SiteName <- "Site", SiteList <- 12:14. Create the following vectors.
TrtName <- "Trt"
TrtList <- c("A","B","C")
SiteName <- "Site"
SiteList <- 12:14

# Exercise Step 2a
#  a.  [1] "Trt A : Site ---12" "Trt B : Site ---13" "Trt C : Site ---14"
str_c(
  str_c(TrtName, TrtList, sep=" "),
  str_c(SiteName, SiteList, sep = str_c(" ", str_dup("-", 3))),
  sep=" : ")

# Exercise Step 2b
#  b.  [1] "Site: 12 with A" "Site: 13 with B" "Site: 14 with C"
str_c(
  str_c(SiteName, SiteList,sep = ": "),
  TrtList, sep = " with "
)

# Exercise Step 2c
#  c.  [1] "Site: 12 with A and Site: 13 with B and Site: 14 with C"
str_flatten(
  str_c(
    str_c(SiteName, SiteList,sep = ": "),
    TrtList, sep = " with "
  ),
  collapse = " and "
)

# Exercise Step 3
# Starting with the vector [1] "Site: 12 with A, Site: 13 with B, Site: 14 with C".
# Create the vector, "12 with A, " "13 with B, " "14 with C".
mystr <- "Site: 12 with A, Site: 13 with B, Site: 14 with C"

myvecs <- str_split(mystr, pattern = "Site: ") %>% unlist()

myvecs[2:4]


# String Operations pt 1 --------------------------------------------------

# Exercise Step 2
# Run the code below to define some variables.
cost = 123.56
retail = 495.25
margin = (retail - cost)
percent_markup = margin / cost

# Use these variables with some additional text, and the functions `str_glue()`
# and the `"{}" `function, to create the following sentence.
# Each pill pack costs 123.56 and is sold for 495.25 resulting in a % markup of 3.00817416639689.
str_glue(
  "Each pill pack costs {cost} and is sold for {retail} resulting in a % markup of {percent_markup}."
)

# String Operations pt 2 --------------------------------------------------

# Exercise Step 3
# Create a variable named sentence which is equal to
# "The quick brown fox jumps over the lazy dog.".
sentence <- "The quick brown fox jumps over the lazy dog."

# Exercise Step 4
# find beginning and ending position of the string "lazy"
lazy <- str_locate(sentence, "lazy")

# Exercise Step 5
# Switch the words fox around with dog.
new_sentence <- str_replace(sentence, "dog", "fox") %>%
  str_replace("fox", "dog")
new_sentence

# Exercise Step 6
# Remove the word lazy from the sentence in the previous step. Make sure there
# is only one space between every word.
new_sentence <-
  new_sentence %>%
  str_remove("lazy") %>%
  str_squish()

# Subsets and Formats -----------------------------------------------------

# Exercise Step 2
# We created a string earlier that said that  the pill pack costs, it's price and the
# resulting markup. However, it wasn't very pretty. Use the new functions,
# dollar() and percent(), to make it look like.
# Each pill pack costs $123.56 and is sold for $495.25 resulting in a % markup of 300.8%
# Use the functions str_glue(), dollar(), and percent().
context <- str_glue(
  "Each pill pack costs {dollar(cost, accuracy = .01)} and is sold for {dollar(cost, accuracy = .01)} resulting in a % markup of {percent(percent_markup, accuracy = .1)}."
)
context

# Exercise Step 3
# Read in the data sets listed below using the rules associated with each.
# Exercise Step 3.a
# abc_crf_aesr:
#  - Keep only the variables: `STUDYID`, `SUBJECT`, `AETERM`, `HLGT_TER`,
#    `HLT_TERM`, `PT_TERM`, `SOC_TERM`.
#  - Keep only records that contain the word `"skin"` (case insensitive)
#    in any of the variables: `AETERM`,`HLGT_TER`, `HLT_TERM`, `PT_TERM`, `SOC_TERM`.
abc_crf_aesr <-
  read_sas(
    'abc_crf_aesr.sas7bdat',
    col_select = c(STUDYID, SUBJECT, AETERM, HLGT_TER, HLT_TERM, PT_TERM, SOC_TERM)
  ) %>%
  filter(
    str_detect(tolower(AETERM), "skin") |
      str_detect(tolower(HLGT_TER), "skin") |
      str_detect(tolower(HLT_TERM), "skin") |
      str_detect(tolower(PT_TERM), "skin") |
      str_detect(tolower(SOC_TERM), "skin")
  )

# Exercise Step 3.b
# bbc_crf_aesr:
#  - Keep only the variables: `STUDYID`, `SUBJECT`, `AETERM`, `HLGT_TER`,
#    `HLT_TERM`, `PT_TERM`, `SOC_TERM`.
#  - Keep only records that contain the word `"skin"` (case insensitive)
#    in any of the variables: `AETERM`, `HLGT_TER`, `HLT_TERM`, `PT_TERM`, `SOC_TERM`.
bbc_crf_aesr <-
  read_sas(
    'bbc_crf_aesr.sas7bdat',
    col_select = c(STUDYID, SUBJECT, AETERM, HLGT_TER, HLT_TERM, PT_TERM, SOC_TERM)
  ) %>%
  filter(
    str_detect(tolower(AETERM), "skin") |
      str_detect(tolower(HLGT_TER), "skin") |
      str_detect(tolower(HLT_TERM), "skin") |
      str_detect(tolower(PT_TERM), "skin") |
      str_detect(tolower(SOC_TERM), "skin")
  )

# Exercise Step 3.c
# abc_crf_cm:
#  - Keep only the variables: `STUDYID`, `SUBJECT`, `DRUGTERM`.
#  - Keep only the records that contain the word `"lidex"` (case insensitive)
#    in the variable `DRUGTERM`.
#  - Keep only distinct values for `SUBJECT` and `DRUGTERM`.
abc_crf_cm <-
  read_sas('abc_crf_cm.sas7bdat',
           col_select = c(STUDYID, SUBJECT, DRUGTERM))  %>%
  filter(str_detect(tolower(DRUGTERM), "lidex")) %>%
  distinct(SUBJECT, DRUGTERM)

# Exercise Step 3.d
# bbc_crf_cm:
#  - Keep only the variables: `STUDYID`, `SUBJECT`, `DRUGTERM`.
#  - Keep only the records that contain the word `"lidex"` (case insensitive)
#    in the variable `DRUGTERM`.
#  - Keep only distinct values for `SUBJECT` and `DRUGTERM`.
bbc_crf_cm <-
  read_sas('bbc_crf_cm.sas7bdat',
           col_select = c(STUDYID, SUBJECT, DRUGTERM)) %>%
  filter(str_detect(tolower(DRUGTERM), "lidex")) %>%
  distinct(SUBJECT, DRUGTERM)


# Strings in a Pipe -------------------------------------------------------

# Exercise Step 3a
# Combine all of these data sets as appropriate.
# a.   Stack the `aesr` data sets for the two studies
aesr_skin <-
  bind_rows(abc_crf_aesr, bbc_crf_aesr)

# Exercise Step 3a
# b.   Stack the `cm` data sets for both studies
cm_skin <-
  bind_rows(abc_crf_cm, bbc_crf_cm) %>%
  filter(str_detect(tolower(DRUGTERM), "lidex")) %>%
  distinct(SUBJECT, DRUGTERM)

# Exercise Step 4
# Left join the stacked `ae` and stacked `cm` data by patient.
# - If `DRUGTERM` is equal to `NA`, replace with `"nothing with Lidex"`.
# - Create a variable named `narrative` using the variables `SUBJECT`,
#  `DRUGTERM`, and `AETERM` that looks like the console output below.
#  It should have 22 records.
# - Save to a data frame `(tibble)`.
skin_lidex <-
  left_join(aesr_skin, cm_skin, by = c("SUBJECT" = "SUBJECT")) %>%
  mutate(DRUGTERM = ifelse(is.na(DRUGTERM), "nothing with Lidex", DRUGTERM)) %>%
  mutate(narrative =
    str_to_sentence(
      str_glue("Subject {SUBJECT} took {DRUGTERM} and experienced {AETERM}.")
  )) %>%
  select(narrative) %>%
  print()

# Exercise Step 5
# Using the `tibble` you just created in the previous step, and the `pull()`,
# `str_wrap()`, and `cat()` functions, create output to the console that
# looks like the following (output abbreviated in example below).
# Note: using "\\n" in the `cat()` function creates a line return.
skin_lidex %>%
  pull(narrative) %>%
  str_wrap(width = 25,
           indent = 3,
           exdent = 5) %>%
  cat(sep = "\n \n")


