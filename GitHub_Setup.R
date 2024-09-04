install.packages("usethis")
library(usethis)

usethis::use_git_config(user.name = "Your Name", user.email = "Your@Email.com")

usethis::create_github_token()

usethis::edit_r_environ()
usethis::use_git()
usethis::use_git_remote("origin", url = NULL, overwrite = TRUE)
# usethis::use_github()

pat <- Sys.getenv("GITHUB_PAT")
user <- Sys.getenv("GITHUB_USER")

usethis::use_git_remote(
  url = paste0("https://", user, ":" , pat , "@github.com/vikasgaddu1/R_Training.git"),
  name = "origin"
)
usethis::git_remotes()
system("git remote -v")
system("git push origin main")


# On the Terminal tab
# git remote add origin https://<username>:<your PAT>@github.com/vikasgaddu1/R_Training.git
# git remote -v
# Create test file
# 
# create the test file in the folder under Code_data_2024_03_27/GH_testfolder/Name_testfile.r
# go to upper right corner Git tab in Rstudio, stage the file by clicking the check box and press the commit icon, put initial commit as comment and press ok.
# go to terminal and type
# git push origin main
# go to github.com and navigate to r training repository and verify if you can see your file.
