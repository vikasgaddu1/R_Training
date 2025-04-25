install.packages("sdtm.oak")

library(sdtm.oak)
domain_example()

domain_example("ae")
cm <- read_domain_example("cm")
View(cm)

path <- ct_spec_example("ct-01-cm")
path
ct_spec <- read_ct_spec(file = path)
View(ct_spec)

ct_spec <- read_ct_spec_example("ct-01-cm")
View(ct_spec)
names(ct_spec)
myct <- ct_spec |> filter(codelist_code == "C71113")
View(myct)

# A few example terms.
terms <-
  c(
    "/day",
    "Yes",
    "Unknown",
    "Prior",
    "Every 2 hours",
    "Percentage",
    "International Unit"
  )

# Load a controlled terminology example
ct_spec <- read_ct_spec_example("ct-01-cm")

# Use all possible matching terms in the controlled terminology.
ct_map(x = terms, ct_spec = ct_spec)

# Note that if the controlled terminology mapping is restricted to a codelist
# code, e.g. C71113, then only `"/day"` and `"Every 2 hours"` get mapped to
# `"QD"` and `"Q2H"`, respectively; remaining terms won't match given the
# codelist code restriction, and will be mapped to an uppercase version of
# the original terms.
ct_map(x = terms, ct_spec = ct_spec, ct_clst = "C71113")

library(tibble)

# Create the controlled terminology specification tibble
ct_spec <- tibble(
  codelist_code = c("C71113", "C71113", "C71113"),
  collected_value = c("A", "B", "C"),
  term_synonyms = c("apple", "banana", "cherry"),
  term_value= c("Apple", "Banana", "Cherry")
)
# Original vector of terms
x <- c("A", "B", "C", "B", "A")

# Recode the vector using the controlled terminology
x_recoded <- ct_map(x, ct_spec = ct_spec, from = "collected_value", to = "term_value")
print(x_recoded)

dm <- tibble::tribble(
  ~USUBJID, ~RFSTDTC, ~RFXSTDTC,
  "test_study-375", "2020-09-28T10:10", "2020-09-28T10:10",
  "test_study-376", "2020-09-21T11:00", "2020-09-21T11:00",
  "test_study-377", NA, NA,
  "test_study-378", "2020-01-20T10:00", "2020-01-20T10:00",
  "test_study-379", NA, NA,
)

dm

sdtm_in <-
  tibble::tribble(
    ~DOMAIN,
    ~oak_id,
    ~raw_source,
    ~patient_number,
    ~USUBJID,
    ~VSDTC,
    ~VSTESTCD,
    ~VSORRES,
    ~VSSTAT,
    ~VISIT,
    "VS",
    1L,
    "VTLS1",
    375L,
    "test_study-375",
    "2020-09-01T13:31",
    "DIABP",
    "90",
    NA,
    "SCREENING",
    "VS",
    2L,
    "VTLS1",
    375L,
    "test_study-375",
    "2020-10-01T11:20",
    "DIABP",
    "90",
    NA,
    "SCREENING",
    "VS",
    1L,
    "VTLS1",
    375L,
    "test_study-375",
    "2020-09-28T10:10",
    "PULSE",
    "ND",
    NA,
    "SCREENING",
    "VS",
    2L,
    "VTLS1",
    375L,
    "test_study-375",
    "2020-10-01T13:31",
    "PULSE",
    "85",
    NA,
    "SCREENING",
    "VS",
    1L,
    "VTLS2",
    375L,
    "test_study-375",
    "2020-09-28T10:10",
    "SYSBP",
    "120",
    NA,
    "SCREENING",
    "VS",
    2L,
    "VTLS2",
    375L,
    "test_study-375",
    "2020-09-28T10:05",
    "SYSBP",
    "120",
    NA,
    "SCREENING",
    "VS",
    1L,
    "VTLS1",
    376L,
    "test_study-376",
    "2020-09-20",
    "DIABP",
    "75",
    NA,
    "SCREENING",
    "VS",
    1L,
    "VTLS1",
    376L,
    "test_study-376",
    "2020-09-20",
    "PULSE",
    NA,
    "NOT DONE",
    "SCREENING",
    "VS",
    2L,
    "VTLS1",
    376L,
    "test_study-376",
    "2020-09-20",
    "PULSE",
    "110",
    NA,
    "SCREENING",
    "VS",
    2L,
    "VTLS1",
    378L,
    "test_study-378",
    "2020-01-20T10:00",
    "PULSE",
    "110",
    NA,
    "SCREENING",
    "VS",
    3L,
    "VTLS1",
    378L,
    "test_study-378",
    "2020-01-21T11:00",
    "PULSE",
    "105",
    NA,
    "SCREENING"
  )

sdtm_in

# Example 1:
observed_output <- derive_blfl(
  sdtm_in = sdtm_in,
  dm_domain = dm,
  tgt_var = "VSLOBXFL",
  ref_var = "RFXSTDTC",
  baseline_visits = c("SCREENING")
)
observed_output |> 
  select(USUBJID,VSDTC,VSTESTCD, VSLOBXFL,VSORRES)

# Example 2:
observed_output2 <- derive_blfl(
  sdtm_in = sdtm_in,
  dm_domain = dm,
  tgt_var = "VSLOBXFL",
  ref_var = "RFXSTDTC",
  baseline_timepoints = c("PRE-DOSE")
)
observed_output2

# Example 3: Output is the same as Example 2
observed_output3 <- derive_blfl(
  sdtm_in = sdtm_in,
  dm_domain = dm,
  tgt_var = "VSLOBXFL",
  ref_var = "RFXSTDTC",
  baseline_visits = c("SCREENING"),
  baseline_timepoints = c("PRE-DOSE")
)
observed_output3


raw_dataset <-
  tibble::tribble(
    ~patnum, ~MDRAW,
    101L, "BABY ASPIRIN",
    102L, "CORTISPORIN",
    103L, NA_character_,
    104L, "DIPHENHYDRAMINE HCL"
  )

# Generate oak_id_vars
generate_oak_id_vars(
  raw_dat = raw_dataset,
  pat_var = "patnum",
  raw_src = "Concomitant Medication"
)