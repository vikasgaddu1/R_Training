# Set working folder
setwd("/cloud/project/Code_Data_2024_03_27/Code and Data/admiral")

# Uncomment line below if you need to install these packages
# install.packages(c("dplyr", "lubridate", "stringr", "tibble", "pharmaversesdtm", "admiral"))

library(dplyr, warn.conflicts = FALSE)
library(lubridate)
library(stringr)
library(tibble)
library(pharmaversesdtm)
library(admiral)

# Read in SDTM datasets
dm <- pharmaversesdtm::dm
ds <- pharmaversesdtm::ds
ex <- pharmaversesdtm::ex
vs <- pharmaversesdtm::vs

adsl <- dm %>%
  mutate(TRT01P = ARM, TRT01A = ACTARM)

# impute start and end time of exposure to first and last respectively,
# do not impute date
ex_ext <- ex %>%
  derive_vars_dtm(
    dtc = EXSTDTC,
    new_vars_prefix = "EXST"
  ) %>%
  derive_vars_dtm(
    dtc = EXENDTC,
    new_vars_prefix = "EXEN",
    time_imputation = "last"
  )

ex_ext |> 
  filter(EXDOSE > 0 |
           (EXDOSE == 0 &
              str_detect(EXTRT, "PLACEBO")) & !is.na(EXSTDTM)) |> 
  arrange(STUDYID, USUBJID, EXSTDTM, EXSEQ) |> 
  select(STUDYID, USUBJID, EXSTDTM, EXSTTMF, EXSEQ) |>
  group_by(STUDYID, USUBJID) |> 
  slice(1) |> 
  ungroup() |> 
  select(-EXSEQ) |> 
  arrange(STUDYID, USUBJID, EXSTDTM) |> 
  mutate(TRTSDTM = EXSTDTM) |> 
  select(-EXSTDTM, -EXSTTMF) |> 
  print()

adsl1 <- adsl %>%
  derive_vars_merged(
    dataset_add = ex_ext,
    filter_add = (EXDOSE > 0 |
                    (EXDOSE == 0 &
                       str_detect(EXTRT, "PLACEBO"))) & !is.na(EXSTDTM),
    new_vars = exprs(TRTSDTM = EXSTDTM, TRTSTMF = EXSTTMF),
    order = exprs(EXSTDTM, EXSEQ),
    mode = "first",
    by_vars = exprs(STUDYID, USUBJID)
  ) %>%
  derive_vars_merged(
    dataset_add = ex_ext,
    filter_add = (EXDOSE > 0 |
                    (EXDOSE == 0 &
                       str_detect(EXTRT, "PLACEBO"))) & !is.na(EXENDTM),
    new_vars = exprs(TRTEDTM = EXENDTM, TRTETMF = EXENTMF),
    order = exprs(EXENDTM, EXSEQ),
    mode = "last",
    by_vars = exprs(STUDYID, USUBJID)
  ) |> 
  derive_vars_dtm_to_dt(source_vars = exprs(TRTSDTM, TRTEDTM)) |> 
  derive_var_trtdurd()


# convert character date to numeric date without imputation
ds_ext <- derive_vars_dt(
  ds,
  dtc = DSSTDTC,
  new_vars_prefix = "DSST"
)


adsl2 <- adsl1 %>%
  derive_vars_merged(
    dataset_add = ds_ext,
    by_vars = exprs(STUDYID, USUBJID),
    new_vars = exprs(EOSDT = DSSTDT),
    filter_add = DSCAT == "DISPOSITION EVENT" & DSDECOD != "SCREEN FAILURE"
  )

format_eosstt <- function(x) {
  case_when(
    x %in% c("COMPLETED") ~ "COMPLETED",
    x %in% c("SCREEN FAILURE") ~ NA_character_,
    TRUE ~ "DISCONTINUED"
  )
}

adsl3 <- adsl2 %>%
  derive_vars_merged(
    dataset_add = ds,
    by_vars = exprs(STUDYID, USUBJID),
    filter_add = DSCAT == "DISPOSITION EVENT",
    new_vars = exprs(EOSSTT = format_eosstt(DSDECOD)),
    missing_values = exprs(EOSSTT = "ONGOING")
  )
