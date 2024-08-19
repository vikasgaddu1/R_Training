# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Introduction to ggplot 2 - Part II

# Packages & Functions on Display:
# - {ggplot2   3.3.1}: ggplot(), aes(), `+`, facet_grid(), geom_col(), geom_linerange(),
#                     geom_pointrange(), geom_errorbar(), geom_crossbar(), geom_hline(),
#                     geom_vline(), geom_abline(), geom_rect()

# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)

# Load Vignette for Reference
vignette("ggplot2-specs", package = "ggplot2")


# Import Data -------------------------------------------------------------
# Using 'diamonds' data for demonstration purposes

data_plots <-
  diamonds %>%
  slice_sample(n = 500) %>%
  mutate(carat_group = floor(carat))

data_plots %>% glimpse()

summary(data_plots$carat)
summary(data_plots$price)


# Geometry Layers ---------------------------------------------------------

ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point()

ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point() +
  geom_smooth()


# Fixed Aesthetics in Either Geometry
ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point(size = 4) +
  geom_smooth(color = "red", se = FALSE, size = 2)


# Dynamic Aesthetics in Either Geometry
ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point(aes(color = cut), size = 4) +
  geom_smooth(color = "red", se = FALSE, size = 2)


ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point(size = 1) +
  geom_smooth(aes(color = cut), se = FALSE, size = 2)


# Order of Geometries
ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point(size = 6, shape = 15) +
  geom_point(size = 3, shape = 4, color = "red")

ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point(size = 3, shape = 4, color = "red") +
  geom_point(size = 6, shape = 15)


# Multiple Facets ---------------------------------------------------------

ggplot(data_plots, aes(x = carat, y = price)) +
  geom_line(size = 1)


# Differentiate by Variable within Plot
ggplot(data_plots, aes(x = carat, y = price, group = cut)) +
  geom_line(size = 1)


# Differentiate by Variable in Many Plot Facets
ggplot(data_plots, aes(x = carat, y = price)) +
  geom_line(size = 1) +
  facet_grid(rows = vars(cut), scales = "fixed")

ggplot(data_plots, aes(x = carat, y = price)) +
  geom_line(size = 1) +
  facet_grid(cols = vars(cut), rows = vars(clarity), scales = "fixed")


# Control Facets
ggplot(data_plots, aes(x = carat, y = price)) +
  geom_line(size = 1) +
  facet_grid(cols = vars(cut),
             scales = "free",
             switch = "both")


# Works with Many Geometries
ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point() +
  facet_grid(vars(cut))

ggplot(data_plots, aes(x = price)) +
  geom_histogram() +
  facet_grid(rows = vars(cut))

ggplot(data_plots, aes(x = cut, y = price)) +
  geom_boxplot() +
  facet_grid(cols = vars(clarity))


# Documentation
help(facet_grid, package = "ggplot2")
help(facet_wrap, package = "ggplot2")


# Using Summary Data ------------------------------------------------------

data_summary <-
  data_plots %>%
  group_by(carat_group) %>%
  summarise(n   = n(),
            avg = mean(price),
            std = sd(price),
            min = min(price),
            med = median(price),
            max = max(price)) %>%
  print()


# Bars from Counts
ggplot(data_summary, aes(x = carat_group, y = n)) +
  geom_col()


# Line Summaries
ggplot(data_summary, aes(x = carat_group, ymin = min, ymax = max)) +
  geom_linerange()

ggplot(data_summary, aes(x = carat_group, ymin = min, y = med, ymax = max)) +
  geom_pointrange()

ggplot(data_summary, aes(x = carat_group, ymin = min, y = med, ymax = max)) +
  geom_errorbar()

ggplot(data_summary, aes(x = carat_group, ymin = min, y = med, ymax = max)) +
  geom_crossbar()


# Comparing Group Means
ggplot(data_summary, aes(x = carat_group, y = avg)) +
  geom_point(size = 3) +
  geom_line(aes(group = 1)) +
  geom_errorbar(aes(ymin = avg - std, ymax = avg + std), width = 0.05)


# Documentation
help(geom_col,        package = "ggplot2")
help(geom_crossbar,   package = "ggplot2")
help(geom_errorbar,   package = "ggplot2")
help(geom_linerange,  package = "ggplot2")
help(geom_pointrange, package = "ggplot2")


# Using Summary Functions -------------------------------------------------

# Reference Lines
ggplot(data_plots, aes(x = carat, y = price)) +
  geom_hline(aes(yintercept = mean(price))) +
  geom_point(alpha = 0.25)

ggplot(data_plots, aes(x = carat, y = price)) +
  geom_vline(xintercept = c(0.75, 1.50), size = 2) +
  geom_point(alpha = 0.25)

ggplot(data_plots, aes(x = carat, y = price)) +
  geom_abline(intercept = 0, slope = 5000, color = "red", linetype = 2, size = 2) +
  geom_point(alpha = 0.25)


# Reference Area
ggplot(data_plots, aes(x = carat, y = price)) +
  geom_rect(aes(xmin = mean(carat) - sd(carat),
                xmax = mean(carat) + sd(carat)),
            ymin = -Inf, ymax = Inf, fill = "orange") +
  geom_point(alpha = 0.25)

ggplot(data_plots, aes(x = carat, y = price)) +
  geom_rect(xmin = 1.00, xmax = 1.50,
            ymin = 2500, ymax = 7500,
            fill = "orange", color = "black", size = 1.5) +
  geom_point(alpha = 0.25)


# Documentation
help(geom_rect,   package = "ggplot2")
help(geom_hline,  package = "ggplot2")
help(geom_vline,  package = "ggplot2")
help(geom_abline, package = "ggplot2")


# Documentation -----------------------------------------------------------

# Special Notes
# - Find all accepted names of colors
colors()

sample_palette <- sample(colors(), 6)
scales::show_col(sample_palette)

# Vignettes
vignette("ggplot2-specs", package = "ggplot2")

# Website References
# - https://ggplot2-book.org/
# - http://ggplot2.tidyverse.org/reference
# - https://rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
