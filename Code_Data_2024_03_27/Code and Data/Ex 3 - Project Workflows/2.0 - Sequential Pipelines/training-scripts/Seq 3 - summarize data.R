
# Step 3 ------------------------------------------------------------------

library(tidyverse)

df_summary <-
  df_analysis %>%
  group_by(depth_group) %>%
  summarise(
    avg_carat = mean(carat),
    avg_price = mean(price),
    std_price = sd(price))

# -------------------------------------------------------------------------
