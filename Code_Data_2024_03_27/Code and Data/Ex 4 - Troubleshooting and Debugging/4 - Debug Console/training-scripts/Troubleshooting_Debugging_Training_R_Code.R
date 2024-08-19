
#' Anova Accel2R - Clinical R Training -----------------------------------
#' © 2022 Anova Groups All rights reserved

#' Title: Using the Debug Console

#' Packages & Functions on Display:
#' - {base 4.1.2}:  debug(), undebug(), traceback(), browser()


# Getting Started ---------------------------------------------------------

#' Debugging works best when functions are defined in a separate script
#' from where they are being used
#' - See the function definitions in `debug-fn.R`
#' - Source the script
#' - Run the function

fn_run_operations(25)


# Debug with 'debug()' ----------------------------------------------------

#' The `debug()` function gives you complete control over the each step in the
#' operation of the function

debug(fn_run_operations)
fn_run_operations(25)

#' We notice a few things:
#' - The function script opens, showing the function being debugged
#' - The current operation is highlighted and shows a green arrow
#' - The console now displays Debug Menu buttons
#' - Browse[]> indicates the sub-environment level that we are currently seeing
#' - Environment Panel now shows function environment with temporary objects
#' - We can still use the console to explore temporary objects

#' `Debug Buttons`
#' Next:                 Run the next line of code
#' Step Into:            Delve into the next function environment
#' Finish Loop/Function: Finish the sub-function's operation
#' Continue:             Continue operation until breakpoint or completion
#' Stop:                 Exit the debug menu


#' Use `undebug()` to finish debugging this function
undebug(fn_run_operations)



# Introduce an Error ------------------------------------------------------

#' Now, let's introduce an error to this function by trying to perform
#' arithmetic on a number and a character

fn_run_operations(25)

#' The console shows us the error message, with two options:
#' - `Show Traceback`
#' - `Rerun with Debug`



## Locate Errors with Traceback --------------------------------------------
#' `Traceback` helps us locate the exact location of the error by showing the order of
#' operations and where the error occurs in each function
#' - Note: The `traceback()` function provides the same functionality without RStudio

#'   [Bottom of Traceback]
#'     Step 1: The error occurred inside fn_get_number(),
#'     Step 2: Inside `fn_get_number()`, the error occurred at line #31 with `fn_multiply()`
#'     Step 3: Inside `fn_multiply()`,   the error occurred at line #25 with `fn_division()`
#'     Step 4: Inside `fn_exponent()`,   the error occurred at line #19 with `fn_exponent()`
#'   [Top of Traceback]



# Debug with the Console --------------------------------------------------

#' `Rerun with Debug`
#' Now that we know the exact location of the error, we can `Rerun with Debug`
#' to see the debugging console.
#'
#'
#' Using this option takes us directly to the point where the error occurs.


# Debug with Breakpoints --------------------------------------------------

#' Again, debugging operations are best done when functions are stored in
#' separate scripts.  Using breakpoints requires RStudio to store each line of
#' code in memory, so we have to use the "Source" button again.

#' [Setting Breakpoints]
#' - RStudio Toolbar : 'Debug' > 'Toggle Breakpoint' at the specified line
#' - With your Cursor: Click to the left of the line number to insert a break point


#' So, let's set some breakpoints and run the function again.  Now, we will see
#' snapshots of the function environment as it exists at each break point.  Note
#' that break points stop the operations before executing the code on the line
#' where the breakpoint is placed

fn_run_operations(25)


# Debug with 'browser()' --------------------------------------------------

#' Similar to using the `traceback()` function above, if you are working outside
#' of RStudio, then you can place a breakpoint using the `broswer()` function.
#' Simply put a call to `browser()` where you want the operation to pause



# Documentation -----------------------------------------------------------

help(debug,     package = "base")
help(traceback, package = "base")

#' Website References
#' - https://adv-r.hadley.nz/debugging.html

# -------------------------------------------------------------------------
