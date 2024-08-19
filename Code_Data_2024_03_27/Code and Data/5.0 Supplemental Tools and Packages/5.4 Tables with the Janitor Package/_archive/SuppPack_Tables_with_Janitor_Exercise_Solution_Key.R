# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Setup -------------------------------------------------------------------

# Load Packages

library(tidyverse)
library(janitor)

# abc_dm <- read_sas("abc_crf_dm.sas7bdat",
#                   col_select = c('STUDYID', 'SUBJECT', 'BIRTHDT', 'SEX', 'RACE')) %>%
#  mutate(BIRTHDT = case_when(SUBJECT == '03-005' ~ as.Date("2052-12-10"),
#                             TRUE ~  BIRTHDT))
#
# abc_dm2 <- read_sas("abc_crf_dm.sas7bdat",
#                    col_select = c('STUDYID', 'SUBJECT', 'BIRTHDT', 'SEX', 'RACE')) %>%
#  filter(substring(SUBJECT, 1, 2) == "06")
#
# abc_dm_unclean <-
#  bind_rows(abc_dm, abc_dm2) %>%
#  rename(`Birth Date` = BIRTHDT,
#         `$Study&ID` = STUDYID,
#         `.S E X!` = SEX)
#
# saveRDS(abc_dm_unclean, 'abc_dm_unclean.rds')

# Exercise Step 3.a
abc_dm_unclean <- readRDS('data/abc_dm_unclean.rds') %>% glimpse()

# Exercise Steps 3.b, 3.c, 3.d, 3.e, 3.f
abc_dm_clean <-
  abc_dm_unclean %>%
  clean_names() %>%
  remove_constant() %>%
  mutate(birth_date = case_when(subject == '03-005' ~ as.Date("1952-12-10"),
                                TRUE ~  birth_date)) %>%
  distinct_all()

# saveRDS(abc_dm_clean, 'abc_dm_valid.rds')

# Exercise Step 3.g
abc_dm_valid <- readRDS('data/abc_dm_valid.rds')

compare_df_cols(abc_dm_clean, abc_dm_valid)
identical(abc_dm_clean, abc_dm_valid)
abc_dm_clean == abc_dm_valid

# Exercise Step 4.a - 4.f
# Combine and prepare demographic data
# Combine and prepare demographic data
dm_prep <-
  abc_dm_clean %>%
  mutate(
    Age = floor((parse_date('2020-01-01') - birth_date) / 365.25),
    AgeCat = case_when(
      Age < 50 ~ "Under 50",
      Age >= 50 & Age < 65 ~ "50-64",
      Age >= 65 ~ "At least 65"
    ),
    Sex = ifelse(s_e_x == 0, "Male", "Female"),
    Site = substring(subject, 1, 2),
    patid = as.numeric(substring(subject, 4, 6)),
    BlindCode = case_when(
      patid %% 3 == 0 ~ "Placebo",
      patid %% 3 == 1 ~ "Active 50mg",
      patid %% 3 == 2 ~ "Active 100mg"
    )
  )

# Exercise Step 4.g
dm_prep$Sex2 <- factor(
  dm_prep$s_e_x,
  levels = dm_prep$s_e_x,
  labels = dm_prep$Sex,
  ordered = TRUE
)

dm_prep$BlindCode2 <-
  factor(
    dm_prep$BlindCode,
    levels = c("Placebo", "Active 50mg", "Active 100mg"),
    ordered = TRUE
  )

dm_prep$AgeCat2 <- factor(
  dm_prep$AgeCat,
  levels = c('Under 50', '50-64', 'At least 65'),
  ordered = TRUE
)

# Exerise Step 5

# Output #1
sex <-
  dm_prep %>%
  tabyl(Sex2) %>%
  adorn_totals(where = c("row")) %>%
  adorn_pct_formatting(digits = 1, rounding = "half up")

# Output #2
agecat <-
  dm_prep %>%
  tabyl(AgeCat2) %>%
  adorn_totals(where = c("row")) %>%
  adorn_pct_formatting(digits = 1, rounding = "half up")

# output #3
agecatbysex <-
  dm_prep %>%
  tabyl(AgeCat2, Sex2) %>%
  adorn_totals(where = c("row", "col"))


# output #4
sitebyblindcodebysex <-
  dm_prep %>%
  tabyl(Site, BlindCode2, Sex2) %>%
  adorn_totals(where = c("row", "col")) %>%
  adorn_percentages(denominator = "row") %>%
  adorn_pct_formatting(digits = 1, rounding = "half up") %>%
  adorn_ns(position = "front") %>%
  adorn_title(row_name = "Site",
              col_name = "Treatment",
              placement = "combined") %>%
  print()

# Exercise Step 7
male <- sitebyblindcodebysex$Male

male_stub <- rep(c("Male", " "), times = c(1, nrow(male) - 1))

males <-
  data.frame(male_stub, male) %>%
  rename(Sex = male_stub)


female <- sitebyblindcodebysex$Female

female_stub <- rep(c("Female", " "), times = c(1, nrow(female) - 1))

females <-
  data.frame(female_stub, female) %>%
  rename(Sex = female_stub)

both <-
  bind_rows(males, females)

# Exercise Step 8
bypoint5 <- seq(from = 0, to = 10, by = .5)

# Exercise Step 9
byp_df <-
  data.frame(bypoint5, round(bypoint5), round_half_up(bypoint5))

