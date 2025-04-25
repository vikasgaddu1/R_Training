
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Creating Plots in the Tidyverse

# Packages & Functions on Display:
# - {ggplot2   3.3.1}: ggplot(), aes(), geom_*(), position_*()

# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)

# Load Vignette for Reference
vignette("ggplot2-specs", package = "ggplot2")

# Import Data -------------------------------------------------------------
# Using 'diamonds' data for demonstration purposes

data_plots <-
  diamonds %>%
  slice_sample(n = 500)

data_plots %>% glimpse()

summary(data_plots$carat)
summary(data_plots$price)


# Getting Started with Plots ----------------------------------------------

# An Empty Canvas
data_plots |> 
  ggplot()

plt <- ggplot(data = data_plots)

# Add Aesthetics to the Plot
ggplot(data = data_plots, mapping = aes(x = carat, y = price))

# Add Geometries to the Plot using '+'
ggplot(data = data_plots, mapping = aes(x = carat, y = price)) +
  geom_point()


# Fixed Aesthetics --------------------------------------------------------

# Store Aesthetics as Static Object
plot_base <-
  ggplot(data = data_plots, mapping = aes(x = carat, y = price))

# Set Aesthetics for Color, Fill, Size, Shape, Alpha
plot_base + geom_point(size = 5)
plot_base + geom_point(shape = 1)
plot_base + geom_point(alpha = 0.25)
plot_base + geom_point(color = "red")
plot_base + geom_point(color = "#FF0110")


# Any Combination of Aesthetics
plot_base + geom_point(size = 5)
plot_base + geom_point(size = 5, shape = 21)
plot_base + geom_point(size = 5, shape = 21, fill = "red")
plot_base + geom_point(size = 5, shape = 21, fill = "black", color = "red")
plot_base + geom_point(size = 5, shape = 21, fill = "black", color = "red", alpha = 0.25)


# Dynamic Aesthetics ------------------------------------------------------

ggplot(data_plots, aes(x = carat, y = price)) + geom_point()

# Let an Aesthetic Change by Variable Values
ggplot(data_plots, aes(x = carat, y = price, color = price)) + geom_point()
ggplot(data_plots, aes(x = carat, y = price, color = cut))   + geom_point()

# Mix Fixed and Dynamic Aesthetics
ggplot(data_plots, aes(x = carat, y = price, color = cut, alpha = price)) +
  geom_point(size = 5, shape = 15)


# Scatterplot -------------------------------------------------------------
# Aesthetics: X, Y, Alpha, Color, Size, Shape, Fill

ggplot(data_plots, aes(x = carat, y = price)) + geom_point()
ggplot(data_plots, aes(x = cut, y = price)) + geom_point()


# If points are too dense, spread them out (aka. 'jitter')
ggplot(data_plots, aes(x = cut, y = price)) +
  geom_point(alpha = 0.25,
             position = position_jitter(width = 0.10))


# Line Plot ---------------------------------------------------------------
# Aesthetics: X, Y, Alpha, Color, Size, Group, Linetype

# Line Across All Points
ggplot(data_plots, aes(x = carat, y = price)) + geom_line()


# Dynamic Line Aesthetics
ggplot(data_plots, aes(x = carat, y = price, group = cut, color = cut)) + geom_line()
ggplot(data_plots, aes(x = carat, y = price, linetype = cut)) + geom_line()


# Fixed Line Aesthetics
ggplot(data_plots, aes(x = carat, y = price)) + geom_line(linetype = 2)


# Smoothed Average Line
ggplot(data_plots, aes(x = carat, y = price)) + geom_smooth()
ggplot(data_plots, aes(x = carat, y = price)) + geom_smooth(se = FALSE, color = "red")


# Boxplot -----------------------------------------------------------------
# Aesthetics: X, Y, Alpha, Color, Fill, Size, Group, Linetype

ggplot(data_plots, aes(x = cut, y = price)) + geom_boxplot()

ggplot(data_plots, aes(x = cut, y = price)) +
  geom_boxplot(outlier.shape = 3, varwidth = TRUE, color = "red")


# Bar Chart ---------------------------------------------------------------
# Aesthetics: X, Alpha, Color, Group, Fill, Weight

# Fixed Aesthetics
ggplot(data_plots, aes(x = cut)) + geom_bar()
ggplot(data_plots, aes(y = cut)) + geom_bar(fill = "orange", color = "black")

# Dynamic Aesthetics
# - Stacked Bars (Default)
ggplot(data_plots, aes(x = cut, fill = clarity)) + geom_bar()


# - Side-by-Side Bars (aka. Dodged Bars)
ggplot(data_plots, aes(x = cut, fill = clarity)) +
  geom_bar(color = "white", position = position_dodge())


# - Proportional Bars (aka. Filled Bars)
ggplot(data_plots, aes(x = cut, fill = clarity)) +
  geom_bar(color = "black", position = position_fill())


# Summary Data
data_summary <- data_plots %>% count(cut) %>% print()
ggplot(data_summary, aes(x = cut, weight = n)) + geom_bar()

data_plots |> 
  count(cut, clarity) |> 
  ggplot(aes(x = cut, fill = clarity, weight = n)) +
  geom_bar(position = position_fill())

# Histogram ---------------------------------------------------------------
# Aesthetics: X, Alpha, Color, Group, Fill, Linetype
data_plots |> 
  filter(cut=="Fair") |>
ggplot(aes(x = carat)) + geom_histogram()
ggplot(data_plots, aes(x = carat)) + geom_histogram(bins = 500)


# Density Plot
ggplot(data_plots, aes(x = carat)) + geom_density()
str(data_plots)
ggplot(data_plots, aes(x = carat)) + geom_density(fill = "orange") 
ggplot(data_plots, aes(x = carat, linetype = cut)) + geom_density()


# Documentation -----------------------------------------------------------

# Special Notes
# - Find all accepted names of colors
colors()

sample_palette <- sample(colors(), 10)
scales::show_col(c("yellow1", "yellow2", "yellow3", "yellow4", "yellow"))

mymean <- function(...) {
  #capture current;
  mean(...)
}
tryCatch(
  mymean(data_plots$prices),
  error = function(e) print(e),
  finally = print("Done")
)



# Vignettes
vignette("ggplot2-specs", package = "ggplot2")

# Help Pages
help(aes,             package = "ggplot2")
help(ggplot,          package = "ggplot2")
help(geom_line,       package = "ggplot2")
help(geom_point,      package = "ggplot2")
help(geom_boxplot,    package = "ggplot2")
help(position_fill,   package = "ggplot2")
help(position_dodge,  package = "ggplot2")
help(position_jitter, package = "ggplot2")

# Website References
# - https://ggplot2-book.org/
# - http://ggplot2.tidyverse.org/reference
# - https://rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
