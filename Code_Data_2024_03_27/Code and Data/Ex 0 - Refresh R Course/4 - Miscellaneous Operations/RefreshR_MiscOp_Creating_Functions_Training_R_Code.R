
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Misc Operations - Creating Functions

# Packages & Functions on Display:
# - {base 4.2.0}: function(), message(), print(), paste(), stopifnot()


# Creating Functions ------------------------------------------------------
# Functions will allow you to reuse code in other situations
# If you find yourself repeating lines of code more than three times, create a function


# Function - Basic --------------------------------------------------------

fn_a <- function(argument_1 = "default_value"){
  print(argument_1)
}


fn_a()
fn_a("new value")


# Function - Intermediate -------------------------------------------------

fn_b <- function(a1, a2, a3){
  message("You passed in the following values:")

  1 + 2
  3 + 4

  # Only the final operation gets returned
  paste(a1, a2, a3, sep = ", ")
}


fn_b()
fn_b(1, 2, 3)
fn_b(a2 = 2)



# Function - Advanced -----------------------------------------------------

fn_c <- function(n, c, df){

  # Argument Checking
  stopifnot(is.numeric(n))
  stopifnot(is.character(c))
  stopifnot(is.data.frame(df))

  return(n * 100)                      # Return quits the function early

  print(paste("Character:", c))
  print(paste("DF Rows:", nrow(df)))

}

fn_c(1, "A", mtcars)


# Function - Advanced (Alternate) -----------------------------------------

fn_d <- function(n, c, df){

  # Argument Checking
  stopifnot(is.numeric(n))
  stopifnot(is.character(c))
  stopifnot(is.data.frame(df))


  # Use print to display intermediate results
  internal_n  <- print(n * 100)
  internal_c  <- print(paste("Character:", c))
  internal_df <- print(paste("DF Rows:", nrow(df)))


  # Use a list to store all intermediate results for use outside of function
  list(
    return_n  = internal_n,
    return_c  = internal_c,
    return_df = internal_df)
}


fn_d(1, "A", mtcars)



# Documentation -----------------------------------------------------------

# Vignettes
vignette(programming)

# Help Pages
help("function")

# Website References
# - https://r4ds.had.co.nz/functions.html
# - https://www.w3schools.com/r/r_functions.asp

# -------------------------------------------------------------------------
