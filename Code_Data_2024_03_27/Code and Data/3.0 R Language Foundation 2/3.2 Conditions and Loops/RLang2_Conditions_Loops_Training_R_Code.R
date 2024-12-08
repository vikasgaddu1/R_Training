# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Read sample data frame
df <- readRDS("df.rds")
df

# Conditionals -----------------------------------------------------------

# Setup
status <- "DEV"
status <- "PROD"


# If Condition
if (status == "DEV") {
  # Sample data
  data <- df[sample(nrow(df), 5),]
  
} else if (status == "PROD" || status == "PREPROD") {
  # Use full data
  data <- df
  
} else {
  # Generates error
  stop("Unknown status")
  
}

data

# If condition not vectorized
if (data$age > 40) {
  # Error/Warning
  
  data$age_cat <- "> 40"
  
} else {
  data$age_cat <- "<= 40"
  
}

# Vectorized ifelse
data$age_cat <- ifelse(data$age > 40, "> 40", "<= 40")
data


# dplyr case_when function
library(dplyr)
data$age_cat <- case_when(
  data$age < 18 ~ "< 18",
  data$age >= 18 &
    data$age < 24 ~ "18 to 24",
  data$age >= 24 &
    data$age < 45 ~ "24 to 45",
  data$age >= 45 &
    data$age < 60 ~ "45 to 60",
  data$age >= 60 ~ "> 60",
  TRUE ~ "Unknown"
)
data


# For Loop ----------------------------------------------------------------

# Setup
v1 <- 10:12
v2 <- c("a", "b", "c")

print(v1)
# Numeric Vector
for (elem in v1) {
  print(elem)
}

# Character Vector
for (elem in v2) {
  print(elem)
}


# Data frame columns
for (nm in names(data)) {
  print(class(data[[nm]]))     # Double brackets to access vector
}


# Data frame Variable
for (elem in data$subjid) {
  # No reason to do this
  print(elem)
}

# Most functions vectorized anyway
print(data$subjid)


## Best Practice: Try to avoid big loops in R! ##



# Use Case  --------------------------------------------

## Assigning labels and description to data frame

# Assign labels one by one
attr(df$subjid, "label") <- "Subject ID"
attr(df$name, "label") <- "Subject Name"
# ...


# Create named vector
df_labels <- c(
  subjid = "Subject ID",
  name = "Subject Name",
  sex = "Sex",
  age = "Age",
  arm = "Treatment Arm"
)

df_desc <- c(
  subjid = "A three-digit subject identifier",
  name = "The name of the subject.",
  sex = "The sex of the subject.  Valid values are M, F or UNK.",
  age = "The age of the subject.",
  arm = "The Arm code for this subject.  Valid values are A or B"
)

# Assign labels and description using for loop
for (nm in names(df)) {
  attr(df[[nm]], "label") <- df_labels[[nm]]
  attr(df[[nm]], "description") <- df_desc[[nm]]
}

str(df)

typeof(attributes(df))

# Named vector returns name and value
df_labels["subjid"]

# To get value only, use double brackets
df_labels[["subjid"]]

View(df)

saveRDS(df, "df.rds")
