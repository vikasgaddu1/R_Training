Error in select(., -SITEID2, -AVISITN, -ADT) :
Traceback:
29: stop(fallback)
28: signal_abort(cnd)
27: cnd_signal(cnd)
26: handlers[[1L]](cnd)
25: (function (cnd) 
    {
        {
            .__handler_frame__. <- TRUE
            .__setup_frame__. <- frame
            if (inherits(cnd, "message")) {
                except <- c("warning", "error")
            }
            else if (inherits(cnd, "warning")) {
                except <- "error"
            }
            else {
                except <- ""
            }
        }
        while (!is_null(cnd)) {
            if (inherits(cnd, "vctrs_error_subscript")) {
                out <- handlers[[1L]](cnd)
                if (!inherits(out, "rlang_zap")) 
                    throw(out)
      ...
24: signalCondition(cnd)
23: signal_abort(cnd, .file)
22: abort(class = c(class, "vctrs_error_subscript"), i = i, ..., 
        call = call)
21: stop_subscript(class = "vctrs_error_subscript_oob", i = i, subscript_type = subscript_type, 
        ..., call = call)
20: stop_subscript_oob(i = i, subscript_type = subscript_type, names = names, 
        subscript_action = subscript_action, subscript_arg = subscript_arg, 
        call = call)
19: (function () 
    stop_subscript_oob(i = i, subscript_type = subscript_type, names = names, 
        subscript_action = subscript_action, subscript_arg = subscript_arg, 
        call = call))()
18: vctrs::vec_as_location(x, n = length(vars), names = vars, call = call, 
        arg = arg)
17: chr_as_locations(x, vars, call = call, arg = arg)
16: as_indices_impl(x, vars, call = call, arg = arg, strict = strict)
15: as_indices_sel_impl(out, vars = vars, strict = strict, data = data, 
        allow_predicates = allow_predicates, call = error_call, arg = as_label(expr))
14: walk_data_tree(new, data_mask, context_mask)
13: reduce_sels(node, data_mask, context_mask, init = init)
12: eval_c(expr, data_mask, context_mask)
11: walk_data_tree(expr, data_mask, context_mask)
10: vars_select_eval(vars, expr, strict = strict, data = x, name_spec = name_spec, 
        uniquely_named = uniquely_named, allow_rename = allow_rename, 
        allow_empty = allow_empty, allow_predicates = allow_predicates, 
        type = type, error_call = error_call)
9: withCallingHandlers(expr, condition = function(cnd) {
       {
           .__handler_frame__. <- TRUE
           .__setup_frame__. <- frame
           if (inherits(cnd, "message")) {
               except <- c("warning", "error")
           }
           else if (inherits(cnd, "warning")) {
               except <- "error"
           }
           else {
               except <- ""
           }
       }
       while (!is_null(cnd)) {
           if (inherits(cnd, "vctrs_error_subscript")) {
               out <- handlers[[1L]](cnd)
               if (!inherits(out, "rlang_zap")) 
                   throw(out)
           }
     ...
8: try_fetch(expr, vctrs_error_subscript = function(cnd) {
       cnd$subscript_action <- subscript_action(type)
       cnd$subscript_elt <- "column"
       cnd_signal(cnd)
   })
7: with_subscript_errors(out <- vars_select_eval(vars, expr, strict = strict, 
       data = x, name_spec = name_spec, uniquely_named = uniquely_named, 
       allow_rename = allow_rename, allow_empty = allow_empty, allow_predicates = allow_predicates, 
       type = type, error_call = error_call), type = type)
6: eval_select_impl(data, names(data), as_quosure(expr, env), include = include, 
       exclude = exclude, strict = strict, name_spec = name_spec, 
       allow_rename = allow_rename, allow_empty = allow_empty, allow_predicates = allow_predicates, 
       error_call = error_call, )
5: tidyselect::eval_select(expr(c(...)), data = .data, error_call = error_call)
4: select.data.frame(., -SITEID2, -AVISITN, -ADT)
3: select(., -SITEID2, -AVISITN, -ADT)
2: filter(., USUBJID == "ABC-01-049")
1: dat_fmt %>% select(-SITEID2, -AVISITN, -ADT) %>% filter(USUBJID == 
       "ABC-01-049")

