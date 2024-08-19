
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Data Types - Factor Values

# Packages & Functions on Display:
# - {base    4.2.0}: sort(), rev(), factor(), levels()
# - {forcats 0.5.1}: fct_infreq(), fct_relevel(), fct_recode(), fct_relabel(),
#                   fct_reorder()
# - {readr   2.1.2}: read_rds()
# - {dplyr   1.0.8}: mutate(), select(), pull()


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)

# Load Data
df_adslvs <-
  read_rds("data/adslvs.rds") %>%
  print()


# Factor Values -----------------------------------------------------------
# Useful for ordering strings, controlling displays, and statistical tests

vec_factor <- c("ARM D", "ARM A", "ARM C", "ARM B") %>% print()

vec_factor %>% sort()
vec_factor %>% sort() %>% rev()

vec_factor %>% factor(levels = c("ARM A", "ARM B", "ARM C", "ARM D"))


# Factor Operations -------------------------------------------------------
# Tidyverse factor operations have no equivalents in base R

df_adslvs
df_adslvs$agegr1 %>% levels()                # Already an ordinal factor
df_adslvs$avisit %>% factor() %>% levels()   # Convert chr to factor


# Create factor levels that descend in frequency
df_adslvs$avisit %>% factor() %>% fct_infreq() %>% levels()


# Control level order of an existing factor
df_adslvs$avisit %>% factor() %>% fct_relevel("Week 8", "Week 2", "Week 4") %>% levels()


# Rename levels of existing factor manually
df_adslvs$avisit %>% factor() %>% fct_recode("W2" = "Week 2") %>% levels()


# Rename levels of existing factor with a function
df_adslvs$avisit %>% factor() %>% fct_relabel(str_to_upper) %>% levels()


# Factor Operations in Tidyverse Pipeline ---------------------------------

df_adslvs %>%
  mutate(avisit_factor = factor(avisit)) %>%
  select(subjid, avisit, avisit_factor)


# Order levels based on another numeric variable
df_adslvs %>%
  mutate(
    avisit_factor =
      avisit %>%
      factor() %>%
      fct_reorder(aval_resp, mean)) %>%
  pull(avisit_factor) %>%
  levels()



# Documentation -----------------------------------------------------------

# Vignettes
vignette("forcats", package = "forcats")

# Help Pages
help("factor")

# Website References
# - http://forcats.tidyverse.org
# - https://r4ds.had.co.nz/factors.html
# - https://rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
