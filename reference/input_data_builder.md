# Build Meridian input data with a fluent builder

`input_data_builder()` creates a Meridian `DataFrameInputDataBuilder`,
and the `with_*()` verbs add each data component from one or more R data
frames. Finish the chain with `build_input_data()`. This is the
flexible, pipe- friendly path; for the common case,
[`as_meridian_input()`](https://bdshaff.github.io/meridianR/reference/as_meridian_input.md)
wraps the whole chain in a single call.

## Usage

``` r
input_data_builder(
  kpi_type = c("non_revenue", "revenue"),
  geo = "geo",
  time = "time",
  media_time = time,
  population = "population",
  kpi = "kpi",
  revenue_per_kpi = "revenue_per_kpi"
)

with_kpi(builder, data, kpi_col = NULL, time_col = NULL, geo_col = NULL)

with_population(builder, data, population_col = NULL, geo_col = NULL)

with_controls(builder, data, control_cols, time_col = NULL, geo_col = NULL)

with_revenue_per_kpi(
  builder,
  data,
  revenue_per_kpi_col = NULL,
  time_col = NULL,
  geo_col = NULL
)

with_media(
  builder,
  data,
  media_cols,
  media_spend_cols,
  media_channels,
  time_col = NULL,
  geo_col = NULL
)

with_reach(
  builder,
  data,
  reach_cols,
  frequency_cols,
  rf_spend_cols,
  rf_channels,
  time_col = NULL,
  geo_col = NULL
)

with_organic_media(
  builder,
  data,
  organic_media_cols,
  organic_media_channels = NULL,
  media_time_col = NULL,
  geo_col = NULL
)

with_non_media_treatments(
  builder,
  data,
  non_media_treatment_cols,
  time_col = NULL,
  geo_col = NULL
)

build_input_data(builder)
```

## Arguments

- kpi_type:

  Either `"non_revenue"` or `"revenue"`.

- geo, time, media_time, population, kpi, revenue_per_kpi:

  Default column names the builder uses when a specific `*_col` argument
  is not supplied to a verb.

- builder:

  A `meridian_input_builder` from `input_data_builder()`.

- data:

  A data frame containing the referenced columns.

- kpi_col, time_col, geo_col, population_col, revenue_per_kpi_col,
  media_time_col:

  Optional column-name overrides; default to the builder's defaults.

- control_cols:

  Character vector of control-variable column names.

- media_cols:

  Character vector of media *execution* columns (e.g. impressions or
  clicks).

- media_spend_cols:

  Character vector of media *spend* columns, aligned with `media_cols`.

- media_channels:

  Character vector of channel names for the media.

- reach_cols, frequency_cols, rf_spend_cols:

  Character vectors of reach, average-frequency, and spend columns for
  reach-and-frequency channels.

- rf_channels:

  Character vector of channel names for the R&F channels.

- organic_media_cols:

  Character vector of organic-media execution columns.

- organic_media_channels:

  Optional channel names for organic media.

- non_media_treatment_cols:

  Character vector of non-media treatment columns (e.g. promotions,
  price changes).

## Value

`input_data_builder()` and every `with_*()` verb return a
`meridian_input_builder`. `build_input_data()` returns a
`meridian_input_data` object.

## Details

Each verb returns the (modified) builder, so calls compose with the
native pipe:

    input_data_builder("non_revenue") |>
      with_kpi(df) |>
      with_population(df) |>
      with_controls(df, control_cols = c("gqv", "competitor_sales")) |>
      with_media(df,
        media_cols       = c("tv_impressions", "search_clicks"),
        media_spend_cols = c("tv_spend", "search_spend"),
        media_channels   = c("TV", "Search")) |>
      build_input_data()

## See also

[`as_meridian_input()`](https://bdshaff.github.io/meridianR/reference/as_meridian_input.md)
for the one-call interface.
