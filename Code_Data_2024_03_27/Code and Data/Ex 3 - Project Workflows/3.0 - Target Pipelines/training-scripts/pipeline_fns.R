
# Pipeline Functions ------------------------------------------------------
# These functions are used to demonstrate the structure of a script pipeline


# General Recommendations
# - Keep functions either all in one script, or in their own individual scripts
# - Preference differs with length of functions
# - Choose a method that is easier to understand, and easier to debug

# Reminder
# - Explicit 'return()' is not required when creating functions
# - Though 'return()' can be helpful to keep track of where the code ends


# Write Data to Disk ------------------------------------------------------

fn_write_data <- function(data, output_path){

  df_name <- deparse(substitute(data))
  fn_message <- stringr::str_glue("Writing {df_name} dataset to disk.")
  message(fn_message)

  write_rds(data, output_path)

}

# Get Data ----------------------------------------------------------------

fn_get_data <- function(path_to_rawdata){
  read_rds(path_to_rawdata)
}


# Prepare Data ------------------------------------------------------------

fn_prepare_data <- function(raw_data){

  message("Note: This function currently only works with ggplot2::diamonds dataset!")
  raw_data %>%
    dplyr::arrange(desc(depth)) %>%
    tibble::rowid_to_column("depth_order") %>%
    dplyr::mutate(x_diff = x - mean(x)) %>%
    dplyr::mutate(depth_group = cut(depth, 5))
}


# Summarize Data ----------------------------------------------------------

fn_summary_data <- function(prepared_data){
  prepared_data %>%
    dplyr::group_by(depth_group) %>%
    dplyr::summarise(
      avg_carat = mean(carat),
      avg_price = mean(price),
      std_price = sd(price))
}


# Analyze Data ------------------------------------------------------------

fn_analyze_data <- function(prepared_data){
  aov(data = prepared_data,
      formula = price ~ depth_group)
}


# Get Analysis Results ----------------------------------------------------

fn_model_summary <- function(model_object){
  broom::tidy(model_object)
}

# Create Plot -------------------------------------------------------------

fn_create_plot <- function(summary_data){
  summary_data %>%
    ggplot2::ggplot(aes(y = depth_group, x = avg_price)) +
    ggplot2::geom_point() +
    ggplot2::geom_errorbar(aes(xmin = avg_price - std_price,
                               xmax = avg_price + std_price))
}


# Create Table ------------------------------------------------------------

fn_create_table <- function(prepared_data){
  prepared_data %>%
    janitor::tabyl(cut, color, clarity) %>%
    janitor::adorn_percentages() %>%
    janitor::adorn_pct_formatting() %>%
    janitor::adorn_ns(position = "front")
}
