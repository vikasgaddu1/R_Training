
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Creating Packages with devtools

# Packages & Functions on Display:
# - {devtools 2.4.2}
# - {usethis  2.0.1}: create_package, create_tidy_package


# Setup -------------------------------------------------------------------
# Devtools is a meta-package that includes dozens of packages meant for assisting
# with common workflows in R and RStudio, including working projects and packages

library(devtools)


# Create Package Structure ------------------------------------------------
# Generally recommended to make a package its own project, but the limitations
# of RStudio Cloud prevent us from tying the package-project together

# Creating a Package:
# [RStudio ] : File > New Project > New Directory > New Package
# [Function] : create_package("path/to/my/package)

create_package("mypkg")


# Additional Assistance
# Once you're more familiar with package creation, create_tidy_package will
# provide helpful default settings, files, folders, and licenses
create_tidy_package("/path/to/my_tidy_pkg")


# Touring RStudio Build Menu ----------------------------------------------
# After creating and loading the project-package, restart/terminate RStudio
# to see the Build Menu and Build Panel


# Document             :  Compile all of the documentation you've written into
#                        corresponding help pages, vignettes, and NAMESPACE file
#
#
# Load All             :  Load all the functions you've written for the package,
#                        useful for testing the functions as you write them
#
#
# Test Package         :  Run all the unit tests you've created to test your
#                        functions
#
#
# Check Package        :  Check the package files, directory structure, and unit
#                        tests for proper specification
#
#
# Install and Restart  :  Test the installation of your package, simulating a
#                        install.packages() and library() call
#
#
# Build Source Package :  Compile the source files and directories into tar.gz
#                        file.  Requires external development tools, but able
#                        to be installed on any OS
#
#
# Build Binary Package :  Compile the source files and directories into OS
#                        specific file format.  Does not require external
#                        development tools, but able to be installed only on
#                        OS that built the package



# Anatomy of a Package ----------------------------------------------------
# Looking at the Files Panel, we see an automatically created directory
# structure to house our package components

# R/            : Directory that will store the scripts for your functions
#
# DESCRIPTION   : File contains basic documentation for package (author,
#                version, package dependencies, etc.)
#
# NAMESPACE     : File contains the package functions that are 'exported' for
#                the end user to use
#
# package.Rproj : File containing the RStudio package-project
# .gitignore    : File listing the files that will be not be included in Git version control
# .Rbuildignore : File listing the files that will be not be included in the final package



# Note:
# This structure will change as we continue through the development process


# Documentation -----------------------------------------------------------

# Help Pages
help(create_package,      package = "usethis")
help(create_tidy_package, package = "usethis")

# Learn More:
# https://r-pkgs.org/whole-game.html

# Websites
# usethis    : https://usethis.r-lib.org
# devtools   : https://devtools.r-lib.org/
# R Packages : https://r-pkgs.org



# Package Development Keyboard Shortcuts
# Description 	          Windows & Linux 	Mac
# Document Package 	      Ctrl+Shift+D 	    Cmd+Shift+D
# Load All             	  Ctrl+Shift+L 	    Cmd+Shift+L
# Test Package (Desktop) 	Ctrl+Shift+T 	    Cmd+Shift+T
# Test Package (Web) 	    Ctrl+Alt+F7 	    Cmd+Option+F7
# Check Package 	        Ctrl+Shift+E 	    Cmd+Shift+E
# Build and Reload 	      Ctrl+Shift+B 	    Cmd+Shift+B

# -------------------------------------------------------------------------
