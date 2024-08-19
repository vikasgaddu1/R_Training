
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2020 Anova Groups All rights reserved

# Title: Introduction to Statistical Functions in R

# Packages & Functions on Display:
# - {stats   4.0.2}: chisq.test(), cor(), cor.test(), t.test()
# - {broom   0.7.0}: tidy(), augment()
# - {janitor 2.0.1}: tabyl()


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
library(janitor)
library(broom)


# The Data ----------------------------------------------------------------
# https://bmcmedinformdecismak.biomedcentral.com/articles/10.1186/s12911-020-1023-5
# - Davide Chicco, Giuseppe Jurman: Machine learning can predict survival of
#  patients with heart failure from serum creatinine and ejection fraction alone.
#  BMC Medical Informatics and Decision Making 20, 16 (2020)

data_heart <-
  read_csv("data/heart.csv",
           col_types = cols(
             age                      = col_double(),
             anaemia                  = col_factor(),
             creatinine_phosphokinase = col_double(),
             diabetes                 = col_factor(),
             ejection_fraction        = col_double(),
             high_blood_pressure      = col_factor(),
             platelets                = col_double(),
             serum_creatinine         = col_double(),
             serum_sodium             = col_double(),
             sex                      = col_factor(),
             smoking                  = col_factor(),
             time                     = col_double(),
             DEATH_EVENT              = col_factor()
           ))

data_heart %>% glimpse()


# Chi-Square Test ---------------------------------------------------------

data_heart %>% tabyl(sex)
data_heart %>% tabyl(diabetes)


# With a Pre-Defined Table
tabyl_chisq <- data_heart %>% tabyl(sex, diabetes) %>% print()
janitor::chisq.test(tabyl_chisq)

table_chisq <- base::table(data_heart$sex, data_heart$diabetes) %>% print()
stats::chisq.test(table_chisq)


# Using Raw Data
stats_chisq <- chisq.test(data_heart$sex, data_heart$diabetes) %>% print()


# Using Results
stats_chisq %>% typeof()
stats_chisq %>% class()

names(stats_chisq)
stats_chisq$statistic


# Tidying the Results
broom::tidy(stats_chisq)
broom::augment(stats_chisq)


# Goodness of Fit Test
table_gft <-
  data_heart %>%
  count(sex, name = "actual") %>%
  mutate(expected = ifelse(sex == 0, 0.40, 0.60)) %>%
  print()

stats_gft <- chisq.test(table_gft$actual, p = table_gft$expected)
stats_gft
stats_gft %>% tidy()
stats_gft %>% augment()


# Different Tests
fisher.test(data_heart$sex, data_heart$diabetes) %>% print()

chisq.test(data_heart$sex, data_heart$diabetes, correct = TRUE) %>% print()
chisq.test(data_heart$sex, data_heart$diabetes, correct = FALSE) %>% print()

mcnemar.test(data_heart$sex, data_heart$diabetes, correct = TRUE) %>% print()
mcnemar.test(data_heart$sex, data_heart$diabetes, correct = FALSE) %>% print()

mantelhaen.test(data_heart$sex, data_heart$smoking, data_heart$diabetes, correct = TRUE) %>% print()
mantelhaen.test(data_heart$sex, data_heart$smoking, data_heart$diabetes, correct = FALSE) %>% print()


# Documentation
help(tidy,            package = "generics")
help(chisq.test,      package = "stats")
help(fisher.test,     package = "stats")
help(mcnemar.test,    package = "stats")
help(mantelhaen.test, package = "stats")


# Correlation -------------------------------------------------------------

summary(data_heart$age)
summary(data_heart$platelets)

# Correlation Matrix
data_numeric <- data_heart %>% select(where(is.numeric))
stats::cor(data_numeric)
stats::cor(data_numeric, use = "all.obs")
stats::cor(data_numeric, use = "complete.obs") %>% as_tibble(rownames = "var_name")


# Correlation Estimate
stats::cor(data_heart$age, data_heart$platelets)


# Correlation Test
stats_cor_1 <- stats::cor.test(data_heart$age, data_heart$platelets, method = "pearson") %>% print()
stats_cor_2 <- stats::cor.test(data_heart$age, data_heart$platelets, method = "spearman") %>% print()


# Using Results
stats_cor_1 %>% typeof()
stats_cor_2 %>% class()

stats_cor_1 %>% names()
stats_cor_2$p.value


# Tidying the Results
stats_cor_1 %>% tidy()


# Documentation
help(cor,      package = "stats")
help(cor.test, package = "stats")

# See Also
help(var, package = "stats")
help(cov, package = "stats")


# T-Test ------------------------------------------------------------------

summary(data_heart$sex)
summary(data_heart$platelets)

# Independent T-Test
stats_indt <- stats::t.test(data_heart$platelets, mu = 260000) %>% print()


# Paired T-Test
# stats_part <- stats::t.test(data$before_value, data$after_value, paired = TRUE)


# Two Sample T-Test
stats_twot <- stats::t.test(platelets ~ sex, data = data_heart, var = TRUE) %>% print()


# Welch Two Sample T-Test
stats_welt <- stats::t.test(platelets ~ sex, data = data_heart, var = FALSE) %>% print()


# Using Results
stats_indt %>% typeof()
stats_indt %>% class()

stats_indt %>% names()
stats_indt$conf.int


# Tidying the Results
stats_twot %>% tidy()


# Checking Assumptions
shapiro.test(data_heart$platelets)
shapiro.test(data_heart$platelets) %>% tidy()


# Using Base R Plots - Not Easily Edited
hist(data_heart$platelets)
qqnorm(data_heart$platelets)


# Using ggplot2
ggplot(data_heart, aes(x = platelets)) + geom_histogram()
ggplot(data_heart, aes(sample = platelets)) + geom_qq()



# Documentation
help(t.test,       package = "stats")
help(wilcox.test,  package = "stats")
help(shapiro.test, package = "stats")
help(tidy.aov,     package = "broom")


# See Also
# - Wilcoxon Signed-Rank, Wilcoxon Matched Pairs, Mann-Whitney U Test
help(wilcox.test, package = "stats")


# Extension Packages ------------------------------------------------------

# corrr: A tool for exploring correlations
# infer: Perform inference using tidy design framework
# corrplot: A graphical display of a correlation matrix
# ggstatsplot: Conduct tests and create customizable ggplots with simple functions


# A Note ------------------------------------------------------------------
# R rounds half-to-even, following the IEC 60559 standard, which differs
# from rounding in SAS, and rounding that we learned in elementary math class

# https://www.rdocumentation.org/packages/base/versions/3.5.2/topics/Round

# -------------------------------------------------------------------------
