# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# We are going to construct a narrative string using two methods. The narrative string will be built using
# data from the invdata_new.rds file in your course level directory. Use the following steps:
#  a.	Read in the invdata_new.rds file into a data frame.
#  b.	Calculate summary statistics for the number of rows, mean yearsexp, minimum years experience,
#      and maximum experience.
#  c.	The narrative string should look like the following:
# "Investigators across <number of rows> sites had an average <mean years experience> years of experience
# ranging from <minimum years experience> to <maximum years experience> years."

#  d.	First construct the narrative string using a paste method using only the paste() function.
#  e.	Second construct the narrative string using only the sprintf() function. In this narrative, format
#      the mean years experience forcing one decimal place.

# Exercise Step 3.a
invdata <- readRDS('_data/invdata_new.rds')
invdata

# Exercise Step 3.b
site_stats <- c(
  nrows = nrow(invdata),
  meanye = mean(invdata$yearsexp),
  minye = min(invdata$yearsexp),
  maxye = max(invdata$yearsexp)
)


# Exercise Step 3.d
inv_narrative <- paste(
  "Investigators across",
  site_stats['nrows'],
  "sites had an average",
  site_stats['meanye'],
  "years of experience ranging from",
  site_stats['minye'],
  "to",
  site_stats['maxye'],
  "years."
)
inv_narrative

# Exercise Step 3.e
inv_narrative2 <- paste(
  "Investigators across",
  site_stats['nrows'],
  "sites had an average",
  site_stats['meanye'],
  "years of experience ranging from",
  site_stats['minye'],
  "to",
  site_stats['maxye'],
  "years.", sep = '~/~'
)
inv_narrative2

# sprintf() Exercises -----------------------------------------

# Exercise Step 3.a
inv_narrative2 <-
  sprintf(
    "Investigators across %d sites had an average %.1f years of experience ranging from %d to %d years.",
    site_stats['nrows'],
    site_stats['meanye'],
    site_stats['minye'],
    site_stats['maxye']
  )
inv_narrative2


# Use cases Exericises --------------------------------

# Exercise Step 3
# Using data from the raw_vitals.rds frame stored in the course level directory, create a data frame
# that looks like the following when printed to the console. Estimated Mean Arterial Pressure formula is: (2/3)*DP + (1/3)*SP.
#                    Measure                 Statistic    Day1_Site01    Day1_Site09
# 1        Systolic/Diastolic                         N              8             12
# 2                                           # Missing              2              0
# 3                                                Mean (121.8 / 78.0) (120.7 / 77.2)
# 4
# 5    Mean Arterial Pressure                         N              8             12
# 6                                           # Missing              2              0
# 7                                                Mean          92.58          91.67
# 8                                             Minimum           78.7           84.0
# 9                                             Maximum          111.3          100.0
vs_data <- readRDS('_data/raw_vitals.rds')

vs_data$MAP <- (2 / 3) * vs_data$DIABP + (1 / 3) * vs_data$SYSBP

vs_09 <-
  vs_data[substring(vs_data$SUBJECT, 1, 2) == '09' &
            vs_data$VISIT == 'day1',
          c('SUBJECT', 'DIABP', 'SYSBP', 'MAP')]
vs_01 <-
  vs_data[substring(vs_data$SUBJECT, 1, 2) == '01' &
            vs_data$VISIT == 'day1',
          c('SUBJECT', 'DIABP', 'SYSBP', 'MAP')]

Measure <-
  c('Systolic/Diastolic',
    '',
    '',
    '',
    'Mean Arterial Pressure',
    '',
    '',
    '',
    '')
Measure <- format(Measure, width = 25, justify = 'right')

Statistic <-
  c('N',
    '# Missing',
    'Mean',
    '',
    'N',
    '# Missing',
    'Mean',
    'Minimum',
    'Maximum')
Statistic <- format(Statistic, width = 25, justify = 'right')

Day1_Site01 <-
  c(
    sum(!is.na(vs_01$SYSBP)),
    sum(is.na(vs_01$SYSBP)),
    sprintf(
      "(%.1f / %.1f)",
      mean(vs_01$SYSBP, na.rm = TRUE),
      mean(vs_01$DIABP, na.rm = TRUE)
    ),
    ' ',
    sum(!is.na(vs_01$MAP)),
    sum(is.na(vs_01$MAP)),
    sprintf("%.2f", mean(vs_01$MAP, na.rm = TRUE)),
    sprintf("%.1f", min(vs_01$MAP, na.rm = TRUE)),
    sprintf("%.1f", max(vs_01$MAP, na.rm = TRUE))
  )

Day1_Site01 <- format(Day1_Site01, width = 25, justify = 'right')

Day1_Site09 <-
  c(
    sum(!is.na(vs_09$SYSBP)),
    sum(is.na(vs_09$SYSBP)),
    sprintf(
      "(%.1f / %.1f)",
      mean(vs_09$SYSBP, na.rm = TRUE),
      mean(vs_09$DIABP, na.rm = TRUE)
    ),
    ' ',
    sum(!is.na(vs_09$MAP)),
    sum(is.na(vs_09$MAP)),
    sprintf("%.2f", mean(vs_09$MAP, na.rm = TRUE)),
    sprintf("%.1f", min(vs_09$MAP, na.rm = TRUE)),
    sprintf("%.1f", max(vs_09$MAP, na.rm = TRUE))
  )

Day1_Site09 <- format(Day1_Site09, width = 25, justify = 'right')



vs_results <-
  data.frame(Measure, Statistic, Day1_Site01, Day1_Site09)

vs_results
