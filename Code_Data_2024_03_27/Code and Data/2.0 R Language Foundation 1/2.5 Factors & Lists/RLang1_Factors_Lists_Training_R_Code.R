
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Simple Frequencies ------------------------------------------------------

# Using named vectors as decodes
arm <- c("A", "A", "A", "B", "A", "B", "A", "B", "A", "B")
arm_decode <- c(A = "Placebo", B = "Active (50 mg)")
arm_decode[arm]

# Simple frequencies with table()
arm_freq <- table(arm)
print(arm_freq)
a_pop <- arm_freq["A"]
a_pop
b_pop <- arm_freq["B"]
b_pop

# Zero categorical values
arm_decode <-
  c(A = "Placebo", B = "Active (50 mg)", C = "Active (100 mg)")
table(arm_decode[arm])  # Does not work


# Factors -----------------------------------------------------------------

# Factor Introduction
arm_f <- factor(arm, levels = c("A", "B", "C"))
print(arm_f)
levels(arm_f)
arm_freq <- table(arm_f)
arm_freq

c_pop <- arm_freq["C"]
c_pop

arm_decode_f <- factor(arm_decode,
                       levels = c("Placebo", "Active (50 mg)", "Active (100 mg)"))
print(arm_decode_f)
table(arm_decode_f[arm])



# Factor Data Integrity ---------------------------------------------------


# Factors Will enforce data integrity
arm_f[length(arm_f) + 1] <- "X"  # Warning
levels(arm_f)

# Add a new level
levels(arm_f) <- c("A", "B", "C", "X")
levels(arm_f)

# Add new level value to data
arm_f[length(arm_f)] <- "X"      # No warning
arm_f


# Lists -------------------------------------------------------------------

# Mixed data types become character by default
vec1 <- c("a", 1, TRUE, as.Date("2020-06-20"))
print(vec1)

# A list can hold any data type
lst1 <- list("a", 1, TRUE, as.Date("2020-06-20"))
print(lst1)

# Named List
lst2 <- list(
  var1 = "a",
  var2 = 1,
  var3 = TRUE,
  var4 = as.Date("2020-06-20")
)
print(lst2)

lst2[4]
lst2["var4"]        # Subset
lst2["var2"] <- 2   # Assign
lst2["var2"]

lst2$var4           # Subset
lst2$var2 <- 3      # Assign
lst2$var2
