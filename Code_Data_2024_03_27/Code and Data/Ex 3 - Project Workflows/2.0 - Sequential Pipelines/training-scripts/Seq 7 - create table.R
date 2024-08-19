
# Step 7 ------------------------------------------------------------------

library(janitor)

df_table <-
  df_analysis %>%
  tabyl(cut, color, clarity) %>%
  adorn_percentages() %>%
  adorn_pct_formatting() %>%
  adorn_ns(position = "front")

# -------------------------------------------------------------------------
