Error in readRDS(con, refhook = refhook) : cannot open the connection
 
Traceback: 
[1] "6: readRDS(con, refhook = refhook)"                                 
[2] "5: read_rds(dp)"                                                    
[3] "4: print(x, ...)"                                                   
[4] "3: log_print(x, ..., console = console, blank_after = blank_after, "
[5] "       msg = msg, hide_notes = hide_notes)"                         
[6] "2: put(.)"                                                          
[7] "1: read_rds(dp) %>% put()"                                          

Warning message:
In readRDS(con, refhook = refhook) :
  cannot open file 'data/abc/SDTM/DM.rds': No such file or directory

