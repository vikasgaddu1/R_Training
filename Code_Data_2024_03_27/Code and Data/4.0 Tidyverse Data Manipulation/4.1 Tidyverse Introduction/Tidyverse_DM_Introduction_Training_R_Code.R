
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2020 Anova Groups All rights reserved

# Title: Introduction to the Tidyverse

# Packages & Functions on Display:
# - {tidyverse 1.3.0}: `%>%`, dplyr, tibble, readr, tidyr, forcats, stringr, ggplot2

# Setup -------------------------------------------------------------------

# Load Package
library(tidyverse)

# Package Conflicts
filter

stats::filter()
dplyr::filter()


# Function Pipeline -------------------------------------------------------
# Pipe Operator: %>%

# Keyboard Shortcut:
# - Windows: Ctrl + Shift + M
# -     Mac:  Cmd + Shift + M

# Use:
# - function(x, y)
# - x %>% function(y)

vector_1 <- seq(1, 10)

vector_sample <- sample(vector_1, size = 2)
vector_mean   <- mean(vector_sample, na.rm = TRUE)

vector_1 %>%
  sample(size = 2) %>%
  mean(na.rm = TRUE)


# Tidyverse Package Prefix ------------------------------------------------

readr::parse_
readr::read_
readr::write_

stringr::str_
forcats::fct_

# Documentation -----------------------------------------------------------

# Vignettes
vignette("paper",     package = "tidyverse")
vignette("manifesto", package = "tidyverse")

# Help Pages
help(`%>%`,     package = "magrittr")
help(tidyverse, package = "tidyverse")

# Website References
# https://www.tidyverse.org/
# https://rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
