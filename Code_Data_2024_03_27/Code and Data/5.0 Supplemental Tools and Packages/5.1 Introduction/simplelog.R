# Load Packages
library(dplyr)
library(logr)
library(tidylog)
library(this.path)

options("tidylog.display" = list(log_print), 
        "logr.on" = TRUE,
        "logr.notes" = FALSE)

current_path <- this.path()
filename <- strsplit(current_path, "/")[[1]][length(strsplit(current_path, "/")[[1]])]
filename <- basename(current_path)
logfile <- str_replace(filename, ".R", ".log")
log_open(logfile)


sep("Step 3")

put("This is step 3.c")

# Exercise Step 3.d
# You will need to uncomment the code below for step 3.d
# if (3 !=4) {
#  stop("3 is not equal to 4!")
# }


sep("Data Loading Section")

data(iris)

sep("Data Summarization Section")

iris_summary <- iris %>%
  filter(!is.na(Sepal.Length)) %>%
  group_by(Species) %>%
  summarise(Mean_Sepal_Length = mean(Sepal.Length, na.rm = TRUE)) %>%
  ungroup() %>% 
  put()
# Exercise Step 3.e
log_close()
