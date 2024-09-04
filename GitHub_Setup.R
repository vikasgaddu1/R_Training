install.packages("usethis")
library(usethis)

usethis::use_git_config(user.name = "Your Name", user.email = "Your@Email.com")

usethis::create_github_token()
# 

usethis::edit_r_environ()
usethis::use_git()
usethis::use_github()
