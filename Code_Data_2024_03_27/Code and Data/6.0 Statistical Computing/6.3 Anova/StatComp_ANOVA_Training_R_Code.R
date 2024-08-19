
# Anova Accel2R - Clinical R Training -----------------------------------

# Title: Introduction to ANOVA in R

# Packages & Functions on Display:
# - {stats   4.0.2}: aov(), bartlett.test(), shapiro.test(), TukeyHSD(), pairwise.t.test()
# - {broom   0.7.0}: tidy(), augment(), glance()


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
library(broom)


# The Data ----------------------------------------------------------------
# https://bmcmedinformdecismak.biomedcentral.com/articles/10.1186/s12911-020-1023-5
# - Davide Chicco, Giuseppe Jurman: Machine learning can predict survival of
#  patients with heart failure from serum creatinine and ejection fraction alone.
#  BMC Medical Informatics and Decision Making 20, 16 (2020)

# Missing Values: Remove or impute prior to any using statistics functions
# Factor Variables: Results differ based on variable types. Ensure factor for char or binary

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


# Conducting the Test -----------------------------------------------------

summary(data_heart$age)
summary(data_heart$sex)
summary(data_heart$anaemia)
summary(data_heart$platelets)

# One Way ANOVA
stats_anova_1 <- aov(platelets ~ sex,           data = data_heart) %>% print()

# One Way ANCOVA
stats_anova_2 <- aov(platelets ~ sex + age,     data = data_heart) %>% print()

# Two Way ANOVA
stats_anova_3 <- aov(platelets ~ sex + anaemia, data = data_heart) %>% print()

# Factorial ANOVA
stats_anova_4 <- aov(platelets ~ sex + anaemia + sex:anaemia, data = data_heart) %>% print()
stats_anova_5 <- aov(platelets ~ sex * anaemia,               data = data_heart) %>% print()

# See Also
help(oneway.test,  package = "stats")
help(kruskal.test, package = "stats")


# Using the Model ---------------------------------------------------------

stats_anova_1 %>% typeof()
stats_anova_2 %>% class()

stats_anova_1 %>% names()
stats_anova_2$coefficients


# Tidying the Results
diagnostic_table   <- stats_anova_3 %>% broom::tidy()    %>% print()
diagnostic_values  <- stats_anova_4 %>% broom::augment() %>% print()
diagnostic_summary <- stats_anova_5 %>% broom::glance()  %>% print()


# Model Diagnostics
# - base::plot() has pre-defined plots, but not easy to save/edit/export
# - May need to create your own using ggplot2 and the tidy/augment/glance data
plot(stats_anova_3)


# See Also
help(anova,        package = "stats")
help(residuals,    package = "stats")
help(coefficients, package = "stats")


# Model Assumptions -------------------------------------------------------

# Normality Test
shapiro.test(diagnostic_values$.resid)
shapiro.test(diagnostic_values$.resid) %>% tidy()

# Constant Variance
bartlett.test(platelets ~ sex, data = data_heart)
bartlett.test(platelets ~ sex, data = data_heart) %>% tidy()

# Using Base R Plots - Not Easily Edited
hist(diagnostic_values$.resid)
qqnorm(diagnostic_values$.resid)

# Using ggplot2
ggplot(diagnostic_values, aes(x = .resid)) + geom_histogram()
ggplot(diagnostic_values, aes(sample = .resid)) + geom_qq()


# Adjustments and Contrasts -----------------------------------------------

# Tukey
stats_tukey <- TukeyHSD(stats_anova_3) %>% print()
stats_tukey %>% tidy()
stats_tukey %>% plot()


# Comparisons
p.adjust.methods
pairwise.t.test(data_heart$age, g = data_heart$anaemia,
                p.adjust.method = "holm",
                pool.sd = FALSE,
                paired = FALSE)


# Contrasts
aov(platelets ~ sex * anaemia,
    data = data_heart,
    contrasts = list(sex = contr.treatment, anaemia = contr.SAS)) %>%
  print()


# See Also
help(p.adjust,             package = "stats")
help(contrasts,            package = "stats")
help(pairwise.table,       package = "stats")
help(pairwise.prop.test,   package = "stats")
help(pairwise.wilcox.test, package = "stats")


# Documentation -----------------------------------------------------------

help(aov,             package = "stats")
help(glance,          package = "broom")
help(augment,         package = "generics")
help(TukeyHSD,        package = "stats")
help(bartlett.test,   package = "stats")
help(pairwise.t.test, package = "stats")

# External Packages -------------------------------------------------------

# car: Additional functions to assist with statistical inference and unbalanced designs
# rstatx: A package to assist with viewing and visualizing results of statistical analyses
# emmeans: Assists with finding estimated marginal means for linear and mixed models
# ggstatsplot: Conduct tests and create customizable ggplots with simple functions


# A Note ------------------------------------------------------------------
# R rounds half-to-even, following the IEC 60559 standard, which differs
# from rounding in SAS, and rounding that we learned in elementary math class

# https://www.rdocumentation.org/packages/base/versions/3.5.2/topics/Round

# -------------------------------------------------------------------------
