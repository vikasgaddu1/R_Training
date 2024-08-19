
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: SequentialPipelines_showdata.R

# Pseudo Code -------------------------------------------------------------

# |- Data Displays

# Show Data -------------------------------------------------------------------
# bs_counts %>% 
#  print()

bs_plot <- 
  bs_counts %>%  
  ggplot(aes(y = AEBODSYS, x = n)) +
  geom_col(fill = 'orange') + 
  labs(title = company,
       subtitle = study,
       x = "Counts",
       y = "AE Body System",
       caption = paste("Note: ",
                       environ,
                       basepath,
                       '.'))  

print(bs_plot)
