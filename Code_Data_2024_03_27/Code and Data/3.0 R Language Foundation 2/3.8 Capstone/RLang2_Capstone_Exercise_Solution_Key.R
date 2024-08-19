# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

source("formats.R")

# Create sample data ------------------------------------------------------

# Exercise Step 4.c
df <- readRDS('dm.rds')

# Exercise Step 4.d
df <-
  df[df$ARM != "SCREEN FAILURE", c('SUBJID', 'ARM', 'AGE', 'SEX')]

# Exercise Step 4.e
# ARM format copy this to formats.R in course level directory.
# arm_fmt  <- function(x) {
#  ifelse(x == 'ARM A', "Placebo", "Active")
# }

# Exercise Step 4.f
df$ReportARM <- arm_fmt(df$ARM)

# Add age category
df$agec <- factor(age_cat(df$AGE),
                  levels = c("< 18", "18 - 23",
                             "24 - 44", "45 - 59", ">= 60"))
df
str(df)

# Set up vectors ----------------------------------------------------------


age_stub <- c("Age", rep("", 3))
age_labels <- c("n/ # missing", "Mean", "Median", "Range")
agec_stub <- c("Age Group", rep("", 5))
sex_stub <- c("Sex", rep("", 2))

# Perform Calculations ----------------------------------------------------

# Split data frame into two. One for Active and one for Placebo.
df_active <- subset(df, df$ReportARM == "Active")
df_placebo <- subset(df, df$ReportARM == "Placebo")


# First generate statistics for Active
# Calculate summary statistics for age
age_n_active <- sum(!is.na(df_active$AGE))
age_nmiss_active <- sum(is.na(df_active$AGE))

age_stats_active <-
  c(
    sprintf("%d / %d", age_n_active, age_nmiss_active),
    sprintf("%.1f", mean(df_active$AGE, na.rm = TRUE)),
    sprintf("%.1f", median(df_active$AGE, na.rm = TRUE)),
    range_fmt(range(df_active$AGE, na.rm = TRUE))
  )


agec_freq_active <- table(df_active$agec)
agec_stats_active <-
  c(
    sprintf("%d / %d", age_n_active, age_nmiss_active),
    cnt_pct(agec_freq_active, age_n_active)
  )


# Calculate frequencies for sex
sex_freq_active <- table(df_active$SEX)
sex_n_active <- sum(!is.na(df_active$SEX))
sex_nmiss_active <- sum(is.na(df_active$SEX))

sex_stats_active <-
  c(
    sprintf("%d / %d", sex_n_active, sex_nmiss_active),
    cnt_pct(sex_freq_active, sex_n_active)
  )



# Now generate statistics for Placebo
age_n_placebo <- sum(!is.na(df_placebo$AGE))
age_nmiss_placebo <- sum(is.na(df_placebo$AGE))

age_stats_placebo <-
  c(
    sprintf("%d / %d", age_n_placebo, age_nmiss_placebo),
    sprintf("%.1f", mean(df_placebo$AGE, na.rm = TRUE)),
    sprintf("%.1f", median(df_placebo$AGE, na.rm = TRUE)),
    range_fmt(range(df_placebo$AGE, na.rm = TRUE))
  )



# Calculate frequencies for age group
agec_freq_placebo <- table(df_placebo$agec)
agec_stats_placebo <-
  c(
    sprintf("%d / %d", age_n_placebo, age_nmiss_placebo),
    cnt_pct(agec_freq_placebo, age_n_placebo)
  )


# Calculate frequencies for sex
sex_freq_placebo <- table(df_placebo$SEX)
sex_n_placebo <- sum(!is.na(df_placebo$SEX))
sex_nmiss_placebo <- sum(is.na(df_placebo$SEX))
sex_stats_placebo <-
  c(
    sprintf("%d / %d", sex_n_placebo, sex_nmiss_placebo),
    cnt_pct(sex_freq_placebo, sex_n_placebo)
  )




# Calculate frequencies for sex
sex_freq <- table(df$SEX)


# Create demog table ------------------------------------------------------


# Create data frame for age statistics
age_df <- data.frame(
  stub = age_stub,
  labels = age_labels,
  stats_active = age_stats_active,
  stats_placebo = age_stats_placebo
)


# Create data frame for age category statistics
agec_df <- data.frame(
  stub = agec_stub,
  labels        = c("n / # missing", levels(df$agec)),
  stats_active  = agec_stats_active,
  stats_placebo = agec_stats_placebo
)

# Create data frame for sex statistics
sex_df <- data.frame(
  stub = sex_stub,
  labels = c("n / # missing", sex_fmt(names(sex_freq))),
  stats_active = sex_stats_active,
  stats_placebo = sex_stats_placebo,
  row.names = NULL
)

# Create data frame for blank row
blank <- data.frame(
  stub = "",
  labels = "",
  stats_active = "",
  stats_placebo = ""
)


# Append everything into demog table
demog <- rbind(age_df, blank, agec_df, blank, sex_df)
demog

# Apply label to demog variables
attr(demog$stub, "label") = "Measure"
attr(demog$labels, "label") = "Statistic"
attr(demog$stats_active, "label") = sprintf("Acive (N=%d)", nrow(df_active))
attr(demog$stats_placebo, "label") = sprintf("Placebo (N=%d)", nrow(df_placebo))
demog

# Exercise Step 4.h
# View in data frame viewer
View(demog)
