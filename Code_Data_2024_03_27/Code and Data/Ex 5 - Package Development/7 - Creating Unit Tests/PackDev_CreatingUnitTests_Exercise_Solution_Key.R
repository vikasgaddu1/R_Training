
# -------------------------------------------------------------------------

# Exercise Step 7
test_that("Test Package Functions", {

  expect_equal(text_sub(blahblahblah), "blahblahblah")

  expect_equal(is.grouped_df(mtcars %>% create_group_var("am")), TRUE)

  expect_error(mtcars %>% create_group_var(am))

  expect_equal(my_summstats_function(c(1:3), "mean"), 2)

  # expect_error(my_summstats_function(c("1", "2", "3"), "mean"))

  expect_error(my_summstats_function(c(1, 2, 3), "geomean"))

})


# Exercise Step 10
library(covr)

file_coverage(
  source_files = c("R/pkg_helpers.R"),
  test_files   = c("tests/testthat/test-pkg_helpers.R")) %>%
  report()

# -------------------------------------------------------------------------
