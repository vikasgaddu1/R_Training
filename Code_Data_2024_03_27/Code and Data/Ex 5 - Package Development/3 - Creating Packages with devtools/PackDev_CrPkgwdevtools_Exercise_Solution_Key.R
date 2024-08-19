
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Creating Packages with devtools Exercise Solution Key

# Setup -------------------------------------------------------------------

library(devtools)

create_package("first_package")

# now do same for creating a tidy package.
library(devtools)

# move up one directory to get out of the firstpackage directory.
setwd('../')

create_tidy_package("first_tidypackage")

