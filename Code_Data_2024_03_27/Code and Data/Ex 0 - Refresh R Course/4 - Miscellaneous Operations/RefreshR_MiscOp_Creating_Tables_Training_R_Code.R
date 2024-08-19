
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Misc Operations - Creating Tables

# Packages & Functions on Display:
# - {readr   2.1.2}: read_rds()
# - {base    4.2.0}: table()
# - {tidyr   1.2.0}: count(), pivot_wider()
# - {janitor 2.1.0}: tabyl(), adorn_totals(), adorn_percentages(), adorn_pct_formatting(),
#                   adorn_ns(), adorn_titles()


# Setup -------------------------------------------------------------------
# Load Packages

library(janitor)
library(tidyverse)

# Load Data
df_adslvs <- read_rds("data/adslvs.rds") %>% print()


# Tables - Base R ---------------------------------------------------------

table(df_adslvs$arm)
table(df_adslvs$arm, df_adslvs$sex)


# Tables - Tidyverse ------------------------------------------------------
df_adslvs %>%
  count(arm) %>%
  pivot_wider(names_from = "arm", values_from = "n")


df_adslvs %>%
  count(arm, sex) %>%
  pivot_wider(names_from = "sex", values_from = "n")


# Tables - Janitor --------------------------------------------------------

df_adslvs %>% tabyl(arm)
df_adslvs %>% tabyl(arm, sex)

df_adslvs %>%
  tabyl(arm, sex) %>%
  adorn_totals() %>%
  adorn_percentages() %>%
  adorn_pct_formatting() %>%
  adorn_ns() %>%
  adorn_title("Table of ARM by Sex", placement = "top")


# Documentation -----------------------------------------------------------

# Vignettes
vignette("tabyls")

# Help Pages
help("count")
help("table", package = "base")

# Website References
# - https://sfirke.github.io/janitor/index.html

# -------------------------------------------------------------------------
