test_that("as_meridian_input builds InputData with correct dimensions", {
  skip_if_no_meridian()
  df <- toy_df(n_geos = 2, n_weeks = 20)
  input <- as_meridian_input(
    df,
    kpi = "kpi", geo = "geo", population = "population",
    media_spend = "tv_spend", media = "tv_impr", media_channels = "TV",
    controls = "price"
  )
  expect_s3_class(input, "meridian_input_data")
  expect_equal(length(input_coord(input, "geo")), 2)
  expect_equal(length(input_coord(input, "time")), 20)
  expect_equal(input_coord(input, "media_channel"), "TV")
})

test_that("as_meridian_input errors on a missing column", {
  skip_if_no_meridian()
  df <- toy_df()
  expect_error(
    as_meridian_input(df, kpi = "nope", geo = "geo", population = "population"),
    "missing"
  )
})

test_that("the fluent builder produces an equivalent object", {
  skip_if_no_meridian()
  df <- toy_df()
  input <- input_data_builder("non_revenue") |>
    with_kpi(df, kpi_col = "kpi") |>
    with_population(df) |>
    with_media(df, media_cols = "tv_impr", media_spend_cols = "tv_spend", media_channels = "TV") |>
    build_input_data()
  expect_s3_class(input, "meridian_input_data")
  expect_equal(input_coord(input, "media_channel"), "TV")
})

test_that("national model synthesizes a single geo", {
  skip_if_no_meridian()
  set.seed(1)
  wk <- seq(as.Date("2021-01-04"), by = 7, length.out = 20)
  df <- data.frame(
    time = format(wk, "%Y-%m-%d"),
    kpi = runif(20, 200, 800),
    tv_spend = runif(20, 200, 1500),
    tv_impr = runif(20, 1e3, 8e3)
  )
  input <- as_meridian_input(
    df,
    kpi = "kpi", media_spend = "tv_spend", media = "tv_impr",
    media_channels = "TV", national = TRUE
  )
  expect_s3_class(input, "meridian_input_data")
  expect_equal(length(input_coord(input, "geo")), 1)
})
