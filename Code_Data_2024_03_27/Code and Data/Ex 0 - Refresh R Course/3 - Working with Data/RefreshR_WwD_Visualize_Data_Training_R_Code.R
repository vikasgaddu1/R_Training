
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Working with Data - Visualize Data with 'ggplot2'

# Packages & Functions on Display:
# - {base    4.2.0}: colors()
# - {haven   2.5.0}: read_sas()
# - {dplyr   1.0.8}: summarize(), rename_with(), select(), filter(), pivot_wider(),
#                   inner_join(), group_by(), n()
# - {ggplot2 3.3.5}: ggplot(), aes(), geom_point(), geom_smooth(), facet_wrap(), geom_col(),
#                   geom_hline(), geom_vline(), geom_pointrange(), geom_label(), labs()
#                   theme_dark(), theme_minimal(), theme(), geom_density(), geom_histogram(),
#                   geom_bar(), geom_line(), geom_boxplot(), ggsave()



# Setup -------------------------------------------------------------------

# Load Packages
library(haven)
library(tidyverse)
library(scales)


# Prepare Data
df_adsl <-
  read_sas("data/abc_adam_adsl.sas7bdat") %>%
  rename_with(str_to_lower) %>%
  filter(arm != "SCREEN FAILURE") %>%
  transmute(
    subjid,
    siteid,
    sex,
    arm    = factor(arm, ordered = T, levels = c("ARM A", "ARM B", "ARM C", "ARM D")),
    agegr1 = factor(agegr1, ordered = T, levels =  c("18-29 years", "30-39 years", "40-49 years", "50-65 years", ">65 years")))


df_advs <-
  read_sas("data/abc_adam_advs.sas7bdat") %>%
  rename_with(str_to_lower) %>%
  select(subjid, siteid, avisitn, paramcd, aval) %>%
  filter(paramcd == "BMI" | (paramcd == "PULSE" & avisitn == 0)) %>%
  pivot_wider(
    id_cols = c(subjid, siteid),
    names_from  = paramcd,
    values_from = aval,
    names_repair = str_to_lower)


df_plots <- inner_join(df_adsl, df_advs, by = c("subjid", "siteid"))


# Using ggplot2 -----------------------------------------------------------
#' The `ggplot2` package is older than tidyverse, so it does not work with `%>%`.
#' Instead it uses `+` to link operations together within a `ggplot2` context

df_plots %>% ggplot()
df_plots %>% ggplot(aes(x = bmi, y = pulse))
df_plots %>% ggplot(aes(x = bmi, y = pulse)) + geom_point()


# Fixed Aesthetics --------------------------------------------------------

df_plots %>%
  ggplot(aes(x = bmi, y = pulse)) +
  geom_point(
    shape = 22,
    size  = 5,
    color = "black",
    fill  = "red",
    alpha = 0.50)

# Dynamic Aesthetics ------------------------------------------------------

df_plots %>%
  ggplot(aes(x = bmi, y = pulse)) +
  geom_point(
    aes(shape = sex,
        color = sex,
        size  = pulse,
        alpha = pulse))


# Plot Assignment ---------------------------------------------------------

pl_base <-
  df_plots %>%
  ggplot(aes(x = bmi, y = pulse)) +
  geom_point()


# Adding to the Plot
pl_base + geom_smooth()


# Subset a Plot -----------------------------------------------------------

pl_base +
  geom_smooth() +
  facet_wrap("sex")


# Using Summary Data ------------------------------------------------------

df_summary <-
  df_plots %>%
  group_by(agegr1) %>%
  summarise(
    n = n(),
    avg = mean(bmi, na.rm = T),
    sd  = sd(bmi, na.rm = T))

df_summary %>%
  ggplot(aes(x = agegr1, y = n)) +
  geom_col()

df_summary %>%
  ggplot(aes(x = agegr1)) +
  geom_pointrange(aes(y = avg, ymin = avg - sd, ymax = avg + sd))


# Using Text --------------------------------------------------------------

df_summary %>%
  ggplot(aes(x = agegr1, y = n, label = str_glue("N = {n}"))) +
  geom_col() +
  geom_label(nudge_y = -2)


# Using Labels ------------------------------------------------------------

pl_base +
  labs(
    title = "Learning ggplot2",
    subtitle = "Plotting Pulse by BMI",
    y = "Pulse Values",
    x = "BMI Values")

# Add Reference Lines -----------------------------------------------------

pl_base +
  geom_smooth() +
  geom_hline(yintercept = 60) +
  geom_vline(xintercept = 35)

# Plot Themes -------------------------------------------------------------

pl_base
pl_base + theme_dark()
pl_base + theme_minimal()


# Custom Themes
pl_base +
  theme(
    plot.background = element_rect(fill = "pink"),
    panel.background = element_rect(fill = "lightblue"))


# Various Plot Types ------------------------------------------------------

df_plots %>% ggplot(aes(x = bmi))             + geom_density()
df_plots %>% ggplot(aes(x = bmi))             + geom_histogram()
df_plots %>% ggplot(aes(x = agegr1))          + geom_bar()
df_plots %>% ggplot(aes(x = bmi, y = pulse))  + geom_line()
df_plots %>% ggplot(aes(x = bmi, y = agegr1)) + geom_boxplot()


# Useful Tools ------------------------------------------------------------

# Save plots as PNG files
plot_to_save <-
  df_plots %>% ggplot(aes(x = bmi))             + geom_density()
ggsave("plot_to_save.png", plot_to_save) 


colors()             # List available color labels
scales::show_col(hue_pal()(16))   # View the given colors


# Documentation -----------------------------------------------------------

# Vignettes
vignette("ggplot2-specs", package = "ggplot2")

# Help Pages
help("ggplot")

# Website References
# - https://www.rstudio.com/resources/cheatsheets
# - https://r4ds.had.co.nz/data-visualisation.html

# -------------------------------------------------------------------------
