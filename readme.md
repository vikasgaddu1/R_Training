## README

Repository for the course "R programming for SAS programmer" by Anova Groups.

### GitHUB repo steps
Create a github.com account
Vikas will add you as contributor

Create an account on posit.cloud
Create New project -> https://github.com/vikasgaddu1/R_Training.git
Tools -> Version Control -> project setup -> select git and restart R

Go to Terminal and add global options
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

Tools -> Global options -> Create SSH Key in R studio
In terminal type cat ~/.ssh/id_ed25519.pub
Copy the ssh public key
Go to github.com -> click icon on right ->settings -> ssh and gpg keys -> click 'new ssh key' ->
description add 'rstudio_cloud' and paste ssh key from above step

Come back to r studio and in terminal type following
git remote remove origin
git remote add origin git@github.com:vikasgaddu1/R_Training.git  
git remote -v

confirm the connection by
ssh -T git@github.com


<p xmlns:cc="http://creativecommons.org/ns#">

This work is licensed under <a href="https://creativecommons.org/licenses/by-nc/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY-NC 4.0<img src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" style="height:22px!important;margin-left:3px;vertical-align:text-bottom;"/><img src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" style="height:22px!important;margin-left:3px;vertical-align:text-bottom;"/><img src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" style="height:22px!important;margin-left:3px;vertical-align:text-bottom;"/></a>

</p>
