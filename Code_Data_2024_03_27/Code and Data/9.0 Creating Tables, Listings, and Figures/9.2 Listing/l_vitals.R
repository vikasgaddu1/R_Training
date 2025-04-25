dir_data <- "./_data/abc/ADaM" %>% put()

put("Load Data, filter by safety flag, and select desired columns")
advs <- file.path(dir_data, "ADVS.csv") %>% read_csv() %>%
  filter(SAFFL == "Y") %>%
  select(USUBJID, TRTA, SAFFL, AVISIT, AVISITN, PARAM,
         PARAMCD, PARAMN, AVAL, BASE, CHG) %>%
  put()

tbl <- create_table(advs, use_attributes = "none") %>% 
  define(USUBJID, id_var = TRUE, label = "Subject ID",dedupe = TRUE) |> 
  define(TRTA, id_var = TRUE, label = "Treatment",dedupe = TRUE) |>
  define(SAFFL, id_var = TRUE, label = "Safety Flag",dedupe = TRUE) |>
  define(PARAMN, visible = FALSE, blank_after = TRUE) |>
  define(PARAMCD, visible = FALSE) |>
  define(PARAM, id_var = TRUE, label = "Parameter",dedupe = TRUE) |>
  define(AVISITN,visible = FALSE) |>
  define(AVISIT, id_var = TRUE, label = "Visit",dedupe = TRUE) |>
  define(AVAL, label = "Value") |>
  define(BASE, label = "Baseline") 

rpt <- create_report("_output/Vitals_Listing1_0.txt", output_type = "TXT") %>% 
  page_header("Client: Anova", "Study: ABC") %>% 
  titles("Listing 2.0", "Vital Signs") %>% 
  add_content(tbl, align = "left") %>% 
  page_footer(Sys.time(), "Confidential", "Page [pg] of [tpg]")
write_report(rpt) %>% put()


lst <- as_listing(advs,
                  key_cols = c("USUBJID", "TRTA", "SAFFL", "PARAM", "AVISIT"),
                  disp_cols = c("AVAL", "BASE", "CHG"),
                  split_into_pages_by_var = "PARAMCD",
                  main_title = "Vital Signs \n Title 2 \n Title 3",
                  subtitles = "Safety Population",
                  main_footer ="Confidential \n Page [pg] of [tpg]" )

export_as_txt(lst, "_output/rlvs.txt")
