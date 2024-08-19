
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Misc Operations - Conditions

# Packages & Functions on Display:
# - {readr  2.1.2}: read_rds()
# - {base   4.2.0}: %in%, isTRUE(), isFALSE(), is.na(), is.null(), is.list(),
#                  is.vector(), is.numeric(), is.character(), is.data.frame(),
#                  any(), all(), sum(), ifelse(), if()


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)

# Load Data
df_adslvs <- read_rds("data/adslvs.rds") %>% print()


# The Basics --------------------------------------------------------------
# All conditionals will evaluate a single true or false

T; TRUE
F; FALSE


# Relational Operators ----------------------------------------------------

1 == 2
1 != 2
1 <  2
1 >  2
1 >= 2
1 <= 2


# Conditional Operators
(1 < 2) & (3 > 4)
(1 < 2) | (3 > 4)


# Checking Existence in a Vector ------------------------------------------

1  %in% 1:10
"A" %in% c("a", "b", "c")

!( 1  %in% 1:10)
!("A" %in% c("a", "b", "c"))


# Explicit Conditions -----------------------------------------------------

isTRUE(T); isFALSE(F)

isFALSE(1 == 2)

is.na(NA)
is.null(NULL)

is.list("a")
is.vector("a")
is.numeric("a")
is.character("a")
is.data.frame("a")            # And many more...


# Checking Many Conditions ------------------------------------------------

any(T, F, T)   # Are there any TRUE values?
all(T, F, T)   # Are all values TRUE?


# Check many different conditions
all(
  is.numeric(1),
  is.character("a"),
  is.data.frame(df_adslvs))


# Example:
is.na(df_adslvs$base_temp)
is.na(df_adslvs$base_temp) %>% any()   # Are there any NA values in a vector?
is.na(df_adslvs$base_temp) %>% sum()   # How many?





# If Else Statements ------------------------------------------------------
# ifelse() accepts a logical vector as input
# if() only accepts a single logical element as input

ifelse(T, "Yes", "No")
ifelse(c(T, T), "Yes", "No")


# Simple use case with ifelse()
ifelse(1 < 2, "Yes", "No")


# Complex use case with if()
vec_sample <- runif(100) %>% print()

if (mean(vec_sample) < 0.40) {

  # Add many operations inside brackets { }
  print("Less than 0.40")
  print(sd(vec_sample))
  print(summary(vec_sample))

} else if (mean(vec_sample) > 0.80) {

  print("Greater than 0.80")
  print(sd(1:100))
  print(month.abb)

} else {

  "The values is somewhere in the middle"

}



# Case When Statements ----------------------------------------------------
# case_when() is a vectorized version of if(), and allows for more complex
# conditionals than ifelse()

vec_sample <- runif(100) %>% print()

# Doesn't work with if()
if (vec_sample > .9) {print("90% - 100%")}


# But it works with case_when
case_when(
  vec_sample > .9 ~ "90% - 100%",
  vec_sample > .5 ~ "50% - 90%",
  vec_sample > .2 ~ "20% - 50%",
  TRUE            ~ "Everything Else"
)


# Tidyverse Pipeline
df_adslvs %>%
  transmute(
    subjid,
    arm,
    sex,
    base_pulse,
    pulse_cat =
      case_when(
        base_pulse > mean(base_pulse, na.rm = T) ~ "Above Avg",
        TRUE                                     ~ "Below Avg"))


# Documentation -----------------------------------------------------------

# Help Pages
help("Control")
help("ifelse")
help("case_when")

# Website References
# - https://www.w3schools.com/r/r_if_else.asp
# - https://r4ds.had.co.nz/functions.html#conditional-execution

# -------------------------------------------------------------------------
