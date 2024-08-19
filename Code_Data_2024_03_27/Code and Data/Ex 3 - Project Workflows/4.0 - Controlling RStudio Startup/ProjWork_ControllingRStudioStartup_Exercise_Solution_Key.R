# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Controlling RStudio Startup with the R Profile
# Exercise Solution Key

# Packages & Functions on Display:
# - {usethis 2.0.1}: edit_r_profile

print("Welcome back!")

setwd("/cloud/project")
print(paste("Current working directory", getwd()))

cat(paste(Sys.info()[["user"]], "on", "\n",
          Sys.info()[["sysname"]], "\n",
          Sys.info()[["version"]]
    )
)
