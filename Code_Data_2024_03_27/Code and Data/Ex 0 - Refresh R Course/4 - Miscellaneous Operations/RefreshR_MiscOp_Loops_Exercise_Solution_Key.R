# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 2
varlabels <- tribble(
  ~varname, ~varlabel,
  "subjid", "Subject ID",
  "trta", "Treatment ARM",
  "sex", "Sex of Subject",
  "age", "Age of Subject"
)

dm <- tribble(
  ~subjid, ~trta, ~sex, ~age,
  1, "ARM A", "M", 26,
  2, "ARM B", "F", 41
)

# Examine structure of dm data frame before applying any labels.
str(dm)

# Manually apply a label to a variable on the dm data frame.
attr(dm[["subjid"]], "label") <- "Test Subject Label"

# Examine structure of dm data frame after applying one label as a test.
str(dm)

# Loop over the variables on the dm data frame and print them.
for (vn in names(dm)) {
  print(vn)
}

# Loop over the variable labels from the varlabel data frame for each 
# variable in the dm data frame and print them.
for (vn in names(dm)) {
  print(varlabels$varlabel[varlabels$varname == vn])
}


# Exercise Step 3
for (vn in names(dm)) {
  attr(dm[[vn]], "label") <-
    varlabels$varlabel[varlabels$varname == vn]
}

# Examine structure of dm data frame after applying all labels.
str(dm)

