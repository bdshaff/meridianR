test_that("analysis accessors return tidy tibbles", {
  skip_if_no_meridian()
  mmm <- fitted_toy_model()

  sm <- summary_metrics(mmm)
  expect_s3_class(sm, "tbl_df")
  expect_true(all(c("channel", "metric", "distribution", "roi") %in% names(sm)))

  expect_s3_class(response_curves(mmm), "tbl_df")
  expect_s3_class(hill_curves(mmm), "tbl_df")
  expect_s3_class(adstock_decay(mmm), "tbl_df")
  expect_true(all(c("param", "max_rhat") %in% names(rhat_summary(mmm))))
  expect_true(all(c("time", "expected", "actual") %in% names(expected_vs_actual(mmm))))
})

test_that("analyzer() is reusable and accessors accept it", {
  skip_if_no_meridian()
  a <- analyzer(fitted_toy_model())
  expect_s3_class(a, "meridian_analyzer")
  expect_s3_class(summary_metrics(a), "tbl_df")
})

test_that("plot_* functions return ggplot objects", {
  skip_if_no_meridian()
  mmm <- fitted_toy_model()
  expect_s3_class(plot_model_fit(mmm), "ggplot")
  expect_s3_class(plot_roi(mmm), "ggplot")
  expect_s3_class(plot_contribution(mmm), "ggplot")
  expect_s3_class(plot_response_curves(mmm), "ggplot")
  expect_s3_class(plot_hill_curves(mmm), "ggplot")
  expect_s3_class(plot_adstock_decay(mmm), "ggplot")
  expect_s3_class(plot_rhat(mmm), "ggplot")
})

test_that("autoplot dispatches by type and validates it", {
  skip_if_no_meridian()
  mmm <- fitted_toy_model()
  expect_s3_class(autoplot(mmm, type = "roi"), "ggplot")
  expect_error(autoplot(mmm, type = "nope"))
})
