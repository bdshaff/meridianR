# Skip a test unless the Meridian Python package can be imported.
skip_if_no_meridian <- function() {
  testthat::skip_on_cran()
  ok <- tryCatch(meridian_available(), error = function(e) FALSE)
  testthat::skip_if_not(isTRUE(ok), "Meridian Python package not available")
}

# A tiny fitted model, built once per test run and cached, for analysis tests.
.toy_cache <- new.env(parent = emptyenv())
fitted_toy_model <- function() {
  if (is.null(.toy_cache$mmm)) {
    input <- as_meridian_input(
      toy_df(n_geos = 2, n_weeks = 30),
      kpi = "kpi", geo = "geo", population = "population",
      media_spend = "tv_spend", media = "tv_impr", media_channels = "TV",
      controls = "price"
    )
    mmm <- meridian_model(input, model_spec(max_lag = 4))
    fit(mmm, prior_draws = 50, n_chains = 2, n_adapt = 50, n_burnin = 50, n_keep = 50, seed = 1)
    .toy_cache$mmm <- mmm
  }
  .toy_cache$mmm
}

# A small long-format toy data frame for geo-level tests.
toy_df <- function(n_geos = 2, n_weeks = 20, seed = 1) {
  set.seed(seed)
  geos <- LETTERS[seq_len(n_geos)]
  wk <- seq(as.Date("2021-01-04"), by = 7, length.out = n_weeks)
  df <- expand.grid(time = wk, geo = geos, stringsAsFactors = FALSE)
  n <- nrow(df)
  df$kpi <- runif(n, 200, 800)
  df$population <- rep(seq_len(n_geos) * 1e6, each = n_weeks)
  df$tv_impr <- runif(n, 1e3, 8e3)
  df$tv_spend <- runif(n, 200, 1500)
  df$price <- rnorm(n)
  df
}
