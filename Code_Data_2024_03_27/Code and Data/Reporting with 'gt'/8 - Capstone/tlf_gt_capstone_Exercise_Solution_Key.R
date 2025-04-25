
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Capstone

# Packages & Functions on Display:
# - {gt 0.10.0}: gt_preview, gt, opt_interactive


# Setup -------------------------------------------------------------------
# Load Packages

# Exercise step 1
# Part a
library(tidyverse)
library(gt)
library(haven)
library(broom)
library(fmtr)


adsl <-
  read_sas('_data/abc_adam_adsl.sas7bdat') |>
  select(SUBJID, ARM, SEX, RACE, AGE, AGEGR1) |>
  filter(ARM != "SCREEN FAILURE")

arm_pop <- count(adsl, ARM) %>% deframe()

# Calculate P-Values for stat tests
age_anova <- aov(AGE ~ ARM, data = adsl) %>%
  tidy() %>% filter(term == "ARM") %>%
  transmute(stat = sprintf("%.3f (%.3f)", statistic,p.value))

ageg_chisq <- chisq.test(adsl$ARM, adsl$AGEGR1, correct = FALSE) %>%
  tidy() %>% transmute(stat = sprintf("%.3f (%.3f)", statistic,p.value))

sex_chisq <- chisq.test(adsl$ARM, adsl$SEX, correct = FALSE) %>%
  tidy() %>% transmute(stat = sprintf("%.3f (%.3f)", statistic,p.value))

race_chisq <- chisq.test(adsl$ARM, adsl$RACE, correct = FALSE) %>%
  tidy() %>% transmute(stat = sprintf("%.3f (%.3f)", statistic,p.value))


age_block <-
  adsl %>%
  group_by(ARM) %>%
  summarise( N = as.character(n()),
             Mean = as.character(round(mean(AGE), digits = 1)),
             sd   = as.character(round(sd(AGE), digits = 2)),
             Median = as.character(median(AGE)),
             q1 = as.character(quantile(AGE, probs = .25)),
             q3 = as.character(quantile(AGE, probs = .75)),
             min  = as.character(min(AGE)),
             max = as.character(max(AGE))) %>%
  mutate(`Mean (SD)` = paste0(Mean, ' (', sd, ')'),
         `Q1 - Q3`   = paste0(q1, ' - ', q3),
         Range       = paste0(min, ' - ', max)) %>%
  select(ARM, N, `Mean (SD)`, Median, `Q1 - Q3`, Range) %>%
  pivot_longer(-ARM,
               names_to  = "label",
               values_to = "value") %>%
  pivot_wider(names_from = ARM,
              values_from = "value") %>%
  add_column(var = "AGE", .before = "label") %>%
  add_column(varlabel = "Age (years)", .before = "label") %>%
  bind_cols(age_anova)

age_block |>
  gt()

ageg_block <-
  adsl %>%
  select(ARM, AGEGR1) %>%
  group_by(ARM, AGEGR1) %>%
  summarize(n = n()) %>%
  pivot_wider(names_from = ARM,
              values_from = n,
              values_fill = 0) %>%
  transmute(var = "AGEGR1",
            label =   fct_relevel(AGEGR1, "18-29 years", "30-39 years",
                                          "40-49 years", "50-65 years",
                                          ">65 years"),
            `ARM A` = fmt_cnt_pct(`ARM A`, arm_pop["ARM A"]),
            `ARM B` = fmt_cnt_pct(`ARM B`, arm_pop["ARM B"]),
            `ARM C` = fmt_cnt_pct(`ARM C`, arm_pop["ARM C"]),
            `ARM D` = fmt_cnt_pct(`ARM D`, arm_pop["ARM D"])) %>%
  arrange(label) %>%
  add_column(varlabel = "Age Group", .before = "label") %>%
  bind_cols(ageg_chisq)

ageg_block |>
  gt()

sex_block <-
  adsl %>%
  select(ARM, SEX) %>%
  mutate(SEX = case_when(SEX == "M" ~ "Male",
                         SEX == "F" ~ "Female",
                         .default = "Unknown")) %>%
  group_by(ARM, SEX) %>%
  summarize(n = n()) %>%
  pivot_wider(names_from = ARM,
              values_from = n,
              values_fill = 0) %>%
  transmute(var = "SEX",
            label =   fct_relevel(SEX, "Male", "Female"),
            `ARM A` = fmt_cnt_pct(`ARM A`, arm_pop["ARM A"]),
            `ARM B` = fmt_cnt_pct(`ARM B`, arm_pop["ARM B"]),
            `ARM C` = fmt_cnt_pct(`ARM C`, arm_pop["ARM C"]),
            `ARM D` = fmt_cnt_pct(`ARM D`, arm_pop["ARM D"])) %>%
  arrange(label) %>%
  add_column(varlabel = "Sex", .before = "label") %>%
  bind_cols(sex_chisq)

sex_block |>
  gt()

race_decode <- c("WHITE" = "White",
                 "BLACK OR AFRICAN AMERICAN" = "Black or African American",
                 "ASIAN" = "Asian",
                 "NATIVE AMERICAN" = "Native American",
                 "UNKNOWN" = "Unknown",
                 "SOMETHING" = "Something Else")

race_block <-
  adsl %>%
  select(ARM, RACE) %>%
  mutate(RACE = factor(RACE, levels = names(race_decode),
                       labels = race_decode)) %>%
  group_by(ARM, RACE) %>%
  summarize(n = n()) %>%
  pivot_wider(names_from = ARM,
              values_from = n,
              values_fill = 0) %>%
  transmute(var = "RACE",
            label =  RACE,
            `ARM A` = fmt_cnt_pct(`ARM A`, arm_pop["ARM A"]),
            `ARM B` = fmt_cnt_pct(`ARM B`, arm_pop["ARM B"]),
            `ARM C` = fmt_cnt_pct(`ARM C`, arm_pop["ARM C"]),
            `ARM D` = fmt_cnt_pct(`ARM D`, arm_pop["ARM D"])) %>%
  arrange(label) %>%
  add_column(varlabel = "Race", .before = "label") %>%
  bind_cols(race_chisq)

race_block |>
  gt()

final <-
  bind_rows(age_block, ageg_block, sex_block, race_block) %>%
  select(-var)

# Exercise 1
# Part b
finalgt <-
  final %>%
  mutate(varlabel = case_when(varlabel == lag(varlabel) ~ "",
                              .default = varlabel),
         stat     = case_when(varlabel == "" ~ "",
                              .default = stat)) %>%

  gt() %>%
  tab_header(title = md("<b>Table 1.0<br>
                        Analysis of Demographics Characteristics<br>
                        Safety Population</b>")) %>%
  cols_label(varlabel = "Variable",
             label    = "Summary Stat",
             stat     = md("Tests of Association<br>
                           Value of (P-Value)")) %>%
  tab_footnote("Pearson's Chi-Square tests will be used for categorical variables
   and ANOVA tests for continuous variables.",
               locations = cells_column_labels(columns = stat)) %>%
  opt_footnote_marks(marks = c("*", "^")) %>%
  tab_style(style = cell_text(
    weight = "bold",
    color = "black"),
    locations = cells_column_labels(columns = everything())) %>%
  tab_style(style = cell_borders(
    sides = "top",
    color = "blue"),
    locations = cells_body()) %>%
  tab_style(
    style = list(
      cell_fill(color  = "grey"),
      cell_text(color  = 'black', weight = "bold")),
      locations = cells_body(
        columns = everything(),
        rows = varlabel != ""
      ))

finalgt

# Exercise 1
# Part c
gtsave(finalgt, "Demo Table 1.html")
gtsave(finalgt, "Demo Table 1.rtf")
gtsave(finalgt, "Demo Table 1.pdf")

# Exercise step 2
# Part a
adae <-
  readRDS('_data/adae.rds') %>%
  select(SUBJID, TRTA, AEHLT, ASTDT, AENDT,
         ADURN, AESEV, AEBODSYS, AEREL) |>
  filter(!is.na(TRTA))

trta_pop <-
  count(adae, TRTA) |>
  rename(trtapop = n)

adae_sevrel <-
  readRDS('_data/adae.rds') %>%
  select(SUBJID, TRTA, AEHLT, ASTDT, AENDT, ADURN, AESEV, AEREL) %>%
  filter(AEREL != "NOT RELATED" | AESEV == "SEVERE")

adae_bodsumm <-
  adae |>
  group_by(TRTA, AEBODSYS) |>
  summarize(n = n()) |>
  ungroup() |>
  inner_join(trta_pop, by = join_by(TRTA)) |>
  mutate(frac = n / trtapop) |>
  filter(frac > 0.05) |>
  arrange(TRTA, desc(frac))


# Exercise 2
# Part b
adae_bodsumm |>
  mutate(TRTA = case_when(TRTA == lag(TRTA) ~ "",
                          .default = TRTA),
         trtapop = case_when(TRTA == lag(TRTA) ~ "",
                             .default = as.character(trtapop))) |>
  gt() |>
  tab_header(title =
              md("<b>Table 2</b><br>
                 Adverse Events Body System Counts & Percentages"),
             subtitle = "> 5% Within Treatment Group") |>
  cols_merge(columns = c(TRTA, trtapop),
             pattern = "{1} (N = {2})",
             rows = TRTA != "") |>
  cols_label(TRTA = "Treatment",
             AEBODSYS = "AE Body System",
             n = "Count") |>
  fmt_percent(frac, decimals = 1) |>
  cols_merge_n_pct(n, frac) |>
  tab_style(
    style = list(
      cell_fill(color  = "grey"),
      cell_text(color  = 'black', weight = "bold")),
    locations = cells_body(
      columns = c(TRTA, AEBODSYS),
      rows = TRTA != ""
    )) |>
  data_color(
    columns = n,
    target_columns = n,
    palette = "inferno") |>
  tab_style(
    style = cell_borders(
    sides  = "top",
    color  = "white"),
    locations = cells_title()) |>
  tab_style(style = cell_text(
    weight = "bold",
    color = "black"),
    locations = cells_column_labels(columns = everything())) |>
  tab_style(style = cell_borders(
    sides = "right",
    color = "black"),
    locations = cells_body())


# Exercise step 3
# Part a
advs <-
  read_sas('_data/abc_adam_advs.sas7bdat') |>
  filter(PARAMCD == "BMI" & TRTA != "") |>
  select(SUBJID, SITEID, TRTA, AVAL) |>
  rename(BMI = AVAL)

# Now let's summarize some data for a gt table.
advs_summ <-
  advs |>
  group_by(TRTA, SITEID) |>
  summarize(
    min  = min(BMI, na.rm = TRUE),
    mean = mean(BMI, na.rm = TRUE),
    max  = max(BMI, na.rm = TRUE)) |>
  ungroup()


advs_summ2 <-
  advs |>
  group_by(TRTA) |>
  summarize(
    min  = min(BMI, na.rm = TRUE),
    mean = mean(BMI, na.rm = TRUE),
    max  = max(BMI, na.rm = TRUE)) |>
  ungroup()

advs_summ |>
  ggplot(aes(x = SITEID, y = mean)) +
  geom_col() +
  theme_classic()

plot_bars_trta <- function(my_trta) {
  advs_summ |>
    filter(TRTA == my_trta) |>
    ggplot(aes(x = SITEID, y = mean)) +
    geom_col() +
    theme_classic() +
    theme(
      # Change tick label font sizes:
      axis.text.x = element_text(size = 16),
      axis.text.y = element_text(size = 16),
      # Optionally, change axis title font sizes:
      axis.title.x = element_text(size = 18),
      axis.title.y = element_text(size = 18)
    )
}

# plot_bars_trta("ARM A")

# Exercise 3
# Part b
advs_summ2 |>
  mutate(Plot = TRTA) |>
  gt() |>
  tab_header(title = md("<b>Table 3.0<br>
                        BMI Summary Stats and Charts by Site ID")) |>
  cols_label(min = "Min",
             mean = "Mean",
             max = "Max",
             Plot = "Mean BMI by Site ID") |>
  tab_spanner(label = md("<b>Plot Summary Stats</b>"),
                         columns = c(min, mean, max)) |>
  text_transform(
    locations = cells_body("Plot"),
    fn = function(my_trta){
      lapply(my_trta, plot_bars_trta) |>
        ggplot_image(height = px(200), aspect_ratio = 3)
    }) |>
  tab_style(style = cell_borders(
    sides = "right",
    color = "black"),
    locations = cells_body()) |>
  tab_style(style = cell_text(
    align = "center",
    weight = "bold",
    color = "black"),
    locations = cells_column_labels(columns = everything()))

