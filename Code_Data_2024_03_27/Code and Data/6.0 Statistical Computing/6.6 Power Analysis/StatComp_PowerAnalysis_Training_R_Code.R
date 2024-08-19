
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2022 Anova Groups All rights reserved

# Title: Power Analysis

# Packages & Functions on Display:
# - {pwr 1.3.0}:  pwr.r.test, pwr.t.test, pwr.t2n.test, pwr.p.test, pwr.2p.test
#                pwr.2p2n.test, pwr.chisq.test, pwr.f2.test, pwr.anova.test
#
# - {effectsize 0.8.1}: cohens_f, eta_squared, omega_squared, epsilon_squared

# Setup -------------------------------------------------------------------

# Load Packages
library(pwr)
library(dplyr)
library(readr)
library(effectsize)


# Simple Examples ---------------------------------------------------------

# Determine Sample Size
# Two Sided T-Test with Medium Effect Size
power_t <-
  pwr.t.test(
    n           = NULL,         # N is NULL because this is what we want to estimate
    d           = 0.20,         # Effect Size
    sig.level   = 0.05,         # Significant Level
    power       = 0.90,         # Power of Test
    type        = "two.sample", # 'two.sample', 'one.sample', 'paired'
    alternative = "two.sided")  # 'two.sided', 'greater', or 'less'

# See the Results
power_t

# Visualize Results
plot(power_t)


# Determine Power
# One Way Anova with 4 Groups and Medium Effect Size
power_anova <-
  pwr.anova.test(
    n         = 25,
    k         = 4,
    f         = 0.25,
    sig.level = 0.05,
    power     = NULL)

power_anova
plot(power_anova)


# Additional Tests --------------------------------------------------------
# Enter any three arguments and the fourth will be calculated
# Typical arguments are 'n', 'sig.level', 'power', and 'alternative'


#    pwr.r.test(r) 	      correlation                            (r is ES;)
#    pwr.t.test(d) 	      t-tests (one sample, 2 sample, paired) (d is ES;)
#  pwr.t2n.test(n1, n2, d) t-test (two samples with unequal n)    (d is ES; n1, n2 are group sample sizes)
#    pwr.p.test(h) 	      proportion (one sample)                (h is ES;)
#   pwr.2p.test(h) 	      two proportions (equal n)              (h is ES;)
# pwr.2p2n.test(n1, n2, h) two proportions (unequal n)            (h is ES; n1, n2 are group sample sizes)
# pwr.chisq.test(w, N, df) 	chi-square test                        (w  is ES; N is total obs)
#   pwr.f2.test(u, v, f2) 	general linear model                   (f2 is ES; u,v represent degrees of freedom)
# pwr.anova.test(k, f) 	    balanced one way ANOVA                 (f  is ES; k is number of groups)


# Determine Effect Size ---------------------------------------------------
# Use these functions on a model that already exists

data_heart <- read_rds("data/heart.rds")
data_heart %>% glimpse()

model_aov <- aov(platelets ~ smoking * time, data = data_heart)
model_aov

model_aov %>% cohens_f()
model_aov %>% eta_squared()
model_aov %>% omega_squared()
model_aov %>% epsilon_squared()


# Other Functions
# Standardized Difference - cohens_d()
# Contingency Tables      - phi(), cramers_v()


# Documentation -----------------------------------------------------------

# Vignettes
vignette("effectsize",   package = "effectsize")
vignette("pwr-vignette", package = "pwr")

# Help Pages
help(pwr.t.test)
help(pwr.anova.test)
help(cohens_f)

# -------------------------------------------------------------------------
