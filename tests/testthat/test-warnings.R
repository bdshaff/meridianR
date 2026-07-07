test_that("Python warnings surface as tidy, classed R warnings", {
  skip_if_no_meridian()
  invisible(meridian_version()) # ensure Meridian is imported and the handler installed

  warnings <- reticulate::import("warnings")
  msg <- paste0("meridianR test ", as.integer(runif(1, 0, 1e9)))
  expect_warning(warnings$warn(msg), class = "meridian_python_warning")
})
