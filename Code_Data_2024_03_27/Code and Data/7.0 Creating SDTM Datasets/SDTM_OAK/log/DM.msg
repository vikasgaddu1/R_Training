Error: '_data/abc/CRF//DM.csv' does not exist in current working directory ('/cloud/project/Code_Data_2024_03_27/Code and Data/7.0 Creating SDTM Datasets/SDTM_OAK'). 
Traceback: 
 [1] "14: stop(\"'\", path, \"' does not exist\", if (!is_absolute_path(path)) {"                                                         
 [2] "        paste0(\" in current working directory ('\", getwd(), \"')\")"                                                              
 [3] "    }, \".\", call. = FALSE)"                                                                                                       
 [4] "13: check_path(path)"                                                                                                               
 [5] "12: (function (path, write = FALSE) "                                                                                               
 [6] "    {"                                                                                                                              
 [7] "        if (is.raw(path)) {"                                                                                                        
 [8] "            return(rawConnection(path, \"rb\"))"                                                                                    
 [9] "        }"                                                                                                                          
[10] "        if (!is.character(path)) {"                                                                                                 
[11] "            return(path)"                                                                                                           
[12] "        }"                                                                                                                          
[13] "        if (is_url(path)) {"                                                                                                        
[14] "            if (requireNamespace(\"curl\", quietly = TRUE)) {"                                                                      
[15] "                con <- curl::curl(path)"                                                                                            
[16] "            }"                                                                                                                      
[17] "            else {"                                                                                                                 
[18] "                inform(\"`curl` package not installed, falling back to using `url()`\")"                                            
[19] "                con <- url(path)"                                                                                                   
[20] "            }"                                                                                                                      
[21] "            ext <- tolower(tools::file_ext(path))"                                                                                  
[22] "            return(switch(ext, zip = , bz2 = , xz = {"                                                                              
[23] "                close(con)"                                                                                                         
[24] "                stop(\"Reading from remote `\", ext, \"` compressed files is not supported,\\n\", "                                 
[25] "      ..."                                                                                                                          
[26] "11: vroom_(file, delim = delim %||% col_types$delim, col_names = col_names, "                                                       
[27] "        col_types = col_types, id = id, skip = skip, col_select = col_select, "                                                     
[28] "        name_repair = .name_repair, na = na, quote = quote, trim_ws = trim_ws, "                                                    
[29] "        escape_double = escape_double, escape_backslash = escape_backslash, "                                                       
[30] "        comment = comment, skip_empty_rows = skip_empty_rows, locale = locale, "                                                    
[31] "        guess_max = guess_max, n_max = n_max, altrep = vroom_altrep(altrep), "                                                      
[32] "        num_threads = num_threads, progress = progress)"                                                                            
[33] "10: vroom::vroom(file, delim = \",\", col_names = col_names, col_types = col_types, "                                               
[34] "        col_select = {"                                                                                                             
[35] "            {"                                                                                                                      
[36] "                col_select"                                                                                                         
[37] "            }"                                                                                                                      
[38] "        }, id = id, .name_repair = name_repair, skip = skip, n_max = n_max, "                                                       
[39] "        na = na, quote = quote, comment = comment, skip_empty_rows = skip_empty_rows, "                                             
[40] "        trim_ws = trim_ws, escape_double = TRUE, escape_backslash = FALSE, "                                                        
[41] "        locale = locale, guess_max = guess_max, show_col_types = show_col_types, "                                                  
[42] "        progress = progress, altrep = lazy, num_threads = num_threads)"                                                             
[43] "9: read_csv(file.path(base_path, \"DM.csv\"), col_types = cols(BIRTHDT = col_date(format = \"%d%b%Y\")))"                           
[44] "8: print(x, ...)"                                                                                                                   
[45] "7: log_print(x, ..., console = console, blank_after = blank_after, "                                                                
[46] "       msg = msg, hide_notes = hide_notes)"                                                                                         
[47] "6: put(.)"                                                                                                                          
[48] "5: read_csv(file.path(base_path, \"DM.csv\"), col_types = cols(BIRTHDT = col_date(format = \"%d%b%Y\"))) %>% "                      
[49] "       put() at SDTM_DM_Exercise_Solution_Key.R#27"                                                                                 
[50] "4: eval(ei, envir)"                                                                                                                 
[51] "3: eval(ei, envir)"                                                                                                                 
[52] "2: withVisible(eval(ei, envir))"                                                                                                    
[53] "1: source(\"/cloud/project/Code_Data_2024_03_27/Code and Data/7.0 Creating SDTM Datasets/7.3 DM/SDTM_DM_Exercise_Solution_Key.R\", "
[54] "       echo = TRUE)"                                                                                                                

