Error in .fun(.data, ...) : 
[1mCaused by error in [38;5;253m`` names(message) <- `*vtmp*` ``[39m:[22m
[33m![39m 'names' attribute [1] must be the same length as the vector [0]

Traceback:
29: stop(fallback)
28: signal_abort(cnd, .file)
27: abort(bullets, class = "dplyr:::mutate_error", parent = skip_internal_condition(e), 
        bullets = bullets, call = error_call)
26: h(simpleError(msg, call))
25: .handleSimpleError(function (e) 
    {
        local_error_context(dots = dots, .index = i, mask = mask)
        bullets <- c(cnd_bullet_header("computing"), mutate_bullets(e))
        abort(bullets, class = "dplyr:::mutate_error", parent = skip_internal_condition(e), 
            bullets = bullets, call = error_call)
    }, "'names' attribute [1] must be the same length as the vector [0]", 
        base::quote(names(message) <- `*vtmp*`))
24: cli_format(x, .envir = emptyenv())
23: .rlang_cli_format(x, cli::format_error)
22: cli_format(glue_escape(lines))
21: cnd_message_format(cnd, ...)
20: cnd_message(c)
19: conditionMessage.rlang_error(cond)
18: conditionMessage(cond)
17: signalCondition(cnd)
16: signal_abort(cnd, .file)
15: abort(msg, call = error_call)
14: check_type(val, x, name, error_call = error_call)
13: replace_with(out, query[[i]] & !replaced, value[[i]], NULL, error_call = error_call)
12: case_when(ARMCD == "SCRNFAIL" ~ NA_integer_, ARMCD != "SCRNFAIL" ~ 
        as.numeric(ARMCD), TRUE ~ as.numeric(NA))
11: .Call(dplyr_mask_eval_all_mutate, quo, private)
10: mask$eval_all_mutate(quo)
9: withCallingHandlers({
       for (i in seq_along(dots)) {
           context_poke("column", old_current_column)
           quosures <- expand_across(dots[[i]])
           quosures_results <- vector(mode = "list", length = length(quosures))
           for (k in seq_along(quosures)) {
               quo <- quosures[[k]]
               quo_data <- attr(quo, "dplyr:::data")
               if (!is.null(quo_data$column)) {
                   context_poke("column", quo_data$column)
               }
               chunks <- NULL
               result <- NULL
               if (quo_is_symbol(quo)) {
                   name <- as_string(quo_get_expr(quo))
                   if (name %in% names(new_columns)) {
                     result <- new_columns[[name]]
                     chunks <- mask$resolve(name)
                   }
                   else if (name %in% names(.data)) {
     ...
8: mutate_cols(.data, dplyr_quosures(...), caller_env = caller_env())
7: mutate.data.frame(.data, ...)
6: .fun(.data, ...)
5: log_mutate(.data, .fun = dplyr::mutate, .funname = "mutate", 
       ...)
4: mutate(., AGEGR1 = case_when(AGE >= 18 & AGE <= 29 ~ "18-29 years", 
       AGE >= 30 & AGE <= 39 ~ "30-39 years", AGE >= 40 & AGE <= 
           49 ~ "40-49 years", AGE >= 50 & AGE <= 65 ~ "50-65 years", 
       AGE > 65 ~ ">65 years", TRUE ~ as.character(NA)), TRT01P = case_when(ARM != 
       "SCREEN FAILURE" ~ ARM, TRUE ~ as.character(NA)), TRT01PN = case_when(ARMCD == 
       "SCRNFAIL" ~ NA_integer_, ARMCD != "SCRNFAIL" ~ as.numeric(ARMCD), 
       TRUE ~ as.numeric(NA)), TRT01A = case_when(ARM != "SCREEN FAILURE" ~ 
       ARM, TRUE ~ as.character(NA)), TRT01AN = case_when(ARMCD != 
       "SCRNFAIL" ~ as.numeric(ARMCD), TRUE ~ as.numeric(NA)), INCNFL = case_when(!is.na(RFICDTC) ~ 
       "Y", TRUE ~ "N"), RANDFL = case_when(INCNFL == "Y" & (ARMCD == 
       "1" | ARMCD == "2" | ARMCD == "3" | ARMCD == "4") & is.na(inie) ~ 
       "Y", TRUE ~ "N"))
3: log_select(.data, .fun = dplyr::select, .funname = "select", 
       ...)
2: select(., STUDYID, USUBJID, SUBJID, SITEID, AGE, AGEU, AGEGR1, 
       SEX, RACE, RACEN, ETHNIC, ETHNICN, COUNTRY, ARM, ACTARM, 
       TRT01P, TRT01PN, TRT01A, TRT01AN, INCNFL, RANDFL, RFICDTC)
1: readRDS(file.path(SDTM_path, "DM.rds")) %>% left_join(racen, 
       by = "RACE") %>% left_join(ethnicn, by = "ETHNIC") %>% left_join(ie, 
       by = "USUBJID") %>% mutate(AGEGR1 = case_when(AGE >= 18 & 
       AGE <= 29 ~ "18-29 years", AGE >= 30 & AGE <= 39 ~ "30-39 years", 
       AGE >= 40 & AGE <= 49 ~ "40-49 years", AGE >= 50 & AGE <= 
           65 ~ "50-65 years", AGE > 65 ~ ">65 years", TRUE ~ as.character(NA)), 
       TRT01P = case_when(ARM != "SCREEN FAILURE" ~ ARM, TRUE ~ 
           as.character(NA)), TRT01PN = case_when(ARMCD == "SCRNFAIL" ~ 
           NA_integer_, ARMCD != "SCRNFAIL" ~ as.numeric(ARMCD), 
           TRUE ~ as.numeric(NA)), TRT01A = case_when(ARM != "SCREEN FAILURE" ~ 
           ARM, TRUE ~ as.character(NA)), TRT01AN = case_when(ARMCD != 
           "SCRNFAIL" ~ as.numeric(ARMCD), TRUE ~ as.numeric(NA)), 
       INCNFL = case_when(!is.na(RFICDTC) ~ "Y", TRUE ~ "N"), RANDFL = case_when(INCNFL == 
           "Y" & (ARMCD == "1" | ARMCD == "2" | ARMCD == "3" | ARMCD == 
           "4") & is.na(inie) ~ "Y", TRUE ~ "N")) %>% select(STUDYID, 
       USUBJID, SUBJID, SITEID, AGE, AGEU, AGEGR1, SEX, RACE, RACEN, 
       ETHNIC, ETHNICN, COUNTRY, ARM, ACTARM, TRT01P, TRT01PN, TRT01A, 
       TRT01AN, INCNFL, RANDFL, RFICDTC)

Error in .fun(.data, ...) : 
[1mCaused by error:[22m
[33m![39m object 'NA_double_' not found

Traceback:
18: stop(fallback)
17: signal_abort(cnd, .file)
16: abort(bullets, class = "dplyr:::mutate_error", parent = skip_internal_condition(e), 
        bullets = bullets, call = error_call)
15: h(simpleError(msg, call))
14: .handleSimpleError(function (e) 
    {
        local_error_context(dots = dots, .index = i, mask = mask)
        bullets <- c(cnd_bullet_header("computing"), mutate_bullets(e))
        abort(bullets, class = "dplyr:::mutate_error", parent = skip_internal_condition(e), 
            bullets = bullets, call = error_call)
    }, "object 'NA_double_' not found", base::quote(eval_tidy(pair$rhs, 
        env = default_env)))
13: eval_tidy(pair$rhs, env = default_env)
12: case_when(ARMCD == "SCRNFAIL" ~ NA_double_, ARMCD != "SCRNFAIL" ~ 
        as.numeric(ARMCD), TRUE ~ as.numeric(NA))
11: .Call(dplyr_mask_eval_all_mutate, quo, private)
10: mask$eval_all_mutate(quo)
9: withCallingHandlers({
       for (i in seq_along(dots)) {
           context_poke("column", old_current_column)
           quosures <- expand_across(dots[[i]])
           quosures_results <- vector(mode = "list", length = length(quosures))
           for (k in seq_along(quosures)) {
               quo <- quosures[[k]]
               quo_data <- attr(quo, "dplyr:::data")
               if (!is.null(quo_data$column)) {
                   context_poke("column", quo_data$column)
               }
               chunks <- NULL
               result <- NULL
               if (quo_is_symbol(quo)) {
                   name <- as_string(quo_get_expr(quo))
                   if (name %in% names(new_columns)) {
                     result <- new_columns[[name]]
                     chunks <- mask$resolve(name)
                   }
                   else if (name %in% names(.data)) {
     ...
8: mutate_cols(.data, dplyr_quosures(...), caller_env = caller_env())
7: mutate.data.frame(.data, ...)
6: .fun(.data, ...)
5: log_mutate(.data, .fun = dplyr::mutate, .funname = "mutate", 
       ...)
4: mutate(., AGEGR1 = case_when(AGE >= 18 & AGE <= 29 ~ "18-29 years", 
       AGE >= 30 & AGE <= 39 ~ "30-39 years", AGE >= 40 & AGE <= 
           49 ~ "40-49 years", AGE >= 50 & AGE <= 65 ~ "50-65 years", 
       AGE > 65 ~ ">65 years", TRUE ~ as.character(NA)), TRT01P = case_when(ARM != 
       "SCREEN FAILURE" ~ ARM, TRUE ~ as.character(NA)), TRT01PN = case_when(ARMCD == 
       "SCRNFAIL" ~ NA_double_, ARMCD != "SCRNFAIL" ~ as.numeric(ARMCD), 
       TRUE ~ as.numeric(NA)), TRT01A = case_when(ARM != "SCREEN FAILURE" ~ 
       ARM, TRUE ~ as.character(NA)), TRT01AN = case_when(ARMCD != 
       "SCRNFAIL" ~ as.numeric(ARMCD), TRUE ~ as.numeric(NA)), INCNFL = case_when(!is.na(RFICDTC) ~ 
       "Y", TRUE ~ "N"), RANDFL = case_when(INCNFL == "Y" & (ARMCD == 
       "1" | ARMCD == "2" | ARMCD == "3" | ARMCD == "4") & is.na(inie) ~ 
       "Y", TRUE ~ "N"))
3: log_select(.data, .fun = dplyr::select, .funname = "select", 
       ...)
2: select(., STUDYID, USUBJID, SUBJID, SITEID, AGE, AGEU, AGEGR1, 
       SEX, RACE, RACEN, ETHNIC, ETHNICN, COUNTRY, ARM, ACTARM, 
       TRT01P, TRT01PN, TRT01A, TRT01AN, INCNFL, RANDFL, RFICDTC)
1: readRDS(file.path(SDTM_path, "DM.rds")) %>% left_join(racen, 
       by = "RACE") %>% left_join(ethnicn, by = "ETHNIC") %>% left_join(ie, 
       by = "USUBJID") %>% mutate(AGEGR1 = case_when(AGE >= 18 & 
       AGE <= 29 ~ "18-29 years", AGE >= 30 & AGE <= 39 ~ "30-39 years", 
       AGE >= 40 & AGE <= 49 ~ "40-49 years", AGE >= 50 & AGE <= 
           65 ~ "50-65 years", AGE > 65 ~ ">65 years", TRUE ~ as.character(NA)), 
       TRT01P = case_when(ARM != "SCREEN FAILURE" ~ ARM, TRUE ~ 
           as.character(NA)), TRT01PN = case_when(ARMCD == "SCRNFAIL" ~ 
           NA_double_, ARMCD != "SCRNFAIL" ~ as.numeric(ARMCD), 
           TRUE ~ as.numeric(NA)), TRT01A = case_when(ARM != "SCREEN FAILURE" ~ 
           ARM, TRUE ~ as.character(NA)), TRT01AN = case_when(ARMCD != 
           "SCRNFAIL" ~ as.numeric(ARMCD), TRUE ~ as.numeric(NA)), 
       INCNFL = case_when(!is.na(RFICDTC) ~ "Y", TRUE ~ "N"), RANDFL = case_when(INCNFL == 
           "Y" & (ARMCD == "1" | ARMCD == "2" | ARMCD == "3" | ARMCD == 
           "4") & is.na(inie) ~ "Y", TRUE ~ "N")) %>% select(STUDYID, 
       USUBJID, SUBJID, SITEID, AGE, AGEU, AGEGR1, SEX, RACE, RACEN, 
       ETHNIC, ETHNICN, COUNTRY, ARM, ACTARM, TRT01P, TRT01PN, TRT01A, 
       TRT01AN, INCNFL, RANDFL, RFICDTC)

