
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Setup 
a <- 1
b <- 2


## Arithmetic Operators ##
c <- a + b     # Addition
c <- a - b     # Subtraction
c <- a * b     # Multiplication
c <- a / b     # Division

c <- a^b     # Exponent
c <- a %/% b   # Quotient
c <- a %% b    # Remainder

## Relational Operators ##
d <- a == b    # Comparison Equals;
d <- a != b;   # Not Equal 
d <- a > b;    # Greater Than
d <- a < b;    # Less Than
d <- a >= b;   # Greater Than or Equal To
d <- a <= b;   # Less Than or Equal To


# Setup 
a <- TRUE
b <- FALSE

## Logical Operators ##
e <- a && b    # And (Logical)
e <- a & b     # And (Element-wise)
e <- a || b    # Or  (Logical)
e <- a | b     # Or  (Element-wise)
e <- !a        # Not


## Miscellaneous Operators ##
f <- 1:5       # Series
print(a & f)

f <- 7 %in% 1:5  # In
print(f)


# Setup
x <- c(2, 5, 4, 3)
y <- c(1, 2, 4, 6)

## Vector Operations - Arithmetic ##
g <- x + y
print(g)

g <- x - y
print(g)

g <- x %% y
print(g)


# Setup
x <- c(TRUE, FALSE, TRUE, FALSE)
y <- c(TRUE, TRUE, FALSE, FALSE)

## Vector Operations - Logical ##
g <- x & y
print(g)

g <- x | y
print(g)

g <- x && y
print(g)

g <- x || y
print(g)
