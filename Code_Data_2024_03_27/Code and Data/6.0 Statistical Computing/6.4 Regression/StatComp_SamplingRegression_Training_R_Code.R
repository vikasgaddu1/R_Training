
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2020 Anova Groups All rights reserved

# Title: Introduction to Regression in R

# Packages & Functions on Display:
# - {stats 4.0.2}: lm(), glm(), predict(), shapiro.test(),
#                 step(), anova(), AIC(), BIC()
# - {broom 0.7.0}: tidy(), glance(), augment()


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
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


# Data Sampling -----------------------------------------------------------

# Taking a Random Sample
sample(1:100, size = 5)
sample(1:100, size = 5)


# Controlling the RNG Seed
set.seed(42)
sample(1:100, size = 5)


# RNG Seed Set at Time of Execution
set.seed(42)
sample(1:100, size = 5)
sample(1:100, size = 5)


# Running Code Line-by-Line
set.seed(42)
sample(1:100, size = 5)
set.seed(42)
sample(1:100, size = 5)


# Random Subset of Data
set.seed(42)
data_heart %>% slice_sample(n = 5)

set.seed(42)
data_heart %>% slice_sample(n = 5)
data_heart %>% slice_sample(n = 5)


# Training and Validation Data Split
set.seed(42)
data_train <- data_heart %>% slice_sample(prop = 0.75)
data_valid <- anti_join(data_heart, data_train)


# With Bigger Data, Random Index Works Better
set.seed(42)
data_nrow <- data_heart %>% nrow() %>% print()
data_indx <- data_nrow %>% seq_len() %>% print()
smp_train <- data_indx %>% sample(size = floor(data_nrow * 0.75)) %>% print()
smp_valid <- setdiff(data_indx, smp_train) %>% print()


# Using Fixed Row Selection for Demonstration
data_train  <- data_heart[  1:150, ]
data_valid  <- data_heart[151:299, ]


# Building the Model ------------------------------------------------------

summary(data_train$age)
summary(data_train$serum_sodium)


# Linear Regression
stats_ols <- lm(platelets ~ age, data = data_train) %>% print()
stats_mlr <- lm(platelets ~ age + serum_sodium, data = data_train) %>% print()


# Using the Model
stats_ols %>% typeof()
stats_ols %>% class()

stats_ols %>% names()
stats_ols$coefficients

# Tidying the Model
diagnostic_table    <- stats_mlr %>% broom::tidy() %>% print()
diagnostic_table_ci <- stats_mlr %>% broom::tidy(conf.int = TRUE) %>% print()

diagnostic_values   <- stats_mlr %>% broom::augment() %>% print()
diagnostic_summary  <- stats_mlr %>% broom::glance() %>% print()


# Model Diagnostics -------------------------------------------------------

# Normal Distribution
shapiro.test(diagnostic_values$.std.resid)
plot(stats_mlr)

ggplot(diagnostic_values, aes(x = .std.resid))      + geom_histogram()
ggplot(diagnostic_values, aes(sample = .std.resid)) + geom_qq()

# Linear Relationship
ggplot(diagnostic_values, aes(x = .resid, y = .fitted)) + geom_point()

# Non-Constant Variance
ggplot(diagnostic_values, aes(x = .std.resid, y = .fitted)) +
  geom_point() +
  scale_x_sqrt()

# Outliers
diagnostic_values %>% slice_max(.hat, n = 5)
diagnostic_values %>% slice_max(.cooksd, n = 5)

# Collinearity
data_train %>%
  select(where(is.numeric)) %>%
  cor()


# Model Comparison --------------------------------------------------------

step(stats_mlr, direction = "backward")

anova(stats_ols, stats_mlr)

stats_mlr %>% AIC()
stats_mlr %>% BIC()


# Model Prediction --------------------------------------------------------

data_train
data_valid
data_new <- tibble(age = 50, serum_sodium = 130, platelets = 225000)

predict(stats_mlr, data_valid)
predict(stats_mlr, data_new)

augment(stats_mlr, newdata = data_valid)
augment(stats_mlr, newdata = data_new)


# Logistic Regression -----------------------------------------------------

stats_lr <-
  glm(DEATH_EVENT ~ age + platelets + smoking, data = data_train,
      family = "binomial")

stats_lr_0 <-
  glm(relevel(DEATH_EVENT, ref = "0") ~ age + platelets + smoking, data = data_train,
      family = "binomial")

stats_lr_1 <-
  glm(relevel(DEATH_EVENT, ref = "1") ~ age + platelets + smoking, data = data_train,
      family = "binomial")

# Using the Results
stats_lr
stats_lr$coefficients
stats_lr %>% AIC()
stats_lr %>% step(direction = "both")

# Tidying the Results
stats_lr %>% glance()
stats_lr %>% augment()

stats_lr %>% tidy()
stats_lr %>% tidy(conf.int = TRUE)
stats_lr %>% tidy(conf.int = TRUE, exponentiate = TRUE)    # Request Odds Ratios

# Diagnostics
plot(stats_lr)

# Prediction
predict(stats_lr_1, new_data = data_valid, type = "response")
augment(stats_lr_1, new_data = data_valid, type.predict = "response")


# Documentation -----------------------------------------------------------

help(lm,          package = "stats")
help(glm,         package = "stats")
help(AIC,         package = "stats")
help(step,        package = "stats")
help(anova,       package = "stats")
help(plot.lm,     package = "stats")
help(predict.lm,  package = "stats")
help(predict.glm, package = "stats")

help(tidy.lm,     package = "broom")
help(tidy.glm,    package = "broom")
help(glance.lm,   package = "broom")
help(glance.glm,  package = "broom")
help(augment.lm,  package = "broom")
help(augment.glm, package = "broom")

# External Packages -------------------------------------------------------

# - car: Additional functions to assist with statistical inference and unbalanced designs
# - rstatx: A package to assist with viewing and visualizing results of statistical analyses
# - emmeans: Assists with finding estimated marginal means for linear and mixed models
# - rsample: A package to assist with sampling, resampling, cross-validation, bootstrap
# - fastDummies: Creates dummy columns from categorical variables


# A Note ------------------------------------------------------------------
# R rounds half-to-even, following the IEC 60559 standard, which differs
# from rounding in SAS, and rounding that we learned in elementary math class

# https://www.rdocumentation.org/packages/base/versions/3.5.2/topics/Round

# -------------------------------------------------------------------------
