# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)

# Exercise Step 2
v1 <- c(1, 2, 3, 4, 5)
print(v1)
class(v1)
typeof(v1)
length(v1)

# Exercise Step 3
v2 <- c("1", "2", "3")
print(v2)
class(v2)
typeof(v2)
length(v2)

# Exercise Step 4
v3 <- c(1, "B", 3)
print(v3)
class(v3)
typeof(v3)
length(v3)

# Exercise Step 5
nv1 <- c("A" = "ARM 1", "B" = "ARM 2", "C" = "ARM 3")

nv1_1 <- nv1[c(1, 3)]

nv1_2 <- nv1[c("A", "C")]
