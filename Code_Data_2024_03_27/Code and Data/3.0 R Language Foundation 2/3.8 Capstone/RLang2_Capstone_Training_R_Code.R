# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved


library(randomNames)
source("3.8 Capstone/RLang2_Capstone_Exercise_Formats.R")

# Create sample data ------------------------------------------------------


# Add Missing Values
subjid <- 100:109
name <- randomNames(10)
sex <- factor(c("M", "F", NA, "M", "M", "F", "M", "F", "F", "M"),
              levels =  c("M", "F", "UNK"))
age <- c(41, 53, 43, 39, 47, 52, 21, NA, 62, 26)
arm <- c(rep("A", 5), rep("B", 5))

# Create data frame
df <- data.frame(subjid, name, sex, age, arm)
df


# Add age category
df$agec <- factor(age_cat(df$age),
                  levels = c("< 18", "18 to 23",
                             "24 to 44", "45 to 59", ">= 60"))
df
str(df)

# Set up vectors ----------------------------------------------------------


age_stub <- c("Age", rep("", 3))
age_labels <- c("n", "Mean", "Median", "Range")
agec_stub <- c("Age Group", rep("", 5))
sex_stub <- c("Sex", rep("", 3))
arm_decode <- c(A = "Placebo", B = "Treatment 1")


# Perform Calculations ----------------------------------------------------


# Calculate summary statistics for age
age_pop <- sum(!is.na(df$age))
age_stats <- c(age_pop,
               sprintf("%.1f", mean(df$age, na.rm = TRUE)),
               sprintf("%.1f", median(df$age, na.rm = TRUE)),
               range_fmt(range(df$age, na.rm = TRUE)))

# Calculate frequencies for age group
agec_freq <- table(df$agec)
agec_stats <- c(age_pop, cnt_pct(agec_freq, age_pop))


# Calculate frequencies for sex
sex_freq <- table(df$sex)
sex_pop <- sum(!is.na(df$sex))
sex_stats <- c(sex_pop, cnt_pct(sex_freq, sex_pop))


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

agec_df <- data.frame(stub = agec_stub,
                      labels = c("n", levels(df$agec)),
                      stats = agec_stats)
agec_df

# Create data frame for sex statistics
sex_df <- data.frame(
  stub = sex_stub,
  labels = c("n", sex_fmt(names(sex_freq))),
  stats = sex_stats,
  row.names = NULL
)
sex_df

# Append everything into demog table
demog <- rbind(age_df, blank, agec_df, blank, sex_df)
demog

# Apply label
attr(demog$stats, "label") = "All Patients"
demog

# View in data frame viewer
View(demog)
