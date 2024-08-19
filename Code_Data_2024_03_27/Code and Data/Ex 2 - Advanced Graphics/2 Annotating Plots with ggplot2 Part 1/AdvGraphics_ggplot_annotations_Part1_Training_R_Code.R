
# Anova Accel2R - Clinical R Training -----------------------------------

# Title: Plot Annotations

# Packages & Functions on Display:
# - {ggplot2   3.3.1}: ggplot(), aes(), labs(), lims(), guides(), theme(),
#                     scale_*(), annotate(), geom_text(), geom_label(), ggsave()
# - {scales    1.1.1}: label_*(), breaks_*()


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
library(scales)


# Load Vignette for Reference
vignette("ggplot2-specs", package = "ggplot2")


# Plot Data ---------------------------------------------------------------

data_plots <-
  diamonds %>%
  slice_sample(n = 500) %>%
  mutate(carat_group = floor(carat))

data_plots %>% glimpse()


# Plot Titles -------------------------------------------------------------

ggplot(data_plots, aes(x = carat, y = price, color = cut)) +
  geom_point() +
  labs(title = "Diamond Prices",
       subtitle = "Carat by Price and Cut Class",
       caption = "Note: Using ggplot2 diamonds data",
       x = "Carats",
       y = "Price",
       color = "Cut\nof the\nDiamond")


# Remove Titles
ggplot(data_plots, aes(x = carat, y = price, color = cut)) +
  geom_point() +
  labs(x = NULL, y = "")

ggplot(data_plots, aes(x = carat, y = price, color = cut)) +
  geom_point() +
  labs(x = "", y = "")


# Text Styles
ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point(alpha = 0.25) +
  labs(x = quote(x^2 + (.00002 * sqrt(y))))


# Documentation
help(labs, package = "ggplot2")


# Plot Limits -------------------------------------------------------------

ggplot(data_plots, aes(x = carat, y = price, color = cut)) +
  geom_point() +
  lims(x = c(0, 1.5),
       y = c(5000, NA),
       color = c("Fair", "Good", "Very Good"))


# Documentation
help(lims,            package = "ggplot2")
help(coord_cartesian, package = "ggplot2")


# Plot Legends ------------------------------------------------------------

ggplot(data_plots, aes(x = carat, y = price, color = cut, shape = cut, alpha = carat)) +
  geom_point()

ggplot(data_plots, aes(x = carat, y = price, color = cut, shape = cut, alpha = carat)) +
  geom_point() +
  guides(color = guide_legend(title = "Cut", reverse = TRUE),
         shape = guide_legend(label = FALSE, nrow = 3, ncol = 2),
         alpha = "none")


# Using Themes
ggplot(data_plots, aes(x = carat, y = price, color = cut)) +
  geom_point() +
  theme(legend.position = "bottom")

ggplot(data_plots, aes(x = carat, y = price, color = cut)) +
  geom_point() +
  theme(legend.position = c(0.85, 0.25))

ggplot(data_plots, aes(x = carat, y = price, color = cut)) +
  geom_point() +
  theme(legend.position = c(1.00, 1.00))


# Documentation
help(theme,        package = "ggplot2")
help(guide,        package = "ggplot2")
help(guide_legend, package = "ggplot2")


# Plot Scales -------------------------------------------------------------
# - Note: Every aesthetic has a `scale_*()`

scale_x_
scale_y_
scale_size_
scale_color_


# Numeric Scales
ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point() +
  scale_x_continuous(name = "Diamond Carats",
                     limits = c(NA, 2),
                     breaks = c(0.50, 1, 1.50),
                     labels = c("A", "B", "C"),
                     position = "top")

ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point() +
  scale_y_continuous(breaks = scales::breaks_width(2500),
                     labels = scales::label_dollar(),
                     position = "right")


# Numeric Scales - Transformation
ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point() +
  scale_y_log10(name = "Log of Price") +
  scale_x_sqrt(name = "Square Root of Carat")


# Numeric Scales - Aesthetics
ggplot(data_plots, aes(x = carat, y = price, alpha = price)) +
  geom_point() +
  scale_alpha(breaks = scales::breaks_width(2500), range = c(0.01, 0.50))

ggplot(data_plots, aes(x = carat, y = price, color = price)) +
  geom_point()

ggplot(data_plots, aes(x = carat, y = price, color = price)) +
  geom_point() +
  scale_color_continuous(type = "gradient", low = "black", high = "red")

ggplot(data_plots, aes(x = carat, y = price, color = price)) +
  geom_point() +
  scale_color_continuous(type = "viridis", option = "A", direction = -1)


# Categorical Scales
ggplot(data_plots, aes(x = carat, y = price, color = cut)) +
  geom_point(size = 3)

ggplot(data_plots, aes(x = carat, y = price, color = cut)) +
  geom_point(size = 3) +
  scale_color_manual(values = c("Fair"      = "red",
                                "Good"      = "blue",
                                "Very Good" = "gray",
                                "Premium"   = "purple",
                                "Ideal"     = "orange"),
                     labels = c("Fair"      = "cut-1",
                                "Good"      = "cut-2",
                                "Very Good" = "cut-3",
                                "Premium"   = "cut-4",
                                "Ideal"     = "cut-5"))



ggplot(data_plots, aes(x = carat, y = price, color = cut)) +
  geom_point(size = 3) +
  scale_color_brewer(type = "div", palette = 1)

ggplot(data_plots, aes(x = carat, y = price, color = cut)) +
  geom_point(size = 3) +
  scale_color_viridis_d(begin = 0.10, end = 0.90)


# Date Scales
# - Breaks accepts any lubridate-style period of date and time
# - Labels accepts any character formatting of date and time
# scale_x_date(date_breaks = "2 months")
# scale_x_date(labels = scales::label_date())


# Documentation
help(scale_alpha,           package = "ggplot2")
help(scale_x_continuous,    package = "ggplot2")
help(scale_color_discrete,  package = "ggplot2")
help(scale_color_viridis_d, package = "ggplot2")


# Documentation -----------------------------------------------------------

# Special Notes
colors() # - Find all accepted names of colors

# Vignettes
vignette("ggplot2-specs", package = "ggplot2")

# Help Pages
help(labs,                  package = "ggplot2")
help(theme,                 package = "ggplot2")
help(guides,                package = "ggplot2")
help(scale_alpha,           package = "ggplot2")
help(scale_x_continuous,    package = "ggplot2")
help(scale_color_viridis_d, package = "ggplot2")

# Website References
# - https://ggplot2-book.org/
# - http://ggplot2.tidyverse.org/reference
# - https://rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
