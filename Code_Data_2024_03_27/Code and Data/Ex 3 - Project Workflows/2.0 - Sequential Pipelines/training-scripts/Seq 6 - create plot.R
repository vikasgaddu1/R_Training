
# Step 6 ------------------------------------------------------------------

library(tidyverse)

pl_summary <-
  df_summary %>%
  ggplot(aes(y = depth_group, x = avg_price)) +
  geom_point() +
  geom_errorbar(aes(xmin = avg_price - std_price,
                    xmax = avg_price + std_price))

# -------------------------------------------------------------------------
