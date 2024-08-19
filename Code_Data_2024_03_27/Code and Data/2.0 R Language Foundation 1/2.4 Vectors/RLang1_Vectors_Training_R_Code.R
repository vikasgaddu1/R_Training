
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Vector
age <- c(41, 53, 43, 39, 47, 52, 21, 38, 62, 26)

print(age)

# Vector Subsetting
age[7]                  # Single position subset
age[c(1, 2, 3)]         # Vector of positions
age[1:5]                # Sequence of positions
age[-7]                 # Negative positions
age[-(1:5)]             # Negative sequence
age[c(1, 2, 1, 3, 3)]   # Repeated positions
age[age > 40]           # Logical expressions
age[2] <- 54            # Position assignment
print(age)

# Vectorized functions
length(age)
class(age)
sort(age)
sum(age)
mean(age)
median(age)
min(age)
max(age)
range(age)

# Named vectors
age_named <- c(
  s1 = 41,
  s2 = 53,
  s3 = 43,
  s4 = 39,
  s5 = 47,
  S6 = 52,
  S7 = 21,
  s8 = 38,
  s9 = 62,
  s10 = 26
)

print(age_named)

# Vector attributes
length(age_named)
class(age_named)
mean(age_named)
names(age_named)
names(age)

# Named Vector subsetting
age_named[3]                                # Position subset
age_named["s3"]                             # Named subset
age_named["s2"] <- 54                       # Named assignment
age_named[c("s1", "s2", "s3")]              # Vector of names
age_named[c("s1", "s2", "s1", "s3", "s2")]  # Repeated names

# Using named vectors as decodes
sex <- c("M", "F", "F", "M", "M", "F", "M", "F", "F", "M")
sex_decode <- c(M = "Male", F = "Female")

sex_decode[sex]     # Decode
