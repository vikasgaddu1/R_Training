
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

library(randomNames)

# Create sample data ------------------------------------------------------

subjid <- 100:109
name <- randomNames(10)
sex <- factor(c("M", "F", "F", "M", "M", "F", "M", "F", "F", "M"),
              levels =  c("M", "F", "UNK"))
age <- c(41, 53, 43, 39, 47, 52, 21, 38, 62, 26)
arm <- c(rep("A", 5), rep("B", 5))

# Create data frame
df <- data.frame(subjid, name, sex, age, arm)
df


# Set up vectors ----------------------------------------------------------


age_stub <- c("Age", rep("", 4))
age_labels <- c("n", "Mean", "Median", "Min", "Max")
sex_stub <- c("Sex", rep("", 2))
sex_decode <- c(M = "Male", F = "Female", UNK = "Unknown")
arm_decode <- c(A = "Placebo", B = "Treatment 1")


# Perform Calculations ----------------------------------------------------


# Calculate summary statistics for age
age_stats <- c(nrow(df),
               mean(df$age),
               median(df$age),
               min(df$age),
               max(df$age))

# Calculate frequencies for age
sex_freq <- table(df$sex)
sex_stats <- c(sex_freq["M"],
               sex_freq["F"],
               sex_freq["UNK"])


# Create demog table ------------------------------------------------------


# Create data frame for age statistics
age_df <- data.frame(stub = age_stub,
                     labels = age_labels,
                     stats = age_stats)

age_df

# Create data frame for blank row
blank <- data.frame(stub = "",
                    labels = "",
                    stats = "")

# Create data frame for sex statistics
sex_df <- data.frame(
  stub = sex_stub,
  labels = sex_decode[names(sex_freq)],
  stats = sex_stats,
  row.names = NULL
)
sex_df

# Append everything into demog table
demog <- rbind(age_df, blank, sex_df)
demog

# Apply label
attr(demog$stats, "label") = "All Patients"
demog

# View in data frame viewer
View(demog)
