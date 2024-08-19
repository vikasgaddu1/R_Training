
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Working with Data - Subset and Filter

# Packages & Functions on Display:
# - {readr 2.1.2}:  read_rds()
#
# - {base  4.2.0}:  [ ], [[ ]], subset(), unique(), head(), tail(), sample(),
#                  nrow(), min(), max()
#
# - {dplyr 1.0.8}:  pull(), select(), slice(), filter(), distinct(), slice_head(),
#                  slice_tail(), slice_min(), slice_max(), slice_sample(), last_col(),
#                  everything(), ends_with(), starts_with(), contains(), where()

# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)

# Load Data
df_vs <- read_rds("data/adslvs.rds")


# Subset Columns ----------------------------------------------------------

# Base R
df_vs$arm
df_vs["arm"]
df_vs[["arm"]]

# Tidyverse Pipelines
df_vs %>% pull(arm)
df_vs %>% select(arm)
df_vs %>% select(arm, age, agegr1)



# Subset Rows -------------------------------------------------------------

df_vs[1:2, ]
df_vs %>% slice(1:2)

df_vs[1:2, "arm"]
df_vs %>% select(arm) %>% slice(1:2)


# Shortcut to Subset First/Last 5 Rows
df_vs %>% head()
df_vs %>% tail()

# Tidyverse Shortcut to Subset First/Last N Rows
df_vs %>% slice_head(n = 1)
df_vs %>% slice_tail(n = 5)


# Subset by Condition -----------------------------------------------------

df_vs %>% subset(arm == "ARM D", c("age", "sex", "base_resp"))
df_vs %>% filter(arm == "ARM D") %>% select(age, sex, base_resp)

# Subset with AND ( & )
df_vs %>% subset(arm == "ARM D" & age < 35)
df_vs %>% filter(arm == "ARM D" & age < 35)
df_vs %>% filter(arm == "ARM D", age < 35, AVISITN > 2)

# Subset with OR ( | )
df_vs %>% subset(arm == "ARM D" | age <= 35)
df_vs %>% filter(arm == "ARM D" | age <= 35)


# Subset Distinct Rows ----------------------------------------------------

unique(df_vs[c("arm", "agegr1")])

df_vs %>% distinct()             # Remove Duplicate Rows
df_vs %>% distinct(arm, agegr1)  # Unique Combinations of Values



# Subset Min/Max Rows -----------------------------------------------------

df_vs[df_vs$age == min(df_vs$age), ]
df_vs[df_vs$age == max(df_vs$age), ]

df_vs %>% slice_min(age)
df_vs %>% slice_max(age)


# Subset Random Rows ------------------------------------------------------

df_vs[sample(nrow(df_vs), 10), ]


df_vs %>% slice_sample(n = 10)
df_vs %>% slice_sample(prop = 0.25)



# Tidyverse Selecting Functions -------------------------------------------

df_vs %>% select(last_col())
df_vs %>% select(everything())
df_vs %>% select(base_pulse:last_col())

df_vs %>% select(ends_with("d"))
df_vs %>% select(starts_with("a"))
df_vs %>% select(contains("resp"))
df_vs %>% select(where(is.numeric))


# Documentation -----------------------------------------------------------

# Vignettes
vignette("dplyr")
vignette("tidyselect")

# Help Pages
help("filter", package = "dplyr")
help("select", package = "dplyr")

# Website References
# - https://r4ds.had.co.nz/transform.html
# - https://www.rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
