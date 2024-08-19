WARNING: Differences found between final data frame and QC

Error in basename(path) : argument "path" is missing, with no default
Traceback:
5: basename(path)
4: is.factor(x)
3: sub("([^.]+)\\.[[:alnum:]]+$", "\\1", x)
2: tools::file_path_sans_ext(basename(path))
1: write_xpt(dat_final)

Warning message:
[38;5;253mThere were 3 warnings in `.fun()`.
The first warning was:[39m
[38;5;253m[36mℹ[38;5;253m In argument: `TRTEDT = as_date(EXENDTC)`.[39m
Caused by warning:
[33m![39m  2 failed to parse.
[38;5;253m[36mℹ[38;5;253m Run ]8;;ide:run:dplyr::last_dplyr_warnings()dplyr::last_dplyr_warnings()]8;; to see the 2 remaining warnings.[39m

