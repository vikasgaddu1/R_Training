# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Setup
a <- 1234.56789

# Rounding functions
round(a, 1)
ceiling(a)
floor(a)
trunc(a)
signif(a, 6)

# Format function for dates
format(Sys.Date(), format = "%d%b%Y")

# Format function also works with numbers
format(a, digits = 5, nsmall = 1)
format(a,
       digits = 5,
       nsmall = 1,
       width = 10)

# Change separators
format(a, big.mark = ",")
format(a,
       digits = 10,
       decimal.mark = ",",
       big.mark = ".")

# Format function also works with characters
sites <- c("San Francisco", "London", "Tokyo")
format(sites, width = 10, justify = "right")
format(sites, width = 10, justify = "left")

# sprintf function
sprintf("%f", a)         # Floating point number
sprintf("%.1f", a)       # One decimal place
sprintf("%8.1f", a)      # Fixed width
sprintf("%-8.1f", a)     # Fixed width left justified
sprintf("%08.1f", a)     # Zero padded
sprintf("%+.1f", a)      # Forced sign
sprintf("%+.1f",-a)     # Negative
sprintf("%.1f%%", a)     # Percentage
sprintf("$%.2f", a)      # Currency

# Formatting codes
# %s = string
# %d = integer
# %f = decimal number

# Interpolation
sprintf("Site: %s", sites)

# More interpolation
counts <- c(2, 126, 154)
sprintf("Site: %s, Count: %d", sites, counts)
sprintf("Site: %s, Count: %d, Percent: %.1f%%",
        sites,
        counts,
        counts / sum(counts) * 100)



# Use Cases ---------------------------------------------------------------


# Counts and Percents
sprintf("%d (%.1f%%)", counts, counts / sum(counts) * 100)

# Counts and Percents - Fixed width and Low indicator
pcts <- counts / sum(counts) * 100
pcts
pctf <-
  ifelse(pcts > 0 & pcts < 1 , "< 1.0", sprintf("%5.1f", pcts))
pctf
sprintf("%d (%s%%)", counts, pctf)


# Count and percent function
cnt_pct <- function(cnt, denom) {
  # Calculate Percent
  pcts <- cnt / denom * 100
  
  # Deal with values between 0 and 1
  pctf <-
    ifelse(pcts > 0 & pcts < 1 , "< 1.0", sprintf("%5.1f", pcts))
  
  # Format result
  ret <- sprintf("%d (%s%%)", cnt, pctf)
  
  return(ret)
}


cnt_pct(counts, sum(counts))
