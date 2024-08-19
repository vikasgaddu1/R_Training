
# Prepare & Summarize Data -------------------------------------------------------------------
fn_getdmdata <- function(DMrds) {
  
# readRDS(paste0(basepath, datapath, "DM.rds")) %>% 
readRDS(paste0(basepath, DMrds)) %>% 
  select(USUBJID, SITEID, SEX, AGE)
  
}

fn_getaedata <- function(AErds) {
  
readRDS(paste0(basepath, AErds)) %>% 
    select(USUBJID, AEBODSYS, AETERM, AEHLT)
  
}

fn_dataprepsumm <- function(dm, ae) {
  
inner_join(dm, ae, by = c("USUBJID" = "USUBJID")) %>% 
  group_by(AEBODSYS) %>% 
  summarize(n = n())

}

# Show Data -------------------------------------------------------------------
fn_show_data <- function(dataprepsumm) {

bs_plot <- 
  dataprepsumm %>%  
  ggplot(aes(y = AEBODSYS, x = n)) +
  geom_col(fill = 'orange') + 
  labs(title = company,
       subtitle = study,
       x = "Counts",
       y = "AE Body System",
       caption = paste("Note: ",
                       environ,
                       basepath,
                       '.'))  

return(bs_plot)

}

# Analyze Data -------------------------------------------------------------------
fn_ttest_agebysex <- function(dmdata) {
  
stats_chisq <- 
  stats::t.test(AGE ~ SEX, data = dmdata)

return(tidy(stats_chisq))
  
}
