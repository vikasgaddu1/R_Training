### GitHub Repository Setup Steps
# 
# 1. **Create a GitHub Account**
#   - Sign up for an account at [github.com](https://github.com).
# - Vikas will add you as a contributor to the repository.
# 
# 2. **Set Up Posit Cloud (formerly RStudio Cloud)**
#   - Create an account on [posit.cloud](https://posit.cloud).
# - Create a new project using the Git repository URL: `https://github.com/vikasgaddu1/R_Training.git`.
# - Navigate to `Tools` > `Version Control` > `Project Setup`, select `Git`, and restart RStudio.

# Install and load the usethis package, which provides functions to streamline project setup and management
install.packages("usethis")
library(usethis)

# Configure Git with your name and email, necessary for committing changes
usethis::use_git_config(user.name = "Your Name", user.email = "Your@Email.com")

# Create a GitHub Personal Access Token (PAT) for authentication
usethis::create_github_token()

# Open the .Renviron file to store the PAT securely
usethis::edit_r_environ()

# Add user entry in .Renviron file so that no secrets are explicitly written.

# Initialize a Git repository in the current project
usethis::use_git()

# Set up a Git remote named 'origin', allowing for overwriting if it already exists
usethis::use_git_remote("origin", url = NULL, overwrite = TRUE)

# Uncomment the following line if you want to create a new GitHub repository and link it to the local project
# usethis::use_github()

# Retrieve the GitHub PAT and username from environment variables
pat <- Sys.getenv("GITHUB_PAT")
user <- Sys.getenv("GITHUB_USER")

# Add a Git remote with authentication details using the PAT and username
usethis::use_git_remote(
  url = paste0("https://", user, ":", pat, "@github.com/vikasgaddu1/R_Training.git"),
  name = "origin"
)

# List the current Git remotes to verify the setup
usethis::git_remotes()

# Display the Git remotes using a system command to ensure they are correctly configured
system("git remote -v")

# Construct the full file name with an extension, e.g., .csv, in a specific directory
file_name <- file.path("Code_Data_2024_03_27", "GH_testfolder", paste0(user, ".csv"))

# Create a sample data frame to write to the file
data <- data.frame(x = 1:5, y = letters[1:5])

# Write the data frame to a CSV file using the constructed file name
write.csv(data, file = file_name, row.names = FALSE)

# Commit the changes using the RStudio interface (manual step)

# Push the changes to GitHub
system("git push origin main")

# Go to github.com and navigate to the R_Training repository to verify if you can see your file (manual step)

# Use a reproducible environment for our R project to avoid compatibility issues.
install.packages("renv")
library(renv)


# To create a .lock file
# renv::init() # Commented as we will inherit the .lock file from github

# Creates environment with same package version
renv::restore()

# if new packages installed then use snapshot command to update the lock file
renv::snapshot()


