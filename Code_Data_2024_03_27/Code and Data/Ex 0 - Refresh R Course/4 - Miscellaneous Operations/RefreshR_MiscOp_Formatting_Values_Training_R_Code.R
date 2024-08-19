
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Misc Operations - Formatting Values

# Packages & Functions on Display:
# - {base   4.2.0}: format()
# - {scales 1.2.0}: number(), percent(), pvalue()
# - {fmtr   1.5.5}: fapply(), fattr(), value(), condition(), fcat(), formats()


# Setup -------------------------------------------------------------------

# Load Packages
library(fmtr)
library(scales)
library(tidyverse)


# Prepare Vectors
vec_num <- runif(n = 5) * 10000; print(vec_num)
vec_dts <- as.Date(runif(n = 5) * 10000, origin = "1970-01-01"); print(vec_dts)


# Formats - Base R --------------------------------------------------------

format(vec_num, digits = 2)
format(vec_num, digits = 5, big.mark = ",")

format(vec_dts, format = "%B")
format(vec_dts, format = "%B %d, %Y")


# Formats - Tidyverse Scales ----------------------------------------------

number(vec_num)
number(vec_num, accuracy = 0.001)
number(vec_num, accuracy = 0.001, prefix = "Number: ")
number(vec_num, suffix = " units")
number(vec_num, big.mark = ",")

percent(0.12345)
pvalue(c(0.075, 0.000012345))


# Formats - 'fmtr' --------------------------------------------------------

# Quickly apply complex formats to a vector
vec_num <- runif(10, min = 1, max = 10) %>% print()
vec_num %>% fapply("%1.1f")


# Or store the format in an attribute and apply it later
vec_num <-
  vec_num %>%
  fattr(format  = "%1.2f", width   = 5, justify = "left")

vec_num
vec_num %>% fapply()


# User defined formats
my_fmts <- c(A = "Apple", C = "Cranberry")

LETTERS[1:5]
LETTERS[1:5] %>% fapply(my_fmts)



# Complex user defined formats, conditions are checked in order defined
my_fmts_2 <- value(
  condition(x == "A",              "Ant"),
  condition(x %in% c("C", "D"),    "Other"),
  condition(x %>% str_detect("Z"), "Zebra"),
  condition(x %>% is.character(),  NA)
)

LETTERS
LETTERS %>% fapply(my_fmts_2)


# Using a format catalog
df_adslvs

my_fmts_3 <- fcat(
  sex = function(x) str_to_upper(x),
  age = function(x) paste("Age:", x),
  base_temp = "%1.2f"
)

formats(df_adslvs) <- my_fmts_3

df_adslvs %>% select(sex, age, base_temp)
df_adslvs %>% select(sex, age, base_temp) %>% fdata()


# Documentation -----------------------------------------------------------

# Vignettes
vignette("fmtr")

# Help Pages
help("format")
help("number", package = "scales")

# Website References
# - https://scales.r-lib.org/
# - https://fmtr.r-sassy.org/

# -------------------------------------------------------------------------
