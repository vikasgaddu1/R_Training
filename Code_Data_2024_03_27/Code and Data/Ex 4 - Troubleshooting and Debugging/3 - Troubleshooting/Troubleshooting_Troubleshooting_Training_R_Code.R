
#' Anova Accel2R - Clinical R Training -----------------------------------
#' © 2022 Anova Groups All rights reserved

# Title: Troubleshooting Your Code in R


## First Steps -------------------------------------------------------------

#' Step 1
#' Check the case sensitivity of your functions, R objects, and variables


#' Step 2
#' The `RStudio Global Options` has plenty of tools available to help you catch
#' issues before they become errors.
#'
#' In the Code options > Display > "Show Line Numbers" can help keep track of
#' where you are in your script
#'
#' Highlight R Function Calls ensures that R functions in the script are a
#' different color than R objects
#'
#' Rainbow Parentheses give each nested parentheses a unique color, to help
#' track operations when nesting functions and using many parentheses.  Also,
#' Ctrl+P will quickly jump to the beginning/end of the current parentheses

(((
  ((((((
    ((((((((
      "Rainbow Parentheses"
    ))))))))
  ))))))
)))

paste("Random Sample Mean:", format(mean(runif(100)), digits = 3))


#' Step 3
#' Code > Diagnostics: Show diagnostics for R enables RStudio to check arguments
#' to function calls, to ensure names you are using are actually present in your
#' script.  When the options are checked, then RStudio will provide an icon in
#' the script editor if it detects that there is an issue.  Hovering over the
#' icon will display a tip about how to resolve this issue

#' Error
print(123.456 digits = 100)

#' Warning
x <- undefined_name

#' Suggestion
mean (1 : 100)



## Implicit Errors ---------------------------------------------------------

#' Many functions in R change their functionality based on the type of input
#' that is given.  This allows for flexibility in how a function can be used for
#' a variety of use cases, however one of the downsides to this is that it
#' allows for undefined arguments to passed in as if they were actual arguments
#' to the function.


#' For example, place your cursor in the function and let the help menu pop up.
#' You'll see the definition suggests `mean(x, ...)` is the proper usage, but
#' that isn't helpful

mean(x, )


#' If we want to remove missing values from the input, we can specify any of
#' these arguments:

mean(1:50, na.rm   = T)
mean(1:50, rm.na   = T)
mean(1:50, remove  = T)
mean(1:50, missing = F)


#' You'll see that they all return a valid result, but only only one of them is
#' a valid argument to the `mean()` function.  If the input actually contains a
#' missing value, then `na.rm` will actually remove the missing value, but the
#' others return `NA`.  This is tricky because the operation still succeeded
#' without any warnings or errors

mean(c(10, NA, 30, 40), na.rm   = T)
mean(c(10, NA, 30, 40), rm.na   = T)
mean(c(10, NA, 30, 40), remove  = T)
mean(c(10, NA, 30, 40), missing = F)


#' To combat this, always confirm the valid arguments to a function by checking
#' out the documentation.  The documentation tells use that `na.rm` is the only
#' valid argument to remove missing values for this function.

help(mean)



## Tidyverse Pipelines -----------------------------------------------------

library(dplyr)
library(palmerpenguins)

#' Data for demonstration has categories, integers, and numeric values
penguins

#' Tidyverse packages have been working to improve error handling and debugging.
#' Notice the note there that says we can use the 'rlang' package with
#' 'last_trace()' to get a better idea of what went wrong and where

penguins %>%
  group_by(species) %>%
  slice_max(bill_length_mm, n = 3) %>%
  ungroup() %>%
  arrange(bill_length_mm) %>%
  select(species, island, bill_length_mm, body_mass_g) %>%
  mutate(
    new_var_1 = bill_length_mm / 10,
    new_var_2 = paste("The Island of", island),
    new_var_3 = if_else(species == "Gentoo", "Other", species)
  )

#' Easily see the output of a tidyverse pipeline at any point with `%>% print()`

penguins %>%
  group_by(species) %>%
  slice_max(bill_length_mm, n = 3) %>%
  ungroup() %>%
  arrange(bill_length_mm) %>%
  select(species, island, bill_length_mm, body_mass_g) %>% print()
mutate(
  new_var_1 = bill_length_mm / 10,
  new_var_2 = paste("The Island of", island),
  new_var_3 = if_else(species == "Gentoo", "Other", species)
)


#' See all steps of a tidyverse pipeline with many ` %>% print() %>% `

penguins %>%
  group_by(species) %>% print() %>%
  slice_max(bill_length_mm, n = 3) %>% print() %>%
  mutate(
    new_var_1 = bill_length_mm / 10
  )



## Documentation -----------------------------------------------------------

#' Website References
#' - RStudio Code Diagnostics: [https://support.rstudio.com/hc/en-us/articles/205753617-Code-Diagnostics-in-the-RStudio-IDE]
#' - StackOverflow Example: [https://stackoverflow.com/questions/46123285/printing-intermediate-results-without-breaking-pipeline-in-tidyverse]


# -------------------------------------------------------------------------
