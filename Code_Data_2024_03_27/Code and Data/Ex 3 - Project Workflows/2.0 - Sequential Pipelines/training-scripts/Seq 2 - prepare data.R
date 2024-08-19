
# Step 2 ------------------------------------------------------------------

library(tidyverse)

df_analysis <-
  df_raw %>%
  arrange(desc(depth)) %>%
  rowid_to_column("depth_order") %>%
  mutate(x_diff = x - mean(x)) %>%
  mutate(depth_group = cut(depth, 5))

# -------------------------------------------------------------------------
