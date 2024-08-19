
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


# Text Annotations --------------------------------------------------------

ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point()

ggplot(data_plots, aes(x = carat, y = price, label = scales::dollar(price))) +
  geom_text()

ggplot(data_plots, aes(x = carat, y = price, label = scales::dollar(price))) +
  geom_label()

ggplot(data_plots, aes(x = carat, y = price, label = scales::dollar(price))) +
  geom_point() +
  geom_label(data = data_plots[1:3, ], size = 5, fontface = "bold")


# Data as Labels
data_summary <-
  data_plots %>%
  tabyl(cut) %>%
  adorn_pct_formatting() %>%
  print()

ggplot(data_summary, aes(y = cut, x = n, label = percent)) +
  geom_col() +
  geom_text(size = 10)


# Adjust Label Placement
ggplot(data_summary, aes(y = cut, x = n, label = percent)) +
  geom_col() +
  geom_text(size = 10, hjust = -0.25)

ggplot(data_summary, aes(y = cut, x = n, label = percent)) +
  geom_col() +
  geom_text(size = 10, nudge_x = 10)


# Label / Text
ggplot(data_summary, aes(y = cut, x = n, label = percent)) +
  geom_col() +
  geom_label(size = 10, hjust = -0.05)


# Documentation
help(geom_text,  package = "ggplot2")
help(geom_label, package = "ggplot2")


# Fixed Annotations -------------------------------------------------------

ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point(alpha = 0.25) +
  annotate(geom = "point",   x = 1.5, y = 3000, size = 5, color = "red")


ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point(alpha = 0.25) +
  annotate(geom = "point",   x = 1.5, y = 3000, size = 5, color = "red") +
  annotate(geom = "segment", x = 2.0, xend = 1.55, y = 3000, yend = 3000, arrow = arrow())


ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point(alpha = 0.25) +
  annotate(geom = "point",   x = 1.5, y = 3000, size = 5, color = "red") +
  annotate(geom = "segment", x = 2.0, xend = 1.55, y = 3000, yend = 3000, arrow = arrow()) +
  annotate(geom = "text",    x = 2.0, y = 3000, label = "Reference Point")

ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point(alpha = 0.25) +
  annotate(geom = "point",   x = 1.5, y = 3000, size = 5, color = "red") +
  annotate(geom = "segment", x = 2.0, xend = 1.55, y = 3000, yend = 3000, arrow = arrow()) +
  annotate(geom = "text",    x = 2.0, y = 3000, label = "Reference Point", hjust = 0, vjust = 0)

ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point(alpha = 0.25) +
  annotate(geom = "point",   x = 1.5, y = 3000, size = 5, color = "red") +
  annotate(geom = "segment", x = 2.0, xend = 1.55, y = 3000, yend = 3000, arrow = arrow()) +
  annotate(geom = "text",    x = 2.0, y = 3000, label = "Reference Point", hjust = 0, vjust = 1)


ggplot(data_plots, aes(x = carat, y = price)) +
  geom_point(alpha = 0.25) +
  annotate(geom = "rect",
           xmin = 2, xmax = 3, ymin = 14000, ymax = 16000,
           fill = "orange", color = "black") +
  annotate(geom = "label",
           x = 2.5, y = 15000,
           label = "Math: italic(abc) ^ 2 + bold(def)", parse = TRUE)


# Documentation
help(annotate, package = "ggplot2")


# Plot Themes -------------------------------------------------------------

plot_base <-
  ggplot(data_plots, aes(x = carat, y = price, color = cut)) +
  geom_point() +
  labs(title = "Diamonds", color = "Cut Class")

plot_base

plot_base + theme_bw()
plot_base + theme_minimal()
plot_base + theme_linedraw()


# Custom Plot Text
plot_base +
  theme(plot.title   = element_text(face = "bold", color = "red"),
        legend.title = element_text(face = "italic"),
        legend.text  = element_text(angle = 45),
        axis.text    = element_text(size = 20))


# Custom Plot Lines
plot_base +
  theme(axis.line    = element_line(color = "black"),
        panel.grid   = element_line(color = "red", linetype = 2),
        axis.ticks.x = element_line(size = 5),
        axis.ticks.y = element_blank())


# Custom Plot Colors
plot_base +
  theme(panel.background  = element_rect(fill = "pink", color = "black"),
        plot.background   = element_rect(fill = "lightblue"),
        legend.background = element_rect(linetype = 2, color = "black"))


# Define Custom Theme
my_theme <-
  theme(plot.title        = element_text(face = "bold", color = "red"),
        legend.title      = element_text(face = "italic"),
        legend.text       = element_text(angle = 45),
        axis.text         = element_text(size = 20),
        axis.line         = element_line(color = "black"),
        panel.grid        = element_line(color = "red", linetype = 2),
        axis.ticks.x      = element_line(size = 5),
        axis.ticks.y      = element_blank(),
        panel.background  = element_rect(fill = "pink", color = "black"),
        plot.background   = element_rect(fill = "lightblue"),
        legend.background = element_rect(linetype = 2, color = "black"))


plot_base + my_theme


# Documentation
help(theme, package = "ggplot2")


# Plot Export -------------------------------------------------------------

# Interactively with Plot > Export
plot_base


# With Function
ggsave(filename = "plot_output.png", plot = plot_base,
       width = 10, height = 20, units = "cm")


# As R Object
write_rds(plot_base, path = "plot_object.rds")


# Extension Packages ------------------------------------------------------
# https://exts.ggplot2.tidyverse.org/

# ggAlly:    Helps when using transformed data
# ggtext:    Finer control over text display on the plot labels, titles, annotations
# svglite:   Allows ggsave to save plots as SVG to edit manually later
# ggforce:   More options when highlighting certain areas of a plot
# ggrepel:   Additional assistance with controlling annotation labels on a plot
# patchwork: Useful when combining multiple plots into a single plot
# survminer: Used when creating survival analysis plots with ggplot2


# Documentation -----------------------------------------------------------

# Special Notes
colors() # - Find all accepted names of colors

# Vignettes
vignette("ggplot2-specs", package = "ggplot2")

# Help Pages
help(theme,      package = "ggplot2")
help(annotate,   package = "ggplot2")
help(geom_text,  package = "ggplot2")
help(geom_label, package = "ggplot2")

# Website References
# - https://ggplot2-book.org/
# - http://ggplot2.tidyverse.org/reference
# - https://rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
