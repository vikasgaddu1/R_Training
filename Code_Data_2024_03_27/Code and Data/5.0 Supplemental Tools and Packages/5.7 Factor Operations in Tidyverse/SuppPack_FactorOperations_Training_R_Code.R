# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Tidyverse Factor Operations with forcats

# Packages & Functions on Display:
# - {forcats 0.5.0}: fct_inorder, fct_infreq, fct_rev, fct_relevel, fct_shift,
#                   fct_shuffle, fct_reorder, fct_expand, fct_drop, fct_collapse,
#                   fct_lump, fct_other, fct_recode, fct_relabel, fct_anon


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
library(haven)
library(janitor)

# Import Data -------------------------------------------------------------
# data_labels <- var_label(data_study)

data_study <- read_sas("ae_studya.sas7bdat")
data_study %>% glimpse()


# Where are Factors Useful? -----------------------------------------------
# All statistics functions in R require categorical variables to be stored
# as factors, or as indicator variables


# Useful In Tables
data_study %>% tabyl(soc_term, aeserious)


# Useful In Figures
ggplot(data_study, aes(y = soc_term)) + geom_bar()


# Where Are Factors Defined? ----------------------------------------------

# Either on Import
data_study_csv <-
  read_csv(file = "ae_studya.csv",
           col_types = cols_only("patient" = col_integer(),
                                 "visit"   = col_integer(),
                                 soc_term  = col_factor(include_na = TRUE))) %>%
  print()

levels(data_study_csv$soc_term)


# In the Data
data_study_fct <-
  data_study %>%
  mutate(f_soc = factor(soc_term))

levels(data_study_fct$f_soc)


# On the Fly
ggplot(data_study, aes(y = factor(soc_term))) +
  geom_bar()


# Define a Plotting Function ----------------------------------------------

base_plot <- function(data, y_fill) {
  library(rlang)

  ggplot(data, aes(y = {{y_fill}}, fill = {{y_fill}})) +
    geom_bar() +
    scale_y_discrete(drop = FALSE) +
    scale_fill_viridis_d(end = 0.75, drop = FALSE) +
    guides(fill = "none") +
    labs(y = NULL, x = NULL)
}

base_plot(data_study, y_fill = soc_term)


# Factors in Order --------------------------------------------------------

# In Alphabetical Order
base_plot(data_study, y_fill = base::factor(soc_term))

# In Order of Appearance
base_plot(data_study, y_fill = fct_inorder(soc_term))

# In Order of Frequency
base_plot(data_study, y_fill = fct_infreq(soc_term))

# In Reverse Order
base_plot(data_study, y_fill = fct_infreq(soc_term) %>% fct_rev())


# Redefine Factors in Data
data_factors <-
  data_study %>%
  mutate(f_soc = fct_infreq(soc_term))


# Control Factor Order ----------------------------------------------------

# Explicit Order
base_plot(data_factors,
          y_fill = factor(f_soc, levels = c("Skin Disorders", "Psychiatric Disorders")))


# Bring Some Factors to Front
base_plot(data_factors,
          y_fill = fct_relevel(f_soc, c("Skin Disorders", "Psychiatric Disorders")))


# Shift All Factors
data_factors$f_soc %>% levels()
data_factors$f_soc %>% fct_shift(n =  2) %>% levels()
data_factors$f_soc %>% fct_shift(n = -2) %>% levels()

base_plot(data_factors, y_fill = f_soc)
base_plot(data_factors, y_fill = fct_shift(f_soc, n = 2))


# Random Order
base_plot(data_factors, y_fill = fct_shuffle(f_soc))


# Order Factors by Another Variable
base_plot(data_factors, y_fill = fct_reorder(f_soc, visit))


# Add and Remove Factor Levels --------------------------------------------

data_factors_extra <-
  data_factors %>%
  mutate(f_soc_other = fct_expand(f_soc, c("Other 1", "Other 2")))

base_plot(data_factors_extra, y_fill = f_soc_other)
base_plot(data_factors_extra, y_fill = fct_drop(f_soc_other))


# Collapse Factor Levels
base_plot(data_factors,
          y_fill = fct_collapse(f_soc,
                                "Skin, Psych" = c("Psychiatric Disorders", "Skin Disorders")))

# Lump Factor Levels Together
data_factors %>% tabyl(f_soc)

base_plot(data_factors, fct_lump_n(f_soc, n = 2))
base_plot(data_factors, fct_lump_min(f_soc, min = 5))
base_plot(data_factors, fct_lump_prop(f_soc, prop = .15))

base_plot(data_factors, fct_other(f_soc, keep = c("Psychiatric Disorders", "Skin Disorders")))
base_plot(data_factors, fct_other(f_soc, drop = c("Psychiatric Disorders", "Skin Disorders")))


# Control Factor Appearance -----------------------------------------------

base_plot(data_factors, y_fill = fct_recode(f_soc,
                                            "Missing" = "",
                                            "General" = "General Disorders",
                                            "Heart"   = "Cardiac Disorders"))


# Re-Label Factor Levels with Function
base_plot(data_factors, y_fill = fct_relabel(f_soc, .fun = str_to_upper))


# Re-Label Factor Levels with Anonymous
base_plot(data_factors, y_fill = fct_anon(f_soc))


# Documentation -----------------------------------------------------------

# Vignettes
vignette("forcats", package = "forcats")

# Help Pages
help(fct_lump,     package = "forcats")
help(fct_expand,   package = "forcats")
help(fct_recode,   package = "forcats")
help(fct_infreq,   package = "forcats")
help(fct_reorder,  package = "forcats")
help(fct_relevel,  package = "forcats")
help(fct_relabel,  package = "forcats")
help(fct_collapse, package = "forcats")

# Website References
# - http://forcats.tidyverse.org
# - https://github.com/tidyverse/forcats
# - https://rstudio.com/resources/cheatsheets/


# Equivalent Operations ---------------------------------------------------

help(factor, package = "base")

# -------------------------------------------------------------------------
