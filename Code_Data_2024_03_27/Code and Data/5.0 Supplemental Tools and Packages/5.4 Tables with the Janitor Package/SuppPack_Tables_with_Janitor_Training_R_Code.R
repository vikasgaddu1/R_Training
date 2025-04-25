
# Anova Accel2R - Clinical R Training -----------------------------------

# Title: Tables and Data Cleaning with Janitor

# Packages & Functions on Display:
# - {janitor 2.0.1}: tabyl, adorn_*, get_dupes, clean_names


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
library(janitor)

# Load Data ---------------------------------------------------------------

data_demo <- tribble(
  ~study,    ~inv, ~patient, ~visit, ~screendate, ~sex, ~race, ~dob, ~treatment
  ,"StudyA", 1000, 1, 0,  parse_date('2020-01-03'), "M", "White",            parse_date('1990-01-31'), "Placebo"
  ,"StudyA", 1000, 2, 0,  parse_date('2020-01-02'), "F", "African American", parse_date('1989-12-09'), "Placebo"
  ,"StudyA", 1010, 3, 0,  parse_date('2020-01-03'), "M", "Asian",            parse_date('1992-02-26'), "Placebo"
  ,"StudyA", 1010, 4, 0,  parse_date('2020-01-03'), "M", "White",            parse_date('1991-07-04'), "Placebo"
  ,"StudyA", 1010, 5, 0,  parse_date('2020-01-02'), "F", "African American", parse_date('1990-06-30'), "Active"
  ,"StudyA", 1000, 7, 0,  parse_date('2020-01-03'), "M",  NA,                parse_date('1990-10-31'), "Active"
  ,"StudyA", 1000, 7, 0,  parse_date('2020-01-03'), "M", "White",            parse_date('1990-10-31'), "Active"
  ,"StudyA", 1000, 8, 0,  parse_date('2020-01-02'), "F", "African American", parse_date('1988-09-12'), "Active"
  ,"StudyA", 1010, 9, 0,  parse_date('2020-01-03'), "M", "Asian",            parse_date('1993-04-22'), "Active"
  ,"StudyA", 1010, 10, 0, parse_date('2020-01-03'), "M", "White",            parse_date('1994-09-05'), "Active"
)

# Summary Tables ----------------------------------------------------------

# Single Variable
data_demo %>%
  janitor::tabyl(race, show_na = TRUE)

# Two Variables
data_demo %>%
  janitor::tabyl(race, sex, show_na = FALSE)

# Three Variables
data_demo %>%
  janitor::tabyl(race, sex, treatment)



# Table Formatting --------------------------------------------------------

tbl_twoway <-
  data_demo %>%
  tabyl(race, sex) %>%
  print()

# Adding Totals
tbl_twoway %>%
  adorn_totals(where = c("row", "col"))


# Adding Percentages
tbl_twoway %>%
  adorn_percentages(denominator = "col") %>%
  adorn_pct_formatting(digits = 2, rounding = "half up")


# Adding Counts
tbl_twoway %>%
  adorn_percentages(denominator = "col") %>%
  adorn_pct_formatting() %>%
  adorn_ns(position = "front")

tbl_twoway %>%
  adorn_percentages(denominator = "col") %>%
  adorn_pct_formatting() %>%
  adorn_ns(position = "rear")


# Adding Titles
tbl_twoway %>%
  adorn_title(row_name = "Race Title", col_name = "Sex Title", placement = "top")

tbl_twoway %>%
  adorn_title(row_name = "Race Title", col_name = "Sex Title", placement = "combined")


# All Together
data_demo %>%
  tabyl(race, sex) %>%
  adorn_totals(where = "row") %>%
  adorn_percentages() %>%
  adorn_pct_formatting() %>%
  adorn_ns() %>%
  adorn_title(placement = "combined")


# Other Janitor Helpers ---------------------------------------------------

# Find Rows with Selected Duplicate Values
data_demo %>% get_dupes(patient, visit)
data_demo %>% get_dupes(sex)


# Quickly Clean Variable Names
tibble(`bad name 1`  = 1:10,
       `.bad name 2` = 1:10) %>%
  clean_names()


# Remove Empty and Constant Rows
data_2 <-
  tribble(~a, ~b, ~c, ~d,
           1,  1,  1, NA,
           1,  2,  3, NA,
           1,  5, 10, NA,
          NA, NA, NA, NA)

data_2
data_2 %>% remove_empty(which = "rows")
data_2 %>% remove_empty(which = "cols")
data_2 %>% remove_empty(which = c("rows", "cols"))

data_2
remove_constant(data.frame(A=1, B=1:3))
data_2 %>% remove_constant()
data_2 %>% remove_constant(na.rm = TRUE)


# Round Assistance
10.50 %>% base::round()
10.50 %>% janitor::round_half_up()


# Data Comparison
data_demo %>% glimpse()

data_demo_alt <-
  tibble(study = 1, inv = "1000", patient = "01", visit = "00") %>%
  print()

compare_df_cols(data_demo, data_demo_alt)


# Documentation -----------------------------------------------------------

# Vignettes
vignette("tabyls",  package = "janitor")
vignette("janitor", package = "janitor")


# Help Pages
help("tabyl",             package = "janitor")
help("adorn_ns",          package = "janitor")
help("adorn_totals",      package = "janitor")
help("adorn_percentages", package = "janitor")


# Website References
# - https://sfirke.github.io/janitor
# - https://github.com/sfirke/janitor

# Equivalent Operations ---------------------------------------------------

help(table,  package = "base")
help(xtabs,  package = "stats")
help(ftable, package = "stats")

# -------------------------------------------------------------------------
