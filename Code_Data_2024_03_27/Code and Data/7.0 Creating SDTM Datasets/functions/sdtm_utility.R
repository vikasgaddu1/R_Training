to_iso8601 <- Vectorize(function(day = NULL, month = NULL, year = NULL) {
  month_map <- c(
    JAN = 1, FEB = 2, MAR = 3, APR = 4, MAY = 5, JUN = 6,
    JUL = 7, AUG = 8, SEP = 9, OCT = 10, NOV = 11, DEC = 12
  )
  monthn <- month_map[month]

  # Handle missing components by replacing with '-'
  year_str <- if(is.null(year) | is.na(year)) "-" else sprintf("%04d", year)
  month_str <- if(is.null(month) | is.na(month)) "-" else sprintf("%02d", monthn)
  day_str <- if(is.null(day) | is.na(day)) "-" else sprintf("%02d", day)
  
  # Create initial date string
  date_str <- paste(year_str, month_str, day_str, sep="-")
  
  # Apply right-hand side truncation rule
  # If string ends with '-', remove trailing '-' characters
  while (endsWith(date_str, "-")) {
    date_str <- substr(date_str, 1, nchar(date_str)-1)
  }
  
  # Handle case where all components are missing
  if (date_str == "") {
    return("")
  }
  
  tryCatch({
    as.Date(date_str)
  }, error = function(e) {
    warning("Invalid date: ", date_str)
  })
  
  return(date_str)
})

