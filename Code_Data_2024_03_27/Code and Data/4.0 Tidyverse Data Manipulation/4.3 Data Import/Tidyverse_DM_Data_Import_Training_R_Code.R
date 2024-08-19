
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2020 Anova Groups All rights reserved

# Title: Importing and Exporting Data

# Packages & Functions on Display:
# - {readr    1.3.1}: read_*, write_*, spec
# - {haven    2.3.0}: read_sas
# - {labelled 2.4.0}: var_label
# - {readxl   1.3.1}: read_excel
# - {writexl  1.3.0}: write_xlsx


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)

# Read and Write - Text Files ---------------------------------------------

# Loading CSV
default_readcsv <-
  readr::read_csv(file = "_data/ae_studya.csv")

# View Column Specification
spec(default_readcsv)

# View Column Specification without Reading File
spec_csv(file = "_data/ae_studya.csv")

# Custom Specification
# Notice aedtstop is now a proper date, because it guesses the format
# Notice int instead of dbl
# Notice factor with levels including NA
custom_spec <-
  cols(patient   = col_integer(),
       visit     = col_integer(),
       aeraw     = col_character(),
       aedtstart = col_date(format = "%Y/%m/%d"),
       aedtstop  = col_date(format = ""),
       aeserious = col_factor(levels = c("YES", "NO", include_na = TRUE)),
       aeongoing = col_factor(levels = c("YES", "NO", include_na = TRUE)),
       soc_term  = col_character()
  )

# Control Arguments
custom_readcsv <-
  read_csv(file = "_data/ae_studya.csv",
           col_names = TRUE,
           col_types = custom_spec,
           n_max = 15)

# Writing CSV
write_csv(custom_readcsv,
          file = "_data/custom_output_name.csv")

# Write delimited file
write_delim(custom_readcsv,
            file = "_data/custom_output_name.txt",
            delim = "\t")

# Read delimited file
read_delim(file = "_data/custom_output_name.txt",
           delim = "\t")


# Vignettes
vignette("readr")

# Help Pages
help(read_csv,       package = "readr")
help(write_csv,      package = "readr")
help(parse_datetime, package = "readr")

# Equivalent Functions
help(read.csv,  package = "utils")
help(write.csv, package = "utils")


# Read and Write - Binary R Objects ---------------------------------------

custom_r_object <-
  list(data   = custom_readcsv,
       vector = vector(),
       list   = list(),
       matrix = matrix())

class(custom_r_object)

write_rds(custom_r_object,
          "_data/r_list.rds")

read_rds("_data/r_list.rds")



# Help Pages
help(write_rds, package = "readr")
help(saveRDS,   package = "base")


# Read and Write - Excel Workbooks ----------------------------------------

library(readxl)
library(writexl)

default_readexcel <-
  readxl::read_excel("_data/study abc data dictionary.xlsx")

custom_readexcel <-
  readxl::read_excel("_data/study abc data dictionary.xlsx",
                     sheet = 1,
                     n_max = 15,
                     .name_repair = "universal")


# Export Excel - Single Sheet
writexl::write_xlsx(default_readexcel,
                    "_data/data_dictionary_1.xlsx")


# Export Excel - Multiple Sheets
excel_sheets <-
  list(sheet_1 = default_readexcel,
       sheet_2 = custom_readexcel)

writexl::write_xlsx(excel_sheets,
                    "_data/data_dictionary_2.xlsx")


# Vignettes
vignette("cell-and-column-types")
vignette("sheet-geometry")

# Help Pages
help(read_excel, package = "readxl")
help(write_xlsx, package = "writexl")


# Read - SAS Datasets -----------------------------------------------------

library(haven)
library(labelled)

custom_readsas <-
  haven::read_sas("_data/ae_studya.sas7bdat",
                  col_select = everything(),
                  n_max = 15)

custom_readsas


labelled::var_label(custom_readsas)

var_label(custom_readsas) <- list(aedtstart = "AE Date Start")
var_label(custom_readsas)


# Vignettes
vignette("semantics")
vignette("intro_labelled")

# Help Pages
help(read_sas, package = "haven")
help(read_xpt, package = "haven")


# Documentation -----------------------------------------------------------

# Website References
# - https://readr.tidyverse.org/
# - https://haven.tidyverse.org/
# - https://readxl.tidyverse.org/
# - https://docs.ropensci.org/writexl/

# - https://rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------

