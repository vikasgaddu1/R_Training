
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Misc Operations - Loops

# Packages & Functions on Display:
# - {base 4.2.0}: for(), list()


# Loops -------------------------------------------------------------------
# Working with loops is generally not recommended in R, because everything is
# vectorized, and loops can be avoided in most situations

# A Loop
for (i in 1:10){
  print(i + 1)
}


# A Vectorized Operation Instead
1:10 + 1


# Modifying an Object in a Loop
init_list <- list()
for (i in 1:10){
  init_list[[i]] <- letters[i]
}
init_list


# Documentation -----------------------------------------------------------

# Help Pages
help("Control")

# Website References
# - https://www.w3schools.com/r/r_for_loop.asp
# - https://r4ds.had.co.nz/iteration.html#for-loops
# - https://r4ds.had.co.nz/iteration.html#for-loops-vs.-functionals

# -------------------------------------------------------------------------
