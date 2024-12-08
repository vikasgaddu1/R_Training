# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Function Introduction ---------------------------------------------------


# Simple function
triple <- function(x) {
  result <- x * 3
  
  return(result)
}

triple(2)


# Multiple parameters
triple <- function(x, y) {
  ret <- (x + y) * 3
  
  return(ret)
}

triple(2, 3)

mean <- function(x,y,z) {
  result <- sum(x,y,z)/3
  return(result)
}

# Default parameter value
xyparam <- function(x = 2, y ) {
  ret <- x * y * 3
  
  return(ret)
}

xyparam( , 4)


# Parameter checks
triple <- function(x = NA) {

  if (is.na(x)) {
    stop("X is a required parameter")
  }else if (x < 0) {
    warning("Input value must greater than zero.")
  }
  ret <- x * 3
  
  return(ret)
}

triple(-1)    # Error


# Lazy Evaluation
triple <- function(x) {
  ret <- y * 3
  
  return(ret)
}

triple(2)     # Error



# Function Use Cases ------------------------------------------------------


# Read sample data frame
df <- readRDS(file.path("_data","df.rds"))
df <- readRDS(file.path("_data","df.rds"))
path <- file.path("_data","df.rds")

# Default range output
rng <- range(df$age)
rng

# Want: "Min to Max"

# Range formatting function
range_fmt <- function(x) {
  if (length(x) != 2) {
    stop("Input vector length must be equal to 2.")
  }
  
  ret <- paste(x[1], "-", x[2])
  
  return(ret)
}

# Formatted output
range_fmt(rng)


# Age categorization function
library(dplyr)
age_case <- function(x) {
  ret <- case_when(
    x < 18 ~ "< 18",
    x >= 18 & x < 24 ~ "18 to 24",
    x >= 24 & x < 45 ~ "24 to 45",
    x >= 45 & x < 60 ~ "45 to 60",
    x >= 60 ~ "> 60",
    TRUE ~ "Unknown"
  )
  return(ret)
}

df$age_cat <- age_case(df$age)
df

# Vectorized age categorization function
age_cat <- Vectorize(function(x) {
  if (x < 18) {
    ret <- "< 18"
  } else if (x >= 18 & x < 24) {
    ret <- "18 to 24"
  } else if (x >= 24 & x < 45) {
    ret <- "24 to 45"
  } else if (x >= 45 & x < 60) {
    ret <- "45 to 60"
  } else if (x >= 60) {
    ret <- "> 60"
  } else {
    ret <- "Unknown"
  }
  
  return(ret)
})

df$age_cat <- NA
df

df$age_cat <- age_cat(df$age)
df



# Apply Functions ---------------------------------------------------------


# Subset character columns

# Create function
char_check <- function(x) {
  ret <- class(x) == "character"
  
  return(ret)
}

multiple_return <- function(x,y){
  x <- x * 2
  y <- y * 2
  return(list(x,y))
}
multiple_return(2,3)

inputxy <- data.frame(input1 = c(1,2,3),
                      input2 = c(4,5,6))

mapply(multiple_return, inputxy$input1, inputxy$input2)

char_check(df$name)
char_check(df$age)
char_check(df$subjid)

# Apply function to data frame columns
char_cols <- sapply(df, FUN = char_check)


# Subset
df[char_cols]


## One step! ##
df[sapply(
  df,
  FUN = function(x) {
    class(x) == "character"
  }
)]

df[lapply(
  df,
  FUN = function(x) {
    class(x) == "character"
  }
)]

chartype <- lapply(
  df,
  FUN = function(x) {
    class(x) == "character"
  }
)

chartype
class(chartype)
df[c(TRUE,FALSE)]
