## README

This repository is for the course "R Programming for SAS Programmers" by Anova Groups.

### GitHub Repository Setup Steps

1. **Create a GitHub Account**
   - Sign up for an account at [github.com](https://github.com).
   - Vikas will add you as a contributor to the repository.

2. **Set Up Posit Cloud (formerly RStudio Cloud)**
   - Create an account on [posit.cloud](https://posit.cloud).
   - Create a new project using the Git repository URL: `https://github.com/vikasgaddu1/R_Training.git`.
   - Navigate to `Tools` > `Version Control` > `Project Setup`, select `Git`, and restart RStudio.

3. **Configure Git Global Options**
   - Open the terminal and set your global Git configuration:
     ```bash
     git config --global user.email "you@example.com"
     git config --global user.name "Your Name"
     ```

4. **Create an SSH Key in RStudio**
   - Go to `Tools` > `Global Options` -> `Git/SVN` -> and create an SSH key using the create `SSH key` button under SSH window in R studio.
   - In the terminal, display your SSH public key:
     ```bash
     cat ~/.ssh/id_ed25519.pub
     ```
   - Copy the SSH public key.

5. **Add SSH Key to GitHub**
   - Go to [GitHub settings](https://github.com/settings/keys).
   - Click on `SSH and GPG keys`, then `New SSH key`.
   - Add a description like `rstudio_cloud` and paste the SSH key you copied earlier.

6. **Set Up Git Remote in RStudio**
   - In the terminal, remove the existing remote and add the correct one:
     ```bash
     git remote remove origin
     git remote add origin git@github.com:vikasgaddu1/R_Training.git
     git remote -v
     ```

7. **Confirm SSH Connection**
   - Verify the SSH connection to GitHub: and if prompted say 'yes`
     ```bash
     ssh -T git@github.com 
     ```
8. **Create test file**
   - create the test file in the folder under Code_data_2024_03_27/GH_testfolder/Name_testfile.r
   - go to upper right corner Git tab in Rstudio, stage the file by clicking the check box and press the `commit` icon, put initial commit as comment and press ok.
   - go to terminal and type
     ```bash
       git push origin main
     ```
   - go to github.com and navigate to r training repository and verify if you can see your file.

By following these steps, you will have your development environment set up for the course "R Programming for SAS Programmers."

<p xmlns:cc="http://creativecommons.org/ns#">

This work is licensed under <a href="https://creativecommons.org/licenses/by-nc/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY-NC 4.0<img src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" style="height:22px!important;margin-left:3px;vertical-align:text-bottom;"/><img src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" style="height:22px!important;margin-left:3px;vertical-align:text-bottom;"/><img src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" style="height:22px!important;margin-left:3px;vertical-align:text-bottom;"/></a>

</p>
