test_that("priors and model_spec construct", {
  skip_if_no_meridian()
  p <- prior_distribution(roi_m = prior_lognormal(0.2, 0.9))
  expect_s3_class(p, "meridian_prior")

  spec <- model_spec(prior = p, max_lag = 4, media_effects_dist = "log_normal")
  expect_s3_class(spec, "meridian_model_spec")
})

test_that("meridian_model builds and samples the prior", {
  skip_if_no_meridian()
  df <- toy_df()
  input <- as_meridian_input(
    df,
    kpi = "kpi", geo = "geo", population = "population",
    media_spend = "tv_spend", media = "tv_impr", media_channels = "TV",
    controls = "price"
  )
  mmm <- meridian_model(input, model_spec(max_lag = 4))
  expect_s3_class(mmm, "meridian_model")
  expect_false("posterior" %in% model_groups(mmm))

  sample_prior(mmm, 20)
  expect_true("prior" %in% model_groups(mmm))
})
