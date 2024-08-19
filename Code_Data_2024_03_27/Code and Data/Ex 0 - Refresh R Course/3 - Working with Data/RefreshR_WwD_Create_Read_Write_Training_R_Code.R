
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Working with Data - Create, Read, Write

# Packages & Functions on Display:
# - {base     4.2.0}: data.frame(), read.csv(), saveRDS()
# - {tibble   3.1.6}: tibble(), tribble()
# - {readr    2.1.2}: read_csv(), cols(), write_rds()
# - {writexl  1.4.0}: write_xlsx()
# - {readxl   1.4.0}: read_xlsx()
# - {haven    2.5.0}: read_sas()
# - {labelled 2.9.0}: var_label()


# Setup -------------------------------------------------------------------

library(tidyverse)


# Create Data -------------------------------------------------------------

# Create from existing vectors
col_1 <- 1:3
col_2 <- c("a", "b", "c")

data.frame(col_1, col_2)
tibble(col_1, col_2)


# Create directly
data.frame(
  col_1 = 1:3,
  col_2 = c("a", "b", "c"))

tibble(
  col_1 = 1:3,
  col_2 = c("a", "b", "c"))


# Create in vertical format
tribble(
  ~col_1, ~col_2,
       1,    "a",
       2,    "b",
       3,    "c")



# Write Data --------------------------------------------------------------

mtcars %>% write.csv("data/mtcars.csv")     # Base R
mtcars %>% write_csv("data/mtcars.csv")


# Read Data
read.csv("data/mtcars.csv")                 # Base R
read_csv("data/mtcars.csv")


# Define column types when reading in
read_csv(
  "data/mtcars.csv",
  col_types = cols(
    mpg  = col_double(),
    cyl  = col_factor(),
    disp = col_double(),
    hp   = col_integer())
)



# Write any R objects to the disk
my_list <-
  list(
    numbers    = 1:10,
    characters = letters,
    dataframes = mtcars)

my_list %>% saveRDS("data/my_list.rds")     # Base R
my_list %>% write_rds("data/my_list.rds")   # Tidyverse fn is generally faster



# Read / Write Excel ------------------------------------------------------

library(readxl)   # Reading and writing functions are separated into two pkgs
library(writexl)


# Write a single dataset to disk
mtcars %>% write_xlsx("data/mtcars.xlsx")


# Write many datasets to disk, each dataset is a sheet in the workbook
my_datalist <-
  list(
    data_1 = mtcars,
    data_2 = mtcars %>% filter(cyl == 6),
    data_3 = mtcars %>% filter(cyl == 4)
  )

my_datalist %>% write_xlsx("data/my_datalist.xlsx")


# Read the workbook and specify the sheet
read_xlsx("data/my_datalist.xlsx", sheet = 2)


# Read SAS Data -----------------------------------------------------------
# There are no functions to create a SAS file currently

library(haven)      # Haven reads the SAS datasets
library(labelled)   # Labelled makes it easy to work with SAS variable labels


df_sas <- read_sas("data/dm.sas7bdat")


var_label(df_sas)
var_label(df_sas) <- list(STUDYID = "Subject ID")
var_label(df_sas)



# Documentation -----------------------------------------------------------

# Vignettes
vignette("readr")
vignette("intro_labelled", package = "labelled")

# Help Pages
help("readRDS")
help("read_sas")

# Website References
# - https://r4ds.had.co.nz/data-import.html
# - https://www.rstudio.com/resources/cheatsheets/

# -------------------------------------------------------------------------
