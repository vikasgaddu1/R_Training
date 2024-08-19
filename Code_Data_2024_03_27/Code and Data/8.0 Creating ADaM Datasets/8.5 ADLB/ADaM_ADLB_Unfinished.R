# Anova Accel2R - Clinical R Training -----------------------------------
# 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(readr)
library(logr)
library(fmtr)
library(diffdf)
library(readxl)
library(tidylog, warn.conflicts = FALSE)

options("tidylog.display" = list(log_print))

log_open("ADLB", show_notes = FALSE)


# Import Data ------------------------------------------------------------

sep("Read Needed Input Data")


base_path <- "data/abc/SDTM/" %>% put()
out_path <- "data/abc/ADaM/" %>% put()
spec_path <- "specs" %>% put()

put("Read ADSL")
adsl <- 
  read_csv(file.path(out_path, "ADSL.csv")) %>% 
  put()

put("Read LB")
lb <- 
  read_csv(file.path(base_path, "LB.csv")) %>% 
  put()


# Create Formats ----------------------------------------------------------

sep("Create format catalog for ADLB")

put("Create lab format catalog")
lb_fmts <- fcat()

put("Get adam fmts from format catalot")
adam_fmts <- read.fcat("data/abc/adam_fmts.fcat")

put("Put relevent lab formats from adam catalog into lab format catalog")
lb_fmts$LBPARMCD <- adam_fmts$LBPARAMCD
lb_fmts$LBPARCAT <- adam_fmts$LBPARCAT

put("Read in ValueLevel tab from ADaM specs")
vals <- read_excel(file.path(spec_path, "ADaM_Specs_Clean.xlsx"),
                   sheet = "ValueLevel") %>% 
  filter(DATASET == "ADLB") %>% put()

put("Read in LBTESTCD_LOOKUP tab from ADaM specs")
lbtests <- read_excel(file.path(spec_path, "ADaM_Specs_Clean.xlsx"),
                      sheet = "LBTESTCD_LOOKUP") 

put("Create format for lab test codes")
lb_fmts$LBTESTCDS <- lbtests %>% 
  transmute(Name = "LBTESTCDS",
            Type = "U",
            Expression = paste0("x == '", LBTESTCD, "'"),
            Label = TRUE,
            Order = NA) %>% 
  bind_rows(data.frame(Name = "LBTESTCDS", Type = "U", Expression = as.character(TRUE),
                       Label = FALSE, Order = NA)) %>% as.fmt() %>% put()


put("Get formats with conditional value 1")
vlevels1 <- vals %>% filter(VARIABLE %in% c("AWRANGE", "AWTARGET", 
                                            "AWLO", "AWHI")) %>% 
  transmute(Name = VARIABLE,
            Type = "U",
            Expression = paste0("x == '", CONDITIONAL_VALUE1, "'"),
            Label = CTVALUE,
            Order = NA) %>% put()
tmp1 <- as.fcat(vlevels1)

tmp1$AWRANGE[[length(tmp1$AWRANGE) + 1]] <- condition(TRUE, NA)
lb_fmts$AWRANGE <- tmp1$AWRANGE

tmp1$AWTARGET[[length(tmp1$AWTARGET) + 1]] <- condition(TRUE, NA)
lb_fmts$AWTARGET <- tmp1$AWTARGET

tmp1$AWLO[[length(tmp1$AWLO) + 1]] <- condition(TRUE, NA)
lb_fmts$AWLO <- tmp1$AWLO

tmp1$AWHI[[length(tmp1$AWHI) + 1]] <- condition(TRUE, NA)
lb_fmts$AWHI <- tmp1$AWHI

put("Get formats with conditional value 2")
vlevels2 <- vals %>% filter(VARIABLE %in% c("PARAM", "PARAMN", 
                                            "AWRANGE", "AWTARGET")) %>% 
  transmute(Name = VARIABLE,
            Type = "U",
            Expression = paste0("x == '", CONDITIONAL_VALUE2, "'"),
            Label = CTVALUE,
            Order = NA) %>% put()

tmp2 <- as.fcat(vlevels2)
lb_fmts$PARAM <- tmp2$PARAM
lb_fmts$PARAMN <- tmp2$PARAMN


put("Create format for AVISIT")
lb_fmts$AVISIT <- value(condition(x == 1, "Day 1 Baseline"),
                        condition(x >= 8 & x <= 22, "Week 2"),
                        condition(x >= 23 & x <= 36, "Week 4"),
                        condition(x >= 37 & x <= 50, "Week 6"),
                        condition(x >= 51 & x <= 71, "Week 8"),
                        condition(x >= 72 & x <= 99, "Week 12"), 
                        condition(TRUE, NA)) %>% put()

put("Create format for AVISITN")
lb_fmts$AVISITN <- value(condition(x == "Day 1 Baseline", 0),
                         condition(x == "Week 2", 2),
                         condition(x == "Week 4", 4),
                         condition(x == "Week 6", 6),
                         condition(x == "Week 8", 8),
                         condition(x == "Week 12", 12),
                         condition(TRUE, NA)) %>% put()

put("Create format for ANRIND")
lb_fmts$ANRIND <- value(condition(x == "CLINICALLY HIGH", "High"),
                        condition(x == "CLINICALLY LOW", "Low"),
                        condition(x == "HIGH", "High"),
                        condition(x == "LOW", "Low"),
                        condition(x == "NORMAL", "Normal")) %>% put()


put("Prepare data for formatting list for AVALC")
avalc_dat <- vals %>% filter(VARIABLE %in% c("AVAL")) %>% 
  select(VARIABLE, CONDITIONAL_VALUE2, NUMB_DEC_PLACES) %>% 
  as.data.frame() %>% put()

put("Create and populate a formatting list for AVALC")
avalc_flist <- flist(type = "row")

count <- 0
for(nm in avalc_dat$CONDITIONAL_VALUE2) {
  count <-  count + 1
  avalc_flist$formats[[nm]] <- paste0("%.", avalc_dat[count, "NUMB_DEC_PLACES"], "f")
  
}
put(avalc_flist)

put("Get unique panel/param combinations, needed to filter final data frame")
labfilters <- vals %>%   filter(VARIABLE == "PARAMN") %>% 
  select(CONDITIONAL_VALUE1, CONDITIONAL_VALUE2) %>% put()



# Prepare Data ------------------------------------------------------------

sep("Perform preparation of input data")



put("Select needed columns from ADSL.")
dat_adsl <- adsl %>% 
  select(STUDYID, USUBJID, SUBJID, SITEID, TRT01P, TRT01PN, TRT01A, TRT01AN,
         RANDFL, SAFFL, MITTFL, PPROTFL, TRTSDT, TRTEDT) %>% 
  put()


put("Select needed rows and columns from LB.")
dat_lb <- lb %>% select(USUBJID, LBSEQ, LBTESTCD, LBTEST, LBCAT, LBORRES,
                        LBORRESU, LBORNRLO, LBORNRHI, LBSTRESC, LBSTRESN,
                        LBSTRESU, LBSTNRLO, LBSTNRHI, LBNRIND, LBDTC) %>% 
  filter(fapply(LBTESTCD, lb_fmts$LBTESTCDS), LBSTRESC != "",
         LBTESTCD != "PTHI" | LBORRESU == "pmol/L") %>% put()



# Create Final Data Frame -------------------------------------------------


sep("Combine prepared data to create final ADLB data frame.")

put("Join adsl and lb")
joined <- left_join(dat_adsl, dat_lb, by = c("USUBJID" = "USUBJID")) %>% put()

put("Assign LBTESTCD as lookup for the AVALC formatting list")
avalc_flist$lookup <- joined$LBTESTCD


put("Define variables")
interim <- joined %>% 
  transmute(STUDYID, 
            USUBJID, 
            SUBJID, 
            SITEID,
            LBSEQ,
            TRTP = TRT01P,
            TRTPN = TRT01PN,
            TRTA = TRT01A,
            TRTAN = TRT01AN,
            RANDFL,
            SAFFL, 
            MITTFL,
            PPROTFL,
            TRTSDT = as.Date(TRTSDT, "%d%b%Y"),
            TRTEDT = as.Date(TRTEDT, "%d%b%Y"), 
            ADT = as.Date(LBDTC),
            ADY = as.numeric(case_when(ADT >= TRTSDT ~ ADT - TRTSDT + 1,
                                       ADT < TRTSDT ~ ADT - TRTSDT)),
            ADTF = as.character(NA),
            AVISIT = fapply(ADY, lb_fmts$AVISIT),
            AVISITN = fapply(AVISIT, lb_fmts$AVISITN), 
            PARAM = fapply(LBTESTCD, lb_fmts$PARAM), 
            PARAMCD = LBTESTCD,
            PARAMN = as.numeric(fapply(LBTESTCD, lb_fmts$PARAMN)),
            PARCAT1 = LBCAT, 
            AVAL = LBSTRESN,
            AVALC = ifelse(suppressWarnings(is.na(as.numeric(LBORRES))), 
                           ifelse(is.na(LBORRES), NA,
                                  ifelse(LBORRES == "<5", "<5.0", LBORRES)), 
                           fapply(LBSTRESN, avalc_flist)),
            ANRIND = fapply(LBNRIND, lb_fmts$ANRIND),
            AWRANGE = fapply(AVISIT, lb_fmts$AWRANGE),
            AWTARGET = as.numeric(fapply(AVISIT, lb_fmts$AWTARGET)),
            AWTDIFF = abs(ADY - AWTARGET),
            AWLO = as.numeric(fapply(AVISIT, lb_fmts$AWLO)),
            AWHI = as.numeric(fapply(AVISIT, lb_fmts$AWHI)),
            AWU = ifelse(is.na(AWTARGET), NA, "DAYS"),
            ABLFL = NA,
            ANL01FL = ifelse(is.na(AVISIT), NA, 
                             ifelse(ADT > TRTEDT + 3, NA, "Y"))
  ) %>% 
  arrange(USUBJID, LBSEQ) %>% 
  put()

put("Pull out baseline values and visits")
baseline <- interim %>% filter(ADT <= TRTSDT) %>% 
  arrange(USUBJID, PARAMN, ADY) %>% group_by(USUBJID, PARCAT1, PARAMN) %>% 
  filter(row_number() == n()) %>% mutate(ABLFL = "Y", AVISIT = "Day 1 Baseline",
                                         AVISITN = 0, ANL01FL = "Y") %>% 
  select(USUBJID, PARAMN, PARCAT1, ADY, BASE = AVAL, 
         BASEC = AVALC, BNRIND = ANRIND, ABLFL, 
         AVISIT, AVISITN, ANL01FL) %>% put()

put("Filter by desired lab parameters and join in baseline visits")
final_pre <- interim %>% 
  inner_join(labfilters, by = c("PARCAT1" = "CONDITIONAL_VALUE1", 
                                "PARAMCD" = "CONDITIONAL_VALUE2")) %>% 
  left_join(select(baseline, -BASE, -BASEC, -BNRIND), 
            by = c("USUBJID" = "USUBJID", "PARAMN" = "PARAMN",
                   "PARCAT1" = "PARCAT1", "ADY" = "ADY")) %>% 
  mutate(AVISIT.x = ifelse(is.na(AVISIT.x), AVISIT.y, AVISIT.x),
         AVISITN.x = ifelse(is.na(AVISITN.x), AVISITN.y, AVISITN.x),
         ABLFL.x = ifelse(is.na(ABLFL.x), ABLFL.y, ABLFL.x),
         ANL01FL.x = ifelse(is.na(ANL01FL.x), ANL01FL.y, ANL01FL.x)) %>% 
  select(-ends_with(".y")) %>% 
  rename(AVISIT = AVISIT.x , AVISITN = AVISITN.x , ABLFL = ABLFL.x, 
         ANL01FL = ANL01FL.x) %>% put()

put("Get baseline parameter values")
baseline1 <- baseline %>% 
  select(USUBJID, PARAMN, PARCAT1, BASE, BASEC, BNRIND) %>% 
  put()


put("Re-join baseline values to get BASE, BASEC, and BNRIND")
final_pre2 <- final_pre %>% 
  left_join(baseline1, by = c("USUBJID" = "USUBJID", 
                              "PARAMN" = "PARAMN", 
                              "PARCAT1" = "PARCAT1")) %>% 
  relocate(BASE, .after = AVALC) %>% 
  relocate(BASEC, .after = BASE) %>% 
  relocate(BNRIND, .after = ANRIND) %>% 
  arrange(USUBJID, PARAMN, ADY) %>% put()

put("Clear out ANL01FL for repeated visits")
final <- final_pre2 %>% group_by(USUBJID, PARAMN, AVISITN) %>% 
  mutate(count = seq_along(ANL01FL), 
         ANL01FL = ifelse(ANL01FL == "Y" & count == 2, NA, ANL01FL)) %>% 
  select(-count) %>% put()

put("Clear row names on ANL01FL")
names(final$ANL01FL) <- NULL

put("Final data frame")
put(final)

# view(final)    

put("Save to file")
write_rds(final, file.path(out_path, "ADLB.rds"))



# Compare to Reference Dataset --------------------------------------------

sep("Compare to reference dataset")

qc_pth <- "./data/abc/ADaM/ADLB.csv" %>% put()

put("Read in comparison data")
dat_qc <- 
  read_csv(qc_pth,
           col_types = cols(
             .default = col_character(),
             LBSEQ = col_double(),
             TRTPN = col_double(),
             TRTAN = col_double(),
             ADY = col_double(),
             ADTF = col_character(),
             AVISITN = col_double(),
             PARAMN = col_double(),
             AVAL = col_double(),
             BASE = col_double(),
             BASEC = col_character(),
             AWTARGET = col_double(),
             AWTDIFF = col_double(),
             AWLO = col_double(),
             AWHI = col_double(),
             TRTSDT = col_date("%d%b%Y"),
             TRTEDT = col_date("%d%b%Y"),
             ADT = col_date("%d%b%Y"))) %>% 
  arrange(USUBJID, PARAMN, ADY) %>% 
  put()


put("Perform comparisons")
diff1 <- anti_join(final, dat_qc) %>% put()
diffdf(final, dat_qc) %>% put()

if (nrow(diff1) == 0) {
  put("NOTE: Final data frame and QC are identical.")
} else {
  put("WARNING: Differences found between final data frame and QC", msg = TRUE)
  
}



# Clean Up ----------------------------------------------------------------


log_close()
options("tidylog.display" = NULL)


