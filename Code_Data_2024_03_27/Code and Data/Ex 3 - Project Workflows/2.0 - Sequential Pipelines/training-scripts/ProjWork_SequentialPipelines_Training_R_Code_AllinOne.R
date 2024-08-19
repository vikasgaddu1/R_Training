
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Pipelines - All in One

# Pseudo Code -------------------------------------------------------------

# |- Get raw data
# |- Prepare data for analysis
#  |- Create table using prepared data
#  |- Summarize the prepared data
#    |- Create plot based on summarized data
# |- Run linear model on the prepared data
# |- Save model results

# Setup -------------------------------------------------------------------

library(tidyverse)
library(janitor)
library(broom)


# Step 1: Get Raw Data ----------------------------------------------------

df_raw <- diamonds


# Step 2: Prepare Data for Analysis ---------------------------------------

df_analysis <-
  df_raw %>%
  arrange(desc(depth)) %>%
  rowid_to_column("depth_order") %>%
  mutate(x_diff = x - mean(x)) %>%
  mutate(depth_group = cut(depth, 5)) %>%
  print()


# Step 3: Summarize Data --------------------------------------------------

df_summary <-
  df_analysis %>%
  group_by(depth_group) %>%
  summarise(
    avg_carat = mean(carat),
    avg_price = mean(price),
    std_price = sd(price)) %>%
  print()


# Step 4: Analyze Data ----------------------------------------------------

df_model <-
  aov(
    data = df_analysis,
    formula = price ~ depth_group) %>%
  print()


# Step 5: Get Analysis Results --------------------------------------------

df_model_summary <-
  df_model %>%
  tidy() %>%
  print()


# Step 6: Create Plot -----------------------------------------------------

pl_summary <-
  df_summary %>%
  ggplot(aes(y = depth_group, x = avg_price)) +
  geom_point() +
  geom_errorbar(aes(xmin = avg_price - std_price,
                    xmax = avg_price + std_price))

pl_summary

# Step 7: Create Table ----------------------------------------------------

df_table <-
  df_analysis %>%
  tabyl(cut, color, clarity) %>%
  adorn_percentages() %>%
  adorn_pct_formatting() %>%
  adorn_ns(position = "front") %>%
  print()


# All in One --------------------------------------------------------------

# -- Pros --
# Easy to track the process
# Changes are easy to do on the fly
# No worry of dependencies


# -- Cons --
# Structure is flow is very important
# Adjustments to part of the process mean the entire process needs to rerun
# Challenging to navigate script when too large
# Challenging to make adjustments and ensure downstream process still works

# -------------------------------------------------------------------------
