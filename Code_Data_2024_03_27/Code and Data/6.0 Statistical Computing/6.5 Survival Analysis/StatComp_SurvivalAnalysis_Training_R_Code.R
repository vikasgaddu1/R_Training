
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2020 Anova Groups All rights reserved

# Title: Introduction to Survival Analysis in R

# Packages & Functions on Display:
# - {broom     0.7.10}: tidy(), glance(), augment()
# - {survival  3.1.12}: Surv(), survfit(), summary(), quantile(), survdiff(), survreg(), coxph()
# - {survminer 0.4.80}: ggsurvevents(), ggsurvplot(), ggcoxdiagnostics()


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
library(broom)

library(survival)
library(survminer)


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
             DEATH_EVENT              = col_logical() # Event Indicator is TRUE / FALSE
           ))


data_heart %>% glimpse()

# Data Subset
data_train  <- data_heart[  1:150, ]
data_valid  <- data_heart[151:299, ]


# Define a Survival Vector ------------------------------------------------

surv_vct <- Surv(time = data_train$time, event = data_train$DEATH_EVENT)
surv_vct %>% print()
surv_vct %>% class()


# Plot Event Times
surv_gg <- survminer::ggsurvevents(surv_vct)
surv_gg
surv_gg %>% class()
surv_gg + labs(title = "New Title", subtitle = "A Subtitle", caption = "New Caption")


# Documentation
help(Surv, package = "survival")


# Working with Survival Time ----------------------------------------------
# Build model with intercept only

stats_surv_int <- survival::survfit(surv_vct ~ 1, data = data_train) %>% print()

# Working with the Model
stats_surv_int %>% typeof()
stats_surv_int %>% class()
stats_surv_int %>% names()
stats_surv_int$surv

# Tidying the Output
stats_surv_int %>% tidy()

# Time Estimates
stats_surv_int %>% summary(times = 5)
stats_surv_int %>% summary(times = 45:50)


# Documentation
help(survfit,         package = "survival")
help(summary.survfit, package = "survival")


# Stratified Survival Time ------------------------------------------------

stats_surv_st <- survival::survfit(surv_vct ~ sex, data = data_train) %>% print()

# Working with the Model
stats_surv_st %>% typeof()
stats_surv_st %>% class()
stats_surv_st %>% names()

# Tidying the Output
stats_surv_st %>% tidy()

# Time Estimates
stats_surv_st %>% summary(times = 10)


# Quantile Estimates
stats_surv_quantiles <- quantile(stats_surv_st) %>% print()
stats_surv_quantiles %>% typeof()
stats_surv_quantiles %>% map(class)

stats_surv_quantiles %>% map(as_tibble, rownames = "strata")


# Documentation
help(quantile.survfit, package = "survival")


# Categorizing Numeric Variables ------------------------------------------

# Find Numeric Percentiles
ntile_default <- quantile(data_heart$age) %>% print()
ntile_custom  <- quantile(data_heart$age, probs = c(0.10, 0.30, 0.80)) %>% print()

# Categorize Numeric Variable
base::findInterval(data_heart$age, ntile_default)
base::findInterval(data_heart$age, ntile_custom, rightmost.closed = FALSE, all.inside = FALSE, left.open = FALSE)

data_heart %>%
  mutate(age_Q = findInterval(age, ntile_default)) %>%
  select(age, age_Q)


# Categorical Numbers in a Model
survival::survfit(surv_vct ~ findInterval(age, ntile_default), data = data_train)


# See Also
help(surv_median,     package = "survminer")
help(surv_cutpoint,   package = "survminer")
help(surv_categorize, package = "survminer")


# Documentation
help(findInterval, package = "base")


# Kaplan-Meier Plots ------------------------------------------------------

# Using Base Plots - Hard Edit
stats_surv_st %>% plot()


# Using ggsurvplot and ggplot2
stats_surv_st %>% survminer::ggsurvplot()

stats_surv_st %>%
  survminer::ggsurvplot(conf.int = TRUE,
                        pval = TRUE,
                        pval.method = TRUE,
                        risk.table = TRUE) +
  labs(caption = "A Regular Caption")

# Cumulative Event Plot
stats_surv_st %>% survminer::ggsurvplot(fun = "event")

# Cumulative Hazard Plot
stats_surv_st %>% survminer::ggsurvplot(fun = "cumhaz")


# Documentation
help(ggsurvplot, package = "survminer")


# Log Rank Tests ----------------------------------------------------------

stats_surv_lrt <- survival::survdiff(surv_vct ~ sex, data = data_train) %>% print()

# Working with the Model
stats_surv_lrt %>% names()

# Tidying the Output
stats_surv_lrt %>% tidy()
stats_surv_lrt %>% glance()


# Stratified Log Rank Test
stats_surv_slr <- survival::survdiff(surv_vct ~ sex + strata(smoking), data = data_train) %>% print()
stats_surv_slr %>% names()

stats_surv_slr %>% tidy()
stats_surv_slr %>% glance()


# Documentation
help(strata,   package = "survival")
help(survdiff, package = "survival")


# Cox Proportional Hazards ------------------------------------------------

stats_surv_cph   <- survival::coxph(surv_vct ~ age + sex,         data = data_train) %>% print()
stats_surv_cph_s <- survival::coxph(surv_vct ~ age + strata(sex), data = data_train) %>% print()


# Working with the Model
stats_surv_cph %>% typeof()
stats_surv_cph %>% class()
stats_surv_cph %>% names()

stats_surv_cph$method
stats_surv_cph %>% stats::coefficients()
stats_surv_cph %>% stats::logLik()


# Tidying the Output
stats_surv_cph %>% tidy()
stats_surv_cph %>% glance()


# Model Prediction - Validation Data
stats_surv_cph %>% predict(newdata = data_valid)
stats_surv_cph %>% broom::augment(newdata = data_valid)


# Model Prediction - Testing Data
data_test <- tibble(age = 50, sex = factor(0))
stats_surv_cph %>% augment(newdata = data_test)


# CPH Diagnostics
stats_surv_cph %>% survminer::ggcoxdiagnostics()
stats_surv_cph %>% survminer::ggcoxdiagnostics(type = "deviance")
stats_surv_cph %>% survminer::ggcoxdiagnostics(type = "deviance", ox.scale = "observation.id")
stats_surv_cph %>% survminer::ggcoxdiagnostics(type = "deviance", ox.scale = "linear.predictions")


# CPH Assumptions - Schoenfeld Test
stats_surv_cph_a <- stats_surv_cph %>% survival::cox.zph()
stats_surv_cph_a
stats_surv_cph_a %>% ggcoxzph()


# Documentation
help(coxph,            package = "survival")
help(cox.zph,          package = "survival")
help(ggcoxdiagnostics, package = "survminer")


# Parametric Models -------------------------------------------------------

# Exponential Model
stats_surv_exp <- survreg(surv_vct ~ age + sex + platelets, data = data_train, dist = "exponential")

# Weibull Model
stats_surv_wei <- survreg(surv_vct ~ age + sex + platelets, data = data_train, dist = "weibull")

# Plots
survminer::ggsurvevents(fit = stats_surv_exp, data = data_valid, type = "cumulative")


# Documentation
help(survreg,      package = "survival")
help(ggsurvevents, package = "survminer")


# Documentation -----------------------------------------------------------

# Vignettes
vignette("survival", package = "survival")

# Website References
# Cheatsheet - https://rpkgs.datanovia.com/survminer/survminer_cheatsheet.pdf


# A Note ------------------------------------------------------------------
# R rounds half-to-even, following the IEC 60559 standard, which differs
# from rounding in SAS, and rounding that we learned in elementary math class

help(round, package = "base")

# -------------------------------------------------------------------------
