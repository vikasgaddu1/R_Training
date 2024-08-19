# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key


# Strings -----------------------------------------------------------------

# Exercise Step 3
# set your working directory to the course level directory using the
# Session > Set Working Directory > Choose Directory
# Notice the setwd() function in the console. Copy and paste it to your program.
setwd("<course level directory>")

# Exercise Step 4
# Create a variable, data_directory with the value data.
data_directory <- "_data"

# Exercise Step 5
# Create a variable, `data_frame`, with the value `invdata_new.rds`.
data_frame <- 'invdata_new.rds'

# Exercise Step 6
# Determine the length of each of the two variables `data_directory` and `dataframe`.
nchar(data_directory)
nchar(data_frame)

# Exercise Step 7
# Use the `file.path()` function to create the full path for your R script, `data_path`.
data_path <- file.path(data_directory, data_frame,fsep = "/")

# Exercise Step 8
# What do you expect the length of `data_path` to be? Check the length to confirm your understanding.
nchar(data_path)


# Extract and Concat ------------------------------------------------------

# Exercise Step 3
# Use the `data_path` variable to read in the `invdata_new.rds` R data frame from the course level directory.
invdata <- readRDS(data_path)

# Exercise Step 4
# Use the paste() function to create a vector with each element showing the raw data like the following example for the first record:
"1001, M, 23, AZO, Kalamazoo"
paste(invdata$invid, invdata$sex, invdata$yearsexp,
      invdata$site, invdata$site_city,sep = ", ",collapse = "\n")

# Exercise Step 5
# Copy and modify the previous line to make a vector of length one with a newline character between each element of the vector. How would you output that vector so that it looks like the following?
#    1001, M, 23, AZO, Kalamazoo
#    1002, F, 12, AZO, Kalamazoo
#    1003, M, 10, SFO, San Francisco
#    1004, M, 3, ORD, Chicago
#    1005, F, 2, ORD, Chicago
cat(paste(invdata$invid, invdata$sex, invdata$yearsexp,
          invdata$site, invdata$site_city, sep = ", ",collapse = "\n"))

# Exercise Step 6
# use the ifelse conditional logic function within the paste0 function to add a variable named inv_bio that combines
# the variables and constant text into a sentence like the following example:
# Investigator 1000 is a Male, with 23 years experience and is located in Kalamazoo
invdata$inv_bio <- paste0(
  'Investigator ',
  invdata$invid,
  ' is a ',
  ifelse(invdata$sex == 'M', 'male', 'female'),
  ', with ',
  invdata$yearsexp,
  ' years experience, and is located in ',
  invdata$site_city,
  '.'
)

# Examine the results to ensure you have a proper sentence.
invdata


# Other Operations --------------------------------------------------------



# Exercise Step 3
# Instead of the word and, we decided to use an ampersand symbol. Use the sub or gsub function to
# replace ' and ' with ' & ' in the inv_bio variable we just created.
invdata$inv_bio <- sub(' and ', ' & ', invdata$inv_bio,)
invdata

# Exercise Step 4
# Now we want to change the word *is* to *was* for each record. Which function, sub() or gsub(),
# can replace all occurrences of *is* at once? Use that function to do so.
invdata$inv_bio <- gsub(' is ',' was ',invdata$inv_bio,)
invdata

# Exercise Step 5
# Read in the invdata_new.rds R data set from the course level directory.
raw_vs <- readRDS('_data/raw_vitals.rds')

# Exercise Step 6
# The raw_vs has a variable named SUBJECT that is a two digit site id, followed by a hyphen, followed by a three digit
# subject ID. From the SUBJECT variable, create a variable named site_id which is a numeric site number. Also create a variable named subj_id
# which is a numeric subject id variable.
raw_vs$site_id <- as.numeric(substring(raw_vs$SUBJECT, 1, 2))
raw_vs$subj_id <- as.numeric(substring(raw_vs$SUBJECT, 4, 6))


# Exercise Step 7
# using our invdata data frame, consider the total years of experience of the investigator team. Each investigator's years of
# experience would count towards the total years of experience for that team. Add a variable to invdata named pct_ye that is a % of
# years of experience across all investigators. Use the format and paste0 functions to make it look like xx.x%.
invdata$pct_ye <-
  paste0(format((invdata$yearsexp / sum(invdata$yearsexp)) * 100,
                width = 5,
                justify = 'right',
                digits = 1,
                nsmall = 1
               ),
         '%')

# Exercise Step 8
# Define the following variable in your session.
aecsv <- "headache, vOMITing, nAUsEA, CHILLS, vertigo"

# Exercise Step 9
# Use the strsplit() function to turn the comma separated list into a list object named aelist.
aelist <- strsplit(aecsv, ',')

# Exercise Step 10
# change the list into a vector named aevector using the unlist() function and eliminate the leading blanks.
aevector <- trimws(unlist(aelist))

# Exercise Step 11
# change the aevector elements into proper case (first character upper case and the rest of the word lower case).
aevector_proper <-
  paste0(toupper(substring(aevector, 1, 1)), tolower(substring(aevector, 2, nchar(aevector))))
aevector_proper

