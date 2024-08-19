# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Setup -------------------------------------------------------------------

# Exercise Step 3
library(tidyverse)
library(fmtr)
library(haven)


# Exercise Step 4
crf_dm <-
  read_sas("data/abc_crf_dm.sas7bdat") %>%
  select(SUBJECT, BIRTHDT, ETHNIC, RACE, SEX) %>%
  mutate(
    SITEID = substring(SUBJECT, 1, 2),
    SUBJECTID = substring(SUBJECT, 4, 6),
    AGE = as.numeric(floor((
      as.Date("2005-2-02") - BIRTHDT
    ) / 365.25))
  ) %>%
  select(SITEID, SUBJECTID, BIRTHDT, AGE,  ETHNIC, RACE, SEX)

unique(crf_dm$SITEID)

# Exercise Step 5
# Create user-defined format for
site_fmt <-
  value(
    condition(x == "03" | x == "06" | x == "09", "Area 1", order = 1),
    condition(x == "04" |
                x == "08" | x == "01", "Area 2", order = 2),
    condition(TRUE, "Area 51", order = 3)
  )

sex_fmt <- value(
  condition(x == 0, "Male", order = 1),
  condition(x == 1, "Female", order = 2),
  condition(TRUE, "Missing")
)

race_fmt <-
  value(
    condition(x == 1, "American Indian/Alaskan Native"),
    condition(x == 2, "Asian"),
    condition(x == 3, "Native Hawaiian or other Pacific Islander"),
    condition(x == 4, "Black or African American"),
    condition(x == 5, "White"),
    condition(x == 6, "Unknown or not Reported"),
    condition(TRUE, "Missing")
  )

ethnic_fmt <- value(
  condition(x == 1, "Hispanic or Latino"),
  condition(x == 2, "Not Hispanic or Latino"),
  condition(x == 3, "Unknown or not Reported"),
  condition(TRUE, "Missing")
)


# Exercise Step 6
age_fmt <- value(
  condition(is.na(x) | trimws(x) == "", "Missing"),
  condition(x < 25, "< 25 years old"),
  condition(x >= 25 & x <= 50, "25-50 years old"),
  condition(x > 50, "> 50 years old")
)

# Exercise Step 8
formats(crf_dm) <- list(
  SITEID = site_fmt,
  RACE = race_fmt,
  ETHNIC = ethnic_fmt,
  SEX = sex_fmt,
  BIRTHDT = "%m %d %Y"
)

# Exercise Steps 8 and 10
crf_dm_with_formats <-
  fdata(crf_dm)

# Exercise Step 11
crf_dm_with_formats$AGEGROUP <-
  fapply(crf_dm_with_formats$AGE, age_fmt)


# Exercise Step 12
crf_dm_long <-
  crf_dm %>%
  pivot_longer(
    cols = c(SEX, ETHNIC, RACE, AGE),
    names_to = 'varname',
    values_to = 'value'
  )

value_fmt <- flist(
  type = "row",
  lookup = crf_dm_long$varname,
  SEX    = sex_fmt,
  RACE   = race_fmt,
  ETHNIC = ethnic_fmt,
  AGE    = age_fmt
)

# Exercise Step 13
crf_dm_long$Value_Formatted <- fapply(crf_dm_long$value, value_fmt)
crf_dm_long$SITE_AREA <- fapply(crf_dm_long$SITEID, site_fmt)

# Exercise Step 14
fmt_n(crf_dm$SEX)
fmt_cnt_pct(crf_dm$SEX)
fmt_mean_sd(crf_dm$AGE)
fmt_median(crf_dm$AGE)
fmt_range(crf_dm$AGE)
fmt_quantile_range(crf_dm$AGE)

# Exercise Step 15
# Calculate summary statistics for each patient
summary_age <-
  crf_dm %>%
  group_by(SITEID) %>%
  summarize(
    n = fmt_n(AGE),
    "Mean (SD)" = fmt_mean_sd(AGE),
    Median = fmt_median(AGE),
    "Q1 - Q3" = fmt_quantile_range(AGE),
    "Min - Max" = fmt_range(AGE)
  )

denom <- nrow(crf_dm)

freq_resp <-
  crf_dm_with_formats %>%
  group_by(SEX) %>%
  summarize(n = fmt_cnt_pct(n(), denom))



