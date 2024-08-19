# Nested Functions ------------------------------------------

# tempconversion is the function to be used by the end user, 
# while the others are meant only to be used within the 
# subsequent function. 

tempconversion <- function(temp, whichway) {
  if (whichway == 'F2C') {
    result <- f2c(temp)
  } else if (whichway == 'C2F') {
    result <- c2f(temp)
  } else {
    stop("Invalid whichway parameter value")
  }
  return(result)
}


f2c <- function(x) {
  c <- (x - 32) * (5 / 9)
}

c2f <- function(x) {
  f <- (c * (9 / 5)) + 32
}