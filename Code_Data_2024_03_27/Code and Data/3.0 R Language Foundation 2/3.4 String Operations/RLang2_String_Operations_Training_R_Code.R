# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Introduction to String Operations ------------------------------------------

# Escape character is slash (\)
file_path <- "c:\Projects\R Training"
file_path <- "c:/Projects/R Training"
file_path <- "c:\\Projects\\R Training"
print(file_path)
cat(file_path)

# Concatenating Paths
file_path <-
  file.path("c:","Projects","R Training", "string_operations.R")
file_path

# Quotes in strings
nm <- "Kevin O'Malley"
nm <- 'Kevin O\'Malley'
nm <- 'His name is "Kevin O\'Malley".'
nm <- "His name is \"Kevin O'Malley\"."
cat(nm)

# Newline, tab, and unicode escape codes
st <- "Treatment 1 \n(N=56)"
print(st)
cat(st)
st <- "System Organ Class\n\t High Level Term"
cat(st)
st <- "2.8\u03BC"    # (unicode) or '03BC'x
cat(st)

# Length of strings (length)
length("Treatment 1")
length(c("Treatment 1", "Treatment 2"))
nchar("Treatment 1 (N=56)")
nchar("Treatment 1 \n(N=56)")
nchar("2.8\u03BC")

# Upper and Lower Case (upcase & lowcase)
toupper("Prod")
tolower("Prod")

# String extraction (substr)
trt <- "Treatment A"
substring(trt, 2, 5)
substring(trt, 5)
substring(trt, nchar(trt))

# String concatenation (|| or cat*)
paste("25", "-", "56")
paste(25, "-", 56)
paste(25, "-", 56, sep = "")
paste0(25, "-", 56)
paste(25, 56, sep = "-")
paste(c(25, 22, 28), c(56, 59, 63), sep = "-")
paste(c(25, 22, 28), c(56, 59, 63), sep = "-", collapse = "|")

# Paste Recycling
subjid <- 100:109
paste0("ABC-", subjid)
paste0("ABC-", c("001", "002"), "-", subjid)

# Data Type conversion (put)
as.character(102)
as.integer("102")

# String replacement  (replace, etc.)
sub("1", "A", "Treatment 1 (N=21)", fixed = TRUE)
gsub("1", "A",  "Treatment 1 (N=21)", fixed = TRUE)

# Note: Regex extraction/replacement functions available

# String splitting & trimming (scan & trim)
codes <- "A1, B4, A7, C2"
split_codes <- strsplit(codes, ",", fixed = TRUE)
class(split_codes)
split_codes <- unlist(split_codes)
class(split_codes)
split_codes <- trimws(split_codes)
split_codes
split_codes[2]
# One step
split_codes1 <- trimws(unlist(strsplit(codes, ",", fixed = TRUE)))
split_codes1




# Use Cases ---------------------------------------------------------------


## Generate unique subject id ##
usubjid_fmt <- function(study, site, subjid) {
  ret <- paste(toupper(study), toupper(site), subjid, sep = "-")
  
  return(ret)
}

subjid <- 100:102
sites <-  c("001", "002", "003")

# Test usubjid function
usubjid_fmt("ABC", sites, subjid)



## Format count and percent ##
cnt_pct <- function(cnt, denom) {
  # Calculate percentages
  pct <- cnt / denom * 100
  
  # Format percentages
  fmt <- format(pct,
                width = 5,
                digits = 1,
                nsmall = 1)
  
  # Combine counts and percents
  # ret <- ifelse(cnt == 0, "0",paste0(cnt, " ", "(", fmt, "%)") )
  ret <- case_when(
    cnt == 0 ~ "0",
    pct == 100 ~ paste0(cnt, " ", "(100%)"),
    .default = paste0(cnt, " ", "(", fmt, "%)")
    
  ) 
  
  return(ret)
}


# Test count and percent function
cnt_pct(0:9, 9)


# Conceptual Pause --------------------------------------------------------

# All above functions are vectorized!
subjid <- 100:109
sites <- c("San Francisco", "London", "Tokyo")

sub("o", "0", sites)
toupper(sites)
substring(sites, 1, 2)
nchar(sites)
as.character(subjid)
file.path("c:","Study-ABC", sites)

# 1) Loops are inside all the functions
# 2) Rarely need explicit loops
# 3) Data operations are normally column-based, not row based
# 4) No true equivalent of a data step

# Set up data
subjid <- paste0("S", 200:203)
subj_temp <- c(98.6, 36.1, 101.2, 35.8)
temp_uom <- c("F", "C", "F", "C")

df1 <- data.frame(subjid, subj_temp, temp_uom)

# Create string of subject temperature F and C
subj_temps <- Vectorize(function(subj, temp, uom) {
  if (uom == "F") {
    tmpf <- temp
    tmpc <- 5 / 9 * (temp - 32)
  } else {
    tmpf <- (temp * 9 / 5) + 32
    tmpc <- temp
  }
  print(paste("Farenheit:", tmpf))
  
  ret <- paste0(
    subj,
    " ",
    format(tmpf, digits = 1, nsmall = 1),
    "\u2109",
    # Degrees Fahrenheit
    " (",
    format(tmpc, digits = 1, nsmall = 1),
    "\u2103)"
  ) # Degrees Celcius
  
  return(ret)
  
})

# Execute vectorized function across variables
subj_temps(df1$subjid, df1$subj_temp, df1$temp_uom)

