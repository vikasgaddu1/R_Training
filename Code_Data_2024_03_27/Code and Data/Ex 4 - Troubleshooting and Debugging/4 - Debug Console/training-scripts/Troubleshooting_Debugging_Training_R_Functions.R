# Nested Functions --------------------------------------------------------

#' `fn_run_operations` is the function to be used by the end user, while the others
#' are meant only to be used within the subsequent function. Notice, we put an
#' error in `fn_exponent` for this demonstration.

fn_run_operations <- function(x){
  A <- x
  for_demo_1 <- "This is an irrelevant line of code"
  
  my_result  <- fn_multiply(A)
  
  # Return this value from the operations
  my_result
}

fn_multiply <- function(x){
  B <- x * 2
  fn_division(B)
}

fn_division <- function(x){
  for_demo_2 <- "This is an irrelevant line of code"
  C <- x / 3
  fn_exponent(C)
}

fn_exponent <- function(x){
  D <- x ^ "4"
  # D <- x ^ 4
  fn_addition(D)
}

fn_addition <- function(x){
  E <- x + 5
  return(E)
}



# Even or Odd -------------------------------------------------------------
#' This function determines if a number is odd or even

## Function V1 ----
even_or_odd_v1 <- function(number){

  # Request a number and divide it by 2
  quotient <- number / 2

  # Test if the quotient is a whole number
  test_int <- is.integer(quotient)

  # If quotient is an integer, then it is even, otherwise it is odd
  result <-
    if (isTRUE(test_int)){
      "Even"
    } else if (isFALSE(test_int)) {
      "Odd"
    }

  # Print the result to the screen
  result
}

## Function V2 ----
even_or_odd_v2 <- function(number){

  # Test the condition using the modulo operator %%
  test <- number %% 2 == 0

  # Determine what to display as a result
  result <- if (isTRUE(test)){
    "Even"
  } else if (isFALSE(test)) {
    "Odd"
  }

  # Print the result to the screen
  result
}
