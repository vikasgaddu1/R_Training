# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Create sample data ------------------------------------------------------
subjid <- 100:109
sex <- factor(c("M", "F", "F", "M", "M", "F", "M", "F", "F", "M"),
              levels =  c("M", "F", "UNK"))
age <- c(41, 53, 43, 39, 47, 52, 21, 38, 62, 26)
arm <- c(rep("A", 5), rep("B", 5))

# Create data frame
df <- data.frame(subjid, sex, age, arm)
df


# Set up vectors ----------------------------------------------------------


age_stub   <- c("Age", rep("", 4))
age_labels <- c("n", "Mean", "Median", "Min", "Max")
sex_stub   <- c("Sex", rep("", 2))
sex_decode <- c(M = "Male", F = "Female", UNK = "Unknown")
arm_decode <- c(A = "Placebo", B = "Treatment 1")


# Perform Calculations ----------------------------------------------------

# Approach - split data into separate arms, perform calculations for each arm,
#           put together for final demog table.
# by treatment arm so let's split the data frame df into df_a and df_b

df_a <- subset(df, df$arm == 'A')
df_b <- subset(df, df$arm == 'B')

# Calculate summary statistics for age for arm A
age_stats_a <- c(nrow(df_a),
                 mean(df_a$age),
                 median(df_a$age),
                 min(df_a$age),
                 max(df_a$age))

# Calculate summary statistics for age  for arm B
age_stats_b <- c(nrow(df_b),
                 mean(df_b$age),
                 median(df_b$age),
                 min(df_b$age),
                 max(df_b$age))


# Calculate frequencies for sex for arm A
sex_freq_a <- table(df_a$sex)
sex_stats_a <- c(sex_freq_a["M"],
                 sex_freq_a["F"],
                 sex_freq_a["UNK"])

# Calculate frequencies for sex for arm B
sex_freq_b <- table(df_b$sex)
sex_stats_b <- c(sex_freq_b["M"],
                 sex_freq_b["F"],
                 sex_freq_b["UNK"])


# Create demog table ------------------------------------------------------


# Create data frame for age statistics
age_df <- data.frame(
  stub        = age_stub,
  labels      = age_labels,
  stats_a     = age_stats_a,
  stats_b     = age_stats_b
)

age_df

# Create data frame for blank row
blank <- data.frame(
  stub        = "",
  labels      = "",
  stats_a     = "",
  stats_b     = ""
)

# Create data frame for sex statistics
sex_df <- data.frame(
  stub        = sex_stub,
  labels      = sex_decode,
  stats_a     = sex_stats_a,
  stats_b     = sex_stats_b,
  row.names   = NULL
)
sex_df

# Append everything into demog table
demog <- rbind(age_df, blank, sex_df)
demog

# Apply labels
attr(demog$stub,        "label") = "Variable"
attr(demog$labels,      "label") = "Statistic"
attr(demog$stats_a,     "label") = "Arm A"
attr(demog$stats_b,     "label") = "Arm B"
demog

# View in data frame viewer
View(demog)
