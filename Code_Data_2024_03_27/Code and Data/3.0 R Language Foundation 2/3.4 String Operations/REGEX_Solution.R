# Load necessary libraries
library(tibble)
library(stringr)

# Original annotations
annotation <- tribble(
  ~annot,
  "DM.RACE",
  "SV.SVSTDTC",
  "CM.CMCAT = 'Concomitant Medication'",
  "PRINDCO in SUPPPR",
  "BRSPR in SUPPCM when IDVAR = CMSEQ"
)

# Function to identify the annotation type and split accordingly
split_annotation <- function(annot) {
  
  # Type 1: Standard annotation (e.g., DM.RACE)
  if (str_detect(annot, "^[^. ]+\\.[^ ]+$")) {
    dataset <- str_extract(annot, "^[^. ]+")
    variable <- str_extract(annot, "(?<=\\.)[^ ]+")
    value <- NA
    condition <- NA
    
    # Type 2: Annotation with value (e.g., CM.CMCAT = 'Concomitant Medication')
  } else if (str_detect(annot, " = ")) {
    dataset <- str_extract(annot, "^[^. ]+")
    variable <- str_extract(annot, "(?<=\\.)[^ =]+")
    value <- str_extract(annot, "(?<= = ).+")
    condition <- NA
    
    # Type 3: Annotation with "in" (e.g., PRINDCO in SUPPPR)
  } else if (str_detect(annot, " in ") & !str_detect(annot, "when")) {
    variable <- str_extract(annot, "^[^ ]+")
    dataset <- str_extract(annot, "(?<= in )[^ ]+")
    value <- NA
    condition <- NA
    
    # Type 4: Annotation with "in" and "when" (e.g., BRSPR in SUPPCM when IDVAR = CMSEQ)
  } else if (str_detect(annot, " in .+ when ")) {
    variable <- str_extract(annot, "^[^ ]+")
    dataset <- str_extract(annot, "(?<= in )[^ ]+")
    value <- NA
    condition <- str_extract(annot, "(?<=when ).+")
    
  } else {
    # If the pattern doesn't match any known type
    dataset <- NA
    variable <- NA
    value <- NA
    condition <- NA
  }
  
  return(c(dataset, variable, value, condition))
}

# Apply the function to all annotations
split_results <- t(sapply(annotation$annot, split_annotation))

# Create a new dataframe with the split components
result_df <- as_tibble(split_results, .name_repair = "unique") %>%
  rename(Dataset = ...1, Variable = ...2, Value = ...3, Condition = ...4)

# Print the final dataframe
print(result_df)
