
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key


# Factors Exercises --------------------------------------

# Exercise Step 3
# Declare a vector named labflags with the following values
# "N","H","L","N","N","N","N","H","H","L"
labflags <- c("N", "H", "L", "N", "N", "N", "N", "H", "H", "L")


# Exercise Step 4
# Use the table function on labflags and review the results.
table(labflags)


# Exercise Step 5
# Create a vector for decoding labflags with the values
# H='High', L='Low',N="Normal",F="Fatal" and name it labflags_decodes.
labflags_decodes <- c(H = 'High',
                      L = 'Low',
                      N = "Normal",
                      F = "Fatal")


# Exercise Step 6
# Create a decoded vector named labflags_decoded using the labflags and labflags_decodes
# vectors.
labflags_decoded <- labflags_decodes[labflags]


# Exercise Step 7
#	Use the table function on labflags_decoded and review the results.
table(labflags_decoded)

# Exercise Step 8
# Declare a factor called labflags_factor using the labflags vector and the following
# levels:  "N","H","L","F"
labflags_factor <- factor(labflags, levels = c("N", "H", "L", "F"))

# Exercise Step 9
# Use the print and table functions to view the labflags_factor contents and summary
# table respectively. Note that even though there are no "F" values in the labflags
# vector, the table function still reports it with a zero count unlike the decoded vector.
print(labflags_factor)
table(labflags_factor)


# Exercise Step 10
#	Similar to the previous two steps, create a labflags_decoded_factor using
# the labflags_decoded vector and the appropriate levels.
labflags_decoded_factor <-
  factor(labflags_decoded, levels = c("Normal", "High", "Low", "Fatal"))

# Exercise Step 11
# Use the print and table functions to view the labflags_decoded_factor contents and
# summary table respectively. Note that even though there are no "Fatal" values in the
# labflags_decoded vector, the table function still reports it with a zero count
# unlike the decoded vector.
print(labflags_decoded_factor)
table(labflags_decoded_factor)

# Exercise Step 12
# Assign the table name labflags_decoded_factor_table to table(labflags_decoded_factor_table)
labflags_decoded_factor_table <- table(labflags_decoded_factor)

# Exercise Step 13
# Create a variable called fatalities, and set it to the count of Fatal elements from the
# labflags_decoded_factor_table and examine the value.
fatalities <- labflags_decoded_factor_table["Fatal"]


# Lists Exercises --------------------------------------

# lists

# Exercise Step 1
# Create a list named userprofile for a fictious person. Include elements for
# first_name, last_name, date_of_birth, gender, pet_names (one dog and one cat
# using a named vector), street_address, city, state, zipcode.
userprofile <- list(
  last_name = "Doe",
  first_name = "Jane",
  date_of_birth = as.Date("1970-01-04"),
  gender = "Female",
  pet_names = c(dog = "Astro", cat = "Fluffy"),
  kid_names = c(son = "Elroy", daughter = "Judy"),
  street_address = "1600 Pennsylvania Ave NW",
  city           = "Washington",
  state          = "DC",
  zipcode        = 20500
)

# Exercise Step 2
# Use the userprofile list to answer the following questions about this fictious person using your knowledge of the R language.
# i.e.  "What is your last name?" would be last_name <- userprofile["last_name"]
last_name <- userprofile["last_name"]
print(last_name)

# Exercise Step 2.a
# What is your date of birth?
dob <- userprofile["date_of_birth"]
print(dob)

# Exercise Step 2.b
# What city do you live in?
city <- userprofile["city"]
print(city)

# Exercise Step 2.c
# What are your pet's names?
pet_names <- userprofile["pet_names"]
print(pet_names)


# Exercise Step 3
# The user in question needs to update their last name to "Jetson". Update the
# last_name element of your userprofile list to "Jetson".
userprofile["last_name"] <- "Jetson"

# Exercise Step 4
print(userprofile)

